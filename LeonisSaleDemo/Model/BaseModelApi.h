//
//  BaseModelApi.h
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/7/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface BaseModelApi : BaseModel

@property (nonatomic,assign) RequestDataCode resultCode;
@property (nonatomic,copy) NSString * resultMsg;

- (instancetype)initWithDictionary:(NSDictionary *)apiData;

@end
