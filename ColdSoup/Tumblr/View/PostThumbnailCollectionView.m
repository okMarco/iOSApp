//
//  PostThumbnailCollectionView.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/25.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "PostThumbnailCollectionView.h"
#import "PostThumbnailCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "Post.h"
#import "PostThumbnailCellModel.h"
#import "PostThumbnailOperationView.h"

@interface PostThumbnailCollectionView()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout> {
    CGFloat _itemWidth;
}
@property (nonatomic, strong) PostThumbnailOperationView *operationView;
@end

@implementation PostThumbnailCollectionView

- (instancetype)init {
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.headerHeight = 0;
    layout.footerHeight = 0;
    layout.minimumColumnSpacing = CollectionViewGap;
    layout.minimumInteritemSpacing = CollectionViewGap;
    layout.columnCount = 3;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        
        _itemWidth = (ScreenWidth - CollectionViewGap * (layout.columnCount + 1)) / layout.columnCount;
        
        [self registerClass:PostThumbnailCell.class forCellWithReuseIdentifier:NSStringFromClass(PostThumbnailCell.class)];
        
        _postModelList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (PostThumbnailOperationView *)operationView {
    if (!_operationView) {
        _operationView = [[PostThumbnailOperationView alloc] init];
        _operationView.operationDelegate = _operationDelegate;
    }
    return _operationView;
}

- (void)refreshComplete:(NSArray *)results {
    NSMutableArray *newPostCellModels = [[NSMutableArray alloc] init];
    for (Post *post in results) {
        PostThumbnailCellModel *cellModel = [[PostThumbnailCellModel alloc] initWithPost:post cellWidth:_itemWidth];
        [newPostCellModels addObject:cellModel];
    }
    [self.postModelList insertObjects:newPostCellModels
                            atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newPostCellModels.count)]];
    [self reloadData];
}

- (void)loadMoreDataComplete:(NSArray *)results {
    for (Post *post in results) {
        PostThumbnailCellModel *cellModel = [[PostThumbnailCellModel alloc] initWithPost:post cellWidth:_itemWidth];
        [self.postModelList addObject:cellModel];
    }
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _postModelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PostThumbnailCell.class) forIndexPath:indexPath];
    cell.cellWidth = _itemWidth;
    cell.post = _postModelList[indexPath.row].post;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];
    longPress.minimumPressDuration = 0.8;
    [cell addGestureRecognizer:longPress];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.postModelList[indexPath.row].cellSize;
}

- (void)cellLongPressed:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];
    [self.operationView show:_postModelList[indexPath.row].post];
}
@end
