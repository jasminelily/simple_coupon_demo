//
//  OfferImage.h
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/5/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferImage : NSObject

@property(nonatomic,copy) NSString* url_small;
@property(nonatomic,copy) NSString* url_big;
@property(nonatomic,assign) CGSize size_small;
@property(nonatomic,assign) CGSize size_big;

@end
