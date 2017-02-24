//
//  SendOutGoodsViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "SendOutGoodsViewController.h"
#import "ChangYongSendAddressViewController.h"
#import "ChangYongGetAddressViewController.h"
#import "AddSendAddressViewController.h"
@interface SendOutGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UILabel *fahuoLabel;
    
    UILabel *fahuoText;   //发货地址
    UILabel *fahuorenText;   //发货人
    UILabel *fahuoPhoneText;   //发货人电话
    
   
    
    UILabel *shouhuoLabel;
    UILabel *shouhuoText; //收货地址
    UILabel *shouhuorenText;   //收货人
    UILabel *shouhuoPhoneText;   //收货人电话
    
    
    UITextField *huoNumText;  //货物件数量
    UITextField *huoNameText; //货物名称
    UILabel *shoufeibiaozhunLabel; //收费标准
    
    NSMutableDictionary *fahuodizhiDic;
    
    
    NSMutableDictionary *shouhuodizhiDic;
    
    
    NSString *shoufeibiaozhunValue;
    
    UIButton *gouBtn;

}
@end

@implementation SendOutGoodsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(xuanchangyong:)
                                                     name:KNOTIFICATION_XuanChangyong
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(xuanchangyong1:)
                                                     name:KNOTIFICATION_XuanChangyong1
                                                   object:nil];
        
        fahuodizhiDic = [[NSMutableDictionary alloc] init];
        shouhuodizhiDic = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[fahuodizhiDic objectForKey:@"ship_address_id"] length]==0)
    {
        //获取默认发货地址
        [self getShipaddress_obtain];
    }
   
    //获取默认收货地址
    //    [self getReceiptaddress_obtain];
    
}

-(void)getShipaddress_obtain
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_shipaddress_obtain",@"funcId",
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
             [fahuodizhiDic removeAllObjects];
             [fahuodizhiDic setDictionary:item];
             [_tableView reloadData];
         }
         else
         {
             
         }
         NSLog(@"%@",responseObject);
     } Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
         
     }];

}

