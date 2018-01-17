//
//  NSString+skStrWidth.h
//  GpsDuplicate
//
//  Created by SoKing on 2017/11/28.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSString (skStrWidth)

/**
 计算文本的CGSize

 @param text 需要计算的文本
 @param width 最大的宽度设置
 @param size 字体的siez
 @return 返回文本的CGSize
 */
-(CGSize)skTitleSize:(NSString *)text
             labWidth:(CGFloat)width
          fontOfSize:(CGFloat)size;

/**
 MD5加密

 @return 返回加密后的字符
 */
-(id)MD5;
@end
