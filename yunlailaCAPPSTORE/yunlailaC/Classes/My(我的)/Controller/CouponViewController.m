//
//  CouponViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "CouponViewController.h"

@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *addressArray;
}
@end

@implementation CouponViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        addressArray = [[NSMutableArray alloc] init];
        NSDictionary *threedict1 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",1] ,
                                     @"mingzi" :@"优惠券" ,
                                     @"jine" : @"20",
                                     @"miaosu" : @"运费抵扣",
                                     @"shijian" : @"2016-05-31",
                                     };
        
        NSDictionary *threedict2 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",2] ,
                                     @"mingzi" :@"优惠券" ,
                                     @"jine" : @"20",
                                     @"miaosu" : @"运费抵扣",
                                     @"shijian" : @"2016-05-31",
                                     };
        NSDictionary *threedict3 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",3] ,
                                     @"mingzi" :@"优惠券" ,
                                     @"jine" : @"20",
                                     @"miaosu" : @"运费抵扣",
                                     @"shijian" : @"2016-05-31",
                                     };
        NSDictionary *threedict4 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",4] ,
                                     @"mingzi" :@"优惠券" ,
                                     @"jine" : @"20",
                                     @"miaosu" : @"运费抵扣",
                                     @"shijian" : @"2016-05-31",
                                     };
        NSDictionary *threedict5 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",5] ,
                                     @"mingzi" :@"优惠券" ,
                                     @"jine" : @"20",
                                     @"miaosu" : @"运费抵扣",
                                     @"shijian" : @"2016-05-31",
                                     };
        
        
        [addressArray addObject:threedict1];
        [addressArray addObject:threedict2];
        [addressArray addObject:threedict3];
        [addressArray addObject:threedict4];
        [addressArray addObject:threedict5];
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
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
    self.title = @"优惠券";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
//    UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"优惠价使用说明" style:UIBarButtonItemStyleDone target:self action:@selector(changyong)];
//    self.navigationItem.rightBarButtonItem = changyongItem;
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void) initView
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
- (void)changyong
{
    NSLog(@"优惠券使用说明");
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return addressArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
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
    return 90;
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
    NSDictionary *info = [addressArray objectAtIndex:indexPath.section];
   
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 0, 300*APP_DELEGATE().autoSizeScaleX, 90)];
    bg.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:bg];
    
    UIView *bg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90*APP_DELEGATE().autoSizeScaleX, 90)];
    bg1.backgroundColor = titleViewColor;
    [bg addSubview:bg1];
    
    UILabel *jineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 90*APP_DELEGATE().autoSizeScaleX, 45)];
    jineLable.numberOfLines = 1;
    jineLable.textAlignment = NSTextAlignmentCenter;
    jineLable.font = viewFont1;
    jineLable.textColor = [UIColor whiteColor];
    jineLable.text = [NSString stringWithFormat:@"￥%@",[info objectForKey:@"jine"]];
    [bg1 addSubview:jineLable];
    
    UILabel *mingziLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 90*APP_DELEGATE().autoSizeScaleX, 20)];
    mingziLable.numberOfLines = 1;
    mingziLable.textAlignment = NSTextAlignmentCenter;
    mingziLable.font = viewFont3;
    mingziLable.textColor = [UIColor whiteColor];
    mingziLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"mingzi"]];
    [bg1 addSubview:mingziLable];
    
    UILabel *miaosuLable = [[UILabel alloc] initWithFrame:CGRectMake(110*APP_DELEGATE().autoSizeScaleX, 0, 200*APP_DELEGATE().autoSizeScaleX, 30)];
    miaosuLable.numberOfLines = 1;
    miaosuLable.textAlignment = NSTextAlignmentLeft;
    miaosuLable.font = viewFont3;
    miaosuLable.textColor = fontColor;
    miaosuLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"miaosu"]];
    [bg addSubview:miaosuLable];
    
    UILabel *shijianLable = [[UILabel alloc] initWithFrame:CGRectMake(110*APP_DELEGATE().autoSizeScaleX, 30, 200*APP_DELEGATE().autoSizeScaleX, 30)];
    shijianLable.numberOfLines = 1;
    shijianLable.textAlignment = NSTextAlignmentLeft;
    shijianLable.font = viewFont3;
    shijianLable.textColor = fontColor;
    shijianLable.text = [NSString stringWithFormat:@"有效期  %@",[info objectForKey:@"shijian"]];
    [bg addSubview:shijianLable];

    UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(130*APP_DELEGATE().autoSizeScaleX, 60, 110*APP_DELEGATE().autoSizeScaleX, 20)];
    [submitBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [submitBtn setTitle:@"立即兑换" forState:UIControlStateHighlighted];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
    [submitBtn addTarget:self
                  action:@selector(submitBtnClick:)
        forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = viewFont1;
    [cell.contentView addSubview:submitBtn];

 
    return cell;
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"提交");
    
    
    
}

@end
