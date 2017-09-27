//
//  RouteBookViewController.h
//  skyer
//
//  Created by odier on 2016/12/8.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface RouteBookViewController : UIViewController <MAMapViewDelegate, AMapSearchDelegate,UITextFieldDelegate>

- (IBAction)segment:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (strong, nonatomic) IBOutlet MAMapView *mapView;
@property (strong, nonatomic) UIButton *btnCenter;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
- (IBAction)btnClear:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLook;
- (IBAction)btnLook:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtSearch;


@end
