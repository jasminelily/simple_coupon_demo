//
//  UserModel.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright © 2014 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelApi.h"

@interface UserModel : BaseModelApi<NSCoding>

@property (nonatomic,copy) NSString * groupName;
@property (nonatomic,copy) NSString * userNumber;

- (instancetype)initWithDictionary:(NSDictionary *)data;

@end
