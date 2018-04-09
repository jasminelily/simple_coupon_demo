//
//  CCTopBarButton.h
//  LeonisDaleDemo
//
//  Created by leo-mobile-lily on 10/2/13.
//

#import <UIKit/UIKit.h>

typedef enum {
    CCTopBarButton_Type_Right,
    CCTopBarButton_Type_Left
}CCTopBarButton_Type;

typedef void (^ClickActionBlock)();

@interface CCTopBarButton : UIButton

- (id)initWithFrame:(CGRect)frame withType:(int)buttonType;
- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(ClickActionBlock)action;
@end
