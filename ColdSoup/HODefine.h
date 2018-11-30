//
//  HODefine.h
//  ColdSoup
//
//  Created by HoChan on 2018/11/23.
//  Copyright © 2018 Okhoochan. All rights reserved.
//

#ifndef HODefine_h
#define HODefine_h

#define CollectionViewGap 5

#define WeakSelf(weakSelf)  __weak typeof(self) weakSelf = self;
#define StrongSelf(strongSelf)  __strong typeof(weakSelf) strongSelf = weakSelf;

#define SafeAreaBottom ({CGFloat i; if(@available(iOS 11.0, *)) {i = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom; } else {i = 0;} i;})

#define BackgroundColor [UIColor colorWithHexString:@"ECEEF0"]
#define GreenColor [UIColor colorWithHexString:@"56BB89"]
#define LineColor [UIColor colorWithHexString:@"D5D6D9"]
#define TumblrColor [UIColor colorWithHexString:@"36465D"]
#define LightPlaceHolderColor [UIColor colorWithHexString:@"EEEEEE"]
#define LightPlaceHolderImage [UIImage imageWithColor:LightPlaceHolderColor]

#define ContentTextFont [UIFont systemFontOfSize:16]
#define ContentTextColor [UIColor colorWithHexString:@"404040"]
#define SubContentTextFont [UIFont systemFontOfSize:12]
#define SubContentTextColor [UIColor colorWithHexString:@"808080"]
#define ThumbnailTextFont [UIFont systemFontOfSize:16 weight:UIFontWeightBold]

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#endif /* HODefine_h */
