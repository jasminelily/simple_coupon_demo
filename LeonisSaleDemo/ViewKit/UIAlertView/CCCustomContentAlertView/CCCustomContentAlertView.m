//
//  CCNumberInputAlertView.m
//  haios
//
//  Created by leo-mobile-lily on 9/6/13.
//  Copyright (c) 2013 Leonis All rights reserved.
//

#import "CCCustomContentAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "CCRefreshCircleView.h"

typedef enum {
    ButtonClickType_OK,
    ButtonClickType_Cancel,
    ButtonClickType_None
}ButtonClickType;

//left margin
#define kLateralInset         12.0
//top margin
#define kVerticalInset         8.0

//title
#define kTitleLabelMargin     12.0
//alert view width
#define kTableAlertWidth     284.0
//alert button height
#define kButtonHeight   44.0

//textview
#define kTextViewHeight 200

//textfiled max length
#define TEXTFIELD_DEFALUT_MAX_LENGTH 20
#define kTextfiledHeight 35

//uitableview
#define kTableRowCount _numberOfRows(0)>5? 5:_numberOfRows(0)
#define kTableRowHeight 40.0
#define TABLE_SELECTED_COLOR [UIColor colorWithRed:0.318 green:0.4 blue:0.569 alpha:1.0]
#define TABLE_UNSELET_COLOR [UIColor blackColor]
#define BACKGROUND_COLOR WHITE
#define BACKGROUND_COLOR_LOADING SYS_COLOR
#define BTN_TEXT_COLOR SYS_COLOR_TEXT
#define TITLE_TEXT_COLOR SYS_COLOR_TEXT
//uiprogressview
#define kProgressHeight 90
//indicator
#define kIndicatorHeight 50

#define MSG_SHOW_TIME_ERROR 2
#define MSG_SHOW_TIME_SUCCESS 1

@interface CCCustomContentAlertView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
// alert typey
@property (nonatomic) CCCustomContentAlertViewType alertType;
@property (nonatomic) ButtonClickType btnClickType;
@property (nonatomic) CCCustomContentAlertViewMaskType maskType;

// alert back groud view(mask)
@property (nonatomic,strong) UIView *alertBg;
// alert title
@property (nonatomic,strong) CCLabel * titleLabel;
// alert content(uitable view,textfield,textview...)
@property (nonatomic,strong) UIView * contentView;

// alert button
@property (nonatomic,strong) UIButton * cancelButton;
@property (nonatomic,strong) UIButton * okButton;
@property (nonatomic,strong) NSString * cancelBtnTitle;
@property (nonatomic,strong) NSString * okBtnTitle;

// alert title
@property (nonatomic,strong) NSString * title;
// alert content text
@property (nonatomic,strong) NSString * text;

@property (nonatomic,strong) CCCustomContentAlertOKBlock okBlock;
@property (nonatomic,strong) CCCustomContentAlertCancelBlock cancelBlock ;
@property (nonatomic,strong) CCCustomContentAlertCompleteBlock completeBlock;

//uitableview
@property (nonatomic,strong) CCCustomContentAlertNumberOfRowsBlock numberOfRows;
@property (nonatomic,strong) CCCustomContentAlertTableCellsBlock cells;
@property (nonatomic,strong) CCCustomContentAlertRowSelectionBlock selectionBlock;

//indicator
@property (nonatomic,strong) CCRefreshCircleView* indicator;
@property (nonatomic,strong) NSTimer * timer;

//message
@property (nonatomic,assign) float msgShowTime;
@end

@implementation CCCustomContentAlertView
@synthesize maxTextLength;

#pragma mark -
#pragma mark Init

-(id)initWithType:(CCCustomContentAlertViewType)alertViewType{
    _maskType = CCCustomContentAlertViewMaskType_None;
    return [self initWithTitle:nil withType:alertViewType withText:nil withCancelButtonTitle:nil withOKButtonTitle:nil];
}

-(id)initWithType:(CCCustomContentAlertViewType)alertViewType withMask:(CCCustomContentAlertViewMaskType)mskType{
    _maskType = mskType;
    return [self initWithTitle:nil withType:alertViewType withText:nil withCancelButtonTitle:nil withOKButtonTitle:nil];
}

