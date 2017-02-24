//
//  ServiceListViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ServiceListViewController.h"
#import "ServicePointsViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "RoutePlanningViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface ServiceListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items; //列表数据
    int start;  //分页用
    int limit; //分页用
    
    UITextField *searchText;
}
@end

@implementation ServiceListViewController
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
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"dituliebiao_01" highIcon:@"dituliebiao_01" target:self action:@selector(dituBtnClick:)];
}

- (void) initView
{
//    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    bg.backgroundColor = [UIColor colorWithRed:99/255.0 green:133/255.0 blue:230/255.0 alpha:0.9];
//    [self.view addSubview:bg];
//    
//    
//    UIImageView *searchBg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 220 + 43, 30)];
//    searchBg.image = [UIImage imageNamed:@"zhuye_biankuang"];
//    [bg addSubview:searchBg];
//    searchBg.userInteractionEnabled = YES;
//    UIImageView *iconView1 = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"zhuye_sousuo"]];
//    iconView1.contentMode = UIViewContentModeCenter;
//    
//    searchText = [[UITextField alloc] init];
//    searchText.leftView = iconView1;
//    searchText.leftViewMode = UITextFieldViewModeAlways;
//    searchText.leftView.frame = CGRectMake(0, 0, 30, 30);
//    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
//    searchText.borderStyle = UITextBorderStyleNone;
//    searchText.frame = CGRectMake(0, 0, 215 + 43, 30);
//    searchText.delegate = self;
//    searchText.placeholder = @"搜索服务点";
//    searchText.returnKeyType = UIReturnKeySearch;
//    searchText.keyboardType = UIKeyboardTypeDefault;
//    searchText.font = viewFont2;
//    searchText.textColor = [UIColor whiteColor];
//    [searchText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [searchText setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
//    [searchBg addSubview:searchText];
//    
//    UIButton *dituBtn = [[UIButton alloc] initWithFrame: CGRectMake(278, 0,43, 50)];
//    [dituBtn setImage:[UIImage imageNamed:@"dituliebiao_01"] forState:UIControlStateNormal];
//    [dituBtn setImage:[UIImage imageNamed:@"dituliebiao_01"] forState:UIControlStateHighlighted];
//    [dituBtn addTarget:self
//              action:@selector(dituBtnClick:)
//    forControlEvents:UIControlEventTouchUpInside];
//    [bg addSubview:dituBtn];
    

    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - 20 -44-0)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

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
                                     @"hex_dot_queryAllDotsFuntion",@"funcId",
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
                 if ([CLLocationManager locationServicesEnabled] &&
                     ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
                      || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))

                 {
                     NSComparator cmptr = ^(NSDictionary *obj1, NSDictionary *obj2)
                     {
                         CLLocation *orig=[[CLLocation alloc] initWithLatitude:[LocationManager sharedInstance].latitude  longitude:[LocationManager sharedInstance].longitude] ;
                         CLLocation* dist1=[[CLLocation alloc] initWithLatitude:[[obj1 objectForKey:@"latitude"] doubleValue] longitude:[[obj1 objectForKey:@"longitude"] doubleValue] ];
                         
                         CLLocationDistance kilometers1=[orig distanceFromLocation:dist1];
                         
                         
                        CLLocation* dist2=[[CLLocation alloc] initWithLatitude:[[obj2 objectForKey:@"latitude"] doubleValue] longitude:[[obj2 objectForKey:@"longitude"] doubleValue] ];
                         
                         CLLocationDistance kilometers2=[orig distanceFromLocation:dist2];
                         
                         if (kilometers1 > kilometers2)
                         {
                             return (NSComparisonResult)NSOrderedDescending;
                         }
                         
                         if (kilometers1 < kilometers2) {
                             return (NSComparisonResult)NSOrderedAscending;
                         }
                         return (NSComparisonResult)NSOrderedSame;
                     };
                     
                     NSArray *array = [items sortedArrayUsingComparator:cmptr];
                     [items removeAllObjects];
                     [items addObjectsFromArray:array];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
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
    NSDictionary *info = [items objectAtIndex:indexPath.section];
    
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 66, 62)];
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[info objectForKey:@"dot_image"]]];
    [icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mendian"]];
    icon.image = [UIImage imageNamed:@"mendian"];
    [cell.contentView addSubview:icon];
    
    UILabel *mingziLable = [[UILabel alloc] initWithFrame:CGRectMake(85, 8, 170*APP_DELEGATE().autoSizeScaleX, 20)];
    mingziLable.numberOfLines = 1;
    mingziLable.textAlignment = NSTextAlignmentLeft;
    mingziLable.font = viewFont1;
    mingziLable.textColor = fontColor;
    mingziLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"dot_name"]];
    [cell.contentView addSubview:mingziLable];
    
    UILabel *weizhiLable = [[UILabel alloc] initWithFrame:CGRectMake(85, 31, 230*APP_DELEGATE().autoSizeScaleX, 20)];
    weizhiLable.numberOfLines = 0;
    weizhiLable.textAlignment = NSTextAlignmentLeft;
    weizhiLable.font = viewFont1;
