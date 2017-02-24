//
//  SetPayPassWordViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "SetPayPassWordViewController.h"

@interface SetPayPassWordViewController ()<UITextFieldDelegate>
{
    UITextField *shoujihaoText;
    UITextField *yanzhengmaText;
    UITextField *mimaText;
    UITextField *querenmimaText;
    
    SSNCountdownButton *verificationBtn;
    

}
@end

@implementation SetPayPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付密码";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
    
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    shoujihaoText = [[UITextField alloc] init];
    shoujihaoText.clearButtonMode = UITextFieldViewModeWhileEditing;
    shoujihaoText.borderStyle = UITextBorderStyleNone;
    shoujihaoText.frame = CGRectMake(85, 0, 220, 38);
    shoujihaoText.delegate = self;
    shoujihaoText.placeholder = @"输入手机号";
    shoujihaoText.keyboardType = UIKeyboardTypeNumberPad;
    shoujihaoText.returnKeyType = UIReturnKeyDone;
    shoujihaoText.font = viewFont1;
    [bgView addSubview:shoujihaoText];
    
    NSDictionary *item = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
    NSString *account_id = [item objectForKey:@"account_id"];
    shoujihaoText.text = account_id;
    shoujihaoText.enabled = NO;
    
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
    
    yanzhengmaText = [[UITextField alloc] init];
    yanzhengmaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    yanzhengmaText.borderStyle = UITextBorderStyleNone;
    yanzhengmaText.frame = CGRectMake(85, 39, 160, 38);
    yanzhengmaText.delegate = self;
    yanzhengmaText.placeholder = @"请输入验证码";
    yanzhengmaText.returnKeyType = UIReturnKeyDone;
    yanzhengmaText.font = viewFont1;
    yanzhengmaText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:yanzhengmaText];
    
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
    
    mimaText = [[UITextField alloc] init];
    mimaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    mimaText.borderStyle = UITextBorderStyleNone;
    mimaText.frame = CGRectMake(85, 78, 220, 38);
    mimaText.delegate = self;
    mimaText.placeholder = @"请输入6位密码";
    mimaText.returnKeyType = UIReturnKeyDone;
    mimaText.font = viewFont1;
    mimaText.secureTextEntry = YES;
    mimaText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:mimaText];
    
    
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
    
    querenmimaText = [[UITextField alloc] init];
    querenmimaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    querenmimaText.borderStyle = UITextBorderStyleNone;
    querenmimaText.frame = CGRectMake(85, 118, 220, 38);
    querenmimaText.delegate = self;
    querenmimaText.placeholder = @"请再次输入密码";
    querenmimaText.returnKeyType = UIReturnKeyDone;
    querenmimaText.font = viewFont1;
    querenmimaText.secureTextEntry = YES;
    querenmimaText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:querenmimaText];
    
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 200, 250, 34)];
    [loginBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [loginBtn setTitle:@"确认提交" forState:UIControlStateHighlighted];
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

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)verificationBtnClick:(id)sender
{
    if ([AppTool validateMobile:shoujihaoText.text]==NO)
    {
        [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
        return;
    }
    [self.view endEditing:YES];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     shoujihaoText.text,@"phone",
                                     @"5",@"type",
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

- (void)RegisterBtnClick:(id)sender
{
    [self.view endEditing:YES];
    NSLog(@"去注册");
    if ([AppTool validateMobile:shoujihaoText.text]==NO)
    {
        [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
        return;
    }
    if (yanzhengmaText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写验证码"];
        return;
    }
    if (mimaText.text.length!=6)
    {
        [MBProgressHUD showAutoMessage:@"请填写6位密码"];
        return;
    }
    if (querenmimaText.text.length!=6)
    {
        [MBProgressHUD showAutoMessage:@"请确认新密码"];
        return;
    }
    if (![querenmimaText.text isEqualToString:mimaText.text])
    {
        [MBProgressHUD showAutoMessage:@"密码和确认密码不一致"];
        return;
    }
     [self.view endEditing:YES];
[UIAlertView showAlert:@"是否确认并且提交？" delegate:self cancelButton:@"取消" otherButton:@"提交" tag:1];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"保存");
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSDictionary *item = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
        NSString *account_id = [item objectForKey:@"account_id"];
        
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_updateCustPayPwdFunction",@"funcId",
                                         mimaText.text,@"pay_pwd",
                                         querenmimaText.text,@"confirm_pwd",
                                         yanzhengmaText.text,@"validate_code",
                                         account_id,@"phone",
                                         nil];
        
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

             if (((response *)obj.responses[0]).flag.intValue==1)
             {
                 [MBProgressHUD showAutoMessage:@"设置支付密码成功"];
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
             [MBProgressHUD showError:@"设置支付密码失败" toView:self.view];
         }];
        
    }
    else
    {
        NSLog(@"取消");
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
