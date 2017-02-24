//
//  KaiTongQuYuViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "KaiTongQuYuViewController.h"

@interface KaiTongQuYuViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableViewL;
    UITableView *_tableViewR;
    NSMutableArray *items;
    int indexL;
    int indexR;
}
@end

@implementation KaiTongQuYuViewController
@synthesize mydelegate;
@synthesize sheng;
@synthesize shi;
- (void)setSheng:(NSDictionary *)sheng1
{
    sheng = sheng1;
}
- (void)setShi:(NSDictionary *)shi1
{
    shi = shi1;
    [items removeAllObjects];
    NSArray *quyu = [shi objectForKey:@"child"];
    [items addObjectsFromArray:quyu];
    [_tableViewL reloadData];
    [_tableViewR reloadData];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        indexL = 0;
        indexR = 0;
        items = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    if (IsIOS7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
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
    self.title = @"开通区域";
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"fanhuijianfanhui" highIcon:@"fanhuijianfanhui" target:self action:@selector(pop:)];
    
}

- (void) initView
{
    UIImageView *iconView1 = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"searchbar_textfield_search_icon"]];
    iconView1.contentMode = UIViewContentModeCenter;
    
    _tableViewL = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 80, [UIScreen mainScreen].bounds.size.height-TabbarHeight)];
    _tableViewL.dataSource = self;
    _tableViewL.delegate = self;
    _tableViewL.backgroundColor = [UIColor whiteColor];
    _tableViewL.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableViewL];
    if (IsIOS7)
        _tableViewL.separatorInset = UIEdgeInsetsZero;
    
    _tableViewR = [[UITableView alloc] initWithFrame:CGRectMake(80, 0, 240, [UIScreen mainScreen].bounds.size.height-TabbarHeight)];
    _tableViewR.dataSource = self;
    _tableViewR.delegate = self;
    _tableViewR.backgroundColor = bgViewColor;
    _tableViewR.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableViewR];
    if (IsIOS7)
        _tableViewR.separatorInset = UIEdgeInsetsZero;
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableViewL)
    {
        return items.count;
    }
    else
    {
        if (items.count==0)
        {
            return 0;
        }
        else
        {
            NSDictionary *info = [items objectAtIndex:indexL];
            NSArray *_tableRData = [info objectForKey:@"child"];
            return _tableRData.count;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView==_tableViewL)
    {
        static NSString* CellIdentifierL = @"CellIdentifierL";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierL];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifierL];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        NSDictionary *area = [items objectAtIndex:indexPath.row];
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 65*APP_DELEGATE().autoSizeScaleX, 40)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = [NSString stringWithFormat:@"%@",[area objectForKey:@"region_name"]];
        [cell.contentView addSubview:titleLable1];
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 40)];
        colorView.backgroundColor = titleViewColor;
        [cell.contentView addSubview:colorView];
        if (indexL==indexPath.row)
        {
            colorView.hidden = NO;
            titleLable1.textColor = titleViewColor;
        }
        else
        {
            colorView.hidden = YES;
            titleLable1.textColor = fontColor;
        }
        return cell;
    }
    else
    {
        static NSString* CellIdentifierR = @"CellIdentifierR";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierR];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifierR];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = bgViewColor;
        }
        
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        NSDictionary *info = [items objectAtIndex:indexL];
        NSArray *_tableRData = [info objectForKey:@"child"];
        
        NSDictionary *address = [_tableRData objectAtIndex:indexPath.row];
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 0, 210*APP_DELEGATE().autoSizeScaleX, 40)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = [NSString stringWithFormat:@"%@",[address objectForKey:@"region_name"]];
        [cell.contentView addSubview:titleLable1];
        
        if (indexR==indexPath.row)
        {
            titleLable1.textColor = titleViewColor;
        }
        else
        {
            titleLable1.textColor = fontColor;
        }

        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 43, 210*APP_DELEGATE().autoSizeScaleX, 1)];
        fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        [cell.contentView addSubview:fgx];
        
        return cell;
    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==_tableViewL)
    {
        indexL = indexPath.row;
        [_tableViewL reloadData];
        indexR = 0;
        [_tableViewR reloadData];
    }
    else
    {
        indexR = indexPath.row;
        [_tableViewR reloadData];
        
        NSDictionary *area = [items objectAtIndex:indexL];
        NSArray *_tableRData = [area objectForKey:@"child"];
        NSDictionary *address = [_tableRData objectAtIndex:indexR];

        
        [UIAlertView showAlert:[NSString stringWithFormat:@"您选择了%@%@",[area objectForKey:@"region_name"],[address objectForKey:@"addressName"]] delegate:self cancelButton:@"取消" otherButton:@"确定" tag:1];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSLog(@"取消");
    }
    else
    {
        NSLog(@"回调");
        NSDictionary *area = [items objectAtIndex:indexL];
        NSArray *_tableRData = [area objectForKey:@"child"];
        NSDictionary *address = [_tableRData objectAtIndex:indexR];
        if (mydelegate && [mydelegate respondsToSelector:@selector(sendAreaAndAddress:andAddress:)])
        {
            [mydelegate sendAreaAndAddress:area andAddress:address];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