//    weizhiLable.textColor = fontColor;
    weizhiLable.textColor = fontHuiColor;
    weizhiLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"dot_address"]];
    [cell.contentView addSubview:weizhiLable];
    
    UILabel *juliLable = [[UILabel alloc] initWithFrame:CGRectMake(85, 56, 200*APP_DELEGATE().autoSizeScaleX, 15)];
    juliLable.numberOfLines = 0;
    juliLable.textAlignment = NSTextAlignmentCenter;
    juliLable.font = viewFont5;
    juliLable.textColor = fontOrangeColor;
    [cell.contentView addSubview:juliLable];
    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))
    {
  
//        NSLog(@"orig:%@",orig);
        
        if ([[info objectForKey:@"latitude"] doubleValue]==0||[[info objectForKey:@"longitude"] doubleValue]==0)
        {
            juliLable.text = @"未定位";
            CGSize size = [juliLable boundingRectWithSize:CGSizeMake(300, 15)];
            juliLable.frame = CGRectMake(85, 56, size.width+10,15);
            LRViewBorderRadius(juliLable,5,1,fontOrangeColor);
        }
        else
        {
            CLLocation *orig=[[CLLocation alloc] initWithLatitude:[LocationManager sharedInstance].latitude  longitude:[LocationManager sharedInstance].longitude] ;
            CLLocation* dist=[[CLLocation alloc] initWithLatitude:[[info objectForKey:@"latitude"] doubleValue] longitude:[[info objectForKey:@"longitude"] doubleValue] ];
            
            CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
            juliLable.text = [NSString stringWithFormat:@"%0.2f千米",kilometers];
            CGSize size = [juliLable boundingRectWithSize:CGSizeMake(300, 15)];
            juliLable.frame = CGRectMake(85, 56, size.width+10,15);
            LRViewBorderRadius(juliLable,5,1,fontOrangeColor);

        }
    }
    else
    {
        juliLable.text = @"未开启定位";
        CGSize size = [juliLable boundingRectWithSize:CGSizeMake(300, 15)];
        juliLable.frame = CGRectMake(85, 56, size.width+10,15);
        LRViewBorderRadius(juliLable,5,1,fontOrangeColor);
    }


