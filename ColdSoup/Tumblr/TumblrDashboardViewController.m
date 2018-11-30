//
//  TumblrDashboardViewController.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "TumblrDashboardViewController.h"

@interface TumblrDashboardViewController ()

@end

@implementation TumblrDashboardViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"Dashboard";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)refreshData:(NSUInteger)sinceId {
    [[TumblrApi shareApi] dashboard:sinceId offset:0 completionBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        [self refreshComplete:posts error:error];
    }];
}

- (void)loadMoreData:(NSInteger)offset {
    [[TumblrApi shareApi] dashboard:0 offset:offset completionBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        [self loadMoreDataComplete:posts error:error];
    }];
    return;
}

@end
