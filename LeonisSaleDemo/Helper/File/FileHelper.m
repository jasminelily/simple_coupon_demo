//
//  FileHelper.m
//
//  Created by leo-mobile-lily on 2/20/13.
//  Copyright (c) 2013 Leonis&Co. Yoshio. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

/*
Local Jsonファイル　読む
 */
+(NSDictionary*)readJson:(NSString*)fileName{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return json;
}

@end
