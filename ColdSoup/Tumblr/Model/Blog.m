//
//  Blog.m
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import "Blog.h"

@implementation Blog

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"blogDescription" : @"description"};
}

@end
