//
//  HomePageViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "HomePageViewController.h"
#import "SDCycleScrollView.h"

#import "CollectingViewController.h"  //代收款
#import "OrdersViewController.h"
#import "ShouHuoJiluViewController.h"
#import "ReceiptViewController.h" //回单
#import "ClaimsViewController.h" //理赔
#import "ComplaintViewController.h" //投诉
#import "StatisticsViewController.h" //统计
#import "MyMessageViewController.h"  //消息


#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import "SaoMaViewController.h"

#import "UpdatePassWordViewController.h"

#import "YFRollingLabel.h"
#import "XianLuShengViewController.h"
#import "HelpViewController.h"
@interface HomePageViewController ()<UITextFieldDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate,SaoMaViewControllerDelegate,UIAlertViewDelegate>
{
    UIScrollView *scrollView; //首页根视图
    UITextField *searchText;  //搜索栏
    SDCycleScrollView *cycleScrollView; //滚动视图
    NSMutableArray *imagesURLStrings; //滚动视图数据 (暂未使用)
    UIView *bgView;
    YFRollingLabel *paomaView;
    
    BOOL wancheng1;
    BOOL wancheng2;
    BOOL wancheng3;
}
@end

@implementation HomePageViewController

- (void)sendCode:(NSString *)code
{
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"运单跟踪";
    vc.webURL = [NSString stringWithFormat:@"%@?waybillNum=%@&type=1",waybillDetailsURL,code];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)noPassWordTip:(NSNotification *)notification
{
    [UIAlertView showAlert:@"您还没有设置登录密码，现在设置吗?" delegate:self cancelButton:@"取消" otherButton:@"设置" tag:1];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"设置密码");
        UpdatePassWordViewController *vc = [[UpdatePassWordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        NSLog(@"不设置");
    }
}
/**
 *  @author 徐杨
 *
 *  获取通知前往发货列表
 *
 *  @param notification
 */
-(void)goSendList:(NSNotification *)notification
{
    OrdersViewController *vc = [[OrdersViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        imagesURLStrings = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(goSendList:)
                                                     name:KNOTIFICATION_fahuolist
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noPassWordTip:)
                                                     name:KNOTIFICATION_noPassWord
                                                   object:nil];
        
       

    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"首页"];
    [self getBanner];
    //获取新闻
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_message_app_queryAllFunction",@"funcId",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
         if (obj.global.flag.intValue==-4001)
         {
//             [MBProgressHUD showAutoMessage:@"登录失效，请重新登录。"];
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
//             [MBProgressHUD showAutoMessage:@"该功能暂时已关闭"];
             return;
         }
         if (obj.global.flag.intValue==-4003)
         {
//             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             return;
         }
         if (obj.global.flag.intValue!=1)
         {
//             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             return;
         }
         
         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             if(((response *)obj.responses[0]).items.count>0)
             {
//                 [items addObjectsFromArray: ((response *)obj.responses[0]).items];
                 NSMutableArray *array = [[NSMutableArray alloc] init];
                 
                 for (int i=0; i < ((response *)obj.responses[0]).items.count; i++)
                 {
                     NSDictionary *info = [((response *)obj.responses[0]).items objectAtIndex:i];
                     [array addObject:[info objectForKey:@"message_title"]];
                 }
                 [paomaView removeFromSuperview];
                 
                 
                 paomaView = [[YFRollingLabel alloc] initWithFrame:CGRectMake(110*APP_DELEGATE().autoSizeScaleX, 2*APP_DELEGATE().autoSizeScaleY, 200*APP_DELEGATE().autoSizeScaleX, 35*APP_DELEGATE().autoSizeScaleY)  textArray:array font:viewFont2 textColor:fontColor];
                 [bgView addSubview:paomaView];
                 paomaView.speed = 1;
                 [paomaView setOrientation:RollingOrientationLeft];
                 [paomaView setInternalWidth:paomaView.frame.size.width / 3];;
                 
                 //Label Click Event Using Block
                 paomaView.labelClickBlock = ^(NSInteger index){
                     NSString *text = [array objectAtIndex:index];
                     NSLog(@"You Tapped item:%li , and the text is %@",(long)index,text);
                 };

                 
             }
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
     }];
    
    //如果没有用户资料 前往登录  否则检查更新
    NSDictionary *user =  [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
    if (user==nil)
    {
        [AppTool presentDengLu:self];
    }
    else
    {
        if (ISAPPSTORE==0)
        {
            [[PgyUpdateManager sharedPgyManager] checkUpdate];
        }
        else
        {
            [self checkUpdateWithAppID:@"1142144828" success:^(NSDictionary *resultDic, BOOL isNewVersion, NSString *newVersion) {
                
                if (isNewVersion)
                {
                    if (resultDic!=nil)
                    {
                        [self showUpdateView:resultDic];
                    }
                    
                }
                else
                {
                    
                }
                
            } failure:^(NSError *error)
             {
                 
             }];
            
        }
        
        
        //        968615456  测试
        //        1142144828  微门店
        
    }
}

