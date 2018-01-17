//
//  skClassMethod.h
//  GpsDuplicate
//
//  Created by SoKing on 2017/12/5.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkMacro.h"

@interface SkClassMethod : NSObject

/**
 UIAlertView的类方法

 @param title title
 @param message message
 @param cancalTitle 退出的文字
 @param sureTitle 确定的文字
 @param sureBlock 确定的回调
 */
+(void)skAlerView:(NSString *)title message:(NSString *)message cancalTitle:(NSString*)cancalTitle sureTitle:(NSString*)sureTitle sureBlock:(void(^)(void))sureBlock;
@end
