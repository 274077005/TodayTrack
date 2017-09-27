//
//  GetVisibleViewController.m
//  odierBike2015
//
//  Created by odier on 2016/11/15.
//  Copyright © 2016年 odier. All rights reserved.
//

#import "SkyerGetVisibleViewController.h"

@implementation SkyerGetVisibleViewController
//全局变量
static id _instance = nil;
//单例方法
+(instancetype)sharedInstance{
    return [[self alloc] init];
}
////alloc会调用allocWithZone:
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}
- (UIViewController *)skyerVisibleViewController {
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [self getVisibleViewControllerFromRootView:rootViewController];
}

- (UIViewController *) getVisibleViewControllerFromRootView:(UIViewController *) rootViewController {
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFromRootView:[((UINavigationController *) rootViewController) visibleViewController]];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFromRootView:[((UITabBarController *) rootViewController) selectedViewController]];
    } else {
        if (rootViewController.presentedViewController) {
            return [self getVisibleViewControllerFromRootView:rootViewController.presentedViewController];
        } else {
            return rootViewController;
        }
    }
}


- (UIViewController*)skyerTopViewControllerWithRootViewController:(UIViewController*)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self skyerTopViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self skyerTopViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self skyerTopViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
    
}

@end
