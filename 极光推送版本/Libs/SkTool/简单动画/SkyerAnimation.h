//
//  SkyerAnimation.h
//  MyApp
//
//  Created by odier on 2016/11/11.
//  Copyright © 2016年 Skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkyerAnimation : NSObject
+ (instancetype)sharedInstance;
- (void) skTransitionWithType:(NSString *) type
                  WithSubtype:(NSString *) subtype
                     ForView : (UIView *) view;

- (void)skAnimationWithView:(UIView *)view duration:(CFTimeInterval)duration;
@end
