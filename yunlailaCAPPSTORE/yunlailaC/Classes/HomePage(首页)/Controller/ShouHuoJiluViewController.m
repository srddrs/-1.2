//
//  ShouHuoJiluViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ShouHuoJiluViewController.h"
#import "SWTableViewCell.h"
#import "YunDanGenZongViewController.h"
#import "ReservationViewController.h"
@interface ShouHuoJiluViewController ()<WJSegmentMenuDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items1;
    NSMutableArray *items2;
    int start;
    int limit;
    int type;  //已收
}
@end

@implementation ShouHuoJiluViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        items1 = [[NSMutableArray alloc] init];
        items2 = [[NSMutableArray alloc] init];
        start = 0;
        limit = pageSize *100;
        type = 0;
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
    self.title = @"运单";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void) initView
{
    WJSegmentMenu *segmentMenu = [[WJSegmentMenu alloc]initWithFrame:CGRectMake(0, 1, 320, 30)];
    segmentMenu.delegate = self;
    [segmentMenu segmentWithTitles:@[@"发货运单",@"收货运单"]];

    [self.view addSubview:segmentMenu];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 31*APP_DELEGATE().autoSizeScaleY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20 - TabbarHeight -31*APP_DELEGATE().autoSizeScaleY)];
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

- (void)segmentWithIndex:(NSInteger)index title:(NSString *)title
{
    if (index==0)
    {
        NSLog(@"发的");
        type = 0;
        [self loadData];
    }
    else
    {
        
        NSLog(@"收的");
        type = 1;
        [self loadData];
    }
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
   NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    NSString *account_id = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"account_id"]];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_customer_waybill_queryCustomerSendedWaybillByPhoneFunction",@"funcId",
                                     account_id,@"consignee_phone",
//                                     @"18990867016",@"consignee_phone",
                                     [NSString stringWithFormat:@"%d",start],@"start",
                                     [NSString stringWithFormat:@"%d",limit],@"limit",
                                     
                                     nil];
    if (type==0)
    {
        [paramDic setObject:@"1" forKey:@"type"];
    }
    else
    {
        [paramDic setObject:@"2" forKey:@"type"];
    }
    [helper Soap:ms_driverURL Parameters:paramDic Success:^(id responseObject)
     {
        
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
          [self endMJ];
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
                 if (type==0)
                 {
                     [items1 removeAllObjects];
                 }
                 else
                 {
                     [items2 removeAllObjects];
                 }
             }
             if(((response *)obj.responses[0]).items.count>0)
             {
//                  状态(-1：删除，0:正常、1:锁定、2:作废3:运输中,4,等待代收款上传,5等待客户领取；6：已到目的地9：完成)
                 if (type==0)
                 {
                     [items1 addObjectsFromArray: ((response *)obj.responses[0]).items];
                 }
                 else
                 {
                     [items2 addObjectsFromArray: ((response *)obj.responses[0]).items];
                 }
                 
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
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [_tableView reloadData];
     }];
    
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (type==0)
    {
         [tableView tableViewDisplayWitMsg1:@"暂无数据" ifNecessaryForRowCount:items1.count];
        return items1.count;
    }
    else
    {
        [tableView tableViewDisplayWitMsg1:@"暂无数据" ifNecessaryForRowCount:items2.count];
        return items2.count;
    }
   
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
    NSDictionary *info;
    if (type==0)
    {
        info = [items1 objectAtIndex:indexPath.section];
    }
    else
    {
        info = [items2 objectAtIndex:indexPath.section];
    }
    
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
    e_station_brLable.text = [NSString stringWithFormat:@"到站:%@",[info objectForKey:@"e_station_br"]];
    [bg addSubview:e_station_brLable];
    
    //状态
    UILabel *statusLable = [[UILabel alloc] initWithFrame:CGRectMake(190*APP_DELEGATE().autoSizeScaleX, 0, 100*APP_DELEGATE().autoSizeScaleX, 30)];
    statusLable.numberOfLines = 0;
    statusLable.textAlignment = NSTextAlignmentRight;
    statusLable.font = viewFont4;
    statusLable.textColor = fontOrangeColor;
    
