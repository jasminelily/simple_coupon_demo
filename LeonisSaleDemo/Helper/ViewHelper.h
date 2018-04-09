//
//  ViewHelper.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCTopBarButton.h"
#import "CCLabel.h"

@interface ViewHelper : NSObject

+(void)resetView:(UIView *)view originY:(float)originY;
+(void)resetViewCenter:(UIView*)view;

+(CGSize)calImageSize:(float)width withOriginSize:(CGSize)size;

+(void)customBackButton:(UIViewController*)viewController withClickBlock:(ClickActionBlock)clickAction;
+(void)customHomeButton:(UIViewController*)viewController withClickBlock:(ClickActionBlock)clickAction;
+(void)customClosekButton:(UIViewController*)viewController withClickBlock:(ClickActionBlock)clickAction;

+(CCLabel*)createLabel:(CGRect)frame withText:(NSString*)txt isTextBold:(BOOL)isBold;


@end
