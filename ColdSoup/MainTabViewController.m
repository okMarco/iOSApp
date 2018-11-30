//
//  MainTabViewController.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/22.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "MainTabViewController.h"
#import "DashboardViewController.h"
#import "MeViewController.h"
#import "SearchViewController.h"
#import "FollowingViewController.h"
#import "TumblrDashboardViewController.h"
#import "TumblrLikesViewController.h"
#import "HOTransitionNavigationController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    TumblrDashboardViewController *dashboardVc = [[TumblrDashboardViewController alloc] init];
    HOTransitionNavigationController *dashboardWrapperVc = [[HOTransitionNavigationController alloc] initWithRootViewController:dashboardVc];

    
    MeViewController *meVc = [[MeViewController alloc] init];
    HOTransitionNavigationController *meWrapperVc = [[HOTransitionNavigationController alloc] initWithRootViewController:meVc];
    
    TumblrLikesViewController *likesVc = [[TumblrLikesViewController alloc] init];
    HOTransitionNavigationController *searchWrapperVc = [[HOTransitionNavigationController alloc] initWithRootViewController:likesVc];
    
    FollowingViewController *followingVc = [[FollowingViewController alloc] init];
    HOTransitionNavigationController *followingWrapperVc = [[HOTransitionNavigationController alloc] initWithRootViewController:followingVc];
    self.viewControllers = @[dashboardWrapperVc, searchWrapperVc, followingWrapperVc, meWrapperVc];
    
    for (UINavigationController *navigationVc in self.viewControllers) {
        [navigationVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: ContentTextColor} forState:UIControlStateSelected];
    }
}



@end
