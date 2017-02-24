//
//  RegisterViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField *accountText;   //手机号
    UITextField *verificationText;  //验证码
    UITextField *passWordText;   //密码
    UITextField *rePassWordText;  //确认密码
    
     SSNCountdownButton *verificationBtn;
    
    UIButton *agreeBtn;
    UIButton *loginBtn;
}
@end

@implementation RegisterViewController
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
    self.title = @"注册";
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 38*4+3)];
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
    accountText.frame = CGRectMake(80, 0, 220, 38);
    accountText.delegate = self;
    accountText.placeholder = @"输入手机号";
    accountText.returnKeyType = UIReturnKeyDone;
    accountText.keyboardType = UIKeyboardTypeNumberPad;
    accountText.font = viewFont1;
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
    verificationText.frame = CGRectMake(80, 39, 160, 38);
    verificationText.delegate = self;
    verificationText.placeholder = @"请输入验证码";
    verificationText.returnKeyType = UIReturnKeyDone;
    verificationText.font = viewFont1;
    verificationText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:verificationText];
    
    verificationBtn = [[SSNCountdownButton alloc] initWithFrame: CGRectMake(240, 39, 80, 38)];
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

    
    
    UIView *fgx2 = [[UIView alloc] initWithFrame:CGRectMake(15, 77, 290, 1)];
    fgx2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [bgView addSubview:fgx2];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 78, 60, 38)];
    threeLabel.backgroundColor = [UIColor clearColor];
    threeLabel.textColor = fontColor;
    threeLabel.textAlignment = NSTextAlignmentLeft;
    threeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    threeLabel.numberOfLines = 0;
    threeLabel.font = viewFont1;
    threeLabel.text = @"密码";
    [bgView addSubview:threeLabel];
    
    passWordText = [[UITextField alloc] init];
    passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordText.borderStyle = UITextBorderStyleNone;
    passWordText.frame = CGRectMake(80, 78, 220, 38);
    passWordText.delegate = self;
    passWordText.placeholder = @"请输入密码";
    passWordText.returnKeyType = UIReturnKeyDone;
    passWordText.font = viewFont1;
    passWordText.secureTextEntry = YES;
    [bgView addSubview:passWordText];

    
    UIView *fgx3 = [[UIView alloc] initWithFrame:CGRectMake(15, 117, 290, 1)];
    fgx3.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [bgView addSubview:fgx3];
    
    UILabel *fourLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 118, 60, 38)];
    fourLabel.backgroundColor = [UIColor clearColor];
    fourLabel.textColor = fontColor;
    fourLabel.textAlignment = NSTextAlignmentLeft;
    fourLabel.lineBreakMode = NSLineBreakByWordWrapping;
    fourLabel.numberOfLines = 0;
    fourLabel.font = viewFont1;
    fourLabel.text = @"确认密码";
    [bgView addSubview:fourLabel];
    
    rePassWordText = [[UITextField alloc] init];
    rePassWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    rePassWordText.borderStyle = UITextBorderStyleNone;
    rePassWordText.frame = CGRectMake(80, 118, 220, 38);
    rePassWordText.delegate = self;
    rePassWordText.placeholder = @"请确认密码";
    rePassWordText.returnKeyType = UIReturnKeyDone;
    rePassWordText.font = viewFont1;
    rePassWordText.secureTextEntry = YES;
    [bgView addSubview:rePassWordText];
