//
//  GetVisibleViewController.h
//  odierBike2015
//
//  Created by odier on 2016/11/15.
//  Copyright © 2016年 odier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SkyerSingleton.h"

@interface SkGetVisibleViewController : NSObject
SkyerSingletonH(SkGetVisibleViewController)

/**
 获取当前页面

 @return 返回的是app显示的页面
 */
- (UIViewController *)skyerVisibleViewController;//获取当前显示的页面


@end
