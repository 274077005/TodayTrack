//
//  MainViewController.m
//  skyer
//
//  Created by odier on 2016/11/30.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initTableViews{
    UIViewController *view1=[self.storyboard instantiateViewControllerWithIdentifier:@"FirstViewControllerNa"];
    view1.tabBarItem.image=[UIImage imageNamed:@"V2_0_tabqx"];
    view1.tabBarItem.title=@"骑行";
    
    UIViewController *view2=[self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewControllerNa"];
    view2.tabBarItem.image=[UIImage imageNamed:@"V2_0_tabsb"];
    view2.tabBarItem.title=@"轨迹";
    
    UIViewController *view3=[self.storyboard instantiateViewControllerWithIdentifier:@"ThirdViewControllerNa"];
    view3.tabBarItem.image=[UIImage imageNamed:@"V2_0_tabtx"];
    view3.tabBarItem.title=@"线路";
    
    
    UIViewController *view4=[self.storyboard instantiateViewControllerWithIdentifier:@"QQStepViewControllerNa"];
    view4.tabBarItem.image=[UIImage imageNamed:@"v2_0_tabwd"];
    view4.tabBarItem.title=@"刷步";
    
    if ([self isShowQQstep]) {
        self.viewControllers=@[view1,view2,view3];
    }else{
        self.viewControllers=@[view1,view2,view3,view4];
    }
    
}
- (BOOL)isShowQQstep{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateLast = [dateFormatter dateFromString:@"2017-07-1"];
    NSDate *today=[NSDate date];
    NSDate *data=[today earlierDate:dateLast];
    return [data isEqualToDate:today];
}

@end
