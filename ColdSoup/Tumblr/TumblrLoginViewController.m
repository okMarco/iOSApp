//
//  LoginViewController.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "TumblrLoginViewController.h"
#import <TMTumblrSDK/TMOAuthAuthenticator.h>
#import <TMTumblrSDK/TMURLSession.h>
#import "TMOAuthAuthenticatorDelegate.h"
#import "HOWebView.h"
#import "TumblrApi.h"
#import "MainTabViewController.h"
#import "TMAPIError.h"

NSString *const TumblrLoginSuccessNotification = @"TumblrLoginSuccess";


@interface TumblrLoginViewController ()<TMOAuthAuthenticatorDelegate, WKNavigationDelegate>
@property (nonatomic, strong) TMAPIApplicationCredentials *applicationCredentials;
@property (nonatomic, strong) TMURLSession *session;
@property (nonatomic, strong) TMOAuthAuthenticator *authenticator;

@property (nonatomic, strong) HOWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation TumblrLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TumblrColor;
    
    self.applicationCredentials = [[TMAPIApplicationCredentials alloc] initWithConsumerKey:TumblrApiConsumer consumerSecret:TumblrApiConsumerSecret];
    
    self.session = [[TMURLSession alloc] initWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                        applicationCredentials:self.applicationCredentials
                                               userCredentials:[TMAPIUserCredentials new]
                                        networkActivityManager:nil
                                     sessionTaskUpdateDelegate:nil
                                        sessionMetricsDelegate:nil
                                            requestTransformer:nil
                                             additionalHeaders:nil];
    
    self.authenticator = [[TMOAuthAuthenticator alloc] initWithSession:self.session
                                                applicationCredentials:self.applicationCredentials
                                                              delegate:self];
    [self.loadingView startAnimating];
    [self.authenticator authenticate:@"ello" callback:^(TMAPIUserCredentials * _Nullable creds, NSError * _Nullable error) {
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setObject:creds.token forKey:TumblrApiOAuthTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:creds.tokenSecret forKey:TumblrApiOAuthTokenSecretKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[TumblrApi shareApi] userInfo];
            MainTabViewController *mainVc = [[MainTabViewController alloc] init];
            [self presentViewController:mainVc animated:YES completion:nil];
        }
    }];
}

- (HOWebView *)webView {
    if (!_webView) {
        _webView = [[HOWebView alloc] init];
        NSString *colorHtml = @"<html><body style=\"background: #36465D\"></body></html>";
        [_webView loadHTMLString:colorHtml baseURL:nil];
        [self.view addSubview:_webView];
        _webView.navigationDelegate = self;
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _webView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingView.hidesWhenStopped = YES;
        [self.view addSubview:_loadingView];
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
    }
    return _loadingView;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    [self.authenticator handleOpenURL:URL];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)openURLInBrowser:(NSURL *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.loadingView stopAnimating];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:urlRequest];
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
