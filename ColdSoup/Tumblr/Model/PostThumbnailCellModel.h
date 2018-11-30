//
//  PostThumbnailCellModel.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/25.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Post;

NS_ASSUME_NONNULL_BEGIN

@interface PostThumbnailCellModel : NSObject
@property (nonatomic, strong) Post *post;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGSize cellSize;

- (instancetype)initWithPost:(Post *)post cellWidth:(CGFloat)cellWidth;
@end

NS_ASSUME_NONNULL_END
