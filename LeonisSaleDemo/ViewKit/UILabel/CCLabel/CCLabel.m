//
//  CCLabel.m
//  GreenStamp
//
//  Created by leo-mobile-lily on 9/17/14.
//  Copyright (c) 2014 Leonisand. All rights reserved.
//

#import "CCLabel.h"

@implementation CCLabel

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByCharWrapping;
        
    }
    return self;
}

@end
