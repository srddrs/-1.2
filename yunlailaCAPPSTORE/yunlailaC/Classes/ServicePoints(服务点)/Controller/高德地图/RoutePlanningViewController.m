//
//  RoutePlanningViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "RoutePlanningViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CommonUtility.h"
#import "MANaviRoute.h"

const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
const NSInteger RoutePlanningPaddingEdge                    = 20;

@interface RoutePlanningViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
}
/* 路径规划类型 */
@property (nonatomic) AMapRoutePlanningType routePlanningType;

@property (nonatomic, strong) AMapRoute *route;

/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;
/* 路线方案个数. */
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@end

@implementation RoutePlanningViewController
@synthesize route       = _route;

@synthesize currentCourse = _currentCourse;
@synthesize totalCourse   = _totalCourse;

@synthesize previousItem = _previousItem;
@synthesize nextItem     = _nextItem;

@synthesize startCoordinate         = _startCoordinate;
@synthesize destinationCoordinate   = _destinationCoordinate;

#pragma mark - Utility

/* 更新"上一个", "下一个"按钮状态. */
- (void)updateCourseUI
{
    /* 上一个. */
    self.previousItem.enabled = (self.currentCourse > 0);
    
    /* 下一个. */
    self.nextItem.enabled = (self.currentCourse < self.totalCourse - 1);
}

/* 更新"详情"按钮状态. */
- (void)updateDetailUI
{
    self.navigationItem.rightBarButtonItem.enabled = self.route != nil;
}

- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil)
    {
        switch (self.routePlanningType)
        {
            case AMapRoutePlanningTypeDrive   :
            case AMapRoutePlanningTypeWalk    : total = self.route.paths.count;    break;
            case AMapRoutePlanningTypeBus     : total = self.route.transits.count; break;
            default: total = 0; break;
        }
    }
    
    self.totalCourse = total;
}

- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1)
    {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}

- (BOOL)decreaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse > 0)
    {
        self.currentCourse--;
        
        result = YES;
    }
    
    return result;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{

    /* 公交路径规划. */
    if (self.routePlanningType == AMapRoutePlanningTypeBus)
    {
        if (self.route.transits.count>0)
        {
             self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentCourse]];
        }
       
    }
    /* 步行，驾车路径规划. */
    else
    {
        MANaviAnnotationType type = self.routePlanningType == AMapRoutePlanningTypeDrive ? MANaviAnnotationTypeDrive : MANaviAnnotationTypeWalking;
        if (self.route.paths.count>0)
        {
            self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES];
        }
        
    }
    
    [self.naviRoute addToMapView:_mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
    
    [self showXiangQing];
}