-(id)initWithTitle:(NSString *)title withType:(CCCustomContentAlertViewType)alertViewType withText:(NSString*)text{
    return [self initWithTitle:title withType:alertViewType withText:text withCancelButtonTitle:nil withOKButtonTitle:nil];
}

-(id)initWithTitle:(NSString *)title withType:(CCCustomContentAlertViewType)alertViewType withText:(NSString*)text withShowTime:(float)showTime{
    _msgShowTime = showTime;
    return [self initWithTitle:title withType:alertViewType withText:text withCancelButtonTitle:nil withOKButtonTitle:nil];
}

-(id)initWithTitle:(NSString *)title withType:(CCCustomContentAlertViewType)alertViewType withText:(NSString *)text withCancelButtonTitle:(NSString*) cancelButtonTitle withOKButtonTitle:(NSString *)okButtonTitle {
    self = [super init];
    if (self) {
        self.title = title;
        self.text = text;
        self.alertType = alertViewType;
        self.cancelBtnTitle = cancelButtonTitle;
        self.okBtnTitle = okButtonTitle;
    }
    
    return self;
}

#pragma mark - UITableView Init

-(id)initWithTitle:(NSString *)title withTableNumberOfRows:(CCCustomContentAlertNumberOfRowsBlock)rowsBlock withTableCells:(CCCustomContentAlertTableCellsBlock)cellsBlock
{
    if (rowsBlock == nil || cellsBlock == nil)
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        self.alertType = CCCustomContentAlertViewType_TableView;
        self.numberOfRows = rowsBlock;
        self.cells = cellsBlock;
        self.title = title;
        self.cancelBtnTitle = MOJI_BTN_CANCEL;
        self.okBtnTitle = MOJI_BTN_OK;
    }
    
    return self;
}

#pragma mark - alert show
-(void)show{
    
    [self createViews];
    
    // show the alert with animation
    [self animateIn];
    
}

#pragma mark - alert disminss
-(void)dismiss{
    
    //indicator動画なし
    if (self.alertType == CCCustomContentAlertViewType_ActivityIndicator) {
        [self removeFromSuperview];
        [self afterDissmiss];
        return;
    }
    
    // disppear the alert with animation
    [self animateOut];
    
}
#pragma mark - views
-(void)createViews{
    
    [self createBackgroundView];
    
    [self addTitleLabel];
    
    switch (self.alertType) {
        case CCCustomContentAlertViewType_TextView:
            [self addTextView];
            break;
        case CCCustomContentAlertViewType_TableView:
            [self addTableView];
            break;
        case CCCustomContentAlertViewType_ProgressView:
            [self addProgressView];
            break;
        case CCCustomContentAlertViewType_Label:
        case CCCustomContentAlertViewType_Message:
        case CCCustomContentAlertViewType_ErrorMsg:
            [self addLabel];
            break;
        case CCCustomContentAlertViewType_ActivityIndicator:
            [self addIndicator];
            break;
        default:
            break;
    }
    
    [self addButtons];
    
    [self resetBackgroudView];
}

