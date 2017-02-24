//
//  YunDanGenZongViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "YunDanGenZongViewController.h"
#import "SWTableViewCell.h"
@interface YunDanGenZongViewController ()<WJSegmentMenuDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *addressArray;
    WJSegmentMenu *segmentMenu;

}
@end

@implementation YunDanGenZongViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        addressArray = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
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
    self.title = @"运单跟踪";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"fanhuijianfanhui" highIcon:@"fanhuijianfanhui" target:self action:@selector(pop:)];
}

- (void) initView
{
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    bg.backgroundColor = titleViewColor;
    [self.view addSubview:bg];
    
    UILabel *yundanNumLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    yundanNumLable.numberOfLines = 0;
    yundanNumLable.textAlignment = NSTextAlignmentLeft;
    yundanNumLable.font = viewFont1;
    yundanNumLable.textColor = [UIColor whiteColor];
    yundanNumLable.text = [NSString stringWithFormat:@"运单号:%@",@"224466881122334455"];
    [bg addSubview:yundanNumLable];

    

    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 61, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - TabbarHeight - statusViewHeight-61)];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    _tableView.backgroundColor = bgViewColor;
//    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    [self.view addSubview:_tableView];
//    if (IsIOS7)
//        _tableView.separatorInset = UIEdgeInsetsZero;
    

}

-(void)setSegmentMenu:(int)index
{
    if (!segmentMenu)
    {
        segmentMenu = [[WJSegmentMenu alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 30)];
        segmentMenu.delegate = self;
    }
    [segmentMenu segmentWithTitles:@[@"运输信息",@"代收款",@"回单跟踪"] andIndex:index];
    [self.view addSubview:segmentMenu];
}

- (void)pop:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
    
        }];
}

- (void)segmentWithIndex:(NSInteger)index title:(NSString *)title
{
    if (index==0)
    {
        NSLog(@"运输信息");
        
//        [self initYiShou];
    }
    else if(index==1)
    {
        NSLog(@"代收款");
    }
    else
    {
        
        NSLog(@"回单跟踪");
//        [self initWeiShou];
    }
}
@end
