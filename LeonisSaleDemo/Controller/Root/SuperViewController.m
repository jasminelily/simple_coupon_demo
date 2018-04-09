//
//  SuperViewController.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import "SuperViewController.h"

#import "LeftViewController.h"
#import "CCRefreshCircleView.h"
#import "CCCustomContentAlertView.h"

static const int REFRESH_VIEW_SIZE = 30;
static const float LAODING_SCROLL_MAX_Y = 60.0f;
static const float LAODING_ANIMATION_DURATION = 1.0f;

@interface SuperViewController ()<LeftViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)CCRefreshCircleView *refreshView;
@property (nonatomic,strong)CCCustomContentAlertView *loading;

@property (nonatomic,strong)UILabel * numberView;

@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ((LeftViewController*)self.frostedViewController.menuViewController).leftDelegate = self;
    _loading = [[CCCustomContentAlertView alloc] initWithType:CCCustomContentAlertViewType_ActivityIndicator];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setPageTitle];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self scrollToTop:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

#pragma mark -
#pragma mark Refresh
-(UIView*)createRefreshView{
    if (_refreshView == nil) {
        
        _refreshView = [[CCRefreshCircleView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - REFRESH_VIEW_SIZE)*0.5, REFRESH_VIEW_SIZE*-1, REFRESH_VIEW_SIZE, REFRESH_VIEW_SIZE)];
        _refreshView.progress = 1;
        _refreshView.hidden = YES;
    }
    
    return _refreshView;
}

-(void)startLoading{
    _isLoading = YES;
    
    [_loading show];
}

-(void)stopLoading{
    
    _refreshView.hidden = YES;
    _isLoading = NO;
    
    [_loading dismiss];
}

-(void)refreshProcess:(CGFloat)process{
    _refreshView.hidden = NO;
    _refreshView.progress = process;
    [_refreshView setNeedsDisplay];
}

-(void)calProccessCircle:(float)scrollY{
    
    if (scrollY > 0) {
        return;
    }
    
    float moveY = fabsf(scrollY) - 64;//navi height
    float maxMove = LAODING_SCROLL_MAX_Y;
    if (moveY > maxMove){
        moveY = maxMove;
    }
    CGFloat process = moveY/maxMove;
    _loadingProccess = process;
    
    [self refreshProcess:process];
}

-(void)stopProccessCircle:(CCAfter)block{
    [UIView animateWithDuration:LAODING_ANIMATION_DURATION animations:^{
        _refreshView.hidden = YES;
    } completion:^(BOOL finished) {
        
        if (block) {
            block();
        }
    }];
}

#pragma mark -
#pragma mark number
-(UIView*)createNumberView{
    CGFloat height = 35;
    CGFloat left = 10;
    _numberView = [ViewHelper createLabel:CGRectMake(left, height * -1, CGRectGetWidth(self.view.frame) - left*2, height) withText:nil isTextBold:YES];
    _numberView.backgroundColor = TOPBAR_BACK_COLOR;
    _numberView.textColor = TOPBAR_TEXT_FONT_COLOR;
    _numberView.textAlignment = NSTextAlignmentCenter;
    _numberView.clipsToBounds = YES;
    _numberView.layer.cornerRadius = 5;
    _numberView.hidden = YES;
    
    return _numberView;
    
}

-(void)setNumberViewWithNumber:(NSInteger)number{
    
    _numberView.text =[NSString stringWithFormat:@"%ld件の%@があります",(long)number,[self getPageCountTitle]];
    _numberView.hidden = NO;
    _numberView.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        [ViewHelper resetView:_numberView originY:5];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionTransitionNone animations:^{
            [ViewHelper resetView:_numberView originY:CGRectGetHeight(_numberView.frame) * -1];
            _numberView.alpha = 0;
        } completion:^(BOOL finished){
            _numberView.hidden = YES;
        }];
    }];
}

#pragma mark -
#pragma mark Property
-(void)backFromDetail{
    _isNoNeedRefresh = YES;
}

#pragma mark -
#pragma mark Override
-(void)afterSelectLeft:(int)pageType{
    
}

#pragma mark -
#pragma mark Method

-(void)backToTop{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)leftViewDidSelectRow:(int)rowType{
    
    [self backToTop];
    
    self.clickName = rowType;
    
    [self setPageTitle];
    [self afterSelectLeft:self.clickName];
    
}

-(void)setPageTitle{
    
    NSString * title = nil;
    
    switch (self.pageName) {
        case PageType_Coupon:
            title = NSLocalizedString(@"TOP_TITLE_COUPON", @"クーポン");
            break;
        case PageType_Reco:
            title = NSLocalizedString(@"TOP_TITLE_RECOM", @"レコメンデーション");
            break;
       
        default:
            break;
    }
    
    if (title != nil) {
        self.title = title;
    }
    
}

-(NSString*)getPageCountTitle{
    NSString * title = nil;
    
    switch (self.pageName) {
       
        case PageType_Coupon:
            title = NSLocalizedString(@"TOP_TITLE_COUPON", @"クーポン");
            break;
        case PageType_Reco:
            title = NSLocalizedString(@"TOP_TITLE_RECOM", @"レコメンデーション");
            break;
        default:
            title = @"";
            break;
    }

    return title;
}

#pragma mark -
#pragma mark NJKScrollFullScreenDelegate

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
    [self moveToolbar:-deltaY animated:YES]; // move to revese direction
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    [self moveNavigationBar:deltaY animated:YES];
    [self moveToolbar:-deltaY animated:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    [self hideNavigationBar:YES];
    [self hideToolbar:YES];
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    [self showNavigationBar:YES];
    [self showToolbar:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_scrollProxy reset];
    [self showNavigationBar:YES];
    [self showToolbar:YES];
}

-(void)scrollToTop:(BOOL)animated{
    
    [_scrollProxy reset];
    [self showNavigationBar:animated];
    [self showToolbar:animated];
    
}
@end
