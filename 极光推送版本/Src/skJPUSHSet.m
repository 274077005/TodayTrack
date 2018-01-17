//
//  skJPUSHSet.m
//  GpsDuplicate
//
//  Created by SoKing on 2017/11/28.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import "skJPUSHSet.h"
#import "SkyerJpushMessage.h"
#import <AdSupport/AdSupport.h>


#define kjpushKey @"49387c68bd79abf22f7b630b"
#define kjpushChannel @"569965"
#define kjpushIsProduction YES


@implementation skJPUSHSet
SkyerSingletonM(skJPUSHSet)
#pragma mark 极光推送的初始化设置
- (void)skJpushSet:(NSDictionary * _Nullable)launchOptions {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:kjpushKey
                          channel:kjpushChannel
                 apsForProduction:kjpushIsProduction
            advertisingIdentifier:advertisingId];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            
            [[SkyerJpushMessage sharedSkyerJpushMessage] skLoginGetUserType];
            
            
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
            [[NSUserDefaults standardUserDefaults] setObject:@"退出软件再试一次" forKey:@"registrationID"];
        }
    }];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSLog(@"willPresentNotification");
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self skReceiveJPUSH:userInfo];
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户
    } else {
        // Fallback on earlier versions
    }
    
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"didReceiveNotificationResponse");
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self skReceiveJPUSH:userInfo];
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        completionHandler();  // 系统要求执行这个方法
    } else {
        // Fallback on earlier versions
    }
}


#pragma mark - 对收到的消息进行处理
-(void)skReceiveJPUSH:(NSDictionary *_Nullable)info{
    NSLog(@"收到了啥?=%@",info);
    [[SkyerJpushMessage sharedSkyerJpushMessage] skyerGerMessage:info];
}

@end
