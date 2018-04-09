//
//  ConvertHelper.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 9/3/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import "ConvertHelper.h"

@implementation ConvertHelper

//string
+(NSString*)trimString:(NSString*)str{
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    return trimmedString;
    
}

//-------url-------------
+(NSURL*)url:(NSString*)strUrl{
    if (!strUrl) {
        return nil;
    }
    return [NSURL URLWithString:
            [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

//-------image-------------
+(UIImageView*)changeImage:(UIImageView*)imageView withColor:(UIColor*)color{
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:color];
    
    return imageView;
}

//-------json--------
+(NSArray*)formatJson:(NSData*)data{
    NSDictionary* rs = nil;
    if (data)
    {
        NSError *parseError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        
        if (json)
        {
            rs = json;
        }
    }
    
    return [rs objectForKey:@"data"];
}

@end
