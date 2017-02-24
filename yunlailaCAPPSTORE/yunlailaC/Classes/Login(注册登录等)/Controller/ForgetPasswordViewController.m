//
//  ForgetPasswordViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPassword2ViewController.h"
@interface ForgetPasswordViewController ()<UITextFieldDelegate>
{
    UITextField *accountText; //手机号
    UITextField *verificationText; //验证码
   
    SSNCountdownButton *verificationBtn; //获取验证码
}
@end

@implementation ForgetPasswordViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    if (IsIOS7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"忘记密码";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"fanhuijianfanhui" highIcon:@"fanhuijianfanhui" target:self action:@selector(pop:)];

    
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @author 徐杨
 *
 *  界面初始化
 */
- (void)initView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 38*2+2)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 38)];
    oneLabel.backgroundColor = [UIColor clearColor];
    oneLabel.textColor = fontColor;
    oneLabel.textAlignment = NSTextAlignmentLeft;
    oneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    oneLabel.numberOfLines = 0;
    oneLabel.font = viewFont1;
    oneLabel.text = @"手机号";
    [bgView addSubview:oneLabel];
    
    accountText = [[UITextField alloc] init];
    accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountText.borderStyle = UITextBorderStyleNone;
    accountText.frame = CGRectMake(65, 0, 240, 38);
    accountText.delegate = self;
    accountText.placeholder = @"输入手机号";
    accountText.returnKeyType = UIReturnKeyDone;
    accountText.font = viewFont1;
    accountText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:accountText];
    
    UIView *fgx1 = [[UIView alloc] initWithFrame:CGRectMake(15, 38, 290, 1)];
    fgx1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [bgView addSubview:fgx1];
    
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, 60, 38)];
    twoLabel.backgroundColor = [UIColor clearColor];
    twoLabel.textColor = fontColor;
    twoLabel.textAlignment = NSTextAlignmentLeft;
    twoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    twoLabel.numberOfLines = 0;
    twoLabel.font = viewFont1;
    twoLabel.text = @"验证码";
    [bgView addSubview:twoLabel];
    
    verificationText = [[UITextField alloc] init];
    verificationText.clearButtonMode = UITextFieldViewModeWhileEditing;
    verificationText.borderStyle = UITextBorderStyleNone;
    verificationText.frame = CGRectMake(65, 39, 180, 38);
    verificationText.delegate = self;
    verificationText.placeholder = @"请输入验证码";
    verificationText.returnKeyType = UIReturnKeyDone;
    verificationText.font = viewFont1;
    verificationText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:verificationText];
    
    verificationBtn = [[SSNCountdownButton alloc] initWithFrame: CGRectMake(240, 39, 80, 39)];
    [verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verificationBtn setTitle:@"获取验证码" forState:UIControlStateHighlighted];
    [verificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [verificationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:106/255.0 green:144/255.0 blue:245/255.0 alpha:1]] forState:UIControlStateNormal];
    [verificationBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:106/255.0 green:144/255.0 blue:245/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [verificationBtn addTarget:self
                        action:@selector(verificationBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
    verificationBtn.titleLabel.font = viewFont1;
    [bgView addSubview:verificationBtn];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 120, 250, 34)];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [submitBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
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

/**
 *  @author 徐杨
 *
 *  返回事件
 *
 *  @param sender
 */
- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  @author 徐杨
 *
 *  获取验证码点击
 *
 *  @param sender
 */
- (void)verificationBtnClick:(id)sender
{
    [self.view endEditing:YES];
    
    if ([AppTool validateMobile:accountText.text]==NO)
    {
        [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
        return;
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     accountText.text,@"phone",
                                     @"11",@"type",
                                     nil];
    
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    [MBProgressHUD showMessag:@"" toView:self.view];
    
    [helper Post:verificationCodURL Parameters:paramDic Success:^(id responseObject)
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

         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             [MBProgressHUD showSuccess:@"获取验证码成功" toView:self.view];
             [(SSNCountdownButton *)sender beginCountdownWithTime:60 normalTitle:@"获取验证码" timeUnit:@"s" normalColor:[UIColor colorWithRed:106/255 green:144/255 blue:245/255 alpha:1] inColor:[UIColor colorWithRed:106/255.0 green:144/255.0 blue:245/255.0 alpha:1] animated:YES];
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
         [MBProgressHUD showError:@"获取验证码失败,网络异常" toView:self.view];
     }];

}


/**
 *  @author 徐杨
 *
 *  下一步按钮点击
 *
 *  @param sender
 */
- (void)submitBtnClick:(id)sender
{
    NSLog(@"忘记密码");
    if ([AppTool validateMobile:accountText.text]==NO)
    {
        [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
        return;
    }
    if (verificationText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写验证码"];
        return;
    }
    [UIAlertView showAlert:@"是否确认并且提交？" delegate:self cancelButton:@"取消" otherButton:@"提交" tag:1];
    
}

/**
 *  @author 徐杨
 *
 *  下一步选项选择事件
 *
 *  @param alertView
 *  @param buttonIndex
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"下一步");
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_real_name_authen",@"funcId",
                                         accountText.text,@"phone",
                                         verificationText.text,@"validate_code",
                                         nil];
        
        [helper Post:forgetPwdStep1URL Parameters:paramDic Success:^(id responseObject)
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

             if (((response *)obj.responses[0]).flag.intValue==1)
             {
                 [MBProgressHUD showAutoMessage:@"手机认证成功"];
                 NSDictionary *item = ((response *)obj.responses[0]).items[0];
                 
                 ForgetPassword2ViewController *vc =[[ForgetPassword2ViewController alloc] init];
                 vc.forget_code = [item objectForKey:@"forget_code"];
                 vc.cust_id = [item objectForKey:@"cust_id"];
                 [self.navigationController pushViewController:vc animated:YES];
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
             [MBProgressHUD showError:@"手机认证失败" toView:self.view];
         }];
        
    }
    else
    {
        NSLog(@"取消");
    }
    
}

/**
 *  @author 徐杨
 *
 *  键盘事件
 *
 *  @param textField
 *
 *  @return 
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
