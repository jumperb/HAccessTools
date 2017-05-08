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
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *image_width;
@property (nonatomic) NSString *image_height;
@property (nonatomic) long favorite_count;
@property (nonatomic) long browse_count;
@property (nonatomic) NSString *authorId;
@property (nonatomic) NSString *author_name;
@property (nonatomic) NSString *author_icon;

@property (nonatomic) long long server_modified;
@property (nonatomic) long long server_created;
@end
