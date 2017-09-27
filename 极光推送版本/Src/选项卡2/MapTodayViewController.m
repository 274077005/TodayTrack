//
//  MapTodayViewController.m
//  skyer
//
//  Created by odier on 2016/12/6.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "MapTodayViewController.h"
#import "SkyerFmdbUse.h"
#import "StartAndEndPoint.h"


@interface MapTodayViewController ()
@property (nonatomic, strong) NSMutableArray *arrTrackData;
@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation MapTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_timeSelect;
    // Do any additional setup after loading the view.
    _arrTrackData=[[NSMutableArray alloc] init];
    _mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [self getOneDayTrack];
        [self showLine];
        [self showPoint];
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getOneDayTrack{
    
    NSString *sql=[NSString stringWithFormat:@"select * from t_locations where substr(timestamp, 1, 10) IS '%@' order by timestamp DESC",_timeSelect];
    
    FMResultSet *results=[[SkyerFmdbUse sharedSingleton] skyerQueryWithSQL:sql];
    
    
    while ([results next]) {
        NSString *timestamp=[results stringForColumn:@"timestamp"];
        NSString *altitude=[results stringForColumn:@"altitude"];
        NSString *course=[results stringForColumn:@"course"];
        NSString *horizontalaccuracy=[results stringForColumn:@"horizontalaccuracy"];
        NSString *latitude=[results stringForColumn:@"latitude"];
        NSString *longitude=[results stringForColumn:@"longitude"];
        NSString *myaction=[results stringForColumn:@"myaction"];
        NSString *speed=[results stringForColumn:@"speed"];
        NSString *verticalaccuracy=[results stringForColumn:@"verticalaccuracy"];
        
        
        
        NSDictionary *oneDic=@{@"timestamp":timestamp,
                               @"altitude":altitude,
                               @"course":course,
                               @"horizontalaccuracy":horizontalaccuracy,
                               @"latitude":latitude,
                               @"longitude":longitude,
                               @"myaction":myaction,
                               @"speed":speed,
                               @"verticalaccuracy":verticalaccuracy};
        [_arrTrackData addObject:oneDic];
    }
}
#pragma mark - 显示标记点

- (void)showPoint{
    
    MAPointAnnotation *alAnnotationStart = [[MAPointAnnotation alloc]init];
    alAnnotationStart.coordinate=CLLocationCoordinate2DMake([[[_arrTrackData firstObject] objectForKey:@"latitude"] floatValue], [[[_arrTrackData firstObject] objectForKey:@"longitude"] floatValue]);
    alAnnotationStart.title=@"终点";
    [self.mapView addAnnotation:alAnnotationStart];
    
    MAPointAnnotation *alAnnotationEnd = [[MAPointAnnotation alloc]init];
    alAnnotationEnd.coordinate=CLLocationCoordinate2DMake([[[_arrTrackData lastObject] objectForKey:@"latitude"] floatValue], [[[_arrTrackData lastObject] objectForKey:@"longitude"] floatValue]);
    alAnnotationEnd.title=@"起点";
    [self.mapView addAnnotation:alAnnotationEnd];
}

#pragma mark - 显示路线
- (void)showLine{
    NSInteger count=_arrTrackData.count;
    
    CLLocationCoordinate2D line2Points[count];

    for (int i =0; i< _arrTrackData.count; ++i) {
        CGFloat latitude=[[[_arrTrackData objectAtIndex:i] objectForKey:@"latitude"] floatValue];
        CGFloat longitude=[[[_arrTrackData objectAtIndex:i] objectForKey:@"longitude"] floatValue];
        line2Points[i].latitude = latitude;
        line2Points[i].longitude = longitude;
    }
    MAPolyline *line2 = [MAPolyline polylineWithCoordinates:line2Points count:count];
    NSArray *arrLine=@[line2];
    [self.mapView addOverlays:arrLine];
    
    [self.mapView showOverlays:self.mapView.overlays edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
}

#pragma mark - MAMapViewDelegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.strokeColor = [UIColor colorWithRed:18.0/255 green:118.0/255 blue:209.0/255 alpha:1];
        polylineRenderer.lineWidth   = 2.f;
        
        return polylineRenderer;
    }
    
    return nil;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        StartAndEndPoint *annotationView = (StartAndEndPoint *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[StartAndEndPoint alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        if([annotation.title isEqualToString:@"起点"]){
            annotationView.labTitle.text=@"起点";
            annotationView.labTitle.textColor=[UIColor greenColor];
        }else{
            annotationView.labTitle.text=@"终点";
            annotationView.labTitle.textColor=[UIColor redColor];
        }
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, 0);
        return annotationView;
    }
    return nil;
}
@end
