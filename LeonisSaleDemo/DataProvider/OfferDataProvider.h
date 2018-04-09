//
//  OfferViewController.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataProvider.h"

@interface OfferDataProvider : NSObject

+(void)requestDataWithType:(int)type withParameter:(NSDictionary*)parameters complate:(RequestListDataAfterRquest)block;

@end
