//
//  TumblrBlogViewController.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/30.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "TumblrBlogViewController.h"

@interface TumblrBlogViewController ()

@end

@implementation TumblrBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.numberOfTouchesRequired = tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)tap {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
