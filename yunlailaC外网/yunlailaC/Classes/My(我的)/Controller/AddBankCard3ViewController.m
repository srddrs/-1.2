//
//  AddBankCard3ViewController.m
//  yunlailaC
//
//  Created by admin on 16/9/2.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AddBankCard3ViewController.h"

@interface AddBankCard3ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_tableView;
    UITextField *shenfenzhengText;  //身份证
    UITextField *xingmingText; //姓名
    UITextField *yinhangkaText; //银行卡
    
    UIButton *photoBtn1;
    UIButton *photoBtn2;
    UIButton *photoBtn3;
    
    UIImageView *photoView1;
    UIImageView *photoView2;
    UIImageView *photoView3;
    
    NSString *photoViewURL1;
    NSString *photoViewURL2;
    NSString *photoViewURL3;
    
    UIButton *agreeBtn;
}

@end

@implementation AddBankCard3ViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    self.title = @"添加银行卡(他人)";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
}

- (void) initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-TabbarHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else if(section==1)
    {
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section!=2)
    {
        return 25;
    }
    else
    {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        headView.backgroundColor = bgViewColor;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 7, 11, 11)];
        icon.image = [UIImage imageNamed:@"smrz_tixing@2x"];
        [headView addSubview:icon];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX + 20, 0, 290*APP_DELEGATE().autoSizeScaleX, 25)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont4;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"温馨提示：个人实名认证后一经认证无法修改。";
        [headView addSubview:titleLable1];
        
        
        return headView;
    }
    else if (section==1)
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        headView.backgroundColor = bgViewColor;
        
        
        UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 0, 290*APP_DELEGATE().autoSizeScaleX, 25)];
        titleLable2.numberOfLines = 0;
        titleLable2.textAlignment = NSTextAlignmentLeft;
        titleLable2.font = viewFont4;
        titleLable2.textColor = fontColor;
        titleLable2.text = @"实例：请按提示上传图片";
        [headView addSubview:titleLable2];
        
        return headView;
    }
    else
    {
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 100*APP_DELEGATE().autoSizeScaleY;
    }
    else if (indexPath.section==1)
    {
        return 125*APP_DELEGATE().autoSizeScaleY;
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row==3)
        {
            return 125*APP_DELEGATE().autoSizeScaleY;
        }
        return 44*APP_DELEGATE().autoSizeScaleY;
    }
    else
    {
        return 44;
    }
    
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
    
    
    
    
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        UIImageView *infoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DELEGATE().autoSizeScaleX, 100*APP_DELEGATE().autoSizeScaleY)];
        infoView.image = [UIImage imageNamed:@"smrz_shili"];
        [cell.contentView addSubview:infoView];
    }
    
    if(indexPath.section==1&&indexPath.row==0)
    {
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0*APP_DELEGATE().autoSizeScaleX, 15, 107*APP_DELEGATE().autoSizeScaleX, 25)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = viewFont4;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"身份证正面";
        [cell.contentView addSubview:titleLable1];
        
        UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(107*APP_DELEGATE().autoSizeScaleX, 15, 107*APP_DELEGATE().autoSizeScaleX, 25)];
        titleLable2.numberOfLines = 0;
        titleLable2.textAlignment = NSTextAlignmentCenter;
        titleLable2.font = viewFont4;
        titleLable2.textColor = fontColor;
        titleLable2.text = @"身份证反面";
        [cell.contentView addSubview:titleLable2];
        
        UILabel *titleLable3 = [[UILabel alloc] initWithFrame:CGRectMake(214*APP_DELEGATE().autoSizeScaleX, 15, 107*APP_DELEGATE().autoSizeScaleX, 25)];
        titleLable3.numberOfLines = 0;
        titleLable3.textAlignment = NSTextAlignmentCenter;
        titleLable3.font = viewFont4;
        titleLable3.textColor = fontColor;
        titleLable3.text = @"手持身份证";
        [cell.contentView addSubview:titleLable3];
        
        
        if (!photoView1)
        {
            photoView1 = [[UIImageView alloc] initWithFrame:CGRectMake((107-60)/2*APP_DELEGATE().autoSizeScaleX, 50, 60*APP_DELEGATE().autoSizeScaleX, 60*APP_DELEGATE().autoSizeScaleX)];
            
            photoView1.image = [UIImage imageNamed:@"smrz_tianjia"];
            photoView1.userInteractionEnabled = YES;
            photoBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60*APP_DELEGATE().autoSizeScaleX, 60*APP_DELEGATE().autoSizeScaleX)];
            [photoBtn1 addTarget:self
                          action:@selector(photoBtn1Click:)
                forControlEvents:UIControlEventTouchUpInside];
            [photoView1 addSubview:photoBtn1];
        }
        
        [cell.contentView addSubview:photoView1];
        
        if (!photoView2)
        {
            photoView2 = [[UIImageView alloc] initWithFrame:CGRectMake((321-60)/2*APP_DELEGATE().autoSizeScaleX, 50, 60*APP_DELEGATE().autoSizeScaleX, 60*APP_DELEGATE().autoSizeScaleX)];
            photoView2.userInteractionEnabled = YES;
            photoView2.image = [UIImage imageNamed:@"smrz_tianjia"];
            
            photoBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60*APP_DELEGATE().autoSizeScaleX, 60*APP_DELEGATE().autoSizeScaleX)];
            [photoBtn2 addTarget:self
                          action:@selector(photoBtn2Click:)
                forControlEvents:UIControlEventTouchUpInside];
            [photoView2 addSubview:photoBtn2];
        }
        
        [cell.contentView addSubview:photoView2];
        
        if (!photoView3)
        {
            photoView3 = [[UIImageView alloc] initWithFrame:CGRectMake((535-60)/2*APP_DELEGATE().autoSizeScaleX, 50, 60*APP_DELEGATE().autoSizeScaleX, 60*APP_DELEGATE().autoSizeScaleX)];
            photoView3.userInteractionEnabled = YES;
            photoView3.image = [UIImage imageNamed:@"smrz_tianjia"];
            
            photoBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60*APP_DELEGATE().autoSizeScaleX, 60*APP_DELEGATE().autoSizeScaleX)];
            [photoBtn3 addTarget:self
                          action:@selector(photoBtn3Click:)
                forControlEvents:UIControlEventTouchUpInside];
            [photoView3 addSubview:photoBtn3];
        }
        
        [cell.contentView addSubview:photoView3];
        
    }
    if(indexPath.section==2&&indexPath.row==0)
    {
        UIImageView *xingmingView = [[UIImageView alloc] initWithFrame:CGRectMake(9*APP_DELEGATE().autoSizeScaleX, 3*APP_DELEGATE().autoSizeScaleY, 303*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY)];
        xingmingView.userInteractionEnabled = YES;
        xingmingView.image  = [UIImage imageNamed:@"smrz_juxing"];
        [cell.contentView addSubview:xingmingView];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = viewFont2;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"姓名";
        [xingmingView addSubview:titleLable1];
        
        if (!xingmingText)
        {
            xingmingText = [[UITextField alloc] init];
            xingmingText.clearButtonMode = UITextFieldViewModeWhileEditing;
            xingmingText.borderStyle = UITextBorderStyleNone;
            xingmingText.frame = CGRectMake(75*APP_DELEGATE().autoSizeScaleX, 0, 228*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY);
            xingmingText.delegate = self;
            xingmingText.placeholder = @"请输入姓名";
            xingmingText.returnKeyType = UIReturnKeyDone;
            xingmingText.keyboardType = UIKeyboardTypeDefault;
            xingmingText.font = viewFont2;
            xingmingText.textColor = fontColor;
            xingmingText.text = @"";
            
        }
        [xingmingView addSubview:xingmingText];
    }
    else if(indexPath.section==2&&indexPath.row==1)
    {
        UIImageView *shenfenzhengView = [[UIImageView alloc] initWithFrame:CGRectMake(9*APP_DELEGATE().autoSizeScaleX, 3*APP_DELEGATE().autoSizeScaleY, 303*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY)];
        shenfenzhengView.userInteractionEnabled = YES;
        shenfenzhengView.image  = [UIImage imageNamed:@"smrz_juxing"];
        [cell.contentView addSubview:shenfenzhengView];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = viewFont2;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"身份证号码";
        [shenfenzhengView addSubview:titleLable1];
        
        if (!shenfenzhengText)
        {
            shenfenzhengText = [[UITextField alloc] init];
            shenfenzhengText.clearButtonMode = UITextFieldViewModeWhileEditing;
            shenfenzhengText.borderStyle = UITextBorderStyleNone;
            shenfenzhengText.frame = CGRectMake(75*APP_DELEGATE().autoSizeScaleX, 0, 228*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY);
            shenfenzhengText.delegate = self;
            shenfenzhengText.placeholder = @"请输入身份证号码";
            shenfenzhengText.returnKeyType = UIReturnKeyDone;
            shenfenzhengText.keyboardType = UIKeyboardTypePhonePad;
            shenfenzhengText.font = viewFont2;
            shenfenzhengText.textColor = fontColor;
            shenfenzhengText.text = @"";
            
        }
        [shenfenzhengView addSubview:shenfenzhengText];
        
    }
    else if(indexPath.section==2&&indexPath.row==2)
    {
        UIImageView *shenfenzhengView = [[UIImageView alloc] initWithFrame:CGRectMake(9*APP_DELEGATE().autoSizeScaleX, 3*APP_DELEGATE().autoSizeScaleY, 303*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY)];
        shenfenzhengView.userInteractionEnabled = YES;
        shenfenzhengView.image  = [UIImage imageNamed:@"smrz_juxing"];
        [cell.contentView addSubview:shenfenzhengView];
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = viewFont2;
        titleLable1.textColor = fontColor;
        titleLable1.text = @"银行卡号";
        [shenfenzhengView addSubview:titleLable1];
        
        if (!yinhangkaText)
        {
            yinhangkaText = [[UITextField alloc] init];
            yinhangkaText.clearButtonMode = UITextFieldViewModeWhileEditing;
            yinhangkaText.borderStyle = UITextBorderStyleNone;
            yinhangkaText.frame = CGRectMake(75*APP_DELEGATE().autoSizeScaleX, 0, 228*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY);
            yinhangkaText.delegate = self;
            yinhangkaText.placeholder = @"请输入银行卡号";
            yinhangkaText.returnKeyType = UIReturnKeyDone;
            yinhangkaText.keyboardType = UIKeyboardTypePhonePad;
            yinhangkaText.font = viewFont2;
            yinhangkaText.textColor = fontColor;
            yinhangkaText.text = @"";
            
        }
        [shenfenzhengView addSubview:yinhangkaText];
        
    }

    else if(indexPath.section==2&&indexPath.row==3)
    {
        
        if (!agreeBtn)
        {
            agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            agreeBtn.frame = CGRectMake(9*APP_DELEGATE().autoSizeScaleX, 10*APP_DELEGATE().autoSizeScaleY ,15*APP_DELEGATE().autoSizeScaleX, 15*APP_DELEGATE().autoSizeScaleX);
            [agreeBtn setImage:[UIImage imageNamed:@"smrz_xuanzhe"] forState:UIControlStateNormal];
            [agreeBtn setImage:[UIImage imageNamed:@"smrz_xuanzhe2"] forState:UIControlStateSelected];
            [agreeBtn addTarget:self
                         action:@selector(agreeBtnClick:)
               forControlEvents:UIControlEventTouchUpInside];
            agreeBtn.selected = YES;
        }
        [cell.contentView addSubview:agreeBtn];
        UILabel *clauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*APP_DELEGATE().autoSizeScaleX, 3*APP_DELEGATE().autoSizeScaleY, 260*APP_DELEGATE().autoSizeScaleX, 30*APP_DELEGATE().autoSizeScaleY)];
        clauseLabel.numberOfLines = 0;
        clauseLabel.textAlignment = NSTextAlignmentLeft;
        clauseLabel.font = viewFont3;
        clauseLabel.textColor = titleViewColor;
        clauseLabel.text = @"您的提交具有法律责任,请检查清楚提交";
        [cell.contentView addSubview:clauseLabel];
        
        //        cell.backgroundColor = bgViewColor;
        UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 38*APP_DELEGATE().autoSizeScaleY, 300*APP_DELEGATE().autoSizeScaleX, 34*APP_DELEGATE().autoSizeScaleY)];
        [submitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [submitBtn setTitle:@"提交审核" forState:UIControlStateHighlighted];
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

- (void)agreeBtnClick:(id)sender
{
    agreeBtn.selected = !agreeBtn.selected;
}

- (void)photoBtn1Click:(id)sender
{
    [self.view endEditing:YES];
    if ([photoViewURL1 length]==0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet addButtonWithTitle:@"拍照"];
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 11;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet addButtonWithTitle:@"看大图"];
        [actionSheet addButtonWithTitle:@"删除"];
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 21;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    
}

