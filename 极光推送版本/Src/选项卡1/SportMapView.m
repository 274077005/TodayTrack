//
//  SportMapView.m
//  skyer
//
//  Created by odier on 2016/12/14.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SportMapView.h"
#import "SkDataOperation.h"
#import "StartAndEndPoint.h"

@implementation SportMapView

- (void)drawRect:(CGRect)rect {
    
    [self addSubview:_viewBack];
    [self addSubview:_imageBack];
    
}

- (void)viewAppear{
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    _mapView.showsUserLocation = YES;
    _mapView.delegate=self;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading];
    
    _dicTrack=[[SkDataOperation SkReadArrayWithFileName:KsRountTrackData] firstObject];
    NSString *trackUse=[_dicTrack objectForKey:@"trackUse"];
    
    if ([trackUse isEqualToString:@"1"]) {
        [self showAnnotion];
        [self showLine];
    }
    
}
- (void)viewDisAppear{
    _mapView.delegate=nil;
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView setUserTrackingMode:MAUserTrackingModeNone];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    }
    else if([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        StartAndEndPoint *annotationView = (StartAndEndPoint *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[StartAndEndPoint alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        if([annotation.title isEqualToString:@"起点"]){
            annotationView.labTitle.text=@"起点";
            annotationView.labTitle.textColor=[UIColor greenColor];
        }else if([annotation.title isEqualToString:@"终点"]){
            annotationView.labTitle.text=@"终点";
            annotationView.labTitle.textColor=[UIColor redColor];
        }else{
            annotationView.labTitle.text=annotation.title;
            annotationView.labTitle.textColor=[UIColor blueColor];
        }
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, 0);
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (_mapView.userTrackingMode!=2) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading];
    }
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
}

#pragma mark - 显示标记点
- (void) showAnnotion{
    [_mapView removeAnnotations:_mapView.annotations];
    
    NSString *points=[_dicTrack objectForKey:@"points"];
    NSArray *arrOnePoint=[points componentsSeparatedByString:@";"];
    
    for (int i =0 ; i<arrOnePoint.count; ++i) {
        NSString *onePoint=[arrOnePoint objectAtIndex:i];
        
        NSArray *arrPoint=[onePoint componentsSeparatedByString:@","];
        
        MAPointAnnotation *Annotation = [[MAPointAnnotation alloc]init];
        Annotation.coordinate=CLLocationCoordinate2DMake([[arrPoint firstObject] floatValue], [[arrPoint lastObject] floatValue]);
        
        if (i>0) {
            if (i==arrOnePoint.count-1) {
                Annotation.title=@"终点";
            }else{
                Annotation.title=[NSString stringWithFormat:@"途%d",i];
            }
        }else{
            Annotation.title=@"起点";
        }
        [self.mapView addAnnotation:Annotation];
    }
}

#pragma mark - 显示路线

- (void)showLine{
    
    NSArray *arrPolyline=[[_dicTrack objectForKey:@"ployLine"] componentsSeparatedByString:@";"];
    CLLocationCoordinate2D commonPolylineCoords[arrPolyline.count];
    for (int i =0; i< arrPolyline.count; ++i) {
        
        NSArray *arr2D=[[arrPolyline objectAtIndex:i] componentsSeparatedByString:@","];
        
        CGFloat latitude=[[arr2D objectAtIndex:1] floatValue];
        CGFloat longitude=[[arr2D objectAtIndex:0] floatValue];
        
        commonPolylineCoords[i].latitude = latitude;
        commonPolylineCoords[i].longitude = longitude;
        
    }
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:arrPolyline.count];
    //在地图上添加折线对象
    [self.mapView addOverlay: commonPolyline];
    
    [_mapView showOverlays:_mapView.overlays edgePadding:UIEdgeInsetsMake(50, 20, 50, 20) animated:YES];
    
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.strokeColor = [UIColor redColor];
        polylineRenderer.lineWidth   = 3.f;
        
        return polylineRenderer;
    }
    
    return nil;
}
@end
