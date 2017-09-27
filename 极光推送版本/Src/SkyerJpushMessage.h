//
//  SkyerJpushMessage.h
//  极光推送版本
//
//  Created by SoKing on 2017/5/25.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkyerSingleton.h"

@interface SkyerJpushMessage : NSObject
SkyerSingletonH(SkyerJpushMessage)

/**
 极光推送获取到的推送信息

 @param message 推送的消息
 */
- (void)skyerGerMessage:(NSDictionary *)message;

/**
 截取出来的激活信息

 @return 返回激活信息
 */
- (NSString *)skyerGerMessageKeyValue;

/**
 试用期

 @return 返回试用时间字符
 */
- (NSString *)skyerGerTryDate;

/**
 判断是否在试用期

 @return 如果是yes就是试用期
 */
- (BOOL)userTryoutTime;

-(NSString *)dateToString:(NSDate*) date;
- (NSDate*)stringToDate:(NSString *)string;
@end
