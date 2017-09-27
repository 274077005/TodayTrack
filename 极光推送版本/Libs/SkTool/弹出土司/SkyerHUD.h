//
//  SkyerHUD.h
//  skyer
//
//  Created by odier on 2016/12/12.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkToast.h"
#import "MBProgressHUD.h"



@interface SkyerHUD : NSObject

+(void) skyerShowToast:(NSString *)title;

+(void) skyerShowProgress:(NSString *)title;

+(void) skyerRemoveProgress;
@end
