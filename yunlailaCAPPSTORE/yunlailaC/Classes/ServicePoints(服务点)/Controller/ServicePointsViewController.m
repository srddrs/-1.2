//
//  ServicePointsViewController.m
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import "ServicePointsViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "RoutePlanningViewController.h"
#import "PuTongMAPointAnnotation.h"
#import "ZuiJinMAPointAnnotation.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface ServicePointsViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    NSMutableArray *annotations;
    NSMutableArray *addressArray;
    
    UIView *bgView;
    UILabel *mingziLable;
    UILabel *weizhiLable;
    UIImageView *icon;
    
    UITextField *searchText;
    MAPointAnnotation *currentAnnotation;
    NSMutableDictionary *currentPoi;
    
    NSArray *_pathPolylines;
    
}


@end

@implementation ServicePointsViewController


- (void)refreshMap:(NSNotification *)notification
{
    [self checkMapView];
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
        _mapView.pausesLocationUpdatesAutomatically = NO;
//        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
        
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
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
//    [_mapView removeAnnotations:_mapView.annotations];
//    [_mapView removeOverlays:_mapView.overlays];
    
    _search.delegate = nil;

    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshMap:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        annotations = [[NSMutableArray alloc] init];
        addressArray = [[NSMutableArray alloc] init];
        currentPoi = [[NSMutableDictionary alloc] init];
        _pathPolylines = [[NSArray alloc] init];
    }
    return self;
}

