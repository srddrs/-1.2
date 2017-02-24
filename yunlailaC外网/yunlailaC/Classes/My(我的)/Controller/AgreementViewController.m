//
//  AgreementViewController.m
//  yunlailaC
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()
{
    UITextView *textView;
}
@end

@implementation AgreementViewController
@synthesize title1;
@synthesize content;
@synthesize agreementID;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.title = title1;
    textView.text = content;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运费购买协议";
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)pop:(id)sender
{
    [self.navigationController  dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)initView{

    //正文
    textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, 290, 440)];
    textView.font = viewFont1;
    textView.text = @"";
    textView.editable = NO;
    textView.textColor = fontColor;
    textView.backgroundColor = bgViewColor;
    [self.view addSubview:textView];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 455, 250, 34)];
    [submitBtn setTitle:@"我已阅读并同意该协议" forState:UIControlStateNormal];
    [submitBtn setTitle:@"我已阅读并同意该协议" forState:UIControlStateHighlighted];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
    [submitBtn addTarget:self
                  action:@selector(submitBtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = viewFont1;
    [self.view addSubview:submitBtn];
}

- (void)submitBtnClick:(id)sender
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    //    [payInfo objectForKey:@"name"]
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_agreement_freightvoucher_custAgreeFunction",@"funcId",
                                     agreementID,@"agreement_id",
                                     nil];
    [MBProgressHUD showMessag:@"" toView:self.view];
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
            
             [self.navigationController  dismissViewControllerAnimated:YES completion:^{
                 
             }];
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
@end
