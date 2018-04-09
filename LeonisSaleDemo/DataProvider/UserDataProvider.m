//
//  UserDataController.m
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/7/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import "UserDataProvider.h"
#import "UrlConstant.h"
#import "RequestHelper.h"
#import "FileHelper.h"

#import "UserModel.h"

@implementation UserDataProvider

+(void)requestDataWithType:(int)type withParameter:(NSDictionary*)parameters complate:(RequestSingleDataAfterRquest)block{
    NSString* url = nil;
    switch (type) {
        case DataType_User:
            url = API_URL_USER_INFO;
            break;
            
        default:
            break;
    }
    
    [self requestDataWithUrl:url withParameter:parameters complate:block];
    
}

+(void)requestDataWithUrl:(NSString*)url withParameter:(NSDictionary *)parameters complate:(RequestSingleDataAfterRquest)block{
    
    //TODO: (NO API)
    [RequestHelper requestApiUrl:url withParameters:parameters complate:^(NSDictionary *datas) {
        
        //TODO: for DEMO (NO API,use local json)
        NSDictionary* user = [FileHelper readJson:@"userinfo"];
        UserModel * model = [[UserModel alloc] initWithDictionary:user];
        if (block) {
            block(model.resultCode,model);
        }
        
    }];
    
}


@end
