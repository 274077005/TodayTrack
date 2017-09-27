//
//  MapTodayViewController.h
//  skyer
//
//  Created by odier on 2016/12/6.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface MapTodayViewController : UIViewController <MAMapViewDelegate>
@property (nonatomic ,strong) NSString *timeSelect;//进入这个界面传进来的数据



@end
