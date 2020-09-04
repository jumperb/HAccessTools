//
//  ViewController.m
//  HAccessTools
//
//  Created by zct on 2017/5/8.
//  Copyright © 2017年 zct. All rights reserved.
//

#import "ViewController.h"
#import "TestMocker.h"
#import "PFeedDAO.h"
#import <NSObject+ext.h>
#import "HNetworkLogHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMenu:@"自动mock" callback:^(id sender, id data) {
        PFeedDAO *dao = [PFeedDAO new];
        dao.enableAutoMock = YES;
        dao.timeline = 0;
        dao.timeType = 1;
        [dao start:^(id sender, id data, NSError *error) {
            NSLog(@"%@ %@", data, [data jsonString]);
        }];
    }];
    
    [self addMenu:@"自定义自动mock" callback:^(id sender, id data) {
        PFeedDAO *dao = [PFeedDAO new];
        dao.autoMocker = [TestMocker shared];
        dao.enableAutoMock = YES;
        dao.timeline = 0;
        dao.timeType = 1;
        [dao start:^(id sender, id data, NSError *error) {
            NSLog(@"%@ %@", data, [data jsonString]);
        }];
    }];
    
    [HNetworkLogHelper enable];
    
    [self addMenu:@"产生日志" callback:^(id sender, id data) {
        PFeedDAO *dao = [PFeedDAO new];
        dao.timeline = 0;
        dao.timeType = 1;
        dao.isMock = NO;
        [dao start:^(id sender, id data, NSError *error) {
            NSLog(@"%@ %@", data, [data jsonString]);
        }];
    }];
    
    [self addMenu:@"获取日志" callback:^(id sender, id data) {
        [HNetworkLogHelper showLog];
    }];
    
    [self addMenu:@"清除日志" callback:^(id sender, id data) {
        [HNetworkLogHelper clear];
    }];
}

@end