- (void)getReceiptaddress_obtain
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_receiptaddress_obtain",@"funcId",
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
             [shouhuodizhiDic removeAllObjects];
             [shouhuodizhiDic setDictionary:item];
             [_tableView reloadData];
         }
         else
         {
             
         }
         NSLog(@"%@",responseObject);
     } Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
         
     }];

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
    self.title = @"发货";
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
        return 1;
    }
    else
    {
        return 3;
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
    if (indexPath.section==1&&indexPath.row==2)
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
        titleLable1.hidden = YES;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12, 20, 20)];
        icon.image = [UIImage imageWithName:@"fahuotubiao"];
        [cell.contentView addSubview:icon];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //发货地址编号
        if ([[fahuodizhiDic objectForKey:@"ship_address_id"] length]==0)
        {
            if (!fahuoLabel)
            {
                fahuoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*APP_DELEGATE().autoSizeScaleX, 0, 70*APP_DELEGATE().autoSizeScaleX, 44)];
                fahuoLabel.backgroundColor = [UIColor clearColor];
                fahuoLabel.textColor = fontColor;
                fahuoLabel.textAlignment = NSTextAlignmentLeft;
                fahuoLabel.lineBreakMode = NSLineBreakByWordWrapping;
                fahuoLabel.numberOfLines = 0;
                fahuoLabel.font = viewFont1;
                fahuoLabel.text = @"发货地址";
            }
             [cell.contentView addSubview:fahuoLabel];
        }
        else
        {
            if (!fahuoText)
            {
                fahuoText = [[UILabel alloc] initWithFrame:CGRectMake(40*APP_DELEGATE().autoSizeScaleX, 0, 252*APP_DELEGATE().autoSizeScaleX, 22)];
                fahuoText.backgroundColor = [UIColor clearColor];
                fahuoText.textColor = fontColor;
                fahuoText.textAlignment = NSTextAlignmentLeft;
                fahuoText.lineBreakMode = NSLineBreakByTruncatingHead;
                fahuoText.numberOfLines = 0;
                fahuoText.font = viewFont2;
            }
            fahuoText.text = [NSString stringWithFormat:@"%@%@",[fahuodizhiDic objectForKey:@"region_city"],[fahuodizhiDic objectForKey:@"address"]];
            [cell.contentView addSubview:fahuoText];
            if (!fahuorenText)
            {
                fahuorenText = [[UILabel alloc] initWithFrame:CGRectMake(40*APP_DELEGATE().autoSizeScaleX, 22, 180*APP_DELEGATE().autoSizeScaleX, 22)];
                fahuorenText.backgroundColor = [UIColor clearColor];
                fahuorenText.textColor = [UIColor colorWithRed:105/255.0 green:143/255.0 blue:243/255.0 alpha:1.0];
                fahuorenText.textAlignment = NSTextAlignmentLeft;
                fahuorenText.lineBreakMode = NSLineBreakByWordWrapping;
                fahuorenText.numberOfLines = 0;
                fahuorenText.font = viewFont2;
            }
            fahuorenText.text = [NSString stringWithFormat:@"%@",[fahuodizhiDic objectForKey:@"user_name"]];
            [cell.contentView addSubview:fahuorenText];
            CGSize size = [fahuorenText boundingRectWithSize:CGSizeMake(180*APP_DELEGATE().autoSizeScaleX, 22)];
            fahuorenText.frame = CGRectMake(40*APP_DELEGATE().autoSizeScaleX, 22, size.width,22);
            
            if (!fahuoPhoneText)
            {
                fahuoPhoneText = [[UILabel alloc] initWithFrame:CGRectMake((40+size.width+20)*APP_DELEGATE().autoSizeScaleX, 22, 100*APP_DELEGATE().autoSizeScaleX, 22)];
                fahuoPhoneText.backgroundColor = [UIColor clearColor];
                fahuoPhoneText.textColor = [UIColor colorWithRed:105/255.0 green:143/255.0 blue:243/255.0 alpha:1.0];
                fahuoPhoneText.textAlignment = NSTextAlignmentLeft;
                fahuoPhoneText.lineBreakMode = NSLineBreakByWordWrapping;
                fahuoPhoneText.numberOfLines = 0;
                fahuoPhoneText.font = viewFont2;
            }
            fahuoPhoneText.frame = CGRectMake((40+size.width+20)*APP_DELEGATE().autoSizeScaleX, 22, 100*APP_DELEGATE().autoSizeScaleX, 22);
            fahuoPhoneText.text = [NSString stringWithFormat:@"%@",[fahuodizhiDic objectForKey:@"phone"]];
            [cell.contentView addSubview:fahuoPhoneText];

            UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fahuorenphoneTap:)];
            tapGr.cancelsTouchesInView = YES;
            [fahuoPhoneText addGestureRecognizer:tapGr];
            fahuoPhoneText.userInteractionEnabled = YES;

        }
        
      
        
        

    }
    else  if(indexPath.section==0&&indexPath.row==1)
    {
        titleLable1.hidden = YES;
        fgx.hidden = YES;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12, 20, 20)];
        icon.image = [UIImage imageWithName:@"shouhuotubiao"];
        [cell.contentView addSubview:icon];
 
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //收货地址编号
        if ([[shouhuodizhiDic objectForKey:@"recript_address_id"] length]==0)
        {
            if (!shouhuoLabel)
            {
                shouhuoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*APP_DELEGATE().autoSizeScaleX, 0, 70*APP_DELEGATE().autoSizeScaleX, 44)];
                shouhuoLabel.backgroundColor = [UIColor clearColor];
                shouhuoLabel.textColor = fontColor;
                shouhuoLabel.textAlignment = NSTextAlignmentLeft;
                shouhuoLabel.lineBreakMode = NSLineBreakByTruncatingHead;
                shouhuoLabel.numberOfLines = 0;
                shouhuoLabel.font = viewFont1;
                shouhuoLabel.text = @"收货地址";
            }
            [cell.contentView addSubview:shouhuoLabel];
        }
        else
        {
            if (!shouhuoText)
            {
                shouhuoText = [[UILabel alloc] initWithFrame:CGRectMake(40*APP_DELEGATE().autoSizeScaleX, 0, 252*APP_DELEGATE().autoSizeScaleX, 22)];
                shouhuoText.backgroundColor = [UIColor clearColor];
                shouhuoText.textColor = fontColor;
                shouhuoText.textAlignment = NSTextAlignmentLeft;
                shouhuoText.lineBreakMode = NSLineBreakByWordWrapping;
                shouhuoText.numberOfLines = 0;
                shouhuoText.font = viewFont2;
            }
            shouhuoText.text = [NSString stringWithFormat:@"%@%@",[shouhuodizhiDic objectForKey:@"recript_city"],[shouhuodizhiDic objectForKey:@"address"]];
            [cell.contentView addSubview:shouhuoText];
            if (!shouhuorenText)
            {
                shouhuorenText = [[UILabel alloc] initWithFrame:CGRectMake(40*APP_DELEGATE().autoSizeScaleX, 22, 180*APP_DELEGATE().autoSizeScaleX, 22)];
                shouhuorenText.backgroundColor = [UIColor clearColor];
                shouhuorenText.textColor = [UIColor colorWithRed:105/255.0 green:143/255.0 blue:243/255.0 alpha:1.0];
                shouhuorenText.textAlignment = NSTextAlignmentLeft;
                shouhuorenText.lineBreakMode = NSLineBreakByWordWrapping;
                shouhuorenText.numberOfLines = 0;
                shouhuorenText.font = viewFont2;
            }
            shouhuorenText.text  = [NSString stringWithFormat:@"%@",[shouhuodizhiDic objectForKey:@"user_name"]];
            [cell.contentView addSubview:shouhuorenText];
            CGSize size = [shouhuorenText boundingRectWithSize:CGSizeMake(180*APP_DELEGATE().autoSizeScaleX, 22)];
            shouhuorenText.frame = CGRectMake(40*APP_DELEGATE().autoSizeScaleX, 22, size.width*APP_DELEGATE().autoSizeScaleX,22);
            
            if (!shouhuoPhoneText)
            {
                shouhuoPhoneText = [[UILabel alloc] initWithFrame:CGRectMake((40+size.width+20)*APP_DELEGATE().autoSizeScaleX, 22, 100*APP_DELEGATE().autoSizeScaleX, 22)];
                shouhuoPhoneText.backgroundColor = [UIColor clearColor];
                shouhuoPhoneText.textColor = [UIColor colorWithRed:105/255.0 green:143/255.0 blue:243/255.0 alpha:1.0];
                shouhuoPhoneText.textAlignment = NSTextAlignmentLeft;
                shouhuoPhoneText.lineBreakMode = NSLineBreakByWordWrapping;
                shouhuoPhoneText.numberOfLines = 0;
                shouhuoPhoneText.font = viewFont2;
            }
            shouhuoPhoneText.text =  [NSString stringWithFormat:@"%@",[shouhuodizhiDic objectForKey:@"phone"]];
            [cell.contentView addSubview:shouhuoPhoneText];
            UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouhuorenphoneTap:)];
            tapGr.cancelsTouchesInView = YES;
            [shouhuoPhoneText addGestureRecognizer:tapGr];
            shouhuoPhoneText.userInteractionEnabled = YES;
        }
        
        
    }
    else  if(indexPath.section==1&&indexPath.row==0)
    {
        titleLable1.text = @"货物件数";
        if (!huoNumText)
        {
            huoNumText = [[UITextField alloc] init];
            huoNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
            huoNumText.borderStyle = UITextBorderStyleNone;
            huoNumText.textColor = fontColor;
            huoNumText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            huoNumText.delegate = self;
            huoNumText.placeholder = @"请输入货物件数";
            huoNumText.returnKeyType = UIReturnKeyDone;
            huoNumText.keyboardType = UIKeyboardTypeNumberPad;
            huoNumText.font = viewFont1;
            huoNumText.text = @"";
            
        }
        [cell.contentView addSubview:huoNumText];
       
    }
    else  if(indexPath.section==1&&indexPath.row==1)
    {
        titleLable1.text = @"货物名称";
        fgx.hidden = YES;
        if (!huoNameText)
        {
            huoNameText = [[UITextField alloc] init];
            huoNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
            huoNameText.borderStyle = UITextBorderStyleNone;
            huoNameText.frame = CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 44);
            huoNameText.delegate = self;
            huoNameText.placeholder = @"请输入货物名称";
            huoNameText.returnKeyType = UIReturnKeyDone;
            huoNameText.keyboardType = UIKeyboardTypeDefault;
            huoNameText.font = viewFont1;
             huoNameText.textColor = fontColor;
            huoNameText.text = @"";
            
        }
        [cell.contentView addSubview:huoNameText];
        
    }
