//
//  BXTabBarController.m
//  BaoXianDaiDai
//
//  Created by JYJ on 15/5/28.
//  Copyright (c) 2015年 baobeikeji.cn. All rights reserved.
//

#import "YLLTabBarController.h"

#import "HomePageViewController.h"
#import "GroupViewController.h"
#import "SendOutGoodsViewController.h"
#import "ServiceListViewController.h"
#import "MyViewController.h"

#import "YLLTabBar.h"

#define kTabbarHeight 49

@interface YLLTabBarController ()

@end

@implementation YLLTabBarController
+ (void)initialize {
    // 设置tabbarItem的普通文字
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [[UIColor alloc]initWithRed:113/255.0 green:109/255.0 blue:104/255.0 alpha:1];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    
    //设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self addAllChildVc];
    // 自定义tabBar
    [self setUpTabBar];
}
#pragma mark - 自定义tabBar
- (void)setUpTabBar
{
    YLLTabBar *myTabBar = [[YLLTabBar alloc] init];
    // 更换tabBar
    [self setValue:myTabBar forKey:@"tabBar"];
}



/**
 *  添加所有的子控制器
 */
- (void)addAllChildVc {
    // 添加初始化子控制器 BXHomeViewController
    HomePageViewController *home = [[HomePageViewController alloc] init];
    [self addOneChildVC:home title:@"首页" imageName:@"zhuye_shouye_01" selectedImageName:@"zhuye_shouye_02"];
    
    GroupViewController *customer = [[GroupViewController alloc] init];
    [self addOneChildVC:customer title:@"圈子" imageName:@"zhuye_quanzi_01" selectedImageName:@"zhuye_quanzi_02"];
    
    // 添加一个空白控制器
    [self addChildViewController:[[UIViewController alloc] init]];
    
    ServiceListViewController *compare = [[ServiceListViewController alloc] init];
    [self addOneChildVC:compare title:@"服务点" imageName:@"zhuye_fuwudian_01" selectedImageName:@"zhuye_fuwudian_02"];
    
    MyViewController *profile = [[MyViewController alloc]init];
    [self addOneChildVC:profile title:@"我的" imageName:@"zhuye_wode_01" selectedImageName:@"zhuye_wode_02"];
//    profile.view.backgroundColor = BXRandomColor;
}


/**
 *  添加一个自控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中时的图标
 */

- (void)addOneChildVC:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
//    childVc.tabBarItem.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 不要渲染
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    childVc.navigationItem.title = title;
    
    // 添加为tabbar控制器的子控制器
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

@end