- (void)getBanner
{

    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
//    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_client_message_app_queryBannerFunction",@"funcId",
                                     @"1",@"banner_type",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
         ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
         if (obj.global.flag.intValue==-4001)
         {
             //             [MBProgressHUD showAutoMessage:@"登录失效，请重新登录。"];
//             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                 sleep(2);
//                 dispatch_async(dispatch_get_main_queue(), ^{
//                     
//                     //清空保存的token等数据
//                     NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
//                     for (int i = 0; i < [cookies count]; i++)
//                     {
//                         NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
//                         [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//                         
//                     }
//                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUser];
//                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];
//                     
//                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCookie];
////                     ((YLLTabBarController *)self.view.window.rootViewController).selectedIndex = 0;
////                     [self.navigationController popToRootViewControllerAnimated:NO];
//                     [AppTool presentDengLu:self];
//                     
//                 });
//             });
             [imagesURLStrings addObject:[UIImage imageNamed:@"zhuye_banner1"]];
             cycleScrollView.localizationImagesGroup = imagesURLStrings;
             
             return;
         }
         if (obj.global.flag.intValue==-4002)
         {
             //             [MBProgressHUD showAutoMessage:@"该功能暂时已关闭"];
             return;
         }
         if (obj.global.flag.intValue==-4003)
         {
             //             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             return;
         }
         if (obj.global.flag.intValue!=1)
         {
             //             [MBProgressHUD showAutoMessage:@"服务器异常，请稍后再试"];
             return;
         }
         
         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             if(((response *)obj.responses[0]).items.count>0)
             {
                 //                 [items addObjectsFromArray: ((response *)obj.responses[0]).items];
                 NSMutableArray *array = [[NSMutableArray alloc] init];
                 
                 for (int i=0; i < ((response *)obj.responses[0]).items.count; i++)
                 {
                     NSDictionary *info = [((response *)obj.responses[0]).items objectAtIndex:i];
                     [array addObject:[info objectForKey:@"banner_url"]];
                 }
            
                     cycleScrollView.imageURLStringsGroup = array;

             }
         }
         else
         {
//             NSRange range = [((response *)obj.responses[0]).message rangeOfString:@"UnknownHostException"];
//             if (range.location !=NSNotFound)
//             {
//                 [MBProgressHUD showError:@"网络异常" toView:self.view];
//             }
//             else
//             {
//                 [MBProgressHUD showError:((response *)obj.responses[0]).message toView:self.view];
//             }
             [imagesURLStrings addObject:[UIImage imageNamed:@"zhuye_banner1"]];
             cycleScrollView.localizationImagesGroup = imagesURLStrings;

         }
         NSLog(@"%@",responseObject);
         
     } Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [imagesURLStrings addObject:[UIImage imageNamed:@"zhuye_banner1"]];
         cycleScrollView.localizationImagesGroup = imagesURLStrings;

     }];
}

