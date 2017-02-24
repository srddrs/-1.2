//
//  DingWeiDiZhiViewController.h
//  yunlailaC
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "YLLBaseViewController.h"
@protocol DingWeiDiZhiViewControllerDelegate <NSObject>
@optional
- (void)sendformattedAddress:(NSString *)formattedAddress AndCoordinate:(CLLocationCoordinate2D)coordinate;
@end

@interface DingWeiDiZhiViewController : YLLBaseViewController
@property (nonatomic, assign) id<DingWeiDiZhiViewControllerDelegate> mydelegate;
@end
