//
//  DaoDaShengfenViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "DaoDaShengfenViewController.h"
#import "DaoDaChengShiViewController.h"
@interface DaoDaShengfenViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *items;
    NSMutableArray *tmpitems;
    int currentIndex;
    UITextField *searchText;
}
@end

@implementation DaoDaShengfenViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        currentIndex = -1;
        items = [[NSMutableArray alloc] init];
        tmpitems = [[NSMutableArray alloc] init];
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
    currentIndex = -1;
    [_collectionView.mj_header beginRefreshing];
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
    self.title = @"到达省份";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"fanhuijianfanhui" highIcon:@"fanhuijianfanhui" target:self action:@selector(pop:)];
    
}

- (void) initView
{
    UIImageView *iconView1 = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"searchbar_textfield_search_icon"]];
    iconView1.contentMode = UIViewContentModeCenter;
    
    searchText = [[UITextField alloc] init];
    searchText.leftView = iconView1;
    searchText.leftViewMode = UITextFieldViewModeAlways;
    searchText.leftView.frame = CGRectMake(0, 0, 30, 44);
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.borderStyle = UITextBorderStyleNone;
    searchText.frame = CGRectMake(15, 7, 290, 30);
    searchText.delegate = self;
    searchText.placeholder = @"搜索省";
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.keyboardType = UIKeyboardTypeDefault;
    searchText.font = viewFont2;
    searchText.textColor = fontColor;
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.borderStyle = UITextBorderStyleRoundedRect;
    [searchText setValue:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [searchText setValue:viewFont2 forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:searchText];
    [searchText addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(320,0);//头部
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 44, [UIScreen mainScreen].bounds.size.width -30 , [UIScreen mainScreen].bounds.size.height - TabbarHeight  - 44) collectionViewLayout:flowLayout];
    
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    [_collectionView setBackgroundColor:bgViewColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    
}
#pragma mark 下拉刷新数据
- (void)loadData
{
    NHNetworkHelper *helper = [NHNetworkHelper shareInstance];
    [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     @"hex_region_queryAllReceiptRegionFunction",@"funcId",
                                     nil];
    
    [helper Soap:commonURL Parameters:paramDic Success:^(id responseObject)
     {
         [_collectionView.mj_header endRefreshing];
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
             [items removeAllObjects];
             [items addObjectsFromArray: ((response *)obj.responses[0]).items];
             [_collectionView reloadData];
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
         [_collectionView.mj_header endRefreshing];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
         
     }];
    
}

#pragma mark - collectionView代理
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 50);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //    if (section==0)
    //    {
    //    return CGSizeMake(0, 0);
    //    }
    //    else
    //    {
    //    return CGSizeMake(320, 30);
    //    }
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

#pragma mark - collection数据源代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [collectionView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:items.count];
    

    return [items count];
}

//头部显示的内容
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
//                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
//
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    view1.backgroundColor = [UIColor whiteColor];
//
//    UILabel *label1 = [[UILabel alloc] init];
//    label1.frame = CGRectMake(15, 3, 210, 30);
//    label1.font=[UIFont systemFontOfSize:12];
//    label1.numberOfLines = 0;
//    label1.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
//    label1.text = @"本地服务";
//    [view1 addSubview:label1];
//    if (indexPath.section==0)
//    {
//        label1.text = @"本地服务";
//    }
//    else
//    {
//        label1.text = @"网络服务";
//    }
//
//    [headerView addSubview:view1];//头部广告栏
//    return headerView;
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell* cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewIdentifier" forIndexPath:indexPath];
    
    for (UIView* view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    
    cell.contentView.backgroundColor = bgViewColor;
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 90, 41)];
    [button1 setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageWithColor:titleViewColor] forState:UIControlStateHighlighted];
    [button1 setBackgroundImage:[UIImage imageWithColor:titleViewColor] forState:UIControlStateSelected];
    
    NSDictionary *sheng = [items objectAtIndex:indexPath.row];
    
    [button1 setTitle:[NSString stringWithFormat:@"%@",[sheng objectForKey:@"receipt_name"]] forState:UIControlStateNormal];
    [button1 setTitle:[NSString stringWithFormat:@"%@",[sheng objectForKey:@"receipt_name"]] forState:UIControlStateHighlighted];
    [button1 setTitle:[NSString stringWithFormat:@"%@",[sheng objectForKey:@"receipt_name"]] forState:UIControlStateSelected];
    
    
    [button1 setTitleColor:fontColor forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    button1.titleLabel.font = viewFont1;
    button1.titleLabel.lineBreakMode = 0;
    button1.tag = indexPath.row;
    
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    LRViewBorderRadius(button1,5,1,[UIColor clearColor]);
    [cell.contentView addSubview:button1];
    if (indexPath.row==currentIndex)
    {
        button1.selected = YES;
    }
    else
    {
        button1.selected = NO;
    }
    
    
    return cell;
}

-(void)buttonClick:(UIButton *)sender
{
    currentIndex = sender.tag;
    [_collectionView reloadData];
    NSDictionary *sheng = [items objectAtIndex:sender.tag];
    
    NSLog(@"点击了：省%@",[sheng objectForKey:@"receipt_name"]);
    NSArray *shis = [sheng objectForKey:@"child"];
    if (shis.count>0)
    {
        DaoDaChengShiViewController *vc = [[DaoDaChengShiViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.sheng = sheng;
    }
    else
    {
        NSDictionary *info = @{
                               @"text" :[sheng objectForKey:@"receipt_name"] ,
                               @"receipt_region_id" : [sheng objectForKey:@"receipt_region_id"],
                               };
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_XuanKaiTong1 object:nil userInfo:info];
        }];
    }
    
}


- (void)pop:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [tmpitems removeAllObjects];
    [tmpitems addObjectsFromArray:items];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [items removeAllObjects];
    [items addObjectsFromArray:tmpitems];
    [_collectionView reloadData];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [items removeAllObjects];
    [items addObjectsFromArray:tmpitems];
    [_collectionView reloadData];
    return YES;
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    if (textField.text.length==0)
    {
        [items removeAllObjects];
        [items addObjectsFromArray:tmpitems];
        [_collectionView reloadData];
    }
    else
    {
        [items removeAllObjects];
        for (NSDictionary *info in tmpitems)
        {
            NSRange range = [[info objectForKey:@"receipt_name"] rangeOfString:textField.text];
            if (range.location !=NSNotFound)
            {
                [items addObject:info];
            }
        }
        
        [_collectionView reloadData];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end

