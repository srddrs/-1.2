//
//  AboutViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于系统";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    [self initView];
    [APP_DELEGATE() storyBoradAutoLay:self.view];
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initView{
    //logo
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 54, 54)];
    [logoView setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logoView];
    
    //公司
    UILabel *comLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 80, 12)];
    comLabel.text = @"托运邦货主";
    comLabel.font = viewFont1;
    comLabel.textColor = fontColor;
    [self.view addSubview:comLabel];
    
    //版本
    UILabel *vLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 85, 9)];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    vLabel.text = [NSString stringWithFormat:@"版本号:V%@",app_Version];
    vLabel.textColor = fontColor;
    vLabel.font = viewFont2;
    [self.view addSubview:vLabel];
    
    
    //正文
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 75, 290, self.view.frame.size.height - 75)];
    textView.font = viewFont1;
    textView.text = @"托运邦货主移动客户端是基于Android和iOS操作系统开发的快件管理软件，向客户提供自助下单，查件，订单管理，网店查询等便捷服务。\n\n主要功能 \n\n下单寄件：自动保存寄件人和收件人地址，常用地址寄件，一键选择。\n\n上门接货：软件下单即可上门现场开票接货\n\n查件：扫描运单条码或输入运单号查件\n\n更多托运邦货主APP功能等您来发现。。。";
    textView.editable = NO;
    textView.textColor = fontColor;
    textView.backgroundColor = bgViewColor;
    [self.view addSubview:textView];
}

@end
