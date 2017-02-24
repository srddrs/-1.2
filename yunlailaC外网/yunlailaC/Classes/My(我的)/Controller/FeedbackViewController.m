//
//  FeedbackViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (nonatomic, strong)UITextView *pingJia;
@property (nonatomic, strong)UILabel *tishiLabel;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"反馈建议";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
    
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];
    titleLabel.text = @"您的评价";
    titleLabel.font = viewFont1;
    titleLabel.textColor = fontColor;
    [self.view addSubview:titleLabel];

    //对话框
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 320, 130)];
    bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg];
    bg.userInteractionEnabled = YES;
    
    
    self.pingJia = [[UITextView alloc]initWithFrame:CGRectMake(15, 0, 290, 130)];
    self.pingJia.tintColor = [UIColor grayColor];
    self.pingJia.font = viewFont2;
    self.pingJia.delegate = self;
    [bg addSubview:self.pingJia];
    
    self.tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, 290,40)];
    self.tishiLabel.font = viewFont2;
    self.tishiLabel.text = @"请写下您的意见和建议，我们期待您的声音。";
    self.tishiLabel.numberOfLines = 0;
    self.tishiLabel.textColor = [UIColor grayColor];
    [self.pingJia addSubview:self.tishiLabel];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 180, 250, 34)];
    [submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [submitBtn setTitle:@"确认提交" forState:UIControlStateHighlighted];
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

-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
//    if (number > 100) {
//        
//        textView.text = [textView.text substringToIndex:100];
//        number = 100;
//        
//    }
    if (number == 0) {
        self.tishiLabel.hidden = NO;
    }else{
        self.tishiLabel.hidden = YES;
    }
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    if (self.pingJia.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写意见和建议"];
        return;
    }

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
        NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        NSString *name;
        if ([[loginUser objectForKey:@"nick_name"] length]>0)
        {
            name = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"nick_name"]];
        }
        else
        {
            name = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"real_name"]];
        }
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_feedbackinformation_function",@"funcId",
                                         self.pingJia.text,@"message",
                                         account_id,@"phone",
                                         name,@"back_name",
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
                 [helper Post:loginOutURL Parameters:nil Success:^(id responseObject)
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
                          [MBProgressHUD showAutoMessage:@"提交意见反馈成功"];
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
                      [MBProgressHUD showError:@"退出失败,网络异常" toView:self.view];
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
             [MBProgressHUD showError:@"修改密码失败" toView:self.view];
         }];
        
    }
    else
    {
        NSLog(@"取消");
    }
    
}

@end
