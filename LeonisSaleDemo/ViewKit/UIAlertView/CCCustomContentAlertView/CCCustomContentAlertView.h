//
//  CCCustomContentAlertView.h
//  haios
//
//  Created by leo-mobile-lily on 9/10/13.
//  Copyright (c) 2013 Leonis All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CCCustomContentAlertViewType_TextView,
    CCCustomContentAlertViewType_TableView,
    CCCustomContentAlertViewType_ProgressView,
    CCCustomContentAlertViewType_Label,
    CCCustomContentAlertViewType_Message,
    CCCustomContentAlertViewType_ErrorMsg,
    CCCustomContentAlertViewType_ActivityIndicator,
}CCCustomContentAlertViewType;

typedef enum {
    CCCustomContentAlertViewMaskType_None = 1
}
CCCustomContentAlertViewMaskType;

@class CCCustomContentAlertView;

//-----------------Blocks definition---------------------
//Blocks definition for button
typedef void (^CCCustomContentAlertOKBlock)(void);
typedef void (^CCCustomContentAlertCancelBlock)(void);
typedef void (^CCCustomContentAlertCompleteBlock)(void);

//Blocks definition for table view
typedef NSInteger (^CCCustomContentAlertNumberOfRowsBlock)(NSInteger section);
typedef UITableViewCell* (^CCCustomContentAlertTableCellsBlock)(CCCustomContentAlertView *alert, NSIndexPath *indexPath);
typedef void (^CCCustomContentAlertRowSelectionBlock)(NSIndexPath *selectedIndex);

//--------------------------------------------------------------------------------------------------
@interface CCCustomContentAlertView : UIView

//-----------------Init alert-------------------
//init alert
-(id)initWithType:(CCCustomContentAlertViewType)alertViewType;
-(id)initWithType:(CCCustomContentAlertViewType)alertViewType withMask:(CCCustomContentAlertViewMaskType)mskType;
-(id)initWithTitle:(NSString *)title withType:(CCCustomContentAlertViewType)alertViewType withText:(NSString*)text;
-(id)initWithTitle:(NSString *)title withType:(CCCustomContentAlertViewType)alertViewType withText:(NSString*)text withShowTime:(float)showTime;
-(id)initWithTitle:(NSString *)title withType:(CCCustomContentAlertViewType)alertViewType withText:(NSString *)text withCancelButtonTitle:(NSString*) cancelButtonTitle withOKButtonTitle:(NSString *)okButtonTitle;
//init alert with uitableview
-(id)initWithTitle:(NSString *)title withTableNumberOfRows:(CCCustomContentAlertNumberOfRowsBlock)rowsBlock withTableCells:(CCCustomContentAlertTableCellsBlock)cellsBlock;
//-----------------Show alert-------------------
//show alert
-(void)show;
//dissmiss alert
-(void)dismiss;

//-----------------Dissmision alert---------------------
//ok cancel
-(void)configureOKBlock:(CCCustomContentAlertOKBlock)okBlock andCancelBlock:(CCCustomContentAlertCancelBlock)cancelBlock;
//uitableview select cancel
-(void)configureSelectBlock:(CCCustomContentAlertRowSelectionBlock) selBlock andCancelBlock:(CCCustomContentAlertCancelBlock)cancelBlock;
-(void)configureCompleteBlock:(CCCustomContentAlertCompleteBlock)completeBlock;

//-----------------Property---------------------
@property (nonatomic,strong) NSIndexPath * selectIndex;
@property (nonatomic,strong) NSNumber* maxTextLength;

-(void)changeProcessStatusWithNewProcess:(float) progcess withMessage:(NSString*)msg isDismiss:(BOOL) isDismiss;

@end
