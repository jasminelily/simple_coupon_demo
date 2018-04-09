//
//  CenterViewController.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/22/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@protocol LeftViewDelegate
-(void)leftViewDidSelectRow:(int)rowType;
@end

@interface LeftViewController : UIViewController

@property (nonatomic,weak) id<LeftViewDelegate>leftDelegate;

@end
