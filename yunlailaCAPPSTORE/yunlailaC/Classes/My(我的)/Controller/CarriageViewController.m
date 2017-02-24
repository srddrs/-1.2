//
//  CarriageViewController.m
//  yunlailaC
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "CarriageViewController.h"
#import "BalanceViewController.h"
#import "AgreementViewController.h"
@interface CarriageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *payInfo;
    NSMutableArray *payArray;
    
    UIView *ModeView;
    UIView *bgView;
    UIButton *WXBtn;
    UIButton *ALiBtn;
    BOOL isWXPay;
    BOOL isAliPay;
    
    UIButton *agreeBtn;
    NSMutableDictionary *xieyiInfo;
    UILabel *clauseLabel;
    
    UIButton *submitBtn;
}
@end

@implementation CarriageViewController
-(void)refreshUserInfo:(NSNotification *)notification
{
    [self getUserInfoAndShowZhiFuOk];
    
}

- (void)getUserInfoAndShowZhiFuOk
{
    //获取用户信息
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_member_queryCustInformationFunction",@"funcId",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         [self endMJ];
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
             
//             
//             [[NSUserDefaults standardUserDefaults] setObject:item forKey:kUserInfo];
//             [[NSUserDefaults standardUserDefaults] synchronize];
             [_tableView reloadData];
             
             YLLWebViewController *vc = [[YLLWebViewController alloc] init];
             vc.webTitle = @"充值成功";
             
             NSString *level;
             if ([[item objectForKey:@"grade_name"] isEqualToString:@"铜牌会员"])
             {
                 level = @"1";
             }
             else if ([[item objectForKey:@"grade_name"] isEqualToString:@"银牌会员"])
             {
                 level = @"2";
             }
             else if ([[item objectForKey:@"grade_name"] isEqualToString:@"金牌会员"])
             {
                 level = @"3";
             }
             else if ([[item objectForKey:@"grade_name"] isEqualToString:@"钻石会员"])
             {
                 level = @"4";
             }
             else
             {
                 level = @"2";
             }

             vc.webURL = [NSString stringWithFormat:@"%@?level=%@&voucherAmount=%@&voucherGiveAmount=%@",RechargeIntroductionURL,level,[NSString stringWithFormat:@"%@",[payInfo objectForKey:@"voucher_amount"]],[NSString stringWithFormat:@"%@",[payInfo objectForKey:@"voucher_give_amount"]]];
             YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
             nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
             [self presentViewController:nav animated:YES completion:nil];
         }
         else
         {
             
         }
         NSLog(@"%@",responseObject);
     } Failure:^(NSError *error)
     {
         [self endMJ];
         NSLog(@"%@",error);
     }];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        payInfo = [[NSMutableDictionary alloc] init];
     
        payArray = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshUserInfo:)
                                                     name:KNOTIFICATION_zhifu
                                                   object:nil];
        xieyiInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    
    [self getuserInfo];
     [self getPayInfo];
    //协议判断
    [self functionxieyi];
}

- (void)getPayInfo
{
    //获取支付信息
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_freightvoucher_queryAllFunction",@"funcId",
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
             NSArray *item = ((response *)obj.responses[0]).items;
             NSLog(@"item:%@",item);
             [payArray removeAllObjects];
             [payArray addObjectsFromArray:item];
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

- (void)getuserInfo
{
    //获取用户信息
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_member_queryCustInformationFunction",@"funcId",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         [self endMJ];
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
          [self endMJ];
         NSLog(@"%@",error);
     }];
}

