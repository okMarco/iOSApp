//
//  PostListViewController.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrApi.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TumblrPostOperationDelegate <NSObject>

- (void)like:(Post *)post;

- (void)unlike:(Post *)post;

- (void)repost:(Post *)post;

- (void)blog:(NSString *)blogName;

@end

@interface TumblrPostListViewController : UIViewController

- (void)refreshData:(NSUInteger)sinceId;

- (void)refreshComplete:(NSArray *)results error:(NSError *)error;

- (void)loadMoreData:(NSInteger)offset;

- (void)loadMoreDataComplete:(NSArray *)results error:(NSError *)error;


@end

NS_ASSUME_NONNULL_END
