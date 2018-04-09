//
//  SuperViewController.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import <UIKit/UIKit.h>

//hidden navi
#import "UIViewController+NJKFullScreenSupport.h"
#import "NJKScrollFullScreen.h"

@interface SuperViewController : UIViewController<NJKScrollFullscreenDelegate>

@property (nonatomic,strong) NJKScrollFullScreen *scrollProxy;

@property (nonatomic,assign) int pageName;
@property (nonatomic,assign) int clickName;
@property (nonatomic,assign) BOOL isNoNeedRefresh;

//refresh
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) float loadingProccess;


-(UIView*)createNumberView;
-(void)setNumberViewWithNumber:(NSInteger)number;

//refresh
-(UIView*)createRefreshView;
-(void)calProccessCircle:(float)scrollY;
-(void)stopProccessCircle:(CCAfter)block;

-(void)startLoading;
-(void)stopLoading;

-(void)scrollToTop:(BOOL)animated;

//Override
-(void)afterSelectLeft:(int)pageType;
-(void)setPageTitle;


@end
