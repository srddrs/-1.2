//
//  UserInfoViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "UserInfoViewController.h"
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    UIImageView *headView;
    UILabel *userNameLabel;
    UILabel *userPhoneLabel;
    UILabel *userTagLabel;
}
@end

@implementation UserInfoViewController
@synthesize userInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
    
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)postUserInfo:(NSDictionary *)userInfo1;
{
    self.userInfo = userInfo1;
    NSLog(@"11111");
    [_tableView reloadData];
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
//    if (section == 0)
//    {
//        return 1;
//    }
//    else
//    {
//        return 3;
//    }
  
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section==0)
//    {
//        return 0;
//    }
//    return 10;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section==0)
//    {
//        return nil;
//    }
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
//    headerView.backgroundColor = bgViewColor;
//    return headerView;
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section==0)
//    {
//        return 90;
//    }
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
    
//    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 43, 290*APP_DELEGATE().autoSizeScaleX, 1)];
//    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
//    [cell.contentView addSubview:fgx];
    
//    if (indexPath.section==0&&indexPath.row==0)
//    {
//        namelabel.frame = CGRectMake(15, 0, 100, 90);
//        namelabel.text = @"头像";
//        fgx.hidden = YES;
//        
//        headView = [[UIImageView alloc] initWithFrame:CGRectMake(220*APP_DELEGATE().autoSizeScaleX, 10, 70, 70)];
//        headView.layer.masksToBounds = YES;
//        headView.layer.cornerRadius = 10;
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",@"1111"]];
//        [headView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default"]];
//        [cell.contentView addSubview:headView];
//    }
//    else if (indexPath.section==1&&indexPath.row==0)
    if (indexPath.section==0&&indexPath.row==0)
    {
        namelabel.text = @"名字";
        if (!userNameLabel)
        {
            userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX,0 ,200*APP_DELEGATE().autoSizeScaleX , 40)];
            userNameLabel.backgroundColor = [UIColor clearColor];
            userNameLabel.textColor = fontColor;
            userNameLabel.text = @"未填写";
            userNameLabel.textAlignment = NSTextAlignmentRight;
            userNameLabel.font = viewFont1;
            userNameLabel.numberOfLines = 0;
            if ([[userInfo objectForKey:@"nick_name"] length]>0)
            {
                userNameLabel.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"nick_name"]];
            }
            else
            {
                userNameLabel.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"real_name"]];
            }

        }
        
        [cell.contentView addSubview:userNameLabel];
    }
//    else if (indexPath.section==1&&indexPath.row==1)
//    {
//        namelabel.text = @"电话";
//        if (!userPhoneLabel)
//        {
//            userPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX,0 ,200*APP_DELEGATE().autoSizeScaleX , 40)];
//            userPhoneLabel.backgroundColor = [UIColor clearColor];
//            userPhoneLabel.textColor = fontColor;
//            userPhoneLabel.text = @"未填写";
//            userPhoneLabel.textAlignment = NSTextAlignmentRight;
//            userPhoneLabel.font = viewFont1;
//            userPhoneLabel.numberOfLines = 0;
//        }
//        [cell.contentView addSubview:userPhoneLabel];
//    }
//    else if (indexPath.section==1&&indexPath.row==2)
//    {
//        namelabel.text = @"爱好";
//        fgx.hidden = YES;
//        if (!userTagLabel)
//        {
//            userTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX,0 ,200*APP_DELEGATE().autoSizeScaleX , 40)];
//            userTagLabel.backgroundColor = [UIColor clearColor];
//            userTagLabel.textColor = fontColor;
//            userTagLabel.text = @"未填写";
//            userTagLabel.textAlignment = NSTextAlignmentRight;
//            userTagLabel.font = viewFont1;
//            userTagLabel.numberOfLines = 0;
//        }
//        [cell.contentView addSubview:userTagLabel];
//    }
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section==0&&indexPath.row==0)
//    {
//        NSLog(@"头像");
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
//        [actionSheet addButtonWithTitle:@"拍照"];
//        [actionSheet addButtonWithTitle:@"从相册选择"];
//        [actionSheet addButtonWithTitle:@"取消"];
//        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
//        actionSheet.tag = 999;
//        actionSheet.delegate = self;
//        [actionSheet showInView:self.view];
//    }
//    else if (indexPath.section==1&&indexPath.row==0)
   if (indexPath.section==0&&indexPath.row==0)
    {
        NSLog(@"名字");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改名字"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"修改",nil];
        alert.tag = 1;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];


    }
//    else if (indexPath.section==1&&indexPath.row==1)
//    {
//        NSLog(@"电话");
//    }
//    else if (indexPath.section==1&&indexPath.row==2)
//    {
//        NSLog(@"爱好");
//
//
//    }
    
}



-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        UITextField *tf=[alertView textFieldAtIndex:0];
        if (alertView.tag==1)
        {
            if (tf.text.length>0&&tf.text.length<=5)
            {
                NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
                
                [MBProgressHUD showMessag:@"" toView:self.view];
                NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 @"hex_client_member_update_information",@"funcId",
                                                 @"2016-01-01",@"birthday",
                                                 tf.text,@"nick_name",
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
                         [MBProgressHUD showSuccess:@"修改名字成功" toView:self.view];
                         userNameLabel.text = tf.text;
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
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [MBProgressHUD showError:@"修改名字失败" toView:self.view];
                 }];

                
            }
            else
            {
                [MBProgressHUD showAutoMessage:@"昵称最多5位"];
            }
        }
        
        
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.delegate = self;
    if(buttonIndex==0)
    {
        BOOL cameraAvailable = [UIImagePickerController isCameraDeviceAvailable:
                                UIImagePickerControllerCameraDeviceRear];
        
        if (cameraAvailable==YES) {
            pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickVC animated:YES completion:^{
                
            }];
        }
        else
        {
            [UIAlertView showAlert:@"沒有摄像头" cancelButton:@"知道了"];
        }
        
    }
    else if(buttonIndex==1)
    {
        pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickVC animated:YES completion:^{
            
        }];
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation=image.imageOrientation;
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        headView.image = image;
        // 调整图片角度完毕
        //        }
        [picker dismissViewControllerAnimated:NO completion:^{
            
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];   // 保存文件的名称
            [imageData writeToFile:filePath atomically:YES];
            
//            NSMutableDictionary *paramDic1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                              filePath,@"file",
//                                              nil];
//            
//            [self createRequest:uploadURL param:paramDic1 withRequestType:uploadType];
            
        }];
    }
    
    
}

@end
