//
//  PostThumbnailCell.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/25.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostThumbnailCell : UICollectionViewCell
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, strong) Post *post;
@end

NS_ASSUME_NONNULL_END
