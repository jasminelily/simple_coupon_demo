//
//  CenterViewController.h
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/22/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import "LeftViewController.h"
#import "CCLeftSideHeader.h"

#import "UserDataProvider.h"
#import "LocalSaveHelper.h"

static int const TABLE_VIEW_HEADER_HEIGHT = 30;
static int const TABLE_VIEW_TITLE_HEIGHT = 80;

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSArray * dataSourceSection;
@property (nonatomic,strong) NSArray * dateSourceArray;
@property (nonatomic,strong) CCLeftSideHeader * titleView;
@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addHeader];
    [self addTable];
    
    [self getHeaderData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setDataSource];
}

-(void)addHeader{
    
    _titleView = [[CCLeftSideHeader alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), TABLE_VIEW_TITLE_HEIGHT)];
    [self.view addSubview:_titleView];
}

-(void)addTable{
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_titleView.frame),CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame) - CGRectGetHeight(_titleView.frame))];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = LEFT_VIEW_BACK_COLOR;
    [self.view addSubview:tableView];
}

-(void)setHeader:(UserModel*)user{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_titleView setSideHeader:user];
    });
}

-(void)getHeaderData{
    [UserDataProvider requestDataWithType:DataType_User withParameter:nil complate:^(RequestDataCode code, NSObject *obj) {
        if (RequestDataCode_Success == code) {
            UserModel* user = (UserModel*)obj;
            [LocalSaveHelper saveUserInfo:user];
            [self setHeader:user];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceSection.count;
}

#pragma mark -
#pragma mark TableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    
    return TABLE_VIEW_HEADER_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), TABLE_VIEW_HEADER_HEIGHT)];
    UILabel *txt = [[CCLabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(header.frame) - 5, CGRectGetHeight(header.frame))];
    txt.text = [self.dataSourceSection objectAtIndex:section];
    [txt setFont:[UIFont boldSystemFontOfSize:LEFT_HEADER_TEXT_FONT_SIZE]];
    [txt setTextColor:TOPBAR_TEXT_FONT_COLOR];
    [header addSubview:txt];
    [header setBackgroundColor:TOPBAR_BACK_COLOR];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)[self.dateSourceArray objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LeftViewControllerCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString * txt = [[self.dateSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = txt;
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:LEFT_VIEW_TEXT_FONT_SIZE]];
    [cell.textLabel setTextColor:LEFT_VIEW_TEXT_COLOR];
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"actualize"];
        [ConvertHelper changeImage:cell.imageView withColor:LEFT_VIEW_TEXT_COLOR];
    }else{
        cell.imageView.image = nil;
    }
    
    cell.backgroundColor = LEFT_VIEW_BACK_COLOR;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowType = -1;
    BOOL isHidden = YES;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    rowType = PageType_Reset;
                    break;
                default:
                    break;
            }
            
            break;
            
        case 1:
            switch (indexPath.row) {
                    
                case 0:
                    rowType = PageType_Coupon;
                    break;
                case 1:
                    rowType = PageType_Reco;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    rowType = PageType_UserPhone;
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                    
                case 0:
                    rowType = PageType_Site;
                    isHidden = NO;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    void (^afterSelect)(void)  = ^(void) {
        [self.leftDelegate leftViewDidSelectRow:rowType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //select section
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            //scroll to top
            [tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        });
    };
    
    //そのた need to hide
    if (isHidden == YES) {
        [self.frostedViewController hideMenuViewControllerWithCompletionHandler:^{
            afterSelect();
        }];
    }else{
        afterSelect();
    }
}

-(void)setDataSource{
    
    NSArray * section1 = [NSArray arrayWithObjects:NSLocalizedString(@"TOP_LEFT_TITLE_RESET", @"リセット"),nil];
    NSArray * section2 = [NSArray arrayWithObjects:NSLocalizedString(@"TOP_LEFT_TITLE_COUPON_LIST", @"クーポン一覧"),nil];
    NSArray * section3 = [NSArray arrayWithObjects:NSLocalizedString(@"TOP_LEFT_TITLE_USER_PHONE", @"端末情報"),nil];
    NSArray * section4 = [NSArray arrayWithObjects: NSLocalizedString(@"TOP_LEFT_TITLE_SITE_OFFER", @"OFFERs特設サイト"), nil];
    self.dateSourceArray = [NSArray arrayWithObjects:section1,section2,section3,section4, nil];
    self.dataSourceSection = [NSArray arrayWithObjects:@"",NSLocalizedString(@"LEFT_SECTION_SERVICE", @"機能"),NSLocalizedString(@"LEFT_SECTION_ACCOUNT", @"アカウント"),NSLocalizedString(@"LEFT_SECTION_OTHER", @"その他"), nil];
}

@end
