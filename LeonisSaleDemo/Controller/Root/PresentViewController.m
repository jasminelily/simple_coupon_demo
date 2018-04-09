//
//  PresentViewController.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 1/28/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import "PresentViewController.h"

#import "SiteOfferViewController.h"
#import "UserPhoneViewController.h"
#import "CCCustomContentAlertView.h"

#import "UrlConstant.h"

@interface PresentViewController()<UINavigationControllerDelegate>

@property (nonatomic)int type;

@property (nonatomic)UIViewController *presentView;
@property (nonatomic)UIViewController *baseView;

@end

@implementation PresentViewController

-(void)showViewType:(int)pageType inView:(UIViewController*)baseViewController{
    _baseView = baseViewController;
    _type = pageType;
    
    NSString *title = nil;
    switch (pageType) {
        case PageType_Site:
            _presentView = [[SiteOfferViewController alloc] initWithURLString:SITE_OFFER_URL];
            title = NSLocalizedString(@"TOP_LEFT_TITLE_SITE_OFFER", @"OFFERs特設サイト");
            break;
        case PageType_UserPhone:
            _presentView = [[UserPhoneViewController alloc] initWithStyle:UITableViewStyleGrouped];
            title = NSLocalizedString(@"TOP_LEFT_TITLE_USER_PHONE", @"端末情報");
            break;
        default:
            break;
    }
    
    _presentView.title = title;
    [self showPresentView];
}

-(void)showPresentView{
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_presentView];
    
    if (_type != PageType_Site) {
        
        if ([navigationController.navigationBar respondsToSelector:@selector(setTranslucent:)]) {
            [navigationController.navigationBar setTranslucent:NO];
        }
    }
    navigationController.delegate = self;
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [_baseView presentViewController:navigationController animated:YES completion:nil];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //閉じるボタン
    if([viewController.navigationController.viewControllers count] <= 1){
        
        [ViewHelper customClosekButton:viewController withClickBlock:^{
            [viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }else{
        [ViewHelper customBackButton:viewController withClickBlock:^{
            [viewController.navigationController popViewControllerAnimated:YES];
        }];
    }
    
}


@end
