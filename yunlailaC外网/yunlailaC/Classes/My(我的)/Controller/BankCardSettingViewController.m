
//
//  BankCardSettingViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "BankCardSettingViewController.h"

@interface BankCardSettingViewController ()<UITextFieldDelegate>
{
    UITextField *danbiText;
    UITextField *meiriText;
}
@end

@implementation BankCardSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"管理银行卡";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    UIView *colorView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 22, 2, 16)];
    colorView1.backgroundColor = titleViewColor;
    [self.view addSubview:colorView1];
    
    UILabel *desclabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    desclabel1.backgroundColor = [UIColor clearColor];
    desclabel1.textColor = [UIColor blackColor];
    desclabel1.textAlignment = NSTextAlignmentLeft;
    desclabel1.lineBreakMode = NSLineBreakByWordWrapping;
    desclabel1.numberOfLines = 0;
    desclabel1.font = viewFont1;
    desclabel1.text = @"单笔限额";
    [self.view addSubview:desclabel1];
    
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 30)];
    bg1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg1];

    UILabel *desclabel11 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    desclabel11.backgroundColor = [UIColor clearColor];
    desclabel11.textColor = [UIColor blackColor];
    desclabel11.textAlignment = NSTextAlignmentLeft;
    desclabel11.lineBreakMode = NSLineBreakByWordWrapping;
    desclabel11.numberOfLines = 0;
    desclabel11.font = viewFont1;
    desclabel11.text = @"实物类商品";
    [bg1 addSubview:desclabel11];
    
    danbiText = [[UITextField alloc] init];
    danbiText.clearButtonMode = UITextFieldViewModeWhileEditing;
    danbiText.borderStyle = UITextBorderStyleNone;
    danbiText.frame = CGRectMake(100, 0, 200, 30);
    danbiText.textAlignment = NSTextAlignmentRight;
    danbiText.delegate = self;
    danbiText.placeholder = @"单笔限额";
    danbiText.keyboardType = UIKeyboardTypeNumberPad;
    danbiText.returnKeyType = UIReturnKeyDone;
    danbiText.font = viewFont1;
    [bg1 addSubview:danbiText];

    
    
    
    
    
    UIView *colorView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 92, 2, 16)];
    colorView2.backgroundColor = titleViewColor;
    [self.view addSubview:colorView2];
    
    UILabel *desclabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, 100, 20)];
    desclabel2.backgroundColor = [UIColor clearColor];
    desclabel2.textColor = [UIColor blackColor];
    desclabel2.textAlignment = NSTextAlignmentLeft;
    desclabel2.lineBreakMode = NSLineBreakByWordWrapping;
    desclabel2.numberOfLines = 0;
    desclabel2.font = viewFont1;
    desclabel2.text = @"每日限额";
    [self.view addSubview:desclabel2];
    
    UIView *bg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 320, 30)];
    bg2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bg2];
    
    UILabel *desclabel22 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    desclabel22.backgroundColor = [UIColor clearColor];
    desclabel22.textColor = [UIColor blackColor];
    desclabel22.textAlignment = NSTextAlignmentLeft;
    desclabel22.lineBreakMode = NSLineBreakByWordWrapping;
    desclabel22.numberOfLines = 0;
    desclabel22.font = viewFont1;
    desclabel22.text = @"实物类商品";
    [bg2 addSubview:desclabel22];
    
    meiriText = [[UITextField alloc] init];
    meiriText.clearButtonMode = UITextFieldViewModeWhileEditing;
    meiriText.borderStyle = UITextBorderStyleNone;
    meiriText.frame = CGRectMake(100, 0, 200, 30);
    meiriText.textAlignment = NSTextAlignmentRight;
    meiriText.delegate = self;
    meiriText.placeholder = @"每日限额";
    meiriText.keyboardType = UIKeyboardTypeNumberPad;
    meiriText.returnKeyType = UIReturnKeyDone;
    meiriText.font = viewFont1;
    [bg2 addSubview:meiriText];

}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
