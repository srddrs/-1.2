//
//  AddBankCard2ViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/25.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AddBankCard2ViewController.h"

@interface AddBankCard2ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITextField *chikarenText;  //持卡人
    UITextField *yinhangkaText;  //银行卡
    UITextField *shoujihaoText; //手机号
}
@end

@implementation AddBankCard2ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNav
{
    self.title = @"添加银行卡";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void) initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TabbarHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)pop:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    headView.backgroundColor = bgViewColor;
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        return 150;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier3 = @"CellIdentifier3";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 70*APP_DELEGATE().autoSizeScaleX, 44)];
    titleLable1.numberOfLines = 0;
    titleLable1.textAlignment = NSTextAlignmentLeft;
    titleLable1.font = viewFont1;
    titleLable1.textColor = fontColor;
    [cell.contentView addSubview:titleLable1];
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 43, 290*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];
 
    if(indexPath.section==0&&indexPath.row==0)
    {
        titleLable1.text = @"持卡人";
        if (!chikarenText)
        {
            chikarenText = [[UITextField alloc] init];
            chikarenText.clearButtonMode = UITextFieldViewModeWhileEditing;
            chikarenText.borderStyle = UITextBorderStyleNone;
            chikarenText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            chikarenText.delegate = self;
            chikarenText.placeholder = @"持卡人";
            chikarenText.returnKeyType = UIReturnKeyDone;
            chikarenText.keyboardType = UIKeyboardTypeNumberPad;
            chikarenText.font = viewFont1;
            chikarenText.textColor = fontColor;
            chikarenText.text = @"";
            NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
            NSString *name;
            //            if ([[loginUser objectForKey:@"nick_name"] length]>0)
            //            {
            //                name = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"nick_name"]];
            //            }
            //            else
            //            {
            //                name = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"real_name"]];
            //            }
            if ([[loginUser objectForKey:@"real_name"] length]>0)
            {
                name = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"real_name"]];
            }
            else
            {
                name = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"nick_name"]];
            }
            
            chikarenText.text = name;
            
        }
        [cell.contentView addSubview:chikarenText];
    }
    else if(indexPath.section==0&&indexPath.row==1)
    {
        titleLable1.text = @"银行卡";
        if (!yinhangkaText)
        {
            yinhangkaText = [[UITextField alloc] init];
            yinhangkaText.clearButtonMode = UITextFieldViewModeWhileEditing;
            yinhangkaText.borderStyle = UITextBorderStyleNone;
            yinhangkaText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            yinhangkaText.delegate = self;
            yinhangkaText.placeholder = @"请输入银行卡号";
            yinhangkaText.returnKeyType = UIReturnKeyDone;
            yinhangkaText.keyboardType = UIKeyboardTypeNumberPad;
            yinhangkaText.font = viewFont1;
            yinhangkaText.textColor = fontColor;
            yinhangkaText.text = @"";
            
        }
        [cell.contentView addSubview:yinhangkaText];
    }
    else if(indexPath.section==0&&indexPath.row==2)
    {
        titleLable1.text = @"手机号";
        if (!shoujihaoText)
        {
            shoujihaoText = [[UITextField alloc] init];
            shoujihaoText.clearButtonMode = UITextFieldViewModeWhileEditing;
            shoujihaoText.borderStyle = UITextBorderStyleNone;
            shoujihaoText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            shoujihaoText.delegate = self;
            shoujihaoText.placeholder = @"请输入预留手机号";
            shoujihaoText.returnKeyType = UIReturnKeyDone;
            shoujihaoText.keyboardType = UIKeyboardTypeNumberPad;
            shoujihaoText.font = viewFont1;
            shoujihaoText.textColor = fontColor;
            shoujihaoText.text = @"";
            
        }
        [cell.contentView addSubview:shoujihaoText];
    }
    else
    {
        NSLog(@"AAAA:%d",indexPath.row);
        fgx.hidden = YES;
        titleLable1.hidden = YES;
        cell.backgroundColor = bgViewColor;
        UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 20, 250*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
        [submitBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
        [submitBtn setTitle:@"添加银行卡" forState:UIControlStateHighlighted];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
        [submitBtn addTarget:self
                      action:@selector(submitBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
        submitBtn.titleLabel.font = viewFont1;
        [cell.contentView addSubview:submitBtn];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 50*APP_DELEGATE().autoSizeScaleY, 290*APP_DELEGATE().autoSizeScaleX, 60)];
        descLabel.numberOfLines = 0;
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.font = viewFont3;
        
        [cell.contentView addSubview:descLabel];
        
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"温馨提示:该预留手机号非常重要,请勿随便填写"];
        [str addAttribute:NSForegroundColorAttributeName value:titleViewColor range:NSMakeRange(0,5)];
        [str addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(5,str.length-5)];
        descLabel.attributedText = str;
    }
    return cell;
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    [self.view endEditing:YES];
    if (yinhangkaText.text.length == 0 || [[AppTool isBankCardNum:yinhangkaText.text] isEqualToString:@"不是正确格式的银行卡"]|| [[AppTool isBankCardNum:yinhangkaText.text] isEqualToString:@"银行卡位数不正确"])
    {
        [MBProgressHUD showAutoMessage:@"请输入正确的银行卡号"];
        return;
    }
    
    if ([AppTool validateMobile:shoujihaoText.text]==NO)
    {
        [MBProgressHUD showAutoMessage:@"请填写正确的手机号"];
        return;
    }
    [UIAlertView showAlert:@"是否确认并且提交？" delegate:self cancelButton:@"取消" otherButton:@"提交" tag:1];
    
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
                                         @"hex_client_bank_bind_bank",@"funcId",
                                         yinhangkaText.text,@"bankNumber",
                                         shoujihaoText.text,@"phone",
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
                 [MBProgressHUD showMessag:@"添加银行卡成功" toView:self.view];
                  [self.navigationController dismissViewControllerAnimated:YES completion:^{
                      
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
             [MBProgressHUD showError:@"添加银行卡失败" toView:self.view];
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
