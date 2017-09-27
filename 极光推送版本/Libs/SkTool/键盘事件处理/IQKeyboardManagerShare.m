//
//  IQKeyboardManagerShare.m
//  skyer
//
//  Created by odier on 2016/11/30.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "IQKeyboardManagerShare.h"
#import "IQKeyboardManager.h"

@implementation IQKeyboardManagerShare
+(void)initIQKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = YES;
    manager.toolbarManageBehaviour=IQAutoToolbarByPosition;
}
@end
