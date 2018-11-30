//
//  HOWebView.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "HOWebView.h"
@interface HOWebView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation HOWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:UIScrollView.class]) {
                ((UIScrollView *)view).delegate = self;
                break;
            }
        }
    }
    return self;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        [self addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
        }];
    }
    return _progressView;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if ([change[NSKeyValueChangeNewKey] floatValue] < [change[NSKeyValueChangeOldKey] floatValue]) {
            return;
        }
        self.progressView.hidden = NO;
        self.progressView.progress = [change[NSKeyValueChangeNewKey] floatValue];
        if ([change[@"new"]floatValue] == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
            });
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self).offset(scrollView.adjustedContentInset.top);
        } else {
            // Fallback on earlier versions
        }
    }];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
