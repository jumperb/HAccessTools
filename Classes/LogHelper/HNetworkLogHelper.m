//
//  HNetworkLogHelper.m
//  HAccessTools
//
//  Created by zct on 2017/5/8.
//  Copyright © 2017年 zct. All rights reserved.
//

#import "HNetworkLogHelper.h"
#import <NSFileManager+ext.h>
#import <UIKit/UIKit.h>
#import <UIApplication+ext.h>

@interface HNetworkLogHelper () <UIDocumentInteractionControllerDelegate>
@property (nonatomic) dispatch_queue_t ioQueue;
@property (nonatomic) BOOL enabled;
@end

@implementation HNetworkLogHelper

+ (instancetype)shared
{
    static dispatch_once_t pred;
    static HNetworkLogHelper *o = nil;
    
    dispatch_once(&pred, ^{ o = [[self alloc] init]; });
    return o;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("com.HAccess.HNetworkLogHelper", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
+ (NSString *)logPath
{
    return [NSFileManager tempPath:@"h_network_error_log.txt"];
}
+ (void)clear
{
    [[NSFileManager defaultManager] removeItemAtPath:[self logPath] error:nil];
}

+ (void)enable
{
    [HNetworkLogHelper shared].enabled = YES;
}
+ (void)disable
{
    [HNetworkLogHelper shared].enabled = NO;
}
- (void)logToFile:(NSString *)log
{
    NSString *text = [log stringByAppendingString:@"\n"];
    static NSString *filePath = nil;
    if (!filePath)
    {
        filePath = [HNetworkLogHelper logPath];
    }
    
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (!isExit)
    {
        NSLog(@"创建log:%@", filePath);
        [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return ;
    }
    
    NSFileHandle  *outFile;
    NSData *buffer;
    
    outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    
    if(outFile == nil)
    {
        NSLog(@"文件打开失败");
    }
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    
    //读取inFile并且将其内容写到outFile中
    NSString *bs = [NSString stringWithFormat:@"%@",text];
    buffer = [bs dataUsingEncoding:NSUTF8StringEncoding];
    
    [outFile writeData:buffer];
    
    //关闭读写文件
    [outFile closeFile];
}

+ (void)showLog
{
    [[self shared] showLog];
}
- (void)showLog
{
    UIDocumentInteractionController *di = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[HNetworkLogHelper logPath]]];
    di.delegate = self;
    di.UTI = @"public.text";
    [di presentPreviewAnimated:YES];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return [UIApplication naviTop];
}
@end

#import <HNetworkDAO.h>
#import <NSObject+ext.h>

@interface HNetworkDAO ()
- (NSString *)fullurl;
@end

@interface HNetworkDAO (LogHelper)
@property (nonatomic) NSString *paramString;
@end

#import <objc/runtime.h>

@implementation HNetworkDAO (LogHelper)

@dynamic paramString;
static const void *paramStringAddress = &paramStringAddress;
- (NSString *)paramString
{
    return objc_getAssociatedObject(self, paramStringAddress);
}

- (void)setParamString:(NSString *)paramString
{
    objc_setAssociatedObject(self, paramStringAddress, paramString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load
{
    [NSObject methodSwizzleWithClass:self origSEL:@selector(requestFinishedFailureWithError:) overrideSEL:@selector(log_requestFinishedFailureWithError:)];
    [NSObject methodSwizzleWithClass:self origSEL:@selector(setupParams) overrideSEL:@selector(log_setupParams)];
}
- (id)log_setupParams
{
    NSDictionary *parametersDict = [self log_setupParams];
    NSMutableString *paramString = [NSMutableString new];
    for (NSString *key in parametersDict)
    {
        id value = parametersDict[key];
        if ([value isKindOfClass:[HNetworkMultiDataObj class]]) continue;
        if (paramString.length > 0) [paramString appendFormat:@"&"];
        [paramString appendFormat:@"%@=%@", key, [value stringValue]];
    }
    self.paramString = paramString;
    return parametersDict;
}
- (void)log_requestFinishedFailureWithError:(NSError *)error
{
    [self log_requestFinishedFailureWithError:error];
    if (![HNetworkLogHelper shared].enabled) return;
    dispatch_async([HNetworkLogHelper shared].ioQueue, ^{
        NSMutableString *str = [NSMutableString new];
        [str appendFormat:@"网络错误:%@\n", error.localizedDescription];
        [str appendFormat:@"原始数据:\n"];
        [str appendFormat:@"%@ %@\n\n",self.method, [self fullurl]];
        [str appendFormat:@"Param: %@\n\n", self.paramString];
        [str appendFormat:@"Response: %@\n\n", [self responseString]];
        [[HNetworkLogHelper shared] logToFile:str];
    });
}
- (NSString *)responseString
{
    return [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
}

@end
