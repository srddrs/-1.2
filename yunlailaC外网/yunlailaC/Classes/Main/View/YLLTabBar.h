//
//  YLLTabBar.h
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLLTabBar;

@protocol YLLTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(YLLTabBar *)tabBar;
@end
@interface YLLTabBar : UITabBar
/** tabbar的代理 */
@property (nonatomic, weak) id<YLLTabBarDelegate> myDelegate ;
@end
