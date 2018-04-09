//
//  CCLeftSideHeader.m
//  LeonisSaleDemo
//
//  Created by LilyTan on 4/7/18.
//  Copyright © 2018 Leonis&Co. All rights reserved.
//

#import "CCLeftSideHeader.h"

@interface CCLeftSideHeader()
@property (nonatomic,strong) UIView* back;
@property (nonatomic,strong) UIImageView *imgIcon;
@property (nonatomic,strong) UILabel *lblGroupNameTitle;
@property (nonatomic,strong) UILabel *lblGroupName;
@property (nonatomic,strong) UILabel *lblUserNoTitle;
@property (nonatomic,strong) UILabel *lblUserNo;
@end

@implementation CCLeftSideHeader

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
         self.backgroundColor = TOPBAR_BACK_COLOR;
    }
    
    return self;
}

-(void)setSideHeader:(UserModel*)user{
    _lblGroupName.text = user.groupName;
    _lblUserNo.text = user.userNumber;
}

-(void)setLblAttributes:(UILabel*)lbl{
    [lbl setTextColor:TOPBAR_TEXT_FONT_COLOR];
    [lbl setFont:[UIFont boldSystemFontOfSize:LEFT_HEADER_TEXT_FONT_SIZE]];
    lbl.numberOfLines = 1;
}
@end
