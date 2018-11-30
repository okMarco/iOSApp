//
//  Post.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blog.h"

extern NSString *const PostTypePhoto;
extern NSString *const PostTypeVideo;
extern NSString *const PostTypeText;

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject
@property (nonatomic, assign) NSUInteger postId;
@property (nonatomic, strong) Blog *blog;
@property (nonatomic, copy) NSString *blogName;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, assign) NSInteger noteCount;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *reblogKey;

@end

@interface PhotoSize : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@interface Photo : NSObject
@property (nonatomic, strong) NSArray<PhotoSize *> *photoSizes;
@property (nonatomic, strong) PhotoSize *originalSize;
@property (nonatomic, copy) NSString *caption;
@end



@interface PhotoPost : Post
@property (nonatomic, strong) NSArray<Photo *> *photos;
@end

@interface VideoPost : Post
@property (nonatomic, copy) NSString *video_type;
@property (nonatomic, copy) NSString *video_url;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, assign) NSInteger thumbnailWidth;
@property (nonatomic, assign) NSInteger thumbnailHeight;
@end

@interface TextPost : Post
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
