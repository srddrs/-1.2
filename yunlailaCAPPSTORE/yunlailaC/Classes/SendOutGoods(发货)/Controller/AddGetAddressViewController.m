//
//  AddGetAddressViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AddGetAddressViewController.h"
#import "DaoDaShengfenViewController.h"
#import "DingWeiDiZhiGetViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
@interface AddGetAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DingWeiDiZhiGetViewControllerDelegate,AMapSearchDelegate>
{
    AMapSearchAPI *_search;
    
    UITableView *_tableView;
    UITextField *lianxirenText;
    UITextField *lianxidianhuaText;
    UILabel *kaitongquyuLabel;
    UITextField *xiangxidizhiText;
    UILabel *dingweiweizhiLabel;
    UIButton *gouBtn;
    
    NSString *receipt_region_id;
    double latitude;
    double longitude;
}
@end

@implementation AddGetAddressViewController
-(void)xuankaitong:(NSNotification *)notification
{
    kaitongquyuLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"text"]]];
    receipt_region_id = [notification.userInfo objectForKey:@"receipt_region_id"];
    NSLog(@"receipt_region_id:%@",receipt_region_id);
    kaitongquyuLabel.textColor = fontColor;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
      
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(xuankaitong:)
                                                     name:KNOTIFICATION_XuanKaiTong1
                                                   object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _search.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    [self initView];
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:[LocationManager sharedInstance].latitude longitude:[LocationManager sharedInstance].longitude];
    regeo.requireExtension            = YES;
    
    [_search AMapReGoecodeSearch:regeo];
    [APP_DELEGATE() storyBoradAutoLay:self.view];

    
}

#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        latitude = coordinate.latitude;
        longitude = coordinate.longitude;