//    状态(-1：删除，0:正常、1:锁定、2:作废3:运输中,4,等待代收款上传,5等待客户领取；6：已到目的地9：完成)
    
    NSString *statusString;
    if ([[info objectForKey:@"status"] intValue]==-1)
    {
        statusString = @"删除";
    }
    else if ([[info objectForKey:@"status"] intValue]==0)
    {
        statusString = @"正常";
    }
    else if ([[info objectForKey:@"status"] intValue]==1)
    {
        statusString = @"锁定";
    }
    
    else if ([[info objectForKey:@"status"] intValue]==2)
    {
        statusString = @"作废";
    }
    
    else if ([[info objectForKey:@"status"] intValue]==3)
    {
        statusString = @"运输中";
    }
    else if ([[info objectForKey:@"status"] intValue]==4)
    {
        statusString = @"等待代收款上传";
    }
    else if ([[info objectForKey:@"status"] intValue]==5)
    {
        statusString = @"等待客户领取";
    }
    else if ([[info objectForKey:@"status"] intValue]==6)
    {
        statusString = @"已到目的地";
    }
    else if ([[info objectForKey:@"status"] intValue]==7)
    {
        statusString = @"代收款领取中";
    }
    else if ([[info objectForKey:@"status"] intValue]==8)
    {
        statusString = @"原货返回";
    }
    else if ([[info objectForKey:@"status"] intValue]==9)
    {
        statusString = @"完成";
    }
    
    statusLable.text = statusString;
    [cell.contentView addSubview:statusLable];
    
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
    shipper_nameLable.text = [NSString stringWithFormat:@"发货人:%@",[info objectForKey:@"shipper_name"]];
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
    
    NSString *goods_total_weight = [NSString stringWithFormat:@"%0.1f",[[info objectForKey:@"goods_total_weight"] doubleValue]];
    NSString *goods_total_volume = [NSString stringWithFormat:@"%0.1f",[[info objectForKey:@"goods_total_volume"] doubleValue]];
    goods_nameLable.text = [NSString stringWithFormat:@"货物:%@   %@件/%@吨/%@方",[info objectForKey:@"goods_name"],[info objectForKey:@"goods_total_num"],goods_total_weight,goods_total_volume];
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
    
    
    UIButton *genzhongBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 150,152*APP_DELEGATE().autoSizeScaleX, 45)];
    [genzhongBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:246/255.0 green:247/255.0 blue:251/255.0 alpha:1]] forState:UIControlStateNormal];
    [genzhongBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:234/255.0 green:238/255.0 blue:253/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [genzhongBtn setImage:[UIImage imageNamed:@"sh_yundangenzong"] forState:UIControlStateNormal];
    [genzhongBtn setImage:[UIImage imageNamed:@"sh_yundangenzong"] forState:UIControlStateHighlighted];
    [genzhongBtn addTarget:self
                    action:@selector(traceBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:genzhongBtn];
    genzhongBtn.tag = indexPath.section;
    
    
    
    UIButton *shenqingBtn = [[UIButton alloc] initWithFrame: CGRectMake(152*APP_DELEGATE().autoSizeScaleX, 150,152*APP_DELEGATE().autoSizeScaleX, 45)];
    [shenqingBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:246/255.0 green:247/255.0 blue:251/255.0 alpha:1]] forState:UIControlStateNormal];
    [shenqingBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:234/255.0 green:238/255.0 blue:253/255.0 alpha:1]] forState:UIControlStateHighlighted];
    
    if ([[info objectForKey:@"status"] intValue] == 6) //已到
    {
        if ([[info objectForKey:@"is_order_send"] intValue] == 1)//表示已填写预约收货
        {
            [shenqingBtn setImage:[UIImage imageNamed:@"sh_yiyuyue"] forState:UIControlStateNormal];
            [shenqingBtn setImage:[UIImage imageNamed:@"sh_yiyuyue"] forState:UIControlStateHighlighted];
        }
        else
        {
            [shenqingBtn setImage:[UIImage imageNamed:@"sh_yuyuesonghuo"] forState:UIControlStateNormal];
            [shenqingBtn setImage:[UIImage imageNamed:@"sh_yuyuesonghuo"] forState:UIControlStateHighlighted];
        }
        [shenqingBtn addTarget:self
                        action:@selector(reservationBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:shenqingBtn];
        shenqingBtn.tag = indexPath.section;

        UILabel *fgx2 = [[UILabel alloc] initWithFrame:CGRectMake(160*APP_DELEGATE().autoSizeScaleX, 151, 1, 45)];
        fgx2.backgroundColor = bgViewColor;
        [cell.contentView addSubview:fgx2];
        
    }
    else
    {
        genzhongBtn.frame = CGRectMake(0*APP_DELEGATE().autoSizeScaleX, 150,300*APP_DELEGATE().autoSizeScaleX, 45);
        fgx.hidden = YES;
    }
    
   
    
    
    UIView *yuanView1 = [[UIView alloc] initWithFrame:CGRectMake(-4, 147, 10, 10)];
    yuanView1.backgroundColor = bgViewColor;
    [bg addSubview:yuanView1];
    LRViewBorderRadius(yuanView1,5,1,[UIColor clearColor]);
    
    UIView *yuanView2 = [[UIView alloc] initWithFrame:CGRectMake(298*APP_DELEGATE().autoSizeScaleX, 147, 10, 10)];
    yuanView2.backgroundColor = bgViewColor;
    [bg addSubview:yuanView2];
    LRViewBorderRadius(yuanView2,5,1,[UIColor clearColor]);
    
    return cell;
}

