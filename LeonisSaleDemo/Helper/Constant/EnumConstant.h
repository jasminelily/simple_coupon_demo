//
//  Header.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright © 2014 Leonis&Co. All rights reserved.
//

#ifndef EnumConstant_h
#define EnumConstant_h

typedef enum {
    PageType_Reset = 1,
    PageType_Coupon = 3,
    PageType_Reco = 4,
    PageType_UserNo = 9,
    PageType_UserPhone = 10,
    PageType_Site = 13,
    PageType_Home = 15,
}PageType;

typedef enum {
    DataType_User = 10,
    DataType_Offer_Coupon = 20,
    DataType_Offer_Reco = 30
 
}DataType;

//value == api code
typedef enum {
    RequestDataCode_Success = 0,
    RequestDataCode_No_Data = 100,
    RequestDataCode_No_Error = -1,
}RequestDataCode;

typedef enum {
    ButtonType_Ok,
    ButtonType_Cancel
}ButtonType;

typedef enum {
    TopButtonType_Close = 0,
    TopButtonType_Back = 1,
    TopButtonType_Other = 2
}TopButtonType;

typedef void (^CCAfter)();
typedef void (^CCOK)();
typedef void (^CCNG)();
typedef void (^RequestApiDataAfterRquest)(NSDictionary* datas);
typedef void (^RequestListDataAfterRquest)(NSArray* datas);
typedef void (^RequestSingleDataAfterRquest)(RequestDataCode code,NSObject* obj);

#endif
