//
//
//  skyer
//
//  Created by odier on 16/8/3.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SkScollPageView : UIScrollView <UIScrollViewDelegate>


typedef void (^pageIndex) (NSInteger page);

@property (nonatomic,copy) pageIndex pageIndex;

- (void)initScollPageView: (NSArray *)arrViews;

- (void)scrollViewWithContentOffSetPage:(NSInteger)page;

- (void)setPageIndex:(pageIndex)pageIndex;

@end
