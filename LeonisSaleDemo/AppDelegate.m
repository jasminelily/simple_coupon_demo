//
//  AppDelegate.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/22/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import "AppDelegate.h"
#import "CenterViewController.h"

#import "DEMONavigationController.h"
#import "LeftViewController.h"
#import "REFrostedViewController.h"

@interface AppDelegate ()<UINavigationControllerDelegate>
@property (nonatomic,strong) CenterViewController* centerViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setAppearance];
    [self setViewController];
    
    //for custom coupon shake
    application.applicationSupportsShakeToEdit = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}

-(void)setViewController{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _centerViewController = [[CenterViewController alloc] init];
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:_centerViewController];
    navigationController.delegate = self;
    LeftViewController *menuController = [[LeftViewController alloc] init];
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.panGestureEnabled = YES;
    
    // Make it a root controller
    //
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

-(void)setAppearance{
    [[UINavigationBar appearance] setBarTintColor:TOPBAR_BACK_COLOR];
    NSDictionary *topbar = @{
                             NSForegroundColorAttributeName: TOPBAR_TEXT_FONT_COLOR,
                             NSFontAttributeName:[UIFont boldSystemFontOfSize:TOPBAR_TEXT_FONT_SIZE]
                             };
    [[UINavigationBar appearance] setTitleTextAttributes:topbar];
    
    //-----UIStatusBar Text Color
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //戻りボタン
    if([navigationController.viewControllers count] > 1){
        [ViewHelper customBackButton:viewController withClickBlock:^{
            [viewController.navigationController popViewControllerAnimated:NO];
        }];
    }else{
        [ViewHelper customHomeButton:viewController withClickBlock:^{
            [((DEMONavigationController*)navigationController) showMenu];
        }];
    }
}

@end
