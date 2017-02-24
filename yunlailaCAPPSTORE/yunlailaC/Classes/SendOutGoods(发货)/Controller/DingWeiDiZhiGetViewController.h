//
//  DingWeiDiZhiGetViewController.h
//  yunlailaC
//
//  Created by admin on 16/7/14.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "YLLBaseViewController.h"
@protocol DingWeiDiZhiGetViewControllerDelegate <NSObject>
@optional
- (void)sendformattedAddress:(NSString *)formattedAddress AndCoordinate:(CLLocationCoordinate2D)coordinate;
@end
@interface DingWeiDiZhiGetViewController : YLLBaseViewController
@property (nonatomic, assign) id<DingWeiDiZhiGetViewControllerDelegate> mydelegate;
@end
