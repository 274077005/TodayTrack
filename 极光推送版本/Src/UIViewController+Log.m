//
//  UIViewController+Log.m
//  极光推送版本
//
//  Created by SoKing on 2017/8/1.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import "UIViewController+Log.h"
#import<objc/runtime.h>

@implementation UIViewController (Log)

+ (void)load {
    
    //我们只有在开发的时候才需要查看哪个viewController将出现
    //所以在release模式下就没必要进行方法的交换
#ifdef DEBUG
    
    //原本的viewWillAppear方法
    
    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    
    //需要替换成 能够输出日志的viewWillAppear
    Method logViewWillAppear = class_getInstanceMethod(self, @selector(logViewWillAppear:));
    
    //两方法进行交换
    method_exchangeImplementations(viewWillAppear, logViewWillAppear);
    
#endif
    
}

- (void)logViewWillAppear:(BOOL)animated {
    
    NSString *className = NSStringFromClass([self class]);
    
    //在这里，你可以进行过滤操作，指定哪些viewController需要打印，哪些不需要打印
    
    NSLog(@"%@ will appear",className);
    
    //下面方法的调用，其实是调用viewWillAppear
    [self logViewWillAppear:animated];
}

@end
