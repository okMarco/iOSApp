//
//  PostListViewController.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "TumblrPostListViewController.h"
#import "PostThumbnailCollectionView.h"
#import "MJRefresh.h"
#import "Post.h"
#import "PostThumbnailCellModel.h"
#import "JDStatusBarNotification.h"
#import "AppUIManager.h"
#import "ColdSoupRefreshHeader.h"
#import "ColdSoupRefreshFooter.h"
#import "TumblrBlogViewController.h"
#import "TumblrLikesViewController.h"

@interface TumblrPostListViewController ()<TumblrPostOperationDelegate>
@property (nonatomic, strong) PostThumbnailCollectionView *thumbnailCollectionView;
@end

@implementation TumblrPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self thumbnailCollectionView];
    [self.thumbnailCollectionView.mj_header beginRefreshing];
}

- (PostThumbnailCollectionView *)thumbnailCollectionView {
    if (!_thumbnailCollectionView) {
        _thumbnailCollectionView = [[PostThumbnailCollectionView alloc] init];
        WeakSelf(weakSelf);
        _thumbnailCollectionView.mj_header = [ColdSoupRefreshHeader headerWithRefreshingBlock:^{
            StrongSelf(strongSelf);
            NSUInteger sinceId = 0;
            if (strongSelf.thumbnailCollectionView.postModelList.count) {
                sinceId = strongSelf.thumbnailCollectionView.postModelList[0].post.postId;
            }
            [strongSelf refreshData:sinceId];
        }];
        _thumbnailCollectionView.mj_footer = [ColdSoupRefreshFooter footerWithRefreshingBlock:^{
            StrongSelf(strongSelf);
            [strongSelf loadMoreData:strongSelf.thumbnailCollectionView.postModelList.count];
        }];
        _thumbnailCollectionView.mj_footer.hidden = YES;
        _thumbnailCollectionView.operationDelegate = self;
        [self.view addSubview:_thumbnailCollectionView];
        [_thumbnailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _thumbnailCollectionView;
}

- (void)setUpRefreshHeaderAndFooter:(UIScrollView *)scrollView {
    
}

- (void)refreshData:(NSUInteger)sinceId {
    
}

- (void)loadMoreData:(NSInteger)offset {
    
}

- (void)refreshComplete:(NSArray *)results error:(NSError *)error {
    [self.thumbnailCollectionView.mj_header endRefreshing];
    [self.thumbnailCollectionView refreshComplete:results];
    self.thumbnailCollectionView.mj_footer.hidden = NO;
}

- (void)loadMoreDataComplete:(NSArray *)results error:(NSError *)error {
    [self.thumbnailCollectionView.mj_footer endRefreshing];
    [self.thumbnailCollectionView loadMoreDataComplete:results];
}

- (void)like:(Post *)post {
    [[TumblrApi shareApi] likePost:post completionBlock:^(BOOL success) {
        if (success) {
            post.liked = YES;
        }
    }];
}

- (void)unlike:(Post *)post {
    [[TumblrApi shareApi] unlikePost:post completionBlock:^(BOOL success) {
        if (success) {
            post.liked = NO;
        }
    }];
}

- (void)repost:(Post *)post {
    [[TumblrApi shareApi] repost:post completionBlock:^(BOOL success) {
        if (success) {
            [JDStatusBarNotification showWithStatus:@"转发成功" dismissAfter:1.5 styleName:JDStatusBarStyleTumblrSuccess];
        }
    }];
}

- (void)blog:(NSString *)blogName {
    if (!blogName.length) {
        return;
    }
    TumblrLikesViewController *likeVC = [[TumblrLikesViewController alloc] init];
    //TumblrBlogViewController *blogVC = [[TumblrBlogViewController alloc] init];
    [self.navigationController pushViewController:likeVC animated:YES];
}
@end
