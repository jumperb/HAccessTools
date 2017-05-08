//
//  PCategoryGuidItem.h
//  PenYou
//
//  Created by zhangchutian on 2017/3/24.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import <HAccess/HDeserializableObject.h>

@interface PCategoryGuidItem : HDeserializableObject
@property (nonatomic) NSString *category_id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *image;
@property (nonatomic) long price;
- (NSString *)priceString;
@end
