//
//  CCHiddenNaviWebVIewController.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 2/12/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import "CCHiddenNaviWebVIewController.h"

//hidden navi
#import "UIViewController+NJKFullScreenSupport.h"
#import "NJKScrollFullScreen.h"

@interface CCHiddenNaviWebVIewController ()<NJKScrollFullscreenDelegate>
@property (nonatomic) NJKScrollFullScreen *scrollProxy;
@end

@implementation CCHiddenNaviWebVIewController


-(id)init{
    self = [super init];
    
    if (self) {
        self.loadingBarTintColor = SYS_COLOR;
        self.buttonTintColor = SYS_COLOR;
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self.webView];
    
    self.webView.scrollView.delegate = _scrollProxy;
    _scrollProxy.delegate = self;

}

#pragma mark -
#pragma mark NJKScrollFullScreenDelegate

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
//    [self moveToolbar:-deltaY animated:YES]; // move to revese direction
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
//    [self moveToolbar:-deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
//    [self hideToolbar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
//    [self showToolbar:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_scrollProxy reset];
    [self showNavigationBar:YES];
//    [self showToolbar:YES];
}

@end