//    UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(280*APP_DELEGATE().autoSizeScaleX, 65, 10*APP_DELEGATE().autoSizeScaleX, 14*APP_DELEGATE().autoSizeScaleX)];
//    icon1.image = [UIImage imageNamed:@"fuwudiandingwei"];
//    [cell.contentView addSubview:icon1];
//    
//    UILabel *NumLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10*APP_DELEGATE().autoSizeScaleX, 14)];
//    NumLable.numberOfLines = 0;
//    NumLable.textAlignment = NSTextAlignmentCenter;
//    NumLable.font = viewFont6;
//    NumLable.textColor = [UIColor whiteColor];
//    NumLable.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
//    [icon1 addSubview:NumLable];
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 89-7, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];

    UILabel *fgx2 = [[UILabel alloc] initWithFrame:CGRectMake(160*APP_DELEGATE().autoSizeScaleX, 92-7, 1, 30)];
    fgx2.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx2];
    
    UIButton *goBtn = [[UIButton alloc] initWithFrame: CGRectMake(6*APP_DELEGATE().autoSizeScaleX, 90-7,144*APP_DELEGATE().autoSizeScaleX, 36)];
    [goBtn setImage:[UIImage imageNamed:@"daozhequ"] forState:UIControlStateNormal];
    [goBtn setImage:[UIImage imageNamed:@"daozhequ"] forState:UIControlStateHighlighted];
    [goBtn addTarget:self
                 action:@selector(goBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:goBtn];
    goBtn.tag = indexPath.section;
    
   
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame: CGRectMake(161*APP_DELEGATE().autoSizeScaleX, 90-7,144*APP_DELEGATE().autoSizeScaleX, 36)];
    [phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateHighlighted];
    [phoneBtn addTarget:self
              action:@selector(phoneBtnClick:)
    forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:phoneBtn];
    phoneBtn.tag = indexPath.section;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *addressInfo = [items objectAtIndex:indexPath.section];
    
}

- (void)dituBtnClick:(id)sender
{
    NSLog(@"切换地图");
    if (items.count>0)
    {
        ServicePointsViewController *vc =[[ServicePointsViewController alloc] init];
        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:^{
            [vc postServicePoi:items];
        }];
    }
    
}

- (void)shouchangBtnClick:(id)sender
{
    NSLog(@"收藏列表");
}


- (void)goBtnClick:(UIButton *)sender
{
    NSLog(@"到这里去");
//    NSDictionary *currentPoi = [items objectAtIndex:sender.tag];
//    
//    RoutePlanningViewController *vc =[[RoutePlanningViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([LocationManager sharedInstance].latitude, [LocationManager sharedInstance].longitude);
//    CLLocationCoordinate2D destinationCoordinate = CLLocationCoordinate2DMake([[currentPoi objectForKey:@"latitude"] doubleValue], [[currentPoi objectForKey:@"longitude"] doubleValue]);
//    [vc daozhe:startCoordinate destinationCoordinate:destinationCoordinate];

   NSDictionary *currentPoi = [items objectAtIndex:sender.tag];
    
    if ([[currentPoi objectForKey:@"latitude"] doubleValue]==0||[[currentPoi objectForKey:@"longitude"] doubleValue]==0)
    {
        [MBProgressHUD showAutoMessage:@"该服务点没有录入导航地址."];
    }
    else
    {
        AMapRouteConfig *config = [AMapRouteConfig new];
        config.appScheme      = [AppTool getApplicationScheme];
        config.appName        = [AppTool getApplicationName];
        config.startCoordinate = CLLocationCoordinate2DMake([LocationManager sharedInstance].latitude, [LocationManager sharedInstance].longitude);
        config.destinationCoordinate = CLLocationCoordinate2DMake([[currentPoi objectForKey:@"latitude"] doubleValue], [[currentPoi objectForKey:@"longitude"] doubleValue]);
        config.routeType = AMapRouteSearchTypeDriving;
        
        if(![AMapURLSearch openAMapRouteSearch:config])
        {
            [UIAlertView showAlert:@"由于您没有安装高德地图，所以无法进入导航界面，请安装高德地图" delegate:self cancelButton:@"取消" otherButton:@"去安装" tag:1];
        }

    }
    
    
    
    
    //    NSString *qidian = @"当前位置";
//
//    NSString *dot_name = [poiInfo objectForKey:@"dot_name"];
//    NSString *url = [NSString stringWithFormat:@"http://m.amap.com/?from=%f,%f(%@)&to=%f,%f(%@)",[LocationManager sharedInstance].latitude,[LocationManager sharedInstance].longitude,[qidian URLEncodedString],[[poiInfo objectForKey:@"latitude"] doubleValue],[[poiInfo objectForKey:@"longitude"] doubleValue],[dot_name URLEncodedString]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [AMapURLSearch getLatestAMapApp];
    }
}

        
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex!=actionSheet.cancelButtonIndex)
    {
        NSString *phone = [actionSheet buttonTitleAtIndex:buttonIndex];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:phone]]];
    }

    
