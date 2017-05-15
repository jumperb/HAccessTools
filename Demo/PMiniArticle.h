//
//  PMiniArticle.h
//  PenYou
//
//  Created by zhangchutian on 2017/3/24.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import <HAccess/HDeserializableObject.h>

@interface PMiniArticle : HDeserializableObject
@property (nonatomic) NSString *server_id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *articleImage;
@property (nonatomic) int imageWidth;
@property (nonatomic) int imageHeight;
@property (nonatomic) long favoriteCount;
@property (nonatomic) long browseCount;
@property (nonatomic) NSString *authorId;
@property (nonatomic) NSString *authorName;
@property (nonatomic) NSString *authorIcon;

@property (nonatomic) long long server_modified;
@property (nonatomic) long long server_created;
@end
