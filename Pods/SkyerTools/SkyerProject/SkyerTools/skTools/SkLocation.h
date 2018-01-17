//
//  UnlimitedBackstage.h
//  skyer
//
//  Created by odier on 2016/10/10.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SkyerSingleton.h"

@interface SkLocation : NSObject <CLLocationManagerDelegate>

SkyerSingletonH(SkLocation)
//使用这玩意需要获取定位权限,否则会报错
@property (nonatomic,strong) CLLocationManager *locationManager;

/**
 这个是需要获取的位置信息
 */
@property (nonatomic,strong) void(^locations)(NSArray *locations);

/**
 先初始化再做事情
 */
-(SkLocation *(^)(void))skInitMannager;
/**
 更新位置信息
 */
-(SkLocation *(^)(void))skStarUpdateLocation;
/**
 暂停更新位置
 */
-(SkLocation *(^)(void))skStopUpdateLocation;

#pragma mark - 这后面的和前面的没有关联

/**
 通过经纬度获取位置信息

 @param latitude 经度
 @param longitude 维度
 @param finshBlock 返回经纬度点的位置信息
 */
-(void)getPlaceWithLocation:(float)latitude
                     andLog:(float)longitude
                 finshBlock:(void(^)(CLPlacemark *placemark))finshBlock;

/**
 通过经纬度获取位置信息

 @param location 经纬度点
 @param finshBlock 返回的位置信息
 */
-(void)getPlaceWithLocation:(CLLocation *)location
                 finshBlock:(void(^)(CLPlacemark *placemark))finshBlock;


/**
 通过位置查询该位置的经纬度

 @param placeName 位置名称(如:北海)
 @param finshBlock 返回位置的经纬度信息
 */
- (void)getPlaceWhitPlaceName:(NSString *)placeName
                   finshBlock:(void(^)(CLPlacemark *placemark))finshBlock;


/**
 两个经纬度点的直线距离

 @param curLocation 第一个点
 @param otherLocation 第二个点
 @return 距离
 */
-(double)getDistance:(CLLocation *) curLocation
    andOtherLocation:(CLLocation*) otherLocation;
@end