-(void)postServicePoi:(NSArray *)array
{
    [addressArray removeAllObjects];
    [addressArray addObjectsFromArray:array];
    
    if (addressArray.count>0)
    {
        //        [_mapView showAnnotations:annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
        NSDictionary *info = [addressArray firstObject];
        
        
         ZuiJinMAPointAnnotation *a1 = [[ZuiJinMAPointAnnotation alloc] init];
        a1.coordinate = CLLocationCoordinate2DMake([[info objectForKey:@"latitude"] doubleValue], [[info objectForKey:@"longitude"] doubleValue]);
        a1.title      = [NSString stringWithFormat:@"%@", [info objectForKey:@"dot_name"]];
        a1.subtitle      = [NSString stringWithFormat:@"%@", [info objectForKey:@"dot_id"]];
        [annotations addObject:a1];
        currentAnnotation = a1;
        
        [currentPoi removeAllObjects];
        [currentPoi setDictionary:info];
        _mapView.centerCoordinate = a1.coordinate;
        bgView.hidden = NO;
    
        [self updateBg];
    }

    
    for (int i = 1; i < addressArray.count-1; ++i)
    {
        NSDictionary *info = [addressArray objectAtIndex:i];
        PuTongMAPointAnnotation *a1 = [[PuTongMAPointAnnotation alloc] init];
        a1.coordinate = CLLocationCoordinate2DMake([[info objectForKey:@"latitude"] doubleValue], [[info objectForKey:@"longitude"] doubleValue]);
        a1.title      = [NSString stringWithFormat:@"%@", [info objectForKey:@"dot_name"]];
        a1.subtitle      = [NSString stringWithFormat:@"%@", [info objectForKey:@"dot_id"]];
        [annotations addObject:a1];
    }
    [_mapView addAnnotations:annotations];
    
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
    self.title = @"服务点";
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"dituliebiao_02" highIcon:@"dituliebiao_02" target:self action:@selector(dituBtnClick:)];
    
    
    _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_mapView];
    
    _mapView.showsCompass = NO;
    _mapView.showsScale = YES;
    _mapView.zoomLevel = 12;
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(10*APP_DELEGATE().autoSizeScaleX, 355*APP_DELEGATE().autoSizeScaleY, 300*APP_DELEGATE().autoSizeScaleX, 100*APP_DELEGATE().autoSizeScaleY)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_mapView addSubview:bgView];
    bgView.hidden = YES;
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(15*APP_DELEGATE().autoSizeScaleX, 8*APP_DELEGATE().autoSizeScaleY, 60*APP_DELEGATE().autoSizeScaleX, 50*APP_DELEGATE().autoSizeScaleY)];
    icon.image = [UIImage imageNamed:@"mendian"];
    [bgView addSubview:icon];
    
    mingziLable = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 7*APP_DELEGATE().autoSizeScaleY, 200*APP_DELEGATE().autoSizeScaleX, 20*APP_DELEGATE().autoSizeScaleY)];
    mingziLable.numberOfLines = 1;
    mingziLable.textAlignment = NSTextAlignmentLeft;
    mingziLable.font = viewFont1;
    mingziLable.textColor = fontColor;
    mingziLable.text = @"";
    [bgView addSubview:mingziLable];
    
    weizhiLable = [[UILabel alloc] initWithFrame:CGRectMake(90*APP_DELEGATE().autoSizeScaleX, 25*APP_DELEGATE().autoSizeScaleY, 200*APP_DELEGATE().autoSizeScaleX, 40*APP_DELEGATE().autoSizeScaleY)];
    weizhiLable.numberOfLines = 0;
    weizhiLable.textAlignment = NSTextAlignmentLeft;
    weizhiLable.font = viewFont1;
    weizhiLable.textColor = fontColor;
    weizhiLable.text = @"";
    [bgView addSubview:weizhiLable];

    UILabel *fgx = [[UILabel alloc] initWithFrame:CGRectMake(0, 65*APP_DELEGATE().autoSizeScaleY, 320*APP_DELEGATE().autoSizeScaleX, 1)];
    fgx.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bgView addSubview:fgx];
    
    UILabel *fgx1 = [[UILabel alloc] initWithFrame:CGRectMake(160*APP_DELEGATE().autoSizeScaleX, 67*APP_DELEGATE().autoSizeScaleY, 1, 30*APP_DELEGATE().autoSizeScaleY)];
    fgx1.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [bgView addSubview:fgx1];
    
  

    
    UIButton *goBtn = [[UIButton alloc] initWithFrame: CGRectMake(6*APP_DELEGATE().autoSizeScaleX, 65*APP_DELEGATE().autoSizeScaleY,144*APP_DELEGATE().autoSizeScaleX, 35*APP_DELEGATE().autoSizeScaleY)];
    [goBtn setImage:[UIImage imageNamed:@"daozhequ"] forState:UIControlStateNormal];
    [goBtn setImage:[UIImage imageNamed:@"daozhequ"] forState:UIControlStateHighlighted];
    [goBtn addTarget:self
              action:@selector(goBtnClick:)
    forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:goBtn];
    
    
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame: CGRectMake(161*APP_DELEGATE().autoSizeScaleX, 65*APP_DELEGATE().autoSizeScaleY,144*APP_DELEGATE().autoSizeScaleX, 35*APP_DELEGATE().autoSizeScaleY)];
    [phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
    [phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateHighlighted];
    [phoneBtn addTarget:self
                 action:@selector(phoneBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:phoneBtn];
    
//    [APP_DELEGATE() storyBoradAutoLay:self.view];

}



- (void)updateBg
{
    bgView.hidden = NO;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[currentPoi objectForKey:@"dot_image"]]];
    [icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mendian"]];
    mingziLable.text = [NSString stringWithFormat:@"%@",[currentPoi objectForKey:@"dot_name"]];
    weizhiLable.text = [NSString stringWithFormat:@"%@",[currentPoi objectForKey:@"dot_address"]];
}
- (void)dituBtnClick:(id)sender
{
    NSLog(@"切换地图");
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)shouchangBtnClick:(id)sender
{
    NSLog(@"收藏列表");
}

