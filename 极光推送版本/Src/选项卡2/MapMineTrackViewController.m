//
//  MapMineTrackViewController.m
//  skyer
//
//  Created by odier on 2016/12/8.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "MapMineTrackViewController.h"
#import "StartAndEndPoint.h"

@interface MapMineTrackViewController ()
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *arrTrackData;
@end

@implementation MapMineTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=[_selectTrack lastObject];
    _arrTrackData=[[NSMutableArray alloc] init];
    _arrTrackData=[_selectTrack firstObject];
    
    _mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    [self showPoint];
    [self showLine];
}
#pragma mark - 显示标记点

- (void)showPoint{
    
    MAPointAnnotation *alAnnotationStart = [[MAPointAnnotation alloc]init];
    
    
    alAnnotationStart.coordinate=CLLocationCoordinate2DMake([[[_arrTrackData firstObject] objectForKey:@"latitude"] floatValue], [[[_arrTrackData firstObject] objectForKey:@"longitude"] floatValue]);
    alAnnotationStart.title=@"起点";
    [self.mapView addAnnotation:alAnnotationStart];
    
    MAPointAnnotation *alAnnotationEnd = [[MAPointAnnotation alloc]init];
    alAnnotationEnd.coordinate=CLLocationCoordinate2DMake([[[_arrTrackData lastObject] objectForKey:@"latitude"] floatValue], [[[_arrTrackData lastObject] objectForKey:@"longitude"] floatValue]);
    alAnnotationEnd.title=@"终点";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
