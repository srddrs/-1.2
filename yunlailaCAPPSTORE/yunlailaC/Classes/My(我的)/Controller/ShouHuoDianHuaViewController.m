//
//  ShouHuoDianHuaViewController.m
//  yunlailaC
//
//  Created by admin on 16/11/1.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ShouHuoDianHuaViewController.h"
#import "AddShouHuoViewController.h"
@interface ShouHuoDianHuaViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items;
    int start;  //分页用
    int limit; //分页用
}
@end

@implementation ShouHuoDianHuaViewController
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
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing]; //下拉刷新
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

-(void)setUpNav
{
    self.title = @"常用收货电话";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
    UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"添加电话" style:UIBarButtonItemStyleDone target:self action:@selector(changyong:)];
    self.navigationItem.rightBarButtonItem = changyongItem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void) initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - 20 )];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)changyong:(id)sender
{
    //    [self ALiPayFunction];
    AddShouHuoViewController *vc =  [[AddShouHuoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  上拉加载更多
 */
- (void)loadMoreData
{
    start = start + limit;
    limit = pageSize;
    [self requestServer];
}
/**
 *  @author 徐杨
 *
 *  下拉刷新调用
 */
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
                                     @"hex_client_consignee_queryPhoneFunction",@"funcId",
                                     //                                     [NSString stringWithFormat:@"%d",start],@"start",
                                     //                                     [NSString stringWithFormat:@"%d",limit],@"limit",
                                     
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
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:items.count];
    
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10*APP_DELEGATE().autoSizeScaleY;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DELEGATE().autoSizeScaleX, 10*APP_DELEGATE().autoSizeScaleY)];
    headView.backgroundColor = bgViewColor;
    return headView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*APP_DELEGATE().autoSizeScaleY;
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
    
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    NSDictionary *info = [items objectAtIndex:indexPath.row];
    
    
    //    yglb_touxiang@2x
//    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 15*APP_DELEGATE().autoSizeScaleY, 40*APP_DELEGATE().autoSizeScaleY, 40*APP_DELEGATE().autoSizeScaleY)];
//    logoView.image = [UIImage imageNamed:@"yglb_touxiang"];
//    [cell.contentView addSubview:logoView];
    
    UILabel *xingmingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 15*APP_DELEGATE().autoSizeScaleY, 100*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
    xingmingLabel.backgroundColor = [UIColor whiteColor];
    xingmingLabel.textColor = fontColor;
    xingmingLabel.textAlignment = NSTextAlignmentLeft;
    xingmingLabel.lineBreakMode = NSLineBreakByWordWrapping;
    xingmingLabel.numberOfLines = 0;
    xingmingLabel.font = viewFont2;
    xingmingLabel.text = [NSString stringWithFormat:@"姓名:%@", [info objectForKey:@"consignee_name"]];
    [cell.contentView addSubview:xingmingLabel];
    
    CGSize size = [xingmingLabel boundingRectWithSize:CGSizeMake(10*APP_DELEGATE().autoSizeScaleX, 0)];
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame: CGRectMake(60*APP_DELEGATE().autoSizeScaleX + size.width+20*APP_DELEGATE().autoSizeScaleX, 10*APP_DELEGATE().autoSizeScaleY,30*APP_DELEGATE().autoSizeScaleY, 30*APP_DELEGATE().autoSizeScaleY)];
    [phoneBtn setImage:[UIImage imageNamed:@"grzx_dianhua"] forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"grzx_dianhua"] forState:UIControlStateHighlighted];
    [phoneBtn addTarget:self
                 action:@selector(phoneBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:phoneBtn];
    phoneBtn.tag = indexPath.row;
    
    
    
    UILabel *dianhuaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 37*APP_DELEGATE().autoSizeScaleY, 240*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
    dianhuaLabel.backgroundColor = [UIColor whiteColor];
    dianhuaLabel.textColor = fontHuiColor;
    dianhuaLabel.textAlignment = NSTextAlignmentLeft;
    dianhuaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dianhuaLabel.numberOfLines = 0;
    dianhuaLabel.font = viewFont2;
    dianhuaLabel.text = [NSString stringWithFormat:@"电话:%@",[info objectForKey:@"consignee_phone"]];
//    dianhuaLabel.text = @"电话: 0817-6237338";
    [cell.contentView addSubview:dianhuaLabel];
    
    
    UIButton *actionBtn = [[UIButton alloc] initWithFrame: CGRectMake(280*APP_DELEGATE().autoSizeScaleX, 15*APP_DELEGATE().autoSizeScaleY,40*APP_DELEGATE().autoSizeScaleY, 40*APP_DELEGATE().autoSizeScaleY)];
    [actionBtn setImage:[UIImage imageNamed:@"yglb_shancu"] forState:UIControlStateNormal];
    [actionBtn setImage:[UIImage imageNamed:@"yglb_shancu"] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self
                  action:@selector(actionBtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:actionBtn];
    actionBtn.tag = indexPath.row;
    
    
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(5*APP_DELEGATE().autoSizeScaleX, 69*APP_DELEGATE().autoSizeScaleY, 310*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [items objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:[info objectForKey:@"consignee_phone"]]]];
}

- (void)phoneBtnClick:(UIButton *)sender
{
    NSDictionary *info = [items objectAtIndex:sender.tag];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:[info objectForKey:@"consignee_phone"]]]];
}

- (void)actionBtnClick:(UIButton *)sender
{
    [UIAlertView showAlert:@"是否确认并且删除收货电话？" delegate:self cancelButton:@"取消" otherButton:@"确认" tag:sender.tag];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"解绑");
        NSDictionary *info = [items objectAtIndex:alertView.tag];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_consignee_deletePhoneByIdFunction",@"funcId",
                                         [info objectForKey:@"consignee_phone_id"],@"consignee_phone_id",
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
                 [MBProgressHUD showAutoMessage:@"删除收货电话成功"];
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
             [MBProgressHUD showError:@"登录失败,网络异常" toView:self.view];
         }];
        
    }
}
@end
