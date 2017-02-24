//
//  LoginViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "HomePageViewController.h"
#import "CustomIOSAlertView.h"
@interface LoginViewController ()<WJSegmentMenuDelegate,UITextFieldDelegate,CustomIOSAlertViewDelegate>
{
    UILabel *topLabel;   //上面的描述文字
    UILabel *downLabel;  //下面的描述文字
    
    UITextField *accountText;   //手机号
    UITextField *passWordText;   //密码
    UIImageView *codeView;
    UITextField *imageText;   //图形验证码
    
    UITextField *mobileText;     //快捷登录手机号
    UITextField *verificationText;  //验证码
    
    SSNCountdownButton *verificationBtn;  //倒计时按钮
    
    UIView *bgView;  //背景
    
    BOOL isShowIMG;
    
}
@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isShowIMG=NO;
    }
    return self;
}

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
   
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"fanhuijianfanhui" highIcon:@"fanhuijianfanhui" target:self action:@selector(pop:)];
    [self initView];
   
    [self initByAccountView];
[APP_DELEGATE() storyBoradAutoLay:self.view];
}

/**
 *  @author 徐杨
 *
 *  视图加载
 */
- (void)initView
{
    WJSegmentMenu *segmentMenu = [[WJSegmentMenu alloc]initWithFrame:CGRectMake(0, 1, 320, 30)];
    segmentMenu.delegate = self;
    [segmentMenu segmentWithTitles:@[@"账号登录",@"手机号快捷登录"]];
    [self.view addSubview:segmentMenu];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, 320, 77)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    topLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 38)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = fontColor;
    topLabel.textAlignment = NSTextAlignmentLeft;
    topLabel.lineBreakMode = NSLineBreakByWordWrapping;
    topLabel.numberOfLines = 0;
    topLabel.font = viewFont1;
    topLabel.text = @"手机";
    [bgView addSubview:topLabel];
    
    accountText = [[UITextField alloc] init];
    accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
    accountText.borderStyle = UITextBorderStyleNone;
    accountText.frame = CGRectMake(65, 0, 240, 38);
    accountText.delegate = self;
    accountText.placeholder = @"手机号";
    accountText.returnKeyType = UIReturnKeyDone;
    accountText.keyboardType = UIKeyboardTypeNumberPad;
    accountText.font = viewFont1;
    [bgView addSubview:accountText];
    
    
    mobileText = [[UITextField alloc] init];
    mobileText.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileText.borderStyle = UITextBorderStyleNone;
    mobileText.frame = CGRectMake(65, 0, 240, 38);
    mobileText.delegate = self;
    mobileText.placeholder = @"手机号";
    mobileText.returnKeyType = UIReturnKeyDone;
    mobileText.font = viewFont1;
    mobileText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:mobileText];
    mobileText.hidden = YES;
    
    UIView *fgx = [[UIView alloc] initWithFrame:CGRectMake(15, 38, 290, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [bgView addSubview:fgx];
    
    downLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, 60, 38)];
    downLabel.backgroundColor = [UIColor clearColor];
    downLabel.textColor = fontColor;
    downLabel.textAlignment = NSTextAlignmentLeft;
    downLabel.lineBreakMode = NSLineBreakByWordWrapping;
    downLabel.numberOfLines = 0;
    downLabel.font = viewFont1;
    downLabel.text = @"密码";
    [bgView addSubview:downLabel];
    
    passWordText = [[UITextField alloc] init];
    passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordText.borderStyle = UITextBorderStyleNone;
    passWordText.frame = CGRectMake(65, 39, 240, 38);
    passWordText.delegate = self;
    passWordText.placeholder = @"请输入密码";
    passWordText.returnKeyType = UIReturnKeyDone;
    passWordText.font = viewFont1;
    passWordText.secureTextEntry = YES;
    [bgView addSubview:passWordText];
    
    verificationText = [[UITextField alloc] init];
    verificationText.clearButtonMode = UITextFieldViewModeWhileEditing;
    verificationText.borderStyle = UITextBorderStyleNone;
    verificationText.frame = CGRectMake(65, 39, 180, 38);
    verificationText.delegate = self;
    verificationText.placeholder = @"请输入验证码";
    verificationText.returnKeyType = UIReturnKeyDone;
    verificationText.keyboardType = UIKeyboardTypeNumberPad;
    verificationText.font = viewFont1;
    [bgView addSubview:verificationText];
     verificationText.hidden = YES;

    
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
    verificationBtn.hidden = YES;

    
    UIButton *RegisterBtn = [[UIButton alloc] initWithFrame: CGRectMake(15, 110, 60, 40)];
    [RegisterBtn addTarget:self
                    action:@selector(RegisterBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
    RegisterBtn.titleLabel.font = viewFont1;
    [self.view addSubview:RegisterBtn];
    
    UILabel *RegisterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    RegisterLabel.backgroundColor = [UIColor clearColor];
    RegisterLabel.textColor = fontColor;
    RegisterLabel.textAlignment = NSTextAlignmentLeft;
    RegisterLabel.lineBreakMode = NSLineBreakByWordWrapping;
    RegisterLabel.numberOfLines = 0;
    RegisterLabel.font = viewFont1;
    RegisterLabel.text = @"注册";
    [RegisterBtn addSubview:RegisterLabel];
    
    
    
    UIButton *forgetPasswordBtn = [[UIButton alloc] initWithFrame: CGRectMake(245, 110, 60, 40)];
    [forgetPasswordBtn addTarget:self
                          action:@selector(forgetPasswordBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    forgetPasswordBtn.titleLabel.font = viewFont1;
    forgetPasswordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:forgetPasswordBtn];
    
    UILabel *forgetPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    forgetPasswordLabel.backgroundColor = [UIColor clearColor];
    forgetPasswordLabel.textColor = fontColor;
    forgetPasswordLabel.textAlignment = NSTextAlignmentRight;
    forgetPasswordLabel.lineBreakMode = NSLineBreakByWordWrapping;
    forgetPasswordLabel.numberOfLines = 0;
    forgetPasswordLabel.font = viewFont1;
    forgetPasswordLabel.text = @"忘记密码";
    [forgetPasswordBtn addSubview:forgetPasswordLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 155, 250, 34)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateHighlighted];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self
                 action:@selector(loginBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = viewFont1;
    [self.view addSubview:loginBtn];
    
    
    
    //暂时屏蔽三方登录的界面
    
//    fgx = [[UIView alloc] initWithFrame:CGRectMake(40, 360, 240, 1)];
//    fgx.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
//    [self.view addSubview:fgx];
//    
//    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -15, 240, 30)];
//    infoLabel.backgroundColor = [UIColor clearColor];
//    infoLabel.textColor = fontColor;
//    infoLabel.textAlignment = NSTextAlignmentCenter;
//    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    infoLabel.numberOfLines = 0;
//    infoLabel.font =viewFont1;
//    infoLabel.text = @"第三方登录";
//    [fgx addSubview:infoLabel];
//    
//    UIButton *wxBtn = [[UIButton alloc] initWithFrame: CGRectMake(90, 395, 30, 30)];
//    [wxBtn setBackgroundImage:[UIImage imageNamed:@"wechat-icon"] forState:UIControlStateNormal];
//    [wxBtn setBackgroundImage:[UIImage imageNamed:@"wechat-icon"] forState:UIControlStateHighlighted];
//    [wxBtn addTarget:self
//                action:@selector(wxBtnClick:)
//      forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wxBtn];
//    
//    UIButton *wbBtn = [[UIButton alloc] initWithFrame: CGRectMake(145, 395, 30, 30)];
//    [wbBtn setBackgroundImage:[UIImage imageNamed:@"weibo-icon"] forState:UIControlStateNormal];
//    [wbBtn setBackgroundImage:[UIImage imageNamed:@"weibo-icon"] forState:UIControlStateHighlighted];
//    [wbBtn addTarget:self
//              action:@selector(wbBtnClick:)
//    forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wbBtn];
//    
//    UIButton *qqBtn = [[UIButton alloc] initWithFrame: CGRectMake(200, 395, 30, 30)];
//    [qqBtn setBackgroundImage:[UIImage imageNamed:@"qq-icon"] forState:UIControlStateNormal];
//    [qqBtn setBackgroundImage:[UIImage imageNamed:@"qq-icon"] forState:UIControlStateHighlighted];
//    [qqBtn addTarget:self
//              action:@selector(qqBtnClick:)
//    forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:qqBtn];
}


/**
 *  @author 徐杨
 *
 *  账号密码登录视图切换
 */
- (void)initByAccountView
{
    [self.view endEditing:YES];
    topLabel.text = @"账号";
    downLabel.text = @"密码";
    verificationBtn.hidden = YES;
    accountText.hidden = NO;
    passWordText.hidden = NO;
    mobileText.hidden = YES;
    verificationText.hidden = YES;
    
    mobileText.text=@"";
    verificationText.text=@"";
    
//    mobileText.text = @"13668156766";
    
}

/**
 *  @author 徐杨
 *
 *  验证码登录视图切换
 */
- (void)initByMobileView
{
    [self.view endEditing:YES];
    topLabel.text = @"手机号";
    downLabel.text = @"验证码";
    verificationBtn.hidden = NO;
    accountText.hidden = YES;
    passWordText.hidden = YES;
    mobileText.hidden = NO;
    verificationText.hidden = NO;
    
    accountText.text=@"";
    passWordText.text=@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  忘记密码点击事件
 *
 *  @param sender
 */
- (void)forgetPasswordBtnClick:(id)sender
{
    NSLog(@"忘记密码");
    ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  登录按钮点击事件
 *
 *  @param sender
 */
- (void)loginBtnClick:(id)sender
{
    if ([downLabel.text isEqualToString:@"密码"])
    {
         [self.view endEditing:YES];
        NSLog(@"账号密码登录");
        if ([AppTool validateMobile:accountText.text]==NO)
        {
            [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
            return;
        }
        
        if(passWordText.text.length==0)
        {
            [MBProgressHUD showError:@"请填写密码" toView:self.view];
            return;
        }
        
        if (isShowIMG==YES)
        {
//            [UIAlertView showAlert:@"弹出验证码" cancelButton:@"好"];
            
            [self showCodeView];
            return;
        }
       
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         accountText.text,@"phone",
                                         passWordText.text,@"password",
                                         @"3",@"loginType",
                                         nil];
        
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        
        
        [helper Post:loginByPwdURL Parameters:paramDic Success:^(id responseObject)
         {
             
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
                     [MBProgressHUD showAutoMessage:@"登录成功,请去个人中心设置密码"];
                 }
                 else
                 {
                     [MBProgressHUD showAutoMessage:@"登录成功"];
                 }
                 
                 
                 [self.navigationController dismissViewControllerAnimated:YES completion:^{
                     //                     APP_DELEGATE().tabBarVc.selectedIndex = 3;
                 }];
                 
             }
             else
             {
                 if (((response *)obj.responses[0]).flag.intValue==-2)
                 {
                     isShowIMG = YES;
                   [self showCodeView];
                     return;
                 }
                 else
                 {
                     isShowIMG = NO;
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
                
             }
             
             
             NSLog(@"%@",responseObject);
         } Failure:^(NSError *error)
         {
             NSLog(@"%@",error);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MBProgressHUD showError:@"登录失败,网络异常" toView:self.view];
         }];
    }
    else
    {
        NSLog(@"手机验证码登录");
        if ([AppTool validateMobile:mobileText.text]==NO)
        {
            [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
            return;
        }
        
        if(verificationText.text.length==0)
        {
            [MBProgressHUD showError:@"请填写验证码" toView:self.view];
            return;
        }
        
        [self.view endEditing:YES];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             mobileText.text,@"phone",
                                             verificationText.text,@"verificationCode",
                                             @"3",@"loginType",
                                             nil];
        
         NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        
        
        [helper Post:loginURL Parameters:paramDic Success:^(id responseObject)
         {
             
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
                 [MBProgressHUD showAutoMessage:@"登录成功"];
                 
                  NSDictionary *item = ((response *)obj.responses[0]).items[0];
                 
           
                 NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];
                 if([cookiesdata length]) {
                     NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
                     NSHTTPCookie *cookie;
                     for (cookie in cookies) {
                         [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                     }  
                 }
                
                 [[NSUserDefaults standardUserDefaults] setObject:item forKey:kLoginUser];
                    [[NSUserDefaults standardUserDefaults] setObject:item forKey:kUserInfo];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                     APP_DELEGATE().tabBarVc.selectedIndex = 3;
                     if ([[item objectForKey:@"is_login_pwd"] intValue]!=1)
                     {
                         [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_noPassWord object:nil userInfo:nil];

                         
                     }
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
}

- (void)showCodeView
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    UIView *alertBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 160)];
//    bgview.backgroundColor = [UIColor redColor];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 280, 25)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = fontColor;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.lineBreakMode = NSLineBreakByWordWrapping;
    label1.numberOfLines = 0;
    label1.font = viewFont1;
    label1.text = @"请输入图片中的内容";
    [alertBGView addSubview:label1];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 280, 25)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = fontColor;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.lineBreakMode = NSLineBreakByWordWrapping;
    label2.numberOfLines = 0;
    label2.font = viewFont2;
    label2.text = @"安全验证,点击图片换一张";
    [alertBGView addSubview:label2];
    
    codeView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 75, 100, 35)];
    NSString *urlString = [NSString stringWithFormat:@"%@/customer/common/imageAction.do?phone=%@",customerServerUrl,accountText.text];
    NSURL *url = [NSURL URLWithString: urlString];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    codeView.image=imagea;
    [alertBGView addSubview:codeView];
    
    UITapGestureRecognizer *tapGr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeViewTap:)];
    tapGr2.cancelsTouchesInView = YES;
    [codeView addGestureRecognizer:tapGr2];
    codeView.userInteractionEnabled = YES;
    alertBGView.userInteractionEnabled = YES;
    
    if (!imageText)
    {
        imageText = [[UITextField alloc] init];
        imageText.backgroundColor = [UIColor whiteColor];
        imageText.clearButtonMode = UITextFieldViewModeWhileEditing;
        imageText.borderStyle = UITextBorderStyleNone;
        imageText.frame = CGRectMake(15, 120, 250, 25);
        imageText.delegate = self;
        imageText.placeholder = @"请输入4位验证码";
        imageText.returnKeyType = UIReturnKeyDone;
        imageText.keyboardType = UIKeyboardTypeDefault;
        imageText.font = viewFont1;
        
    }
    [alertBGView addSubview:imageText];
    
    
    [alertView setContainerView:alertBGView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
//    [alertView setDelegate:self];
    [alertView setUseMotionEffects:true];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        if (buttonIndex==1)
        {
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             accountText.text,@"phone",
                                             passWordText.text,@"password",
                                             imageText.text,@"verification",
                                             @"3",@"loginType",
                                             nil];
            
            NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
            
            
            [helper Post:loginByPwdURL Parameters:paramDic Success:^(id responseObject)
             {
                 
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
                         [MBProgressHUD showAutoMessage:@"登录成功,请去个人中心设置密码"];
                     }
                     else
                     {
                         [MBProgressHUD showAutoMessage:@"登录成功"];
                     }
                     
                     
                     [self.navigationController dismissViewControllerAnimated:YES completion:^{
                         //                     APP_DELEGATE().tabBarVc.selectedIndex = 3;
                     }];
                     
                 }
                 else
                 {
                     isShowIMG = NO;
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
        [alertView close];
    }];
    // And launch the dialog
    [alertView show];

}

