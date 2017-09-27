//
//  RouteBookViewController.m
//  skyer
//
//  Created by odier on 2016/12/8.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "RouteBookViewController.h"
#import "SkyerNavigationController.h"
#import "SkyerUIFactory.h"
#import "SkToast.h"
#import "MANaviRoute.h"
#import "SkyerHUD.h"
#import "StartAndEndPoint.h"
#import "SkDataOperation.h"
#import "skyerDateUse.h"
#import "SkyerUnlimitedBackstageLocation.h"


@interface RouteBookViewController ()
@property (nonatomic ,strong) NSMutableArray *arrPointMake;//起点和终点
@property (nonatomic) NSInteger indexPoint;
@property (nonatomic) NSInteger distance;//规划路线的总距离
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic ,strong) NSMutableString *ployLine;
@end

@implementation RouteBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"路线";
    // Do any additional setup after loading the view.
    [self initViewState];
    _search=[[AMapSearchAPI alloc] init];
    _search.delegate=self;
    _mapView.delegate=self;
    [_mapView setShowsUserLocation:YES];
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    UIButton *btnSave=[SkyerUIFactory skUIButtonInitWithText:@"保存" fontOfSize:17 textColor:[UIColor blackColor] backgroundColor:[UIColor clearColor]];
    [btnSave addTarget:self action:@selector(btnSaveAction) forControlEvents:UIControlEventTouchUpInside];
    btnSave.frame=CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    _arrPointMake=[[NSMutableArray alloc] init];
    _ployLine=[[NSMutableString alloc] init];
}
-(void)dealloc{
    NSLog(@"销毁");
}

- (void)initViewState{
    _btnCenter=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-36/2, self.view.frame.size.height/2-50, 36, 50)];
    [_btnCenter setBackgroundImage:[UIImage imageNamed:@"routeMake"] forState:0];
    [_btnCenter addTarget:self action:@selector(btnCenter) forControlEvents:UIControlEventTouchUpInside];
    
    [_mapView addSubview:_segment];
    [_mapView addSubview:_btnCenter];
    [_mapView addSubview:_btnClear];
    [_mapView addSubview:_btnLook];
    [_mapView addSubview:_txtSearch];
    
    
    [SkyerUIFactory skSetViewsBorde:_btnClear BorderWidth:0 Radius:20 andBorderColor:[UIColor clearColor]];
    [SkyerUIFactory skSetViewsBorde:_btnLook BorderWidth:0 Radius:20 andBorderColor:[UIColor clearColor]];
    _indexPoint=0;
    _distance=0;
}

