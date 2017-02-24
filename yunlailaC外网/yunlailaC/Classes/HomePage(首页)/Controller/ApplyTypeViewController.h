//
//  ApplyTypeViewController.h
//  yunlailaC
//
//  Created by admin on 16/7/15.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "YLLBaseViewController.h"
@protocol ApplyTypeViewControllerDelegate <NSObject>
@optional
- (void)sendType:(NSString *)Type;
@end
@interface ApplyTypeViewController : YLLBaseViewController
@property (nonatomic, assign) id<ApplyTypeViewControllerDelegate> mydelegate;

-(void)setType:(NSString *)type;
@end
