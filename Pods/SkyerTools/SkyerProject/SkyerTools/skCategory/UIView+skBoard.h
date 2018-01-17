//
//  UIView+skBoard.h
//  GpsDuplicate
//
//  Created by SoKing on 2017/11/24.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (skBoard)

/**
 设置view的边框

 @param Radius 圆角
 @param Width 宽度
 @param borderColor 边框的颜色
 */
-(void)skSetBoardRadius:(CGFloat)Radius Width:(CGFloat)Width andBorderColor:(UIColor *)borderColor;

/**
 给view添加一个basc动画

 @param view 无返回
 */
- (void)skCABasicAnimationForView:(UIView *)view;

/**
 给View自定义一个动画

 @param view 需要加动画的view
 @param duration 无返回
 */
- (void)skAnimationWithView:(UIView *)view duration:(CFTimeInterval)duration;
@end
