//
//  SaoMaViewController.h
//  yunlailaC
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "YLLBaseViewController.h"
@protocol SaoMaViewControllerDelegate <NSObject>
@optional
- (void)sendCode:(NSString *)code;
@end
@interface SaoMaViewController : YLLBaseViewController
@property (nonatomic, assign) id<SaoMaViewControllerDelegate> mydelegate;
@end