- (void)showXiangQing
{
    if (self.route == nil)
    {
        return;
    }
    NSLog(@"route:%@",self.route);
    if (self.routePlanningType==AMapRoutePlanningTypeBus) //公交
    {
        if (self.route.transits.count<=0)
        {
            
//            [MBProgressHUD showAutoMessage:[NSString stringWithFormat:@"出租车费用:%0.2f",self.route.taxiCost]];
            return;
        }
        NSArray<AMapTransit *> *transits = self.route.transits;
        AMapTransit *transit = [transits objectAtIndex:self.currentCourse];
        NSArray<AMapSegment *> *segments = transit.segments;
        for (int i = 0; i< segments.count; i++)
        {
            AMapSegment *segment = [segments firstObject];
            //步行信息
            AMapWalking  *walking = segment.walking;
            NSArray<AMapStep *> *steps = walking.steps;
            for (int i=0; i<steps.count; i++)
            {
                AMapStep *step = [steps objectAtIndex:i];
                NSLog(@"step:%@",step.polyline);
                NSArray *pois = [step.polyline componentsSeparatedByString:@","];
                for(int j=0; j < pois.count-1; j+=2)
                {
                    MANaviAnnotation *annot = [[MANaviAnnotation alloc] init];
                    annot.type = MANaviAnnotationTypeWalking;
                    annot.coordinate = CLLocationCoordinate2DMake([[pois objectAtIndex:j+1] doubleValue], [[pois objectAtIndex:j] doubleValue]);
                    annot.title = step.road;
                    annot.subtitle = step.instruction;
                    [_mapView addAnnotation:annot];
                }
            }
            
            
            
            //公交信息
            NSArray<AMapBusLine *> *buslines = segment.buslines;
            AMapBusLine *busline = [buslines firstObject];
            NSLog(@"车是什么 %@  开始%@  结束%@",busline.name,busline.departureStop.name,busline.arrivalStop.name);
            MANaviAnnotation *kaishiAnnotation = [[MANaviAnnotation alloc] init];
            kaishiAnnotation.type = AMapRoutePlanningTypeBus;
            kaishiAnnotation.coordinate = CLLocationCoordinate2DMake(busline.departureStop.location.latitude,busline.departureStop.location.longitude);
            kaishiAnnotation.title = [NSString stringWithFormat:@"%@上车",busline.departureStop.name];
            kaishiAnnotation.subtitle = busline.name;
            [_mapView addAnnotation:kaishiAnnotation];
            
            
            MANaviAnnotation *jieshuiAnnotation = [[MANaviAnnotation alloc] init];
            jieshuiAnnotation.type = AMapRoutePlanningTypeBus;
            jieshuiAnnotation.coordinate = CLLocationCoordinate2DMake(busline.arrivalStop.location.latitude,busline.arrivalStop.location.longitude);
            jieshuiAnnotation.title = [NSString stringWithFormat:@"%@下车",busline.arrivalStop.name];
            jieshuiAnnotation.subtitle = busline.name;
            [_mapView addAnnotation:jieshuiAnnotation];
        }
        
    }
    else
    {
        if (self.route.paths.count<=0)
        {
            return;
        }
        NSArray<AMapPath *> *paths = self.route.paths;
        AMapPath *path = [paths objectAtIndex:self.currentCourse];
        NSArray<AMapStep *> *steps = path.steps;
        for (int i=0; i<steps.count; i++)
        {
            AMapStep *step = [steps objectAtIndex:i];
            NSLog(@"step:%@",step.polyline);
            NSArray *pois = [step.polyline componentsSeparatedByString:@","];
            for(int j=0; j < pois.count-1; j+=2)
            {
                MANaviAnnotation *annot = [[MANaviAnnotation alloc] init];
                if (self.routePlanningType==AMapRoutePlanningTypeDrive) //驾车
                {
                    annot.type = MANaviAnnotationTypeDrive;
                }
                else//步行
                {
                    annot.type = MANaviAnnotationTypeWalking;
                }
                annot.coordinate = CLLocationCoordinate2DMake([[pois objectAtIndex:j+1] doubleValue], [[pois objectAtIndex:j] doubleValue]);
                annot.title = step.road;
                annot.subtitle = step.instruction;
                [_mapView addAnnotation:annot];
            }
        }
    }
}

/* 清空地图上已有的路线. */
- (void)clear
{
    [self.naviRoute removeFromMapView];
    NSArray *pois = [_mapView annotations];
    for (int i=0; i<pois.count; i++)
    {
        MAPointAnnotation *annot = [pois objectAtIndex:i];
        if ([annot isKindOfClass:[MANaviAnnotation class]])
        {
            [_mapView removeAnnotation:annot];
        }
    }
}

/* 将selectedIndex 转换为响应的AMapRoutePlanningType. */
- (AMapRoutePlanningType)searchTypeForSelectedIndex:(NSInteger)selectedIndex
{
    AMapRoutePlanningType navitgationType = 0;
    
    switch (selectedIndex)
    {
        case 0: navitgationType = AMapRoutePlanningTypeDrive;   break;
        case 1: navitgationType = AMapRoutePlanningTypeWalk; break;
        case 2: navitgationType = AMapRoutePlanningTypeBus;     break;
        default:NSAssert(NO, @"%s: selectedindex = %ld is invalid for RoutePlanning", __func__, (long)selectedIndex); break;
    }
    
    return navitgationType;
}


#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineRenderer.lineWidth   = 7;
        polylineRenderer.strokeColor = [UIColor blueColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 10;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    
    [self updateTotal];
    self.currentCourse = 0;
    
    [self updateCourseUI];
    [self updateDetailUI];
    
    
    [self presentCurrentCourse];
}

#pragma mark - RoutePlanning Search

/* 公交路径规划搜索. */
- (void)searchRoutePlanningBus
{
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.city             = @"chengdu";
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    navi.strategy = 0;
    [_search AMapTransitRouteSearch:navi];
}

/* 步行路径规划搜索. */
- (void)searchRoutePlanningWalk
{
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 提供备选方案*/
    navi.multipath = 1;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [_search AMapWalkingRouteSearch:navi];
}

