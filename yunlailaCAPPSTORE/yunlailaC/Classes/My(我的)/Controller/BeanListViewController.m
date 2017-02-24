//
//  BeanListViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "BeanListViewController.h"
#import "SWTableViewCell.h"
@interface BeanListViewController ()<WJSegmentMenuDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *items;
    int start;
    int limit;
}
@end

@implementation BeanListViewController
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
    self.title = @"豆豆明细";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
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
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
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
                                     @"hex_client_bank_beanInformationListFunction",@"funcId",
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *info = [items objectAtIndex:indexPath.section];
    
    
    UILabel *miaosuLable = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 170*APP_DELEGATE().autoSizeScaleX, 44)];
    miaosuLable.numberOfLines = 1;
    miaosuLable.textAlignment = NSTextAlignmentLeft;
    miaosuLable.font = viewFont3;
    miaosuLable.textColor = fontColor;
    miaosuLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"event_name"]];
    [cell.contentView addSubview:miaosuLable];
    
    UILabel *statusLable = [[UILabel alloc] initWithFrame:CGRectMake(220*APP_DELEGATE().autoSizeScaleX, 0, 85*APP_DELEGATE().autoSizeScaleX, 44)];
    statusLable.numberOfLines = 0;
    statusLable.textAlignment = NSTextAlignmentRight;
    statusLable.font = viewFont3;
    statusLable.textColor = fontColor;
    statusLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"number"]];
    [cell.contentView addSubview:statusLable];
    
    UILabel *shijianLable = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 44, 170*APP_DELEGATE().autoSizeScaleX, 36)];
    shijianLable.numberOfLines = 0;
    shijianLable.textAlignment = NSTextAlignmentLeft;
    shijianLable.font = viewFont3;
    shijianLable.textColor = fontColor;
    shijianLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"operate_time"]];
    [cell.contentView addSubview:shijianLable];
    
    UILabel *yueLable = [[UILabel alloc] initWithFrame:CGRectMake(220*APP_DELEGATE().autoSizeScaleX, 44, 85*APP_DELEGATE().autoSizeScaleX, 36)];
    yueLable.numberOfLines = 0;
    yueLable.textAlignment = NSTextAlignmentRight;
    yueLable.font = viewFont3;
    yueLable.textColor = fontColor;
    yueLable.text = [NSString stringWithFormat:@"余额:%@",[info objectForKey:@"current_number"]];
    [cell.contentView addSubview:yueLable];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *addressInfo = [items objectAtIndex:indexPath.section];
//    [UIAlertView showAlert:@"理赔进展页面web制作中" cancelButton:@"确定"];
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