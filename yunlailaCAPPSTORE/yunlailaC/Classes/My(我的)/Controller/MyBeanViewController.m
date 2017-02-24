//
//  MyBeanViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "MyBeanViewController.h"
#import "CouponViewController.h"
#import "BeanListViewController.h"
@interface MyBeanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@end

@implementation MyBeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的运输豆";
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
    return 3;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
//    headView.backgroundColor = bgViewColor;
//    return headView;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    headView.backgroundColor = bgViewColor;
    headView.userInteractionEnabled = YES;
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, 10, 250, 30)];
    [submitBtn setTitle:@"运输豆使用说明" forState:UIControlStateNormal];
    [submitBtn setTitle:@"运输豆使用说明" forState:UIControlStateHighlighted];
    [submitBtn setTitleColor:fontColor forState:UIControlStateNormal];
    [submitBtn setTitleColor:fontColor forState:UIControlStateHighlighted];
//    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
//    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
    [submitBtn addTarget:self
                  action:@selector(submitBtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = viewFont1;
    [headView addSubview:submitBtn];
    
    return headView;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 48;
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
    UIImageView *icon1 = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 12, 25, 25)];
    [cell.contentView addSubview:icon1];
    
    UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(55*APP_DELEGATE().autoSizeScaleX, 0, 160*APP_DELEGATE().autoSizeScaleX, 48)];
    titleLable1.numberOfLines = 0;
    titleLable1.textAlignment = NSTextAlignmentLeft;
    titleLable1.font = viewFont1;
    titleLable1.textColor = fontColor;
    titleLable1.text = @"";
    [cell.contentView addSubview:titleLable1];
    
    
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        fgx.hidden = YES;
        icon1.hidden = YES;
        titleLable1.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = titleViewColor;
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320*APP_DELEGATE().autoSizeScaleX, 48)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentCenter;
        titleLable1.font = titleFont1;
        titleLable1.textColor = [UIColor whiteColor];
        NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        
        titleLable1.text = [NSString stringWithFormat:@"%@颗",[userInfo objectForKey:@"bean_num"]];
        [cell.contentView addSubview:titleLable1];
        [cell.contentView addSubview:titleLable1];
        
    }
    else  if(indexPath.section==0&&indexPath.row==1)
    {
        icon1.image = [UIImage imageNamed:@"duihuan_youhuiquan"];
        titleLable1.text = @"兑换优惠券";
        
    }
    else  if(indexPath.section==0&&indexPath.row==2)
    {
        icon1.image = [UIImage imageNamed:@"mingxi"];
        titleLable1.text = @"豆豆明细";
        fgx.hidden = YES;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0&&indexPath.row==1)
    {
        NSLog(@"兑换优惠券");
        CouponViewController *vc = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
       
        //如果有银行卡  管理
    }
    else  if(indexPath.section==0&&indexPath.row==2)
    {
        NSLog(@"豆豆明细");
        BeanListViewController *vc =[[BeanListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    
}
@end
