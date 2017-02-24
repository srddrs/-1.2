//
//  LocationManager.m
//  beautiful
//
//  Created by xuyang on 15-1-30.
//  Copyright (c) 2015年 mobilemix. All rights reserved.
//

#import "LocationManager.h"
#import "JZLocationConverter.h"
static LocationManager *g_locationManager = nil;

@interface LocationManager ()



@end

#define kLocationManager_FetchCount     3
#define kLocationManager_Timer_Seconds  (30*60)

@implementation LocationManager
// 工厂方法
+ (LocationManager *)sharedInstance
{
    if (g_locationManager == nil) {
        g_locationManager = [[LocationManager alloc] init];
    }
    return g_locationManager;
}

// 开启定时获取位置信息
- (void)startUpdateLocationTimer
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kLocationManager_Timer_Seconds target:self selector:@selector(startUpdatingLocation) userInfo:nil repeats:YES];
    }
    [self.timer fire];
}

// 停止定时获取位置信息
- (void)stopUpdateLocationTimer
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

// 启动位置信息的获取
- (void)startUpdatingLocation
{
    NSLog(@"%d",[[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]);
    self.locationFetchTimes = 0;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    if (isIOS8) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        [self.locationManager requestWhenInUseAuthorization];
#endif
    }
    [self.locationManager startUpdatingLocation];
}

// 停止位置信息的获取
- (void)stopUpdatingLocation
{
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
}

#pragma mark - CLLocationManagerDelegate

// 更新位置信息
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)theLocation fromLocation:(CLLocation *)oldLocation
{
    //    [self transform:theLocation.coordinate.latitude lon:theLocation.coordinate.longitude];
    CLLocationCoordinate2D wgsPt = theLocation.coordinate;
    CLLocationCoordinate2D gcjPt = [JZLocationConverter wgs84ToGcj02:wgsPt];
    CLLocationCoordinate2D bdPt = [JZLocationConverter wgs84ToBd09:wgsPt];
    self.latitude = gcjPt.latitude;
    self.longitude = gcjPt.longitude;
    NSLog(@"lon:%lf, lat:%lf", self.longitude, self.latitude);
    if (self.locationFetchTimes < kLocationManager_FetchCount) {
        self.locationFetchTimes++;
        return;
    }
    
    [self getLocationInfo];
    [self stopUpdatingLocation];
    self.baiduLocationCoordinate2D = bdPt;
    //发通知
//     [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGetLocationInfo object:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@", error);
}

// 获取地理位置信息
- (void)getLocationInfo
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *theLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    [geocoder reverseGeocodeLocation:theLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         for (CLPlacemark *placemark in placemarks)
         {
             NSString *strCity = nil;
             NSArray *arr = [placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
             
             if (arr!=nil||arr.count!=0)
                 strCity = [arr objectAtIndex:0];
             if (strCity!=nil)
             {
                 NSString *cityName = nil;
                 if (placemark.locality) {
                     cityName = placemark.locality;
                 }
                 else {
                     cityName = placemark.administrativeArea;
                 }
                 NSLog(@"%@\n%@\n%@", cityName, strCity, placemark.thoroughfare);
                 cityName = [cityName substringWithRange:NSMakeRange(0,cityName.length-1)];
                 self.address = strCity;
             }
         }
     }];
}


@end

