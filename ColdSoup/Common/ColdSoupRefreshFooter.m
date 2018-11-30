//
//  ColdSoupRefreshFooter.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/29.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "ColdSoupRefreshFooter.h"

@interface ColdSoupRefreshFooter()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation ColdSoupRefreshFooter

- (instancetype)init
{
    self = [super init];
    if (self) {
        WeakSelf(weakSelf);
        [self setBeginRefreshingCompletionBlock:^{
            [weakSelf.loadingView startAnimating];
        }];
        [self setEndRefreshingCompletionBlock:^{
            StrongSelf(strongSelf);
            [strongSelf.loadingView stopAnimating];
        }];
    }
    return self;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView];
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _loadingView;
}

@end
