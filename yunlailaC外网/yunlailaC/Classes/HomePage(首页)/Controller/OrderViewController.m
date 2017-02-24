//
//  DingDanInfoViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "OrderViewController.h"
#import "WaybillsViewController.h"
@interface OrderViewController ()
{
    UIScrollView *scrollView;
    
    UILabel *driverLabel;  //司机
    UILabel *driverPhoneLabel; //司机电话
    
    UILabel *plateLabel;  //车牌
    
    UILabel *indentLabel;  //订单编号
    UILabel *productNameLabel; //货物名称
    
    UILabel *indentDateLabel; //订单时间
    UILabel *numberLabel;   //货物数量
    
    NSMutableDictionary *currentOrder;
}
@end

@implementation OrderViewController
@synthesize order;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        currentOrder = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/**
 *  @author 徐杨
 *
 *  传参
 *
 *  @param orderp <#orderp description#>
 */
- (void)setOrder:(NSDictionary *)orderp
{
    order = orderp;
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [scrollView.mj_header beginRefreshing];//下拉刷新
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,self.view.frame.size.height-statusViewHeight-TabbarHeight)];
    scrollView.backgroundColor = bgViewColor;
    scrollView.contentSize = CGSizeMake(320, self.view.frame.size.height-statusViewHeight);
    [self.view addSubview:scrollView];
    
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @author 徐杨
 *
 *  请求数据
 */
- (void)loadData
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_driver_indent_information",@"funcId",
                                     [order objectForKey:@"indent_id"],@"indent_id",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         [scrollView.mj_header endRefreshing];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
         if (obj.global.flag.intValue==-4001)
         {
             [MBProgressHUD showAutoMessage:@"登录失效，请重新登录，然后跳登陆页面"];
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
             [currentOrder removeAllObjects];
             [currentOrder setDictionary:((response *)obj.responses[0]).items[0]];
            [self initView];
         }
         else
         {
             NSRange range = [((response *)obj.responses[0]).message rangeOfString:@"UnknownHostException"];
             if (range.location !=NSNotFound)
             {
                 [MBProgressHUD showError:@"网络异常" toView:self.view];
             }
             else
             {
                 [MBProgressHUD showError:((response *)obj.responses[0]).message toView:self.view];
             }
         }
         NSLog(@"%@",responseObject);
         
     } Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
         [scrollView.mj_header endRefreshing];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.noDataImage.hidden = NO;
         [self.view bringSubviewToFront:self.noDataImage];
         
     }];
    
}

/**
 *  @author 徐杨
 *
 *  初始化导航条
 */
