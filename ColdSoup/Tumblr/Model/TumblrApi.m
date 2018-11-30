//
//  TumblrApi.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "TumblrApi.h"
#import <TMTumblrSDK/TMOAuthAuthenticator.h>
#import <TMTumblrSDK/TMURLSession.h>
#import <TMTumblrSDK/TMHTTPRequest.h>
#import <TMTumblrSDK/TMOAuth.h>
#import "TMAPIClient.h"
#import "TMRequestFactory.h"
#import "TMBasicBaseURLDeterminer.h"
#import "YYModel.h"
#import "Post.h"
#import "TumblrUser.h"

NSString *const TumblrApiConsumer = @"7heCKuKOlE9ogNpYnv0tebQuczJvjzYqJsSVq7TwqUwZZ27yzr";
NSString *const TumblrApiConsumerSecret = @"ES8dYCiqhOCH3DhxL45Pq4UJ0wLbKKDWxKVKR9jTZVrkkN1sAx";

NSString *const TumblrApiOAuthTokenKey = @"OAuthTokenKey";
NSString *const TumblrApiOAuthTokenSecretKey = @"OAuthTokenSecret";

NSString *const TumblrApiCurrentUserKey = @"CurrentUserKey";

@interface TumblrApi()
@property (nonatomic, strong) TMURLSession *session;
@property (nonatomic, strong) TMAPIClient *client;
@property (nonatomic, strong) TumblrUser *user;

@end

@implementation TumblrApi

+ (instancetype)shareApi {
    static TumblrApi *tumblrApi;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tumblrApi = [[TumblrApi alloc] init];
    });
    return tumblrApi;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        TMAPIApplicationCredentials *applicationCredentials = [[TMAPIApplicationCredentials alloc] initWithConsumerKey:TumblrApiConsumer consumerSecret:TumblrApiConsumerSecret];
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TumblrApiOAuthTokenKey];
        NSString *tokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:TumblrApiOAuthTokenSecretKey];
        _user = [TumblrUser yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] valueForKey:TumblrApiCurrentUserKey]];
        self.session = [[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                            applicationCredentials:applicationCredentials
                                                   userCredentials:[[TMAPIUserCredentials alloc] initWithToken:token tokenSecret:tokenSecret]];
        TMRequestFactory *requestFactory = [[TMRequestFactory alloc] initWithBaseURLDeterminer:[[TMBasicBaseURLDeterminer alloc] init]];
        _client = [[TMAPIClient alloc] initWithSession:self.session requestFactory:requestFactory];
    }
    return self;
}

- (NSArray *)getPostListFromResponse:(NSArray *)posts {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (id post in posts) {
        NSString *type = [post valueForKey:@"type"];
        if ([type isEqualToString:PostTypePhoto]) {
            PhotoPost *photoPost = [PhotoPost yy_modelWithJSON:post];
            [results addObject:photoPost];
        }else if ([type isEqualToString:PostTypeVideo]) {
            VideoPost *videoPost = [VideoPost yy_modelWithJSON:post];
            [results addObject:videoPost];
        }else if ([type isEqualToString:PostTypeText]) {
            TextPost *textPost = [TextPost yy_modelWithJSON:post];
            [results addObject:textPost];
        }
    }
    return results;
}

- (void)userInfo {
    WeakSelf(weakSelf);
    [[self.client userInfoDataTaskWithCallback:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        StrongSelf(strongSelf);
        if (!error) {
            strongSelf.user = [TumblrUser yy_modelWithJSON:[response valueForKey:@"user"]];
            [[NSUserDefaults standardUserDefaults] setObject:[strongSelf.user yy_modelToJSONData] forKey:TumblrApiCurrentUserKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }] resume];
}

- (void)dashboard:(NSUInteger)sinceId offset:(NSInteger)offset completionBlock:(void (^)(NSArray * _Nullable, NSError * _Nullable))completionBlock {
    NSMutableDictionary *params = @{}.mutableCopy;
    if (sinceId > 0) {
        [params setObject:[NSNumber numberWithUnsignedInteger:sinceId] forKey:@"since_id"];
    }
    if (offset > 0) {
        [params setObject:[NSNumber numberWithInteger:offset] forKey:@"offset"];
    }
    [[self.client dashboardRequest:params callback:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (completionBlock) {
                completionBlock([self getPostListFromResponse:[response valueForKey:@"posts"]], nil);
            }
        }else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }] resume];
}

- (void)likes:(NSInteger)beforeId after:(NSInteger)afterId completionBlock:(void (^)(NSArray * _Nullable, NSError * _Nullable))completionBlock{
    NSMutableDictionary *params = @{}.mutableCopy;
    if (afterId > 0) {
        [params setObject:[NSNumber numberWithInteger:afterId] forKey:@"after"];
    }
    if (beforeId > 0) {
        [params setObject:[NSNumber numberWithInteger:beforeId] forKey:@"before"];
    }
    [[self.client likesDataTaskWithParameters:params callback:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (completionBlock) {
                completionBlock([self getPostListFromResponse:[response valueForKey:@"liked_posts"]], nil);
            }
        }else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }] resume];
}

- (void)likePost:(Post *)post completionBlock:(void (^)(BOOL))completionBlock {
    if (!post) {
        return;
    }
    [[self.session taskWithRequest:[self.client.requestFactory likeRequest:[NSString stringWithFormat:@"%lu", (unsigned long)post.postId] reblogKey:post.reblogKey] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(!error);
            });        }
    }] resume];
}

- (void)unlikePost:(Post *)post completionBlock:(void (^)(BOOL))completionBlock {
    if (!post) {
        return;
    }
    [[self.session taskWithRequest:[self.client.requestFactory unlikeRequest:[NSString stringWithFormat:@"%lu", (unsigned long)post.postId] reblogKey:post.reblogKey] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(!error);
            });
        }
    }] resume];
}

- (void)repost:(Post *)post completionBlock:(void (^)(BOOL))completionBlock {
    if (!post) {
        return;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSString stringWithFormat:@"%lu", (unsigned long)post.postId] forKey:@"id"];
    [params setObject:post.reblogKey forKey:@"reblog_key"];
    [[self.session taskWithRequest:[self.client.requestFactory reblogPostRequestWithBlogName:[NSString stringWithFormat:@"%@.tumblr.com", _user.name] parameters:params] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(!error);
            });
        }
    }] resume];
}

+ (NSString *)getBlogAvatarUrl:(NSString *)blogName size:(NSInteger)size{
    return [NSString stringWithFormat:@"https://api.tumblr.com/v2/blog/%@.tumblr.com/avatar/%d", blogName, (int)size];
}
@end
