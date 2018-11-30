//
//  Blog.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Blog : NSObject<NSCoding>
@property (nonatomic, copy) NSString *blogDescription;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *updated;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, assign) NSUInteger followers;
@property (nonatomic, assign) NSUInteger followed;
@property (nonatomic, assign) NSUInteger posts;

@end

NS_ASSUME_NONNULL_END
