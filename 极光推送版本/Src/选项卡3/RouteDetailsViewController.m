//
//  RouteDetailsViewController.m
//  skyer
//
//  Created by odier on 2016/12/13.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "RouteDetailsViewController.h"
#import "StartAndEndPoint.h"

@interface RouteDetailsViewController ()
@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation RouteDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapView];
    
    [self showAnnotion];
    [self showLine];
}

- (void)initMapView{
    _mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    self.title=[_dicTrack objectForKey:@"name"];
    
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
-(void)dealloc{
    NSLog(@"销毁");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
