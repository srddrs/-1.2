//
//  CollectingViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "CollectingViewController.h"
#import "SWTableViewCell.h"
#import "YunDanGenZongViewController.h"
//#import "ApplyCollectingViewController.h"
#import "ApplyCollectingBatchViewController.h"
#import "AddBankCardViewController.h"
#import "ApplyCollectingBatchViewController.h"
#import "HelpViewController.h"
#import "AddBankCard3ViewController.h"
#import "FangKuanMingXiViewController.h"
@interface CollectingViewController ()<WJSegmentMenuDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items;
    int start;
    int limit;
    int type;
    NSMutableArray *selectArray;
}
@end

@implementation CollectingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        items = [[NSMutableArray alloc] init];
        start = 0;
        limit = pageSize;
        type = 1;
        selectArray = [[NSMutableArray alloc] init];
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
    
//    UIButton *infoBtn = [[UIButton alloc] initWithFrame: CGRectMake(240*APP_DELEGATE().autoSizeScaleX, 420*APP_DELEGATE().autoSizeScaleY, 50*APP_DELEGATE().autoSizeScaleY, 50*APP_DELEGATE().autoSizeScaleY)];
//    [infoBtn setBackgroundImage:[UIImage imageNamed:@"dsk_button"] forState:UIControlStateNormal];
//    [infoBtn setBackgroundImage:[UIImage imageNamed:@"dsk_button"] forState:UIControlStateHighlighted];
//    [infoBtn addTarget:self
//                action:@selector(infoBtnClick:)
//      forControlEvents:UIControlEventTouchUpInside];
//    infoBtn.titleLabel.font = viewFont1;
//    [self.view addSubview:infoBtn];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNav
{
    self.title = @"代收款运单";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void) initView
{
    WJSegmentMenu *segmentMenu = [[WJSegmentMenu alloc]initWithFrame:CGRectMake(0, 1, 320, 30)];
    segmentMenu.delegate = self;
    [segmentMenu segmentWithTitles:@[@"未收款",@"申请放款",@"放款中",@"已完成"]];
    
    [self.view addSubview:segmentMenu];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 31*APP_DELEGATE().autoSizeScaleY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - 20-31*APP_DELEGATE().autoSizeScaleY)];
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