- (void)photoBtn2Click:(id)sender
{
    [self.view endEditing:YES];
    if ([photoViewURL2 length]==0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet addButtonWithTitle:@"拍照"];
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 12;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet addButtonWithTitle:@"看大图"];
        [actionSheet addButtonWithTitle:@"删除"];
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 22;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
}

- (void)photoBtn3Click:(id)sender
{
    [self.view endEditing:YES];
    if ([photoViewURL3 length]==0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet addButtonWithTitle:@"拍照"];
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 13;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet addButtonWithTitle:@"看大图"];
        [actionSheet addButtonWithTitle:@"删除"];
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 23;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag<20)
    {
        UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
        pickVC.delegate = self;
        if (actionSheet.tag==11)
        {
            pickVC.title = @"身份证正面拍照";
        }
        else if(actionSheet.tag==12)
        {
            pickVC.title = @"身份证反面拍照";
        }
        else if(actionSheet.tag==13)
        {
            pickVC.title = @"手持身份证拍照";
        }
        if(buttonIndex==0)
        {
            BOOL cameraAvailable = [UIImagePickerController isCameraDeviceAvailable:
                                    UIImagePickerControllerCameraDeviceRear];
            
            if (cameraAvailable==YES)
            {
                pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:pickVC animated:YES completion:^{
                    
                }];
            }
            else
            {
                [UIAlertView showAlert:@"沒有摄像头" cancelButton:@"知道了"];
            }
            
        }
        
    }
    else
    {
        if (actionSheet.tag==21)
        {
            if(buttonIndex==0)
            {
                NSLog(@"看大图");
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
                MJPhoto *photo = [[MJPhoto alloc] init];
                //                photo.image = [UIImage imageWithContentsOfFile:photoViewURL1];
                photo.url = [NSURL URLWithString:photoViewURL1];
                UIImageView *btn = photoView1;
                photo.srcImageView = btn; // 来源于哪个UIImageView
                [photos addObject:photo];
                
                // 2.显示相册
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
                browser.photos = photos; // 设置所有的图片
                [browser show];
                
            }
            else if(buttonIndex==1)
            {
                NSLog(@"删除");
                photoViewURL1 = @"";
                photoView1.image = [UIImage imageNamed:@"smrz_tianjia"];
            }
            
        }
        
        if (actionSheet.tag==22)
        {
            if(buttonIndex==0)
            {
                NSLog(@"看大图");
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
                MJPhoto *photo = [[MJPhoto alloc] init];
                //                photo.image = [UIImage imageWithContentsOfFile:photoViewURL2];
                photo.url = [NSURL URLWithString:photoViewURL2];
                UIImageView *btn = photoView2;
                photo.srcImageView = btn; // 来源于哪个UIImageView
                [photos addObject:photo];
                
                // 2.显示相册
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
                browser.photos = photos; // 设置所有的图片
                [browser show];
                
            }
            else if(buttonIndex==1)
            {
                NSLog(@"删除");
                photoViewURL2 = @"";
                photoView2.image = [UIImage imageNamed:@"smrz_tianjia"];
            }
            
        }
        
        if (actionSheet.tag==23)
        {
            if(buttonIndex==0)
            {
                NSLog(@"看大图");
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
                MJPhoto *photo = [[MJPhoto alloc] init];
                //                photo.image = [UIImage imageWithContentsOfFile:photoViewURL3];
                photo.url = [NSURL URLWithString:photoViewURL3];
                UIImageView *btn = photoView3;
                photo.srcImageView = btn; // 来源于哪个UIImageView
                [photos addObject:photo];
                
                // 2.显示相册
                MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
                browser.photos = photos; // 设置所有的图片
                [browser show];
                
            }
            else if(buttonIndex==1)
            {
                NSLog(@"删除");
                photoViewURL3 = @"";
                photoView3.image = [UIImage imageNamed:@"smrz_tianjia"];
            }
            
        }
        
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
        
        // 调整图片角度完毕
        [picker dismissViewControllerAnimated:NO completion:^{
            
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];   // 保存文件的名称
            [imageData writeToFile:filePath atomically:YES];
            
            
            
            NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
            [MBProgressHUD showMessag:@"正在上传..." toView:self.view];
            
            NSDictionary *item = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUser];
            NSString *tokenValue = [item objectForKey:@"token"];
            
            NSString *url = [NSString stringWithFormat:@"%@?token=%@&media_type=%@",file_uploadURL,tokenValue,@"jpg"];
            [helper Post:url Parameter:nil Data:imageData FieldName:@"file" FileName:fileName MimeType:@"jpg" Success:^(id responseObject)
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
                     //                    [MBProgressHUD showAutoMessage:@"提交实名认证资料成功，请耐心等待工作人员处理"];
                     if ([picker.title isEqualToString:@"身份证正面拍照"])
                     {
                         photoViewURL1 = ((response *)obj.responses[0]).message;
                         [photoView1 sd_setImageWithURL:[NSURL URLWithString:photoViewURL1]];
                     }
                     else if ([picker.title isEqualToString:@"身份证反面拍照"])
                     {
                         photoViewURL2 = ((response *)obj.responses[0]).message;
                         [photoView2 sd_setImageWithURL:[NSURL URLWithString:photoViewURL2]];
                     }
                     else if ([picker.title isEqualToString:@"手持身份证拍照"])
                     {
                         photoViewURL3 = ((response *)obj.responses[0]).message;
                         [photoView3 sd_setImageWithURL:[NSURL URLWithString:photoViewURL3]];
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
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [MBProgressHUD showError:@"上传失败,服务器异常" toView:self.view];
                 
                 
                 
             }];
            
            
        }];
    }
    
    
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    [self.view endEditing:YES];
    if ([photoViewURL1 length]==0)
    {
        [MBProgressHUD showAutoMessage:@"请拍摄身份证正面照"];
        return;
    }
    if ([photoViewURL2 length]==0)
    {
        [MBProgressHUD showAutoMessage:@"请拍摄身份证反面照"];
        return;
    }
    if ([photoViewURL3 length]==0)
    {
        [MBProgressHUD showAutoMessage:@"请拍摄手持身份证照"];
        return;
    }
    if (xingmingText.text.length==0)
    {
        [MBProgressHUD showAutoMessage:@"请填写姓名"];
        return;
    }
    if ([AppTool validateIDCardNumber:shenfenzhengText.text]==NO)
    {
        [MBProgressHUD showAutoMessage:@"请填写正确的身份证号"];
        return;
    }
