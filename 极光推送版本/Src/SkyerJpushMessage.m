//
//  SkyerJpushMessage.m
//  极光推送版本
//
//  Created by SoKing on 2017/5/25.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import "SkyerJpushMessage.h"

@implementation SkyerJpushMessage

SkyerSingletonM(SkyerJpushMessage)

//获得的推送信息
- (void)skyerGerMessage:(NSDictionary *)message{

    NSLog(@"推送得到的消息%@",message);
    NSString *key=[message objectForKey:@"key"];
    NSArray *arrValue=@[@"激活",@"试用",@"免费"];
    
    if ([arrValue containsObject:key]) {
        [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"key"];
        if ([key isEqualToString:@"试用"]) {
            NSDate *tryDate = [[NSDate date] initWithTimeInterval:2*24*60 *60 sinceDate:[NSDate date]];
            NSString *dateString=[self dateToString:tryDate];
            [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"tryDate"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
//推送过来的使用状态（激活、试用、免费这三种会做处理，其他的话就默认是系统消息）
- (NSString *)skyerGerMessageKeyValue{
    NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
    NSArray *arrValue=@[@"激活",@"试用",@"免费"];
    if (![arrValue containsObject:value]) {
        value=@"免费";
    }
    value=@"激活";
    return value;
}
//这个是试用时间
- (NSString *)skyerGerTryDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"tryDate"];
}
//是否在试用期
- (BOOL)userTryoutTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateLast = [dateFormatter dateFromString:[self skyerGerTryDate]];
    
    NSDate *today=[NSDate date];
    
    NSDate *data=[today earlierDate:dateLast];
    
    return [data isEqualToDate:today];
}




-(NSString *)dateToString:(NSDate*) date{
    // 将当前时间以字符串形式输出
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

- (NSDate*)stringToDate:(NSString *)string{
    //由 NSString 转换为 NSDate:
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

@end
