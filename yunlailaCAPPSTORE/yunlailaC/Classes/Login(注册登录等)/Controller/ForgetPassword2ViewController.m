//
//  ForgetPassword2ViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ForgetPassword2ViewController.h"

@interface ForgetPassword2ViewController ()<UITextFieldDelegate>
{
    UITextField *newPassWordText;//新密码
    UITextField *verifyPassWordText;//确认密码
}
@end

@implementation ForgetPassword2ViewController
@synthesize forget_code;  //第一步成功后的传参
@synthesize cust_id;   //第一步成功后的用户id
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
 *  初始化界面
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
    oneLabel.text = @"新密码";
    [bgView addSubview:oneLabel];
    
    newPassWordText = [[UITextField alloc] init];
    newPassWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPassWordText.borderStyle = UITextBorderStyleNone;
    newPassWordText.frame = CGRectMake(80, 0, 220, 38);
    newPassWordText.delegate = self;
    newPassWordText.placeholder = @"请输入新密码";
    newPassWordText.returnKeyType = UIReturnKeyDone;
    newPassWordText.font = viewFont1;
    newPassWordText.secureTextEntry = YES;
    [bgView addSubview:newPassWordText];
    
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
    twoLabel.text = @"确认密码";
    [bgView addSubview:twoLabel];
    
    verifyPassWordText = [[UITextField alloc] init];
    verifyPassWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyPassWordText.borderStyle = UITextBorderStyleNone;
    verifyPassWordText.frame = CGRectMake(80, 39, 220, 38);
    verifyPassWordText.delegate = self;
    verifyPassWordText.placeholder = @"确认新密码";
    verifyPassWordText.returnKeyType = UIReturnKeyDone;
    verifyPassWordText.font = viewFont1;
    verifyPassWordText.secureTextEntry = YES;
    [bgView addSubview:verifyPassWordText];
    

    UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 120, 250, 34)];
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn setTitle:@"确定" forState:UIControlStateHighlighted];
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
 *  确定事件
 *
 *  @param sender <#sender description#>
 */
- (void)submitBtnClick:(id)sender
{
    NSLog(@"forget_code:%@",forget_code);
    NSLog(@"忘记密码");
    if (newPassWordText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写密码"];
        return;
    }
    if (verifyPassWordText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请确认密码"];
        return;
    }
    [UIAlertView showAlert:@"是否确认并且提交？" delegate:self cancelButton:@"取消" otherButton:@"提交" tag:1];
    
}

/**
 *  @author 徐杨
 *
 *  提交选项选择事件
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
                                         newPassWordText.text,@"login_pwd",
                                         forget_code,@"forget_code",
                                         cust_id,@"cust_id",
                                         nil];
        
        [helper Post:forgetPwdStep2URL Parameters:paramDic Success:^(id responseObject)
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
                 [MBProgressHUD showAutoMessage:@"重设密码成功"];
                 [self.navigationController popToRootViewControllerAnimated:YES];
                 
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
             [MBProgressHUD showError:@"重设密码失败" toView:self.view];
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
