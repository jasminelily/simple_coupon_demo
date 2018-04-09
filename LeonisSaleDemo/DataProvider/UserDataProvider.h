//
//  UserDataController.h
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/7/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseDataProvider.h"

@interface UserDataProvider : BaseDataProvider

+(void)requestDataWithType:(int)type withParameter:(NSDictionary*)parameters complate:(RequestSingleDataAfterRquest)block;

@end