- (void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion , NSString * newVersion))success failure:(void (^)(NSError *error))failure
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    NSString *encodingUrl=[[@"http://itunes.apple.com/lookup?id=" stringByAppendingString:appID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    NSString *OLDVERSION =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //     NSString *encodingUrl=[NSString stringWithFormat:@"https://itunes.apple.com/lookup?bundleId=%@",OLDVERSION];
    
    
    
    
    
    
    [helper GET:encodingUrl Parameters:nil Success:^(id responseObject)
     {
         
         NSLog(@"responseObject:%@",responseObject);
         NSArray *results = [responseObject objectForKey:@"results"];
         if (results.count>0)
         {
             NSDictionary *versionInfo = [results objectAtIndex:0];
             NSString * versionStr = [versionInfo valueForKey:@"version"];
             float version =[versionStr floatValue];
             //self.iTunesLink=[[[resultDic objectForKey:@"results"] objectAtIndex:0] valueForKey:@"trackViewUrl"];
             NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
             float currentVersion = [[infoDic valueForKey:@"CFBundleShortVersionString"] floatValue];
             
             if(version>currentVersion)
             {
                 success(responseObject, YES, versionStr);
                 NSLog(@"要升级");
                 
             }else{
//                  success(responseObject, YES, versionStr);
                 success(responseObject, NO, versionStr);
                 NSLog(@"不要升级");
                 
             }
             
         }
         else
         {
             success(responseObject, NO, nil);
             NSLog(@"不要升级");
         }
         
         
         
     } Failure:^(NSError *error)
     {
         failure(nil);
         NSLog(@"%@",error);
     }];
    
    
}

- (void)showUpdateView:(NSDictionary *)resultDic
{
    NSArray *results = [resultDic objectForKey:@"results"];
    NSDictionary *result = [results objectAtIndex:0];
    NSString *alertMsg=
    [[[@"托运邦货主" stringByAppendingString:[NSString stringWithFormat:@"%0.1f",[[result objectForKey:@"version"] floatValue]]]
      stringByAppendingString:@"，赶快体验最新版本吧！"]
     stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",[result objectForKey:@"releaseNotes"] ]];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    //    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    //
    //    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UIWindow *window = app.window;
        
        [UIView animateWithDuration:1.0f animations:^{
            window.alpha = 0;
            window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        } completion:^(BOOL finished) {
            NSString *str = @"https://itunes.apple.com/app/id1142144828";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            exit(0);
        }];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTitle];
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
 *  初始化标题栏
 */
- (void)initTitle
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_dianhua" highIcon:@"zhuye_dianhua" target:self action:@selector(phoneBtnClick:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_shaoyishao" highIcon:@"zhuye_shaoyishao" target:self action:@selector(scanBtnClick:)];
    
    UIImageView *searchBg = [[UIImageView alloc] initWithFrame:CGRectMake(45*APP_DELEGATE().autoSizeScaleX, 7, 230*APP_DELEGATE().autoSizeScaleX, 30)];
    searchBg.image = [UIImage imageNamed:@"zhuye_biankuang"];
    searchBg.userInteractionEnabled = YES;
    
    UIImageView *iconView1 = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"zhuye_sousuo"]];
    iconView1.contentMode = UIViewContentModeCenter;
    
    searchText = [[UITextField alloc] init];
    searchText.leftView = iconView1;
    searchText.leftViewMode = UITextFieldViewModeAlways;
    searchText.leftView.frame = CGRectMake(0, 0, 30, 30);
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.frame = CGRectMake(0, 0, 215*APP_DELEGATE().autoSizeScaleX, 30);
    searchText.delegate = self;
    searchText.placeholder = @"请输入您的运单号";
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.keyboardType = UIKeyboardTypeDefault;
    searchText.font = viewFont2;
    searchText.textColor = [UIColor whiteColor];
    [searchText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchText setValue:viewFont2 forKeyPath:@"_placeholderLabel.font"];
    [searchBg addSubview:searchText];
    self.navigationItem.titleView = searchBg;
}

/**
 *  @author 徐杨
 *
 *  初始化界面
 */
- (void)initView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-statusViewHeight-TabbarHeight)];
    scrollView.backgroundColor = bgViewColor;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollView.frame.size.height*1.1*APP_DELEGATE().autoSizeScaleY);
    [self.view addSubview:scrollView];
    
    
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 320, 125) imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.delegate = self;
    //            cycleScrollView2.titlesGroup = titles;
    cycleScrollView.dotColor = titleViewColor; // 自定义分页控件小圆标颜色
    cycleScrollView.showPageControl = NO;
        cycleScrollView.placeholderImage = [UIImage imageNamed:@"zhuye_banner2"];

