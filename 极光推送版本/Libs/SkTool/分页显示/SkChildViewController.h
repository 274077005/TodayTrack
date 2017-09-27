//
//  SkChildViewController.h
//  skyer
//
//  Created by odier on 16/8/4.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkChildViewController : NSObject

@property (nonatomic, strong) NSArray *arrChildViews;
@property (nonatomic, weak) UIViewController* containView;
@property (nonatomic, strong) UIViewController* TargetView;
@property (nonatomic, weak) UIViewController *mostUserView;
@property UIViewAnimationOptions options;


/*
 *添加显示页面的方法
 *childViewsArray 是要显示的页面数组
 *selfView 当前控制器
 */
- (void)addChildViewControllers:(NSArray *)childViewsArray
                      addTarget:(UIViewController*)view
                     whitOption:(UIViewAnimationOptions) option;
/*修改显示的view
 *btnTag 显示的那页
 */
- (void)changVeiw:(NSInteger)btnTag;
/*移除所有子视图
 */
- (void)removeAllChildViewControllers;
@end
