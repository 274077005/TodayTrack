//
//  SkScollPageView.m
//  skyer
//
//  Created by odier on 16/8/3.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkScollPageView.h"



@implementation SkScollPageView
{
    NSInteger pageSelect;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

/*arrViews 是要显示的页面数组
 *初始化ScollPageView
 */
- (void)initScollPageView: (NSArray *)arrViews{
    
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat viewHeight = self.bounds.size.height;
    
    
    self.delegate=self;
    //设置分页
    self.pagingEnabled = YES;
    //设置滚动范围
    self.contentSize = CGSizeMake(viewWidth *arrViews.count, viewHeight);
    //设置初始偏移量（可以设置开始在第几页）
    [self scrollViewWithContentOffSetPage:0];
    //滚动到边缘的弹簧效果
    self.bounces = YES;
    //隐藏滚动条
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator=NO;
    //添加要显示的View
    for (int i = 0; i< arrViews.count; ++i) {
        
        UIView *view=[arrViews objectAtIndex:i];
        
        view.frame=CGRectMake(i*viewWidth, 0, viewWidth, viewHeight);
        
        [self addSubview:view];
        
    }
}

#pragma mark - 设置偏移在哪一页
/*int page
 *设置页面位置
 */
- (void)scrollViewWithContentOffSetPage:(NSInteger)page{
    self.contentOffset = CGPointMake(([UIScreen mainScreen].bounds.size.width) * page, 0);
}
#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
    pageSelect=scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (_pageIndex) {
        _pageIndex(pageSelect);
    }
}


-(void)setPageIndex:(pageIndex)pageIndex{
    _pageIndex=pageIndex;
}
@end
