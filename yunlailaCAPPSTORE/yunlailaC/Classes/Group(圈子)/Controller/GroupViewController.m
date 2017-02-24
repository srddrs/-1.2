//
//  GroupViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 300, 50)];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor blackColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.numberOfLines = 0;
//    label.font = [UIFont systemFontOfSize:18];
//    label.text = @"暂未开放";
//    [self.view addSubview:label];
    UIImageView *icon =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quanzi"]];
    icon.center = CGPointMake(self.view.centerX, self.view.centerY-100*APP_DELEGATE().autoSizeScaleY);
    [self.view addSubview:icon];
  


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
