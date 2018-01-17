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

@property (nonatomic,copy) NSString *userType;

/**
 极光推送获取到的推送信息

 @param message 推送的消息
 */
- (void)skyerGerMessage:(NSDictionary *)message;
//设置试用时间
- (void)setTryTime:(NSInteger)time;

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

/**
 用户初始化获取用户激活信息
 */
-(void)skLoginGetUserType;
@end