#pragma mark- 按钮点击事件
#pragma mark 保存
- (void)btnSaveAction{
    if (_ployLine.length>0) {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"为本次路线取个名称" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"为本次路线取个名称";
        }];
        
        UIAlertAction *alertCanle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *alertSure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [SkyerHUD skyerShowProgress:@"数据整理"];
            [_mapView showOverlays:_mapView.overlays edgePadding:UIEdgeInsetsMake(self.view.frame.size.height-100, 0, 0, 0) animated:YES];
            
            NSMutableString *points=[[NSMutableString alloc] init];
            for (int i =0; i<_arrPointMake.count; ++i) {
                MAPointAnnotation *oneAnnotion=[_arrPointMake objectAtIndex:i];
                [points appendString:[NSString stringWithFormat:@"%f,%f;",oneAnnotion.coordinate.latitude,oneAnnotion.coordinate.longitude]];
            }
            [points deleteCharactersInRange:NSMakeRange([points length]-1, 1)];
            

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                UIImage *screenshotImage = [self.mapView takeSnapshotInRect:CGRectMake(10, self.view.frame.size.height-110, self.view.frame.size.width-20, 110)];
                
                NSDate *date=[NSDate date];
                int imageName=(int)date;
                
                NSString *dateToday=[skyerDateUse skyerNSDateToNSString:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSString *name=[alert.textFields firstObject].text;
                
                NSString *imagePath=[SkDataOperation skSaveImage:screenshotImage imageName:[NSString stringWithFormat:@"%d",abs(imageName)]];

                NSMutableDictionary *OneTrack=[[NSMutableDictionary alloc] init];
                [OneTrack setObject:points forKey:@"points"];
                [OneTrack setObject:_ployLine forKey:@"ployLine"];
                [OneTrack setObject:[NSString stringWithFormat:@"%ld",_distance] forKey:@"distance"];
                [OneTrack setObject:name forKey:@"name"];
                [OneTrack setObject:imagePath forKey:@"image"];
                [OneTrack setObject:dateToday forKey:@"time"];
                [OneTrack setObject:@"0" forKey:@"trackUse"];//是否在使用
                
                NSArray *rountData=[SkDataOperation SkReadArrayWithFileName:KsRountTrackData];
                NSMutableArray *arrRountTrackData=[[NSMutableArray alloc] initWithArray:rountData];
                
                [arrRountTrackData addObject:OneTrack];
                
                [SkDataOperation SkSaveData:arrRountTrackData withSaveFileName:KsRountTrackData succeedBlock:^{
                    [SkyerHUD skyerShowToast:@"保存成功"];
                    [_mapView showOverlays:_mapView.overlays edgePadding:UIEdgeInsetsMake(50, 20, 50, 20) animated:YES];
                    
                    [SkyerHUD skyerRemoveProgress];
                }];
            });
            
        }];
        
        [alert addAction:alertCanle];
        [alert addAction:alertSure];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [SkyerHUD skyerShowToast:@"预览后再保存"];
    }
}
#pragma mark 类型选择
- (IBAction)segment:(UISegmentedControl *)sender {
    if (_arrPointMake.count==0) {
        sender.selectedSegmentIndex=0;
        [SkToast SkToastShow:@"先设置起点"];
    }else if (_arrPointMake.count==1){
        sender.selectedSegmentIndex=2;
        [SkToast SkToastShow:@"先设置终点"];
    }
}
#pragma mark 获取中心点
- (void)btnCenter{
    
    CLLocationCoordinate2D coordinate=_mapView.centerCoordinate;
    MAPointAnnotation *Annotation = [[MAPointAnnotation alloc]init];
    Annotation.coordinate=coordinate;
    switch (_segment.selectedSegmentIndex) {
        case 0://起点
        {
            if (_arrPointMake.count>0) {
                [_arrPointMake replaceObjectAtIndex:0 withObject:Annotation];
                _segment.selectedSegmentIndex=1;
            }else{
                [_arrPointMake addObject:Annotation];
                _segment.selectedSegmentIndex=2;
            }
        }
            break;
        case 1://途径点
        {
            if (_arrPointMake.count==2) {
                [_arrPointMake insertObject:Annotation atIndex:1];
            }else{
                [_arrPointMake insertObject:Annotation atIndex:_arrPointMake.count-1];
            }
            
        }
            break;
        case 2://终点
        {
            
            if (_arrPointMake.count>1) {
                [_arrPointMake replaceObjectAtIndex:_arrPointMake.count-1 withObject:Annotation];
            }else{
                [_arrPointMake addObject:Annotation];
            }
            
            _segment.selectedSegmentIndex=1;
        }
            break;
            
        default:
            break;
    }
    
    [self showAnnotion];
}
#pragma mark - 显示标记点
- (void) showAnnotion{
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (int i =0 ; i<_arrPointMake.count; ++i) {
        MAPointAnnotation *Annotation = [[MAPointAnnotation alloc]init];
        MAPointAnnotation *AnnotationSelect=[_arrPointMake objectAtIndex:i];
        Annotation.coordinate=AnnotationSelect.coordinate;
        if (i>0) {
            if (i==_arrPointMake.count-1) {
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


//这个是规划路线的
- (void) planingRouteWithOrigin:(AMapGeoPoint *)origin andDestination:(AMapGeoPoint *)destination{
    
    AMapRidingRouteSearchRequest *navi = [[AMapRidingRouteSearchRequest alloc] init];
    /* 提供备选方案*/
    navi.type = 0;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:origin.latitude longitude:origin.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:destination.latitude longitude:destination.longitude];
    
    [self.search AMapRidingRouteSearch:navi];
}
#pragma mark 导航搜索回调
/* 导航搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    
    NSArray *pathsArr=response.route.paths;
    AMapPath *Paths=[pathsArr firstObject];
    NSArray *stepsArr=Paths.steps;
    
    for (int i = 0; i<stepsArr.count; ++i) {
        AMapStep *step=[stepsArr objectAtIndex:i];
        [_ployLine appendString:step.polyline];
        _distance+=step.distance;
    }
    _indexPoint++;
    NSInteger count=_arrPointMake.count-1;
    if (_indexPoint==count)
    {
        [self showLine];
        [SkyerHUD skyerRemoveProgress];
    }
    else
    {
        [self getRoteWithAnnotion];
    }
    
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"导航失败%@",error);
    [SkyerHUD skyerRemoveProgress];
    [SkyerHUD skyerShowToast:@"获取路线失败"];
}

- (IBAction)btnClear:(id)sender {
    _ployLine=[[NSMutableString alloc] init];
    _distance=0;
    _segment.selectedSegmentIndex=0;
    [_arrPointMake removeAllObjects];
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
}
- (IBAction)btnLook:(id)sender {
    if (_arrPointMake.count>=2) {
        [SkyerHUD skyerShowProgress:@"开始获取路线"];
        _ployLine=[[NSMutableString alloc] init];
        [_mapView removeOverlays:_mapView.overlays];
        _indexPoint=0;
        _distance=0;
        [self getRoteWithAnnotion];
    }else{
        [SkyerHUD skyerShowToast:@"请设置起点终点"];
    }
}
- (void)getRoteWithAnnotion{
    if (_arrPointMake.count>=2) {
        MAPointAnnotation *AnnotationOrigin=[_arrPointMake objectAtIndex:_indexPoint];
        
        AMapGeoPoint *origin=[AMapGeoPoint locationWithLatitude:AnnotationOrigin.coordinate.latitude longitude:AnnotationOrigin.coordinate.longitude];
        
        MAPointAnnotation *AnnotationDestination=[_arrPointMake objectAtIndex:_indexPoint+1];
        
        AMapGeoPoint *destination=[AMapGeoPoint locationWithLatitude:AnnotationDestination.coordinate.latitude longitude:AnnotationDestination.coordinate.longitude];
        
        [self planingRouteWithOrigin:origin andDestination:destination];
    }
}

#pragma mark - 显示路线

- (void)showLine{
    if (_ployLine.length>0) {
        NSArray *arrPolyline=[_ployLine componentsSeparatedByString:@";"];
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
    }else{
        [SkyerHUD skyerShowToast:@"无显示数据"];
    }
    
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


#pragma mark - 点击搜索按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [[SkyerUnlimitedBackstageLocation sharedInstance] getPlaceWhitPlaceName:_txtSearch.text finshBlock:^(CLPlacemark *placemark) {
        
        CLLocationCoordinate2D coodinate=placemark.location.coordinate;
        [_mapView setCenterCoordinate:coodinate animated:YES];
    }];
    return YES;
}

@end