//    [imagesURLStrings addObject:[UIImage imageNamed:@"zhuye_banner2"]];
//    [imagesURLStrings addObject:[UIImage imageNamed:@"zhuye_banner1"]];
//    [imagesURLStrings addObject:[UIImage imageNamed:@"zhuye_banner3"]];
    cycleScrollView.localizationImagesGroup = imagesURLStrings;
    cycleScrollView.autoScrollTimeInterval = 4;
    [scrollView addSubview:cycleScrollView];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, 320, 37)];
    bgView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView];

    UIView *fgx1 = [[UIView alloc] initWithFrame:CGRectMake(100, 2, 1, 34)];
    fgx1.backgroundColor = bgViewColor;
    [bgView addSubview:fgx1];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_zuixinhuodong@2x"]];
    iconView.center = CGPointMake(19, 19);
    [bgView addSubview:iconView];
    
    UILabel *paomalabel1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, 65, 35)];
    paomalabel1.backgroundColor = [UIColor clearColor];
    paomalabel1.textColor = titleViewColor;
    paomalabel1.textAlignment = NSTextAlignmentLeft;
    paomalabel1.lineBreakMode = NSLineBreakByWordWrapping;
    paomalabel1.numberOfLines = 0;
    paomalabel1.font = viewFont2;
    paomalabel1.text = @"最新消息";
    [bgView addSubview:paomalabel1];
    
    
    paomaView = [[YFRollingLabel alloc] initWithFrame:CGRectMake(110*APP_DELEGATE().autoSizeScaleX, 2*APP_DELEGATE().autoSizeScaleY, 200*APP_DELEGATE().autoSizeScaleX, 35*APP_DELEGATE().autoSizeScaleY)];
    [bgView addSubview:paomaView];
    
    //    //代收款
    UIButton *receiptsBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 125 + 38, 81, 100)];
    
    UIImageView *receiptsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_daishoukuan"]];
    receiptsImg.center = CGPointMake(40, 40);
    [receiptsBtn addSubview:receiptsImg];
    
    UILabel *receiptslabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 80, 30)];
    receiptslabel1.backgroundColor = [UIColor clearColor];
    receiptslabel1.textColor = fontColor;
    receiptslabel1.textAlignment = NSTextAlignmentCenter;
    receiptslabel1.lineBreakMode = NSLineBreakByWordWrapping;
    receiptslabel1.numberOfLines = 0;
    receiptslabel1.font = viewFont2;
    receiptslabel1.text = @"代收款";
    [receiptsBtn addSubview:receiptslabel1];
    
    [receiptsBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [receiptsBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
//    [receiptsBtn addTarget:self
//                    action:@selector(receiptsBtnClick:)
//          forControlEvents:UIControlEventTouchUpInside];
    [receiptsBtn addTarget:self
                    action:@selector(receiptsBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:receiptsBtn];
    //
    ////    订单
    UIButton *orderBtn = [[UIButton alloc] initWithFrame: CGRectMake(80, 125 + 38, 81, 100)];
    UIImageView *orderImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_dingdan"]];
    orderImg.center = CGPointMake(40, 40);
    [orderBtn addSubview:orderImg];
    
    UILabel *orderlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 80, 30)];
    orderlabel1.backgroundColor = [UIColor clearColor];
    orderlabel1.textColor = fontColor;
    orderlabel1.textAlignment = NSTextAlignmentCenter;
    orderlabel1.lineBreakMode = NSLineBreakByWordWrapping;
    orderlabel1.numberOfLines = 0;
    orderlabel1.font = viewFont2;
    orderlabel1.text = @"订单";
    [orderBtn addSubview:orderlabel1];
    
    [orderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [orderBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
    [orderBtn addTarget:self
                 action:@selector(orderBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:orderBtn];
    //
    ////    收货
    UIButton *ReceivBtn = [[UIButton alloc] initWithFrame: CGRectMake(160, 125 + 38, 81, 100)];
    UIImageView *ReceivImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_shouhuo"]];
    ReceivImg.center = CGPointMake(40, 40);
    [ReceivBtn addSubview:ReceivImg];
    
    UILabel *Receivlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 80, 30)];
    Receivlabel1.backgroundColor = [UIColor clearColor];
    Receivlabel1.textColor = fontColor;
    Receivlabel1.textAlignment = NSTextAlignmentCenter;
    Receivlabel1.lineBreakMode = NSLineBreakByWordWrapping;
    Receivlabel1.numberOfLines = 0;
    Receivlabel1.font = viewFont2;
    Receivlabel1.text = @"运单";
    [ReceivBtn addSubview:Receivlabel1];
    
    
    [ReceivBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [ReceivBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
    [ReceivBtn addTarget:self
                  action:@selector(ReceivBtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:ReceivBtn];
    //
    ////    回单
    UIButton *receiptBtn = [[UIButton alloc] initWithFrame: CGRectMake(240, 125 + 38, 81, 100)];
    UIImageView *receiptImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_huidan"]];
    receiptImg.center = CGPointMake(40, 40);
    [receiptBtn addSubview:receiptImg];
    
    UILabel *receiptlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 80, 30)];
    receiptlabel1.backgroundColor = [UIColor clearColor];
    receiptlabel1.textColor = fontColor;
    receiptlabel1.textAlignment = NSTextAlignmentCenter;
    receiptlabel1.lineBreakMode = NSLineBreakByWordWrapping;
    receiptlabel1.numberOfLines = 0;
    receiptlabel1.font = viewFont2;
    receiptlabel1.text = @"回单";
    [receiptBtn addSubview:receiptlabel1];
    
    
    [receiptBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [receiptBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
    [receiptBtn addTarget:self
                   action:@selector(receiptBtnClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:receiptBtn];
    
    //查询线路
    UIView *xianluView =  [[UIView alloc] initWithFrame:CGRectMake(0, 270, 320, 50)];
    xianluView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:xianluView];
       xianluView.userInteractionEnabled = YES;
    
    UIButton *xianluBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 320, 50)];
    [xianluBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]] forState:UIControlStateNormal];
    [xianluBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
    [xianluBtn addTarget:self
                       action:@selector(xianluBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
    [xianluView addSubview:xianluBtn];
    
    UIImageView *jiantouView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 18, 18)];
    jiantouView.image = [UIImage imageNamed:@"sy_jiantou"];
    jiantouView.center = CGPointMake(300, 25);
    [xianluBtn addSubview:jiantouView];
    
    UIImageView *iconView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 32, 32)];
    iconView1.image = [UIImage imageNamed:@"sy_xianluchaxun"];
    [xianluBtn addSubview:iconView1];
 

    
    UILabel *xianlulabel1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 26)];
    xianlulabel1.backgroundColor = [UIColor clearColor];
    xianlulabel1.textColor = fontColor;
    xianlulabel1.textAlignment = NSTextAlignmentLeft;
    xianlulabel1.lineBreakMode = NSLineBreakByWordWrapping;
    xianlulabel1.numberOfLines = 0;
    xianlulabel1.font = viewFont2;
    xianlulabel1.text = @"线路查询";
    [xianluBtn addSubview:xianlulabel1];
    
    UILabel *xianlulabel2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 200, 20)];
    xianlulabel2.backgroundColor = [UIColor clearColor];
    xianlulabel2.textColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    xianlulabel2.textAlignment = NSTextAlignmentLeft;
    xianlulabel2.lineBreakMode = NSLineBreakByWordWrapping;
    xianlulabel2.numberOfLines = 0;
    xianlulabel2.font = viewFont3;
    xianlulabel2.text = @"具体线路查询...点击查看更多";
    [xianluBtn addSubview:xianlulabel2];
    //业务介绍
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 327, 320, 160)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:bgView2];
    
    UIImageView *iconView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sy_yun"]];
    iconView2.center = CGPointMake(20, 15);
    [bgView2 addSubview:iconView2];
    
    UILabel *jieshaolabel1 = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 80, 30)];
    jieshaolabel1.backgroundColor = [UIColor clearColor];
    jieshaolabel1.textColor = fontColor;
    jieshaolabel1.textAlignment = NSTextAlignmentLeft;
    jieshaolabel1.lineBreakMode = NSLineBreakByWordWrapping;
    jieshaolabel1.numberOfLines = 0;
    jieshaolabel1.font = viewFont3;
    jieshaolabel1.text = @"业务介绍";
    [bgView2 addSubview:jieshaolabel1];
    
    //
    //    //上门收货
    UIButton *homeReceiveBtn = [[UIButton alloc] initWithFrame: CGRectMake(9, 30, 149, 60)];
    [homeReceiveBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]] forState:UIControlStateNormal];
    [homeReceiveBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
    [homeReceiveBtn addTarget:self
                       action:@selector(homeReceiveBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:homeReceiveBtn];
    
    UIImageView *homeReceiveView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 24, 20)];
    homeReceiveView.image = [UIImage imageNamed:@"sy_huoche"];
    [homeReceiveBtn addSubview:homeReceiveView];
    
    UILabel *homeReceivelabel1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 36)];
    homeReceivelabel1.backgroundColor = [UIColor clearColor];
    homeReceivelabel1.textColor = fontColor;
    homeReceivelabel1.textAlignment = NSTextAlignmentLeft;
    homeReceivelabel1.lineBreakMode = NSLineBreakByWordWrapping;
    homeReceivelabel1.numberOfLines = 0;
    homeReceivelabel1.font = viewFont2;
    homeReceivelabel1.text = @"上门收货";
    [homeReceiveBtn addSubview:homeReceivelabel1];
    
    UILabel *homeReceivelabel2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 20)];
    homeReceivelabel2.backgroundColor = [UIColor clearColor];
    homeReceivelabel2.textColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    homeReceivelabel2.textAlignment = NSTextAlignmentLeft;
    homeReceivelabel2.lineBreakMode = NSLineBreakByWordWrapping;
    homeReceivelabel2.numberOfLines = 0;
    homeReceivelabel2.font = viewFont3;
    homeReceivelabel2.text = @"殷切服务,经济选择";
    [homeReceiveBtn addSubview:homeReceivelabel2];
    
    
    //  送货上门
    UIButton *homeDeliveryBtn = [[UIButton alloc] initWithFrame: CGRectMake(160, 30, 149, 60)];
    [homeDeliveryBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]] forState:UIControlStateNormal];
    [homeDeliveryBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
    [homeDeliveryBtn addTarget:self
                        action:@selector(homeDeliveryBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:homeDeliveryBtn];
    
    UIImageView *homeDeliveryView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 20, 32, 19)];
    homeDeliveryView.image = [UIImage imageNamed:@"sy_songhuoshangmen"];
    [homeDeliveryBtn addSubview:homeDeliveryView];
    
    UILabel *homeDeliverylabel1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 36)];
    homeDeliverylabel1.backgroundColor = [UIColor clearColor];
    homeDeliverylabel1.textColor = fontColor;
    homeDeliverylabel1.textAlignment = NSTextAlignmentLeft;
    homeDeliverylabel1.lineBreakMode = NSLineBreakByWordWrapping;
    homeDeliverylabel1.numberOfLines = 0;
    homeDeliverylabel1.font = viewFont2;
    homeDeliverylabel1.text = @"送货上门";
    [homeDeliveryBtn addSubview:homeDeliverylabel1];
    
    UILabel *homeDeliverylabel2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 20)];
    homeDeliverylabel2.backgroundColor = [UIColor clearColor];
    homeDeliverylabel2.textColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    homeDeliverylabel2.textAlignment = NSTextAlignmentLeft;
    homeDeliverylabel2.lineBreakMode = NSLineBreakByWordWrapping;
    homeDeliverylabel2.numberOfLines = 0;
    homeDeliverylabel2.font = viewFont3;
    homeDeliverylabel2.text = @"减去不必要的麻烦";
    [homeDeliveryBtn addSubview:homeDeliverylabel2];
    
    //闪电回单
    UIButton *nextDayBtn = [[UIButton alloc] initWithFrame: CGRectMake(9, 92, 149, 60)];
    [nextDayBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]] forState:UIControlStateNormal];
    [nextDayBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
    [nextDayBtn addTarget:self
                   action:@selector(nextDayBtnClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:nextDayBtn];
    
    UIImageView *nextDayView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 17, 20, 30)];
    nextDayView.image = [UIImage imageNamed:@"sy_dianzihuidan"];
    [nextDayBtn addSubview:nextDayView];
    
    UILabel *nextDaylabel1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 36)];
    nextDaylabel1.backgroundColor = [UIColor clearColor];
    nextDaylabel1.textColor = fontColor;
    nextDaylabel1.textAlignment = NSTextAlignmentLeft;
    nextDaylabel1.lineBreakMode = NSLineBreakByWordWrapping;
    nextDaylabel1.numberOfLines = 0;
    nextDaylabel1.font = viewFont2;
    nextDaylabel1.text = @"闪电回单";
    [nextDayBtn addSubview:nextDaylabel1];
    
    UILabel *nextDaylabel2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 20)];
    nextDaylabel2.backgroundColor = [UIColor clearColor];
    nextDaylabel2.textColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    nextDaylabel2.textAlignment = NSTextAlignmentLeft;
    nextDaylabel2.lineBreakMode = NSLineBreakByWordWrapping;
    nextDaylabel2.numberOfLines = 0;
    nextDaylabel2.font = viewFont3;
    nextDaylabel2.text = @"对方收货后回单";
    [nextDayBtn addSubview:nextDaylabel2];
    //
    //    // 代收款提现
    UIButton *withdrawBtn = [[UIButton alloc] initWithFrame: CGRectMake(160, 92, 149, 60)];
    [withdrawBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]] forState:UIControlStateNormal];
    [withdrawBtn setBackgroundImage:[UIImage imageWithColor:bgViewColor] forState:UIControlStateHighlighted];
    
    [withdrawBtn addTarget:self
                    action:@selector(withdrawBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:withdrawBtn];
    
    UIImageView *withdrawView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 17, 27, 27)];
    withdrawView.image = [UIImage imageNamed:@"sy_daishoukuantixian"];
    [withdrawBtn addSubview:withdrawView];
    
    UILabel *withdrawlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 100, 36)];
    withdrawlabel1.backgroundColor = [UIColor clearColor];
    withdrawlabel1.textColor = fontColor;
    withdrawlabel1.textAlignment = NSTextAlignmentLeft;
    withdrawlabel1.lineBreakMode = NSLineBreakByWordWrapping;
    withdrawlabel1.numberOfLines = 0;
    withdrawlabel1.font = viewFont2;
    withdrawlabel1.text = @"代收款提现";
    [withdrawBtn addSubview:withdrawlabel1];
    
    UILabel *withdrawlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 20)];
    withdrawlabel2.backgroundColor = [UIColor clearColor];
    withdrawlabel2.textColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    withdrawlabel2.textAlignment = NSTextAlignmentLeft;
    withdrawlabel2.lineBreakMode = NSLineBreakByWordWrapping;
    withdrawlabel2.numberOfLines = 0;
    withdrawlabel2.font = viewFont3;
    withdrawlabel2.text = @"提升您的资金流动";
    [withdrawBtn addSubview:withdrawlabel2];
    
    
    
}