- (void)functionxieyi
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    //    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_agreement_freightvoucher_custIsAgreeFunction",@"funcId",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
         if (obj.global.flag.intValue==-4001)
         {
             //             [MBProgressHUD showAutoMessage:@"登录失效，请重新登录。"];
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
             //             [MBProgressHUD showAutoMessage:@"该功能暂时已关闭"];
             return;
         }
         if (obj.global.flag.intValue==-4003)
         {
             //             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             return;
         }
         if (obj.global.flag.intValue!=1)
         {
             //             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             return;
         }
         if (((response *)obj.responses[0]).flag.intValue==-20016)
         {
             //             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
            
             return;
         }
         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             NSArray *array = ((response *)obj.responses[0]).items;
             NSLog(@"array:%@",array);
             [xieyiInfo removeAllObjects];
             [xieyiInfo setDictionary:[array objectAtIndex:0]];
             if ([[xieyiInfo objectForKey:@"is_agree"] integerValue]==2)
             {
                 NSLog(@"弹出协议");
                 AgreementViewController *vc = [[AgreementViewController alloc] init];
                 vc.title1 = [xieyiInfo objectForKey:@"agreement_title"];
                 
                 
                 NSString *content=[[xieyiInfo objectForKey:@"agreement_content"] stringByReplacingOccurrencesOfString:@"<br/>"withString:@"\n"];
                 vc.content = content;
                 vc.agreementID = [xieyiInfo objectForKey:@"agreement_id"];
                 YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
                 nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                 [self presentViewController:nav animated:YES completion:nil];
             }
         }
         else
         {
             //-1 忽略
             
         }
         NSLog(@"%@",responseObject);
         
     } Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
         //         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"运费劵余额";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"YFQ-help" highIcon:@"YFQ-help" target:self action:@selector(infoBtnClick:)];
    
    UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"收支明细" style:UIBarButtonItemStyleDone target:self action:@selector(changyong:)];
    self.navigationItem.rightBarButtonItem = changyongItem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self initView];
    [self initModeView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop:(id)sender
{
    if (ModeView.frame.origin.y==0)
    {
        [self closeBtnClick:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - 20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
     _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)loadData
{
    [self getuserInfo];
    [self getPayInfo];
}

- (void)endMJ
{
   [_tableView.mj_header endRefreshing];
}

- (void)initModeView
{
    ModeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    ModeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    ModeView.userInteractionEnabled = YES;
    [self.view addSubview:ModeView];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 270 )];
    bgView.backgroundColor = [UIColor whiteColor];
    [ModeView addSubview:bgView];
    
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(280,0,40,40);
    [closeBtn setImage:[UIImage imageNamed:@"YFQ-quxiao"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"YFQ-quxiao"] forState:UIControlStateSelected];
    [closeBtn addTarget:self
                 action:@selector(closeBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    UIImageView *WXlogo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45, 32, 29)];
    WXlogo.image = [UIImage imageNamed:@"YFQ-weixing"];
    [bgView addSubview:WXlogo];
    
    UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 41,60, 20)];
    titleLable1.numberOfLines = 0;
    titleLable1.textAlignment = NSTextAlignmentLeft;
    titleLable1.font = viewFont2;
    titleLable1.textColor = fontColor;
    titleLable1.text = @"微信支付";
    [bgView addSubview:titleLable1];
    
    UIImageView *WXlogo2 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 45, 26, 12)];
    WXlogo2.image = [UIImage imageNamed:@"YFQ-tuijian"];
    [bgView addSubview:WXlogo2];
    
    UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 58,190, 20)];
    titleLable2.numberOfLines = 0;
    titleLable2.textAlignment = NSTextAlignmentLeft;
    titleLable2.font = viewFont3;
    titleLable2.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
    ;
    titleLable2.text = @"亿万用户的选择,更快更安全";
    [bgView addSubview:titleLable2];
    
    WXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    WXBtn.frame = CGRectMake(280,43,40,40);
    [WXBtn setImage:[UIImage imageNamed:@"YFQ-queren-huise"] forState:UIControlStateNormal];
    [WXBtn setImage:[UIImage imageNamed:@"YFQ-queren"] forState:UIControlStateSelected];
    [WXBtn addTarget:self
                 action:@selector(WXBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    WXBtn.selected = YES;
    [bgView addSubview:WXBtn];

    UIButton *WXBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    WXBtn1.frame = CGRectMake(0,30,320,55);
    [WXBtn1 addTarget:self
              action:@selector(WXBtnClick:)
    forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:WXBtn1];
    
    
    
    UIImageView *ALilogo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 103 , 32, 29)];
    ALilogo.image = [UIImage imageNamed:@"YFQ-zhifubao"];
    [bgView addSubview:ALilogo];
    
    UIImageView *ALilogo2 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 45, 26, 12)];
    ALilogo2.image = [UIImage imageNamed:@"YFQ-tuijian"];
    [bgView addSubview:ALilogo2];
    
    UILabel *titleLable3 = [[UILabel alloc] initWithFrame:CGRectMake(60, 99 ,60, 20)];
    titleLable3.numberOfLines = 0;
    titleLable3.textAlignment = NSTextAlignmentLeft;
    titleLable3.font = viewFont2;
    titleLable3.textColor = fontColor;
    titleLable3.text = @"支付宝";
    [bgView addSubview:titleLable3];
    
    UILabel *titleLable4 = [[UILabel alloc] initWithFrame:CGRectMake(60, 116 ,190, 20)];
    titleLable4.numberOfLines = 0;
    titleLable4.textAlignment = NSTextAlignmentLeft;
    titleLable4.font = viewFont3;
    titleLable4.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
    ;
    titleLable4.text = @"数亿用户都在用,安全可托付";
    [bgView addSubview:titleLable4];
    
    ALiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ALiBtn.frame = CGRectMake(280,103 ,40,40);
    [ALiBtn setImage:[UIImage imageNamed:@"YFQ-queren-huise"] forState:UIControlStateNormal];
    [ALiBtn setImage:[UIImage imageNamed:@"YFQ-queren"] forState:UIControlStateSelected];
    [ALiBtn addTarget:self
              action:@selector(ALiBtnClick:)
    forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:ALiBtn];
