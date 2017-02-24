//
//  PersonalAssetsViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "PersonalAssetsViewController.h"
#import "AccountBalanceViewController.h"
#import "ManageBankCardViewController.h"
#import "CollectingViewController.h"
#import "CouponshowViewController.h"
#import "MyBeanViewController.h"
#import "CarriageViewController.h"
@interface PersonalAssetsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *userItem;
}

@end

@implementation PersonalAssetsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        userItem = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_member_queryCustInformationFunction",@"funcId",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         
         [userItem removeAllObjects];
         ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
         if (obj.global.flag.intValue==-4001)
         {
             [MBProgressHUD showAutoMessage:@"登录失效，请重新登录。"];
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                 sleep(2);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     //清空保存的token等数据
                     NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
                     for (int i = 0; i < [cookies count]; i++)
                     {
                         NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
                         [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                         
                     }
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUser];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCookie];
                     ((YLLTabBarController *)self.view.window.rootViewController).selectedIndex = 0;
                     [self.navigationController popToRootViewControllerAnimated:NO];
                     
                     
                 });
             });
             
             return;
         }
         if (obj.global.flag.intValue==-4002)
         {
             [MBProgressHUD showAutoMessage:@"该功能暂时已关闭"];
             return;
         }
         if (obj.global.flag.intValue==-4003)
         {
             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             return;
         }
         if (obj.global.flag.intValue!=1)
         {
             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             return;
         }

         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             NSDictionary *item = ((response *)obj.responses[0]).items[0];
             NSLog(@"item:%@",item);
             [userItem setDictionary:item];
              [[NSUserDefaults standardUserDefaults] setObject:item forKey:kUserInfo];
             [[NSUserDefaults standardUserDefaults] synchronize];
              [_tableView reloadData];
         }
         
         NSLog(@"%@",responseObject);
     } Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资产";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
    
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - 20 )];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
    
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else
    {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*APP_DELEGATE().autoSizeScaleY;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DELEGATE().autoSizeScaleX, 10*APP_DELEGATE().autoSizeScaleY)];
    headView.backgroundColor = bgViewColor;
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 48*APP_DELEGATE().autoSizeScaleY;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier3 = @"CellIdentifier3";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
    [cell.contentView addSubview:icon1];
    
    UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
    titleLable1.numberOfLines = 0;
    titleLable1.textAlignment = NSTextAlignmentLeft;
    titleLable1.font = viewFont1;
    titleLable1.textColor = fontColor;
    titleLable1.text = @"";
    [cell.contentView addSubview:titleLable1];
    
    UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX,0 ,200 *APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
    titleLable2.numberOfLines = 0;
    titleLable2.textAlignment = NSTextAlignmentRight;
    titleLable2.font = viewFont1;
    titleLable2.textColor = fontColor;
    titleLable2.text = @"";
    [cell.contentView addSubview:titleLable2];

    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];

    if(indexPath.section==0&&indexPath.row==0)
    {
        icon1.image = [UIImage imageNamed:@"zhanghuyue"];
        titleLable1.text = @"账户余额";
        if ([userItem objectForKey:@"assets_abled"]!=nil)
        {
            titleLable2.text = [NSString stringWithFormat:@"%@",[userItem objectForKey:@"assets_abled"]];
        }
        
    }
    else  if(indexPath.section==0&&indexPath.row==1)
    {
        icon1.image = [UIImage imageNamed:@"YFQ-yunfeiquan"];
        titleLable1.text = @"运费劵余额";
        if ([userItem objectForKey:@"assets_abled"]!=nil )
        {
            titleLable2.text = [NSString stringWithFormat:@"%.2f", [[userItem objectForKey:@"freight_voucher_amount"] floatValue]+[[userItem objectForKey:@"freight_voucher_give_amount"] floatValue]];
        }
        
    }
//    else  if(indexPath.section==0&&indexPath.row==2)
//    {
//        icon1.image = [UIImage imageNamed:@"daishoukuanchaxun"];
//        titleLable1.text = @"代收款查询";
//        if ([userItem objectForKey:@"waybill_total"]!=nil )
//        {
//            titleLable2.text = [NSString stringWithFormat:@"%@",[userItem objectForKey:@"waybill_total"]];
//        }
//         fgx.hidden = YES;
//    }
    else  if(indexPath.section==0&&indexPath.row==2)
    {
        icon1.image = [UIImage imageNamed:@"wodezhichan"];
        titleLable1.text = @"绑定银行卡";
        if ([userItem objectForKey:@"bind_card_num"] !=nil)
        {
            titleLable2.text = [NSString stringWithFormat:@"%@",[userItem objectForKey:@"bind_card_num"]];
        }
       fgx.hidden = YES;
       
    }
    else  if(indexPath.section==1&&indexPath.row==0)
    {
        icon1.image = [UIImage imageNamed:@"GRZC_youhuiquan"];
        titleLable1.text = @"优惠券";
        if ([userItem objectForKey:@"coupon_num"] !=nil)
        {
            titleLable2.text = [NSString stringWithFormat:@"%@",[userItem objectForKey:@"coupon_num"]];
        }
         fgx.hidden = YES;
        
    }
//    else  if(indexPath.section==1&&indexPath.row==1)
//    {
//        icon1.image = [UIImage imageNamed:@"yunshudou"];
//        titleLable1.text = @"我的运输豆";
//        if ([userItem objectForKey:@"bean_num"] !=nil)
//        {
//            titleLable2.text = [NSString stringWithFormat:@"%@个",[userItem objectForKey:@"bean_num"]];
//        }
//        fgx.hidden = YES;
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0&&indexPath.row==0)
    {
        NSLog(@"账户余额");
        AccountBalanceViewController *vc = [[AccountBalanceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else  if(indexPath.section==0&&indexPath.row==1)
    {
        NSLog(@"运费劵余额");
        CarriageViewController *vc = [[CarriageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else  if(indexPath.section==0&&indexPath.row==2)
//    {
//        NSLog(@"代收款查询");
//        CollectingViewController *vc = [[CollectingViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    else  if(indexPath.section==0&&indexPath.row==2)
    {
        NSLog(@"绑定银行卡");
        ManageBankCardViewController *vc = [[ManageBankCardViewController alloc] init];
        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else  if(indexPath.section==1&&indexPath.row==0)
    {
        NSLog(@"优惠券");
        CouponshowViewController *vc = [[CouponshowViewController alloc] init];
        YLLWhiteNavViewController *nav = [[YLLWhiteNavViewController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else  if(indexPath.section==1&&indexPath.row==2)
    {
        NSLog(@"我的运输豆");
        MyBeanViewController *vc = [[MyBeanViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
    
}
@end
