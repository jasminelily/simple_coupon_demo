//
//  BaseDataController.m
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/7/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import "BaseDataProvider.h"

@implementation BaseDataProvider

//
//結果チェック
//
+(RequestDataCode)checkResult:(NSDictionary*)datas{
    // TODO: Error 共通処理
    
    return RequestDataCode_Success;
}
@end
