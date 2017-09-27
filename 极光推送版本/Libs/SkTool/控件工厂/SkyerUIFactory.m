//
//  SkyerUIFactory.m
//  skyer
//
//  Created by odier on 2016/11/30.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkyerUIFactory.h"

@implementation SkyerUIFactory

#pragma mark - UILabel创建
+ (UILabel *)skUILabelInitWithText:(NSString *)text
                   backgroundColor:(UIColor *)backgroundColor
                     textAlignment:(NSTextAlignment)textAlignment
                         textColor:(UIColor *) textColor
                          fontSize:(CGFloat)size
                     numberOfLines:(NSInteger)numberOfLines{
    
    UILabel *label=[[UILabel alloc] init];
    label.text=text;
    label.backgroundColor=backgroundColor;
    label.textAlignment=textAlignment;
    label.textColor=textColor;
    label.font=[UIFont systemFontOfSize:size];
    label.numberOfLines=numberOfLines;
    
    return label;
}
#pragma mark - UIButton创建
+(UIButton *) skUIButtonInitWithText:(NSString *)text
                          fontOfSize:(CGFloat)size
                           textColor:(UIColor *)textColor
                     backgroundColor:(UIColor *)backgroundColor{
    
    UIButton *btn=[[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:size];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn.backgroundColor=backgroundColor;
    return btn;
}


#pragma mark - 文本的size
+ (CGSize)sktitleSize:(NSString *)text
             labWidth:(CGFloat)width
           fontOfSize:(CGFloat)size{
    
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    
    return titleSize;
}
#pragma mark - 设置控件的边框
+(void)skSetViewsBorde:(UIView*)View
           BorderWidth:(CGFloat)Width
                Radius:(CGFloat)Radius
        andBorderColor:(UIColor*)borderColor{
    
    View.layer.cornerRadius=Radius;
    View.layer.masksToBounds=YES;
    View.layer.borderWidth=Width;
    View.layer.borderColor=[borderColor CGColor];
}

@end
