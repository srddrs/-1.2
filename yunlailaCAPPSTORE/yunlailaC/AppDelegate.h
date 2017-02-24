//
//  AppDelegate.h
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLLTabBarController.h"
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)  YLLTabBarController *tabBarVc;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
- (void)storyBoradAutoLay:(UIView *)allView;
@end

