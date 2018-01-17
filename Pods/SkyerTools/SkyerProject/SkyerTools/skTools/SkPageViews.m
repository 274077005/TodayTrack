//
//  SkScollPageView.m
//  skyer
//
//  Created by odier on 16/8/3.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkPageViews.h"



@implementation SkPageViews

-(instancetype)initWithFrame:(CGRect)frame andArrViews:(NSArray*)arrViews andSelecetIndex:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self){
        _indexSelect=index;
        
        CGFloat Width = self.bounds.size.width;
        CGFloat Height = self.bounds.size.height;
        self.delegate=self;
        //设置分页
        self.pagingEnabled = YES;
        //设置滚动范围
        self.contentSize = CGSizeMake(Width *arrViews.count, Height);
        //设置初始偏移量（可以设置开始在第几页）
        [self skChangPage:_indexSelect];
        //滚动到边缘的弹簧效果
        self.bounces = YES;
        //隐藏滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator=NO;
        //添加要显示的View
        for (int i = 0; i< arrViews.count; ++i) {
            if ([[arrViews objectAtIndex:i] isKindOfClass:[UIViewController class]]) {
                
                UIViewController *view=[arrViews objectAtIndex:i];
                
                view.view.frame=CGRectMake(i*Width, 0, Width, Height);
                
                [self addSubview:view.view];
                
            }else{
                UIView *view=[arrViews objectAtIndex:i];
                
                view.frame=CGRectMake(i*Width, 0, Width, Height);
                
                [self addSubview:view];
            }
        }
    }
    return self;
}

#pragma mark - 设置偏移在哪一页
/*int page
 *设置页面位置
 */
- (void)skChangPage:(NSInteger)page{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = CGPointMake(([UIScreen mainScreen].bounds.size.width) * page, 0);
    }];
}
#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
    _indexSelect=scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (_indexBlock) {
        _indexBlock(_indexSelect);
    }
    
}


@end
