//
//  UnlimitedBackstage.h
//  skyer
//
//  Created by odier on 2016/10/10.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface SkyerUnlimitedBackstageLocation : NSObject <CLLocationManagerDelegate>

typedef void (^locations) (NSArray *locations);
@property (nonatomic,copy) locations locations;


@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic,strong) NSTimer *timeGetLocation;//每秒获取一次定位信息

/*
 *单例模式
 */
+ (instancetype)sharedInstance;
/*
 *开始定位服务
 */
- (void) startUpdatingLocations;
/*
 *结束定位服务
 */
- (void) stopUpdatingLocations;
/*
 *block回调获取位置信息
 */
- (void)getLocations:(locations)locations;

/*回调获取位置信息
 *latitude 维度
 *longitude 经度
 *@returen 位置信息
 */

-(void)getPlaceWithLocation:(float)latitude
                     andLog:(float)longitude
                 finshBlock:(void(^)(CLPlacemark *placemark))finshBlock;
/*回调获取位置信息
 *CLLocation 经纬度
 *@returen 位置信息
 */
-(void)getPlaceWithLocation:(CLLocation *)location
                 finshBlock:(void(^)(CLPlacemark *placemark))finshBlock;
/*回调获取位置信息
 *CLLocation 经纬度
 *@returen 位置信息
 */
- (void)getPlaceWhitPlaceName:(NSString *)placeName
                   finshBlock:(void(^)(CLPlacemark *placemark))finshBlock;
/**获取两个经纬度间的直线距离
 *curLocation 当前位置的经纬度
 *otherLocation 另外一个经纬度
 *return double 两点的直线距离
 */
-(double)getDistance:(CLLocation *) curLocation
    andOtherLocation:(CLLocation*) otherLocation;
@end
