//
//  HNetworkDAO+AutoMock.h
//  HAccessTools
//
//  Created by zct on 2020/9/4.
//  Copyright © 2020 zct. All rights reserved.
//

#import <HAccess/HNetworkDAO.h>

NS_ASSUME_NONNULL_BEGIN
@class HNetworkAutoMock;
@interface HNetworkDAO (AutoMock)
@property (nonatomic) BOOL enableAutoMock;
@property (nonatomic) HNetworkAutoMock* autoMocker;
@end


// 自动mocker,写完demo就可以调试了，不用去写mock文件，更不用等服务端开发
// 其中图片用的unsplash.it的
// 项目中可以这样来适配图片大小
//        if ([url containsString:@"unsplash.it"])
//        {
//            NSRange range = [url rangeOfString:@"image="];
//            url = [NSString stringWithFormat:@"https://unsplash.it/%d/%d?%@",(int)w,(int)w, [url substringFromIndex:range.location]];
//            return url;
//        }
//

//注意，以下注解仅仅对字符串类型的属性有效
#define HPMockAsImage @"HPMockAsImage"
#define HPMockAsUserName @"HPMockAsUserName"
#define HPMockAsTitle @"HPMockAsTitle"
#define HPMockAsDesc @"HPMockAsDesc"
#define HPMockAsNumber @"HPMockAsNumber"
#define HPMockAsURL @"HPMockAsURL"

//这个对数字和字符串均有效
#define HPMockAsDate @"HPMockAsDate"

@interface HNetworkAutoMock : NSObject

//下列参数填写方式参考.m里面的默认值
@property (nonatomic) NSArray *imageKeywords;
@property (nonatomic) NSArray *userNameKeyWords;
@property (nonatomic) NSArray *titleKeyWords;
@property (nonatomic) NSArray *descKeyWords;
@property (nonatomic) NSArray *numberKeyWords;
@property (nonatomic) NSArray *urlKeyWords;
@property (nonatomic) NSArray *dateKeyWords;


@property (nonatomic) int minNumber;
@property (nonatomic) int maxNumber;
@property (nonatomic) int minListCount;
@property (nonatomic) int maxListCount;
@property (nonatomic) NSString *textSeed;
@property (nonatomic) NSArray *urlSeed;
@property (nonatomic) NSDictionary *baseformat;

+ (instancetype)shared;


#pragma mark - Protected
//这里面决定各种关键字长度，可以按需求直接覆盖
- (id)mockStringOfPPName:(NSString *)name mockAs:(NSString *)mockAs;
//这里面决定不定number的值域，可以按需求直接覆盖
- (id)mockNumberOfPPname:(NSString *)name typeCode:(char)typeCode from:(NSNumber *)from to:(NSNumber *)to mockAs:(NSString *)mockAs;
//判断关键字命中
- (BOOL)isPPname:(NSString *)ppanme containKeyWords:(NSArray *)keywords;
@end
NS_ASSUME_NONNULL_END
