//
//  HOViewControllerTransition.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/30.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HOViewControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL isPresenting;

@end

NS_ASSUME_NONNULL_END
