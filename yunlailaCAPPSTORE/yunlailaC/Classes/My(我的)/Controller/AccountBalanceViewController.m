//
//  AccountBalanceViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AccountBalanceViewController.h"
#import "AddBankCardViewController.h"
#import "AddBankCard2ViewController.h"
#import "IncomeAndExpensesViewController.h"
#import "AccountDrawMoneyViewController.h"
#import "AddBankCard3ViewController.h"
#import "ManageBankCardViewController.h"
@interface AccountBalanceViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
}

@end

@implementation AccountBalanceViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self getuserInfo];


}
- (void)getuserInfo
{
    //获取用户信息
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_member_queryCustInformationFunction",@"funcId",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
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
             
             
             [[NSUserDefaults standardUserDefaults] setObject:item forKey:kUserInfo];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [_tableView reloadData];
         }
         else
         {
             
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
    self.title = @"账户余额";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
//    headView.backgroundColor = bgViewColor;
//    return headView;
//}

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
    
    
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        fgx.hidden = YES;
        icon1.hidden = YES;
        titleLable1.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = titleViewColor;
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = titleFont1;
        titleLable1.textColor = [UIColor whiteColor];
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        
        titleLable1.text = [NSString stringWithFormat:@"￥%@元",[userInfo objectForKey:@"assets_abled"]];
        [cell.contentView addSubview:titleLable1];
        
    }
    else  if(indexPath.section==0&&indexPath.row==1)
    {
        icon1.image = [UIImage imageNamed:@"tixian"];
        titleLable1.text = @"提现";
        
    }
    else  if(indexPath.section==0&&indexPath.row==2)
    {
        icon1.image = [UIImage imageNamed:@"mingxi"];
        titleLable1.text = @"收支明细";
        fgx.hidden = YES;
    }

    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0&&indexPath.row==1)
    {
        NSLog(@"提现");
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        
        if ([[userInfo objectForKey:@"assets_abled"] doubleValue]<=0)
        {
            [MBProgressHUD showAutoMessage:@"您的余额不足"];
        }
        else
        {
            if ([[userInfo objectForKey:@"bind_card_num"] intValue]==0)
            {
                [UIAlertView showAlert:@"您还没有绑定银行卡,是否绑定银行卡？" delegate:self cancelButton:@"取消" otherButton:@"绑定银行卡" tag:1];
            }
            else
            {
                AccountDrawMoneyViewController *vc =[[AccountDrawMoneyViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
  
        
    }
    else  if(indexPath.section==0&&indexPath.row==2)
    {
        NSLog(@"收支明细");
        IncomeAndExpensesViewController *vc = [[IncomeAndExpensesViewController alloc] init];
        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        if ([[loginUser objectForKey:@"is_auth"] intValue]==0||[[loginUser objectForKey:@"is_auth"] intValue]==3)//没有实名认证
        {
            AddBankCardViewController *vc = [[AddBankCardViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        else if ([[loginUser objectForKey:@"is_auth"] intValue]==1)//实名认证审核中
        {
             [MBProgressHUD showAutoMessage:@"实名认证审核中，请耐心等待"];
        }
        else
        {
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
//            [actionSheet addButtonWithTitle:@"添加银行卡(自己)"];
//            [actionSheet addButtonWithTitle:@"添加银行卡(他人)"];
//            [actionSheet addButtonWithTitle:@"取消"];
//            actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
//            actionSheet.tag = 11;
//            actionSheet.delegate = self;
//            [actionSheet showInView:self.view];
            ManageBankCardViewController *vc = [[ManageBankCardViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
           
        }
       
    }
    else
    {
        NSLog(@"取消");
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        AddBankCard2ViewController *vc = [[AddBankCard2ViewController alloc] init];
        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if(buttonIndex==1)
    {
//        [MBProgressHUD showAutoMessage:@"添加他人银行卡"];
        AddBankCard3ViewController *vc = [[AddBankCard3ViewController alloc] init];
        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
@end
