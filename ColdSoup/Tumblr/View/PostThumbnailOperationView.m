//
//  PostThumbnailOperationView.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/25.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "PostThumbnailOperationView.h"
#import "HOBaseTableViewCell.h"
#import "Post.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TumblrApi.h"
#import "TumblrBlogViewController.h"

@interface OperationCell : HOBaseTableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) BOOL isBlog;

@end

@implementation OperationCell

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.subTitleLabel]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = 5;
        _stackView.distribution = UIStackViewDistributionFill;
        [self.contentView addSubview:_stackView];
    }
    return _stackView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ContentTextFont;
        _titleLabel.textColor = ContentTextColor;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = SubContentTextFont;
        _subTitleLabel.textColor = SubContentTextColor;
    }
    return _subTitleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 5;
        [_iconImageView.layer setMasksToBounds:YES];
        [_iconImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_iconImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (void)setIsBlog:(BOOL)isBlog {
    _isBlog = isBlog;
    self.subTitleLabel.hidden = !isBlog;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.isBlog ? 12.5 : 15);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(self.isBlog ? 30 : 25);
    }];
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    [super updateConstraints];
}

@end

@interface PostThumbnailOperationView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *iconNames;

@property (nonatomic, weak) Post *currentPost;

@end

@implementation PostThumbnailOperationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _titles = @[@"帖子", @"喜欢", @"转发", @"保存原图"];
        _iconNames = @[@"ic_link", @"ic_like", @"ic_repost", @"ic_download"];
        self.backgroundColor = [UIColor clearColor];
        [self contentView];
        [self tableView];
    }
    return self;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tap.numberOfTouchesRequired = tap.numberOfTapsRequired = 1;
        [_contentView addGestureRecognizer:tap];
        [self addSubview:_contentView];
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _contentView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 55;
        [_tableView registerClass:OperationCell.class forCellReuseIdentifier:NSStringFromClass(OperationCell.class)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;

        _tableView.layer.cornerRadius = 8;
        [_tableView.layer setMasksToBounds:YES];
        
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.top.equalTo(self.mas_bottom);
            make.height.mas_equalTo(55 * 5 + 30 + SafeAreaBottom);
        }];
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 4 ? 70 : 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OperationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(OperationCell.class)];
    if (!cell) {
        cell = [[OperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(OperationCell.class)];
    }
    switch (indexPath.row) {
        case 0:
        case 2:
        case 3: {
            cell.iconImageView.image = [UIImage imageNamed:_iconNames[indexPath.row]];
            cell.titleLabel.text = _titles[indexPath.row];
            cell.subTitleLabel.hidden = YES;
            break;
        }
        case 1: {
            NSString *imageName;
            if (_currentPost.liked) {
                imageName = @"ic_liked";
                cell.titleLabel.text = @"取消喜欢";
            }else {
                imageName = @"ic_like";
                cell.titleLabel.text = _titles[indexPath.row];
            }
            cell.iconImageView.image = [UIImage imageNamed:imageName];
            cell.subTitleLabel.hidden = YES;
            break;
        }
        case 4: {
            cell.isBlog = YES;
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[TumblrApi getBlogAvatarUrl:_currentPost.blogName size:64]] placeholderImage:LightPlaceHolderImage];
            cell.titleLabel.text = _currentPost.blogName;
            cell.subTitleLabel.text = _currentPost.blog.blogDescription;
            cell.subTitleLabel.hidden = NO;
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if (!_currentPost) {
        return;
    }
    __strong typeof(_currentPost) post = _currentPost;
    switch (indexPath.row) {
        case 1: {
            if (_operationDelegate) {
                if (post.liked) {
                    [_operationDelegate unlike:post];
                }else {
                    [_operationDelegate like:post];
                }
            }
            break;
        }
        case 2: {
            if (_operationDelegate) {
                [_operationDelegate repost:post];
            }
            break;
        }
        case 4: {
            if (_operationDelegate) {
                [_operationDelegate blog:post.blogName];
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)show:(id)post {
    if (post) {
        _currentPost = post;
        [self.tableView reloadData];
    }
    [self makeKeyAndVisible];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.bottom.equalTo(self).offset(15);
            make.height.mas_equalTo(55 * 5 + 30 + SafeAreaBottom);
        }];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)hide {
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundColor = [UIColor clearColor];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.top.equalTo(self.mas_bottom);
            make.height.mas_equalTo(55 * 5 + 30 + SafeAreaBottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self resignKeyWindow];
    }];
}
@end
