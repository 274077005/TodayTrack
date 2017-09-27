//
//  SkToast.h
//  skyer
//
//  Created by odier on 16/8/5.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - 调用Toast的类
@class Toast;

@interface SkToast : NSObject

+ (void)SkToastShow:(NSString *)title withHight:(CGFloat) hight;
+ (void)SkToastShow:(NSString *)title;

@end

#pragma mark - 这里是实现toast的类
@interface Toast :NSObject

@property (nonatomic, strong) UILabel *labToast;
@property Boolean bShow;


/*默认的初始化toast
 *title 为需要显示的文字
 *hight 目前离最下位置的距离+hight
 */
- (void)initToastView:(NSString *)title
            withHight:(CGFloat) hight;

+ (instancetype)shared;

@end
