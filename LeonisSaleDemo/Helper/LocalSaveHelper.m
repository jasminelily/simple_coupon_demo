//
//  LocalSaveHelper.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/15/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import "LocalSaveHelper.h"

@implementation LocalSaveHelper

+(UserModel*)getUserInfo{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFALUTS_USER_INFO];
    UserModel * user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return user;
}

+(BOOL)saveUserInfo:(UserModel*)user{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:USERDEFALUTS_USER_INFO];
    return  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
