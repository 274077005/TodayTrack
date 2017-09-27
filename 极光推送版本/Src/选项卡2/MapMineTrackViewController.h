//
//  MapMineTrackViewController.h
//  skyer
//
//  Created by odier on 2016/12/8.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface MapMineTrackViewController : UIViewController <MAMapViewDelegate>

@property (nonatomic, strong) NSArray *selectTrack;//选中的轨迹

@end
