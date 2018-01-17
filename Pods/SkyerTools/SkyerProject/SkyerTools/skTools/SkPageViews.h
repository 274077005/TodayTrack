//
//
//  skyer
//
//  Created by odier on 16/8/3.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SkPageViews : UIScrollView <UIScrollViewDelegate>

@property (nonatomic,assign)NSInteger indexSelect;

/**
 回调进入了哪个界面
 */
@property (nonatomic,copy) void (^indexBlock)(NSInteger index);

/**
 初始化分页

 @param arrViews 需要添加的页面数组
 @param index 需要显示的页面
 */
-(instancetype)initWithFrame:(CGRect)frame andArrViews:(NSArray*)arrViews andSelecetIndex:(NSInteger)index;

/**
 修改页面

 @param page 需要修改的下标
 */
- (void)skChangPage:(NSInteger)page;
@end