- (void)segmentWithIndex:(NSInteger)index title:(NSString *)title
{
    if (index==0)
    {
        NSLog(@"1");
        type = 1;
        [self loadData];
    }
    else if (index==01)
    {
        NSLog(@"2");
        type = 2;
        [self loadData];
    }
    else if (index==2)
    {
        NSLog(@"3");
        type = 3;
        [self loadData];
    }
    else
    {
        
        NSLog(@"4");
        type = 4;
        [self loadData];
       
    }
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
    [selectArray removeAllObjects];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_waybill_queryAgentMoneyWaybillFunction",@"funcId",
                                     [NSString stringWithFormat:@"%d",start],@"start",
                                     [NSString stringWithFormat:@"%d",limit],@"limit",
                                     [NSString stringWithFormat:@"%d",type],@"type",
                                     
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
             [selectArray removeAllObjects];
             
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
             
             //             [MBProgressHUD showError:((response *)obj.responses[0]).message toView:self.view];
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
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     [tableView tableViewDisplayWitMsg1:@"暂无数据" ifNecessaryForRowCount:items.count];
    
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
    e_station_brLable.text = [NSString stringWithFormat:@"到站:%@",[info objectForKey:@"e_station_br"]];
    [bg addSubview:e_station_brLable];
    
    //    UILabel *statusLable = [[UILabel alloc] initWithFrame:CGRectMake(210*APP_DELEGATE().autoSizeScaleX, 0, 80*APP_DELEGATE().autoSizeScaleX, 30)];
    //    statusLable.numberOfLines = 0;
    //    statusLable.textAlignment = NSTextAlignmentRight;
    //    statusLable.font = viewFont4;
    //    statusLable.textColor = fontOrangeColor;
    //
    //    [bg addSubview:statusLable];
    
    //运单号
    UIImageView *yundanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 40+3, 15, 15)];
    yundanIcon.image = [UIImage imageNamed:@"dsk_yundanhao"];
    [bg addSubview:yundanIcon];
    
    UILabel *yundanLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 40, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    yundanLable.numberOfLines = 0;
    yundanLable.textAlignment = NSTextAlignmentLeft;
    yundanLable.font = viewFont3;
    yundanLable.textColor = fontColor;
    yundanLable.text = [NSString stringWithFormat:@"运单号:%@",[info objectForKey:@"j_waybill_no"]];
    [bg addSubview:yundanLable];
    
    //收货人
    UIImageView *shouhuorenIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 68+3, 15, 15)];
    shouhuorenIcon.image = [UIImage imageNamed:@"dsk_shouhuoren"];
    [bg addSubview:shouhuorenIcon];
    
    UILabel *shouhuorenLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 68, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    shouhuorenLable.numberOfLines = 0;
    shouhuorenLable.textAlignment = NSTextAlignmentLeft;
    shouhuorenLable.font = viewFont3;
    shouhuorenLable.textColor = fontColor;
    shouhuorenLable.text = [NSString stringWithFormat:@"收货人:%@",[info objectForKey:@"consignee"]];
    [bg addSubview:shouhuorenLable];
    
    //代收款金额
    UIImageView *daishoukuanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 96+3, 15, 15)];
    daishoukuanIcon.image = [UIImage imageNamed:@"dsk_daishoujine"];
    [bg addSubview:daishoukuanIcon];
    
    UILabel *daishoukuanLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 96, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    daishoukuanLable.numberOfLines = 0;
    daishoukuanLable.textAlignment = NSTextAlignmentLeft;
    daishoukuanLable.font = viewFont3;
    daishoukuanLable.textColor = fontColor;
    daishoukuanLable.text = [NSString stringWithFormat:@"代收款金额:%@",[info objectForKey:@"agent_money"]];
    [bg addSubview:daishoukuanLable];
    
    //代收款实际金额
    UIImageView *daishoukuanshijiIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 127, 15, 15)];
    daishoukuanshijiIcon.image = [UIImage imageNamed:@"dsk_shishou"];
    [bg addSubview:daishoukuanshijiIcon];
    
    UILabel *daishoukuanshijiLable = [[UILabel alloc] initWithFrame:CGRectMake(32*APP_DELEGATE().autoSizeScaleX, 124, 200*APP_DELEGATE().autoSizeScaleX, 21)];
    daishoukuanshijiLable.numberOfLines = 0;
    daishoukuanshijiLable.textAlignment = NSTextAlignmentLeft;
    daishoukuanshijiLable.font = viewFont3;
    daishoukuanshijiLable.textColor = fontColor;
    daishoukuanshijiLable.text = [NSString stringWithFormat:@"实收款金额:%@",[info objectForKey:@"actual_agent_money"]];
    [bg addSubview:daishoukuanshijiLable];
    
    
    UIButton *genzhongBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 150,152*APP_DELEGATE().autoSizeScaleX, 45)];
    [genzhongBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:246/255.0 green:247/255.0 blue:251/255.0 alpha:1]] forState:UIControlStateNormal];
    [genzhongBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:234/255.0 green:238/255.0 blue:253/255.0 alpha:1]] forState:UIControlStateHighlighted];
    [genzhongBtn setImage:[UIImage imageNamed:@"sh_yundangenzong"] forState:UIControlStateNormal];
    [genzhongBtn setImage:[UIImage imageNamed:@"sh_yundangenzong"] forState:UIControlStateHighlighted];
    [genzhongBtn addTarget:self
                    action:@selector(genzhongBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:genzhongBtn];
    genzhongBtn.tag = indexPath.section;
    
    
    
    UIButton *shenqingBtn = [[UIButton alloc] initWithFrame: CGRectMake(152*APP_DELEGATE().autoSizeScaleX, 150,152*APP_DELEGATE().autoSizeScaleX, 45)];
    [shenqingBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:246/255.0 green:247/255.0 blue:251/255.0 alpha:1]] forState:UIControlStateNormal];
    [shenqingBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:234/255.0 green:238/255.0 blue:253/255.0 alpha:1]] forState:UIControlStateHighlighted];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    NSString *statusString;
    if (type==1)
    {
        //        statusString = @"未放款";
        [shenqingBtn setImage:[UIImage imageNamed:@"dsk_weifangkuan"] forState:UIControlStateNormal];
        [shenqingBtn setImage:[UIImage imageNamed:@"dsk_weifangkuan"] forState:UIControlStateHighlighted];
        
         NSString *showString = @"";
        if ([[info objectForKey:@"is_wait_loan"] intValue]==1)
        {
            showString = @"等待通知放款";
        }
        
        if ([[info objectForKey:@"is_return_goods"] intValue]==1)
        {
            showString = @"原货返回";
        }
        
        if ([[info objectForKey:@"is_loss"] intValue]==1)
        {
            showString = @"挂失";
        }
        
        UILabel *statusLable = [[UILabel alloc] initWithFrame:CGRectMake(140*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
        statusLable.numberOfLines = 0;
        statusLable.textAlignment = NSTextAlignmentRight;
        statusLable.font = viewFont4;
        statusLable.textColor = fontOrangeColor;
        statusLable.text = showString;
        [cell.contentView addSubview:statusLable];
    }
    else if (type==2)
    {
        //        statusString = @"申请放款";
        [shenqingBtn setImage:[UIImage imageNamed:@"dsk_shenqingfangkuan"] forState:UIControlStateNormal];
        [shenqingBtn setImage:[UIImage imageNamed:@"dsk_shenqingfangkuan"] forState:UIControlStateHighlighted];
        
        bg.frame = CGRectMake(28*APP_DELEGATE().autoSizeScaleX, 0, 304*APP_DELEGATE().autoSizeScaleX, 393/2);
        
        
        UIButton *gouBtn = [[UIButton alloc] initWithFrame: CGRectMake(-20*APP_DELEGATE().autoSizeScaleY, -20*APP_DELEGATE().autoSizeScaleY, 70*APP_DELEGATE().autoSizeScaleY, 70*APP_DELEGATE().autoSizeScaleY)];
        [gouBtn setImage:[UIImage imageNamed:@"DSK-weixuanzhong"] forState:UIControlStateNormal];
        [gouBtn setImage:[UIImage imageNamed:@"DSK_xuanzhong"] forState:UIControlStateSelected];
        //        gouBtn.backgroundColor = [UIColor redColor];
        gouBtn.tag = indexPath.section;
        [gouBtn addTarget:self
                   action:@selector(gouBtnClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:gouBtn];
        
        if ([selectArray containsObject:info])
        {
            gouBtn.selected = YES;
        }
        else
        {
            gouBtn.selected = NO;
        }
        
        if(selectArray.count>0)
        {
             UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"申请放款" style:UIBarButtonItemStyleDone target:self action:@selector(changyong:)];
            self.navigationItem.rightBarButtonItem = changyongItem;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
        }
       
        
       
        
        
    }
    else if (type==3)
    {
        //        statusString = @"正在放款";
        [shenqingBtn setImage:[UIImage imageNamed:@"dsk_chulizhong"] forState:UIControlStateNormal];
        [shenqingBtn setImage:[UIImage imageNamed:@"dsk_chulizhong"] forState:UIControlStateHighlighted];
    }
    else if (type==4)
    {
        //        statusString = @"已完成";
        [shenqingBtn setImage:[UIImage imageNamed:@"dsk_yifangkuan"] forState:UIControlStateNormal];
        [shenqingBtn setImage:[UIImage imageNamed:@"dsk_yifangkuan"] forState:UIControlStateHighlighted];
        
        UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"放款明细" style:UIBarButtonItemStyleDone target:self action:@selector(mingxi:)];
        self.navigationItem.rightBarButtonItem = changyongItem;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
        
        
        
        if ([[info objectForKey:@"loan_time"] length]>0)
        {
            NSDateFormatter *dateFormatterShow = [[NSDateFormatter alloc] init];
            [dateFormatterShow setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate *date = [dateFormatterShow dateFromString:[NSString stringWithFormat:@"%@",[info objectForKey:@"loan_time"]]];
            NSString *showString;
            if (date!=nil)
            {
                NSDateFormatter *dateFormatterShow1 = [[NSDateFormatter alloc] init];
                [dateFormatterShow1 setDateFormat:@"yyyy-MM-dd"];
                showString = [dateFormatterShow1 stringFromDate:date];
            }
            else
            {
                showString = [[info objectForKey:@"loan_time"] substringToIndex:10];
            }
            
            
            
            UILabel *statusLable = [[UILabel alloc] initWithFrame:CGRectMake(140*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
            statusLable.numberOfLines = 0;
            statusLable.textAlignment = NSTextAlignmentRight;
            statusLable.font = viewFont4;
            statusLable.textColor = fontOrangeColor;
            statusLable.text = [NSString stringWithFormat:@"完成时间:%@",showString];
            [cell.contentView addSubview:statusLable];
        }
        
    }
    
    //    statusLable.text = statusString;
    
    [shenqingBtn addTarget:self
                    action:@selector(shenqingBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
    shenqingBtn.backgroundColor = [UIColor redColor];
    [bg addSubview:shenqingBtn];
    shenqingBtn.tag = indexPath.section;
    
    
    UILabel *fgx2 = [[UILabel alloc] initWithFrame:CGRectMake(160*APP_DELEGATE().autoSizeScaleX, 151, 1, 45)];
    fgx2.backgroundColor = bgViewColor;
    [cell.contentView addSubview:fgx2];
    
    
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


- (void)gouBtnClick:(UIButton *)sender
{
    NSLog(@"选中");
    NSDictionary *info = [ items objectAtIndex:sender.tag];
    if ([selectArray containsObject:info])
    {
        [selectArray removeObject:info];
        [_tableView reloadData];
    }
    else
    {
        //        [selectArray removeAllObjects];
        [selectArray addObject:info];
        [_tableView reloadData];
    }
}

- (void)mingxi:(id)sender
{
    NSLog(@"放款明细");
    FangKuanMingXiViewController *vc = [[FangKuanMingXiViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changyong:(id)sender
{
    if(selectArray.count==0)
    {
        [MBProgressHUD showAutoMessage:@"请选择运单"];
    }
    else
    {
        NSMutableString *yundan_ids = [[NSMutableString alloc] init];
        for (int i=0; i<selectArray.count; i++)
        {
            NSDictionary *info = [selectArray objectAtIndex:i];
            [yundan_ids appendString:[NSString stringWithFormat:@"%@",[info objectForKey:@"waybill_id"]]];
            if (i!=selectArray.count-1)
            {
                [yundan_ids appendString:@","];
            }
        }
        
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_querySetInfoFunction",@"funcId",
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
                 
                 
                 if ([[item objectForKey:@"is_auth"] intValue]==0)
                 {
                     if ([[item objectForKey:@"ralation_type"] intValue]==3)
                     {
                         [MBProgressHUD showAutoMessage:@"请通知您的雇主开通代收款业务"];
                     }
                     else
                     {
                         if ([[item objectForKey:@"is_open_loan_service"] intValue]==1)
                         {
                             [MBProgressHUD showAutoMessage:@"业务开通审核中，请耐心等待"];
                         }
                         else
                         {
                             //跳转 实名+银行卡页面
                             AddBankCard3ViewController *vc = [[AddBankCard3ViewController alloc] init];
                             YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
                             nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                             [self presentViewController:nav animated:YES completion:nil];
                         }
                         
                     }
                     
                 }
                 else  if ([[item objectForKey:@"is_auth"] intValue]==1)
                 {
                     [MBProgressHUD showAutoMessage:@"业务开通审核中，请耐心等待"];
                 }
                 else  if ([[item objectForKey:@"is_auth"] intValue]==2)
                 {
                     ApplyCollectingBatchViewController *vc = [[ApplyCollectingBatchViewController alloc] init];
                     vc.waybill = yundan_ids;
                     [self.navigationController pushViewController:vc animated:YES];
                 }
                 else  if ([[item objectForKey:@"is_auth"] intValue]==3)
                 {
                     //跳转 实名+银行卡页面
                     if ([[item objectForKey:@"ralation_type"] intValue]==3)
                     {
                         [MBProgressHUD showAutoMessage:@"请通知您的雇主开通代收款业务"];
                     }
                     else
                     {
                         AddBankCard3ViewController *vc = [[AddBankCard3ViewController alloc] init];
                         YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
                         nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                         [self presentViewController:nav animated:YES completion:nil];
                     }
                     
                     
                 }
             }
             else
             {
                 [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             }
             NSLog(@"%@",responseObject);
         } Failure:^(NSError *error)
         {
             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
         }];

        
        
        
    }
}

-(void)shenqingBtnClick:(UIButton *)sender
{
    
    if (type!=2)
    {
        return;
    }
    
    
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_querySetInfoFunction",@"funcId",
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
             
             
             if ([[item objectForKey:@"is_auth"] intValue]==0)
             {
                 if ([[item objectForKey:@"ralation_type"] intValue]==3)
                 {
                     [MBProgressHUD showAutoMessage:@"请通知您的雇主开通代收款业务"];
                 }
                 else
                 {
                     if ([[item objectForKey:@"is_open_loan_service"] intValue]==1)
                     {
                         [MBProgressHUD showAutoMessage:@"业务开通审核中，请耐心等待"];
                     }
                     else
                     {
                         //跳转 实名+银行卡页面
                         AddBankCard3ViewController *vc = [[AddBankCard3ViewController alloc] init];
                         YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
                         nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                         [self presentViewController:nav animated:YES completion:nil];
                     }

                 }
                 
             }
             else  if ([[item objectForKey:@"is_auth"] intValue]==1)
             {
                 [UIAlertView showAlert:@"业务开通审核中，请耐心等待" cancelButton:@"确定"];
             }
             else  if ([[item objectForKey:@"is_auth"] intValue]==2)
             {
                 NSDictionary *info = [items objectAtIndex:sender.tag];
                 ApplyCollectingBatchViewController *vc = [[ApplyCollectingBatchViewController alloc] init];
                 vc.waybill = [NSString stringWithFormat:@"%@",[info objectForKey:@"waybill_id"]];
                 [self.navigationController pushViewController:vc animated:YES];
             }
             else  if ([[item objectForKey:@"is_auth"] intValue]==3)
             {
                 //跳转 实名+银行卡页面
                 if ([[item objectForKey:@"ralation_type"] intValue]==3)
                 {
                     [MBProgressHUD showAutoMessage:@"请通知您的雇主开通代收款业务"];
                 }
                 else
                 {
                     AddBankCard3ViewController *vc = [[AddBankCard3ViewController alloc] init];
                     YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
                     nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                     [self presentViewController:nav animated:YES completion:nil];
                 }
                
                 
             }
         }
         else
         {
             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
         }
         NSLog(@"%@",responseObject);
     } Failure:^(NSError *error)
     {
         [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
     }];

}


-(void)genzhongBtnClick:(UIButton *)sender
{
    NSDictionary *info = [items objectAtIndex:sender.tag];
    
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"运单跟踪";
    vc.webURL = [NSString stringWithFormat:@"%@?waybillNum=%@&type=2",waybillDetailsURL,[info objectForKey:@"j_waybill_no"]];
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
                                                title:@"跟踪"];
    return rightUtilityButtons;
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"跟踪");
            [cell hideUtilityButtonsAnimated:YES];
            
            NSDictionary *info = [items objectAtIndex:index];
            
            YLLWebViewController *vc = [[YLLWebViewController alloc] init];
            vc.webTitle = @"运单跟踪";
            vc.webURL = [NSString stringWithFormat:@"%@?waybillNum=%@&type=2",waybillDetailsURL,[info objectForKey:@"j_waybill_no"]];
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
