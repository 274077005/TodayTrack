
//
//  UIButton+ClickBlock.h
//  skyer工程集合
//
//  Created by SoKing on 2017/8/1.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^click)(void);

@interface UIButton (ClickBlock)


@property (nonatomic ,copy)click click;

@end
