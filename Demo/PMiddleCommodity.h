//
//  PMiddleCommodity.h
//  PenYou
//
//  Created by zhangchutian on 2017/3/24.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMiniCommodity.h"

@interface PMiddleCommodity : PMiniCommodity
@property (nonatomic) NSString *seller_name;
@property (nonatomic) NSString *origin_place;
@property (nonatomic) long long server_modified;
@end

