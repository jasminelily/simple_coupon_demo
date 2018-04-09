//
//  DataController.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 1/27/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import "DataProvider.h"
#import "OfferDataProvider.h"

@implementation DataProvider

+(void)requestDataWithDataType:(int)dataType complate:(RequestListDataAfterRquest)block{
    
    [self requestDataWithDataType:dataType withParameter:nil complate:block];
    
}

+(void)requestDataWithDataType:(int)dataType withParameter:(NSDictionary*)parameters complate:(RequestListDataAfterRquest)block{
    
    switch (dataType) {
        case DataType_User:
            break;
            
        default:
            [OfferDataProvider requestDataWithType:dataType withParameter:parameters complate:block];
            break;
    }
}


+(void)requestDataWithPageType:(int)pageType complate:(RequestListDataAfterRquest)block{
    [self requestDataWithPageType:pageType withParameter:nil complate:block];
}


+(void)requestDataWithPageType:(int)pageType withParameter:(NSDictionary*)parameters complate:(RequestListDataAfterRquest)block{
    int dataType = 0;
    switch (pageType) {
        case PageType_Coupon:
            dataType = DataType_Offer_Coupon;
            break;
        case PageType_Reco:
            dataType = DataType_Offer_Reco;
            break;
        default:
            break;
    }

    [self requestDataWithDataType:dataType withParameter:parameters complate:block];
}

@end

