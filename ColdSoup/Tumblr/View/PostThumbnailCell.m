//
//  PostThumbnailCell.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/25.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "PostThumbnailCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PostThumbnailCell()
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *videoPlayBtn;
@property (nonatomic, strong) UIImageView *likeIv;

@end

@implementation PostThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 3;
        [self.contentView.layer setMasksToBounds:YES];
    }
    return self;
}

- (NSMutableArray<UIImageView *> *)imageViews {
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.contentView addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    return _imageViews;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = ThumbnailTextFont;
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.backgroundColor = LightPlaceHolderColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];
        _textLabel.hidden = YES;
    }
    return _textLabel;
}

- (UIButton *)videoPlayBtn {
    if (!_videoPlayBtn) {
        _videoPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoPlayBtn setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateNormal];
        [self.contentView addSubview:_videoPlayBtn];
        _videoPlayBtn.hidden = YES;
    }
    return _videoPlayBtn;
}

- (UIImageView *)likeIv {
    if (!_likeIv) {
        _likeIv = [[UIImageView alloc] init];
        _likeIv.image = [UIImage imageNamed:@"ic_liked"];
        [self.contentView addSubview:_likeIv];
    }
    return _likeIv;
}

- (void)setPost:(Post *)post {
    if (_post) {
        [_post removeObserver:self forKeyPath:@"liked"];
    }
    if (!post) {
        return;
    }
    _post = post;
    [_post addObserver:self forKeyPath:@"liked" options:NSKeyValueObservingOptionNew context:nil];
    _textLabel.hidden = YES;
    _videoPlayBtn.hidden = YES;
    if ([post isKindOfClass:PhotoPost.class]) {
        PhotoPost *photoPost = (PhotoPost *)post;
        CGFloat y = 0;
        for (Photo *photo in photoPost.photos) {
            UIImageView *imageView = self.imageViews[[photoPost.photos indexOfObject:photo]];
            imageView.hidden = NO;
            NSString *url = photo.photoSizes[0].url;
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:LightPlaceHolderImage];
            CGFloat imageViewHeight = _cellWidth / photo.originalSize.width * photo.originalSize.height;
            imageView.frame = CGRectMake(0, y, _cellWidth, imageViewHeight);
            y += imageViewHeight;
        }
        for (int i = (int)photoPost.photos.count; i < _imageViews.count; i++) {
            _imageViews[i].hidden = YES;
        }
    }else if ([post isKindOfClass:VideoPost.class]) {
        self.videoPlayBtn.hidden = NO;
        [self.contentView bringSubviewToFront:self.videoPlayBtn];
        VideoPost *videoPost = (VideoPost *)post;
        UIImageView *imageView = self.imageViews[0];
        imageView.hidden = NO;
        CGFloat imageViewHeight = _cellWidth / videoPost.thumbnailWidth * videoPost.thumbnailHeight;
        imageView.frame = CGRectMake(0, 0, _cellWidth, imageViewHeight);
        [imageView sd_setImageWithURL:[NSURL URLWithString:videoPost.thumbnailUrl] placeholderImage:LightPlaceHolderImage];
        for (int i = 1; i< _imageViews.count; i++) {
            _imageViews[i].hidden = YES;
        }
    }else {
        NSString *displayContent = post.type.uppercaseString;
        if ([post isKindOfClass:TextPost.class]) {
            TextPost *textPost = (TextPost *)post;
            if (textPost.title.length) {
                displayContent = textPost.title;
            }
        }
        self.textLabel.hidden = NO;
        self.textLabel.text = displayContent;
        for (int i = 0; i < _imageViews.count; i++) {
            _imageViews[i].hidden = YES;
        }
    }
    
    self.likeIv.hidden = !_post.liked;
    [self.contentView bringSubviewToFront:self.likeIv];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"liked"]) {
        self.likeIv.hidden = !self.post.liked;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.videoPlayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.likeIv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView).offset(-6);
        make.width.height.equalTo(self.contentView.mas_width).multipliedBy(0.1);
    }];
    [super updateConstraints];
}

@end
