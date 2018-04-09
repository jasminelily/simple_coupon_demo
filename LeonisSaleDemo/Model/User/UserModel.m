//
//  UserModel.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright © 2014 Leonis&Co. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDictionary:(NSDictionary *)apiData
{
    self = [super initWithDictionary:apiData];
    if (self) {
        _groupName = [apiData objectForKey:@"groupName"];
        _userNumber = [apiData objectForKey:@"userNumber"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _groupName = [decoder decodeObjectForKey:@"groupName"];
        _userNumber = [decoder decodeObjectForKey:@"userNumber"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_groupName forKey:@"groupName"];
    [encoder encodeObject:_userNumber forKey:@"userNumber"];
}

@end
