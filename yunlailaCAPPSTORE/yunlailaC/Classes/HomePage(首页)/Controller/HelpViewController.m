//
//  HelpViewController.m
//  yunlailaC
//
//  Created by admin on 16/11/24.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "HelpViewController.h"
#import "SetPayPassWordViewController.h"
#import "AddBankCardViewController.h"
#import "ManageBankCardViewController.h"
#import "CollectingViewController.h"
#import "AddBankCard1ViewController.h"
@interface HelpViewController ()
{
    UIScrollView *scrollView; //首页根视图
    BOOL wancheng1;
    BOOL wancheng2;
    BOOL wancheng3;
    
    UIImageView *wanchengImg1;
    UIImageView *wanchengImg2;
    UIImageView *wanchengImg3;
    
    BOOL isBoos;
    int is_auth;
}
@end

@implementation HelpViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        wancheng1 = NO;
        wancheng2 = NO;
        wancheng3 = NO;
        isBoos = NO;
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_querySetInfoFunction",@"funcId",
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
              if ([[item objectForKey:@"ralation_type"] intValue]==3)
              {
                  isBoos = NO;
              }
             else
             {
                 isBoos = YES;
             }
             is_auth = [[item objectForKey:@"is_auth"] intValue];
             if ([[item objectForKey:@"is_pay_pwd"] intValue]==1)
             {
                 //设置了支付密码
                 wancheng1 = YES;
                 wanchengImg1.hidden = NO;
             }
             else
             {
                 wancheng1 = NO;
                 wanchengImg1.hidden = YES;
             }
             
             if ([[item objectForKey:@"is_auth"] intValue]==2)
             {
                 //设置了实名认证
                 wancheng2 = YES;
                 wanchengImg2.hidden = NO;
             }
             else
             {
                 wancheng2 = NO;
                 wanchengImg2.hidden = YES;
             }
             
             if ([[item objectForKey:@"bank_card_number"] intValue]>0)
             {
                 //添加了银行卡
                 wancheng3 = YES;
                 wanchengImg3.hidden = NO;
             }
             else
             {
                 wancheng3 = NO;
                 wanchengImg3.hidden = YES;
             }
             
             if (wancheng1==NO)
             {
                 if ([[item objectForKey:@"ralation_type"] intValue]==3)
                 {
                     [UIAlertView showAlert:@"请通知您的老板设置支付密码" cancelButton:@"确定"];
                 }
                 else
                 {
                     [UIAlertView showAlert:@"您还没有设置支付密码！" delegate:self cancelButton:@"先等等" otherButton:@"去设置" tag:1];
                 }
                 return;

             }

             if (wancheng2==NO)
             {
                 if ([[item objectForKey:@"ralation_type"] intValue]==3)
                 {
                     [UIAlertView showAlert:@"请通知您的老板实名认证" cancelButton:@"确定"];
                 }
                 else
                 {
                      if ([[item objectForKey:@"is_auth"] intValue]==0)
                      {
                          [UIAlertView showAlert:@"您还没有实名认证！" delegate:self cancelButton:@"先等等" otherButton:@"去实名" tag:2];
                      }
                      else  if ([[item objectForKey:@"is_auth"] intValue]==1)
                      {
                          [UIAlertView showAlert:@"实名认证中，请耐心等待" cancelButton:@"确定"];
                      }
                      else  if ([[item objectForKey:@"is_auth"] intValue]==3)
                      {
                           [UIAlertView showAlert:@"实名认证失败，请重新实名认证" delegate:self cancelButton:@"先等等" otherButton:@"去实名" tag:2];
                      }

                     
                 }
                 return;

             }
             
             if (wancheng3==NO)
             {
                 if ([[item objectForKey:@"ralation_type"] intValue]==3)
                 {
                     [UIAlertView showAlert:@"请通知您的老板添加银行卡" cancelButton:@"确定"];
                 }
                 else
                 {
                     [UIAlertView showAlert:@"您还没有添加银行卡！" delegate:self cancelButton:@"先等等" otherButton:@"去添加" tag:3];
                 }

                 return;
             }
             
             if (wancheng1==YES&&wancheng2==YES&&wancheng3==YES)
             {
                 UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(changyong:)];
                 self.navigationItem.rightBarButtonItem = changyongItem;
                 [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
                 [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
             }
             
         }
         else
         {
             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
         }
         NSLog(@"%@",responseObject);
     } Failure:^(NSError *error)
     {
         [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
     }];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTitle];
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initTitle
{
    self.title = @"代收款领取引导";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void)initView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-statusViewHeight-TabbarHeight)];
    scrollView.backgroundColor = bgViewColor;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (0 + 225 + 42 + 168 + 45 + 165 + 50 + 132 +132)*APP_DELEGATE().autoSizeScaleY);
    [self.view addSubview:scrollView];
    scrollView.userInteractionEnabled = YES;
    
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 225)];
    imgView1.image = [UIImage imageNamed:@"picture-one"];
    [scrollView addSubview:imgView1];
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 + 225, 320, 42)];
    imgView2.image = [UIImage imageNamed:@"picture-two"];
    [scrollView addSubview:imgView2];

    imgView2.userInteractionEnabled = YES;
    UIButton *shezi1Btn = [[UIButton alloc] initWithFrame: CGRectMake(0,0,320,42)];
    [shezi1Btn addTarget:self
                  action:@selector(shezi1BtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [imgView2 addSubview:shezi1Btn];
    
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 + 225 + 42, 320, 168)];
    imgView3.image = [UIImage imageNamed:@"picture-three"];
    [scrollView addSubview:imgView3];

    
    UIImageView *imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 + 225 + 42 + 168, 320, 45)];
    imgView4.image = [UIImage imageNamed:@"picture-four"];
    [scrollView addSubview:imgView4];
    
    imgView4.userInteractionEnabled = YES;
    UIButton *shezi2Btn = [[UIButton alloc] initWithFrame: CGRectMake(0,0,320,45)];
    [shezi2Btn addTarget:self
                  action:@selector(shezi2BtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [imgView4 addSubview:shezi2Btn];

    
    UIImageView *imgView5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 + 225 + 42 + 168 + 45, 320, 165)];
    imgView5.image = [UIImage imageNamed:@"picture-five"];
    [scrollView addSubview:imgView5];

    
    UIImageView *imgView6 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 + 225 + 42 + 168 + 45 + 165, 320, 50)];
    imgView6.image = [UIImage imageNamed:@"picture-six"];
    [scrollView addSubview:imgView6];

    
    imgView6.userInteractionEnabled = YES;
    UIButton *shezi3Btn = [[UIButton alloc] initWithFrame: CGRectMake(0,0,320,50)];
    [shezi3Btn addTarget:self
                  action:@selector(shezi3BtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [imgView6 addSubview:shezi3Btn];
    
    
    UIImageView *imgView7 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 + 225 + 42 + 168 + 45 + 165 + 50, 320, 132)];
    imgView7.image = [UIImage imageNamed:@"picture-seven"];
    [scrollView addSubview:imgView7];
    
    wanchengImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(255,-15, 50, 50)];
    wanchengImg1.image = [UIImage imageNamed:@"pictue-eight"];
    [imgView3 addSubview:wanchengImg1];
    wanchengImg1.hidden = YES;
    
    wanchengImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(255,-15, 50, 50)];
    wanchengImg2.image = [UIImage imageNamed:@"pictue-eight"];
    [imgView5 addSubview:wanchengImg2];
    wanchengImg2.hidden = YES;
    
    wanchengImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(255,-15, 50, 50)];
    wanchengImg3.image = [UIImage imageNamed:@"pictue-eight"];
    [imgView7 addSubview:wanchengImg3];
    wanchengImg3.hidden = YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        if (alertView.tag==1)
        {
            
            SetPayPassWordViewController *vc = [[SetPayPassWordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        }
        else if (alertView.tag==2)
        {
            
            AddBankCardViewController *vc = [[AddBankCardViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        else if (alertView.tag==3)
        {
            ManageBankCardViewController *vc = [[ManageBankCardViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
            
        }
        else if (alertView.tag==4) //修改实名认证
        {
            
            AddBankCard1ViewController *vc = [[AddBankCard1ViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)changyong:(id)sender
{
    CollectingViewController *vc = [[CollectingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)shezi1BtnClick:(id)sender
{
    NSLog(@"设置支付密码");
    if(wancheng1==YES)
    {
        [UIAlertView showAlert:@"您已经设置了支付密码" cancelButton:@"确定"];
    }
    else
    {
        if (isBoos==YES)
        {
            SetPayPassWordViewController *vc = [[SetPayPassWordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [UIAlertView showAlert:@"请通知您的老板设置支付密码" cancelButton:@"确定"];
        }
    }
}

- (void)shezi2BtnClick:(id)sender
{
    NSLog(@"实名认证");
    if(wancheng2==YES)
    {
        [UIAlertView showAlert:@"您已经实名认证" cancelButton:@"确定"];
    }
    else
    {
        if (isBoos==YES)
        {
           
            if (is_auth==0)
            {
                [UIAlertView showAlert:@"您还没有实名认证！" delegate:self cancelButton:@"先等等" otherButton:@"去实名" tag:2];
            }
            else  if (is_auth==1)
            {
                [UIAlertView showAlert:@"实名认证中，请耐心等待" cancelButton:@"确定"];
            }
            else  if (is_auth==3)
            {
                [UIAlertView showAlert:@"实名认证失败，请重新实名认证" delegate:self cancelButton:@"先等等" otherButton:@"去实名" tag:4];
            }
        }
        else
        {
            [UIAlertView showAlert:@"请通知您的老板实名认证" cancelButton:@"确定"];
        }
    }

}

- (void)shezi3BtnClick:(id)sender
{
    NSLog(@"绑定银行卡");
    if(wancheng3==YES)
    {
        [UIAlertView showAlert:@"您已经绑定银行卡" cancelButton:@"确定"];
    }
    else
    {
        if (isBoos==YES)
        {
            ManageBankCardViewController *vc = [[ManageBankCardViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            [UIAlertView showAlert:@"请通知您的老板绑定银行卡" cancelButton:@"确定"];
        }
    }

}
- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
}
@end