//    ALiBtn.selected = YES;
    
    UIButton *ALiBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    ALiBtn1.frame = CGRectMake(0,90,320,55);
    [ALiBtn1 addTarget:self
               action:@selector(ALiBtnClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:ALiBtn1];

    agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(0, 160 ,40, 40);
    [agreeBtn setImage:[[UIImage imageNamed:@"待完成"] imageByScalingToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [agreeBtn setImage:[[UIImage imageNamed:@"已完成"] imageByScalingToSize:CGSizeMake(10, 10)] forState:UIControlStateSelected];
    [agreeBtn addTarget:self
                 action:@selector(agreeBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    agreeBtn.selected = YES;
    [bgView addSubview:agreeBtn];
    
    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 165, 100, 30)];
    agreeLabel.numberOfLines = 0;
    agreeLabel.textAlignment = NSTextAlignmentLeft;
    agreeLabel.font = viewFont3;
    agreeLabel.textColor = fontColor;
    agreeLabel.text = @"我同意";
    [bgView addSubview:agreeLabel];
    
    clauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 165, 200, 30)];
    clauseLabel.numberOfLines = 0;
    clauseLabel.textAlignment = NSTextAlignmentLeft;
    clauseLabel.font = viewFont3;
    clauseLabel.textColor = titleViewColor;
    clauseLabel.text = @"《托运邦运单契约条款》";
    [bgView addSubview:clauseLabel];
    
    clauseLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clauseLabelTap:)];
    tapGr.cancelsTouchesInView = YES;
    [clauseLabel addGestureRecognizer:tapGr];

    
    submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 215 , 250, 34)];
    [submitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [submitBtn setTitle:@"立即支付" forState:UIControlStateHighlighted];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
    [submitBtn addTarget:self
                  action:@selector(submitBtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = viewFont1;
    [bgView addSubview:submitBtn];

}


- (void)changyong:(id)sender
{
//    [self ALiPayFunction];
    BalanceViewController *vc =  [[BalanceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)infoBtnClick:(id)sender
{
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"运费券使用说明";
    vc.webURL = [NSString stringWithFormat:@"%@",instructionsURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2)
    {
        return payArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 100*APP_DELEGATE().autoSizeScaleY;
    }
    else if (indexPath.section==1)
    {
        return 75*APP_DELEGATE().autoSizeScaleY;
    }
    if (indexPath.section==2)
    {
        return 100*APP_DELEGATE().autoSizeScaleY;
    }
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2)
    {
        return 40*APP_DELEGATE().autoSizeScaleY;
    }
    else
    {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    

    
    UIView *hView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320*APP_DELEGATE().autoSizeScaleX, 40*APP_DELEGATE().autoSizeScaleY)];
    hView.backgroundColor = [UIColor whiteColor];
   
    UILabel *fgx1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [hView addSubview:fgx1];
    
    
    
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY, 14*APP_DELEGATE().autoSizeScaleX, 13*APP_DELEGATE().autoSizeScaleY)];
    logo.image = [UIImage imageNamed:@"YFQ-goumai"];
    [hView addSubview:logo];

    UILabel *jieshaolabel1 = [[UILabel alloc] initWithFrame:CGRectMake(34*APP_DELEGATE().autoSizeScaleX, 7*APP_DELEGATE().autoSizeScaleY, 200*APP_DELEGATE().autoSizeScaleX, 25*APP_DELEGATE().autoSizeScaleY)];
    jieshaolabel1.backgroundColor = [UIColor clearColor];
    jieshaolabel1.textColor = fontColor;
    jieshaolabel1.textAlignment = NSTextAlignmentLeft;
    jieshaolabel1.lineBreakMode = NSLineBreakByWordWrapping;
    jieshaolabel1.numberOfLines = 0;
    jieshaolabel1.font = viewFont3;
    jieshaolabel1.text = @"购买运费劵";
    [hView addSubview:jieshaolabel1];

    
    UIImageView *arrowIMG = [[UIImageView alloc] initWithFrame:CGRectMake(210*APP_DELEGATE().autoSizeScaleX, 14*APP_DELEGATE().autoSizeScaleY, 12*APP_DELEGATE().autoSizeScaleX, 12*APP_DELEGATE().autoSizeScaleY)];
    arrowIMG.image = [UIImage imageNamed:@"YFQ-help"];
    [hView addSubview:arrowIMG];
    
    UILabel *jieshaolabel2 = [[UILabel alloc] initWithFrame:CGRectMake(220*APP_DELEGATE().autoSizeScaleX, 7*APP_DELEGATE().autoSizeScaleY, 80*APP_DELEGATE().autoSizeScaleX, 25*APP_DELEGATE().autoSizeScaleY)];
    jieshaolabel2.backgroundColor = [UIColor clearColor];
    jieshaolabel2.textColor = fontOrangeColor;
    jieshaolabel2.textAlignment = NSTextAlignmentRight;
    jieshaolabel2.lineBreakMode = NSLineBreakByWordWrapping;
    jieshaolabel2.numberOfLines = 0;
    jieshaolabel2.font = viewFont3;
    jieshaolabel2.text = @"什么是运费劵";
    [hView addSubview:jieshaolabel2];

    
    
    UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTap:)];
    tapGr2.cancelsTouchesInView = YES;
    [hView addGestureRecognizer:tapGr2];
    hView.userInteractionEnabled = YES;
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 39*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [hView addSubview:fgx];
    return hView;
    
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
    
    if (indexPath.section==0)
    {
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"总余额(元)";
        [cell.contentView addSubview:titleLable1];
        
         NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        
        UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(0*APP_DELEGATE().autoSizeScaleX, 50*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 35*APP_DELEGATE().autoSizeScaleY)];
        titleLable2.numberOfLines = 0;
        titleLable2.textAlignment = NSTextAlignmentCenter;
        titleLable2.font = [UIFont systemFontOfSize:sizeValue(25)];
        titleLable2.textColor = titleViewColor;
        titleLable2.text = [NSString stringWithFormat:@"%.2f", [[userInfo objectForKey:@"freight_voucher_amount"] floatValue]+[[userInfo objectForKey:@"freight_voucher_give_amount"] floatValue]];
        [cell.contentView addSubview:titleLable2];
    }
    else if (indexPath.section==1)
    {
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY, 160*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = viewFont2;
        titleLable1.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
;
        titleLable1.text = @"运费劵余额(元)";
        [cell.contentView addSubview:titleLable1];
        
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        
        UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(0*APP_DELEGATE().autoSizeScaleX, 40*APP_DELEGATE().autoSizeScaleY, 160*APP_DELEGATE().autoSizeScaleX, 35*APP_DELEGATE().autoSizeScaleY)];
        titleLable2.numberOfLines = 0;
        titleLable2.textAlignment = NSTextAlignmentCenter;
        titleLable2.font = viewFont2;
        titleLable2.textColor = fontColor;
        titleLable2.text = [NSString stringWithFormat:@"%.2f", [[userInfo objectForKey:@"freight_voucher_amount"] floatValue]];
        [cell.contentView addSubview:titleLable2];
        
        
        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(160*APP_DELEGATE().autoSizeScaleX, 15*APP_DELEGATE().autoSizeScaleY, 1, 40*APP_DELEGATE().autoSizeScaleY)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
        
        
        UILabel *titleLable3 = [[UILabel alloc] initWithFrame:CGRectMake(160*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY, 160*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
        titleLable3.numberOfLines = 0;
        titleLable3.textAlignment = NSTextAlignmentCenter;
        titleLable3.font = viewFont2;
        titleLable3.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
        ;
        titleLable3.text = @"赠送运输劵(元)";
        [cell.contentView addSubview:titleLable3];
        
        
        UILabel *titleLable4 = [[UILabel alloc] initWithFrame:CGRectMake(160*APP_DELEGATE().autoSizeScaleX, 40*APP_DELEGATE().autoSizeScaleY, 160*APP_DELEGATE().autoSizeScaleX, 35*APP_DELEGATE().autoSizeScaleY)];
        titleLable4.numberOfLines = 0;
        titleLable4.textAlignment = NSTextAlignmentCenter;
        titleLable4.font = viewFont2;
        titleLable4.textColor = fontColor;
        titleLable4.text = [NSString stringWithFormat:@"%.2f", [[userInfo objectForKey:@"freight_voucher_give_amount"] floatValue]];
        [cell.contentView addSubview:titleLable4];
        
        
    }
    else if (indexPath.section==2)
    {
        cell.backgroundColor = [UIColor whiteColor];
        NSDictionary *info = [payArray objectAtIndex:indexPath.row];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 15*APP_DELEGATE().autoSizeScaleY, 64*APP_DELEGATE().autoSizeScaleX, 70*APP_DELEGATE().autoSizeScaleY)];
