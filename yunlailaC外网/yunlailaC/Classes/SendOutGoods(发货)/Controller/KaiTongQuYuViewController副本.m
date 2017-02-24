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
    NSMutableArray *_tableLData;
    int indexL;
    int indexR;
}
@end

@implementation KaiTongQuYuViewController
@synthesize mydelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        indexL = 0;
        indexR = 0;
        _tableLData = [[NSMutableArray alloc] init];
        
//        NSMutableArray *addressArray1 = [[NSMutableArray alloc] init];
//        NSDictionary *addressInfo11 = @{
//                                    @"addressId" :[NSString stringWithFormat:@"%d",1] ,
//                                    @"addressName" : @"金牛区地点1",
//                                    };
//        NSDictionary *addressInfo12 = @{
//                                       @"addressId" :[NSString stringWithFormat:@"%d",1] ,
//                                       @"addressName" : @"金牛区地点2",
//                                       };
//        NSDictionary *addressInfo13 = @{
//                                       @"addressId" :[NSString stringWithFormat:@"%d",1] ,
//                                       @"addressName" : @"金牛区地点3",
//                                       };
//
//        [addressArray1 addObject:addressInfo11];
//        [addressArray1 addObject:addressInfo12];
//        [addressArray1 addObject:addressInfo13];
//        
//        
//        NSDictionary *areaInfo1 = @{
//                                     @"areaId" :[NSString stringWithFormat:@"%d",1] ,
//                                     @"areaName" : @"金牛区",
//                                     @"addressArray" : addressArray1,
//                                     };
//        
//        
//        NSMutableArray *addressArray2 = [[NSMutableArray alloc] init];
//        NSDictionary *addressInfo21 = @{
//                                       @"addressId" :[NSString stringWithFormat:@"%d",1] ,
//                                       @"addressName" : @"武侯区地点1",
//                                       };
//        NSDictionary *addressInfo22 = @{
//                                       @"addressId" :[NSString stringWithFormat:@"%d",1] ,
//                                       @"addressName" : @"武侯区地点2",
//                                       };
//        NSDictionary *addressInfo23 = @{
//                                       @"addressId" :[NSString stringWithFormat:@"%d",1] ,
//                                       @"addressName" : @"武侯区地点3",
//                                       };
//        
//        [addressArray2 addObject:addressInfo21];
//        [addressArray2 addObject:addressInfo22];
//        [addressArray2 addObject:addressInfo23];
//        
//        
//        NSDictionary *areaInfo2 = @{
//                                    @"areaId" :[NSString stringWithFormat:@"%d",2] ,
//                                    @"areaName" : @"武侯区",
//                                    @"addressArray" : addressArray2,
//                                    };
//
//
//        [_tableLData addObject:areaInfo1];
//        [_tableLData addObject:areaInfo2];
        
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
    
    //获取所有发货区域
    [self QueryAllShipRegion];
    
}

- (void)QueryAllShipRegion
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_region_queryAllShipRegion",@"funcId",     
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         ResponseObject *obj =[ResponseObject yy_modelWithDictionary:responseObject];
         if (((response *)obj.responses[0]).flag.intValue==1)
         {
             if (((response *)obj.responses[0]).items.count==0)
             {
                 self.noDataImage.hidden = NO;
                 [self.view bringSubviewToFront:self.noDataImage];
             }
             else
             {
                 self.noDataImage.hidden = YES;
                 [self.view bringSubviewToFront:_tableViewL];
                 [self.view bringSubviewToFront:_tableViewR];
                 [_tableLData removeAllObjects];
                 [_tableLData addObjectsFromArray: ((response *)obj.responses[0]).items];
                 [_tableViewL reloadData];
                 [_tableViewR reloadData];
             }

             
         }
         else
         {
             [MBProgressHUD showError:((response *)obj.responses[0]).message toView:self.view];
         }
         NSLog(@"%@",responseObject);
     } Failure:^(NSError *error)
     {
         NSLog(@"%@",error);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNav];
    [self initView];
    
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
    
    UITextField *searchText = [[UITextField alloc] init];
    searchText.leftView = iconView1;
    searchText.leftViewMode = UITextFieldViewModeAlways;
    searchText.leftView.frame = CGRectMake(0, 0, 30, 44);
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.frame = CGRectMake(15, 7, 290, 30);
    searchText.delegate = self;
    searchText.placeholder = @"搜索地域";
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.keyboardType = UIKeyboardTypeDefault;
    searchText.font = viewFont2;
    searchText.textColor = fontColor;
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.borderStyle = UITextBorderStyleRoundedRect;
    [searchText setValue:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [searchText setValue:viewFont2 forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:searchText];
    
    _tableViewL = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 80, [UIScreen mainScreen].bounds.size.height-TabbarHeight-44)];
    _tableViewL.dataSource = self;
    _tableViewL.delegate = self;
    _tableViewL.backgroundColor = [UIColor whiteColor];
    _tableViewL.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableViewL];
    if (IsIOS7)
        _tableViewL.separatorInset = UIEdgeInsetsZero;
    
    _tableViewR = [[UITableView alloc] initWithFrame:CGRectMake(80, 44, 240, [UIScreen mainScreen].bounds.size.height-TabbarHeight-44)];
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
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
        return _tableLData.count;
    }
    else
    {
        if (_tableLData.count>0)
        {
            NSDictionary *info = [_tableLData objectAtIndex:indexL];
            NSArray *_tableRData = [info objectForKey:@"addressArray"];
            if (_tableRData.count>0)
            {
                return _tableRData.count;
            }
            else
            {
                return 0;
            }

        }
        else
        {
            return 0;
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
        
        NSDictionary *area = [_tableLData objectAtIndex:indexPath.row];
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 65, 40)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = [NSString stringWithFormat:@"%@",[area objectForKey:@"areaName"]];
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
        
        NSDictionary *info = [_tableLData objectAtIndex:indexL];
        NSArray *_tableRData = [info objectForKey:@"addressArray"];
        
        NSDictionary *address = [_tableRData objectAtIndex:indexPath.row];
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 210, 40)];
        titleLable1.numberOfLines = 0;
        titleLable1.textAlignment = NSTextAlignmentLeft;
        titleLable1.font = viewFont1;
        titleLable1.textColor = fontColor;
        titleLable1.text = [NSString stringWithFormat:@"%@",[address objectForKey:@"addressName"]];
        [cell.contentView addSubview:titleLable1];
        
        if (indexR==indexPath.row)
        {
            titleLable1.textColor = titleViewColor;
        }
        else
        {
            titleLable1.textColor = fontColor;
        }

        UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(15, 43, 210, 1)];
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
        
        NSDictionary *area = [_tableLData objectAtIndex:indexL];
        NSArray *_tableRData = [area objectForKey:@"addressArray"];
        NSDictionary *address = [_tableRData objectAtIndex:indexR];

        
        [UIAlertView showAlert:[NSString stringWithFormat:@"您选择了%@%@",[area objectForKey:@"areaName"],[address objectForKey:@"addressName"]] delegate:self cancelButton:@"取消" otherButton:@"确定" tag:1];
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
        NSDictionary *area = [_tableLData objectAtIndex:indexL];
        NSArray *_tableRData = [area objectForKey:@"addressArray"];
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
