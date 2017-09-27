//
//  SkyerUIFactory.h
//  skyer
//
//  Created by odier on 2016/11/30.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkyerUIFactory : NSObject
/*新建UILabel
 */
+ (UILabel *)skUILabelInitWithText:(NSString *)text
                   backgroundColor:(UIColor *)backgroundColor
                     textAlignment:(NSTextAlignment)textAlignment
                         textColor:(UIColor *) textColor
                          fontSize:(CGFloat)size
                     numberOfLines:(NSInteger)numberOfLines;
/*新建UIButton
 */
+(UIButton *) skUIButtonInitWithText:(NSString *)text
                          fontOfSize:(CGFloat)size
                           textColor:(UIColor *)textColor
                     backgroundColor:(UIColor *)backgroundColor;

/*计算文本的宽度
 */
+ (CGSize)sktitleSize:(NSString *)text
             labWidth:(CGFloat)width
           fontOfSize:(CGFloat)size;

/*设置控件的边框
 */
+(void)skSetViewsBorde:(UIView*)View
           BorderWidth:(CGFloat)Width
                Radius:(CGFloat)Radius
        andBorderColor:(UIColor*)borderColor;
@end
