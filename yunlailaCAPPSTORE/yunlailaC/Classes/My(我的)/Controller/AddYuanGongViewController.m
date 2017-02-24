//
//  AddYuanGongViewController.m
//  yunlailaC
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AddYuanGongViewController.h"
@interface AddYuanGongViewController ()<UITextFieldDelegate>
{
    UITextField *xingmingText;   //姓名
    UITextField *dianhuaText;   //电话
    UITextField *yanzhengmaText;  //验证码
    
    SSNCountdownButton *verificationBtn;
    
    UIButton *agreeBtn;
    UIButton *loginBtn;
}
@end

@implementation AddYuanGongViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
//    {
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }
//    if (IsIOS7)
//    {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加员工";
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 38*3+3)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 38)];
    oneLabel.backgroundColor = [UIColor clearColor];
    oneLabel.textColor = fontColor;
    oneLabel.textAlignment = NSTextAlignmentLeft;
    oneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    oneLabel.numberOfLines = 0;
    oneLabel.font = viewFont1;
    oneLabel.text = @"员工姓名";
    [bgView addSubview:oneLabel];
    
    xingmingText = [[UITextField alloc] init];
    xingmingText.clearButtonMode = UITextFieldViewModeWhileEditing;
    xingmingText.borderStyle = UITextBorderStyleNone;
    xingmingText.frame = CGRectMake(80, 0, 220, 38);
    xingmingText.delegate = self;
    xingmingText.placeholder = @"输入员工姓名";
    xingmingText.returnKeyType = UIReturnKeyDone;
//    xingmingText.keyboardType = UIKeyboardTypeNumberPad;
    xingmingText.font = viewFont1;
    [bgView addSubview:xingmingText];
    
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
    twoLabel.text = @"员工电话";
    [bgView addSubview:twoLabel];
    
    dianhuaText = [[UITextField alloc] init];
    dianhuaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    dianhuaText.borderStyle = UITextBorderStyleNone;
    dianhuaText.frame = CGRectMake(80, 39, 220, 38);
    dianhuaText.delegate = self;
    dianhuaText.placeholder = @"请输入员工电话";
    dianhuaText.returnKeyType = UIReturnKeyDone;
    dianhuaText.font = viewFont1;
    dianhuaText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:dianhuaText];
    

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
    threeLabel.text = @"验证码";
    [bgView addSubview:threeLabel];
    
    yanzhengmaText = [[UITextField alloc] init];
    yanzhengmaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    yanzhengmaText.borderStyle = UITextBorderStyleNone;
    yanzhengmaText.frame = CGRectMake(80, 78, 160, 38);
    yanzhengmaText.delegate = self;
    yanzhengmaText.placeholder = @"请输入验证码";
    yanzhengmaText.returnKeyType = UIReturnKeyDone;
    yanzhengmaText.font = viewFont1;
//    yanzhengmaText.secureTextEntry = YES;
     yanzhengmaText.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:yanzhengmaText];
    
    verificationBtn = [[SSNCountdownButton alloc] initWithFrame: CGRectMake(240, 78, 80, 38)];
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

    
    UIView *fgx3 = [[UIView alloc] initWithFrame:CGRectMake(15, 117, 290, 1)];
    fgx3.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [bgView addSubview:fgx3];
    
    
    agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.frame = CGRectMake(0, 120 ,40, 40);
    [agreeBtn setImage:[[UIImage imageNamed:@"待完成"] imageByScalingToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [agreeBtn setImage:[[UIImage imageNamed:@"已完成"] imageByScalingToSize:CGSizeMake(10, 10)] forState:UIControlStateSelected];
    [agreeBtn addTarget:self
                 action:@selector(agreeBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    agreeBtn.selected = YES;
    [self.view addSubview:agreeBtn];
    
    UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 125, 100, 30)];
    agreeLabel.numberOfLines = 0;
    agreeLabel.textAlignment = NSTextAlignmentLeft;
    agreeLabel.font = viewFont3;
    agreeLabel.textColor = fontColor;
    agreeLabel.text = @"我同意";
    [self.view addSubview:agreeLabel];
    
    UILabel *clauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 125, 200, 30)];
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
    
    loginBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 160, 250, 34)];
    [loginBtn setTitle:@"绑定员工" forState:UIControlStateNormal];
    [loginBtn setTitle:@"绑定员工" forState:UIControlStateHighlighted];
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

- (void)verificationBtnClick:(id)sender
{
    [self.view endEditing:YES];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     dianhuaText.text,@"phone",
                                     @"13",@"type",
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)RegisterBtnClick:(id)sender
{
    NSLog(@"去绑定");
    [self.view endEditing:YES];
    if(xingmingText.text.length==0)
    {
        [MBProgressHUD showError:@"请填写员工姓名" toView:self.view];
        return;
    }
    if ([AppTool validateMobile:dianhuaText.text]==NO)
    {
        [MBProgressHUD showError:@"请填写正确的手机号" toView:self.view];
        return;
    }
    
    if(yanzhengmaText.text.length==0)
    {
        [MBProgressHUD showError:@"请填写验证码" toView:self.view];
        return;
    }
    if(agreeBtn.selected==NO)
    {
        [MBProgressHUD showError:@"请同意托运邦运单契约条款" toView:self.view];
        return;
    }

    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"hex_client_relations_addEmployeeFunction",@"funcId",
                                     xingmingText.text,@"employee_name",
                                     dianhuaText.text,@"employee_phone",
                                     yanzhengmaText.text,@"verification_code",
                                     nil];
    
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
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
         
         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             [MBProgressHUD showAutoMessage:@"绑定员工成功"];
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
         [MBProgressHUD showError:@"登录失败,网络异常" toView:self.view];
     }];

}
@end
