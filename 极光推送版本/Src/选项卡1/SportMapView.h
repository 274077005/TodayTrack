//
//  SportMapView.h
//  skyer
//
//  Created by odier on 2016/12/14.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface SportMapView : UIView <MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (nonatomic ,strong) NSDictionary *dicTrack;

- (void)viewAppear;
- (void)viewDisAppear;
@end
