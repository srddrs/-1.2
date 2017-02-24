//
//  YLLTabBarController.m
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "YLLTabBarController.h"
#import "YLLTabBar.h"

#import "HomePageViewController.h"
#import "GroupViewController.h"
#import "SendOutGoodsViewController.h"
#import "ServiceListViewController.h"
#import "MyViewController.h"
@interface YLLTabBarController ()<YLLTabBarDelegate>

@end

@implementation YLLTabBarController
#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = viewFont2;
    
    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = titleViewColor;
    dictSelected[NSFontAttributeName] = viewFont2;
    
    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAllChildVc];
    
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    YLLTabBar *tabbar = [[YLLTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{
    
    
    HomePageViewController *HomeVC = [[HomePageViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"zhuye_shouye_01" selectedImage:@"zhuye_shouye_02" title:@"首页"];
    
    GroupViewController *GroupVC = [[GroupViewController alloc] init];
    [self setUpOneChildVcWithVc:GroupVC Image:@"zhuye_quanzi_01" selectedImage:@"zhuye_quanzi_02" title:@"圈子"];
    
    ServiceListViewController *ServicePointsVC = [[ServiceListViewController alloc] init];
    [self setUpOneChildVcWithVc:ServicePointsVC Image:@"zhuye_fuwudian_01" selectedImage:@"zhuye_fuwudian_02" title:@"服务点"];
    
    MyViewController *MyVC = [[MyViewController alloc] init];
    [self setUpOneChildVcWithVc:MyVC Image:@"zhuye_wode_01" selectedImage:@"zhuye_wode_02" title:@"我的"];
}

#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    
//    Vc.tabBarItem.title = title;
    Vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    Vc.navigationItem.title = title;
    [self addChildViewController:nav];
    
}

#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(YLLTabBar *)tabBar
{
    SendOutGoodsViewController *SendOutGoodsVC = [[SendOutGoodsViewController alloc] init];
    YLLNavigationController *navVc = [[YLLNavigationController alloc] initWithRootViewController:SendOutGoodsVC];
    [self presentViewController:navVc animated:YES completion:nil];
}

@end