/* 驾车路径规划搜索. */
- (void)searchRoutePlanningDrive
{
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];

    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [_search AMapDrivingRouteSearch:navi];
}

/* 根据routePlanningType来执行响应的路径规划搜索*/
- (void)SearchNaviWithType:(AMapRoutePlanningType)searchType
{
    switch (searchType)
    {
        case AMapRoutePlanningTypeDrive:
        {
            [self searchRoutePlanningDrive];
            
            break;
        }
        case AMapRoutePlanningTypeWalk:
        {
            [self searchRoutePlanningWalk];
            
            break;
        }
        case AMapRoutePlanningTypeBus:
        {
            [self searchRoutePlanningBus];
            
            break;
        }
    }
}

#pragma mark - Handle Action

/* 切换路径规划搜索类型. */
- (void)searchTypeAction:(UISegmentedControl *)segmentedControl
{
    self.routePlanningType = [self searchTypeForSelectedIndex:segmentedControl.selectedSegmentIndex];
    
    self.route = nil;
    self.totalCourse   = 0;
    self.currentCourse = 0;
    
    [self updateDetailUI];
    [self updateCourseUI];
    
    [self clear];
    
    /* 发起路径规划搜索请求. */
    [self SearchNaviWithType:self.routePlanningType];
}

/* 切到上一个方案路线. */
- (void)previousCourseAction
{
    if ([self decreaseCurrentCourse])
    {
        [self clear];
        
        [self updateCourseUI];
        
        [self presentCurrentCourse];
    }
}

/* 切到下一个方案路线. */
- (void)nextCourseAction
{
    if ([self increaseCurrentCourse])
    {
        [self clear];
        
        [self updateCourseUI];
        
        [self presentCurrentCourse];
    }
}

/* 进入详情页面. */
- (void)detailAction
{
    if (self.route == nil)
    {
        return;
    }
    NSLog(@"route:%@",self.route);


    
    if (self.routePlanningType==AMapRoutePlanningTypeBus) //公交
    {
        NSArray<AMapTransit *> *transits = self.route.transits;
        NSLog(@"AAAAAAA");
        AMapTransit *transit = [transits objectAtIndex:self.currentCourse];
        NSArray<AMapSegment *> *segments = transit.segments;
        AMapSegment *segment = [segments firstObject];
        //步行信息
        AMapWalking  *walking = segment.walking;
        NSArray<AMapStep *> *steps = walking.steps;
        for (int i=0; i<steps.count; i++)
        {
            AMapStep *step = [steps objectAtIndex:i];
            NSLog(@"step:%@",step.polyline);
            NSArray *pois = [step.polyline componentsSeparatedByString:@","];
            for(int j=0; j < pois.count-1; j+=2)
            {
                MANaviAnnotation *annot = [[MANaviAnnotation alloc] init];
                annot.type = MANaviAnnotationTypeWalking;
                annot.coordinate = CLLocationCoordinate2DMake([[pois objectAtIndex:j+1] doubleValue], [[pois objectAtIndex:j] doubleValue]);
                annot.title = step.road;
                annot.subtitle = step.instruction;
                [_mapView addAnnotation:annot];
            }
        }
        
        
        
        //公交信息
        NSArray<AMapBusLine *> *buslines = segment.buslines;
        AMapBusLine *busline = [buslines firstObject];
        NSLog(@"车是什么 %@  开始%@  结束%@",busline.name,busline.departureStop.name,busline.arrivalStop.name);
        MANaviAnnotation *kaishiAnnotation = [[MANaviAnnotation alloc] init];
        kaishiAnnotation.type = AMapRoutePlanningTypeBus;
        kaishiAnnotation.coordinate = CLLocationCoordinate2DMake(busline.departureStop.location.latitude,busline.departureStop.location.longitude);
        kaishiAnnotation.title = [NSString stringWithFormat:@"%@上车",busline.departureStop.name];
        kaishiAnnotation.subtitle = busline.name;
        [_mapView addAnnotation:kaishiAnnotation];
        
        
        MANaviAnnotation *jieshuiAnnotation = [[MANaviAnnotation alloc] init];
        jieshuiAnnotation.type = AMapRoutePlanningTypeBus;
        jieshuiAnnotation.coordinate = CLLocationCoordinate2DMake(busline.arrivalStop.location.latitude,busline.arrivalStop.location.longitude);
        jieshuiAnnotation.title = [NSString stringWithFormat:@"%@下车",busline.arrivalStop.name];
        jieshuiAnnotation.subtitle = busline.name;
        [_mapView addAnnotation:jieshuiAnnotation];

        
    }
    else
    {
        NSArray<AMapPath *> *paths = self.route.paths;
        AMapPath *path = [paths objectAtIndex:self.currentCourse];
        NSArray<AMapStep *> *steps = path.steps;
        for (int i=0; i<steps.count; i++)
        {
            AMapStep *step = [steps objectAtIndex:i];
            NSLog(@"step:%@",step.polyline);
            NSArray *pois = [step.polyline componentsSeparatedByString:@","];
            for(int j=0; j < pois.count-1; j+=2)
            {
                MANaviAnnotation *annot = [[MANaviAnnotation alloc] init];
                if (self.routePlanningType==AMapRoutePlanningTypeDrive) //驾车
                {
                    annot.type = MANaviAnnotationTypeDrive;
                }
                else//步行
                {
                    annot.type = MANaviAnnotationTypeWalking;
                }
                annot.coordinate = CLLocationCoordinate2DMake([[pois objectAtIndex:j+1] doubleValue], [[pois objectAtIndex:j] doubleValue]);
                annot.title = step.road;
                annot.subtitle = step.instruction;
                [_mapView addAnnotation:annot];
            }
        }
    }
}

