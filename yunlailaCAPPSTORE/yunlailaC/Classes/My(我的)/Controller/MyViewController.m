//
//  MyViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//
/**
 *  个人中心
 *
 *  @return
 */
#import "MyViewController.h"
#import "UserInfoViewController.h"
#import "PersonalAssetsViewController.h"
#import "OrdersViewController.h" //我的订单
#import "ChangYongGetAddressViewController.h"
#import "ChangYongSendAddressViewController.h"
#import "StatisticsViewController.h"
#import "MyMessageViewController.h" //消息
#import "SettingViewController.h" //设置
#import "AccountBalanceViewController.h"
#import "CouponshowViewController.h"
#import "MyBeanViewController.h"
#import "SafetySettingViewController.h"
#import "CarriageViewController.h"
#import "WoDeYuanGongViewController.h"
#import "ShouHuoDianHuaViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableDictionary *userItem;
    UILabel *namelabel;
    UILabel *phonelabel;
    UILabel *valueLable1;
    UILabel *valueLable2;
    UILabel *valueLable3;
    
    UIImageView *bgView;
}
@end

@implementation MyViewController
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
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.hidesBackButton = YES;
    
    NSDictionary *user =  [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
    if (user==nil)
    {
        [AppTool presentDengLu:self];
    }
    else
    {
        //获取用户信息
        [userItem removeAllObjects];
        [_tableView reloadData];
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        
        //     [MBProgressHUD showMessag:@"" toView:self.view];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_member_queryCustInformationFunction",@"funcId",
//                            @"hex_client_member_queryAccountInfoFunction",@"funcId", //以后替换
                                         nil];
        
        [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
         {
             //         [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
//             if (obj.global.flag.intValue==-1)
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
                 [userItem removeAllObjects];
                 [userItem setDictionary:item];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:item forKey:kUserInfo];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 if ([[item objectForKey:@"nick_name"] length]>0)
                 {
                     namelabel.text = [NSString stringWithFormat:@"昵称:%@",[item objectForKey:@"nick_name"]];
                 }
                 else
                 {
                     namelabel.text = [NSString stringWithFormat:@"昵称:%@",[item objectForKey:@"real_name"]];
                 }
                 
                 phonelabel.text = [NSString stringWithFormat:@"账号:%@",[item objectForKey:@"account_id"]];
                 [_tableView reloadData];
             }
             else
             {
//                              NSRange range = [((response *)obj.responses[0]).message rangeOfString:@"UnknownHostException"];
//                              if (range.location !=NSNotFound)
//                              {
//                                  [MBProgressHUD showError:@"网络异常" toView:self.view];
//                              }
//                              else
//                              {
//                                  [MBProgressHUD showError:((response *)obj.responses[0]).message toView:self.view];
//                              }
             }
             NSLog(@"%@",responseObject);
         } Failure:^(NSError *error)
         {
             NSLog(@"%@",error);
             //         [MBProgressHUD hideHUDForView:self.view animated:YES];
             //         [MBProgressHUD showError:@"失败" toView:self.view];
             
         }];
        
        
    }
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"XX_gerenzhongxin" highIcon:@"XX_gerenzhongxin" target:self action:@selector(messageBtnClick:)];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"shezhi" highIcon:@"shezhi" target:self action:@selector(settingBtnClick:)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TabbarHeight-20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
    
    [_tableView reloadData];
    
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)messageBtnClick:(id)sender
{
    NSLog(@"消息");
    [UIAlertView showAlert:@"正在开发中..." cancelButton:@"知道了"];
    //    MyMessageViewController *vc = [[MyMessageViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)settingBtnClick:(id)sender
{
    NSLog(@"设置");
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    if ([[loginUser objectForKey:@"cust_relations_type"] intValue]==1||[[loginUser objectForKey:@"cust_relations_type"] intValue]==2)
    {
        if (section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return 2;
        }
        else if (section == 2)
        {
            return 5;
        }
        else
        {
            return 3;
        }

    }//客户关系类型（1：无关系；2：老板；3：员工）
    else
    {
        if (section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return 0;
        }
        else if (section == 2)
        {
            return 2;
        }
        else
        {
            return 0;
        }

    }

    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DELEGATE().autoSizeScaleX, 10)];
    headView.backgroundColor = bgViewColor;
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 186*APP_DELEGATE().autoSizeScaleY;
    }
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
    
    if (indexPath.section==0&&indexPath.row==0)
    {
        if (!bgView)
        {
            bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DELEGATE().autoSizeScaleX, 186*APP_DELEGATE().autoSizeScaleY)];
           
        }
        
        if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"银牌会员"])
        {
            bgView.image = [UIImage imageNamed:@"grzx_beijing"];
        }
        else if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"金牌会员"])
        {
            bgView.image = [UIImage imageNamed:@"beijingkuang"];
        }
        else if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"铜牌会员"])
        {
            bgView.image = [UIImage imageNamed:@"beijing"];
        }
        [cell.contentView addSubview:bgView];
        
        bgView.userInteractionEnabled = YES;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0*APP_DELEGATE().autoSizeScaleX, 10*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 44*APP_DELEGATE().autoSizeScaleY)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"银牌会员"])
        {
              titleLabel.textColor = fontColor;
        }
        else
        {
            titleLabel.textColor = fontColor;
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
     
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.font = titleFont1;
        titleLabel.text = @"个人中心";
         [bgView addSubview:titleLabel];
        
        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingBtn.frame = CGRectMake(280*APP_DELEGATE().autoSizeScaleX, 10*APP_DELEGATE().autoSizeScaleY, 44*APP_DELEGATE().autoSizeScaleY, 44*APP_DELEGATE().autoSizeScaleY);
        [bgView addSubview: settingBtn];
        
        [settingBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
        [settingBtn setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateHighlighted];
        [settingBtn addTarget:self
                       action:@selector(settingBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];

        
        
        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(160*APP_DELEGATE().autoSizeScaleX-30*APP_DELEGATE().autoSizeScaleX, 60*APP_DELEGATE().autoSizeScaleY, 60*APP_DELEGATE().autoSizeScaleY, 60*APP_DELEGATE().autoSizeScaleY)];
        headView.layer.masksToBounds = YES;
        headView.layer.cornerRadius = 60/2*APP_DELEGATE().autoSizeScaleY;
        NSURL *url = [NSURL URLWithString:@"111"];
        [headView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"userIcon"]];
        [cell.contentView addSubview:headView];
        
        if (!namelabel)
        {
            namelabel = [[UILabel alloc] initWithFrame:CGRectMake(110*APP_DELEGATE().autoSizeScaleX, 125*APP_DELEGATE().autoSizeScaleY, 155*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
            namelabel.backgroundColor = [UIColor clearColor];
            namelabel.textColor = [UIColor whiteColor];
            namelabel.textAlignment = NSTextAlignmentLeft;
            namelabel.lineBreakMode = NSLineBreakByWordWrapping;
            namelabel.numberOfLines = 0;
            namelabel.font = viewFont3;
            namelabel.text = @"";
        }
        if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"银牌会员"])
        {
            namelabel.textColor = fontColor;
        }
        else
        {
            namelabel.textColor = fontColor;
        }
        [cell.contentView addSubview:namelabel];
        
        CGSize size = [namelabel boundingRectWithSize:CGSizeMake(100*APP_DELEGATE().autoSizeScaleX, 0)];
        namelabel.frame = CGRectMake(110*APP_DELEGATE().autoSizeScaleX, 125*APP_DELEGATE().autoSizeScaleY, size.width*APP_DELEGATE().autoSizeScaleX,30*APP_DELEGATE().autoSizeScaleY);
        
        
        
        if (!phonelabel)
        {
            phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(110*APP_DELEGATE().autoSizeScaleX, 150*APP_DELEGATE().autoSizeScaleY, 155*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
            phonelabel.backgroundColor = [UIColor clearColor];
            phonelabel.textColor = [UIColor whiteColor];
            phonelabel.textAlignment = NSTextAlignmentLeft;
            phonelabel.lineBreakMode = NSLineBreakByWordWrapping;
            phonelabel.numberOfLines = 0;
            phonelabel.font = viewFont3;
            phonelabel.text = @"";
        }
        if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"银牌会员"])
        {
            phonelabel.textColor = fontColor;
        }
        else
        {
            phonelabel.textColor = fontColor;
        }
        [cell.contentView addSubview:phonelabel];
        
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake((105+6+size.width)*APP_DELEGATE().autoSizeScaleX, 132*APP_DELEGATE().autoSizeScaleY, 14*APP_DELEGATE().autoSizeScaleY, 16*APP_DELEGATE().autoSizeScaleY)];
        if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"铜牌会员"])
        {
            icon1.image = [UIImage imageNamed:@"YFQ-tiepai"];
        }
        else if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"银牌会员"])
        {
            icon1.image = [UIImage imageNamed:@"YFQ-yinpai"];
        }
        else if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"金牌会员"])
        {
            icon1.image = [UIImage imageNamed:@"YFQ-jinpai"];
        }
        else if ([[userItem objectForKey:@"grade_name"] isEqualToString:@"钻石会员"])
        {
            icon1.image = [UIImage imageNamed:@"YFQ-jinpai"];
        }
        
        
        [cell.contentView addSubview:icon1];
        
        UIImageView *icon2 = [[UIImageView alloc] initWithFrame:CGRectMake((105+6+size.width+15)*APP_DELEGATE().autoSizeScaleX, 134*APP_DELEGATE().autoSizeScaleY, 12*APP_DELEGATE().autoSizeScaleY, 12*APP_DELEGATE().autoSizeScaleY)];
        
        icon2.image = [UIImage imageNamed:@"DJ_v1"];
        
