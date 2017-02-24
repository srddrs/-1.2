//
//  DingWeiDiZhiViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/13.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "DingWeiDiZhiViewController.h"
#import "ChangYongSendAddressViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface DingWeiDiZhiViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    
    AMapSearchAPI *_search;
    
    AMapReGeocode *reGeocode;
    
    CLLocationCoordinate2D currentCoordinate;
    NSString *currentformattedAddress;
    
    UILabel *label;
}

@end

@implementation DingWeiDiZhiViewController
@synthesize mydelegate;
- (void)refreshMap:(NSNotification *)notification
{
    [self checkMapView];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSLog(@"取消");
        if (alertView.tag==1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        NSLog(@"设置");
        if (alertView.tag==2)
        {
            if (mydelegate && [mydelegate respondsToSelector:@selector(sendformattedAddress:AndCoordinate:)])
            {
                [mydelegate sendformattedAddress:currentformattedAddress AndCoordinate:currentCoordinate];
            }
//            [self.navigationController dismissViewControllerAnimated:YES completion:^{
//                
//            }];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if(alertView.tag==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
        
    }
}

- (void)checkMapView
{
    [self clearMapView];
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))
    {
        //定位功能可用，开始定位
        [_mapView setHidden:NO];
        _mapView.delegate = self;
        _mapView.zoomLevel = 15;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode  = MAUserTrackingModeFollow;
        
        _search.delegate = self;
        
        _mapView.pausesLocationUpdatesAutomatically = NO;
        
//        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
        
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"定位功能不可用，提示用户或忽略");
        [UIAlertView showAlert:@"请设置允许托运邦货主使用定位服务的权限" delegate:self cancelButton:@"取消" otherButton:@"去设置" tag:1];
        
    }
    
}

- (void)clearMapView
{
    [_mapView setHidden:YES];
    _mapView.delegate = nil;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode  = MAUserTrackingModeNone;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    
    _search.delegate = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkMapView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clearMapView];
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
    self.title = @"定位地址";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];
    
   }

- (void) initView
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)  )];
    [self.view addSubview:_mapView];
    
    _mapView.showsCompass = YES;
    _mapView.showsScale = YES;
    _mapView.zoomLevel = 15;
    
    _search = [[AMapSearchAPI alloc] init];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 36)];
    bg.backgroundColor = [UIColor whiteColor];
    [_mapView addSubview:bg];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 36)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = fontColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = viewFont1;
    label.text = @"单击地图选择发货地点";
    [bg addSubview:label];
   

    UIButton *submitBtn = [[UIButton alloc] initWithFrame: CGRectMake(35, CGRectGetHeight(_mapView.bounds)-120, 250, 34)];
    [submitBtn setTitle:@"确认地点" forState:UIControlStateNormal];
    [submitBtn setTitle:@"确认地点" forState:UIControlStateHighlighted];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateHighlighted];
    [submitBtn addTarget:self
                 action:@selector(submitBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = viewFont1;
    [_mapView addSubview:submitBtn];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(160-6, _mapView.frame.size.height/2-10-44, 13, 20) ];
    icon.image = [UIImage imageNamed:@"dingwei"];
    [_mapView addSubview:icon];
}

- (void)pop:(id)sender
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitBtnClick:(id)sender
{
    NSLog(@"确认起点");
    if (currentformattedAddress.length==0)
    {
        [UIAlertView showAlert:@"拖动地图选择发货地点" cancelButton:@"确定"];
    }
    else
    {
        [UIAlertView showAlert:[NSString stringWithFormat:@"您选择了%@",currentformattedAddress] delegate:self cancelButton:@"取消" otherButton:@"确定" tag:2];
    }
    
}



#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        //        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        //        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        //        pre.image = [UIImage imageNamed:@"location.png"];
        //        pre.lineWidth = 3;
        //        pre.lineDashPattern = @[@6, @3];
        pre.showsAccuracyRing = NO;
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    NSLog(@"拖动结束");
     [_mapView removeAnnotations:_mapView.annotations];
    [self searchReGeocodeWithCoordinate:mapView.centerCoordinate];
    
}

//- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
//{
//    NSLog(@"点击地图");
//      [_mapView removeAnnotations:_mapView.annotations];
//    MAPointAnnotation *pointAnnotation = view.annotation;
//  
//    [self searchReGeocodeWithCoordinate:pointAnnotation.coordinate];
//}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [_mapView removeAnnotations:_mapView.annotations];
    [self searchReGeocodeWithCoordinate:coordinate];
}
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    
    [_search AMapReGoecodeSearch:regeo];
}

#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        
//        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//        pointAnnotation.coordinate = coordinate;
//        [_mapView addAnnotation:pointAnnotation];
        
        label.text = response.regeocode.formattedAddress;
        currentCoordinate = coordinate;
        currentformattedAddress = response.regeocode.formattedAddress;
    }
}

@end
