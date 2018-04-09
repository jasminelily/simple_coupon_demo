//
//  CCTopBarButton.m
//  LeonisDaleDemo
//
//  Created by leo-mobile-lily on 10/2/13.
//

#import "CCTopBarButton.h"

@interface CCTopBarButton()
@property (nonatomic,strong) ClickActionBlock clickBlock;
@end

@implementation CCTopBarButton

- (id)initWithFrame:(CGRect)frame withType:(int)buttonType{
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ClickActionBlock)action
{
    _clickBlock = action;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

-(void) callActionBlock:(id)sender{
    _clickBlock();
}

@end
