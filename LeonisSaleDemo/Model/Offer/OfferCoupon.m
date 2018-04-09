//
//  OfferCoupon.m
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/5/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import "OfferCoupon.h"

@implementation OfferCoupon

- (instancetype)initWithDictionary:(NSDictionary *)apiData
{
    self = [super initWithDictionary:apiData];
    if (self) {
        _title = [apiData objectForKey:@"title"];
        _description_summary = [apiData objectForKey:@"description_summary"];
        _description_top = [apiData objectForKey:@"description_top"];
        _description_bottom = [apiData objectForKey:@"description_bottom"];
        
        NSDictionary* small = [[apiData objectForKey:@"image"] objectForKey:@"small"];
        OfferImage* image = [OfferImage new];
        image.size_small = CGSizeMake([[small objectForKey:@"width"] intValue],[[small objectForKey:@"height"] intValue]);
        image.url_small = [small objectForKey:@"url"];
        _image = image;
    }
    return self;
}

@end
