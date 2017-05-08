//
//  PCategoryGuidItem.m
//  PenYou
//
//  Created by zhangchutian on 2017/3/24.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import "PCategoryGuidItem.h"

@implementation PCategoryGuidItem
- (NSString *)priceString
{
    return [NSString stringWithFormat:@"￥%.2f", _price*1.0/100];
}
@end
