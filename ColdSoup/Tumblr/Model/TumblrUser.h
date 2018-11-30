//
//  TumblrUser.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/28.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Blog;
NS_ASSUME_NONNULL_BEGIN

@interface TumblrUser : NSObject
@property (nonatomic, strong) NSArray *blogs;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger following;
@end

NS_ASSUME_NONNULL_END