//
    agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(0, 160 ,40, 40);
    [agreeBtn setImage:[[UIImage imageNamed:@"待完成"] imageByScalingToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [agreeBtn setImage:[[UIImage imageNamed:@"已完成"] imageByScalingToSize:CGSizeMake(10, 10)] forState:UIControlStateSelected];
    [agreeBtn addTarget:self
               action:@selector(agreeBtnClick:)
     forControlEvents:UIControlEventTouchUpInside];
    agreeBtn.selected = YES;
    [self.view addSubview:agreeBtn];

    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 165, 100, 30)];
    agreeLabel.numberOfLines = 0;
    agreeLabel.textAlignment = NSTextAlignmentLeft;
    agreeLabel.font = viewFont3;
    agreeLabel.textColor = fontColor;
    agreeLabel.text = @"我同意";
    [self.view addSubview:agreeLabel];
    
    UILabel *clauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 165, 200, 30)];
    clauseLabel.numberOfLines = 0;
    clauseLabel.textAlignment = NSTextAlignmentLeft;
    clauseLabel.font = viewFont3;
    clauseLabel.textColor = titleViewColor;
    clauseLabel.text = @"《托运邦运单契约条款》";
    [self.view addSubview:clauseLabel];
    
    clauseLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clauseLabelTap:)];
    tapGr.cancelsTouchesInView = YES;
    [clauseLabel addGestureRecognizer:tapGr];
    
    loginBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 200, 250, 34)];
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    [loginBtn setTitle:@"注册" forState:UIControlStateHighlighted];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self
                 action:@selector(RegisterBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = viewFont1;
    [self.view addSubview:loginBtn];
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
 *  条款点击进web
 *
 *  @param tapGr
 */
- (void)clauseLabelTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"条款");
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"托运邦运单契约条款";
    vc.webURL = [NSString stringWithFormat:@"%@",contractClauseURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  @author 徐杨
 *
 *  获取验证码点击事件
 *
 *  @param sender
 */
- (void)verificationBtnClick:(id)sender
{
    [self.view endEditing:YES];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     accountText.text,@"phone",
                                     @"7",@"type",
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
 *  同意协议点击事件
 *
 *  @param sender
 */
- (void)agreeBtnClick:(id)sender
{
    agreeBtn.selected = !agreeBtn.selected;
    if (agreeBtn.selected==NO)
    {
        loginBtn.enabled = NO;
    }
    else
    {
        loginBtn.enabled = YES;
    }
    

}

/**
 *  @author 徐杨
 *
 *  注册按钮点击事件
 *
 *  @param sender
 */
- (void)RegisterBtnClick:(id)sender
{
    NSLog(@"去注册");
    [self.view endEditing:YES];
    if ([AppTool validateMobile:accountText.text]==NO)
    {
        [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
        return;
    }
    
    if(verificationText.text.length==0)
    {
        [MBProgressHUD showError:@"请填写验证码" toView:self.view];
        return;
    }
    if(passWordText.text.length<6||passWordText.text.length>16)
    {
        [MBProgressHUD showError:@"请填写6-16位密码" toView:self.view];
        return;
    }
    if(rePassWordText.text.length<6||rePassWordText.text.length>16)
    {
        [MBProgressHUD showError:@"请确认密码" toView:self.view];
        return;
    }
    if(![passWordText.text isEqualToString:rePassWordText.text])
    {
        [MBProgressHUD showError:@"确认密码错误" toView:self.view];
        return;
    }
    if(agreeBtn.selected==NO)
    {
        [MBProgressHUD showError:@"请同意托运邦运单契约条款" toView:self.view];
        return;
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     accountText.text,@"phone",
                                     verificationText.text,@"verificationCode",
                                     passWordText.text,@"login_pwd",
                                     rePassWordText.text,@"confirm_pwd",
                                     @"3",@"loginType",
                                     nil];
    
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    [MBProgressHUD showMessag:@"" toView:self.view];
    [helper Post:registerURL Parameters:paramDic Success:^(id responseObject)
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
             
             NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];
             if([cookiesdata length]) {
                 NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
                 NSHTTPCookie *cookie;
                 for (cookie in cookies) {
                     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                 }
             }
             NSDictionary *item = ((response *)obj.responses[0]).items[0];
             [[NSUserDefaults standardUserDefaults] setObject:item forKey:kLoginUser];
                [[NSUserDefaults standardUserDefaults] setObject:item forKey:kUserInfo];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             if ([[item objectForKey:@"is_login_pwd"] intValue]!=1)
             {
                [MBProgressHUD showAutoMessage:@"注册成功,请去个人中心设置密码"];
             }
             else
             {
                [MBProgressHUD showAutoMessage:@"注册成功,请去个人中心设置密码"];
             }

             
             [self.navigationController dismissViewControllerAnimated:YES completion:^{
                 ((YLLTabBarController *)self.view.window.rootViewController).selectedIndex = 3;
             }];
             
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
         [MBProgressHUD showError:@"登录失败,网络异常" toView:self.view];
     }];
    

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
