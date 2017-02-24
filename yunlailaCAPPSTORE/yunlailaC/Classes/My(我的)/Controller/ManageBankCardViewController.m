//
//  ManageBankCardViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ManageBankCardViewController.h"
#import "AddBankCardViewController.h"
#import "AddBankCard1ViewController.h"
#import "AddBankCard2ViewController.h"
#import "AccountDrawMoneyViewController.h"
#import "SWTableViewCell.h"
#import "BankCardSettingViewController.h"
#import "DeleteBankCardViewController.h"
#import "AddBankCard3ViewController.h"
#import "AddBankCard4ViewController.h"
#import "DeleteBankCard2ViewController.h"
@interface ManageBankCardViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items;
    int start;
    int limit;
}
@end

@implementation ManageBankCardViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        items = [[NSMutableArray alloc] init];
        start = 0;
        limit = pageSize;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getuserInfo];
    [_tableView.mj_header beginRefreshing];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNav
{
    self.title = @"绑定银行卡";
//    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
        UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"添加银行卡" style:UIBarButtonItemStyleDone target:self action:@selector(changyong)];
        self.navigationItem.rightBarButtonItem = changyongItem;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];

}
- (void)changyong
{
    NSLog(@"常用地址");
    NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    
    
//    当前账号为员工账号,请联系老板账号添加银行卡
    if ([[loginUser objectForKey:@"cust_relations_type"] intValue]==1||[[loginUser objectForKey:@"cust_relations_type"] intValue]==2)
    {
//        if ([[loginUser objectForKey:@"is_auth"] intValue]==2)//ceshi
//        {
//            AddBankCard3ViewController *vc = [[AddBankCard3ViewController alloc] init];
//            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
//            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            [self presentViewController:nav animated:YES completion:nil];
//        }
        if ([[loginUser objectForKey:@"is_auth"] intValue]==0)//没有实名认证
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
        else if ([[loginUser objectForKey:@"is_auth"] intValue]==3)//实名认证失败，请重新实名认证
        {
            
            AddBankCard1ViewController *vc = [[AddBankCard1ViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            
            //        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            //        [actionSheet addButtonWithTitle:@"添加银行卡(自己)"];
            //        [actionSheet addButtonWithTitle:@"添加银行卡(他人)"];
            //        [actionSheet addButtonWithTitle:@"取消"];
            //        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
            //        actionSheet.tag = 99999;
            //        actionSheet.delegate = self;
            //        [actionSheet showInView:self.view];
            
            AddBankCard2ViewController *vc = [[AddBankCard2ViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
            
        }

    }//客户关系类型（1：无关系；2：老板；3：员工）
    else
    {
        [MBProgressHUD showAutoMessage:@"当前账号为员工账号,请联系老板账号添加银行卡"];
    }

    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==99999)
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
            BOOL is_own = NO;
            for(int i=0;i<items.count;i++)
            {
                NSDictionary *bankInfo = [items objectAtIndex:i];
                if ([[bankInfo objectForKey:@"is_own"] intValue]==2)
                {
                    is_own = YES;
                }
            }
            
            if (is_own==YES)
            {
                [MBProgressHUD showAutoMessage:@"只能绑定一张他人的银行卡"];
            }
            else
            {
                //        [MBProgressHUD showAutoMessage:@"添加他人银行卡"];
                AddBankCard3ViewController *vc = [[AddBankCard3ViewController alloc] init];
                YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
                nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
    }
    else
    {
        NSDictionary *bankInfo = [items objectAtIndex:actionSheet.tag];
        if(buttonIndex==0)
        {
            NSLog(@"重新审核");
            AddBankCard4ViewController *vc = [[AddBankCard4ViewController alloc] init];
            [vc getBankInfo:[bankInfo objectForKey:@"cust_bank_id"]];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            NSLog(@"删除");
            DeleteBankCard2ViewController *vc = [[DeleteBankCard2ViewController alloc] init];
            vc.bank = bankInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void) initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TabbarHeight-20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
//    _tableView.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

}
#pragma mark 下拉刷新数据
- (void)loadMoreData
{
    start = start + limit;
    limit = pageSize;
    [self requestServer];
}
- (void)loadData
{
    start = 0;
    limit = pageSize;
    [self requestServer];
}
- (void)endMJ
{
    if (start==0)
    {
        [_tableView.mj_header endRefreshing];
    }
    else
    {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

- (void)requestServer
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_banklist",@"funcId",
                                     [NSString stringWithFormat:@"%d",start],@"start",
                                     [NSString stringWithFormat:@"%d",limit],@"limit",
                                     
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         [self endMJ];
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
             if (start==0)
             {
                 [items removeAllObjects];
             }
             if(((response *)obj.responses[0]).items.count>0)
             {
                 [items addObjectsFromArray: ((response *)obj.responses[0]).items];
                 
             }
             [_tableView reloadData];
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
         [self endMJ];
         [items removeAllObjects];
         [_tableView reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
         
     }];
    
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
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:items.count];
    
    return items.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*APP_DELEGATE().autoSizeScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
//    headView.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
    
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"CellIdentifier";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }

    
//    cell.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    cell.backgroundColor = [UIColor whiteColor];
    
     NSDictionary *bank = [items objectAtIndex:indexPath.row];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 10*APP_DELEGATE().autoSizeScaleY, 290*APP_DELEGATE().autoSizeScaleX, 80*APP_DELEGATE().autoSizeScaleY)];
    UIImage *imageBG;
    
    
    if ([[bank objectForKey:@"audit_state"] intValue]==1)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@灰色@2x",[bank objectForKey:@"bank_type"]]
                                                         ofType:@"png"];
        NSLog(@"1111:%@",[NSString stringWithFormat:@"%@灰色@2x",[bank objectForKey:@"bank_type"]]);
          NSLog(@"path:%@",path);
        imageBG = [UIImage imageWithContentsOfFile:path];
    }
    else if ([[bank objectForKey:@"audit_state"] intValue]==2)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@红色@2x",[bank objectForKey:@"bank_type"]]
                                                         ofType:@"png"];
        NSLog(@"1111:%@",[NSString stringWithFormat:@"%@红色@2x",[bank objectForKey:@"bank_type"]]);
          NSLog(@"path:%@",path);
        imageBG = [UIImage imageWithContentsOfFile:path];
    }
    else if ([[bank objectForKey:@"audit_state"] intValue]==3)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@灰色@2x",[bank objectForKey:@"bank_type"]]
                                                         ofType:@"png"];
        NSLog(@"1111:%@",[NSString stringWithFormat:@"%@灰色@2x",[bank objectForKey:@"bank_type"]]);
        NSLog(@"path:%@",path);
        imageBG = [UIImage imageWithContentsOfFile:path];
    }

    NSLog(@"imageBG:%@",imageBG);
    if(imageBG)
    {
        bg.image = imageBG;
    }
    else
    {
        if ([[bank objectForKey:@"audit_state"] intValue]==1)
        {
            bg.image = [UIImage imageNamed:@"BANK灰色"];
        }
        else if ([[bank objectForKey:@"audit_state"] intValue]==2)
        {
            bg.image = [UIImage imageNamed:@"BANK红色"];
        }
        else if ([[bank objectForKey:@"audit_state"] intValue]==2)
        {
            bg.image = [UIImage imageNamed:@"BANK灰色"];
        }

        
    }

    [cell.contentView addSubview:bg];
    
    LRViewBorderRadius(bg,5,1,[UIColor clearColor]);
   
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(13*APP_DELEGATE().autoSizeScaleX, 18, 43, 43)];
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[bank objectForKey:@"bank_type"]]];
    
    if(image)
    {
        icon.image = image;
    }
    else
    {
        icon.image = [UIImage imageNamed:@"BANK"];
    }
    
    [bg addSubview:icon];
    
    
    
    UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(65*APP_DELEGATE().autoSizeScaleX, 5*APP_DELEGATE().autoSizeScaleY, 180*APP_DELEGATE().autoSizeScaleX, 25*APP_DELEGATE().autoSizeScaleY)];
    titleLable1.numberOfLines = 0;
    titleLable1.textAlignment = NSTextAlignmentLeft;
    titleLable1.font = viewFont1;
    titleLable1.textColor = fontColor;
    titleLable1.text = [NSString stringWithFormat:@"%@",[bank objectForKey:@"bank_name"]];
    [bg addSubview:titleLable1];
    
    UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(65*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY, 180*APP_DELEGATE().autoSizeScaleX, 25*APP_DELEGATE().autoSizeScaleY)];
    titleLable2.numberOfLines = 0;
    titleLable2.textAlignment = NSTextAlignmentLeft;
    titleLable2.font = viewFont1;
    titleLable2.textColor = fontColor;
    
    if ([[bank objectForKey:@"bankcard_type"] isEqualToString:@"CC"])
    {
        titleLable2.text = [NSString stringWithFormat:@"信用卡              %@",[bank objectForKey:@"bank_username"]];
    }
    else
    {
        titleLable2.text = [NSString stringWithFormat:@"储蓄卡              %@",[bank objectForKey:@"bank_username"]];
    }
    
    
    [bg addSubview:titleLable2];
    
    UILabel *titleLable3 = [[UILabel alloc] initWithFrame:CGRectMake(65*APP_DELEGATE().autoSizeScaleX, 55*APP_DELEGATE().autoSizeScaleY, 220*APP_DELEGATE().autoSizeScaleX, 25*APP_DELEGATE().autoSizeScaleY)];
    titleLable3.numberOfLines = 0;
    titleLable3.textAlignment = NSTextAlignmentLeft;
    titleLable3.font = viewFont2;
    titleLable3.textColor = fontColor;
    titleLable3.text = [NSString stringWithFormat:@"%@",[bank objectForKey:@"bankcard_no"]];
    [bg addSubview:titleLable3];
    
    NSString *bankcard_q = [titleLable3.text substringWithRange:NSMakeRange(0, 6)];
    NSString *bankcard_h = [titleLable3.text substringWithRange:NSMakeRange(titleLable3.text.length-4, 4)];
    titleLable3.text = [NSString stringWithFormat:@"%@*******%@",bankcard_q,bankcard_h];

    UILabel *titleLable4 = [[UILabel alloc] initWithFrame:CGRectMake(200*APP_DELEGATE().autoSizeScaleX, 55*APP_DELEGATE().autoSizeScaleY, 80*APP_DELEGATE().autoSizeScaleX, 25*APP_DELEGATE().autoSizeScaleY)];
    titleLable4.numberOfLines = 0;
    titleLable4.textAlignment = NSTextAlignmentRight;
    titleLable4.font = viewFont2;
    titleLable4.textColor = fontColor;
    if ([[bank objectForKey:@"audit_state"] intValue]==1)
    {
        titleLable4.text = @"审核中";
    }
    else if ([[bank objectForKey:@"audit_state"] intValue]==2)
    {
        titleLable4.text = @"审核通过";
    }
    else if ([[bank objectForKey:@"audit_state"] intValue]==3)
    {
        titleLable4.text = @"审核不通过";
    }
    [bg addSubview:titleLable4];

    
    return  cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *bankInfo = [items objectAtIndex:indexPath.row];
