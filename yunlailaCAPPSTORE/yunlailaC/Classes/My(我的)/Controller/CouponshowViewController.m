//
//  CouponshowViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "CouponshowViewController.h"

@interface CouponshowViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items;
    int start;
    int limit;
}
@end

@implementation CouponshowViewController
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
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    if (IsIOS7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
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
    self.title = @"优惠券";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"fanhuijianfanhui" highIcon:@"fanhuijianfanhui" target:self action:@selector(pop:)];
    
    UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"使用说明" style:UIBarButtonItemStyleDone target:self action:@selector(changyong)];
    self.navigationItem.rightBarButtonItem = changyongItem;
    [self.navigationItem.rightBarButtonItem setTintColor:fontColor];
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

}
- (void)changyong
{
    NSLog(@"优惠券使用说明");
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"优惠券使用说明";
    vc.webURL = [NSString stringWithFormat:@"%@",instructionsURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)pop:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
                                     @"hex_client_queryCouponListByCustIdFunction",@"funcId",
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
             [self endMJ];
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
#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:items.count];
    

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

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section==items.count-1)
//    {
//        return 100;
//    }
//    else
//    {
//        return 0;
//    }
//    
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section==items.count-1)
//    {
//        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//        headView.backgroundColor = bgViewColor;
//        headView.userInteractionEnabled = YES;
//        
//        UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 20, 250*APP_DELEGATE().autoSizeScaleX, 30)];
//        [submitBtn setTitle:@"优惠券使用说明" forState:UIControlStateNormal];
//        [submitBtn setTitle:@"优惠券使用说明" forState:UIControlStateHighlighted];
//        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
//        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
//        [submitBtn addTarget:self
//                      action:@selector(submitBtnClick:)
//            forControlEvents:UIControlEventTouchUpInside];
//        submitBtn.titleLabel.font = viewFont1;
//        [headView addSubview:submitBtn];
//        
//        return headView;
//    }
//    else
//    {
//        return nil;
//    }
//   
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66*APP_DELEGATE().autoSizeScaleY;
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
        cell.backgroundColor = bgViewColor;
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    NSDictionary *info = [items objectAtIndex:indexPath.section];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 0, 300*APP_DELEGATE().autoSizeScaleX, 66*APP_DELEGATE().autoSizeScaleY)];
    bg.image = [UIImage imageNamed:@"youhuiquan"];
     [cell.contentView addSubview:bg];
    
//    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 0, 300*APP_DELEGATE().autoSizeScaleX, 55)];
//    bg.backgroundColor = [UIColor whiteColor];
//    [cell.contentView addSubview:bg];
    
    
    UILabel *jineLable = [[UILabel alloc] initWithFrame:CGRectMake(0*APP_DELEGATE().autoSizeScaleX, 5*APP_DELEGATE().autoSizeScaleY, 90*APP_DELEGATE().autoSizeScaleX, 66*APP_DELEGATE().autoSizeScaleY)];
    jineLable.numberOfLines = 1;
    jineLable.textAlignment = NSTextAlignmentCenter;
    jineLable.font = [UIFont systemFontOfSize:22];
    jineLable.textColor = [UIColor whiteColor];
    jineLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"coupon_value"]];
//    jineLable.text = @"1000.00";
    [bg addSubview:jineLable];
    
    
    UILabel *miaosuLable = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 10*APP_DELEGATE().autoSizeScaleY, 190*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
    miaosuLable.numberOfLines = 1;
    miaosuLable.textAlignment = NSTextAlignmentCenter;
    miaosuLable.font = viewFont3;
    miaosuLable.textColor = fontColor;
//    miaosuLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"coupon_member_id"]];
    miaosuLable.text = @"优惠卷";
    [bg addSubview:miaosuLable];
    
    UILabel *shijianLable = [[UILabel alloc] initWithFrame:CGRectMake(206*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY, 90*APP_DELEGATE().autoSizeScaleX, 45*APP_DELEGATE().autoSizeScaleY)];
    shijianLable.numberOfLines = 0;
    shijianLable.textAlignment = NSTextAlignmentLeft;
    shijianLable.font = viewFont3;
    shijianLable.textColor = fontColor;
    
    
    NSDateFormatter *dateFormatterShow = [[NSDateFormatter alloc] init];
    [dateFormatterShow setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormatterShow dateFromString:[NSString stringWithFormat:@"%@",[info objectForKey:@"expiration_time"]]];
    NSDateFormatter *dateFormatterShow1 = [[NSDateFormatter alloc] init];
    [dateFormatterShow1 setDateFormat:@"yyyy-MM-dd"];

    NSString *showString = [dateFormatterShow1 stringFromDate:date];
    
    shijianLable.text = showString;
    [bg addSubview:shijianLable];
    

    
    return cell;
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
   
    
}
@end
