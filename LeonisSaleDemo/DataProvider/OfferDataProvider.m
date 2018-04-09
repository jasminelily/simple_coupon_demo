//
//  OfferViewController.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import "OfferDataProvider.h"
#import "RequestHelper.h"
#import "UrlConstant.h"
#import "FileHelper.h"

#import "OfferCoupon.h"

@interface OfferDataProvider ()
@end

@implementation OfferDataProvider

+(void)requestDataWithType:(int)type withParameter:(NSDictionary*)parameters complate:(RequestListDataAfterRquest)block{
    NSString* url = nil;
    switch (type) {
        case DataType_Offer_Coupon:
            url = API_URL_COUPON_LIST;
            break;
        case DataType_Offer_Reco:
            url = API_URL_RECO_LIST;
            break;
            
        default:
            break;
    }
    
    [self requestDataWithUrl:url withParameter:parameters complate:block];
    
}

+(void)requestDataWithUrl:(NSString*)url withParameter:(NSDictionary *)parameters complate:(RequestListDataAfterRquest)block{
    
    //共通基本検索条件
    NSDictionary * param = [self getParameters:parameters];
    
    //TODO: (NO API)
    [RequestHelper requestApiUrl:url withParameters:param complate:^(NSDictionary *datas) {
        
        //TODO: for DEMO (NO API,use local json)
        NSDictionary* apiData = [FileHelper readJson:@"offer_coupon"];
        NSArray* coupons = [apiData objectForKey:@"data"];
        NSMutableArray * list = [NSMutableArray new];
        for (NSDictionary*  cp in coupons) {
            OfferCoupon * offerCoupon = [[OfferCoupon alloc] initWithDictionary:cp];
            [list addObject:offerCoupon];
        }
        if (block) {
            block([list copy]);
        }
    }];
    
}

//
//検索条件設定
//

+(NSDictionary*)getParameters:(NSDictionary*)paramsOption{
    //基本検索条件(ページング、並び順など)
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:[self getBaseParameters]];
    
    //option検索条件あり
    if (paramsOption) {
        [params addEntriesFromDictionary:paramsOption];
    }
    
    return [params copy];
}

//
////基本検索条件(ページング、並び順など)
//
+(NSDictionary*)getBaseParameters{
    NSDictionary* params = @{
                             @"sort_target": @"id",
                             @"sort_direction": @"descending"
                             };
    return params;
}



@end