//    AccountDrawMoneyViewController *vc =[[AccountDrawMoneyViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    if ([[bankInfo objectForKey:@"is_own"] intValue]==1)
    {
        [UIAlertView showAlert:@"是否删除该银行卡？" delegate:self cancelButton:@"取消" otherButton:@"删除" tag:indexPath.row];
    }
    else
    {
        if ([[bankInfo objectForKey:@"audit_state"] intValue]==1)
        {
            [MBProgressHUD showAutoMessage:@"正在审核,请耐心等待"];
        }
        else  if ([[bankInfo objectForKey:@"audit_state"] intValue]==2)
        {
             [UIAlertView showAlert:@"是否删除该银行卡？" delegate:self cancelButton:@"取消" otherButton:@"删除" tag:indexPath.row];
        }
        else  if ([[bankInfo objectForKey:@"audit_state"] intValue]==3)
        {
            
//            [MBProgressHUD showAutoMessage:@"审核未通过,请提交银行卡信息重新审核"];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            [actionSheet addButtonWithTitle:@"重新提交"];
            [actionSheet addButtonWithTitle:@"删除"];
            [actionSheet addButtonWithTitle:@"取消"];
            actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
            actionSheet.tag = indexPath.row;
            actionSheet.delegate = self;
            [actionSheet showInView:self.view];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSDictionary *bankInfo = [items objectAtIndex:alertView.tag];
         if ([[bankInfo objectForKey:@"is_own"] intValue]==1)
         {
             DeleteBankCardViewController *vc = [[DeleteBankCardViewController alloc] init];
             vc.bank = bankInfo;
             [self.navigationController pushViewController:vc animated:YES];
         }
         else
         {
             DeleteBankCard2ViewController *vc = [[DeleteBankCard2ViewController alloc] init];
             vc.bank = bankInfo;
             [self.navigationController pushViewController:vc animated:YES];
         }
        
        
    }
    else
    {
        
    }
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:105/255.0 green:143/255.0 blue:243/255.0 alpha:1.0]
                                                title:@"管理"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     titleViewColor
                                                title:@"删除"];
    
    return rightUtilityButtons;
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"设置");
            [cell hideUtilityButtonsAnimated:YES];
            BankCardSettingViewController *vc =[[BankCardSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"删除");
            [cell hideUtilityButtonsAnimated:YES];
            DeleteBankCardViewController *vc = [[DeleteBankCardViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