/**
 *  @author 徐杨
 *
 *  电话点击事件
 *
 *  @param sender
 */
- (void)phoneBtnClick:(id)sender
{
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:@"02866000100"]]];
}

/**
 *  @author 徐杨
 *
 *  扫码点击事件
 *
 *  @param sender
 */
- (void)scanBtnClick:(id)sender
{
    NSLog(@"扫码");
    //     [[BeforeScanSingleton shareScan] ShowSelectedType:QQStyle WithViewController:self];
    SaoMaViewController *vc = [[SaoMaViewController alloc] init];
    vc.mydelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  代收款点击事件
 *
 *  @param sender
 */
- (void)receiptsBtnClick:(id)sender
{
    NSLog(@"代收款");
    CollectingViewController *vc = [[CollectingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  订单点击事件
 *
 *  @param sender
 */
- (void)orderBtnClick:(id)sender
{
    NSLog(@"订单");
    OrdersViewController *vc = [[OrdersViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  收货点击事件
 *
 *  @param sender
 */
- (void)ReceivBtnClick:(id)sender
{
    NSLog(@"收货");
    ShouHuoJiluViewController *vc = [[ShouHuoJiluViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  回单点击事件
 *
 *  @param sender <#sender description#>
 */
- (void)receiptBtnClick:(id)sender
{
    NSLog(@"回单");
    //    [UIAlertView showAlert:@"正在开发中..." cancelButton:@"知道了"];
    ReceiptViewController *vc = [[ReceiptViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  理赔点击事件
 *
 *  @param sender
 */
- (void)settlementBtnClick:(id)sender
{
    NSLog(@"理赔");
    ClaimsViewController *vc = [[ClaimsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  投诉点击事件
 *
 *  @param sender
 */
- (void)complaintBtnClick:(id)sender
{
    NSLog(@"投诉");
    ComplaintViewController *vc = [[ComplaintViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  统计点击事件
 *
 *  @param sender
 */
- (void)statisticsBtnClick:(id)sender
{
    NSLog(@"统计");
    [UIAlertView showAlert:@"正在开发中..." cancelButton:@"知道了"];
    //    StatisticsViewController *vc = [[StatisticsViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  消息点击事件
 *
 *  @param sender
 */
- (void)messageBtnClick:(id)sender
{
    NSLog(@"消息");
    [UIAlertView showAlert:@"正在开发中..." cancelButton:@"知道了"];
    //    MyMessageViewController *vc = [[MyMessageViewController alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 徐杨
 *
 *  领奖点击事件
 *
 *  @param sender
 */
- (void)podiumBtnClick:(id)sender
{
    NSLog(@"领奖");
    [UIAlertView showAlert:@"正在开发中..." cancelButton:@"知道了"];
}

/**
 *  @author 徐杨
 *
 *  人人有礼点击事件
 *
 *  @param sender
 */
- (void)presentBtnClick:(id)sender
{
    NSLog(@"人人有礼");
    [UIAlertView showAlert:@"正在开发中..." cancelButton:@"知道了"];
}

/**
 *  @author 徐杨
 *
 *  上门收货点击事件
 *
 *  @param sender
 */
- (void)homeReceiveBtnClick:(id)sender
{
    NSLog(@"上门收货");
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"上门收货";
    vc.webURL = [NSString stringWithFormat:@"%@",milkRunURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
}

/**
 *  @author 徐杨
 *
 *  送货上门点击事件
 *
 *  @param sender
 */
- (void)homeDeliveryBtnClick:(id)sender
{
    NSLog(@"送货上门");
    
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"送货上门";
    vc.webURL = [NSString stringWithFormat:@"%@",goodsURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  @author 徐杨
 *
 *  次日达点击事件
 *
 *  @param sender
 */
- (void)nextDayBtnClick:(id)sender
{
    NSLog(@"闪电回单");
    
    
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"闪电回单";
    vc.webURL = [NSString stringWithFormat:@"%@",nextDayURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
}

/**
 *  @author 徐杨
 *
 *  代收款提现点击事件
 *
 *  @param sender
 */
- (void)withdrawBtnClick:(id)sender
{
    NSLog(@"代收款提现");
    
    
    YLLWebViewController *vc = [[YLLWebViewController alloc] init];
    vc.webTitle = @"代收款提现";
    vc.webURL = [NSString stringWithFormat:@"%@",withdrawalsURL];
    YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)xianluBtnClick:(id)sender
{
    NSLog(@"线路查询");
       XianLuShengViewController *vc = [[XianLuShengViewController alloc] init];
    YLLWhiteNavViewController *nav = [[YLLWhiteNavViewController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}


/**
 *  @author 徐杨
 *
 *  键盘事件
 *
 *  @param textField
 *
 *  @return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请输入运单号"];
    }
    else
    {
        YLLWebViewController *vc = [[YLLWebViewController alloc] init];
        vc.webTitle = @"运单跟踪";
        vc.webURL = [NSString stringWithFormat:@"%@?waybillNum=%@&type=1",waybillDetailsURL,[textField.text URLEncodedString]];
        YLLNavigationController *nav = [[YLLNavigationController alloc] initWithRootViewController:vc];
        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }
    [textField resignFirstResponder];
    return YES;
}

//- (void)weimendianTap:(UITapGestureRecognizer*)tapGr
//{
//    NSLog(@"拨打电话");
//    ((YLLTabBarController *)self.view.window.rootViewController).selectedIndex = 2;
//    
//}
@end
