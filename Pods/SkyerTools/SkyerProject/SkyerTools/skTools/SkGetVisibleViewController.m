//
//  GetVisibleViewController.m
//  odierBike2015
//
//  Created by odier on 2016/11/15.
//  Copyright © 2016年 odier. All rights reserved.
//

#import "SkGetVisibleViewController.h"

@implementation SkGetVisibleViewController
SkyerSingletonM(SkGetVisibleViewController)

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



@end