-(void)addTitleLabel{
    if (!self.title || self.title.length == 0) {
        return;
    }
    // alert title creation
    self.titleLabel = [[CCLabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.frame = CGRectMake(kLateralInset, kTitleLabelMargin *2, kTableAlertWidth - kLateralInset * 2, 22);
    self.titleLabel.textColor = TITLE_TEXT_COLOR;
    //self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    //self.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.titleLabel sizeToFit];
    
    self.contentView = self.titleLabel;
    self.contentView.center = CGPointMake(kTableAlertWidth/2, self.contentView.center.y);
    [self.alertBg addSubview:self.contentView];
    
}

-(void)addButtons{
    int btnCount = -1;
    
    if (self.cancelBtnTitle != nil && self.okBtnTitle != nil) {
        btnCount = 2;
    }else if(self.cancelBtnTitle == nil && self.okBtnTitle == nil){
        btnCount = 0;
    }else{
        btnCount = 1;
    }
    
    switch (btnCount) {
        case 1:
            [self addOneButton];
            break;
        case 2:
            [self addTwoButtons];
            break;
        default:
            
            break;
    }
}

-(void)addOneButton{
    // ok button creation
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okButton.frame = CGRectMake(kLateralInset, CGRectGetMaxY(self.contentView.frame) + kTitleLabelMargin, kTableAlertWidth - kLateralInset * 2, kButtonHeight);
    [self.okButton addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSString * title = self.okBtnTitle == nil? self.cancelBtnTitle : self.okBtnTitle;
    [self createButton:self.okButton withTitle:title];
    
}

-(void)addTwoButtons{
    
    // cancel button creation
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(kLateralInset, CGRectGetMaxY(self.contentView.frame) + kTitleLabelMargin, (kTableAlertWidth - kLateralInset * 3)/2, kButtonHeight);
    [self.cancelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self createButton:self.cancelButton withTitle:self.cancelBtnTitle];
    
    // ok button creation
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame) + kLateralInset, CGRectGetMaxY(self.contentView.frame) +kTitleLabelMargin, (kTableAlertWidth - kLateralInset * 3)/2, kButtonHeight);
    [self.okButton addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self createButton:self.okButton withTitle:self.okBtnTitle];
    
    
}

-(void)addBtnLine:(BOOL)isOne{
    CGFloat width = 0.5;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.okButton.frame) - width, CGRectGetWidth(self.alertBg.frame), width)];
    [line setBackgroundColor:BTN_TEXT_COLOR];
    [self.alertBg addSubview:line];
    if (isOne == NO) {
        line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.okButton.frame), CGRectGetMinY(self.okButton.frame) - width, width, CGRectGetHeight(self.okButton.frame) +width)];
        [line setBackgroundColor:BTN_TEXT_COLOR];
        [self.alertBg addSubview:line];
        
    }
}

-(void)createButton:(UIButton*)btn withTitle:(NSString*)title{
    
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    btn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    btn.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:BTN_TEXT_COLOR forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];

    btn.opaque = NO;
    btn.layer.cornerRadius = 5.0;
    [self.alertBg addSubview:btn];
    
}

-(void)createBackgroundView
{
    // adding some styles to background view (behind table alert)
    self.frame = [[UIScreen mainScreen] bounds];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.opaque = NO;
    
    // adding it as subview of app's UIWindow
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self];
    
    // get background color darker
    //    [UIView animateWithDuration:0.2 animations:^{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    //    }];
    self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.alertBg];
    
}

-(void)resetBackgroudView{
    float alertheight = 0;
    if (self.okButton) {
        alertheight =  CGRectGetMaxY(self.okButton.frame);
        
    }else{
        if (self.contentView) {
            alertheight = CGRectGetMaxY(self.contentView.frame) ;
        }else{
            alertheight = CGRectGetMaxY(self.titleLabel.frame);
        }
        
        alertheight += kTitleLabelMargin;
    }
    
    float bgY = (CGRectGetHeight(self.frame) - alertheight)*0.5;
  
    if (self.alertType == CCCustomContentAlertViewType_ProgressView) {
        alertheight += kTitleLabelMargin;
    }
    
    float width = kTableAlertWidth;
    self.alertBg.frame = CGRectMake((self.frame.size.width - width) / 2, bgY,width,alertheight);
    
    if (self.alertType == CCCustomContentAlertViewType_ActivityIndicator) {
        self.alertBg.backgroundColor = [UIColor clearColor];
        [ViewHelper resetViewCenter:self.contentView];
    }else{
        [self.alertBg setBackgroundColor:BACKGROUND_COLOR];
        self.alertBg.alpha = 0.9;
        self.alertBg.layer.cornerRadius = 5.0;
    }
    
    if (self.okButton) {
        if (self.cancelButton) {
            
            [self addBtnLine:NO];
        }else{
            [self addBtnLine:YES];
        }
    }
    
}

-(void)addTextField{
    
    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectZero];
    
    tf.frame = CGRectMake(kLateralInset, CGRectGetMaxY(self.titleLabel.frame) + kTitleLabelMargin, kTableAlertWidth - kLateralInset * 2, kTextfiledHeight);
    tf.secureTextEntry = YES;
    tf.backgroundColor = [UIColor whiteColor];
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    [tf setBorderStyle:UITextBorderStyleRoundedRect];
    [tf setFont:[UIFont systemFontOfSize:16]];
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // left padding
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 19)];
    tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    
    // delegate
    tf.delegate = self;
    self.contentView = tf;
    [self.alertBg addSubview:self.contentView];
    [tf becomeFirstResponder];
    
    maxTextLength = [NSNumber numberWithInt:TEXTFIELD_DEFALUT_MAX_LENGTH];
    
}

