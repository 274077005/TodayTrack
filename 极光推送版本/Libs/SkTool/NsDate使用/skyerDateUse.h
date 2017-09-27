//
//  SkyerTool.h
//  skyer
//
//  Created by odier on 2016/12/2.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface skyerDateUse : NSObject
//获取当前系统时间
+(NSDate *)skyerGetCurrentDate;
//将日期转换为字符串（日期，时间）
+(NSString *)skyerGetDateStringFromDate:(NSDate *)date;
/*NSString转换成NSDate
 *NSString uiDate 需要转换的字符串
 *NSString Format 转换格式
 *reture NSDate
 *yyyy-MM-dd HH:mm:ss zzz
 */
+ (NSString * )skyerNSDateToNSString: (NSDate * )date dateFormat:(NSString *)dateFormat;
/*NSDate转换成NSString
 *NSDate date 需要转换的NSDate
 *NSString Format 转换格式
 *reture NSString
 *yyyy-MM-dd HH:mm:ss zzz
 */
+ (NSDate * )skyerNSStringToNSDate: (NSString * )string dateFormat:(NSString *)dateFormat;
//1970年到现在的秒数转换成时间显示
+ (NSString *)skyerBySecondGetDate:(NSString *)second dateFormat:(NSString *)dateFormat;
//1970年到现在的时间转换成秒数显示
+ (NSString *)skyerBydateGetSecond:(NSDate *)date;
@end
