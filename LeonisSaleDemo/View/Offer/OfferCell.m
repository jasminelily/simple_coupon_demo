//
//  OfferCell.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/24/14.
//  Copyright © 2014 Leonis&Co. All rights reserved.
//

#import "OfferCell.h"
#import "CCAsynImageView.h"

#import "OfferCoupon.h"
#import "OfferImage.h"

static int const CELL_MARGIN_BETWEEN = 10;
static int const CELL_PADDING_LEFT = 10;
static int const CELL_MARGIN_LEFT = 10;

#define CELL_IMAGE_WIDTH ([UIScreen mainScreen].applicationFrame.size.width - (CELL_MARGIN_LEFT*2) - (CELL_PADDING_LEFT*2))

@interface OfferCell()<CCAsynImageViewDelegate>

@property (nonatomic)UIView * back;
@property (nonatomic) CCLabel * titleLbl;
@property (nonatomic) CCAsynImageView * img;
@property (nonatomic) CCLabel * txtLbl;

@property (nonatomic) NSLayoutConstraint *consImgHeight;
@end
@implementation OfferCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)initViews{
    
    _back = [[UIView alloc] init];
    _back.layer.cornerRadius = 12.5;
    _back.backgroundColor = OFFER_COUPON_SUB_BACK_COLOR;
    
    _titleLbl = [[CCLabel alloc] init];
    [_titleLbl setFont:[UIFont boldSystemFontOfSize:OFFER_COUPON_LIST_TITLE_FONT_SIZE]];
    [_titleLbl setTextColor:OFFER_COUPON_LIST_TITLE_FONT_COLOR];
    
    _txtLbl = [[CCLabel alloc] init];
    [_txtLbl setFont:[UIFont systemFontOfSize:OFFER_COUPON_LIST_TEXT_FONT_SIZE]];
    [_txtLbl setTextColor:OFFER_COUPON_LIST_TEXT_FONT_COLOR];
    
    _img = [[CCAsynImageView alloc] init];
    
    [self.contentView addSubview:_back];
    
    //背景View
    NSString * cellConsH = @"H:|-left-[_back]-right-|";
    NSString * cellConsV = @"V:|-top-[_back]-bottom-|";
    NSDictionary *metircs = @{@"left":@10,@"right":@10,@"top":@5,@"bottom":@5};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:cellConsH
                                                                             options:0
                                                                             metrics:metircs
                                                                               views:NSDictionaryOfVariableBindings(_back)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:cellConsV
                                                                             options:0
                                                                             metrics:metircs
                                                                               views:NSDictionaryOfVariableBindings(_back)]];
    //内容
    [self addSubViews:@[_titleLbl,_img,_txtLbl] withParentView:_back];
}

-(void)addSubViews:(NSArray*)views withParentView:(UIView*)parentView{
    parentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //sub views
    for(int i = 0; i < views.count; i++){
        
        UIView *subView = [views objectAtIndex:i];
        subView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIView *preView = nil;
        if(i != 0){
            preView = [views objectAtIndex:i-1];
        }
        
        int topMargin = CELL_MARGIN_BETWEEN;
        int leftMargin = CELL_PADDING_LEFT;
        
        [parentView addSubview:subView];
        
        //先頭 parent top margin 調整
        if(i == 0){
            [parentView addConstraint:[NSLayoutConstraint constraintWithItem: subView
                                                                  attribute : NSLayoutAttributeTop
                                                                  relatedBy : NSLayoutRelationEqual
                                                                     toItem : parentView
                                                                  attribute : NSLayoutAttributeTop
                                                                 multiplier : 1.0
                                                                   constant : topMargin]];
        }else{
            //そのた、前のsub viewで調整
            [parentView addConstraint:[NSLayoutConstraint constraintWithItem : subView
                                                                   attribute : NSLayoutAttributeTop
                                                                   relatedBy : NSLayoutRelationEqual
                                                                      toItem : preView
                                                                   attribute : NSLayoutAttributeBottom
                                                                  multiplier : 1.0
                                                                    constant : topMargin]];
        }
        
        //left
        [parentView addConstraint:[NSLayoutConstraint constraintWithItem : subView
                                                               attribute : NSLayoutAttributeLeft
                                                               relatedBy : NSLayoutRelationEqual
                                                                  toItem : parentView
                                                               attribute : NSLayoutAttributeLeft
                                                              multiplier : 1.0
                                                                constant : leftMargin]];
        //right
        [parentView addConstraint:[NSLayoutConstraint constraintWithItem : subView
                                                               attribute : NSLayoutAttributeRight
                                                               relatedBy : NSLayoutRelationEqual
                                                                  toItem : parentView
                                                               attribute : NSLayoutAttributeRight
                                                              multiplier : 1.0
                                                                constant : -leftMargin]];
        //width
        [parentView addConstraint:[NSLayoutConstraint constraintWithItem : subView
                                                               attribute : NSLayoutAttributeWidth
                                                               relatedBy : NSLayoutRelationEqual
                                                                  toItem : nil
                                                               attribute : NSLayoutAttributeNotAnAttribute
                                                              multiplier : 1.0
                                                                constant : CELL_IMAGE_WIDTH]];
        
        if (subView == _img) {
            _consImgHeight = [NSLayoutConstraint constraintWithItem : _img
                                                          attribute : NSLayoutAttributeHeight
                                                          relatedBy : NSLayoutRelationEqual
                                                             toItem : nil
                                                          attribute : NSLayoutAttributeNotAnAttribute
                                                         multiplier : 1.0
                                                           constant : 0];
            [parentView addConstraint:_consImgHeight];
        }
        
        //最後 parent bottom margin 調整
        if(i == (views.count-1)){
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem: subView
                                                                     attribute : NSLayoutAttributeBottom
                                                                     relatedBy : NSLayoutRelationEqual
                                                                        toItem : parentView
                                                                     attribute : NSLayoutAttributeBottom
                                                                    multiplier : 1.0
                                                                      constant : -topMargin];
            [bottom setPriority:UILayoutPriorityDefaultHigh];
            [parentView addConstraint:bottom];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

#pragma mark -
#pragma mark Data
-(void)setData:(NSObject*)data{
    [self setData:data withIndex:nil];
}

-(void)setData:(NSObject*)data withIndex:(NSIndexPath*)index{
    
    if ([data isKindOfClass:[OfferCoupon class]]) {
        OfferCoupon * coupon = (OfferCoupon*)data;
        [self setCoupon:coupon];
    }
    
}

-(void)setCoupon:(OfferCoupon*)coupon{
    [self setContentWithTitle:coupon.title withDesc:coupon.description_summary withImageInfo:coupon.image];
}

-(void)setContentWithTitle:(NSString*)title withDesc:(NSString*)desc withImageInfo:(OfferImage*)imageInfo {
    
    _titleLbl.text = title;
    _txtLbl.text = desc;
    
    //画像
    if ([CheckHelper isStringEmpty:imageInfo.url_small] == NO) {
        CGSize size = [ViewHelper calImageSize:CELL_IMAGE_WIDTH withOriginSize:imageInfo.size_small];
        _consImgHeight.constant = size.height;
        [_img setImageWithURL:imageInfo.url_small];
    }else{
        _consImgHeight.constant = 0;
        _img.image = nil;
    }
    
    
}
@end
