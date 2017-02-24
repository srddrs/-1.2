//
//  statisticsViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "statisticsViewController.h"
#import "IQActionSheetPickerView.h"
#import "SWTableViewCell.h"
@interface StatisticsViewController ()<UITableViewDataSource,UITableViewDelegate,IQActionSheetPickerViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *addressArray;
    
    UIView *timeView;
    UILabel *startLabel;
    UILabel *endLabel;
}
@end

@implementation StatisticsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        addressArray = [[NSMutableArray alloc] init];
        NSDictionary *threedict1 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",1] ,
                                     @"shouhuoren" :@"张三" ,
                                     @"zongcishu" : @"20",
                                     @"zongjianshu" : @"40",
                                     };
        NSDictionary *threedict2 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",2] ,
                                     @"shouhuoren" :@"张三" ,
                                     @"zongcishu" : @"20",
                                     @"zongjianshu" : @"40",
                                     };
        NSDictionary *threedict3 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",3] ,
                                     @"shouhuoren" :@"张三" ,
                                     @"zongcishu" : @"20",
                                     @"zongjianshu" : @"40",
                                     };
        NSDictionary *threedict4 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",4] ,
                                     @"shouhuoren" :@"张三" ,
                                     @"zongcishu" : @"20",
                                     @"zongjianshu" : @"40",
                                     };
        NSDictionary *threedict5 = @{
                                     @"orderId" :[NSString stringWithFormat:@"%d",5] ,
                                     @"shouhuoren" :@"张三" ,
                                     @"zongcishu" : @"20",
                                     @"zongjianshu" : @"40",
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

-(void)setUpNav
{
    self.title = @"发货统计";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
}

- (void) initView
{
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    bg.backgroundColor = titleViewColor;
    [self.view addSubview:bg];
    
    timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    timeView.backgroundColor = [UIColor whiteColor];
    [bg addSubview:timeView];
    
    startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    startLabel.backgroundColor = [UIColor clearColor];
    startLabel.textColor = fontColor;
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.lineBreakMode = NSLineBreakByWordWrapping;
    startLabel.numberOfLines = 0;
    startLabel.font = viewFont1;
    startLabel.text = @"";
    [timeView addSubview:startLabel];
    
    endLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 30)];
    endLabel.backgroundColor = [UIColor clearColor];
    endLabel.textColor = fontColor;
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.lineBreakMode = NSLineBreakByWordWrapping;
    endLabel.numberOfLines = 0;
    endLabel.font = viewFont1;
    endLabel.text = @"";
    [timeView addSubview:endLabel];
    
    UIButton *startBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 160, 30)];
    [startBtn setTitle:@"开始时间" forState:UIControlStateNormal];
    [startBtn setTitle:@"开始时间" forState:UIControlStateHighlighted];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [startBtn setBackgroundImage:[UIImage imageWithColor:titleViewColor] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageWithColor:titleViewColor] forState:UIControlStateHighlighted];
    [startBtn addTarget:self
                action:@selector(startBtnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    startBtn.titleLabel.font = viewFont1;
    [bg addSubview:startBtn];
    
    UIButton *endBtn = [[UIButton alloc] initWithFrame: CGRectMake(160, 0, 160, 30)];
    [endBtn setTitle:@"结束时间" forState:UIControlStateNormal];
    [endBtn setTitle:@"结束时间" forState:UIControlStateHighlighted];
    [endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [endBtn setBackgroundImage:[UIImage imageWithColor:titleViewColor] forState:UIControlStateNormal];
    [endBtn setBackgroundImage:[UIImage imageWithColor:titleViewColor] forState:UIControlStateHighlighted];
    [endBtn addTarget:self
                 action:@selector(endBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    endBtn.titleLabel.font = viewFont1;
    [bg addSubview:endBtn];
    
   

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 31, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight -31-20)];
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

- (void)startBtnClick:(id)sender
{
    
    IQActionSheetPickerView *picker =  [[IQActionSheetPickerView alloc] initWithTitle:@"选择开始时间" delegate:self];
    [picker setTag:1];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}
- (void)endBtnClick:(id)sender
{
    IQActionSheetPickerView *picker =  [[IQActionSheetPickerView alloc] initWithTitle:@"选择结束时间" delegate:self];
    [picker setTag:2];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
  
    
    
    
    if(pickerView.tag==1)
    {
        startLabel.text = destDateString;
        
    }
    else
    {
        endLabel.text = destDateString;
    }
    [UIView animateWithDuration:0.3 animations:^{
        timeView.frame = CGRectMake(0, 30, 320, 30);
        _tableView.frame = CGRectMake(0, 61, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight -61-20);
    }];
}

- (void)actionSheetPickerViewWillCancel:(IQActionSheetPickerView *)pickerView
{
    if(pickerView.tag==1)
    {
        startLabel.text = @"";
        
    }
    else
    {
        endLabel.text = @"";
    }
    if (startLabel.text.length==0&&endLabel.text.length==0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            timeView.frame = CGRectMake(0, 0, 320, 30);
            _tableView.frame = CGRectMake(0, 31, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight -31-20);
        }];
    }
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    headView.backgroundColor = bgViewColor;
    
    UILabel *shouhuorenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 107, 30)];
    shouhuorenLabel.backgroundColor = [UIColor clearColor];
    shouhuorenLabel.textColor = fontColor;
    shouhuorenLabel.textAlignment = NSTextAlignmentCenter;
    shouhuorenLabel.lineBreakMode = NSLineBreakByWordWrapping;
    shouhuorenLabel.numberOfLines = 0;
    shouhuorenLabel.font = viewFont1;
    shouhuorenLabel.text = @"收货人";
    [headView addSubview:shouhuorenLabel];

    UILabel *zongcishuLabel = [[UILabel alloc] initWithFrame:CGRectMake(107, 0, 107, 30)];
    zongcishuLabel.backgroundColor = [UIColor clearColor];
    zongcishuLabel.textColor = fontColor;
    zongcishuLabel.textAlignment = NSTextAlignmentCenter;
    zongcishuLabel.lineBreakMode = NSLineBreakByWordWrapping;
    zongcishuLabel.numberOfLines = 0;
    zongcishuLabel.font = viewFont1;
    zongcishuLabel.text = @"总次数";
    [headView addSubview:zongcishuLabel];
    
    UILabel *zongjianshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(214, 0, 107, 30)];
    zongjianshuLabel.backgroundColor = [UIColor clearColor];
    zongjianshuLabel.textColor = fontColor;
    zongjianshuLabel.textAlignment = NSTextAlignmentCenter;
    zongjianshuLabel.lineBreakMode = NSLineBreakByWordWrapping;
    zongjianshuLabel.numberOfLines = 0;
    zongjianshuLabel.font = viewFont1;
    zongjianshuLabel.text = @"总件数";
    [headView addSubview:zongjianshuLabel];

    
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    
    cell.contentView.backgroundColor = bgViewColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *info = [addressArray objectAtIndex:indexPath.section];
    
    
    UILabel *shouhuorenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 106*APP_DELEGATE().autoSizeScaleX, 43)];
    shouhuorenLabel.backgroundColor = [UIColor whiteColor];
    shouhuorenLabel.textColor = fontColor;
    shouhuorenLabel.textAlignment = NSTextAlignmentCenter;
    shouhuorenLabel.lineBreakMode = NSLineBreakByWordWrapping;
    shouhuorenLabel.numberOfLines = 0;
    shouhuorenLabel.font = viewFont1;
    shouhuorenLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"shouhuoren"]];
    [cell.contentView addSubview:shouhuorenLabel];
    
    UILabel *zongcishuLabel = [[UILabel alloc] initWithFrame:CGRectMake(107*APP_DELEGATE().autoSizeScaleX, 0, 106*APP_DELEGATE().autoSizeScaleX, 43)];
    zongcishuLabel.backgroundColor = [UIColor whiteColor];
    zongcishuLabel.textColor = fontColor;
    zongcishuLabel.textAlignment = NSTextAlignmentCenter;
    zongcishuLabel.lineBreakMode = NSLineBreakByWordWrapping;
    zongcishuLabel.numberOfLines = 0;
    zongcishuLabel.font = viewFont1;
    zongcishuLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"zongcishu"]];
    [cell.contentView addSubview:zongcishuLabel];
    
    UILabel *zongjianshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(214*APP_DELEGATE().autoSizeScaleX, 0, 107*APP_DELEGATE().autoSizeScaleX, 43)];
    zongjianshuLabel.backgroundColor = [UIColor whiteColor];
    zongjianshuLabel.textColor = fontColor;
    zongjianshuLabel.textAlignment = NSTextAlignmentCenter;
    zongjianshuLabel.lineBreakMode = NSLineBreakByWordWrapping;
    zongjianshuLabel.numberOfLines = 0;
    zongjianshuLabel.font = viewFont1;
    zongjianshuLabel.text = [NSString stringWithFormat:@"%@",[info objectForKey:@"zongjianshu"]];
    [cell.contentView addSubview:zongjianshuLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            NSLog(@"删除");
            [cell hideUtilityButtonsAnimated:YES];
        }
            break;
        default:
            break;
    }
}

@end
