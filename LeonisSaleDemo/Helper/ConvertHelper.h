//
//  ConvertHelper.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 9/3/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertHelper : NSObject

//文字列からNSUrlへ変換
+(NSURL*)url:(NSString*)strUrl;

//image
+(UIImageView*)changeImage:(UIImageView*)imageView withColor:(UIColor*)color;

//string
+(NSString*)trimString:(NSString*)string;

//json
+(NSArray*)formatJson:(NSData*)data;


@end
