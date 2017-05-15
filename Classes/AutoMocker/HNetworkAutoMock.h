//
//  HNetworkAutoMock.h
//  PenYou
//
//  Created by zhangchutian on 2017/3/31.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import <Foundation/Foundation.h>
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
@interface HNetworkAutoMock : NSObject

//下列参数填写方式参考.m里面的默认值
@property (nonatomic) NSArray *imageKeywords;
@property (nonatomic) NSArray *userNameKeyWords;
@property (nonatomic) NSArray *titleKeyWords;
@property (nonatomic) NSArray *descKeyWords;
@property (nonatomic) NSArray *numberKeyWords;
@property (nonatomic) NSArray *urlKeyWords;


@property (nonatomic) int minNumber;
@property (nonatomic) int maxNumber;
@property (nonatomic) int minListCount;
@property (nonatomic) int maxListCount;
@property (nonatomic) NSString *textSeed;
@property (nonatomic) NSArray *urlSeed;
@property (nonatomic) NSDictionary *baseformat;

+ (instancetype)shared;
- (void)enable;
- (void)disable;


//这里面决定各种关键字长度，可以按需求直接覆盖
- (id)mockStringOfPPName:(NSString *)name;
//这里面决定不定number的值域，可以按需求直接覆盖
- (id)mockNumberOfPPname:(NSString *)name typeCode:(char)typeCode;

//判断关键字命中
- (BOOL)isPPname:(NSString *)ppanme containKeyWords:(NSArray *)keywords;
@end
