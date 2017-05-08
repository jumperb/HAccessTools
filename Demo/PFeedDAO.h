//
//  PFeedDAO.h
//  PenYou
//
//  Created by zhangchutian on 2017/3/26.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import <HNetworkDAO.h>

@interface PFeedDAO : HNetworkDAO
@property (nonatomic) long long timeline;
@property (nonatomic) BOOL timeType; //朝时间点的哪个方向查 1(之后)|2(之前)
@end

#import "PBannerItem.h"
#import "PCategoryGuidItem.h"
#import "PMiddleCommodity.h"
#import "PMiniArticle.h"

@interface PFeedRes : HDeserializableObject
@property (nonatomic) NSArray<PBannerItem *> *banner;
@property (nonatomic) NSString *banner_md5;
@property (nonatomic) NSArray<PCategoryGuidItem *> *cate_guid;
@property (nonatomic) NSString *cate_guid_md5;
@property (nonatomic) NSArray *list;
@end