-(void)addTextView{
    self.contentView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.contentView.frame = CGRectMake(kLateralInset, CGRectGetMaxY(self.titleLabel.frame) + kTitleLabelMargin, kTableAlertWidth - kLateralInset * 2, kTextViewHeight);
    self.contentView.layer.cornerRadius = 5.0;
    [self.alertBg addSubview:self.contentView];
    
    ((UITextView*) self.contentView).text = self.text;
}

-(void)addTableView{
    // table view creation
    UITableView * tv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tv.frame = CGRectMake(kLateralInset, CGRectGetMaxY(self.titleLabel.frame) + kTitleLabelMargin, kTableAlertWidth - kLateralInset *2, kTableRowCount * kTableRowHeight);
    tv.layer.cornerRadius = 6.0;
    tv.layer.masksToBounds = YES;
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentView = tv;
    [self.alertBg addSubview:self.contentView];
}

-(void)addProgressView{
    UIProgressView * pv = [[UIProgressView alloc]
                           initWithFrame:CGRectMake(kLateralInset*2, CGRectGetMaxY(self.titleLabel.frame) + kTitleLabelMargin, kTableAlertWidth - kLateralInset*4, kProgressHeight)];
    [pv setProgressViewStyle: UIProgressViewStyleBar];
    self.contentView = pv;
    [self.alertBg addSubview:self.contentView];
}

-(void)addIndicator{
    
    if (self.indicator == nil) {
        
        self.indicator = [[CCRefreshCircleView alloc] initWithFrame:CGRectMake(0,0 + kTitleLabelMargin, kIndicatorHeight, kIndicatorHeight)];
        self.indicator.progress = 1;
    }
    
    [self.indicator startRotate];
    self.contentView = self.indicator;
    [self.alertBg addSubview:self.contentView];
    
}

-(void)addLabel{
    float lblHeight = 38;//２行
    if (self.text == nil | self.text.length == 0) {
        lblHeight = 0;
    }
    
    CCLabel * lbl = [[CCLabel alloc]
                     initWithFrame:CGRectMake(kLateralInset*2, CGRectGetMaxY(self.titleLabel.frame) + kTitleLabelMargin, kTableAlertWidth - kLateralInset*4, lblHeight)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    lbl.text = self.text;
    lbl.textColor = TITLE_TEXT_COLOR;
    UIFont *lblFont = [UIFont systemFontOfSize:15];
    [lbl setFont:lblFont];
    
    [lbl sizeToFit];
    
    self.contentView = lbl;
    self.contentView.center = CGPointMake(kTableAlertWidth*0.5, self.contentView.center.y);
    [self.alertBg addSubview:self.contentView];
    
}

#pragma mark - end block
-(void)configureOKBlock:(CCCustomContentAlertOKBlock)okBlock andCancelBlock:(CCCustomContentAlertCancelBlock)cancelBlock
{
    self.okBlock = okBlock;
    self.cancelBlock = cancelBlock;
}

-(void)configureSelectBlock:(CCCustomContentAlertRowSelectionBlock)selBlock andCancelBlock:(CCCustomContentAlertCancelBlock)cancelBlock{
    self.selectionBlock = selBlock;
    self.cancelBlock = cancelBlock;
}

-(void)configureCompleteBlock:(CCCustomContentAlertCompleteBlock)completeBlock{
    self.completeBlock = completeBlock;
}

#pragma mark - animation
-(void)animateIn
{
    //indicator動画なし
    if (self.alertType == CCCustomContentAlertViewType_ActivityIndicator) {
        return;
    }
    
    // UIAlertView-like pop in animation
    self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.2 animations:^{
        self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0/7.5 animations:^{
                self.alertBg.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
    
    float showSecond = 0;
    if (self.alertType == CCCustomContentAlertViewType_ErrorMsg) {
        showSecond = _msgShowTime == 0 ? MSG_SHOW_TIME_ERROR: _msgShowTime;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:showSecond target:self selector:@selector(completeClick) userInfo:nil repeats:NO];
        
    }
    
    if (self.alertType == CCCustomContentAlertViewType_Message) {
        showSecond = _msgShowTime == 0 ? MSG_SHOW_TIME_SUCCESS: _msgShowTime;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:showSecond target:self selector:@selector(completeClick) userInfo:nil repeats:NO];
    }
}

-(void)animateOut
{
    
    [UIView animateWithDuration:1.0/7.5 animations:^{
        self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
                self.alpha = 0.3;
            } completion:^(BOOL finished){
                // table alert not shown anymore
                [self removeFromSuperview];
                [self afterDissmiss];
            }];
        }];
    }];
}


