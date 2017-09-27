//
//  SkyerTool.m
//  skyer
//
//  Created by odier on 2016/12/2.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "skyerDateUse.h"
#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd HH:mm:ss")

@implementation skyerDateUse


//获取当前日期，时间
+(NSDate *)skyerGetCurrentDate{
    NSDate *now = [NSDate date];
    return now;
}



//将日期转换为字符串（日期，时间）
+(NSString *)skyerGetDateStringFromDate:(NSDate *)date{
    NSInteger location = 0;
    NSString *timeStr = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"HH:mm:a"];
    NSString *ampm = [[[formatter stringFromDate:date] componentsSeparatedByString:@":"] objectAtIndex:2];
    timeStr = [formatter stringFromDate:date];
    NSRange range = [timeStr rangeOfString:[NSString stringWithFormat:@":%@",ampm]];
    location = range.location;
    NSString *string = [timeStr substringToIndex:location];
    timeStr = [NSString stringWithFormat:@"%@ %@",ampm,string];
    
    
    NSString *dateStr = @"";
    NSDateFormatter *Dformatter = [[NSDateFormatter alloc] init];
    [Dformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [Dformatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [Dformatter stringFromDate:date];
    //    NSLog(@"%@", [NSString stringWithFormat:@"%@  %@",dateStr,timeStr]);
    return [NSString stringWithFormat:@"%@  %@",dateStr,timeStr];
}
//日期转字符串
+ (NSString * )skyerNSDateToNSString: (NSDate * )date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: dateFormat];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


//字符串转日期
+ (NSDate * )skyerNSStringToNSDate: (NSString * )string dateFormat:(NSString *)dateFormat
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: dateFormat];
    NSDate *date = [formatter dateFromString :string];
    return date;
}




//1970年到现在的秒数转换成时间显示

+ (NSString *)skyerBySecondGetDate:(NSString *)second dateFormat:(NSString *)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *dateLoca = [NSString stringWithFormat:@"%@",second];
    NSTimeInterval time=[dateLoca doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSString *timestr = [formatter stringFromDate:detaildate];
    return timestr;
}

+ (NSString *)skyerBydateGetSecond:(NSDate *)date{
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    return timeSp;
}

@end