//        logo.image = [UIImage imageNamed:[info objectForKey:@"img"]];
        
//        "is_use" = 1;
//        "limit_city" = "\U5357\U5145";
//        note = "";
//        "voucher_amount" = "3000.00";
//        "voucher_give_amount" = "0.00";
//        "voucher_icon" = "";
//        "voucher_id" = 1001848855624186881;

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[info objectForKey:@"voucher_icon"]]];
       [logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"YFQ-twenty-thousand"]];
        
        [cell.contentView addSubview:logo];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 5*APP_DELEGATE().autoSizeScaleY, 220*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentRight;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        
        titleLable1.text = [NSString stringWithFormat:@"%@元运费劵",[info objectForKey:@"voucher_amount"]];
        [cell.contentView addSubview:titleLable1];
        
        UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 28*APP_DELEGATE().autoSizeScaleY, 220*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
        titleLable2.numberOfLines = 0;
        titleLable2.textAlignment = NSTextAlignmentRight;
        titleLable2.font = viewFont2;
        titleLable2.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
        ;
        titleLable2.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"limit_city_note"]];
        [cell.contentView addSubview:titleLable2];
        
        UILabel *titleLable3 = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 50*APP_DELEGATE().autoSizeScaleY, 220*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
        titleLable3.numberOfLines = 0;
        titleLable3.textAlignment = NSTextAlignmentRight;
        titleLable3.font = viewFont2;
        titleLable3.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]
        ;
        titleLable3.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"note"]];
        [cell.contentView addSubview:titleLable3];
        
        
        UILabel *qianggouLable = [[UILabel alloc] initWithFrame:CGRectMake(250*APP_DELEGATE().autoSizeScaleX, 75*APP_DELEGATE().autoSizeScaleY, 165*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
        qianggouLable.numberOfLines = 0;
        qianggouLable.textAlignment = NSTextAlignmentCenter;
        qianggouLable.font = viewFont4;
        qianggouLable.textColor = fontOrangeColor;
        [cell.contentView addSubview:qianggouLable];
        qianggouLable.text = @"立即抢购";
        CGSize size = [qianggouLable boundingRectWithSize:CGSizeMake(165*APP_DELEGATE().autoSizeScaleX, 20)];
        qianggouLable.frame = CGRectMake(255*APP_DELEGATE().autoSizeScaleX, 75*APP_DELEGATE().autoSizeScaleY, size.width+10,20*APP_DELEGATE().autoSizeScaleY);
         LRViewBorderRadius(qianggouLable,5,1,fontOrangeColor);
        if (indexPath.row!=payArray.count-1)
        {
            UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 99*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
            fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
            [cell.contentView addSubview:fgx];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
//    vc.webTitle = @"充值成功";
//    
//    NSString *level = @"3";
//    
//    vc.webURL = [NSString stringWithFormat:@"%@?level=%@&voucherAmount=%@&voucherGiveAmount=%@",RechargeIntroductionURL,level,[NSString stringWithFormat:@"%@",[payInfo objectForKey:@"voucher_amount"]],[NSString stringWithFormat:@"%@",[payInfo objectForKey:@"voucher_give_amount"]]];
//    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
//    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:nav animated:YES completion:nil];
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==2)
    {
        [payInfo removeAllObjects];
        NSDictionary *info = [payArray objectAtIndex:indexPath.row];
        [payInfo setDictionary:info];
        
        
        ModeView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView animateWithDuration:0.5
                         animations:^{
                             bgView.frame = CGRectMake(0, self.view.frame.size.height-(270)*APP_DELEGATE().autoSizeScaleY, self.view.frame.size.width, (270)*APP_DELEGATE().autoSizeScaleY);
                             
                         }
                         completion:^(BOOL finished) {
                             NSLog(@"payInfo:%@",payInfo);
                             clauseLabel.text = [NSString stringWithFormat:@"《%@》",[payInfo objectForKey:@"agreement_title"]];
                         }];
        
    }
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    NSString *type;
    if (WXBtn.selected==YES)
    {
        type = @"微信";
    }
    else if (ALiBtn.selected==YES)
    {
        type = @"支付宝";
    }
    else //(ALiBtn.selected==NO&&WXBtn.selected==NO)
    {
        [UIAlertView showAlert:@"请选择支付方式" cancelButton:@"确定"];
        return;
    }

    NSString *info = [NSString stringWithFormat:@"您即将使用%@支付%@元,是否确认支付?",type,[payInfo objectForKey:@"voucher_amount"]];
    [UIAlertView showAlert:info delegate:self cancelButton:@"取消" otherButton:@"确认支付" tag:1];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        
        if (buttonIndex==1)
        {
            NSLog(@"去支付");
             [self closeBtnClick:nil];
            if (WXBtn.selected==YES)
            {
                NSLog(@"微信支付");
                 [self WXPayFunction];
            }
            else if(ALiBtn.selected==YES)
            {
                NSLog(@"支付宝支付");
                [self ALiPayFunction];
            }
        }
        else
        {
            NSLog(@"取消");
        }
    }
       
    
}

