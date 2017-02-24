//
//  KaiTongQuYuViewController.h
//  yunlailaC
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "YLLBaseViewController.h"
@protocol KaiTongQuYuViewControllerDelegate <NSObject>
@optional
- (void)sendAreaAndAddress:(id)area andAddress:(id)address;
@end
@interface KaiTongQuYuViewController : YLLBaseViewController

@property (nonatomic, assign) id<KaiTongQuYuViewControllerDelegate> mydelegate;

@end
