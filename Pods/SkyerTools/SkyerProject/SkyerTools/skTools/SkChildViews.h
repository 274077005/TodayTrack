//
//  SkChildViewController.h
//  skyer
//
//  Created by odier on 16/8/4.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkChildViews : NSObject

@property (nonatomic, strong) NSArray *arrChildViews;
@property (nonatomic, weak) UIViewController* containView;
@property (nonatomic, strong) UIViewController* TargetView;
@property (nonatomic, weak) UIViewController *mostUserView;
@property UIViewAnimationOptions options;


/**
 初始化添加子视图

 @param childViewsArr 子视图数组
 @param tagView 传入当前视图
 @param option 动画
 @return 初始化
 */
- (instancetype)initWithChildViews:(NSArray *)childViewsArr andTag:(UIViewController *)tagView andOption:(UIViewAnimationOptions)option;

/**
 根据下标改变显示的视图

 @param btnTag 需要显示的下标
 */
- (void)skChangVeiw:(NSInteger)btnTag;
/*移除所有子视图
 */
- (void)removeAllChildViewControllers;
@end
