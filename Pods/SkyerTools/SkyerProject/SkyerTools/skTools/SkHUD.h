//
//  SkyerHUD.h
//  skyer
//
//  Created by odier on 2016/12/12.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkToast.h"
#import "MBProgressHUD.h"
#import "SkMacro.h"



@interface SkHUD : NSObject

/**
 显示吐司

 @param title 要显示的文字
 */
+(void) skyerShowToast:(NSString *)title;

/**
 把进度提示显示在windows上

 @param title 要显示的文字
 */
+(void) skyerShowProgOnWindow:(NSString *)title;

/**
 把进度提示显示在当前的view
 
 @param title 要显示的文字
 */
+(void) skyerShowProgOnView:(NSString *)title;

/**
 移除hud
 */
+(void) skyerRemoveProgress;
@end
