//
//  StartAndEndPoint.m
//  skyer
//
//  Created by odier on 2016/12/8.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "StartAndEndPoint.h"
#import "SkyerUIFactory.h"

@implementation StartAndEndPoint

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0 ,26, 26);
        
        _labTitle = [[UILabel alloc] initWithFrame:self.bounds];
        _labTitle.font=[UIFont systemFontOfSize:10];
        _labTitle.textAlignment=1;
        _labTitle.backgroundColor=[UIColor whiteColor];
        [SkyerUIFactory skSetViewsBorde:_labTitle BorderWidth:1 Radius:13 andBorderColor:[UIColor lightGrayColor]];
        [self addSubview:_labTitle];
    }
    return self;
}

@end
