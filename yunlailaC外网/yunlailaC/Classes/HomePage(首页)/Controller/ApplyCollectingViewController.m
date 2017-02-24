//
//  ApplyCollectingViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ApplyCollectingViewController.h"
#import "ApplyTypeViewController.h"
#import "IQActionSheetPickerView.h"
#import "AddBankCardViewController.h"
#import "AddBankCard2ViewController.h"
#import "AddBankCard3ViewController.h"
#import "ManageBankCardViewController.h"
@interface ApplyCollectingViewController ()<UITableViewDataSource,UITableViewDelegate,ApplyTypeViewControllerDelegate,IQActionSheetPickerViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    BOOL isYinHang;
    
    UILabel *typeLabel;
    UILabel *yinhangLabel;
    NSDictionary *currentBank;
    
    
}
@end

@implementation ApplyCollectingViewController
@synthesize waybill;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        isYinHang = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self getuserInfo];
    
}
- (void)getuserInfo
{
    //获取用户信息
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_member_queryCustInformationFunction",@"funcId",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
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
             NSDictionary *item = ((response *)obj.responses[0]).items[0];
             NSLog(@"item:%@",item);
             
             
             [[NSUserDefaults standardUserDefaults] setObject:item forKey:kUserInfo];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [_tableView reloadData];
         }
         else
         {
             
         }
         NSLog(@"%@",responseObject);
     } Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)setUpNav
{
    self.title = @"申请放款";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void) initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - statusViewHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
    
}



-(void)pickerCancelClicked:(UIBarButtonItem*)barButton
{
    NSLog(@"取消");
}

