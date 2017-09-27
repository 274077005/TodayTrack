//
//  SkToast.m
//  skyer
//
//  Created by odier on 16/8/5.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkToast.h"
#define SKmScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define SKmScreenHeight         ([UIScreen mainScreen].bounds.size.height)

@implementation SkToast
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
+ (void)SkToastShow:(NSString *)title{
    [self SkToastShow:title withHight:0];
}
+ (void)SkToastShow:(NSString *)title withHight:(CGFloat) hight{
    Toast *toast=[Toast shared];
    
    [toast initToastView:title withHight:hight];
}


@end


@implementation Toast

+ (instancetype)shared {
    static id __staticObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [Toast new];
    });
    return __staticObject;
}


- (instancetype)init
{
    if (self = [super init]) {
        _labToast=[[UILabel alloc] init];
    }
    return self;
}

- (void)initToastView:(NSString *)title withHight:(CGFloat)hight{
    
    if (!_bShow) {
        _bShow=YES;
        
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(SKmScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGFloat labHight=100+hight;
        
        _labToast.frame =CGRectMake(SKmScreenWidth/2-titleSize.width/2-10, SKmScreenHeight-labHight, titleSize.width+20, 25);
        _labToast.textAlignment=1;
        _labToast.text=title;
        _labToast.numberOfLines=2;
        _labToast.alpha=0.6;//修改一下透明度
        _labToast.font=[UIFont systemFontOfSize:14];//字体的大小
        _labToast.backgroundColor=[UIColor blackColor];
        _labToast.textColor=[UIColor whiteColor];
        _labToast.layer.cornerRadius=5;//圆角大小
        _labToast.layer.masksToBounds=YES;
        _labToast.layer.borderWidth=0;//边线宽度
        
        UIColor *borderColor=[UIColor grayColor];
        _labToast.layer.borderColor=[borderColor CGColor];
        
        
        [self animationWithView:_labToast duration:0.3];
        [window addSubview:_labToast];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _bShow=NO;
            [_labToast removeFromSuperview];
        });
    }
    
    
}

- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}
@end
