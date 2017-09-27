//
//  SkyerHUD.m
//  skyer
//
//  Created by odier on 2016/12/12.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkyerHUD.h"
static MBProgressHUD *HUD;
@implementation SkyerHUD
+(void)skyerShowToast:(NSString *)title{
    [SkToast SkToastShow:title];
}

+(void) skyerShowProgress:(NSString *)title{
    HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.labelText = title;
    [HUD show:YES];
}
+(void) skyerRemoveProgress{
    [HUD hide:YES];
    [HUD removeFromSuperViewOnHide];
}
@end
