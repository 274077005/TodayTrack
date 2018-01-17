//
//  UIButton+ClickBlock.m
//  skyer工程集合
//
//  Created by SoKing on 2017/8/1.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import "UIButton+ClickBlock.h"
#import <objc/runtime.h>

static const void *associatedKey = "associatedKey";

@implementation UIButton (ClickBlock)

-(void)setClick:(click)click{
    
    objc_setAssociatedObject(self, associatedKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self removeTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (click) {
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

-(click)click{
    return objc_getAssociatedObject(self, associatedKey);
}

-(void)buttonClick{
    if (self.click) {
        self.click();
    }
}

@end
