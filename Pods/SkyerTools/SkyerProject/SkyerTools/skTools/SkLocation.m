//
//  UnlimitedBackstage.m
//  skyer
//
//  Created by odier on 2016/10/10.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkLocation.h"

@implementation SkLocation
SkyerSingletonM(SkLocation)

-(SkLocation *(^)(void))skInitMannager{
    return ^id{
        //定位管理器
        _locationManager=[[CLLocationManager alloc]init];
        //设置允许后台定位参数，保持不会被系统挂起
        [_locationManager setPausesLocationUpdatesAutomatically:YES];
        //iOS9(含)以上系统需设置
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        //允许持续定位
        [_locationManager requestAlwaysAuthorization];
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        return self;
    };
}

-(SkLocation *(^)(void))skStarUpdateLocation{
    return ^id{
        
        [_locationManager startUpdatingLocation];
        
        return self;
    };
}

-(SkLocation *(^)(void))skStopUpdateLocation{
    return ^id{
        [_locationManager stopUpdatingLocation];
        return self;
    };
}

#pragma mark 获取位置信息
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (_locations) {
        _locations(locations);
    }
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