//    else  if(indexPath.section==1&&indexPath.row==2)
//    {
//        titleLable1.text = @"收费标准";
//        titleLable1.frame = CGRectMake(15, 0, 70, 22);
//        fgx.hidden = YES;
//
//        shoufeibiaozhunLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 22, 290, 22)];
//        shoufeibiaozhunLabel.backgroundColor = [UIColor clearColor];
//        shoufeibiaozhunLabel.textColor = fontColor;
//        shoufeibiaozhunLabel.textAlignment = NSTextAlignmentLeft;
//        shoufeibiaozhunLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        shoufeibiaozhunLabel.numberOfLines = 0;
//        shoufeibiaozhunLabel.font = viewFont1;
//        shoufeibiaozhunLabel.text = @"成都--温江 10元/方,200/吨";
//        [cell.contentView addSubview:shoufeibiaozhunLabel];
//    }
    else  if(indexPath.section==1&&indexPath.row==2)
    {
        titleLable1.hidden = YES;
        fgx.hidden = YES;
        cell.backgroundColor = bgViewColor;
        
        gouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        gouBtn.frame = CGRectMake(0, 0,40, 40);
        [gouBtn setImage:[[UIImage imageNamed:@"tongyi_2"] imageByScalingToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        [gouBtn setImage:[[UIImage imageNamed:@"tongyi"] imageByScalingToSize:CGSizeMake(10, 10)] forState:UIControlStateSelected];
        [gouBtn addTarget:self
                   action:@selector(guoBtnClick:)
         forControlEvents:UIControlEventTouchUpInside];
        gouBtn.selected = YES;
        [cell.contentView addSubview:gouBtn];

        
        UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*APP_DELEGATE().autoSizeScaleX, 5, 100*APP_DELEGATE().autoSizeScaleX, 30)];
        agreeLabel.numberOfLines = 0;
        agreeLabel.textAlignment = NSTextAlignmentLeft;
        agreeLabel.font = viewFont3;
        agreeLabel.textColor = fontColor;
        agreeLabel.text = @"我同意";
        [cell.contentView addSubview:agreeLabel];
        
        UILabel *clauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(70*APP_DELEGATE().autoSizeScaleX, 5, 200*APP_DELEGATE().autoSizeScaleX, 30)];
        clauseLabel.numberOfLines = 0;
        clauseLabel.textAlignment = NSTextAlignmentLeft;
        clauseLabel.font = viewFont3;
        clauseLabel.textColor = titleViewColor;
        clauseLabel.text = @"《托运邦运单契约条款》";
        [cell.contentView addSubview:clauseLabel];
        
        clauseLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clauseLabelTap:)];
        tapGr.cancelsTouchesInView = YES;
        [clauseLabel addGestureRecognizer:tapGr];
        
        UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 40, 250*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
        [submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [submitBtn setTitle:@"确认提交" forState:UIControlStateHighlighted];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
        [submitBtn addTarget:self
                     action:@selector(submitBtnClick:)
           forControlEvents:UIControlEventTouchUpInside];
        submitBtn.titleLabel.font = viewFont1;
        [cell.contentView addSubview:submitBtn];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 80*APP_DELEGATE().autoSizeScaleY, 290*APP_DELEGATE().autoSizeScaleX, 60)];
        descLabel.numberOfLines = 0;
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.font = viewFont3;
        
        [cell.contentView addSubview:descLabel];

        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"温馨提示:每天9:00-20:00为营业时间(部分区域以当地营业部为准),非营业时间订单受理可能会稍有延迟,请耐心等待"];
        [str addAttribute:NSForegroundColorAttributeName value:titleViewColor range:NSMakeRange(0,5)];
        [str addAttribute:NSForegroundColorAttributeName value:fontColor range:NSMakeRange(5,str.length-5)];
        descLabel.attributedText = str;

    }
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0)
    {
        NSLog(@"发货地址");
        if ([[fahuodizhiDic objectForKey:@"ship_address_id"] length]!=0)
        {
            ChangYongSendAddressViewController *vc =[[ChangYongSendAddressViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            AddSendAddressViewController *vc = [[AddSendAddressViewController alloc] init];
            YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
       

        
    }
    else  if (indexPath.section==0&&indexPath.row==1)
    {
        NSLog(@"收货地址");
        ChangYongGetAddressViewController *vc =[[ChangYongGetAddressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
              
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)guoBtnClick:(id)sender
{
    gouBtn.selected = !gouBtn.selected;
}

- (void)clauseLabelTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"条款");
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"托运邦运单契约条款";
    vc.webURL = [NSString stringWithFormat:@"%@",contractClauseURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    NSLog(@"fahuodizhiDic:%@",fahuodizhiDic);
    NSLog(@"shouhuodizhiDic:%@",shouhuodizhiDic);
    if ([[fahuodizhiDic objectForKey:@"ship_address_id"] length]==0)
    {
        [MBProgressHUD showAutoMessage:@"请选择发货地址"];
        return;
    }
    if (huoNumText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写货物件数"];
        return;
    }
    if (huoNameText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写货物名称"];
        return;
    }
    if(gouBtn.selected==NO)
    {
        [MBProgressHUD showError:@"请同意托运邦运单契约条款" toView:self.view];
        return;
    }

 [UIAlertView showAlert:@"是否确认并且提交？" delegate:self cancelButton:@"取消" otherButton:@"提交" tag:1];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"保存");
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_indent_save",@"funcId",
                                         [fahuodizhiDic objectForKey:@"ship_address_id"],@"shipAddressId",
                                         huoNameText.text,@"productName",
                                         huoNumText.text,@"number",
                                         nil];
        if ([[shouhuodizhiDic objectForKey:@"recript_address_id"] length]!=0)
        {
            [paramDic setObject:[shouhuodizhiDic objectForKey:@"recript_address_id"] forKey:@"receiveAddressId"];
        }
        
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
                 [MBProgressHUD showMessag:@"发货成功" toView:self.view];
                 [self.navigationController dismissViewControllerAnimated:YES completion:^{
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     ((YLLTabBarController *)self.view.window.rootViewController).selectedIndex = 0;
                     [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_fahuolist object:nil userInfo:nil];
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
             [MBProgressHUD showError:@"发货失败" toView:self.view];
         }];
        
    }
    else
    {
        NSLog(@"取消");
    }
    
}

-(void)xuanchangyong:(NSNotification *)notification
{
    [fahuodizhiDic removeAllObjects];
    [fahuodizhiDic setDictionary: notification.userInfo];

    [_tableView reloadData];
}

-(void)xuanchangyong1:(NSNotification *)notification
{
    [shouhuodizhiDic removeAllObjects];
    [shouhuodizhiDic setDictionary: notification.userInfo];

    [_tableView reloadData];
}

- (void)fahuorenphoneTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"拨打电话");
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:[fahuodizhiDic objectForKey:@"phone"]]]];
}

- (void)shouhuorenphoneTap:(UITapGestureRecognizer*)tapGr
{
    NSLog(@"拨打电话");
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:[shouhuodizhiDic objectForKey:@"phone"]]]];
}
@end