//        dingweiweizhiLabel.text = response.regeocode.formattedAddress;
        dingweiweizhiLabel.text = [NSString stringWithFormat:@"{%f,%f}",latitude,longitude];
        
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNav
{
    self.title = @"收货地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void) initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TabbarHeight-20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)pop:(id)sender
{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5;
    }
    else
    {
        return 2;
    }
    
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
    if (indexPath.section==1&&indexPath.row==1)
    {
        return 150;
    }
    return 44;
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
    
    UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 70*APP_DELEGATE().autoSizeScaleX, 44)];
    titleLable1.numberOfLines = 0;
    titleLable1.textAlignment = NSTextAlignmentLeft;
    titleLable1.font = viewFont1;
    titleLable1.textColor = fontColor;
    [cell.contentView addSubview:titleLable1];
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 43, 290*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        titleLable1.text = @"联系人";
        if (!lianxirenText)
        {
            lianxirenText = [[UITextField alloc] init];
            lianxirenText.clearButtonMode = UITextFieldViewModeWhileEditing;
            lianxirenText.borderStyle = UITextBorderStyleNone;
            lianxirenText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            lianxirenText.delegate = self;
            lianxirenText.placeholder = @"收货人姓名";
            lianxirenText.returnKeyType = UIReturnKeyDone;
            lianxirenText.keyboardType = UIKeyboardTypeDefault;
            lianxirenText.textColor = fontColor;
            lianxirenText.font = viewFont1;
            lianxirenText.text = @"";
        }
        [cell.contentView addSubview:lianxirenText];
    }
    else   if(indexPath.section==0&&indexPath.row==1)
    {
        titleLable1.text = @"联系电话";
        if (!lianxidianhuaText)
        {
            lianxidianhuaText = [[UITextField alloc] init];
            lianxidianhuaText.clearButtonMode = UITextFieldViewModeWhileEditing;
            lianxidianhuaText.borderStyle = UITextBorderStyleNone;
            lianxidianhuaText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            lianxidianhuaText.delegate = self;
            lianxidianhuaText.placeholder = @"收货客户手机号";
            lianxidianhuaText.returnKeyType = UIReturnKeyDone;
            lianxidianhuaText.keyboardType = UIKeyboardTypeNumberPad;
            lianxidianhuaText.textColor = fontColor;
            lianxidianhuaText.font = viewFont1;
            lianxidianhuaText.text = @"";
            
        }
        [cell.contentView addSubview:lianxidianhuaText];
    }
    else   if(indexPath.section==0&&indexPath.row==2)
    {
        titleLable1.text = @"开通区域";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!kaitongquyuLabel)
        {
            kaitongquyuLabel = [[UILabel alloc] init];
            kaitongquyuLabel.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 190*APP_DELEGATE().autoSizeScaleX, 44);
            kaitongquyuLabel.textAlignment = NSTextAlignmentLeft;
            kaitongquyuLabel.lineBreakMode = NSLineBreakByWordWrapping;
            kaitongquyuLabel.numberOfLines = 0;
            kaitongquyuLabel.textColor = fontColor;
            kaitongquyuLabel.font = viewFont1;
            kaitongquyuLabel.text = @"";
            kaitongquyuLabel.text = @"点击右侧选择开通区域";
        }
        [cell.contentView addSubview:kaitongquyuLabel];
    }
    else   if(indexPath.section==0&&indexPath.row==3)
    {
        titleLable1.text = @"详细地址";
        if (!xiangxidizhiText)
        {
            xiangxidizhiText = [[UITextField alloc] init];
            xiangxidizhiText.clearButtonMode = UITextFieldViewModeWhileEditing;
            xiangxidizhiText.borderStyle = UITextBorderStyleNone;
            xiangxidizhiText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            xiangxidizhiText.delegate = self;
            xiangxidizhiText.placeholder = @"请详细到门牌号";
            xiangxidizhiText.returnKeyType = UIReturnKeyDone;
            xiangxidizhiText.keyboardType = UIKeyboardTypeDefault;
            xiangxidizhiText.textColor = fontColor;
            xiangxidizhiText.font = viewFont1;
            xiangxidizhiText.text = @"";
        }
        [cell.contentView addSubview:xiangxidizhiText];
    }
    else   if(indexPath.section==0&&indexPath.row==4)
    {
        titleLable1.text = @"定位位置";
        fgx.hidden = YES;
        if (!dingweiweizhiLabel)
        {
            
            dingweiweizhiLabel = [[UILabel alloc] init];
            dingweiweizhiLabel.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 180*APP_DELEGATE().autoSizeScaleX, 44);
            dingweiweizhiLabel.textAlignment = NSTextAlignmentLeft;
            dingweiweizhiLabel.lineBreakMode = NSLineBreakByWordWrapping;
            dingweiweizhiLabel.numberOfLines = 0;
            dingweiweizhiLabel.textColor = fontColor;
            dingweiweizhiLabel.font = viewFont1;
            dingweiweizhiLabel.text = @"";
            
        }
        [cell.contentView addSubview:dingweiweizhiLabel];
        UIButton *dingweiBtn = [[UIButton alloc] initWithFrame: CGRectMake(289*APP_DELEGATE().autoSizeScaleX, 12,13, 20)];
        [dingweiBtn setBackgroundImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
        [dingweiBtn setBackgroundImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateHighlighted];
        [dingweiBtn addTarget:self
                       action:@selector(dingweiBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:dingweiBtn];
    }
    
    else   if(indexPath.section==1&&indexPath.row==0)
    {
        fgx.hidden = YES;
        titleLable1.text = @"是否设置为常用地址";
        titleLable1.frame = CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
        
        if (!gouBtn)
        {
            gouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            gouBtn.frame = CGRectMake(281*APP_DELEGATE().autoSizeScaleX, 7,30, 30);
            [gouBtn setImage:[UIImage imageNamed:@"moren_weixuanzhong@3x"] forState:UIControlStateNormal];
            [gouBtn setImage:[UIImage imageNamed:@"moren_xuanzhong@3x"]  forState:UIControlStateSelected];
            [gouBtn addTarget:self
                       action:@selector(guoBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
            gouBtn.selected = NO;
            
        }
        [cell.contentView addSubview:gouBtn];
    }
    else   if(indexPath.section==1&&indexPath.row==1)
    {
        cell.backgroundColor = bgViewColor;
        titleLable1.hidden = YES;
        fgx.hidden = YES;
        
        UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 20, 250*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
        [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
        [submitBtn setTitle:@"保存" forState:UIControlStateHighlighted];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
        [submitBtn addTarget:self
                      action:@selector(submitBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
        submitBtn.titleLabel.font = viewFont1;
        [cell.contentView addSubview:submitBtn];
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0&&indexPath.row==2)
    {
        NSLog(@"开通区域");
        DaoDaShengfenViewController *vc = [[DaoDaShengfenViewController alloc] init];
        YLLWhiteNavViewController *nav = [[YLLWhiteNavViewController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
    }
    if(indexPath.section==0&&indexPath.row==4)
    {
        NSLog(@"定位位置");
        DingWeiDiZhiGetViewController *vc = [[DingWeiDiZhiGetViewController alloc] init];
        vc.mydelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        //        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        //        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:nav animated:YES completion:nil];
        
    }
    if(indexPath.section==1&&indexPath.row==0)
    {
        gouBtn.selected = !gouBtn.selected;
        [_tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)sendformattedAddress:(NSString *)formattedAddress AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"地名：%@",formattedAddress);
    NSLog(@"latitude：%f",coordinate.latitude);
    NSLog(@"longitude：%f",coordinate.longitude);
    latitude = coordinate.latitude;
    longitude = coordinate.longitude;
    //    dingweiweizhiLabel.text = formattedAddress;
    dingweiweizhiLabel.text = [NSString stringWithFormat:@"{%f,%f}",latitude,longitude];
    [_tableView reloadData];
}
- (void)guoBtnClick:(id)sender
{
    gouBtn.selected = !gouBtn.selected;
    [_tableView reloadData];
}

- (void)dingweiBtnClick:(id)sender
{
    NSLog(@"定位");
    DingWeiDiZhiGetViewController *vc = [[DingWeiDiZhiGetViewController alloc] init];
    vc.mydelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    //    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    //    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)submitBtnClick:(id)sender
{
    if (lianxirenText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写收货人姓名"];
        return;
    }
    if (lianxidianhuaText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写收货客户手机号"];
        return;
    }
    if (receipt_region_id.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请选择开通区域"];
        return;
    }
    if (xiangxidizhiText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写详细地址"];
        return;
    }
    if ([dingweiweizhiLabel.text isEqualToString:@"未定位"])
    {
        [MBProgressHUD showAutoMessage:@"请定位"];
        return;
    }
    
    NSLog(@"保存");
    [UIAlertView showAlert:@"是否确认并且保存？" delegate:self cancelButton:@"取消" otherButton:@"保存" tag:1];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"保存");
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        NSString *type;
        if (gouBtn.selected==YES)
        {
            type = @"1";
        }
        else
        {
            type = @"0";
        }
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSDictionary *item = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
        NSString *cust_id = [item objectForKey:@"cust_id"];
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_receiptaddress_save_function",@"funcId",
                                         lianxidianhuaText.text,@"phone",
                                         kaitongquyuLabel.text,@"recript_city",
                                         lianxirenText.text,@"user_name",
                                         xiangxidizhiText.text,@"address",
                                         type,@"type",
                                         @"男",@"sex",
                                         [NSString stringWithFormat:@"%f",longitude],@"longitude",
                                         [NSString stringWithFormat:@"%f",latitude],@"latitude",
                                         [NSString stringWithFormat:@"%@",receipt_region_id],@"receipt_region_id",
                                         cust_id,@"member_number",
                                         nil];
        
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
                 [MBProgressHUD showMessag:@"新增收货地址成功" toView:self.view];
                 [self.navigationController dismissViewControllerAnimated:YES completion:^{
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }];
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
             [MBProgressHUD showError:@"新增收货地址失败" toView:self.view];
         }];
        
    }
    else
    {
        NSLog(@"取消");
    }
    
}
@end

