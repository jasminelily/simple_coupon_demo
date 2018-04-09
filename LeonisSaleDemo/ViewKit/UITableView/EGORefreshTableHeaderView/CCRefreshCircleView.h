//
//  CircleView.h
//  Demo8
//
//  Created by Leon on 11/15/13.
//  Copyright (c) 2013 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCRefreshCircleView : UIView

@property (nonatomic, assign) float progress;

-(void)startRotate;
-(void)stopRotate;
@end
