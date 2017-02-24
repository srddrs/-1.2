//
//  LocationManager.h
//  beautiful
//
//  Created by xuyang on 15-1-30.
//  Copyright (c) 2015年 mobilemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (assign, nonatomic) double longitude; // 经度
@property (assign, nonatomic) double latitude;  // 纬度
@property (strong, nonatomic) NSString *address; // 定位的地址
@property (assign, nonatomic) NSInteger locationFetchTimes; // 获取位置信息次数
@property (strong, nonatomic) CLLocationManager *locationManager; // 定位管理器
@property (strong, nonatomic) NSTimer *timer; // 定时器
@property (assign, nonatomic) CLLocationCoordinate2D baiduLocationCoordinate2D;
// 工厂方法
+ (LocationManager *)sharedInstance;
// 开启定时获取位置信息
- (void)startUpdateLocationTimer;
// 停止定时获取位置信息
- (void)stopUpdateLocationTimer;

// 启动位置信息的获取
- (void)startUpdatingLocation;

// 停止位置信息的获取
- (void)stopUpdatingLocation;

@end
