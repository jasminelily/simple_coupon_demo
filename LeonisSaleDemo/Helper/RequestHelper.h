//
//  RequestHelper.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright © 2014 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHelper : NSObject

+(void)requestApiUrl:(NSString*)url withParameters:(NSDictionary*)parameters complate:(RequestApiDataAfterRquest)block;

@end
