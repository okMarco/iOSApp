//
//  PostThumbnailOperationView.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/25.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrPostListViewController.h"

@class Post;

NS_ASSUME_NONNULL_BEGIN

@interface PostThumbnailOperationView : UIWindow

@property (nonatomic, weak) id<TumblrPostOperationDelegate> operationDelegate;

- (void)show:(Post *)post;

- (void)hide;
@end

NS_ASSUME_NONNULL_END
