//
//  ColdSoupRefreshHeader.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/29.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "ColdSoupRefreshHeader.h"

@interface ColdSoupRefreshHeader()

@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat angle;

@end

@implementation ColdSoupRefreshHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadingView];
        
        _timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(updateLoading) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
        WeakSelf(weakSelf);
        [self setBeginRefreshingCompletionBlock:^{
            [weakSelf.timer setFireDate:[NSDate date]];
        }];
        
        [self setEndRefreshingCompletionBlock:^{
            StrongSelf(strongSelf);
            [strongSelf.timer setFireDate:[NSDate distantFuture]];
            [UIView animateWithDuration:0.25 animations:^{
                strongSelf.loadingView.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    
    return self;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_coldsoup_loading_dark"]];
        [self addSubview:_loadingView];
        [_loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _loadingView;
}

- (void)updateLoading {
    _angle += M_PI / 20;
    if (_angle >= M_PI * 2) {
        _angle -= M_PI * 2;
    }
    self.loadingView.transform = CGAffineTransformMakeRotation(_angle);
}

@end
