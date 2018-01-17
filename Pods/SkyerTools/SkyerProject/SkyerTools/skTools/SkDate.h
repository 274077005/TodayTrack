//
//  SkyerTool.h
//  skyer
//
//  Created by odier on 2016/12/2.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkDate : NSObject

/**
 获取系统当前时间

 @return 当前时间
 */
+(NSDate *)skyerGetCurrentDate;

/**
 NSDate-->NSString

 @param date NSDate
 @param dateFormat 格式化的类型(如:yyyy-MM-dd HH:mm:ss zzz)
 @return NSString
 */
+ (NSString * )skyerNSDateToNSString: (NSDate * )date dateFormat:(NSString *)dateFormat;

/**
 NSString-->NSDate

 @param string 需要转换的NSString
 @param dateFormat 格式化的类型(如:yyyy-MM-dd HH:mm:ss zzz)
 @return NSDate
 */
+ (NSDate * )skyerNSStringToNSDate: (NSString * )string dateFormat:(NSString *)dateFormat;

/**
 将字符类型的时间戳转换成字符类型的时间

 @param second 时间戳
 @param dateFormat 格式化的类型(如:yyyy-MM-dd HH:mm:ss zzz)
 @return 字符类型的时间
 */
+ (NSString *)skyerBySecondGetDate:(NSString *)second dateFormat:(NSString *)dateFormat;

/**
 获取data的时间戳

 @param date 需要查看的data
 @return 返回字符类型的时间戳
 */
+ (NSString *)skyerBydateGetSecond:(NSDate *)date;
@end