- (void)setUpNav
{
    self.title = @"订单详情";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

/**
 *  @author 徐杨
 *
 *  初始化视图
 */
- (void) initView
{
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 5*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 88*APP_DELEGATE().autoSizeScaleY)];
    bg1.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg1];
    
    UIImageView *dingdanstatusImg = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 22*APP_DELEGATE().autoSizeScaleY, 290*APP_DELEGATE().autoSizeScaleX, 44*APP_DELEGATE().autoSizeScaleY)];
    //    1提交订单状态2司机接单状态3为完成状态4取消订单
    if ([[currentOrder objectForKey:@"status"] intValue]==1)
    {
        dingdanstatusImg.image = [UIImage imageNamed:@"ddxq_1"];
    }
    else if ([[currentOrder objectForKey:@"status"] intValue]==2)
    {
        dingdanstatusImg.image = [UIImage imageNamed:@"ddxq_2"];
    }
    else if ([[currentOrder objectForKey:@"status"] intValue]==3)
    {
        dingdanstatusImg.image = [UIImage imageNamed:@"ddxq_3"];
    }
    
    else if ([[currentOrder objectForKey:@"status"] intValue]==4)
    {
        dingdanstatusImg.image = [UIImage imageNamed:@"ddxq_qxdd"];
        dingdanstatusImg.frame = CGRectMake(76*APP_DELEGATE().autoSizeScaleX, 22*APP_DELEGATE().autoSizeScaleY, 170*APP_DELEGATE().autoSizeScaleX, 44*APP_DELEGATE().autoSizeScaleY);
    }
    
    
    [bg1 addSubview:dingdanstatusImg];
    
    UILabel *status1Label = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 93*APP_DELEGATE().autoSizeScaleY, 120*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
    status1Label.backgroundColor = [UIColor clearColor];
    status1Label.textColor = fontColor;
    status1Label.textAlignment = NSTextAlignmentLeft;
    status1Label.lineBreakMode = NSLineBreakByWordWrapping;
    status1Label.numberOfLines = 0;
    status1Label.font = viewFont1;
    status1Label.text = @"司机信息";
    [scrollView addSubview:status1Label];
    
    UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 123*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 114*APP_DELEGATE().autoSizeScaleY)];
    bg2.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg2];
    
    //司机
    UIImageView *driverIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, (37*APP_DELEGATE().autoSizeScaleY-15)/2, 15, 15)];
    driverIcon.image = [UIImage imageNamed:@"dsk_shouhuoren"];
    [bg2 addSubview:driverIcon];
    
    driverLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*APP_DELEGATE().autoSizeScaleX, 0, 260*APP_DELEGATE().autoSizeScaleX, 37*APP_DELEGATE().autoSizeScaleY)];
    driverLabel.backgroundColor = [UIColor clearColor];
    driverLabel.textColor = fontColor;
    driverLabel.textAlignment = NSTextAlignmentLeft;
    driverLabel.lineBreakMode = NSLineBreakByWordWrapping;
    driverLabel.numberOfLines = 0;
    driverLabel.font = viewFont1;
    driverLabel.text = [NSString stringWithFormat:@"司机：%@",[currentOrder objectForKey:@"driver_name"]];
    [bg2 addSubview:driverLabel];
    
    UILabel *fgx1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 38*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1*APP_DELEGATE().autoSizeScaleY)];
    fgx1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bg2 addSubview:fgx1];
    
    //司机电话
    UIImageView *driverPhoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, (114*APP_DELEGATE().autoSizeScaleY-15)/2, 15, 15)];
    driverPhoneIcon.image = [UIImage imageNamed:@"ddxq_dianhua"];
    [bg2 addSubview:driverPhoneIcon];
    
    driverPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY, 260*APP_DELEGATE().autoSizeScaleX, 37*APP_DELEGATE().autoSizeScaleY)];
    driverPhoneLabel.backgroundColor = [UIColor clearColor];
    driverPhoneLabel.textColor = fontColor;
    driverPhoneLabel.textAlignment = NSTextAlignmentLeft;
    driverPhoneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    driverPhoneLabel.numberOfLines = 0;
    driverPhoneLabel.font = viewFont1;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"电话：%@",[currentOrder objectForKey:@"driver_phone"]]];
    [str addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(0,3)];
    [str addAttribute:NSForegroundColorAttributeName value:fontOrangeColor range:NSMakeRange(3,str.length-3)];
    driverPhoneLabel.attributedText = str;
    
    [bg2 addSubview:driverPhoneLabel];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(driverPhoneTap:)];
    tapGr.cancelsTouchesInView = YES;
    [driverPhoneLabel addGestureRecognizer:tapGr];
    driverPhoneLabel.userInteractionEnabled = YES;
    bg2.userInteractionEnabled = YES;
    
    UILabel *fgx2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 76*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1*APP_DELEGATE().autoSizeScaleY)];
    fgx2.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bg2 addSubview:fgx2];
    
    //车牌
    UIImageView *plateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, (190*APP_DELEGATE().autoSizeScaleY-15)/2, 15, 15)];
    plateIcon.image = [UIImage imageNamed:@"ddxq_chepai"];
    [bg2 addSubview:plateIcon];
    
    plateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*APP_DELEGATE().autoSizeScaleX, 78*APP_DELEGATE().autoSizeScaleY, 260*APP_DELEGATE().autoSizeScaleX, 37*APP_DELEGATE().autoSizeScaleY)];
    plateLabel.backgroundColor = [UIColor clearColor];
    plateLabel.textColor = fontColor;
    plateLabel.textAlignment = NSTextAlignmentLeft;
    plateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    plateLabel.numberOfLines = 0;
    plateLabel.font = viewFont1;
    plateLabel.text = [NSString stringWithFormat:@"车牌：%@",[currentOrder objectForKey:@"car_number"]];
    [bg2 addSubview:plateLabel];


    UILabel *status1Labe2 = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 238*APP_DELEGATE().autoSizeScaleY, 120*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
    status1Labe2.backgroundColor = [UIColor clearColor];
    status1Labe2.textColor = fontColor;
    status1Labe2.textAlignment = NSTextAlignmentLeft;
    status1Labe2.lineBreakMode = NSLineBreakByWordWrapping;
    status1Labe2.numberOfLines = 0;
    status1Labe2.font = viewFont1;
    status1Labe2.text = @"订单信息";
    [scrollView addSubview:status1Labe2];
    
    UIView *bg3 = [[UIView alloc] initWithFrame:CGRectMake(0, 268*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 114*APP_DELEGATE().autoSizeScaleY)];
    bg3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bg3];
    
    //订单编号
    UIImageView *indentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, (37*APP_DELEGATE().autoSizeScaleY-15)/2, 15, 15)];
    indentIcon.image = [UIImage imageNamed:@"dsk_yundanhao"];
    [bg3 addSubview:indentIcon];
    
    indentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*APP_DELEGATE().autoSizeScaleX, 0, 260*APP_DELEGATE().autoSizeScaleX, 37*APP_DELEGATE().autoSizeScaleY)];
    indentLabel.backgroundColor = [UIColor clearColor];
    indentLabel.textColor = fontColor;
    indentLabel.textAlignment = NSTextAlignmentLeft;
    indentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    indentLabel.numberOfLines = 0;
    indentLabel.font = viewFont1;
    indentLabel.text = [NSString stringWithFormat:@"订单编号：%@",[currentOrder objectForKey:@"indent_id"]];
    [bg3 addSubview:indentLabel];
    
    UILabel *fgx3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 38*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1*APP_DELEGATE().autoSizeScaleY)];
    fgx3.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bg3 addSubview:fgx3];
    
    //订单时间
    UIImageView *indentDateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, (114*APP_DELEGATE().autoSizeScaleY-15)/2, 15, 15)];
    indentDateIcon.image = [UIImage imageNamed:@"sh_shijian"];
    [bg3 addSubview:indentDateIcon];
    
    indentDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY, 260*APP_DELEGATE().autoSizeScaleX, 37*APP_DELEGATE().autoSizeScaleY)];
    indentDateLabel.backgroundColor = [UIColor clearColor];
    indentDateLabel.textColor = fontColor;
    indentDateLabel.textAlignment = NSTextAlignmentLeft;
    indentDateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    indentDateLabel.numberOfLines = 0;
    indentDateLabel.font = viewFont1;
    indentDateLabel.text = [NSString stringWithFormat:@"订单时间：%@",[currentOrder objectForKey:@"indent_date"]];
    [bg3 addSubview:indentDateLabel];
    
    UILabel *fgx4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 76*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1*APP_DELEGATE().autoSizeScaleY)];
    fgx4.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bg3 addSubview:fgx4];
    
    //货物名称
    UIImageView *productNameIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, (190*APP_DELEGATE().autoSizeScaleY-15)/2, 15, 15)];
    productNameIcon.image = [UIImage imageNamed:@"sh_huowu"];
    [bg3 addSubview:productNameIcon];
    
    productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*APP_DELEGATE().autoSizeScaleX, 78*APP_DELEGATE().autoSizeScaleY, 260*APP_DELEGATE().autoSizeScaleX, 37*APP_DELEGATE().autoSizeScaleY)];
    productNameLabel.backgroundColor = [UIColor clearColor];
    productNameLabel.textColor = fontColor;
    productNameLabel.textAlignment = NSTextAlignmentLeft;
    productNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    productNameLabel.numberOfLines = 0;
    productNameLabel.font = viewFont1;
    productNameLabel.text = [NSString stringWithFormat:@"货物名称：%@   %@件",[currentOrder objectForKey:@"product_name"],[currentOrder objectForKey:@"number"]];
    [bg3 addSubview:productNameLabel];

  
    if ([[currentOrder objectForKey:@"canCancel"] intValue]==1&&[[currentOrder objectForKey:@"status"] intValue]!=4&&[[currentOrder objectForKey:@"status"] intValue]!=5)
    {
        UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"取消订单" style:UIBarButtonItemStyleDone target:self action:@selector(cancelOrder)];
        self.navigationItem.rightBarButtonItem = changyongItem;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
        UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 392*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY)];
        bg2.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:bg2];
        
        
        UILabel *waybillLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 260*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY)];
        waybillLabel.backgroundColor = [UIColor clearColor];
        waybillLabel.textColor = fontColor;
        waybillLabel.textAlignment = NSTextAlignmentLeft;
        waybillLabel.lineBreakMode = NSLineBreakByWordWrapping;
        waybillLabel.numberOfLines = 0;
        waybillLabel.font = viewFont2;
        waybillLabel.text = @"运单明细";
        [bg2 addSubview:waybillLabel];
        
        UIImageView *icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(300*APP_DELEGATE().autoSizeScaleX, 13*APP_DELEGATE().autoSizeScaleY, 8, 14)];
        icon3.image = [UIImage imageWithName:@"fanhuijian_xiache"];
        [bg2 addSubview:icon3];
        
        
        bg2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(waybillLabelTap:)];
        tapGr.cancelsTouchesInView = YES;
        [bg2 addGestureRecognizer:tapGr];

    }
}

