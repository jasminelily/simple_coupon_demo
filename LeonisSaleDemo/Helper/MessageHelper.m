//
//  MessageHelper.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 9/3/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import "MessageHelper.h"
#import "CCCustomContentAlertView.h"

@implementation MessageHelper

+(void)showErrorMessage:(NSString*)msg{
    [self showErrorMessageWithTitle:nil withMessage:msg withAfterBlock:nil];
}

+(void)showErrorMessageWithTitle:(NSString*)title withMessage:(NSString*)msg withAfterBlock:(CCAfter)afterBlcok{
    
    [self showMessageWithTitle:title withMessage:msg isSuccessMsg:NO withAfterBlock:afterBlcok];
}

+(void)showSuccessMessageWithTitle:(NSString*)title withMessage:(NSString*)msg withAfterBlock:(CCAfter)afterBlcok{
    
    [self showMessageWithTitle:title withMessage:msg isSuccessMsg:YES withAfterBlock:afterBlcok];
}

+(void)showMessageWithTitle:(NSString*)title withMessage:(NSString*)msg isSuccessMsg:(BOOL)isSuccess withAfterBlock:(CCAfter)afterBlcok{
    int type = 0;
    if (isSuccess) {
        type = CCCustomContentAlertViewType_Message;
    }else{
        type = CCCustomContentAlertViewType_ErrorMsg;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CCCustomContentAlertView * alertView = [[CCCustomContentAlertView alloc] initWithTitle:title withType:type withText:msg];
        [alertView configureCompleteBlock:^{
            if (afterBlcok != nil) {
                afterBlcok();
            }
            
        }];
        [alertView show];
    });
    
    
}

@end
