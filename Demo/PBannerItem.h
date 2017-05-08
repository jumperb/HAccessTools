//
//  PBannerItem.h
//  PenYou
//
//  Created by zhangchutian on 2017/3/24.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import <HAccess/HDeserializableObject.h>

@interface PBannerItem : HDeserializableObject
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *gotoURL; //例如 zhihua://article?id=15123125 或者 zhihua://commodity?id=346345346
@end