/**
 *  @author 徐杨
 *
 *  运单明细事件
 *
 *  @param tapGr <#tapGr description#>
 */
- (void)waybillLabelTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"运单明细");


    WaybillsViewController *vc = [[WaybillsViewController alloc] init];
    vc.order = currentOrder;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  司机电话点击
 *
 *  @param sender <#sender description#>
 */
- (void)driverPhoneTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"司机电话");
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:[currentOrder objectForKey:@"driver_phone"]]]];

}

/**
 *  @author 徐杨
 *
 *  返回事件
 *
 *  @param sender <#sender description#>
 */
- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
}
/**
 *  @author 徐杨
 *
 *  取消订单
 */
- (void)cancelOrder
{
    NSLog(@"取消订单");
    //    ChangYongSendAddressViewController *vc = [[ChangYongSendAddressViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    [UIAlertView showAlert:@"是否确认并且取消订单？" delegate:self cancelButton:@"取消" otherButton:@"取消订单" tag:1];
}

/**
 *  @author 徐杨
 *
 *  取消订单选择器
 *
 *  @param alertView   <#alertView description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_cancelIndentFunction",@"funcId",
                                         [order objectForKey:@"indent_id"],@"indent_id",
                                         nil];
        
        [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
             if (obj.global.flag.intValue==-4001)
             {
                 [MBProgressHUD showAutoMessage:@"登录失效，请重新登录，然后跳登陆页面"];
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
               
                 [MBProgressHUD showAutoMessage:@"取消订单成功"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 NSRange range = [((response *)obj.responses[0]).message rangeOfString:@"UnknownHostException"];
                 if (range.location !=NSNotFound)
                 {
                     [MBProgressHUD showError:@"网络异常" toView:self.view];
                 }
                 else
                 {
                     [MBProgressHUD showError:((response *)obj.responses[0]).message toView:self.view];
                 }
             }
             NSLog(@"%@",responseObject);
         } Failure:^(NSError *error)
         {
             NSLog(@"%@",error);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD showError:@"取消订单失败" toView:self.view];
         }];

    }
    else
    {
        NSLog(@"取消");
    }

}
@end