//    if (yinhangkaText.text.length == 0 || [[AppTool isBankCardNum:yinhangkaText.text] isEqualToString:@"不是正确格式的银行卡"]|| [[AppTool isBankCardNum:yinhangkaText.text] isEqualToString:@"银行卡位数不正确"])
//    {
//        [MBProgressHUD showAutoMessage:@"请输入正确的银行卡号"];
//        return;
//    }
    [UIAlertView showAlert:@"是否确认并且提交？" delegate:self cancelButton:@"取消" otherButton:@"提交" tag:1];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"下一步");
        NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
        [MBProgressHUD showMessag:@"" toView:self.view];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"hex_client_bank_bindOtherBankFunction",@"funcId",
                                         shenfenzhengText.text,@"id_card",
                                         xingmingText.text,@"real_name",
                                         photoViewURL1,@"card_positive_img",
                                         photoViewURL2,@"card_back_img",
                                         photoViewURL3,@"other_img",
                                         yinhangkaText.text,@"bankcard_no",
                                         nil];
        
        [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
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
                 [MBProgressHUD showAutoMessage:@"提交银行卡(他人)信息成功，请耐心等待工作人员处理"];
                 [self dismissViewControllerAnimated:YES completion:nil];
                 //                 AddBankCard2ViewController *vc =[[AddBankCard2ViewController alloc] init];
                 //                 [self.navigationController pushViewController:vc animated:YES];
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
             [MBProgressHUD showError:@"实名认证失败" toView:self.view];
         }];
        
    }
    else
    {
        NSLog(@"取消");
    }
    
}


