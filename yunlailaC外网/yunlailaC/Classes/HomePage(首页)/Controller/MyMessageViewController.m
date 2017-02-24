//
//  MyMessageViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "MyMessageViewController.h"
#import "SWTableViewCell.h"
@interface MyMessageViewController ()<WJSegmentMenuDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *addressArray;
}
@end

@implementation MyMessageViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        addressArray = [[NSMutableArray alloc] init];
        

    }
    return self;
}
-(void)initYiShou
{
    [addressArray removeAllObjects];
    NSDictionary *threedict1 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",1] ,
                                 @"neirong" : @"您的物品现在正在配送过程中，已经到达青羊小区，正在朝目的地金发，请您等待签收",
                                 };
    NSDictionary *threedict2 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",2] ,
                                 @"neirong" : @"您的物品现在正在配送过程中，已经到达青羊小区，正在朝目的地金发，请您等待签收",
                                 };
    
    NSDictionary *threedict3 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",3] ,
                                 @"neirong" : @"您的物品现在正在配送过程中，已经到达青羊小区，正在朝目的地金发，请您等待签收",
                                 };
    NSDictionary *threedict4 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",4] ,
                                 @"neirong" : @"您的物品现在正在配送过程中，已经到达青羊小区，正在朝目的地金发，请您等待签收",
                                 };
    
    NSDictionary *threedict5 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",5] ,
                                 @"neirong" : @"您的物品现在正在配送过程中，已经到达青羊小区，正在朝目的地金发，请您等待签收",
                                 };
    
    [addressArray addObject:threedict1];
    [addressArray addObject:threedict2];
    [addressArray addObject:threedict3];
    [addressArray addObject:threedict4];
    [addressArray addObject:threedict5];
    [_tableView reloadData];
}

-(void)initWeiShou
{
    [addressArray removeAllObjects];
    NSDictionary *threedict1 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",1] ,
                                 @"neirong" : @"系统消息11111",
                                 };
    NSDictionary *threedict2 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",2] ,
                                  @"neirong" : @"系统消息11111",
                                 };
    
    NSDictionary *threedict3 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",3] ,
                                  @"neirong" : @"系统消息11111",
                                 };
    NSDictionary *threedict4 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",4] ,
                                  @"neirong" : @"系统消息11111",
                                 };
    
    NSDictionary *threedict5 = @{
                                 @"orderId" :[NSString stringWithFormat:@"%d",5] ,
                                  @"neirong" : @"系统消息11111",
                                 };
    
    [addressArray addObject:threedict1];
    [addressArray addObject:threedict2];
    [addressArray addObject:threedict3];
    [addressArray addObject:threedict4];
    [addressArray addObject:threedict5];
    
    [_tableView reloadData];
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
    self.title = @"我的消息";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void) initView
{
    WJSegmentMenu *segmentMenu = [[WJSegmentMenu alloc]initWithFrame:CGRectMake(0, 1, 320, 30)];
    segmentMenu.delegate = self;
    [segmentMenu segmentWithTitles:@[@"物流消息",@"系统消息"]];
    
    [self.view addSubview:segmentMenu];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 31, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - statusViewHeight-31)];
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
    //    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    //
    //    }];
}

- (void)segmentWithIndex:(NSInteger)index title:(NSString *)title
{
    if (index==0)
    {
        NSLog(@"已收");
        
        [self initYiShou];
    }
    else
    {
        
        NSLog(@"未收");
        [self initWeiShou];
    }
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
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"CellIdentifier";
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *info = [addressArray objectAtIndex:indexPath.section];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 10, 30, 30)];
    icon.image = [UIImage imageNamed:@"xiaoxi_tixing"];
    [cell.contentView addSubview:icon];

    
    UILabel *neirongLable = [[UILabel alloc] initWithFrame:CGRectMake(60*APP_DELEGATE().autoSizeScaleX, 0, 225*APP_DELEGATE().autoSizeScaleX, 49)];
    neirongLable.numberOfLines = 0;
    neirongLable.textAlignment = NSTextAlignmentLeft;
    neirongLable.font = viewFont3;
    neirongLable.textColor = fontColor;
    neirongLable.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"neirong"]];
    [cell.contentView addSubview:neirongLable];
    
    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 49, 290*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:fgx];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *addressInfo = [addressArray objectAtIndex:indexPath.section];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:105/255.0 green:143/255.0 blue:243/255.0 alpha:1.0]
                                                title:@"删除"];
    return rightUtilityButtons;
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"");
            [cell hideUtilityButtonsAnimated:YES];
            
        }
            break;
        default:
            break;
    }
}

@end
