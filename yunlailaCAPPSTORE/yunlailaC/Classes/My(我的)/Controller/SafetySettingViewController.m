//
//  SafetySettingViewController.m
//  yunlailaC
//
//  Created by admin on 16/8/29.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "SafetySettingViewController.h"
#import "SetPayPassWordViewController.h"
#import "UpdatePassWordViewController.h"
#import "AddBankCardViewController.h"
#import "AddBankCard1ViewController.h"
@interface SafetySettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
}
@end

@implementation SafetySettingViewController
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
    self.title = @"安全设置";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
    
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
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
    return 40*APP_DELEGATE().autoSizeScaleY;
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
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 100*APP_DELEGATE().autoSizeScaleX, 40*APP_DELEGATE().autoSizeScaleY)];
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.textColor = fontColor;
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.lineBreakMode = NSLineBreakByWordWrapping;
    namelabel.numberOfLines = 0;
    namelabel.font = viewFont1;
    namelabel.text = @"";
    [cell.contentView addSubview:namelabel];
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 39*APP_DELEGATE().autoSizeScaleY, 290*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];
    
    if (indexPath.row==0)
    {
        namelabel.text = @"设置支付密码";
    }
    else  if (indexPath.row==1)
    {
        namelabel.text = @"修改登录密码";
    }
    else  if (indexPath.row==2)
    {
        fgx.hidden = YES;
        namelabel.text = @"实名认证";
        
        UILabel *statuslabel = [[UILabel alloc] initWithFrame:CGRectMake(215*APP_DELEGATE().autoSizeScaleX, 0, 70*APP_DELEGATE().autoSizeScaleX, 40*APP_DELEGATE().autoSizeScaleY)];
        statuslabel.backgroundColor = [UIColor clearColor];
        statuslabel.textColor = [UIColor colorWithRed:162/255.0 green:163/255.0 blue:164/255.0 alpha:1];
        statuslabel.textAlignment = NSTextAlignmentRight;
        statuslabel.lineBreakMode = NSLineBreakByWordWrapping;
        statuslabel.numberOfLines = 0;
        statuslabel.font = viewFont1;
        statuslabel.text = @"";
        [cell.contentView addSubview:statuslabel];

        NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        if ([[loginUser objectForKey:@"is_auth"] intValue]==0)//没有实名认证
        {
            statuslabel.text = @"(未认证)";
        }
        else if ([[loginUser objectForKey:@"is_auth"] intValue]==3)//实名认证审核中
        {
            statuslabel.text = @"(未通过)";
        }
        else if ([[loginUser objectForKey:@"is_auth"] intValue]==1)//实名认证审核中
        {
            statuslabel.text = @"(正在审核)";
        }
        else
        {
            statuslabel.text = @"(已认证)";
        }

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0&&indexPath.row==0)
    {
        NSLog(@"设置支付密码");
        SetPayPassWordViewController *vc =[[SetPayPassWordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else  if (indexPath.section==0&&indexPath.row==1)
    {
        NSLog(@"修改支付密码");
        UpdatePassWordViewController *vc =[[UpdatePassWordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else  if (indexPath.section==0&&indexPath.row==2)
    {
        
        NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        if ([[loginUser objectForKey:@"is_auth"] intValue]==0)
        {
            NSLog(@"去实名认证");
            AddBankCardViewController *vc = [[AddBankCardViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        else if ([[loginUser objectForKey:@"is_auth"] intValue]==1)//实名认证审核中
        {
            [MBProgressHUD showAutoMessage:@"实名认证审核中，请耐心等待"];
        }
        else if ([[loginUser objectForKey:@"is_auth"] intValue]==3)//实名认证审核中
        {
            
            AddBankCard1ViewController *vc = [[AddBankCard1ViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            NSLog(@"无事件");
        }

//        UpdatePassWordViewController *vc =[[UpdatePassWordViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