#pragma mark UITextField Delegate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == shenfenzhengText)
    {
        //        [self performSelector:@selector(addXButtonToKeyboard) withObject:nil afterDelay:0.1];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    //     [self removeButtonFromKeyboard];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // string.length为0，表明没有输入字符，应该是正在删除，应该返回YES。
    if (string.length == 0) {
        return YES;
    }
    // length为当前输入框中的字符长度
    NSUInteger length = textField.text.length + string.length;
    // 如果该页面中还有其他的输入框，则需要做这个判断
    if (textField == shenfenzhengText) {
        // str为当前输入框中的字符
        NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
        // 当输入到17位数的时候，通过theLastIsX方法判断最后一位是不是X
        if (length == 17 && [self theLastIsX:str]) {
            // 如果是17位，并通过前17位计算出18位为X，自动补全，并返回NO，禁止编辑。
            textField.text = [NSString stringWithFormat:@"%@%@X", textField.text, string];
            return NO;
        }
        // 如果是其他情况则直接返回小于等于18（最多输入18位）
        return length <= 18;
    }
    return YES;
}
// 判断最后一个是不是X
- (BOOL)theLastIsX:(NSString *)IDNumber {
    NSMutableArray *IDArray = [NSMutableArray array];
    for (int i = 0; i < 17; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2",  nil];
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    if (sum % 11 == 2) return YES;
    else return NO;
}
@end