-(void)shakAlert{
    ((UITextField*)self.contentView).text = nil;
    
    //shake animation
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -20, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    [UIView animateWithDuration:0.1 animations:^{
        // Translate left
        self.alertBg.transform = moveLeft;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            // Translate right
            self.alertBg.transform = moveRight;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                // Translate left
                self.alertBg.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    // Translate to origin
                    self.alertBg.transform = resetTransform;
                }];
            }];
            
        }];
    }];
}

#pragma mark - action
-(void)cancelBtnClick{
    self.btnClickType = ButtonClickType_Cancel;
    
    // dismiss the alert with its animation
    [self animateOut];
    
}

-(void)okBtnClick{
    
    self.btnClickType = ButtonClickType_OK;
    
    if ([self checkInputValue] == NO) {
        return;
    }
    
    // dismiss the alert with its animation
    [self animateOut];
    
}

-(void)completeClick{
    self.btnClickType = ButtonClickType_None;
    // dismiss the alert with its animation
    [self animateOut];
}

-(void)afterDissmiss{
    
    //cancel
    if(self.btnClickType == ButtonClickType_Cancel){
        if (self.cancelBlock != nil){
            self.cancelBlock();
        }
    }
    
    //ok
    if(self.btnClickType == ButtonClickType_OK){
        switch (self.alertType) {
            case CCCustomContentAlertViewType_TableView:
                if (self.selectionBlock != nil && self.selectIndex != nil) {
                    self.selectionBlock(self.selectIndex);
                }
                break;
               
            default:
                //other
                if (self.okBlock != nil){
                    self.okBlock();
                }
                break;
        }
        
    }
    
    //no button
    if(self.completeBlock != nil){
        self.completeBlock();
    }
}

-(BOOL)checkInputValue{
    switch (self.alertType) {
        case CCCustomContentAlertViewType_TableView:
            break;
        default:
            break;
    }
    
    return YES;
}


#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //---入力
    //入力した全部の文字
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //max length
    if (finalString.length > [maxTextLength intValue]) {
        
        return NO;
    }
    
    return YES;
}

-(void)setMaxTextLength:(NSNumber *)amaxTextLength{
    if (amaxTextLength != nil) {
        maxTextLength = amaxTextLength;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // TODO: Allow multiple sections
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // according to the numberOfRows block code
    return self.numberOfRows(section);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = self.cells(self, indexPath);
    if([self.selectIndex isEqual:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = TABLE_SELECTED_COLOR;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = TABLE_UNSELET_COLOR;
    }
    
    // according to the cells block code
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableRowHeight;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath * old = self.selectIndex;
    if ([indexPath isEqual:old]) {
        self.selectIndex = nil;
    }else{
        self.selectIndex = indexPath;
    }
    //元々の行選択なし
    if (old) {
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:old] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //今回選択した行mark 付き
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadData];
    
}

#pragma mark - UIProcessView

-(void)changeProcessStatusWithNewProcess:(float) progcess withMessage:(NSString*)msg isDismiss:(BOOL) isDismiss{
    self.titleLabel.text = msg;
    ((UIProgressView*)self.contentView).progress = progcess;
    if (isDismiss && progcess == 1) {
        [self completeClick];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (self.alertType) {
        case CCCustomContentAlertViewType_ErrorMsg:
        case CCCustomContentAlertViewType_Message:
            
            [self.timer invalidate];
            [self completeClick];
            break;
            
        default:
            break;
    }
    
    if (CCCustomContentAlertViewMaskType_None == self.maskType) {
        [self.timer invalidate];
        [self completeClick];
    }
}


@end
