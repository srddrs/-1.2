//
//  ChangYongGetAddressViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ChangYongGetAddressViewController.h"
#import "SWTableViewCell.h"
#import "AddGetAddressViewController.h"
#import "EditGetAddressViewController.h"
@interface ChangYongGetAddressViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items;
    int start;
    int limit;
}
@end

@implementation ChangYongGetAddressViewController
@synthesize isSetting;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        items = [[NSMutableArray alloc] init];
        start = 0;
        limit = pageSize;
        isSetting = NO;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];
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
    self.title = @"常用收货地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
    UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"新增地址" style:UIBarButtonItemStyleDone target:self action:@selector(changyong)];
    self.navigationItem.rightBarButtonItem = changyongItem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
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
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

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
-(void)requestServer
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_receiptaddress_list",@"funcId",
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
         self.noDataImage.hidden = NO;
         [self.view bringSubviewToFront:self.noDataImage];
         
     }];

}

- (void)changyong
{
    AddGetAddressViewController *vc = [[AddGetAddressViewController alloc] init];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)pop:(id)sender
{
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (items.count==0)
    {
        self.noDataImage.hidden = NO;
        [self.view bringSubviewToFront:self.noDataImage];
        
    }
    else
    {
        self.noDataImage.hidden = YES;
//        [self.view bringSubviewToFront:_tableView];
    }
    return items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
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
    return 105;
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
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    for (UIView *view in cell.contentView.subviews)
    {
            [view removeFromSuperview];
    }
    
    if (isSetting==YES)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    
    NSDictionary *item = [items objectAtIndex:indexPath.section];
    
    UILabel *usernameLable = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 10, 100*APP_DELEGATE().autoSizeScaleX, 35)];
    usernameLable.numberOfLines = 0;
    usernameLable.textAlignment = NSTextAlignmentLeft;
    usernameLable.font = viewFont1;
    usernameLable.textColor = fontColor;
    usernameLable.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"user_name"]];
    [cell.contentView addSubview:usernameLable];
    
//    CGSize size = [usernameLable boundingRectWithSize:CGSizeMake(300*APP_DELEGATE().autoSizeScaleX, 35)];
//    usernameLable.frame = CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, size.width*APP_DELEGATE().autoSizeScaleX,35);
    
    UILabel *userphoneLable = [[UILabel alloc] initWithFrame:CGRectMake(200*APP_DELEGATE().autoSizeScaleX, 5, 110*APP_DELEGATE().autoSizeScaleX, 35)];
    userphoneLable.numberOfLines = 0;
    userphoneLable.textAlignment = NSTextAlignmentRight;
    userphoneLable.font = viewFont1;
    userphoneLable.textColor = fontColor;
    userphoneLable.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"phone"]];
    [cell.contentView addSubview:userphoneLable];

    
    UILabel *addressLable = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 35, 270*APP_DELEGATE().autoSizeScaleX, 35)];
    addressLable.numberOfLines = 0;
    addressLable.textAlignment = NSTextAlignmentLeft;
    addressLable.font = viewFont1;
    addressLable.textColor = [UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1];
    addressLable.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"address"]];
    [cell.contentView addSubview:addressLable];
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];

    
    UIButton *setDefBtn =  [[UIButton alloc] initWithFrame: CGRectMake(0, 70,110*APP_DELEGATE().autoSizeScaleX, 40)];
    setDefBtn.tag = indexPath.section;
    [setDefBtn addTarget:self
                  action:@selector(setDefBtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:setDefBtn];
    
    UIImageView *gouImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 10, 77, 15)];
    if (indexPath.section==0)
    {
        gouImage.image = [UIImage imageNamed:@"moren_xuanzhongzi@3x"] ;
    }
    else
    {
        gouImage.image = [UIImage imageNamed:@"moren_weixuanzhongzi@3x"];
    }
    
    
    
    [setDefBtn addSubview:gouImage];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame: CGRectMake(240*APP_DELEGATE().autoSizeScaleX, 67, 80*APP_DELEGATE().autoSizeScaleX, 40)];
    UIImageView *editImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bianji"]];
    editImg.center = CGPointMake(40*APP_DELEGATE().autoSizeScaleX, 20);
    [editBtn addSubview:editImg];
    editBtn.tag = indexPath.section;
    [editBtn addTarget:self
                action:@selector(editBtnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:editBtn];

    
    return cell;
    
}

- (void)editBtnClick:(UIButton *)sender
{
    NSDictionary *addressInfo = [items objectAtIndex:sender.tag];
    EditGetAddressViewController *vc =[[EditGetAddressViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setAddInfo:addressInfo];
    
}


- (void)setDefBtnClick:(UIButton *)sender
{
    NSDictionary *addressInfo = [items objectAtIndex:sender.tag];
    
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_receiptaddress_default",@"funcId",
                                     [addressInfo objectForKey:@"recript_address_id"],@"receiptaddressId",
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
             [MBProgressHUD showSuccess:@"设置成功" toView:self.view];
             [self loadData];
             [_tableView setContentOffset:CGPointMake(0,0) animated:NO];
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
         [MBProgressHUD showError:@"设置失败" toView:self.view];
     }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (isSetting==NO)
     {
         NSDictionary *addressInfo = [items objectAtIndex:indexPath.section];
         
         [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_XuanChangyong1 object:nil userInfo:addressInfo];
         [self.navigationController popViewControllerAnimated:YES];

     }
    
    
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     titleViewColor
                                                title:@"删除"];
    return rightUtilityButtons;
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
//        case 0:
//        {
//            NSLog(@"编辑");
//            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//            NSLog(@"%d",indexPath.section);
//            NSDictionary *addressInfo = [items objectAtIndex:indexPath.section];
//            [cell hideUtilityButtonsAnimated:YES];
//            EditGetAddressViewController *vc =[[EditGetAddressViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            [vc setAddInfo:addressInfo];
//        }
//            break;
        case 0:
        {
            NSLog(@"删除");
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            [UIAlertView showAlert:@"是否确认删除该收货地址？" delegate:self cancelButton:@"取消" otherButton:@"删除" tag:indexPath.section];
        }
            break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:alertView.tag];
    SWTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [cell hideUtilityButtonsAnimated:YES];
    if (buttonIndex==1)
    {
        NSLog(@"删除");
        
        
        NSDictionary *addressInfo = [items objectAtIndex:alertView.tag];
        
        
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_receiptaddress_delete",@"funcId",
                                         [NSString stringWithFormat:@"%@",[addressInfo objectForKey:@"recript_address_id"]],@"recript_address_id",
                                         
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
                 [MBProgressHUD showAutoMessage:@"删除收货地址成功"];
                 [self loadData];
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
             [MBProgressHUD showError:@"删除收货地址失败" toView:self.view];
         }];
        
    }
    else
    {
        NSLog(@"取消");
    }
    
}
@end
