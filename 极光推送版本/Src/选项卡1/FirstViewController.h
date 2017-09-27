//
//  FirstViewController.h
//  skyer
//
//  Created by odier on 2016/11/30.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labSpeed;

@property (weak, nonatomic) IBOutlet UILabel *labMileage;

@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property (weak, nonatomic) IBOutlet UILabel *labAverageSpeed;

- (IBAction)btnRunAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnRunAction;

@property (weak, nonatomic) IBOutlet UIView *ViewAdd;


@property (weak, nonatomic) IBOutlet UILabel *labTodayStep;

@end
