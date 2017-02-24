//
//  SettingViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
    
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - 20 )];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgViewColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    if (IsIOS7)
        _tableView.separatorInset = UIEdgeInsetsZero;
    
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    if (indexPath.section==1&&indexPath.row==3)
    {
        return 90;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 100*APP_DELEGATE().autoSizeScaleX, 40)];
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.textColor = fontColor;
    namelabel.textAlignment = NSTextAlignmentLeft;
    namelabel.lineBreakMode = NSLineBreakByWordWrapping;
    namelabel.numberOfLines = 0;
    namelabel.font = viewFont1;
    namelabel.text = @"";
    [cell.contentView addSubview:namelabel];
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 39, 290*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];

    if (indexPath.row==0)
    {
        namelabel.text = @"意见反馈";
    }
    else  if (indexPath.row==1)
    {
        namelabel.text = @"清除缓存";
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        UILabel *sizelabel = [[UILabel alloc] initWithFrame:CGRectMake(185*APP_DELEGATE().autoSizeScaleX, 0, 100*APP_DELEGATE().autoSizeScaleX, 40)];
        sizelabel.backgroundColor = [UIColor clearColor];
        sizelabel.textColor = fontColor;
        sizelabel.textAlignment = NSTextAlignmentRight;
        sizelabel.lineBreakMode = NSLineBreakByWordWrapping;
        sizelabel.numberOfLines = 0;
        sizelabel.font = viewFont1;
        
        sizelabel.text = [NSString stringWithFormat:@"%0.2fMB",[self folderSizeAtPath:cachPath]];
        [cell.contentView addSubview:sizelabel];
        if([self folderSizeAtPath:cachPath]<0.01)
        {
            sizelabel.hidden = YES;
        }
    }
    else  if (indexPath.row==2)
    {
       fgx.hidden = YES;
        namelabel.text = @"关于系统";
    }
    else  if (indexPath.row==3)
    {
        fgx.hidden = YES;
        namelabel.hidden = YES;
        cell.backgroundColor = bgViewColor;
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35*APP_DELEGATE().autoSizeScaleX, 20, 250*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
        [submitBtn setTitle:@"退出系统" forState:UIControlStateNormal];
        [submitBtn setTitle:@"退出系统" forState:UIControlStateHighlighted];
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
    
//    if (indexPath.section==0&&indexPath.row==0)
//    {
//        NSLog(@"设置支付密码");
//        SetPayPassWordViewController *vc =[[SetPayPassWordViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else  if (indexPath.section==0&&indexPath.row==1)
//    {
//        NSLog(@"修改支付密码");
//        UpdatePassWordViewController *vc =[[UpdatePassWordViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    if (indexPath.row==0)
    {
        NSLog(@"意见反馈");
        FeedbackViewController *vc =[[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
       
    }
    else  if (indexPath.row==1)
    {
        NSLog(@"清除缓存");
        [UIAlertView showAlert:@"确认清除缓存吗？" delegate:self cancelButton:@"取消" otherButton:@"确定" tag:2];
            }
    else  if (indexPath.row==2)
    {
           NSLog(@"关于系统");
        AboutViewController *vc =[[AboutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    [UIAlertView showAlert:@"是否确认并且退出系统？" delegate:self cancelButton:@"取消" otherButton:@"退出系统" tag:1];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            NSLog(@"退出");
            
//            dispatch_queue_t queue = dispatch_queue_create("gcdtest.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);
//            dispatch_async(queue, ^{
//                //清空保存的token等数据
//                NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
//                for (int i = 0; i < [cookies count]; i++)
//                {
//                    NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
//                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//                    
//                }
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUser];
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];
//                
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCookie];
//            });
//            dispatch_async(queue, ^{
//                APP_DELEGATE().tabBarVc.selectedIndex = 0;
//            });
//            dispatch_barrier_async(queue, ^{
//                NSLog(@"dispatch_barrier_async");
//                [NSThread sleepForTimeInterval:4];
//                
//            });

            NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
            //            [MBProgressHUD showMessag:@"" toView:self.view];
            
            [helper Post:loginOutURL Parameters:nil Success:^(id responseObject)
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
                     
                     
                 }
                 else
                 {
                     //                     [MBProgressHUD showError:((response *)obj.responses[0]).message toView:self.view];
                 }
                 
                 
                 NSLog(@"%@",responseObject);
             } Failure:^(NSError *error)
             {
                 NSLog(@"%@",error);
                 //                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 //                 [MBProgressHUD showError:@"退出失败,网络异常" toView:self.view];
             }];
            
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
            


            
            
            
        }
        else
        {
            NSLog(@"取消");
        }
    }
    else
    {
        if (buttonIndex==1)
        {
            NSLog(@"删除");
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            [self clearCache:cachPath];
            [_tableView reloadData];

        }
        else
        {
            NSLog(@"取消");
        }
    }
    
    
}

-(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        　//SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}
@end
