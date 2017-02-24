//
//  RoutePlanningViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//



@interface RoutePlanningViewController : YLLBaseViewController

typedef NS_ENUM(NSInteger, AMapRoutePlanningType)
{
    AMapRoutePlanningTypeDrive = 0,
    AMapRoutePlanningTypeWalk,
    AMapRoutePlanningTypeBus
};

- (void)daozhe:(CLLocationCoordinate2D)startCoordinate destinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate;
@end
