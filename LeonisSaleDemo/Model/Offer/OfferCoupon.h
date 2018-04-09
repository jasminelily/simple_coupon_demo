//
//  OfferCoupon.h
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/5/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelApi.h"
#import "OfferImage.h"

@interface OfferCoupon : BaseModelApi

@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* description_summary;
@property(nonatomic,copy) NSString* description_top;
@property(nonatomic,copy) NSString* description_bottom;

@property(nonatomic,strong,readonly) OfferImage* image;

- (instancetype)initWithDictionary:(NSDictionary *)apiData;

@end