- (void)WXPayFunction
{
    if([WXApi isWXAppInstalled]==NO)
    {
        [UIAlertView showAlert:@"没有安装微信" cancelButton:@"知道了"];
        return;
    }
//    PayReq *req             = [[PayReq alloc] init];
//    req.openID              = APP_ID;
//    req.partnerId           = MCH_ID;
//    req.prepayId            = @"wx201609301503066c285e86da0989020110";
//    req.nonceStr            = @"9d5abb58-8199-46cb-b80e-c97e8cfd";
//    req.timeStamp           = 1475218986;
//    req.package             = @"Sign=WXPay";
//    req.sign                = @"21BD7625779B0A880C2161FBAE4DE1E6";
//    
//    BOOL wx = [WXApi sendReq:req];
//    return;
    //支付
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    //    [payInfo objectForKey:@"name"]
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_payment_custRechargesStep1Function",@"funcId",
                                     [payInfo objectForKey:@"voucher_id"],@"voucher_id",
                                     @"2",@"payment_type", //支付平台（1：支付宝；2：微信；3：畅捷支付）
                                     @"1",@"recharge_type", //充值类型（1：固定额度；2：自定义额度）
                                     [payInfo objectForKey:@"voucher_amount"],@"amount",
                                     nil];
   [MBProgressHUD showMessag:@"" toView:self.view];
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
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
         if (((response *)obj.responses[0]).flag.intValue==-20016)
         {
             [MBProgressHUD showAutoMessage:@"该条记录已过期,请重试"];
             [_tableView.mj_header beginRefreshing];
             return;
         }
         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             NSArray *item = ((response *)obj.responses[0]).items;
             NSLog(@"item:%@",item);
             NSDictionary *info = [item objectAtIndex:0];
             if(info !=nil)
             {
                 NSDictionary *pay_info = [info objectForKey:@"pay_info"];
                 if(pay_info!=nil)
                 {
                     NSString *prepayId = [NSString stringWithFormat:@"%@",[pay_info objectForKey:@"prepayid"]];
                     NSString *nonceStr = [NSString stringWithFormat:@"%@",[pay_info objectForKey:@"noncestr"]];
                     int  timeStamp =[[pay_info objectForKey:@"timestamp"] intValue];
                     NSString *package = [NSString stringWithFormat:@"%@",[pay_info objectForKey:@"package"]];
                     NSString *sign =[NSString stringWithFormat:@"%@",[pay_info objectForKey:@"sign"]];
                     
                     NSLog(@"prepayId:%@",prepayId);
                     NSLog(@"nonceStr:%@",nonceStr);
                     NSLog(@"timeStamp:%d",timeStamp);
                     NSLog(@"package:%@",package);
                     NSLog(@"sign:%@",sign);
                     //调起微信支付
                     PayReq *req             = [[PayReq alloc] init];
                     req.openID              = APP_ID;
                     req.partnerId           = MCH_ID;
                     req.prepayId            = prepayId;
                     req.nonceStr            = nonceStr;
                     req.timeStamp           = timeStamp;
                     req.package             = package;
                     req.sign                = sign;
                     
                     BOOL wx = [WXApi sendReq:req];
                     NSLog(@"BOOL:%d",wx);
                 }
             }
             
         }
         else
         {
             
         }
     } Failure:^(NSError *error)
     {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"%@",error);
     }];

    
    
    
    
    

}
//服务点payinfo方式
- (void)ALiPayFunction
{
    //支付
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
//    [payInfo objectForKey:@"name"]
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_payment_custRechargesStep1Function",@"funcId",
                                     [payInfo objectForKey:@"voucher_id"],@"voucher_id",
                                     @"1",@"payment_type", //支付平台（1：支付宝；2：微信；3：畅捷支付）
                                     @"1",@"recharge_type", //充值类型（1：固定额度；2：自定义额度）
                                     [payInfo objectForKey:@"voucher_amount"],@"amount",
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
         if (((response *)obj.responses[0]).flag.intValue==-20016)
         {
             [MBProgressHUD showAutoMessage:@"该条记录已过期,请重试"];
             [_tableView.mj_header beginRefreshing];
             return;
         }
         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             NSArray *item = ((response *)obj.responses[0]).items;
             NSLog(@"item:%@",item);
             NSDictionary *info = [item objectAtIndex:0];
             
             NSString *orderString = [info objectForKey:@"pay_info"];
             if (orderString != nil)
             {
                  NSString *appScheme = @"yunlaila";
                 [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                     NSLog(@"类中 reslut = %@",resultDic);
                     //            NSString *memo = [resultDic objectForKey:@"memo"];
                     //            [UIAlertView showAlert:memo  cancelButton:@"取消"];
                     //            6001 用户取消
                     //             9000 交易成功
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
                    
                     //            [self getuserInfo];
                 }];
             }

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
//本地
//- (void)ALiPayFunction
//{
//    NSString *partner = @"2088121369619516";
//    NSString *seller = @"6403796@qq.com";
//    NSString *privateKey = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBAPNJMaoNJiDASFMt+b0ARwvNewbTwC6GLpJN0MGQEz6NcZ1XCOks6yO4MbUDoprnoi3ByCn4xrHa+ccQI/x2O4cZHS85wdfD219puJWjr9ndJhQrRuSk9FEPlgAwdcUJdW0rPr8DQT3pSt6iUxRchPYKRtxO6oQnrlZoTC+ozLQxAgMBAAECgYEA0O344sssBVBcTGLdaHzGhtJOZ0yObOX7NNXzA2gRvtSFz9Og6W8T+LcEqSmYCWQHmTgkCDeHm9IsU9H+tZ9r+irnMAQf26Z6qhwCrRiS9kKfB0Aidf3KwxH9FRPPHiSJ6auhDqqMjssC3l/qLtjkaCUS8Gpu7FKIhpQAJPdFX8kCQQD6hPAzJ5pVk87WtHKPhHbQeO/4fTie42g7w8j3C0v0G6Jgmc794QasweDRj3AFzGpOP1XqsYrtQmKJw5BKtwNTAkEA+Ju+j3fYVXF0Nzkvm9xbaO7G9RxyB2QLIQSbx2uATIYqpjUR4cqudt3u8oVVMtrIS7+rclXHzB27LJCa95rd6wJBAM7YtPuH14aRZFci5vRZC0FWmc0yl22ZlpbCMUzJpw0HRCs+1AoLotdBvb9KD9S504yH/wipT2xXQ8U8FAec1MECQQDXNCKaGLk5BXP/lc4jknXCeOfbKBuBUFXd6BpdXy55j659n/TxyryJgwYkA81Dr2WxRKLJ332LsLTlF+w9qF6vAkEA66D/VTj7dzr+PpU6HOv/I/ayaTsw4iumDv1zfmuq/KuR2faBiRZrY2aIe/xuxQREKby955LV0eUnNAt2iW7JQQ==";
//    
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.sellerID = seller;
//    //	order.outTradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//    
//    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
//    order.outTradeNO = [NSString stringWithFormat:@"%@_%@",[[NSDate new] localDateTimeYYYYMMddHHmm2],[loginUser objectForKey:@"account_id"]];
//    order.subject = [NSString stringWithFormat:@"%@",[payInfo objectForKey:@"name"]]; //商品标题
//    order.body = [NSString stringWithFormat:@"%@",[payInfo objectForKey:@"desc"]]; //商品描述
////     order.totalFee = [NSString stringWithFormat:@"%.2f",[[payInfo objectForKey:@"totalFee"] floatValue]];
//    order.totalFee = [NSString stringWithFormat:@"%.2f",0.01f];
//    order.notifyURL =  @"http://demo.yunlaila.com.cn/account/payment/alipay/receive_notify.do"; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showURL = @"m.alipay.com";
//    //    out_biz_no
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"yunlaila";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"类中 reslut = %@",resultDic);
//            //            NSString *memo = [resultDic objectForKey:@"memo"];
//            //            [UIAlertView showAlert:memo  cancelButton:@"取消"];
//            //            6001 用户取消
//            //             9000 交易成功
//            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_zhifu object:nil userInfo:resultDic];
////            [self getuserInfo];
//        }];
//    }
//
//}
- (void)closeBtnClick:(id)sender
{
    NSLog(@"关拨打界面");
    
    [UIView animateWithDuration:0.5
                     animations:^{
                      bgView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, (270-70)*APP_DELEGATE().autoSizeScaleY);
                     }
                     completion:^(BOOL finished) {
                         ModeView.frame = CGRECT_NO_NAV(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }];
    
}

- (void)WXBtnClick:(id)sender
{
    if (WXBtn.selected==NO)
    {
        WXBtn.selected = !WXBtn.selected;
    }
    ALiBtn.selected = NO;
}

- (void)ALiBtnClick:(id)sender
{
    if (ALiBtn.selected==NO)
    {
        ALiBtn.selected = !ALiBtn.selected;
    }
    WXBtn.selected = NO;
}

- (void)openTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"优惠卷");
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"运费券使用说明";
    vc.webURL = [NSString stringWithFormat:@"%@",CouponIntroductionURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)agreeBtnClick:(id)sender
{
    agreeBtn.selected = !agreeBtn.selected;
    if (agreeBtn.selected ==NO)
    {
        submitBtn.enabled = NO;
    }
    else
    {
        submitBtn.enabled = YES;
    }
}

- (void)clauseLabelTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"条款");
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = [payInfo objectForKey:@"agreement_title"];
    
    vc.webURL = [NSString stringWithFormat:@"%@?agreementId=%@",AgreementURL,[payInfo objectForKey:@"voucher_id"]];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}
@end