-(void)reservationBtnClick:(UIButton *)sender
{
    NSDictionary *info;
    if (type==0)
    {
        info = [items1 objectAtIndex:sender.tag];
    }
    else
    {
        info = [items2 objectAtIndex:sender.tag];
    }
    NSLog(@"预约");
    if ([[info objectForKey:@"status"] intValue] == 6)
    {// 已到达目的地
        if ([[info objectForKey:@"is_order_send"] intValue] == 1)// 表示已填写预约收货
        {
//            [MBProgressHUD showAutoMessage:@"您已经预约"];
        }
        else
        {
            ReservationViewController *vc = [[ReservationViewController alloc] init];
            vc.waybill_id = [info objectForKey:@"waybill_id"];
            vc.consignee = [info objectForKey:@"consignee"];
            vc.consignee_phone = [info objectForKey:@"consignee_phone"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}


/**
 *  @author 徐杨
 *
 *  明细事件
 *
 *  @param sender
 */
-(void)detailsBtnClick:(UIButton *)sender
{
    NSLog(@"运单明细");

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
    NSDictionary *info;
    if (type==0)
    {
        info = [items1 objectAtIndex:sender.tag];
    }
    else
    {
        info = [items2 objectAtIndex:sender.tag];
    }
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"运单跟踪";
    vc.webURL = [NSString stringWithFormat:@"%@?waybillNum=%@&type=1",waybillDetailsURL,[info objectForKey:@"j_waybill_no"]];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *info;
    if (type==0)
    {
        info = [items1 objectAtIndex:indexPath.section];
    }
    else
    {
        info = [items2 objectAtIndex:indexPath.section];
    }
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
                                                title:@"跟踪"];
    return rightUtilityButtons;
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"跟踪");
            [cell hideUtilityButtonsAnimated:YES];
            NSDictionary *info;
            if (type==0)
            {
                info = [items1 objectAtIndex:index];
            }
            else
            {
                info = [items2 objectAtIndex:index];
            }
           
          
            YLLWebViewController *vc = [[YLLWebViewController alloc] init];
            vc.webTitle = @"运单跟踪";
             vc.webURL = [NSString stringWithFormat:@"%@?waybillNum=%@&type=1",waybillDetailsURL,[info objectForKey:@"j_waybill_no"]];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
