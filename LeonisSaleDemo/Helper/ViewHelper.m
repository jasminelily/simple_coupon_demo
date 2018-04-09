//
//  ViewHelper.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import "ViewHelper.h"
#import "CCCustomContentAlertView.h"
#import "ConvertHelper.h"


@implementation ViewHelper

+(void)resetView:(UIView *)view originY:(float)originY{
    CGRect frame = view.frame;
    frame.origin.y = originY;
    view.frame = frame;
}

+(void)resetViewCenter:(UIView*)view{
    view.center = CGPointMake(CGRectGetWidth(view.superview.frame)*0.5,CGRectGetHeight(view.superview.frame)*0.5);
}

+(CGSize)calImageSize:(float)width withOriginSize:(CGSize)size{
    
    double scale = width / size.width;
    CGSize rctSizeFinal = CGSizeMake(size.width * scale,size.height * scale);
    
    return rctSizeFinal;
    
}

+(void)customClosekButton:(UIViewController*)viewController withClickBlock:(ClickActionBlock)clickAction{
    [self customButtonWithImage:@"close" withPosition:CCTopBarButton_Type_Left inView:viewController withClickBlock:clickAction];
}

+(void)customBackButton:(UIViewController*)viewController withClickBlock:(ClickActionBlock)clickAction{
    [self customButtonWithImage:@"back" withPosition:CCTopBarButton_Type_Left inView:viewController withClickBlock:clickAction];
}

+(void)customHomeButton:(UIViewController*)viewController withClickBlock:(ClickActionBlock)clickAction{
    [self customButtonWithImage:@"other" withPosition:CCTopBarButton_Type_Left inView:viewController withClickBlock:clickAction];
}

+(void)customButtonWithImage:(NSString*)imageName withPosition:(int)positionType inView:(UIViewController*)viewController withClickBlock:(ClickActionBlock)clickAction{
    
    CGSize size = TOPBAR_BTN_SIZE;
    CCTopBarButton * button = [[CCTopBarButton alloc] initWithFrame:CGRectMake(0, 0,size.width,size.height) withType:positionType];
    
    UIView * back = [[UIView alloc] initWithFrame:button.frame];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,size.width,size.height)];
    if (positionType == CCTopBarButton_Type_Left) {
        icon.contentMode = UIViewContentModeLeft;
    }else{
        icon.contentMode = UIViewContentModeRight;
    }
    icon.image = [UIImage imageNamed:imageName];
    icon = [ConvertHelper changeImage:icon withColor:TOPBAR_ICON_COLOR];
    
    [icon addSubview:button];
    button.alpha = 0.3;
    
    [back addSubview:icon];
    [back addSubview:button];
    
    switch (positionType) {
        case CCTopBarButton_Type_Left:
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
            break;
        case CCTopBarButton_Type_Right:
            viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
            break;
            
        default:
            break;
    }
    
    [button handleControlEvent:UIControlEventTouchUpInside|UIControlEventTouchUpOutside withBlock:clickAction];
    
}

+(CCLabel*)createLabel:(CGRect)frame withText:(NSString*)txt isTextBold:(BOOL)isBold{
    CCLabel *lbl = [[CCLabel alloc] initWithFrame:frame];
    
    if (isBold) {
        lbl.font = [UIFont boldSystemFontOfSize:SYSTEM_FONT_SIZE_TEXT];
    }else{
        lbl.font = [UIFont systemFontOfSize:SYSTEM_FONT_SIZE_TEXT];
    }
    
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = SYS_COLOR_TEXT;
    
    if (txt != nil) {
        lbl.text = txt;
    }
    return lbl;
}

@end
