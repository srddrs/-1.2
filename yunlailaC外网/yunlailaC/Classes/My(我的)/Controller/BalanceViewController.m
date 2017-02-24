//
//  BalanceViewController.m
//  yunlailaC
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "BalanceViewController.h"

@interface BalanceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items;
    int start;  //分页用
    int limit; //分页用
}
@end

@implementation BalanceViewController
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
    self.title = @"收支明细";
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
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
                                     @"hex_freightvoucher_queryCurrentFunction",@"funcId",
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*APP_DELEGATE().autoSizeScaleY;
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
    
    
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 0*APP_DELEGATE().autoSizeScaleY, 40*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
    typeLabel.backgroundColor = [UIColor whiteColor];
    typeLabel.textColor = fontColor;
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    typeLabel.numberOfLines = 0;
    typeLabel.font = viewFont3;
    if ([[info objectForKey:@"use_type"] integerValue]==1)
    {
        if ([[info objectForKey:@"amount"] floatValue]>0)
        {
            typeLabel.text = @"充值";
        }
        else
        {
            typeLabel.text = @"使用";
        }
        
    }
    else if ([[info objectForKey:@"use_type"] integerValue]==2)
    {
        typeLabel.text = @"赠送";
    }
    
    [cell.contentView addSubview:typeLabel];

    UILabel *shijianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY, 190*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
    shijianLabel.backgroundColor = [UIColor whiteColor];
    shijianLabel.textColor = fontColor;
    shijianLabel.textAlignment = NSTextAlignmentLeft;
    shijianLabel.lineBreakMode = NSLineBreakByWordWrapping;
    shijianLabel.numberOfLines = 0;
    shijianLabel.font = viewFont2;
    shijianLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"operate_time"]];
    [cell.contentView addSubview:shijianLabel];

   
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(180*APP_DELEGATE().autoSizeScaleX, 0*APP_DELEGATE().autoSizeScaleY, 120*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
    amountLabel.backgroundColor = [UIColor whiteColor];
    amountLabel.textColor = titleViewColor;
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.lineBreakMode = NSLineBreakByWordWrapping;
    amountLabel.numberOfLines = 0;
    amountLabel.font = viewFont3;
    amountLabel.text = [NSString stringWithFormat:@"%@元",[info objectForKey:@"amount"]];
    [cell.contentView addSubview:amountLabel];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(180*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY, 120*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
    cityLabel.backgroundColor = [UIColor whiteColor];
    cityLabel.textColor = fontColor;
    cityLabel.textAlignment = NSTextAlignmentRight;
    cityLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cityLabel.numberOfLines = 0;
    cityLabel.font = viewFont3;
    cityLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"use_city"]];
    [cell.contentView addSubview:cityLabel];

    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 59*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
