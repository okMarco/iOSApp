//
//  PostThumbnailCellModel.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/25.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "PostThumbnailCellModel.h"
#import "Post.h"

@implementation PostThumbnailCellModel

- (instancetype)initWithPost:(Post *)post cellWidth:(CGFloat)cellWidth {
    self = [super init];
    if (self) {
        self.cellWidth = cellWidth;
        self.post = post;
    }
    return self;
}

- (void)setPost:(Post *)post {
    _post = post;
    
    CGFloat itemHeight = 0;
    if ([post isKindOfClass:PhotoPost.class]) {
        PhotoPost *photoPost = (PhotoPost *)post;
        for (Photo *photo in photoPost.photos) {
            CGFloat photoViewHeight = _cellWidth / photo.originalSize.width * photo.originalSize.height;
            itemHeight += photoViewHeight;
        }
    }else if ([post isKindOfClass:VideoPost.class]) {
        VideoPost *videoPost = (VideoPost *)post;
        itemHeight = _cellWidth / videoPost.thumbnailWidth * videoPost.thumbnailHeight;
    }else if ([post isKindOfClass:TextPost.class]){
        TextPost *textPost = (TextPost *)post;
        NSString *displayContent = textPost.title;
        if (!displayContent.length) {
            displayContent = textPost.type.uppercaseString;
        }
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        itemHeight = [displayContent boundingRectWithSize:CGSizeMake(_cellWidth - 20, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName : ThumbnailTextFont} context:nil].size.height + 20;
    }
    _cellSize = CGSizeMake(_cellWidth, itemHeight);
}

@end
