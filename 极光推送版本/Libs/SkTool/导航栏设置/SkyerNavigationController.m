//
//  InitNavigationController.m
//  skyer
//
//  Created by odier on 2016/10/10.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkyerNavigationController.h"

@implementation SkyerNavigationController
//全局变量
static id _instance = nil;
//单例方法
+(instancetype)sharedInstance{
    return [[self alloc] init];
}
////alloc会调用allocWithZone:
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}
//设置导航栏上面的状态了（信号，时间，电量的颜色）
- (void)setNavigationState{
    
    [[UINavigationBar appearance] setTranslucent:NO];//适配IOS7以上的系统
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


//设置导航栏的各种属性
- (void)setNavigation:(UIViewController *)addTarget{
    //设置导航栏的颜色
    [addTarget.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    //设置导航栏标题的颜色和字体大小
    [addTarget.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    //设置返回按钮的文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    addTarget.navigationItem.backBarButtonItem = item;
    //设置返回按钮的文字颜色
    [addTarget.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}

//设置导航栏的背景颜色和文字颜色AppDelegate中使用就可以全局了
-(void)setNavigation{
    //设置NavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor lightGrayColor]];
    //@{}代表Dictionary
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"cebian.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}




/**
 *设置导航控制器带图片的左边按钮
 *selfVcV-》这个是要使用的控制器self
 *imageName-》图片的名称
 *return->一个按钮，用来设置按钮的点击事件
 */
-(UIButton*)SkSetNagLeftItem:(UIViewController*)selfView andImageName: (NSString *)imageName{
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [buttonBack setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
    selfView.navigationItem.leftBarButtonItem = btnBack;//为导航栏右侧添加系统自定义按钮
    return buttonBack;
}
/**
 *设置导航控制器带图片的右边按钮
 *selfVcV-》这个是要使用的控制器self
 *imageName-》图片的名称
 *return->一个按钮，用来设置按钮的点击事件
 */
-(UIButton*)SkSetNagRightItem:(UIViewController*)selfView andImageName: (NSString *)imageName{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithCustomView:button];
    selfView.navigationItem.rightBarButtonItem = btnBack;//为导航栏右侧添加系统自定义按钮
    return button;
}
/**
 *设置返回按钮的文字
 *selfVcV-》这个是要使用的控制器self
 *titleName文字名称
 */
-(void)SkSetNagBackBtnTitle:(UIViewController*)selfView withTitle:(NSString *)titleName{
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = titleName;
    selfView.navigationItem.backBarButtonItem = customLeftBarButtonItem;
}
/**
 *设置右边的按钮的文字
 *selfVcV-》这个是要使用的控制器self
 *titleName文字名称
 */
-(UIButton *)SkSetNagRightBtnTitle:(UIViewController*)selfView withTitle:(NSString *)titleName{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [button setTitle:titleName forState:UIControlStateNormal];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithCustomView:button];
    selfView.navigationItem.rightBarButtonItem = btnBack;//为导航栏右侧添加系统自定义按钮
    return button;
}
/*
 *使用图片作为导航栏的背景
 *imageName 背景图片名
 */
- (void)SkSetNagBackgroundImage:(UINavigationController*) nav backgroundImageName:(NSString *)imageName{
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:imageName]forBarMetrics:UIBarMetricsDefault];
}
@end