//        if ([[userItem objectForKey:@"cust_grade_id"] isEqualToString:@"1"])
//        {
//            icon2.image = [UIImage imageNamed:@"DJ_v1"];
//        }
//        else if ([[userItem objectForKey:@"cust_grade_id"] isEqualToString:@"2"])
//        {
//            icon2.image = [UIImage imageNamed:@"DJ_v2"];
//        }
//        else if ([[userItem objectForKey:@"cust_grade_id"] isEqualToString:@"3"])
//        {
//            icon2.image = [UIImage imageNamed:@"DJ_v3"];
//        }
//        else if ([[userItem objectForKey:@"cust_grade_id"] isEqualToString:@"4"])
//        {
//            icon2.image = [UIImage imageNamed:@"DJ_v4"];
//        }
//        else if ([[userItem objectForKey:@"cust_grade_id"] isEqualToString:@"5"])
//        {
//            icon2.image = [UIImage imageNamed:@"DJ_v5"];
//        }
        
        [cell.contentView addSubview:icon2];
        
        UIImageView *icon3 = [[UIImageView alloc] initWithFrame:CGRectMake((105+6+size.width+15 + 15)*APP_DELEGATE().autoSizeScaleX, 134*APP_DELEGATE().autoSizeScaleY, 12*APP_DELEGATE().autoSizeScaleY, 12*APP_DELEGATE().autoSizeScaleY)];
        icon3.image = [UIImage imageNamed:@"renzhengtubiao"];
        [cell.contentView addSubview:icon3];

        NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        if ([[loginUser objectForKey:@"is_auth"] intValue]==0||[[loginUser objectForKey:@"is_auth"] intValue]==3)//没有实名认证
        {
            icon3.hidden = YES;
        }
        else if ([[loginUser objectForKey:@"is_auth"] intValue]==1)//实名认证审核中
        {
            icon3.hidden = YES;
        }
        else
        {
            icon3.hidden = NO;
        }
            
        
        
    }
    else if (indexPath.section==1&&indexPath.row==0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
        icon1.image = [UIImage imageNamed:@"bangdingyinhangka"];
        [cell.contentView addSubview:icon1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"我的资产";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
    }
    else if (indexPath.section==1&&indexPath.row==1)
    {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(!valueLable1)
        {
            valueLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 106*APP_DELEGATE().autoSizeScaleX, 24*APP_DELEGATE().autoSizeScaleY)];
            valueLable1.numberOfLines = 0;
            valueLable1.textAlignment = NSTextAlignmentCenter;
            valueLable1.font = viewFont2;
            valueLable1.textColor = fontColor;
            UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yueTap:)];
            tapGr.cancelsTouchesInView = YES;
            [valueLable1 addGestureRecognizer:tapGr];
            valueLable1.userInteractionEnabled = YES;
        }
        
        valueLable1.text = @"获取中...";
        if ([userItem objectForKey:@"assets_abled"]!=nil)
        {
            valueLable1.text = [NSString stringWithFormat:@"%@",[userItem objectForKey:@"assets_abled"]];
        }
        [cell.contentView addSubview:valueLable1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 24*APP_DELEGATE().autoSizeScaleY, 106*APP_DELEGATE().autoSizeScaleX, 24*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = viewFont2;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"账户余额";
        [cell.contentView addSubview:titleLable1];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yueTap:)];
        tapGr.cancelsTouchesInView = YES;
        [titleLable1 addGestureRecognizer:tapGr];
        titleLable1.userInteractionEnabled = YES;
        
        //运费卷余额
        if (!valueLable2)
        {
            valueLable2 = [[UILabel alloc] initWithFrame:CGRectMake(107*APP_DELEGATE().autoSizeScaleX, 0, 107*APP_DELEGATE().autoSizeScaleX, 24*APP_DELEGATE().autoSizeScaleY)];
            valueLable2.numberOfLines = 0;
            valueLable2.textAlignment = NSTextAlignmentCenter;
            valueLable2.font = viewFont2;
            valueLable2.textColor = fontColor;
            UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yunfeijuanTap:)];
            tapGr2.cancelsTouchesInView = YES;
            [valueLable2 addGestureRecognizer:tapGr2];
            valueLable2.userInteractionEnabled = YES;
        }
        
        valueLable2.text = @"获取中...";
        if ([userItem objectForKey:@"assets_abled"]!=nil)
        {
           
            valueLable2.text = [NSString stringWithFormat:@"%.2f", [[userItem objectForKey:@"freight_voucher_amount"] floatValue]+[[userItem objectForKey:@"freight_voucher_give_amount"] floatValue]];
        }
        [cell.contentView addSubview:valueLable2];
        
        UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(107*APP_DELEGATE().autoSizeScaleX, 24*APP_DELEGATE().autoSizeScaleY, 107*APP_DELEGATE().autoSizeScaleX, 24*APP_DELEGATE().autoSizeScaleY)];
        titleLable2.numberOfLines = 0;
        titleLable2.textAlignment = NSTextAlignmentCenter;
        titleLable2.font = viewFont2;
        titleLable2.textColor = fontColor;
        titleLable2.text = @"运费券余额";
        [cell.contentView addSubview:titleLable2];
        
        UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yunfeijuanTap:)];
        tapGr2.cancelsTouchesInView = YES;
        [titleLable2 addGestureRecognizer:tapGr2];
        titleLable2.userInteractionEnabled = YES;
        
        //优惠券
        if (!valueLable3)
        {
            valueLable3 = [[UILabel alloc] initWithFrame:CGRectMake(214*APP_DELEGATE().autoSizeScaleX, 0, 107*APP_DELEGATE().autoSizeScaleX, 24*APP_DELEGATE().autoSizeScaleY)];
            valueLable3.numberOfLines = 0;
            valueLable3.textAlignment = NSTextAlignmentCenter;
            valueLable3.font = viewFont2;
            valueLable3.textColor = fontColor;
            UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(youhuijuanTap:)];
            tapGr2.cancelsTouchesInView = YES;
            [valueLable3 addGestureRecognizer:tapGr2];
            valueLable3.userInteractionEnabled = YES;
        }
        
        valueLable3.text = @"获取中...";
        if ([userItem objectForKey:@"coupon_num"]!=nil)
        {
            valueLable3.text = [NSString stringWithFormat:@"%@",[userItem objectForKey:@"coupon_num"]];
        }
        [cell.contentView addSubview:valueLable3];
        
        UILabel *titleLable3 = [[UILabel alloc] initWithFrame:CGRectMake(214*APP_DELEGATE().autoSizeScaleX, 24*APP_DELEGATE().autoSizeScaleY, 107*APP_DELEGATE().autoSizeScaleX, 24*APP_DELEGATE().autoSizeScaleY)];
        titleLable3.numberOfLines = 0;
        titleLable3.textAlignment = NSTextAlignmentCenter;
        titleLable3.font = viewFont2;
        titleLable3.textColor = fontColor;
        titleLable3.text = @"优惠券";
        [cell.contentView addSubview:titleLable3];
        
        UITapGestureRecognizer *tapGr3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(youhuijuanTap:)];
        tapGr3.cancelsTouchesInView = YES;
        [titleLable3 addGestureRecognizer:tapGr3];
        titleLable3.userInteractionEnabled = YES;
        
        
        
        UILabel *fgx1 = [[UILabel alloc] initWithFrame:CGRectMake(107*APP_DELEGATE().autoSizeScaleX, 0, 1, 48*APP_DELEGATE().autoSizeScaleY)];
        fgx1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx1];
        
        UILabel *fgx2 = [[UILabel alloc] initWithFrame:CGRectMake(214*APP_DELEGATE().autoSizeScaleX, 0, 1, 48*APP_DELEGATE().autoSizeScaleY)];
        fgx2.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx2];
        
        
    }
    else if (indexPath.section==2&&indexPath.row==0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
        icon1.image = [UIImage imageNamed:@"wodedingdan"];
        [cell.contentView addSubview:icon1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"我的订单";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
    }
    //    else if (indexPath.section==2&&indexPath.row==1)
    //    {
    //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //
    //        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12, 25, 25)];
    //        icon1.image = [UIImage imageNamed:@"shoujiandizhi"];
    //        [cell.contentView addSubview:icon1];
    //
    //        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48)];
    //        titleLable1.numberOfLines = 0;
    //        titleLable1.textAlignment = NSTextAlignmentLeft;
    //        titleLable1.font = viewFont1;
    //        titleLable1.textColor = fontColor;
    //        titleLable1.text = @"收件人地址";
    //        [cell.contentView addSubview:titleLable1];
    //
    //        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    //        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    //        [cell.contentView addSubview:fgx];
    //    }
    else if (indexPath.section==2&&indexPath.row==1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
        icon1.image = [UIImage imageNamed:@"fahuodizhi"];
        [cell.contentView addSubview:icon1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"发件人地址";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
    }
    else if (indexPath.section==2&&indexPath.row==2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
        icon1.image = [UIImage imageNamed:@"grzx_shouhuorendianhua"];
        [cell.contentView addSubview:icon1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"常用收货电话";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
    }

    else if (indexPath.section==2&&indexPath.row==3)
    {
        NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        if ([[loginUser objectForKey:@"cust_relations_type"] intValue]==1||[[loginUser objectForKey:@"cust_relations_type"] intValue]==2)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
            icon1.image = [UIImage imageNamed:@"grzx_wdyg"];
            [cell.contentView addSubview:icon1];
            
            UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
            titleLable1.numberOfLines = 0;
            titleLable1.textAlignment = NSTextAlignmentLeft;
            titleLable1.font = viewFont1;
            titleLable1.textColor = fontColor;
            titleLable1.text = @"我的员工";
            [cell.contentView addSubview:titleLable1];
            
            UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
            fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
            [cell.contentView addSubview:fgx];

        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
            icon1.image = [UIImage imageNamed:@"anquanshezhi"];
            [cell.contentView addSubview:icon1];
            
            UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
            titleLable1.numberOfLines = 0;
            titleLable1.textAlignment = NSTextAlignmentLeft;
            titleLable1.font = viewFont1;
            titleLable1.textColor = fontColor;
            titleLable1.text = @"安全设置";
            [cell.contentView addSubview:titleLable1];
            
            UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
            fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
            [cell.contentView addSubview:fgx];

        }
      
    }
    else if (indexPath.section==2&&indexPath.row==4)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
        icon1.image = [UIImage imageNamed:@"anquanshezhi"];
        [cell.contentView addSubview:icon1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"安全设置";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
    }
    else if (indexPath.section==3&&indexPath.row==0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
        icon1.image = [UIImage imageNamed:@"wodebaobiao"];
        [cell.contentView addSubview:icon1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"我的报表";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
    }
    else if (indexPath.section==3&&indexPath.row==1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
        icon1.image = [UIImage imageNamed:@"fahuotongji"];
        [cell.contentView addSubview:icon1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"发货统计";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
    }
    else if (indexPath.section==3&&indexPath.row==2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY, 25*APP_DELEGATE().autoSizeScaleY)];
        icon1.image = [UIImage imageNamed:@"yaoqinghaoyou"];
        [cell.contentView addSubview:icon1];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"邀请好友赚豆豆";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
    }
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0)
    {
        NSLog(@"用户资料");
        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.userInfo = userItem;
    }
    else if (indexPath.section==1&&indexPath.row==0)
    {
        NSLog(@"我的资产");
        PersonalAssetsViewController *vc =[[PersonalAssetsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section==2&&indexPath.row==0)
    {
        NSLog(@"我的订单");
        OrdersViewController *vc =[[OrdersViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //    else if (indexPath.section==2&&indexPath.row==1)
    
    //    {
    //        NSLog(@"收件人地址");
    //        ChangYongGetAddressViewController *vc = [[ChangYongGetAddressViewController alloc] init];
    //        vc.isSetting = YES;
    //        [self.navigationController pushViewController:vc animated:YES];
    //
    //    }
    else if (indexPath.section==2&&indexPath.row==1)
    {
        NSLog(@"发件人地址");
        ChangYongSendAddressViewController *vc = [[ChangYongSendAddressViewController alloc] init];
        vc.isSetting = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (indexPath.section==2&&indexPath.row==2)
    {
        NSLog(@"常用收货电话");
        ShouHuoDianHuaViewController *vc = [[ShouHuoDianHuaViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    else if (indexPath.section==2&&indexPath.row==3)
    {
        NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        if ([[loginUser objectForKey:@"cust_relations_type"] intValue]==1||[[loginUser objectForKey:@"cust_relations_type"] intValue]==2)
        {
            NSLog(@"我的员工");
            WoDeYuanGongViewController *vc = [[WoDeYuanGongViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        }
        else
        {
            SafetySettingViewController *vc = [[SafetySettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
       
        
    }

    else if (indexPath.section==2&&indexPath.row==4)
    {
        NSLog(@"安全设置");
        SafetySettingViewController *vc = [[SafetySettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    else if (indexPath.section==3&&indexPath.row==0)
    {
        NSLog(@"我的报表");
    }
    else if (indexPath.section==3&&indexPath.row==1)
    {
        NSLog(@"发货统计");
        StatisticsViewController *vc = [[StatisticsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section==3&&indexPath.row==2)
    {
        NSLog(@"邀请好友赚豆豆");
    }
}

- (void)yueTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"余额");
    AccountBalanceViewController *vc = [[AccountBalanceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)youhuijuanTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"优惠卷");
    CouponshowViewController *vc = [[CouponshowViewController alloc] init];
    YLLWhiteNavViewController *nav = [[YLLWhiteNavViewController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)yunfeijuanTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"运费卷 模拟支付");
    CarriageViewController *vc = [[CarriageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
    
}


@end
