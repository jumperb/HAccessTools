//
//  PCommodity.m
//  PenYou
//
//  Created by zhangchutian on 16/9/19.
//  Copyright © 2016年 pinguo. All rights reserved.
//

#import "PMiniCommodity.h"

@implementation PMiniCommodity
ppx(cid, HPMapto(@"id"))
ppx(shipping_type, HPScope(PShippingTypeFree, PShippingTypeConsult))
- (NSString *)priceString
{
    return [NSString stringWithFormat:@"￥%.2f", _price*1.0/100];
}
@end
