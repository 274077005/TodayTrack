//
//  SkChildViewController.m
//  skyer
//
//  Created by odier on 16/8/4.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkChildViewController.h"

@implementation SkChildViewController
- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}



#pragma mark - privatemethods
- (void)addChildViewControllers:(NSArray *)childViewsArray addTarget:(UIViewController*)view whitOption:(UIViewAnimationOptions) option{
    _TargetView=view;
    _arrChildViews=childViewsArray;
    _options=option;
    
    for (int i = 0; i<_arrChildViews.count; ++i) {
        _mostUserView=[_arrChildViews objectAtIndex:i];
        [_TargetView addChildViewController:_mostUserView];
    }
    //设置默认显示在容器View的内容
    _mostUserView=[childViewsArray firstObject];
    [_TargetView.view  addSubview:_mostUserView.view];
    _containView=_mostUserView;
}

#pragma mark - 修改界面

- (void)changVeiw:(NSInteger)btnTag {
    for (int i = 0; i<_arrChildViews.count; ++i) {
        if (btnTag==i) {
            _mostUserView=[_arrChildViews objectAtIndex:i];
            if (_containView==_mostUserView&&btnTag==i) {
                return;
            }
            UIViewController *oldViewController=_containView;
            [self tranSitionFromViewController:oldViewController andTheChangViewController:_mostUserView];
        }
    }
    
}
- (void)tranSitionFromViewController:(UIViewController *)oldViewController andTheChangViewController:(UIViewController *)changView{
    
    [_TargetView transitionFromViewController:_containView toViewController:changView duration:0.5 options:_options animations:^{
        
    }  completion:^(BOOL finished) {
        if (finished) {
            _containView=changView;
        }else{
            _containView=oldViewController;
        }
    }];
    
}
//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    
    for (UIViewController *vc in _TargetView.childViewControllers) {
        
        [vc willMoveToParentViewController:nil];
        
        [vc removeFromParentViewController];
        
    }
}

@end
