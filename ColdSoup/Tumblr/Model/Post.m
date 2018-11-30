//
//  Post.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "Post.h"

NSString *const PostTypePhoto = @"photo";
NSString *const PostTypeVideo = @"video";
NSString *const PostTypeText = @"text";

@implementation Post
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"postId" : @"id",
             @"blogName" : @"blog_name",
             @"noteCount" : @"note_count",
             @"reblogKey" : @"reblog_key"};
}
@end

@implementation PhotoSize

@end

@implementation Photo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"photoSizes" : @"alt_sizes",
             @"originalSize" : @"original_size"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"photoSizes" : [PhotoSize class]};
}

@end

@implementation PhotoPost

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"photos" : [Photo class]};
}

@end

@implementation VideoPost

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"videoType" : @"video_type",
             @"videoUrl" : @"video_url",
             @"thumbnailUrl" : @"thumbnail_url",
             @"thumbnailWidth" : @"thumbnail_width",
             @"thumbnailHeight" : @"thumbnail_height"
             };
}

@end

@implementation TextPost

@end
