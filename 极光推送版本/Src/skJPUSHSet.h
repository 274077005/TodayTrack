//
//  skJPUSHSet.h
//  GpsDuplicate
//
//  Created by SoKing on 2017/11/28.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkyerSingleton.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface skJPUSHSet : NSObject <JPUSHRegisterDelegate>
SkyerSingletonH(skJPUSHSet)
/**
 极光推送的配置(AppDelegate的didFinishLaunchingWithOptions中调用)

 @param launchOptions 需要的参数
 */
- (void)skJpushSet:(NSDictionary * _Nullable)launchOptions;

/**
 接收到极光推送的消息

 @param info 详情信息
 */
-(void)skReceiveJPUSH:(NSDictionary *_Nullable)info;
@end
