//
//  PFeedDAO.m
//  PenYou
//
//  Created by zhangchutian on 2017/3/26.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import "PFeedDAO.h"

@implementation PFeedDAO

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURL = @"https://test.com";
        self.pathURL = @"testpath";
        self.deserializer = [HNEntityDeserializer deserializerWithClass:[PFeedRes class]];
        self.isMock = YES;
    }
    return self;
}
@end


@implementation PFeedRes
ppx(banner, HPOptional, HPInnerType([PBannerItem class]));
ppx(banner_md5, HPOptional)
ppx(cate_guid, HPOptional, HPInnerType([PCategoryGuidItem class]))
ppx(cate_guid_md5, HPOptional)
ppx(list, HPDivideType(@"content_type", @(0), [PMiddleCommodity class], @(1), [PMiniArticle class]))
@end
