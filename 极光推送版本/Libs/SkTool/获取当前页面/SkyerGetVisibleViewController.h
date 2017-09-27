//
//  GetVisibleViewController.h
//  odierBike2015
//
//  Created by odier on 2016/11/15.
//  Copyright © 2016年 odier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkyerGetVisibleViewController : NSObject
+ (instancetype)sharedInstance;

- (UIViewController *)skyerVisibleViewController;//获取当前显示的页面

- (UIViewController*)skyerTopViewControllerWithRootViewController:(UIViewController*)rootViewController;
@end
