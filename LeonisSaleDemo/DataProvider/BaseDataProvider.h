//
//  BaseDataController.h
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/7/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDataProvider : NSObject

+(RequestDataCode)checkResult:(NSDictionary*)datas;

@end
