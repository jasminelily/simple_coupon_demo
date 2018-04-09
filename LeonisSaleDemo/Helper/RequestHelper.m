//
//  RequestHelper.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright © 2014 Leonis&Co. All rights reserved.
//

#import "RequestHelper.h"

NSString* const HTTP_POST = @"POST";

@implementation RequestHelper


+(void)requestApiUrl:(NSString*)url withParameters:(NSDictionary*)parameters complate:(RequestApiDataAfterRquest)block{
    
    //NO API URL
    if ([CheckHelper isStringEmpty:url]) {
        if (block) {
            block(nil);
        }
        return;
    }
    
    //Parameter
    NSData *paramterData = nil;
    
    if (parameters != nil) {
        NSError* error = nil;
        paramterData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error != nil) {
            paramterData = nil;
        }
    }
    
    [self doRequestApiUrl:url withParameters:paramterData complate:block];
    
}

+(void)doRequestApiUrl:(NSString*)url withParameters:(NSData*)paramterData complate:(RequestApiDataAfterRquest)after {
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DATA_DOWNLOAD_TIME_OUT];
    
    //request set http method
    [request setHTTPMethod:HTTP_POST];
    
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    if (paramterData != nil) {
        [request setValue:@([paramterData length]).stringValue forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:paramterData];
    }
    
    //request set url
    NSURL* requestUrl = [ConvertHelper url:url];
    [request setURL:requestUrl];
    
    
    //response
    {
        NSOperationQueue *queue=[NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError != nil) {
                after(nil);
                return ;
            }
            
            NSDictionary *rs = [self requestReslut:data];
            after(rs);
        }];
    }
    
}

+(NSDictionary*)requestReslut:(NSData*)apiResultData{
    
    // JSONなし
    if (apiResultData == nil) {
        return nil;
    }
    
    //convert data
    NSError* error = nil;
    id serializedData = [NSJSONSerialization JSONObjectWithData:apiResultData options:NSJSONReadingAllowFragments error:&error];
    
    //エラー発生
    if (error != nil) {
        return nil;
    }
    
    return serializedData;
    
}
@end
