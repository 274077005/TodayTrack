//
//  InitNavigationController.h
//  skyer
//
//  Created by odier on 2016/10/10.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkyerNavigationController : NSObject



+ (instancetype)sharedInstance;
//设置导航栏上面的状态了（信号，时间，电量的颜色）
//View controller-based status bar appearance 添加plist添加这个字段
- (void)setNavigationState;
/*
 *这个方法是在页面中调用
 */
- (void)setNavigation:(UIViewController *)addTarget;
/*
 *这个方法是在AppDelegate调用
 */
- (void)setNavigation;

/**
 *设置导航控制器带图片的左边按钮
 *selfVcV-》这个是要使用的控制器self
 *imageName-》图片的名称
 *return->一个按钮，用来设置按钮的点击事件
 */
-(UIButton*)SkSetNagLeftItem:(UIViewController*)selfView
                andImageName: (NSString *)imageName;

/**
 *设置导航控制器带图片的右边按钮
 *selfVcV-》这个是要使用的控制器self
 *imageName-》图片的名称
 *return->一个按钮，用来设置按钮的点击事件
 */
-(UIButton*)SkSetNagRightItem:(UIViewController*)selfView
                 andImageName: (NSString *)imageName;
/**
 *设置返回按钮的文字
 *selfVcV-》这个是要使用的控制器self
 *titleName文字名称
 */
-(void)SkSetNagBackBtnTitle:(UIViewController*)selfView
                  withTitle:(NSString *)titleName;
/**
 *设置右边的按钮的文字
 *selfVcV-》这个是要使用的控制器self
 *titleName文字名称
 */
-(UIButton *)SkSetNagRightBtnTitle:(UIViewController*)selfView
                         withTitle:(NSString *)titleName;
/*
 *使用图片作为导航栏的背景
 *imageName 背景图片名
 */
- (void)SkSetNagBackgroundImage:(UINavigationController*) nav
            backgroundImageName:(NSString *)imageNam;
@end
