//
//  ReservationViewController.m
//  yunlailaC
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ReservationViewController.h"
#import "IQActionSheetPickerView.h"
#import "DingWeiDiZhiViewController.h"
@interface ReservationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,IQActionSheetPickerViewDelegate,DingWeiDiZhiViewControllerDelegate>
{
    UITableView *_tableView;
    UITextField *yuyueshijianText;  //预约时间
    UITextField *shijianduanText;  //时间段
    UITextField *shouhuorenText; //收货人姓名
    UITextField *shouhuoPhoneText; //收货人电话
    UITextField *dizhiText; //地址
    UITextField *beizhuText; //备注
    
    UILabel *dingweiweizhiLabel;
    UIButton *bendiBtn;
    double latitude;
    double longitude;
}
@end

@implementation ReservationViewController
@synthesize waybill_id,consignee,consignee_phone;

- (void)sendformattedAddress:(NSString *)formattedAddress AndCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"地名：%@",formattedAddress);
    NSLog(@"latitude：%f",coordinate.latitude);
    NSLog(@"longitude：%f",coordinate.longitude);
    latitude = coordinate.latitude;
    longitude = coordinate.longitude;
    //    dingweiweizhiLabel.text = formattedAddress;
    //    dingweiweizhiLabel.text = [NSString stringWithFormat:@"{%f,%f}",latitude,longitude];
    dingweiweizhiLabel.text  = @"已定位";
    bendiBtn.selected = NO;
    [_tableView reloadData];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        latitude = -1;
        longitude = -1;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))
    {
        
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"定位功能不可用，提示用户或忽略");
        [UIAlertView showAlert:@"请设置允许托运邦货主使用定位服务的权限" delegate:self cancelButton:@"取消" otherButton:@"去设置" tag:1];
        
    }

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
    self.title = @"预约收货";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void) initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TabbarHeight)];
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
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
    if (indexPath.row==8)
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        titleLable1.text = @"预约日期";
        if (!yuyueshijianText)
        {
            yuyueshijianText = [[UITextField alloc] init];
            yuyueshijianText.clearButtonMode = UITextFieldViewModeWhileEditing;
            yuyueshijianText.borderStyle = UITextBorderStyleNone;
            yuyueshijianText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            yuyueshijianText.delegate = self;
            yuyueshijianText.placeholder = @"请选择预约日期";
            yuyueshijianText.returnKeyType = UIReturnKeyDone;
            yuyueshijianText.keyboardType = UIKeyboardTypeDefault;
            yuyueshijianText.font = viewFont1;
            yuyueshijianText.textColor = fontColor;
            yuyueshijianText.text = @"";
            yuyueshijianText.enabled = NO;
            
        }
        [cell.contentView addSubview:yuyueshijianText];
    }
   else if(indexPath.section==0&&indexPath.row==1)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        titleLable1.text = @"预约时段";
        if (!shijianduanText)
        {
            shijianduanText = [[UITextField alloc] init];
            shijianduanText.clearButtonMode = UITextFieldViewModeWhileEditing;
            shijianduanText.borderStyle = UITextBorderStyleNone;
            shijianduanText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            shijianduanText.delegate = self;
            shijianduanText.placeholder = @"请选择预约时段";
            shijianduanText.returnKeyType = UIReturnKeyDone;
            shijianduanText.keyboardType = UIKeyboardTypeDefault;
            shijianduanText.font = viewFont1;
            shijianduanText.textColor = fontColor;
            shijianduanText.text = @"";
            shijianduanText.enabled = NO;
            
        }
        [cell.contentView addSubview:shijianduanText];
    }
    else if(indexPath.section==0&&indexPath.row==2)
    {
        titleLable1.text = @"收货人姓名";
        if (!shouhuorenText)
        {
            shouhuorenText = [[UITextField alloc] init];
            shouhuorenText.clearButtonMode = UITextFieldViewModeWhileEditing;
            shouhuorenText.borderStyle = UITextBorderStyleNone;
            shouhuorenText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            shouhuorenText.delegate = self;
            shouhuorenText.placeholder = @"请输入收货人姓名";
            shouhuorenText.returnKeyType = UIReturnKeyDone;
            shouhuorenText.keyboardType = UIKeyboardTypeDefault;
            shouhuorenText.font = viewFont1;
            shouhuorenText.textColor = fontColor;
            shouhuorenText.text = consignee;

//            NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
//            NSString *name;
//            if ([[loginUser objectForKey:@"real_name"] length]>0)
//            {
//                name = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"real_name"]];
//            }
//            else
//            {
//                name = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"nick_name"]];
//            }
//
//            shouhuorenText.text = name;
        }
        [cell.contentView addSubview:shouhuorenText];
    }
    else if(indexPath.section==0&&indexPath.row==3)
    {
        titleLable1.text = @"收货人电话";
        if (!shouhuoPhoneText)
        {
            shouhuoPhoneText = [[UITextField alloc] init];
            shouhuoPhoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
            shouhuoPhoneText.borderStyle = UITextBorderStyleNone;
            shouhuoPhoneText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            shouhuoPhoneText.delegate = self;
            shouhuoPhoneText.placeholder = @"请输入收货人电话";
            shouhuoPhoneText.returnKeyType = UIReturnKeyDone;
            shouhuoPhoneText.keyboardType = UIKeyboardTypeNumberPad;
            shouhuoPhoneText.font = viewFont1;
            shouhuoPhoneText.textColor = fontColor;
            shouhuoPhoneText.text = consignee_phone;

//            NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
//            if ([[loginUser objectForKey:@"account_id"] length]>0)
//            {
//                shouhuoPhoneText.text = [NSString stringWithFormat:@"%@",[loginUser objectForKey:@"account_id"]];
//            }
        }
        [cell.contentView addSubview:shouhuoPhoneText];
    }
    else if(indexPath.section==0&&indexPath.row==4)
    {
        titleLable1.text = @"地址";
        if (!dizhiText)
        {
            dizhiText = [[UITextField alloc] init];
            dizhiText.clearButtonMode = UITextFieldViewModeWhileEditing;
            dizhiText.borderStyle = UITextBorderStyleNone;
            dizhiText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            dizhiText.delegate = self;
            dizhiText.placeholder = @"请输入收货人地址";
            dizhiText.returnKeyType = UIReturnKeyDone;
            dizhiText.keyboardType = UIKeyboardTypeDefault;
            dizhiText.font = viewFont1;
            dizhiText.textColor = fontColor;
            dizhiText.text = @"";
            
        }
        [cell.contentView addSubview:dizhiText];
    }
    else   if(indexPath.section==0&&indexPath.row==5)
    {
        titleLable1.text = @"定位位置";
        if (!dingweiweizhiLabel)
        {
            
            dingweiweizhiLabel = [[UILabel alloc] init];
            dingweiweizhiLabel.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 180*APP_DELEGATE().autoSizeScaleX, 44);
            dingweiweizhiLabel.textAlignment = NSTextAlignmentLeft;
            dingweiweizhiLabel.lineBreakMode = NSLineBreakByWordWrapping;
            dingweiweizhiLabel.numberOfLines = 0;
            dingweiweizhiLabel.textColor = fontColor;
            dingweiweizhiLabel.font = viewFont1;
            dingweiweizhiLabel.text = @"未定位";
            
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

    else   if(indexPath.section==0&&indexPath.row==6)
    {
        
        titleLable1.text = @"是否使用当前位置";
        titleLable1.frame = CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
        
        if (!bendiBtn)
        {
            bendiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bendiBtn.frame = CGRectMake(281*APP_DELEGATE().autoSizeScaleX, 7,30, 30);
            [bendiBtn setImage:[UIImage imageNamed:@"moren_weixuanzhong@3x"] forState:UIControlStateNormal];
            [bendiBtn setImage:[UIImage imageNamed:@"moren_xuanzhong@3x"]  forState:UIControlStateSelected];            [bendiBtn addTarget:self
                                                                                                                                     action:@selector(bendiBtnClick:)
                                                                                                                           forControlEvents:UIControlEventTouchUpInside];
            bendiBtn.selected = NO;
            
        }
        [cell.contentView addSubview:bendiBtn];
    }
   
    else if(indexPath.section==0&&indexPath.row==7)
    {
        titleLable1.text = @"备注";
        if (!beizhuText)
        {
            beizhuText = [[UITextField alloc] init];
            beizhuText.clearButtonMode = UITextFieldViewModeWhileEditing;
            beizhuText.borderStyle = UITextBorderStyleNone;
            beizhuText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            beizhuText.delegate = self;
            beizhuText.placeholder = @"请输入备注";
            beizhuText.returnKeyType = UIReturnKeyDone;
            beizhuText.keyboardType = UIKeyboardTypeDefault;
            beizhuText.font = viewFont1;
            beizhuText.textColor = fontColor;
            beizhuText.text = @"";
            
        }
        [cell.contentView addSubview:beizhuText];
    }

    else
    {
        fgx.hidden = YES;
        titleLable1.hidden = YES;
        cell.backgroundColor = bgViewColor;
        UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 20, 250*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
        [submitBtn setTitle:@"预约送货" forState:UIControlStateNormal];
        [submitBtn setTitle:@"预约送货" forState:UIControlStateHighlighted];
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
    if (indexPath.row==0)
    {
        IQActionSheetPickerView *picker =  [[IQActionSheetPickerView alloc] initWithTitle:@"选择预约日期" delegate:self];
        [picker setTag:1];
        [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
        [picker show];
    }
    else  if (indexPath.row==1)
    {
        IQActionSheetPickerView *picker =  [[IQActionSheetPickerView alloc] initWithTitle:@"选择预约时段" delegate:self];
        [picker setTag:2];
        [picker setTitlesForComponenets:[NSArray arrayWithObjects:
                                         [NSArray arrayWithObjects:
                                          @"9点   -   10点",
                                          @"10点   -   11点",
                                          @"11点   -   12点",
                                          @"12点   -   13点",
                                          @"13点   -   14点",
                                          @"14点   -   15点",
                                          @"15点   -   16点",
                                          @"16点   -   17点",
                                          @"17点   -   18点",
                                         
                                          nil],
                                         nil]];
        [picker setActionSheetPickerStyle:IQActionSheetPickerStyleTextPicker];
        [picker show];
    }
    else if(indexPath.section==0&&indexPath.row==5)
    {
        NSLog(@"定位位置");
        DingWeiDiZhiViewController *vc = [[DingWeiDiZhiViewController alloc] init];
        vc.mydelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        //        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        //        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //        [self presentViewController:nav animated:YES completion:nil];
        
    }
    else if (indexPath.section==0&&indexPath.row==6)
    {
        bendiBtn.selected = !bendiBtn.selected;
        if (bendiBtn.selected==YES)
        {
            latitude = [LocationManager sharedInstance].latitude;
            longitude = [LocationManager sharedInstance].longitude;
            dingweiweizhiLabel.text  = @"已定位";
        }
        else
        {
            latitude = -1;
            longitude = -1;
            dingweiweizhiLabel.text  = @"未定位";
        }
        [_tableView reloadData];
    }
    
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date
{
    if (pickerView.tag==1)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        yuyueshijianText.text = destDateString;
        [_tableView reloadData];

    }
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray*)titles
{
    shijianduanText.text = [titles objectAtIndex:0];
    [_tableView reloadData];
}
- (void)dingweiBtnClick:(id)sender
{
    NSLog(@"定位");
    DingWeiDiZhiViewController *vc = [[DingWeiDiZhiViewController alloc] init];
    vc.mydelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    //    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    //    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)bendiBtnClick:(id)sender
{
    bendiBtn.selected = !bendiBtn.selected;
    if (bendiBtn.selected==YES)
    {
        latitude = [LocationManager sharedInstance].latitude;
        longitude = [LocationManager sharedInstance].longitude;
        dingweiweizhiLabel.text  = @"已定位";
    }
    else
    {
        latitude = -1;
        longitude = -1;
        dingweiweizhiLabel.text  = @"未定位";
    }
    [_tableView reloadData];
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    [self.view endEditing:YES];
    if (shouhuorenText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写收货人姓名"];
        return;
    }
    if (shouhuoPhoneText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写收货人电话"];
        return;
    }
    if (yuyueshijianText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请选择预约日期"];
        return;
    }
    NSDateFormatter *dateFormatterShow = [[NSDateFormatter alloc] init];
    [dateFormatterShow setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatterShow dateFromString:yuyueshijianText.text];

    if(date != [NSDate today])
    {
        if ([date laterDate:[NSDate today]]==[NSDate today])
        {
            [MBProgressHUD showAutoMessage:@"不能选择过去的日期"];
            return;
        }

    }
    
    if (shijianduanText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请选择预约时段"];
        return;
    }
    
    if (dizhiText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填收货地人地址"];
        return;
    }
    if ([dingweiweizhiLabel.text isEqualToString:@"未定位"])
    {
        [MBProgressHUD showAutoMessage:@"请定位"];
        return;
    }
    
    NSLog(@"保存");
    

    [UIAlertView showAlert:@"是否确认并且提交？" delegate:self cancelButton:@"取消" otherButton:@"提交" tag:2];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            [self.view endEditing:YES];
            NSLog(@"下一步");
            NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
            [MBProgressHUD showMessag:@"" toView:self.view];
            
            NSDictionary *loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             @"hex_driver_waybill_uploadOrderSendFunction",@"funcId",
                                             waybill_id,@"waybill_id",
                                             shouhuorenText.text,@"consignee",
                                             shouhuoPhoneText.text,@"consignee_phone",
                                             yuyueshijianText.text,@"order_date",
                                             shijianduanText.text,@"order_between_time",
                                             dizhiText.text,@"order_address",
                                             [NSString stringWithFormat:@"%f",latitude],@"order_address_lng",
                                             [NSString stringWithFormat:@"%f",longitude],@"order_address_lat",
                                             beizhuText.text,@"order_note",
                                             [loginUser objectForKey:@"account_id"],@"order_phone",
                                             nil];
            
            if (beizhuText.text.length>0)
            {
                [paramDic setObject:beizhuText.text forKey:@"order_remark"];
            }
            [helper Soap:ms_driverURL Parameters:paramDic Success:^(id responseObject)
             {
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
                     [MBProgressHUD showAutoMessage:@"预约送货成功"];
                     [self.navigationController popViewControllerAnimated:YES];
                     
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
                 [MBProgressHUD showError:@"预约送货失败" toView:self.view];
             }];
            
        }
        else
        {
            NSLog(@"取消");
        }

    }
    else
    {
        if (buttonIndex==0)
        {
            NSLog(@"取消");
            if (alertView.tag==1)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
