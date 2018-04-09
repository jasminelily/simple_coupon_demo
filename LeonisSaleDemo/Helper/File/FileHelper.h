//
//  FileHelper.h
//
//  Created by leo-mobile-lily on 2/20/13.
//  Copyright (c) 2013 Leonis&Co. Yoshio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject
//------ファイル読む-------
/* Local Json ファイル　読む*/
+(NSDictionary*)readJson:(NSString*)fileName;

@end
