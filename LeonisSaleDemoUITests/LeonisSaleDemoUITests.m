//
//  LeonisSaleDemoUITests.m
//  LeonisSaleDemoUITests
//
//  Created by LilyT on 5/10/17.
//  Copyright © 2017 Leonis&Co. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LeonisSaleDemoUITests : XCTestCase
@property (nonatomic) XCUIApplication *app;
@end

enum{
    DataType_Coupon = 1,
    DataType_Reco =2
}DataType;

enum{
    CouponType_Number = 1,
    CouponType_Tap =2
}CouponType;

enum{
    RecoType_Url = 1,
    RecoType_Content =2
}RecoType;

@implementation LeonisSaleDemoUITests


- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    //    XCUIApplication *app = [[XCUIApplication alloc] init];
    //    XCUIElement *navigationBar = app.navigationBars[@"\U30af\U30fc\U30dd\U30f3"];
    //    [navigationBar.staticTexts[@"\U30af\U30fc\U30dd\U30f3"] tap];
    //    [[navigationBar.otherElements childrenMatchingType:XCUIElementTypeButton].element tap];
    //    [app.tables.staticTexts[@"\U30c7\U30b6\U30a4\U30f3\U5909\U66f4"] tap];
    //
    
    
    //    XCUIElement *navigationBar2 = app.navigationBars[@"\U30c7\U30b6\U30a4\U30f3"];
    //    [navigationBar2.staticTexts[@"\U30c7\U30b6\U30a4\U30f3"] tap];
    
    //    XCUIElement *button3 = [navigationBar2.otherElements childrenMatchingType:XCUIElementTypeButton].element;
    //    [button3 tap];
    //    [app.buttons[@"\U30ad\U30e3\U30f3\U30bb\U30eb"] tap];
    //    [button2 tap];
    //    [app.buttons[@"OK"] tap];
    //    [button3 tap];
    //    [elementsQuery.icons[@"\U30c7\U30e22"] tap];
    //
    //    XCUIElement *element = app.otherElements[@"\U30c7\U30e22"];
    //    [element swipeUp];
    //    [element tap];
    //    [element swipeUp];
    //    [element swipeLeft];
    
    
    
}

-(void)testPrepare{
    // Use recording to get started writing UI tests.
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationFaceUp;
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    
}

