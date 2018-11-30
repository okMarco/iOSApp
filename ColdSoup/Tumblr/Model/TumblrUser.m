//
//  TumblrUser.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/28.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "TumblrUser.h"
#import "Blog.h"

@implementation TumblrUser

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"blogs" : [Blog class]};
}

@end
