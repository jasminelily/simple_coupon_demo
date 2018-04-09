//
//  CheckHelper.m
//  KoseBeauty
//
//  Created by leo-mobile-lily on 6/30/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import "CheckHelper.h"
#import "CCCustomContentAlertView.h"


#define REGEX_FOR_INTEGERS  @"^([+-]?)(?:|0|[0-9]\\d*)?$"
#define IS_AN_INTEGER(string) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_FOR_INTEGERS] evaluateWithObject:string]

@implementation CheckHelper

+(BOOL)isStringEmpty:(NSObject*)obj{
    if(obj ==  nil){
        return YES;
    }
    if([obj isKindOfClass:[NSString class]]){
        
        NSString * str = (NSString*)obj;
        
        NSString *trimmedString = [str stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        if(trimmedString.length == 0){
            return YES;
        }
    }
    return NO;
}

+(BOOL)isNumber:(NSString*)str{
    return IS_AN_INTEGER([ConvertHelper trimString:str]);
}


+(BOOL)isString:(NSString*)main ContainsOther:(NSString*)sub{
    if ([self isStringEmpty:main]) {
        return NO;
    }
    
    if ([main rangeOfString:sub].location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

@end
