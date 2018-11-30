//
//  TumblrApi.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Post;

extern NSString *const TumblrApiConsumer;
extern NSString *const TumblrApiConsumerSecret;

extern NSString *const TumblrApiOAuthTokenKey;
extern NSString *const TumblrApiOAuthTokenSecretKey;


NS_ASSUME_NONNULL_BEGIN

@interface TumblrApi : NSObject

+ (instancetype)shareApi;

- (void)userInfo;

- (void)dashboard:(NSUInteger)sinceId offset:(NSInteger)offset completionBlock:(void(^)(NSArray * _Nullable posts, NSError * _Nullable error))completionBlock;

- (void)likes:(NSInteger)beforeId after:(NSInteger)afterId completionBlock:(void (^)(NSArray * _Nullable posts, NSError * _Nullable error))completionBlock;

- (void)likePost:(Post *)post completionBlock:(void(^)(BOOL success))completionBlock;

- (void)unlikePost:(Post *)post completionBlock:(void(^)(BOOL success))completionBlock;

- (void)repost:(Post *)post completionBlock:(void (^)(BOOL))completionBlock;

+ (NSString *)getBlogAvatarUrl:(NSString *)blogName size:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
