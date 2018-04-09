//
//  BaseModelApi.m
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/7/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import "BaseModelApi.h"

NSString* const API_KEY_OUT_RESULT_CODE = @"code";

@implementation BaseModelApi

- (instancetype)initWithDictionary:(NSDictionary *)apiData
{
    self = [super init];
    if (self) {
        _resultCode = [[apiData objectForKey:API_KEY_OUT_RESULT_CODE] intValue];
    }
    return self;
}

@end
