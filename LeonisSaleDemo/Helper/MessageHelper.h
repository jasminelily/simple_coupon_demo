//
//  MessageHelper.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 9/3/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageHelper : NSObject

+(void)showErrorMessage:(NSString*)msg;
+(void)showErrorMessageWithTitle:(NSString*)title withMessage:(NSString*)msg withAfterBlock:(CCAfter)afterBlcok;
+(void)showSuccessMessageWithTitle:(NSString*)title withMessage:(NSString*)msg withAfterBlock:(CCAfter)afterBlcok;
+(void)showMessageWithTitle:(NSString*)title withMessage:(NSString*)msg isSuccessMsg:(BOOL)isSuccess withAfterBlock:(CCAfter)afterBlcok;

@end
