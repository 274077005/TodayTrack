//
//  RouteDetailsViewController.h
//  skyer
//
//  Created by odier on 2016/12/13.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface RouteDetailsViewController : UIViewController <MAMapViewDelegate>

@property (nonatomic ,strong) NSDictionary *dicTrack;

@end