- (void)goBtnClick:(id)sender
{
    NSLog(@"到这里去");
    if ([[currentPoi objectForKey:@"latitude"] doubleValue]==0||[[currentPoi objectForKey:@"longitude"] doubleValue]==0)
    {
        [MBProgressHUD showAutoMessage:@"该服务点没有录入导航地址."];
    }
    else
    {
        AMapRouteConfig *config = [AMapRouteConfig new];
        config.appScheme      = [AppTool getApplicationScheme];
        config.appName        = [AppTool getApplicationName];
        config.startCoordinate = CLLocationCoordinate2DMake([LocationManager sharedInstance].latitude, [LocationManager sharedInstance].longitude);
        config.destinationCoordinate = CLLocationCoordinate2DMake([[currentPoi objectForKey:@"latitude"] doubleValue], [[currentPoi objectForKey:@"longitude"] doubleValue]);
        config.routeType = AMapRouteSearchTypeDriving;
        if(![AMapURLSearch openAMapRouteSearch:config])
        {
            [UIAlertView showAlert:@"由于您没有安装高德地图，所以无法进入导航界面，请安装高德地图" delegate:self cancelButton:@"取消" otherButton:@"去安装" tag:999];
        }
        
    }

    
    
    
//    RoutePlanningViewController *vc =[[RoutePlanningViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([LocationManager sharedInstance].latitude, [LocationManager sharedInstance].longitude);
//    CLLocationCoordinate2D destinationCoordinate = CLLocationCoordinate2DMake([[currentPoi objectForKey:@"latitude"] doubleValue], [[currentPoi objectForKey:@"longitude"] doubleValue]);
//    [vc daozhe:startCoordinate destinationCoordinate:destinationCoordinate];
}


- (void)phoneBtnClick:(id)sender
{
    NSLog(@"电话");

    NSDictionary *poiInfo = currentPoi;
    NSArray *phones = [[poiInfo objectForKey:@"telephone"] componentsSeparatedByString:@","];
    if (phones.count>1)
    {
        //多个电话
        NSLog(@"多个电话");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        for (int i=0; i<phones.count; i++)
        {
            [actionSheet addButtonWithTitle:[phones objectAtIndex:i]];
        }
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.destructiveButtonIndex = actionSheet.numberOfButtons - 1;
        actionSheet.tag = 999;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:[poiInfo objectForKey:@"telephone"]]]];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==999)
    {
        if (buttonIndex!=actionSheet.cancelButtonIndex)
        {
            NSString *phone = [actionSheet buttonTitleAtIndex:buttonIndex];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"telprompt://" stringByAppendingString:phone]]];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==999)
    {
        if (buttonIndex==1)
        {
            [AMapURLSearch getLatestAMapApp];
        }
    }
    else
    {
        if (buttonIndex==0)
        {
            NSLog(@"取消");
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }
        else
        {
            NSLog(@"设置");
            if (isIOS10)
            {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{}completionHandler:^(BOOL        success)
                 {
                     
                 }];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }

        }

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tmpBtn1Click:(id)sender
{
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    bgView.hidden = YES;
//    [_mapView removeOverlays:_mapView.overlays];
}
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    NSLog(@"subtitle:%d",[view.annotation.subtitle intValue]);
    for (int i=0; i<addressArray.count; i++)
    {
      
        NSDictionary *info = [addressArray objectAtIndex:i];
        if ([view.annotation.subtitle longLongValue]==[[info objectForKey:@"dot_id"] longLongValue])
        {
             NSLog(@"选中了:%@",info);
             _mapView.centerCoordinate = view.annotation.coordinate;
            currentAnnotation = view.annotation;
            [currentPoi removeAllObjects];
            [currentPoi setDictionary:info];
            [self updateBg];
        }
       
    }
    
}

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

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[ZuiJinMAPointAnnotation class]])
    {
        static NSString *zuijinpointReuseIndetifier = @"zuijinpointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:zuijinpointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:zuijinpointReuseIndetifier];
            annotationView.image = [UIImage imageNamed:@"zuijin-"];
        }
        return annotationView;
    }
    else if ([annotation isKindOfClass:[PuTongMAPointAnnotation class]])
    {
        static NSString *putongpointReuseIndetifier = @"putongpointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:putongpointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:putongpointReuseIndetifier];
            annotationView.image = [UIImage imageNamed:@"putong"];
        }
        return annotationView;
        
    }
    
    return nil;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