-(void)testLogin{
    if (!_app) {
        _app = [[XCUIApplication alloc] init];
    }
    
    XCUIElement *navigationBar = _app.navigationBars[@"グループ"];
    if (([navigationBar exists] && [navigationBar isHittable]) == false) {
        return;
    }
    
    XCUIElementQuery *scrollViewsQuery = _app.scrollViews;
    XCUIElement *secureTextField = [scrollViewsQuery childrenMatchingType:XCUIElementTypeSecureTextField].element;
    [secureTextField tap];
    [secureTextField typeText:@"43214321"];
    [_app.buttons[@"OK"] tap];
    [_app.tables.staticTexts[@"Dev"] tap];
    [[[[scrollViewsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"OK"] elementBoundByIndex:1] tap];
    
}

-(void)testReal{
    
    [self testPrepare];
    
//    [self testLogin];
    
    if (!_app) {
        _app = [[XCUIApplication alloc] init];
    }
    
    //クーポン
    [self OneTypeTest:DataType_Coupon];
    
    //レコメンド
    [self testCellReco];
    [self testPullToRefresh];
    
}

-(void)testPullToRefresh{
    
    XCUIElement* first = [_app.tables.cells elementBoundByIndex:0];
    XCUICoordinate * start = [first coordinateWithNormalizedOffset:CGVectorMake(0, 0)];
    XCUICoordinate * end = [first coordinateWithNormalizedOffset:CGVectorMake(0, 1)];
    
    [start pressForDuration:1 thenDragToCoordinate:end];

}

-(void)OneTypeTest:(int)type{
    
    //画面
    NSUInteger count = _app.tables.cells.count;
    
    //no data
    if (count == 0) {
        //test alert
        [self wait:3];
        count = _app.tables.cells.count;
    }
    
    XCTAssert(count>0);
    //    [self measureBlock:^{
    
    for (int i = 0; i < count; i ++) {
        switch (type) {
            case DataType_Coupon:
                [self testCellCoupon:i];
                break;
            case DataType_Reco:
                [self testCellReco:i];
                break;
            default:
                break;
        }
    }
    
    
}

-(void)testCellReco{
    
    [self checkLeftExist:@"レコメンド一覧"];
    
    [self OneTypeTest:DataType_Reco];
}


-(void)testCellCoupon:(int)index{
    //詳細表示
    XCUIElement * cell = [_app.tables.cells elementBoundByIndex:index];
    int type = -1;
    if ([cell.staticTexts[@"タップ"] exists]) {
        type = CouponType_Tap;
    }else if([cell.staticTexts[@"暗証番号"] exists]){
        type = CouponType_Number;
    }
    
    [cell tap];
    XCUIElementQuery *elementsQuery = _app.scrollViews.otherElements;
    
    if ([elementsQuery.buttons[@"利用する"] exists]) {
        XCUIElement * btnUse = elementsQuery.buttons[@"利用する"];
        [btnUse tap];
        
        switch (type) {
            case CouponType_Tap:
                
                break;
            case CouponType_Number:
                [[[[[[[_app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeSecureTextField].element typeText:@"1234"];
                
                break;
            default:
                break;
        }
        
        XCUIElement * success = elementsQuery.staticTexts[@"Thank You"];
        NSPredicate * check = [NSPredicate predicateWithFormat:@"exists == true && hittable == true"];
        [self expectationForPredicate:check evaluatedWithObject:success handler:nil];
        
        [_app.otherElements.buttons[@"OK"] tap];
        
        //3秒以上かかる or thank you 存在しない、失敗
        [self waitForExpectationsWithTimeout:3.0 handler:^(NSError *error) {
            if (error) {
                NSLog(@"Timeout Error: %@", error);
            }
        }];
        
        //チェックthank you 存在か
        //        XCTAssert((success.exists &&success.hittable && !CGRectIsEmpty(success.frame)));
        
    }
    
    [self uiBack];
    
}


-(void)testCellReco:(int)index{
    //詳細表示
    XCUIElement * cell = [_app.tables.cells elementBoundByIndex:index];
    
    int type = -1;
    if ([cell.staticTexts[@"URL"] exists]) {
        type = RecoType_Url;
    }else if([cell.staticTexts[@"記事"] exists]){
        type = RecoType_Content;
    }
    
    [cell tap];
    
    [self wait:5];
    
    switch (type) {
        case RecoType_Url:
            [self cellRecoUrl];
            break;
            
        default:
            break;
    }
    
    [self uiBack];
    
}

-(void)checkLeftExist:(NSString*)name{
    //open left
    [self uiOther];
    
    XCUIElementQuery *tablesQuery = _app.tables;
    XCUIElement * leftCell = tablesQuery.staticTexts[name];
    if (leftCell.exists == false) {
        [self wait:2];
        [self uiOther];
        leftCell = tablesQuery.staticTexts[name];
        
        XCTAssert(!leftCell.exists);
    }
    
    [leftCell tap];
    [self wait:3];
}

-(void)cellRecoUrl{
    
    XCUIElement *element2 = [_app.toolbars childrenMatchingType:XCUIElementTypeOther].element;
    //    [[[element2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[element2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] tap];
    [self wait:3];
}


-(XCUIElement*)getAlertCustom{
    return [[[[[_app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther].element;
}

-(void)uiBack{
    XCUIElement *navigationBar = [_app.navigationBars elementBoundByIndex:0];
    [[[navigationBar.otherElements containingType:XCUIElementTypeImage identifier:@"back"] childrenMatchingType:XCUIElementTypeButton].element tap];
    
}

-(void)uiBack:(XCUIElement*)navigationBar{
    //    XCUIElement *navigationBar = [_app.navigationBars elementBoundByIndex:0];
    [[[navigationBar.otherElements containingType:XCUIElementTypeImage identifier:@"back"] childrenMatchingType:XCUIElementTypeButton].element tap];
    
}

-(void)uiClose{
    XCUIElement *navigationBar = [_app.navigationBars elementBoundByIndex:0];
    [[[navigationBar.otherElements containingType:XCUIElementTypeImage identifier:@"close"] childrenMatchingType:XCUIElementTypeButton].element tap];
    
}

-(void)uiClose:(XCUIElement*)navigationBar{
    //    XCUIElement *navigationBar = [_app.navigationBars elementBoundByIndex:0];
    [[[navigationBar.otherElements containingType:XCUIElementTypeImage identifier:@"close"] childrenMatchingType:XCUIElementTypeButton].element tap];
    
}

-(void)uiOther{
    XCUIElement *navigationBar = [_app.navigationBars elementBoundByIndex:0];
    [[[navigationBar.otherElements containingType:XCUIElementTypeImage identifier:@"other"] childrenMatchingType:XCUIElementTypeButton].element tap];
}


- (void)wait:(NSUInteger)interval {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"wait"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:interval handler:nil];
}
@end
