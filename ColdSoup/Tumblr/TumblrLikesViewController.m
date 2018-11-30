//
//  TumblrLikesViewController.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/28.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "TumblrLikesViewController.h"

@interface TumblrLikesViewController ()

@end

@implementation TumblrLikesViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"Likes";
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)refreshData:(NSUInteger)sinceId {
    [[TumblrApi shareApi] likes:sinceId after:0 completionBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        [self refreshComplete:posts error:error];
    }];
}


- (void)loadMoreData:(NSInteger)offset {
    [[TumblrApi shareApi] likes:0 after:0 completionBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        [self loadMoreDataComplete:posts error:error];
    }];
}

@end
