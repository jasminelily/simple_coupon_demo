//
//  PresentViewController.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 1/28/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentViewControllerDelegate<NSObject>

-(void)presentViewDismissWithType:(int)type withData:(NSObject*)data;

@end

@interface PresentViewController : NSObject

@property (nonatomic,weak)id<PresentViewControllerDelegate> delegate;

-(void)showViewType:(int)pageType inView:(UIViewController*)baseViewController;

@end
