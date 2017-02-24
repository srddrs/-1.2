//
//  AppDelegate.m
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "YLLYinDaoViewController.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度，兼容性测试
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度，兼容性测试
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window,tabBarVc;
- (void)initTabbar
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"app_Version:%@",app_Version);
    NSLog(@"app_build:%@",app_build);
    //设置是否第一次登陆
//    [NSString stringWithFormat:@"%@-everLaunched",app_Version];
//    [NSString stringWithFormat:@"%@-firstLaunch",app_Version];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-everLaunched",app_Version]])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-everLaunched",app_Version]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@-firstLaunch",app_Version]];
    }
    else
    {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@-firstLaunch",app_Version]];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@-firstLaunch",app_Version]])
    {
        // 这里判断是否第一次
        YLLYinDaoViewController *yinDaoVC = [[YLLYinDaoViewController alloc]init];
        self.window.rootViewController = yinDaoVC;
    }
    else
    {
        tabBarVc = [[YLLTabBarController alloc] init];
        CATransition *anim = [[CATransition alloc] init];
        anim.type = @"rippleEffect";
        anim.duration = 1.0;
        [self.window.layer addAnimation:anim forKey:nil];
        self.window.rootViewController = tabBarVc;
    }
    [self.window makeKeyAndVisible];

    
}

- (void)umengTrack {
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = @"57de0e27e0f55a207d0015cc";
    UMConfigInstance.secret = @"secretstringaldfkals";
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     [self umengTrack];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if(ScreenHeight > 480)
    {
        myDelegate.autoSizeScaleX = ScreenWidth/320;
        myDelegate.autoSizeScaleY = ScreenHeight/568;
    }else{
        myDelegate.autoSizeScaleX = 1.0;
        myDelegate.autoSizeScaleY = 1.0;
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self initTabbar];
    
     [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [AMapServices sharedServices].apiKey = gaodeAPIKey;
    
     [[LocationManager sharedInstance] startUpdateLocationTimer];
    
    if (ISAPPSTORE==0)
    {
        //    //启动基本SDK
        [[PgyManager sharedPgyManager] startManagerWithAppId:@"941fbdc4f6b2a08c1d08a2cd66ef75df"];
        //启动更新检查SDK
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"941fbdc4f6b2a08c1d08a2cd66ef75df"];
        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    }

    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"托运邦"];
    return YES;
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_zhifu object:nil];
                break;
            case WXErrCodeCommon:
                [MBProgressHUD showAutoMessage:@"支付失败"];
                break;
            case WXErrCodeUserCancel:
                [MBProgressHUD showAutoMessage:@"取消支付"];
                break;
            case WXErrCodeSentFail:
                [MBProgressHUD showAutoMessage:@"发送失败"];
                break;
            case WXErrCodeAuthDeny:
                [MBProgressHUD showAutoMessage:@"授权失败"];
                break;
            case WXErrCodeUnsupport:
                [MBProgressHUD showAutoMessage:@"微信不支持"];
                break;
//                WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//                WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//                WXErrCodeSentFail   = -3,   /**< 发送失败    */
//                WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//                WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
            default:
               [MBProgressHUD showAutoMessage:@"支付失败"];                
                
                break;
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //    if ([url.host isEqualToString:@"safepay"]) {
    //        //跳转支付宝钱包进行支付，处理支付结果
    //        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
    //            NSLog(@"result = %@",resultDic);
    //        }];
    //    }
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"APPDelegate中 result = %@",resultDic);
        }];
        
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             NSLog(@"result = %@",resultDic);
                                             NSString *resultStr = resultDic[@"result"];
                                             NSLog(@"result = %@",resultStr);
                                               [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_zhifu object:nil userInfo:resultDic];
                                         }];
    }
    else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"APPDelegate中 result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000)
            {
                [MBProgressHUD showAutoMessage:@"支付成功"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_zhifu object:nil userInfo:resultDic];
            }
            else if ([[resultDic objectForKey:@"resultStatus"] integerValue]==6001)
            {
                [MBProgressHUD showAutoMessage:@"取消支付"];
            }
            else
            {
                [MBProgressHUD showAutoMessage:@"支付失败"];
            }

        }];
    }
    else if ([url.host isEqualToString:@"pay"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"APPDelegate中 result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000)
            {
                [MBProgressHUD showAutoMessage:@"支付成功"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_zhifu object:nil userInfo:resultDic];
            }
            else if ([[resultDic objectForKey:@"resultStatus"] integerValue]==6001)
            {
                [MBProgressHUD showAutoMessage:@"取消支付"];
            }
            else
            {
                [MBProgressHUD showAutoMessage:@"支付失败"];
            }


           
        }];
    }
    else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"APPDelegate中 result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] integerValue]==9000)
            {
                [MBProgressHUD showAutoMessage:@"支付成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_zhifu object:nil userInfo:resultDic];
            }
            else if ([[resultDic objectForKey:@"resultStatus"] integerValue]==6001)
            {
                [MBProgressHUD showAutoMessage:@"取消支付"];
            }
            else
            {
                [MBProgressHUD showAutoMessage:@"支付失败"];
            }
            
        }];
    }

    else if ([url.host isEqualToString:@"pay"])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }

    return YES;
}

- (void)storyBoradAutoLay:(UIView *)allView
{
    for (UIView *temp in allView.subviews)
    {
        if (![temp isKindOfClass:[UITableView class]]&&![temp isKindOfClass:[UICollectionView class]]&&![temp isKindOfClass:[MJRefreshStateHeader class]]&&![temp isKindOfClass:[MJRefreshAutoStateFooter class]])
        {
            temp.frame = CGRectMake1(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
        }
        
        for (UIView *temp1 in temp.subviews)
        {
            if (![temp isKindOfClass:[UITableView class]]&&![temp isKindOfClass:[UICollectionView class]]&&![temp isKindOfClass:[MJRefreshStateHeader class]]&&![temp isKindOfClass:[MJRefreshAutoStateFooter class]])
            {
                temp1.frame = CGRectMake1(temp1.frame.origin.x, temp1.frame.origin.y, temp1.frame.size.width, temp1.frame.size.height);
            }
            for (UIView *temp2 in temp1.subviews)
            {
                if (![temp isKindOfClass:[UITableView class]]&&![temp isKindOfClass:[UICollectionView class]]&&![temp isKindOfClass:[MJRefreshStateHeader class]]&&![temp isKindOfClass:[MJRefreshAutoStateFooter class]])
                {
                    temp2.frame = CGRectMake1(temp2.frame.origin.x, temp2.frame.origin.y, temp2.frame.size.width, temp2.frame.size.height);
                }
                for (UIView *temp3 in temp2.subviews)
                {
                    if (![temp isKindOfClass:[UITableView class]]&&![temp isKindOfClass:[UICollectionView class]]&&![temp isKindOfClass:[MJRefreshStateHeader class]]&&![temp isKindOfClass:[MJRefreshAutoStateFooter class]])
                    {
                        temp3.frame = CGRectMake1(temp3.frame.origin.x, temp3.frame.origin.y, temp3.frame.size.width, temp3.frame.size.height);
                    }
                }
                
            }
        }
    }
}

//修改CGRectMake
CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX; rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX; rect.size.height = height * myDelegate.autoSizeScaleY;
    return rect;
}
@end
