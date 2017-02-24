//
//  ReceiptViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ReceiptViewController.h"
#import "SWTableViewCell.h"
#import "YunDanGenZongViewController.h"
@interface ReceiptViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items; //列表数据
    int start; //分页用1
    int limit; //分页用2
}
@end

@implementation ReceiptViewController
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

- (void)setUpNav
{
    self.title = @"回单";
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

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
}
/**
 *  @author 徐杨
 *
 *  上提更多
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
 *  下拉刷新
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
 *  结束刷新
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
 *  服务器交互
 */
- (void)requestServer
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_driver_waybill_queryReceiptByCustIdFunction",@"funcId",
                                     [NSString stringWithFormat:@"%d",start],@"start",
                                     [NSString stringWithFormat:@"%d",limit],@"limit",
                                     
                                     nil];
    
    [helper Soap:ms_driverURL Parameters:paramDic Success:^(id responseObject)
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
    return 393/2;
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
    cell.backgroundColor = bgViewColor;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *info = [items objectAtIndex:indexPath.section];
    
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(8*APP_DELEGATE().autoSizeScaleX, 0, 304*APP_DELEGATE().autoSizeScaleX, 393/2)];
    bg.image = [UIImage imageNamed:@"dsk_kapian"];
    [cell.contentView addSubview:bg];
    bg.userInteractionEnabled = YES;
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 304*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bg addSubview:fgx];
    
    
    UILabel *e_station_brLable = [[UILabel alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 30)];
    e_station_brLable.numberOfLines = 0;
    e_station_brLable.textAlignment = NSTextAlignmentLeft;
    e_station_brLable.font = viewFont1;
    e_station_brLable.textColor = fontOrangeColor;
    e_station_brLable.text = [NSString stringWithFormat:@"到站:%@",[info objectForKey:@"e_station_city"]];
    [bg addSubview:e_station_brLable];
    
    //订单号
    UIImageView *j_waybill_noIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 40+3, 15, 15)];
    j_waybill_noIcon.image = [UIImage imageNamed:@"dsk_yundanhao"];
    [bg addSubview:j_waybill_noIcon];
    
    UILabel *j_waybill_noLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 40, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    j_waybill_noLable.numberOfLines = 0;
    j_waybill_noLable.textAlignment = NSTextAlignmentLeft;
    j_waybill_noLable.font = viewFont3;
    j_waybill_noLable.textColor = fontColor;
    j_waybill_noLable.text = [NSString stringWithFormat:@"运单号:%@",[info objectForKey:@"j_waybill_no"]];
    [bg addSubview:j_waybill_noLable];
    
    //收货人
    UIImageView *shipper_nameIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 68+3, 15, 15)];
    shipper_nameIcon.image = [UIImage imageNamed:@"dsk_shouhuoren"];
    [bg addSubview:shipper_nameIcon];
    
    UILabel *shipper_nameLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 68, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    shipper_nameLable.numberOfLines = 0;
    shipper_nameLable.textAlignment = NSTextAlignmentLeft;
    shipper_nameLable.font = viewFont3;
    shipper_nameLable.textColor = fontColor;
    shipper_nameLable.text = [NSString stringWithFormat:@"收货人:%@",[info objectForKey:@"consignee"]];
    [bg addSubview:shipper_nameLable];
    
    //货物
    UIImageView *goods_nameIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 96+3, 15, 15)];
    goods_nameIcon.image = [UIImage imageNamed:@"sh_huowu"];
    [bg addSubview:goods_nameIcon];
    
    UILabel *goods_nameLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 96, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    goods_nameLable.numberOfLines = 0;
    goods_nameLable.textAlignment = NSTextAlignmentLeft;
    goods_nameLable.font = viewFont3;
    goods_nameLable.textColor = fontColor;
    goods_nameLable.text = [NSString stringWithFormat:@"货物:%@   %@件",[info objectForKey:@"goods_name"],[info objectForKey:@"goods_total_num"]];
    [bg addSubview:goods_nameLable];
    
    //时间
    UIImageView *dateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 127, 15, 15)];
    dateIcon.image = [UIImage imageNamed:@"sh_shijian"];
    [bg addSubview:dateIcon];
    
    UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 124, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    dateLable.numberOfLines = 0;
    dateLable.textAlignment = NSTextAlignmentLeft;
    dateLable.font = viewFont3;
    dateLable.textColor = fontColor;
    dateLable.text = [NSString stringWithFormat:@"时间:%@",[info objectForKey:@"date"]];
    [bg addSubview:dateLable];
    
    
    UIButton *genzhongBtn = [[UIButton alloc] initWithFrame: CGRectMake(76*APP_DELEGATE().autoSizeScaleX, 150,152*APP_DELEGATE().autoSizeScaleX, 45)];
    [genzhongBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:246/255.0 green:247/255.0 blue:251/255.0 alpha:1]] forState:UIControlStateNormal];
    [genzhongBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:234/255.0 green:238/255.0 blue:253/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [genzhongBtn setImage:[UIImage imageNamed:@"sh_yundangenzong"] forState:UIControlStateNormal];
    [genzhongBtn setImage:[UIImage imageNamed:@"sh_yundangenzong"] forState:UIControlStateHighlighted];
    [genzhongBtn addTarget:self
                    action:@selector(traceBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:genzhongBtn];
    genzhongBtn.tag = indexPath.section;

    return cell;
}

/**
 *  @author 徐杨
 *
 *  跟踪事件
 *
 *  @param sender
 */
-(void)traceBtnClick:(UIButton *)sender
{
    NSLog(@"运单跟踪");
    NSDictionary *info = [items objectAtIndex:sender.tag];
    
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"运单跟踪";
    vc.webURL = [NSString stringWithFormat:@"%@?waybillNum=%@&type=3",waybillDetailsURL,[info objectForKey:@"j_waybill_no"]];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = [items objectAtIndex:indexPath.section];
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"运单明细";
    vc.webURL = [NSString stringWithFormat:@"%@?waybillNum=%@",orderOpenURL,[info objectForKey:@"waybill_id"]];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];

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
            
//            YunDanGenZongViewController *vc = [[YunDanGenZongViewController alloc] init];
//            YLLWhiteNavViewController *nav = [[YLLWhiteNavViewController alloc] initWithRootViewController:vc];
//            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            [self presentViewController:nav animated:YES completion:nil];
//            [vc setSegmentMenu:1];
        }
            break;
        default:
            break;
    }
}

@end
