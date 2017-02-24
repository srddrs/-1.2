//
//  DeleteBankCard2ViewController.m
//  yunlailaC
//
//  Created by admin on 16/9/6.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "DeleteBankCard2ViewController.h"

@interface DeleteBankCard2ViewController ()<UITextFieldDelegate>
{
    UITextField *yinhangText;
    UITextField *yinhangkaText;
    UITextField *dianhuaText;
    UITextField *yanzhengmaText;
    
    SSNCountdownButton *verificationBtn;
}

@end

@implementation DeleteBankCard2ViewController
@synthesize bank;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    yinhangText.text = [NSString stringWithFormat:@"%@",[bank objectForKey:@"bank_name"]];
    yinhangkaText.text = [NSString stringWithFormat:@"%@",[bank objectForKey:@"bankcard_no"]];
    dianhuaText.text = [NSString stringWithFormat:@"%@",[bank objectForKey:@"reserve_telphone"]];
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    if ([[loginUser objectForKey:@"account_id"] length]>0) {
        dianhuaText.text = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"account_id"]];
    }

    
    NSString *bankcard_q = [yinhangkaText.text substringWithRange:NSMakeRange(0, 6)];
    NSString *bankcard_h = [yinhangkaText.text substringWithRange:NSMakeRange(yinhangkaText.text.length-4, 4)];
    yinhangkaText.text = [NSString stringWithFormat:@"%@*******%@",bankcard_q,bankcard_h];
    
    
    
//    NSString *dianhua_q = [dianhuaText.text substringWithRange:NSMakeRange(0, 3)];
//    NSString *dianhua_h = [dianhuaText.text substringWithRange:NSMakeRange(dianhuaText.text.length-4, 4)];
//    dianhuaText.text = [NSString stringWithFormat:@"%@****%@",dianhua_q,dianhua_h];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"删除银行卡";
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
    oneLabel.text = @"银行名称";
    [bgView addSubview:oneLabel];
    
    yinhangText = [[UITextField alloc] init];
    yinhangText.clearButtonMode = UITextFieldViewModeWhileEditing;
    yinhangText.borderStyle = UITextBorderStyleNone;
    yinhangText.frame = CGRectMake(85, 0, 220, 38);
    yinhangText.delegate = self;
    yinhangText.placeholder = @"输入银行名称";
    yinhangText.returnKeyType = UIReturnKeyDone;
    yinhangText.font = viewFont1;
    yinhangText.enabled = NO;
    [bgView addSubview:yinhangText];
    
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
    twoLabel.text = @"银行卡号";
    [bgView addSubview:twoLabel];
    
    yinhangkaText = [[UITextField alloc] init];
    yinhangkaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    yinhangkaText.borderStyle = UITextBorderStyleNone;
    yinhangkaText.frame = CGRectMake(85, 39, 220, 38);
    yinhangkaText.delegate = self;
    yinhangkaText.placeholder = @"请输入银行卡号";
    yinhangkaText.returnKeyType = UIReturnKeyDone;
    yinhangkaText.font = viewFont1;
    yinhangkaText.keyboardType = UIKeyboardTypeNumberPad;
    yinhangkaText.enabled = NO;
    [bgView addSubview:yinhangkaText];
    
    
    
    
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
    threeLabel.text = @"预留电话";
    [bgView addSubview:threeLabel];
    
    dianhuaText = [[UITextField alloc] init];
    dianhuaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    dianhuaText.borderStyle = UITextBorderStyleNone;
    dianhuaText.frame = CGRectMake(85, 78, 220, 38);
    dianhuaText.delegate = self;
    dianhuaText.placeholder = @"请输入电话号码";
    dianhuaText.returnKeyType = UIReturnKeyDone;
    dianhuaText.font = viewFont1;
    dianhuaText.keyboardType = UIKeyboardTypeNumberPad;
    //    dianhuaText.secureTextEntry = YES;
    dianhuaText.enabled = NO;
    [bgView addSubview:dianhuaText];
    
    
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
    fourLabel.text = @"验证码";
    [bgView addSubview:fourLabel];
    
    yanzhengmaText = [[UITextField alloc] init];
    yanzhengmaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    yanzhengmaText.borderStyle = UITextBorderStyleNone;
    yanzhengmaText.frame = CGRectMake(85, 118, 160, 38);
    yanzhengmaText.delegate = self;
    yanzhengmaText.placeholder = @"请输入验证码";
    yanzhengmaText.returnKeyType = UIReturnKeyDone;
    yanzhengmaText.keyboardType = UIKeyboardTypeNumberPad;
    yanzhengmaText.font = viewFont1;
    [bgView addSubview:yanzhengmaText];
    
    
    verificationBtn = [[SSNCountdownButton alloc] initWithFrame: CGRectMake(240, 118, 80, 38)];
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
    
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 180, 250, 34)];
    [loginBtn setTitle:@"删除银行卡" forState:UIControlStateNormal];
    [loginBtn setTitle:@"删除银行卡" forState:UIControlStateHighlighted];
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

- (void)verificationBtnClick:(id)sender
{
    [self.view endEditing:YES];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     dianhuaText.text,@"phone",
                                     @"3",@"type",
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

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RegisterBtnClick:(id)sender
{
    NSLog(@"删除");
    [UIAlertView showAlert:@"是否确认并且删除？" delegate:self cancelButton:@"取消" otherButton:@"删除" tag:1];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self.view endEditing:YES];
        NSLog(@"下一步");
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                         @"hex_client_bank_delete",@"funcId",
                                          @"hex_client_bank_noBindOtherBankFunction",@"funcId",
                                         [bank objectForKey:@"cust_bank_id"],@"cust_bank_id",
                                         dianhuaText.text,@"phone",
                                         yanzhengmaText.text,@"verificationCode",
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
                 
                 [MBProgressHUD showAutoMessage:@"删除银行卡成功"];
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
             [MBProgressHUD showError:@"删除银行卡失败" toView:self.view];
         }];
        
    }
    else
    {
        NSLog(@"取消");
    }
    
}
@end
