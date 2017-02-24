//
//  AccountDrawMoneyViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AccountDrawMoneyViewController.h"
#import "IQActionSheetPickerView.h"
#import "ZCTradeView.h"
@interface AccountDrawMoneyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,IQActionSheetPickerViewDelegate,ZCTradeViewDelegate>
{
    UITableView *_tableView;
    UILabel *yinhangLable;
    UILabel *xianzhiLable;
    UILabel *weihaoLable;
    UITextField *jineText; //金额
    
    NSMutableArray *banks;
    NSDictionary *dBank;
}

@end

@implementation AccountDrawMoneyViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        banks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_banklist",@"funcId",
                                     
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
             if (((response *)obj.responses[0]).items.count>0)
             {
                 [banks removeAllObjects];
                 
                 for (int i=0; i<((response *)obj.responses[0]).items.count; i++)
                 {
                     NSDictionary *bank = [((response *)obj.responses[0]).items objectAtIndex:i];
                     if ([[bank objectForKey:@"audit_state"] intValue]==2)
                     {
                         [banks addObject:bank];
                     }
                 }
                 
                 if (banks.count>0)
                 {
                     NSDictionary *bank = [banks objectAtIndex:0];
                     dBank = [bank copy];
                 }

                  [_tableView reloadData];
                
             }
             else
             {
                 
             }
             
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
         
         
//         self.noDataImage.hidden = NO;
//         [self.view bringSubviewToFront:self.noDataImage];
         
     }];

    
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
    self.title = @"账户提现";
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        return 60;
    }
    else if (indexPath.section==1&&indexPath.row==0)
    {
        return 44;
    }
    else
    {
        return 150;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        headView.backgroundColor = bgViewColor;
        return headView;
    }
    else
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        headView.backgroundColor = bgViewColor;
        
//        if (!xianzhiLable)
//        {
//            NSDictionary *bank = [banks objectAtIndex:0];
//            xianzhiLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 30)];
//            xianzhiLable.numberOfLines = 0;
//            xianzhiLable.textAlignment = NSTextAlignmentLeft;
//            xianzhiLable.font = viewFont1;
//            xianzhiLable.textColor = fontColor;
//            xianzhiLable.text = [NSString stringWithFormat:@"该卡每次最多可以转出%@元",[bank objectForKey:@"neirong2"]];
//        }
        
//        [headView addSubview:xianzhiLable];

        
        return headView;
    }
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

    if(indexPath.section==0&&indexPath.row==0)
    {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 18, 25*APP_DELEGATE().autoSizeScaleX, 25)];
         icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dBank objectForKey:@"bank_type"]]];
        [cell.contentView addSubview:icon];
        
        
        
        if (!yinhangLable)
        {
            yinhangLable = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 220*APP_DELEGATE().autoSizeScaleX, 35)];
            yinhangLable.numberOfLines = 0;
            yinhangLable.textAlignment = NSTextAlignmentLeft;
            yinhangLable.font = viewFont1;
            yinhangLable.textColor = fontColor;
            
        }
               yinhangLable.text = [NSString stringWithFormat:@"%@",[dBank objectForKey:@"bank_name"]];

        
        
        [cell.contentView addSubview:yinhangLable];
        
        if (!weihaoLable)
        {
            weihaoLable = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 30, 220*APP_DELEGATE().autoSizeScaleX, 25)];
            weihaoLable.numberOfLines = 0;
            weihaoLable.textAlignment = NSTextAlignmentLeft;
            weihaoLable.font = viewFont2;
            weihaoLable.textColor = fontColor;
                   }
        
        weihaoLable.text = [NSString stringWithFormat:@"%@",[dBank objectForKey:@"bankcard_no"]];
        NSString *bankcard_q = [weihaoLable.text substringWithRange:NSMakeRange(0, 6)];
        NSString *bankcard_h = [weihaoLable.text substringWithRange:NSMakeRange(weihaoLable.text.length-4, 4)];
        weihaoLable.text = [NSString stringWithFormat:@"%@*******%@",bankcard_q,bankcard_h];
        [cell.contentView addSubview:weihaoLable];
    }
    else if(indexPath.section==1&&indexPath.row==0)
    {
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 70*APP_DELEGATE().autoSizeScaleX, 44)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"金额";
        [cell.contentView addSubview:titleLable1];
        
        if (!jineText)
        {
            jineText = [[UITextField alloc] init];
            jineText.clearButtonMode = UITextFieldViewModeWhileEditing;
            jineText.borderStyle = UITextBorderStyleNone;
            jineText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            jineText.delegate = self;
            jineText.placeholder = @"请输入提现金额";
            jineText.returnKeyType = UIReturnKeyDone;
            jineText.keyboardType = UIKeyboardTypeNumberPad;
            jineText.font = viewFont1;
            jineText.textColor = fontColor;
            jineText.text = @"";
            
        }
        [cell.contentView addSubview:jineText];
        
    }
    else if(indexPath.section==1&&indexPath.row==1)
    {
         cell.backgroundColor = bgViewColor;
        UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 20, 250*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
        [submitBtn setTitle:@"账户提现" forState:UIControlStateNormal];
        [submitBtn setTitle:@"账户提现" forState:UIControlStateHighlighted];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
        [submitBtn addTarget:self
                      action:@selector(submitBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
        submitBtn.titleLabel.font = viewFont1;
        [cell.contentView addSubview:submitBtn];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0)
    {
        NSLog(@"换银行");
        [self.view endEditing:YES];
        IQActionSheetPickerView *picker =  [[IQActionSheetPickerView alloc] initWithTitle:@"选择银行卡" delegate:self];
        [picker setTag:2];
        [picker setActionSheetPickerStyle:IQActionSheetPickerStyleTablePicker];
        [picker setBanks:banks];
        [picker show];
        [picker setButtonColor:fontColor];

    }
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTable:(NSDictionary *)bank
{
    yinhangLable.text = [NSString stringWithFormat:@"%@",[bank objectForKey:@"bank_name"]];
//    xianzhiLable.text = [NSString stringWithFormat:@"该卡每次最多可以转出%@元",[bank objectForKey:@"neirong2"]];

    weihaoLable.text = [NSString stringWithFormat:@"卡编号  %@",[bank objectForKey:@"bankcard_no"]];
    dBank = [bank copy];
    [_tableView reloadData];
    
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    [self.view endEditing:YES];
    if ([[dBank objectForKey:@"cust_bank_id"] length]==0)
    {
        [MBProgressHUD showError:@"请选择银行卡" toView:self.view];
        return;
    }
    if (jineText.text.length==0)
    {
        [MBProgressHUD showError:@"请填写金额" toView:self.view];
        return;
    }
    ZCTradeView *vc = [[ZCTradeView alloc] init];
    vc.delegate = self;
    [vc show];

    
}

-(NSString *)finish:(NSString *)pwd{
    
    NSLog(@"输入的是:%@",pwd);
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_bean_applicationWithdrawalFunction",@"funcId",
                                     [NSString stringWithFormat:@"%@",[dBank objectForKey:@"cust_bank_id"]],@"cust_bank_id",
                                     jineText.text,@"apply_amount",
                                     pwd,@"pay_pwd",
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
             [MBProgressHUD showAutoMessage:@"申请提现成功"];
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
         [MBProgressHUD showError:@"申请提现失败" toView:self.view];
     }];

    return pwd;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
