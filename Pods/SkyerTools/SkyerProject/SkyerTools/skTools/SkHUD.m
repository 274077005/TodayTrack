//
//  SkyerHUD.m
//  skyer
//
//  Created by odier on 2016/12/12.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkHUD.h"
static MBProgressHUD *HUD;
@implementation SkHUD
+(void)skyerShowToast:(NSString *)title{
    [SkToast SkToastShow:title withHight:200];
}

+(void) skyerShowProgOnWindow:(NSString *)title{
    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.label.text = title;
    [HUD showAnimated:YES];
}
+(void) skyerShowProgOnView:(NSString *)title{
    
    HUD = [[MBProgressHUD alloc] initWithView:skVSView.view];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.label.text = title;
    [HUD showAnimated:YES];
}
+(void) skyerRemoveProgress{
    [HUD hideAnimated:YES];
    [HUD removeFromSuperViewOnHide];
}
@end
