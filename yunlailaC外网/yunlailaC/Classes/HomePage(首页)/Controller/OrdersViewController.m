//
//  DingDansViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "OrdersViewController.h"
#import "SWTableViewCell.h"
#import "OrderViewController.h"
@interface OrdersViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;//列表
    NSMutableArray *items; //列表数据
    int start;  //分页用
    int limit; //分页用
}
@end

@implementation OrdersViewController
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @author 徐杨
 *
 *  标题栏初始化
 */
- (void)setUpNav
{
    self.title = @"发货订单";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

/**
 *  @author 徐杨
 *
 *  视图初始化
 */
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
/**
 *  @author 徐杨
 *
 *  刷新结束
 */
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
/**
 *  @author 徐杨
 *
 *  请求服务器
 */
- (void)requestServer
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_indent_list",@"funcId",
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
    return 154;
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
    cell.backgroundColor = [UIColor clearColor];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *info = [items objectAtIndex:indexPath.section];
    
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(8*APP_DELEGATE().autoSizeScaleX, 0, 304*APP_DELEGATE().autoSizeScaleX, 308/2)];
    bg.image = [UIImage imageNamed:@"dd_kapian"];
    [cell.contentView addSubview:bg];
    bg.userInteractionEnabled = YES;
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 304*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bg addSubview:fgx];
   
    UILabel *e_station_brLable = [[UILabel alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 0, 220*APP_DELEGATE().autoSizeScaleX, 38)];
    e_station_brLable.numberOfLines = 1;
    e_station_brLable.textAlignment = NSTextAlignmentLeft;
    e_station_brLable.font = viewFont1;
    e_station_brLable.textColor = fontOrangeColor;
    e_station_brLable.lineBreakMode = NSLineBreakByTruncatingHead;

    if ([[info objectForKey:@"receive_city"] length]==0)
    {
        e_station_brLable.text = [NSString stringWithFormat:@"%@%@",[info objectForKey:@"shipper_city"],[info objectForKey:@"shipper_address"]];
    }
    else
    {
        e_station_brLable.text = [NSString stringWithFormat:@"%@%@---%@",[info objectForKey:@"shipper_city"],[info objectForKey:@"shipper_address"],[info objectForKey:@"receive_city"]];
    }
    
    [bg addSubview:e_station_brLable];
    
    //状态
    UILabel *statusLable = [[UILabel alloc] initWithFrame:CGRectMake(210*APP_DELEGATE().autoSizeScaleX, 0, 80*APP_DELEGATE().autoSizeScaleX, 38)];
    statusLable.numberOfLines = 0;
    statusLable.textAlignment = NSTextAlignmentRight;
    statusLable.font = viewFont4;
    statusLable.textColor = fontOrangeColor;
    
    NSString *statusString;
    if ([[info objectForKey:@"status"] intValue]==1)
    {
        statusString = @"提交订单";
    }
    else if ([[info objectForKey:@"status"] intValue]==2)
    {
        statusString = @"司机接单";
    }
    else if ([[info objectForKey:@"status"] intValue]==3)
    {
        statusString = @"完成";
    }
    
    else if ([[info objectForKey:@"status"] intValue]==4)
    {
        statusString = @"取消订单";
    }
    
    else if ([[info objectForKey:@"status"] intValue]==5)
    {
        statusString = @"已派运单";
    }
    
    
    statusLable.text = statusString;
    [cell.contentView addSubview:statusLable];

    //订单号
    UIImageView *yundanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 45+3, 15, 15)];
    yundanIcon.image = [UIImage imageNamed:@"dsk_yundanhao"];
    [bg addSubview:yundanIcon];
    
    UILabel *yundanLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 45, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    yundanLable.numberOfLines = 0;
    yundanLable.textAlignment = NSTextAlignmentLeft;
    yundanLable.font = viewFont3;
    yundanLable.textColor = fontColor;
    yundanLable.text = [NSString stringWithFormat:@"订单号:%@",[info objectForKey:@"indent_id"]];
    [bg addSubview:yundanLable];

    //发货人
    UIImageView *shouhuorenIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 45+3 +28, 15, 15)];
    shouhuorenIcon.image = [UIImage imageNamed:@"dsk_shouhuoren"];
    [bg addSubview:shouhuorenIcon];
    
    UILabel *shouhuorenLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 45+28, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    shouhuorenLable.numberOfLines = 0;
    shouhuorenLable.textAlignment = NSTextAlignmentLeft;
    shouhuorenLable.font = viewFont3;
    shouhuorenLable.textColor = fontColor;
    shouhuorenLable.text = [NSString stringWithFormat:@"发货人:%@",[info objectForKey:@"shipper"]];
    [bg addSubview:shouhuorenLable];
    
    
    //货物名称
    UIImageView *nameIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 45+3 +28*2, 15, 15)];
    nameIcon.image = [UIImage imageNamed:@"sh_huowu"];
    [bg addSubview:nameIcon];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 45+28*2, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = viewFont3;
    nameLabel.textColor = fontColor;
    nameLabel.text = [NSString stringWithFormat:@"货物:%@   %@件",[info objectForKey:@"product_name"],[info objectForKey:@"number"]];
    [bg addSubview:nameLabel];
    
    //时间
    UIImageView *timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 45+3 +28*3, 15, 15)];
    timeIcon.image = [UIImage imageNamed:@"sh_shijian"];
    [bg addSubview:timeIcon];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 45+28*3, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    timeLabel.numberOfLines = 0;
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = viewFont3;
    timeLabel.textColor = fontColor;
    timeLabel.text = [NSString stringWithFormat:@"时间:%@",[info objectForKey:@"indent_date"]];
    [bg addSubview:timeLabel];

   
//    //订单时间
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 57, 260*APP_DELEGATE().autoSizeScaleX, 22)];
//    timeLabel.backgroundColor = [UIColor clearColor];
//    timeLabel.textColor = fontColor;
//    timeLabel.textAlignment = NSTextAlignmentLeft;
//    timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    timeLabel.numberOfLines = 0;
//    timeLabel.font = viewFont2;
//    timeLabel.text = [NSString stringWithFormat:@"时间:%@",[info objectForKey:@"indent_date"]];
//    [cell.contentView addSubview:timeLabel];



    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = [items objectAtIndex:indexPath.section];
    OrderViewController *vc = [[OrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.order = item;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:105/255.0 green:143/255.0 blue:243/255.0 alpha:1.0]
                                                title:@"删除"];
    return rightUtilityButtons;
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"删除");
            [cell hideUtilityButtonsAnimated:YES];
        }
            break;
        default:
            break;
    }
}

@end