- (void)codeViewTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"刷新验证码");
    NSString *urlString = [NSString stringWithFormat:@"%@/customer/common/imageAction.do?phone=%@",customerServerUrl,accountText.text];
    NSURL *url = [NSURL URLWithString: urlString];
    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    codeView.image=imagea;
    
}

/**
 *  @author 徐杨
 *
 *  微信登录点击
 *
 *  @param sender
 */
- (void)wxBtnClick:(id)sender
{
    NSLog(@"微信");
}

/**
 *  @author 徐杨
 *
 *  微博登录点击
 *
 *  @param sender
 */
- (void)wbBtnClick:(id)sender
{
    NSLog(@"微博");
}

/**
 *  @author 徐杨
 *
 *  qq登录点击
 *
 *  @param sender
 */
- (void)qqBtnClick:(id)sender
{
    NSLog(@"qq");
}

/**
 *  @author 徐杨
 *
 *  获取验证码按钮点击事件
 *
 *  @param sender
 */
- (void)verificationBtnClick:(id)sender
{
    
    
    [self.view endEditing:YES];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     mobileText.text,@"phone",
                                     @"1",@"type",
                                     nil];
    
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    [MBProgressHUD showMessag:@"" toView:self.view];
    
    [helper Post:verificationCodURL Parameters:paramDic Success:^(id responseObject)
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
 *  返回按钮点击
 *
 *  @param sender
 */
- (void)pop:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        
    }];
}

/**
 *  @author 徐杨
 *
 *  选项卡点击
 *
 *  @param index
 *  @param title
 */
- (void)segmentWithIndex:(NSInteger)index title:(NSString *)title
{
    if (index==1)
    {
        NSLog(@"手机号快捷登录");
        [self initByMobileView];
    }
    else
    {
       
       
        NSLog(@"账号登录");
        
        [self initByAccountView];
    }
}

/**
 *  @author 徐杨
 *
 *  键盘return事件
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