#pragma mark - Initialization

- (void)initNavigationBar
{
    self.title = @"导航";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"zhuye_fanhui_baise" highIcon:@"zhuye_fanhui_baise" target:self action:@selector(pop:)];

//    UIBarButtonItem *changyongItem = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStyleDone target:self action:@selector(detailAction)];
//    self.navigationItem.rightBarButtonItem = changyongItem;
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    /* 导航类型. */
    UISegmentedControl *searchTypeSegCtl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"  驾 车  ",
                                             @"  步 行  ",
                                             @"  公 交  ",
                                             nil]];
    
    searchTypeSegCtl.segmentedControlStyle = UISegmentedControlStyleBar;
    [searchTypeSegCtl addTarget:self action:@selector(searchTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *searchTypeItem = [[UIBarButtonItem alloc] initWithCustomView:searchTypeSegCtl];
    
    /* 上一个. */
    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithTitle:@"上一个"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(previousCourseAction)];
    self.previousItem = previousItem;
    
    /* 下一个. */
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"下一个"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(nextCourseAction)];
    self.nextItem = nextItem;
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, searchTypeItem, flexbleItem, previousItem, flexbleItem, nextItem, flexbleItem, nil];
}

- (void)daozhe:(CLLocationCoordinate2D)startCoordinate destinationCoordinate:(CLLocationCoordinate2D)destinationCoordinate
{
    self.startCoordinate = startCoordinate;
    self.destinationCoordinate = destinationCoordinate;
    
    
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
//    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [_mapView addAnnotation:startAnnotation];
    [_mapView addAnnotation:destinationAnnotation];
}
- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
//    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [_mapView addAnnotation:startAnnotation];
    [_mapView addAnnotation:destinationAnnotation];
}

#pragma mark - Life Cycle
- (void)refreshMap:(NSNotification *)notification
{
    [self checkMapView];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSLog(@"取消");
        [self.navigationController popViewControllerAnimated:YES];
        
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

- (void)checkMapView
{
    [self clearMapView];
     NSLog(@"status:%d",[CLLocationManager authorizationStatus]);
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse))

    {
        //定位功能可用，开始定位
        [_mapView setHidden:NO];
        _mapView.delegate = self;
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

- (id)init
{
    if (self = [super init])
    {

        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-47)];
        [self.view addSubview:_mapView];
        
        _mapView.showsCompass = NO;
        _mapView.showsScale = YES;
        _mapView.zoomLevel = 12;
        
//        [APP_DELEGATE() storyBoradAutoLay:self.view];
        [self initNavigationBar];
        
        [self initToolBar];
        
        //    [self addDefaultAnnotations];
        
        [self updateCourseUI];
        
        [self updateDetailUI];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self checkMapView];
    self.navigationController.navigationBar.barStyle    = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.toolbar.barStyle      = UIBarStyleDefault;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clearMapView];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

@end
