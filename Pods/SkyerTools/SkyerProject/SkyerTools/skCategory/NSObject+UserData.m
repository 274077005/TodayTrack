//
//  NSObject+UserData.m
//  skyer工程集合
//
//  Created by SoKing on 2017/9/27.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import "NSObject+UserData.h"
#import <objc/runtime.h>

#define KuserInfoKey @"userData"

@implementation NSObject (UserData)

-(void)setUserData:(id)userData{
    objc_setAssociatedObject(self, KuserInfoKey, userData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(id)userData{
    return objc_getAssociatedObject(self, KuserInfoKey);
}
@end
