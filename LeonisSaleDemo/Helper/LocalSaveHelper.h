//
//  LocalSaveHelper.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/15/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface LocalSaveHelper : NSObject

+(UserModel*)getUserInfo;
+(BOOL)saveUserInfo:(UserModel*)user;

@end
