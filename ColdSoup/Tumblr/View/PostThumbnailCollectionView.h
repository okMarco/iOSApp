//
//  PostThumbnailCollectionView.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/25.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TumblrPostListViewController.h"

@class PostThumbnailCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface PostThumbnailCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray<PostThumbnailCellModel *> *postModelList;
@property (nonatomic, weak) id<TumblrPostOperationDelegate> operationDelegate;


- (void)refreshComplete:(NSArray *)results;

- (void)loadMoreDataComplete:(NSArray *)results;

@end

NS_ASSUME_NONNULL_END
