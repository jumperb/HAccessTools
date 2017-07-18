//
//  PCommodity.h
//  PenYou
//
//  Created by zhangchutian on 16/9/19.
//  Copyright © 2016年 pinguo. All rights reserved.
//

#import <HAccess/HDeserializableObject.h>
#import "PCommodityDefines.h"

@interface PMiniCommodity : HDeserializableObject
@property (nonatomic) NSString *cid;
@property (nonatomic) NSString *img;
@property (nonatomic) NSString *title;
@property (nonatomic) long price;
@property (nonatomic) PShippingType shipping_type;
- (NSString *)priceString;
@end
