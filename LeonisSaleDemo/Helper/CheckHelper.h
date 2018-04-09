//
//  CheckHelper.h
//  KoseBeauty
//
//  Created by leo-mobile-lily on 6/30/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConvertHelper.h"

@interface CheckHelper : NSObject

+(BOOL)isStringEmpty:(NSObject*)obj;
+(BOOL)isNumber:(NSString*)str;
+(BOOL)isString:(NSString*)main ContainsOther:(NSString*)sub;

@end