//         NSDictionary *currentPoi = [items objectAtIndex:actionSheet.tag];
//        if (buttonIndex==0)
//        {
//            NSLog(@"驾车");
//            AMapRouteConfig *config = [AMapRouteConfig new];
//            config.appScheme      = [AppTool getApplicationScheme];
//            config.appName        = [AppTool getApplicationName];
//            config.startCoordinate = CLLocationCoordinate2DMake([LocationManager sharedInstance].latitude, [LocationManager sharedInstance].longitude);
//            config.destinationCoordinate = CLLocationCoordinate2DMake([[currentPoi objectForKey:@"latitude"] doubleValue], [[currentPoi objectForKey:@"longitude"] doubleValue]);
//            config.routeType = AMapRouteSearchTypeDriving;
//            [AMapURLSearch openAMapRouteSearch:config];
//        }
//        else if(buttonIndex==1)
//        {
//            NSLog(@"公交");
//            AMapRouteConfig *config = [AMapRouteConfig new];
//            config.appScheme      = [AppTool getApplicationScheme];
//            config.appName        = [AppTool getApplicationName];
//            config.startCoordinate = CLLocationCoordinate2DMake([LocationManager sharedInstance].latitude, [LocationManager sharedInstance].longitude);
//            config.destinationCoordinate = CLLocationCoordinate2DMake([[currentPoi objectForKey:@"latitude"] doubleValue], [[currentPoi objectForKey:@"longitude"] doubleValue]);
//            config.routeType = AMapRouteSearchTypeTransit;
//            [AMapURLSearch openAMapRouteSearch:config];
//
//        }
//        else if(buttonIndex==2)
//        {
//            NSLog(@"步行");
//            AMapRouteConfig *config = [AMapRouteConfig new];
//            config.appScheme      = [AppTool getApplicationScheme];
//            config.appName        = [AppTool getApplicationName];
//            config.startCoordinate = CLLocationCoordinate2DMake([LocationManager sharedInstance].latitude, [LocationManager sharedInstance].longitude);
//            config.destinationCoordinate = CLLocationCoordinate2DMake([[currentPoi objectForKey:@"latitude"] doubleValue], [[currentPoi objectForKey:@"longitude"] doubleValue]);
//            config.routeType = AMapRouteSearchTypeWalking;
//            [AMapURLSearch openAMapRouteSearch:config];
//        }
//        else if(buttonIndex==3)
//        {
//            NSLog(@"导航");
//           
//            AMapNaviConfig * config = [[AMapNaviConfig alloc] init];
//            config.destination    = CLLocationCoordinate2DMake([[currentPoi objectForKey:@"latitude"] doubleValue], [[currentPoi objectForKey:@"longitude"] doubleValue]);
//            config.appScheme      = [AppTool getApplicationScheme];
//            config.appName        = [AppTool getApplicationName];
//            config.strategy       = AMapDrivingStrategyAvoidHighwaysAndFareAndCongestion;
//            
//            if(![AMapURLSearch openAMapNavigation:config])
//            {
//                [AMapURLSearch getLatestAMapApp];
//            }
//
//        }
    
    
    
    
}

- (void)phoneBtnClick:(UIButton *)sender
{
    NSLog(@"电话");
     NSDictionary *poiInfo = [items objectAtIndex:sender.tag];
    NSArray *phones = [[poiInfo objectForKey:@"telephone"] componentsSeparatedByString:@","];
    if (phones.count>1)
    {
        //多个电话
        NSLog(@"多个电话");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        for (int i=0; i<phones.count; i++)
        {
            [actionSheet addButtonWithTitle:[phones objectAtIndex:i]];
        }
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 999;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:[poiInfo objectForKey:@"telephone"]]]];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