-(void)pickerDoneClicked:(UIBarButtonItem*)barButton
{
    NSLog(@"选择");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
}
#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isYinHang==YES)
    {
        return 3;
    }
    else
    {
        return 2;
    }
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
    if (isYinHang==YES)
    {
        if (indexPath.row==2)
        {
            return 100;
        }
    }
    else
    {
        if (indexPath.row==1)
        {
            return 100;
        }
    }
    return 40;
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
 
    UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 70*APP_DELEGATE().autoSizeScaleX, 40)];
    titleLable1.numberOfLines = 0;
    titleLable1.textAlignment = NSTextAlignmentLeft;
    titleLable1.font = viewFont1;
    titleLable1.textColor = fontColor;
    [cell.contentView addSubview:titleLable1];

    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 39, 290*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];
    
    if (isYinHang==YES)
    {
        if(indexPath.row==0)
        {
            cell.backgroundColor = [UIColor whiteColor];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            titleLable1.text = @"放款方式";
            if (!typeLabel)
            {
                typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 150*APP_DELEGATE().autoSizeScaleX, 40)];
                typeLabel.backgroundColor = [UIColor clearColor];
                typeLabel.textColor = fontColor;
                typeLabel.textAlignment = NSTextAlignmentLeft;
                typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
                typeLabel.numberOfLines = 0;
                typeLabel.font = viewFont1;
            }
            typeLabel.text = @"存到我的银行卡";
            [cell.contentView addSubview:typeLabel];
        }
        else if (indexPath.row==1)
        {
            fgx.hidden = YES;
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            titleLable1.text = @"银行卡";
            if (!yinhangLabel)
            {
                yinhangLabel = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 180*APP_DELEGATE().autoSizeScaleX, 40)];
                yinhangLabel.backgroundColor = [UIColor clearColor];
                yinhangLabel.textColor = fontColor;
                yinhangLabel.textAlignment = NSTextAlignmentLeft;
                yinhangLabel.lineBreakMode = NSLineBreakByWordWrapping;
                yinhangLabel.numberOfLines = 0;
                yinhangLabel.font = viewFont1;
                yinhangLabel.text = @"";
            }
            [cell.contentView addSubview:yinhangLabel];
        }
        else if(indexPath.row==2)
        {
            fgx.hidden = YES;
            titleLable1.hidden = YES;
            cell.backgroundColor = bgViewColor;
            
            UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 25, 250*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
            [submitBtn setTitle:@"申请放款" forState:UIControlStateNormal];
            [submitBtn setTitle:@"申请放款" forState:UIControlStateHighlighted];
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



    }
    else
    {
        if(indexPath.row==0)
        {
            cell.backgroundColor = [UIColor whiteColor];
            fgx.hidden = YES;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            titleLable1.text = @"放款方式";
            if (!typeLabel)
            {
                typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 150*APP_DELEGATE().autoSizeScaleX, 40)];
                typeLabel.backgroundColor = [UIColor clearColor];
                typeLabel.textColor = fontColor;
                typeLabel.textAlignment = NSTextAlignmentLeft;
                typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
                typeLabel.numberOfLines = 0;
                typeLabel.font = viewFont1;
            }
            typeLabel.text = @"存到我的余额账户";
            [cell.contentView addSubview:typeLabel];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            fgx.hidden = YES;
            titleLable1.hidden = YES;
            cell.backgroundColor = bgViewColor;
            
            UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 25, 250*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
            [submitBtn setTitle:@"申请放款" forState:UIControlStateNormal];
            [submitBtn setTitle:@"申请放款" forState:UIControlStateHighlighted];
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
        

    }
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0)
    {
//        ApplyTypeViewController *vc = [[ApplyTypeViewController alloc] init];
//        vc.mydelegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
//        [vc setType:typeLabel.text];
    }
    if (isYinHang==YES)
    {
        if (indexPath.row==1)
        {
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
                         [self.view endEditing:YES];
                         IQActionSheetPickerView *picker =  [[IQActionSheetPickerView alloc] initWithTitle:@"选择银行卡" delegate:self];
                         [picker setTag:2];
                         [picker setActionSheetPickerStyle:IQActionSheetPickerStyleTablePicker];
                         
                         NSMutableArray *banks = [[NSMutableArray alloc] init];
                         for (int i=0; i<((response *)obj.responses[0]).items.count; i++)
                         {
                             NSDictionary *bank = [((response *)obj.responses[0]).items objectAtIndex:i];
                             if ([[bank objectForKey:@"audit_state"] intValue]==2)
                             {
                                 [banks addObject:bank];
                             }
                         }
                         
                         [picker setBanks:banks];
                         [picker show];
                         
                     }
                     else
                     {
                         [UIAlertView showAlert:@"您还没有绑定银行卡,是否绑定银行卡？" delegate:self cancelButton:@"取消" otherButton:@"绑定银行卡" tag:1];
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
                 
                 
             }];

        }
        
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        if (alertView.tag==1)
        {
            NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
            if ([[loginUser objectForKey:@"is_auth"] intValue]==0||[[loginUser objectForKey:@"is_auth"] intValue]==3)//没有实名认证
            {
                AddBankCardViewController *vc = [[AddBankCardViewController alloc] init];
                YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
                nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:nav animated:YES completion:nil];
            }
            else if ([[loginUser objectForKey:@"is_auth"] intValue]==1)//实名认证审核中
            {
                 [MBProgressHUD showAutoMessage:@"实名认证审核中，请耐心等待"];
            }
            else
            {
//                UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
//                [actionSheet addButtonWithTitle:@"添加银行卡(自己)"];
//                [actionSheet addButtonWithTitle:@"添加银行卡(他人)"];
//                [actionSheet addButtonWithTitle:@"取消"];
//                actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
//                actionSheet.tag = 11;
//                actionSheet.delegate = self;
//                [actionSheet showInView:self.view];
                ManageBankCardViewController *vc = [[ManageBankCardViewController alloc] init];
                YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
                nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:nav animated:YES completion:nil];
            }

        }
        else
        {
            NSLog(@"will:%@",waybill);
            NSLog(@"bank:%@",currentBank);
            NSString *lending_way_id;
            if (isYinHang==YES)
            {
                lending_way_id = @"1";
            }
            else
            {
                lending_way_id = @"2";
            }
            
            NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
            [MBProgressHUD showMessag:@"" toView:self.view];
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             @"hex_client_bean_applicationLoanFunction",@"funcId",
                                             [NSString stringWithFormat:@"%@",[waybill objectForKey:@"waybill_id"]],@"waybillId",
                                             lending_way_id,@"lending_way_id",
                                             nil];
            if (isYinHang==YES)
            {
                [paramDic setObject:[NSString stringWithFormat:@"%@",[currentBank objectForKey:@"cust_bank_id"]] forKey:@"bankId"];
            }
            
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
                     [MBProgressHUD showAutoMessage:@"申请放款成功"];
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
                 [MBProgressHUD showError:@"申请放款失败" toView:self.view];
             }];

        }
        
    }
    else
    {
        NSLog(@"取消");
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        AddBankCard2ViewController *vc = [[AddBankCard2ViewController alloc] init];
        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if(buttonIndex==1)
    {
//        [MBProgressHUD showAutoMessage:@"添加他人银行卡"];
        AddBankCard3ViewController *vc = [[AddBankCard3ViewController alloc] init];
        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTable:(NSDictionary *)bank
{
    currentBank = [bank copy];
    yinhangLabel.text = [NSString stringWithFormat:@"%@",[currentBank objectForKey:@"bankcard_no"]];
    
    NSString *bankcard_q = [yinhangLabel.text substringWithRange:NSMakeRange(0, 6)];
    NSString *bankcard_h = [yinhangLabel.text substringWithRange:NSMakeRange(yinhangLabel.text.length-4, 4)];
    yinhangLabel.text = [NSString stringWithFormat:@"%@*******%@",bankcard_q,bankcard_h];
    [_tableView reloadData];
}
- (void)submitBtnClick:(id)sender
{
    NSLog(@"申请放款");
    if (isYinHang==YES)
    {
        if (yinhangLabel.text.length==0)
        {
            [MBProgressHUD showError:@"请选择银行卡" toView:self.view];
            return;
        }
    }
    [UIAlertView showAlert:@"是否确认并且申请放款？" delegate:self cancelButton:@"取消" otherButton:@"申请放款" tag:2];
    
}


- (void)sendType:(NSString *)Type
{
    if ([Type isEqualToString:@"存到我的银行卡"])
    {
        isYinHang = YES;
    }
    else
    {
         isYinHang = NO;
    }
    [_tableView reloadData];
}
@end
