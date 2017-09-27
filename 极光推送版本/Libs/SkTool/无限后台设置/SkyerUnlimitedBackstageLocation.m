//
//  UnlimitedBackstage.m
//  skyer
//
//  Created by odier on 2016/10/10.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkyerUnlimitedBackstageLocation.h"

@implementation SkyerUnlimitedBackstageLocation
//全局变量
static id _instance = nil;
//单例方法
+(instancetype)sharedInstance{
    return [[self alloc] init];
}
////alloc会调用allocWithZone:
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initLocationManager];
        _instance = [super init];
    });
    return _instance;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}



#pragma mark 初始化定位管理器
- (void)initLocationManager{
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    //设置允许后台定位参数，保持不会被系统挂起
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //iOS9(含)以上系统需设置
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>9.0) {
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    //允许持续定位
    [_locationManager requestAlwaysAuthorization];
    //设置代理
    _locationManager.delegate=self;
    //设置定位精度
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次.(为了省电，app挂起是设置为1000米)
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateActive) {
        _locationManager.distanceFilter=100.0;
    }else{
        _locationManager.distanceFilter=1000.0;
    }
    
    NSLog(@"_locationManager初始化%@",_locationManager);
    
}
#pragma mark - 开始定位
- (void) startUpdatingLocations{
    //每秒钟更新一次位置信息
    [_locationManager startUpdatingLocation];
}

#pragma mark - 结束定位
- (void) stopUpdatingLocations{
    [_locationManager stopUpdatingLocation];
}

#pragma mark 获取位置信息
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (_locations) {
        _locations(locations);
    }
}
#pragma mark - block回调回去定位信息
- (void)getLocations:(locations)locations{
    _locations=locations;
}

#pragma mark - block 获取你地理编码得到位置信息
-(void)getPlaceWithLocation:(float)latitude andLog:(float)longitude finshBlock:(void(^)(CLPlacemark *placemark))finshBlock{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark=[placemarks firstObject];
        finshBlock(placemark);
    }];
}
#pragma mark - block 获取你地理编码得到位置信息
-(void)getPlaceWithLocation:(CLLocation *)location finshBlock:(void(^)(CLPlacemark *placemark))finshBlock{
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark=[placemarks firstObject];
        finshBlock(placemark);
    }];
    
}

#pragma mark - Block逆地理编码
- (void)getPlaceWhitPlaceName:(NSString *)placeName finshBlock:(void(^)(CLPlacemark *placemark))finshBlock{
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:placeName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark=[placemarks firstObject];
        finshBlock(placemark);
    }];
}

#pragma mark - 计算两个经纬度间的距离

-(double)getDistance:(CLLocation *) curLocation andOtherLocation:(CLLocation*)otherLocation{
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
}


@end
