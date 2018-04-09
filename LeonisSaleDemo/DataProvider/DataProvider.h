//
//  DataController.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 1/27/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DataProvider : NSObject

+(void)requestDataWithPageType:(int)pageType complate:(RequestListDataAfterRquest)block;
+(void)requestDataWithPageType:(int)pageType withParameter:(NSDictionary*)parameters complate:(RequestListDataAfterRquest)block;

+(void)requestDataWithDataType:(int)dateType complate:(RequestListDataAfterRquest)block;
+(void)requestDataWithDataType:(int)dataType withParameter:(NSDictionary*)parameters complate:(RequestListDataAfterRquest)block;
@end
