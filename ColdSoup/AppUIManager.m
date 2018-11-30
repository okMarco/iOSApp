//
//  AppUiManager.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/28.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

NSString *const JDStatusBarStyleTumblrSuccess = @"JDStatusBarStyleTumblrSuccess";

#import "AppUIManager.h"
#import "JDStatusBarNotification.h"

@implementation AppUIManager

+ (instancetype)shareManager {
    static AppUIManager *uiManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uiManager = [[AppUIManager alloc] init];
    });
    return uiManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITableView.appearance.separatorColor = LineColor;
        [JDStatusBarNotification addStyleNamed:JDStatusBarStyleTumblrSuccess prepare:^JDStatusBarStyle *(JDStatusBarStyle * _Nonnull style) {
            style.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
            style.textColor = [UIColor whiteColor];
            style.barColor = GreenColor;
            return style;
        }];
    }
    return self;
}

@end
