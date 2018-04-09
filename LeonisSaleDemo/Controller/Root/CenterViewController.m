//
//  CenterViewController.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 12/22/14.
//  Copyright (c) 2014 Leonis&Co. All rights reserved.
//

#import "CenterViewController.h"

#import "OfferCell.h"
#import "OfferCoupon.h"

#import "DataProvider.h"

//present
#import "PresentViewController.h"

@interface CenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PresentViewControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray * tableViewDataSource;

@property (nonatomic,strong) PresentViewController *presentViewController;

@end

float const TABLE_HEARDER = 10;

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageName = PAGE_DEFALUT;
    self.clickName = PAGE_DEFALUT;
    
    [self initViews];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isNoNeedRefresh) {
        self.isNoNeedRefresh = NO;
        return;
    }
    
    [self loadData];
    
}

#pragma mark - View

-(void)initViews{
    
    [self initTableViewList];
    
}

-(void)initTableViewList{
    
    [self addViews];
    
    self.scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    self.tableView.delegate = (id)self.scrollProxy;
    self.scrollProxy.delegate = self;
    
}

-(void)addViews{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView setBackgroundColor:SYS_COLOR_BACKGROUND];
    
    [self.tableView addSubview:[self createRefreshView]];
    [self.tableView addSubview:[self createNumberView]];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - Data
-(void)loadData{
    
    //ローディング
    [self startLoading];
    
    [DataProvider requestDataWithPageType:self.pageName complate:^(NSArray *datas) {
        [self afterGetData:datas];
    }];

    
}

-(void)afterGetData:(NSArray *)datas{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setNumberViewWithNumber:datas.count];
        
        _tableViewDataSource = datas;
        [self.tableView reloadData];
        
        [self stopLoading];
        
    });
}

-(void)clearTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self scrollToTop:NO];
        
        _tableViewDataSource = nil;
        [self.tableView reloadData];
    });
}

-(void)scrollToTop{
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark - Tableview Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfferCell * cell = [self createCellTableView:tableView];
    [cell setData:[_tableViewDataSource objectAtIndex:[self getIndex:indexPath]]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OfferCell * cell = [self createCellTableView:tableView];
    [cell setData:[_tableViewDataSource objectAtIndex:[self getIndex:indexPath]]];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
}

-(OfferCell*)createCellTableView:(UITableView *)tableView{
    static NSString * const identifier = @"CenterViewControllerCellId";
    OfferCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[OfferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openToDetail:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEARDER;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _tableViewDataSource.count - 1) {
        return TABLE_HEARDER;
    }
    
    return 0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

-(NSInteger)getIndex:(NSIndexPath*)index{
    return index.section;
}


#pragma mark -
#pragma mark Delegate

-(void)detailUsedInIndex:(NSInteger)index{

}

-(void)presentViewDismissWithType:(int)type withData:(NSObject *)data{
    
}

#pragma mark -
#pragma mark Override
-(void)afterSelectLeft:(int)pageType{
    
        switch (self.clickName) {
                case PageType_Coupon:
                case PageType_Reco:
                 [self loadData];
                break;
            case PageType_UserNo:
            case PageType_UserPhone:
            case PageType_Site:
                self.isNoNeedRefresh = YES;
                [self openPresentView:pageType];
                break;
                
            default:
                break;
        }
}

#pragma mark -
#pragma mark Detail
-(void)openToDetail:(NSIndexPath*)index{
//    NSInteger dataIndex = [self getIndex:index];
//    NSObject * selectObject = [_tableViewDataSource objectAtIndex:dataIndex];
}

-(void)openPresentView:(int)type{
    if (_presentViewController == nil) {
        _presentViewController = [[PresentViewController alloc] init];
    }
    
    _presentViewController.delegate = self;
    [_presentViewController showViewType:type inView:self];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.isLoading == YES) {
        return;
    }
    
    if (scrollView.isDragging) {
        float scrollY = scrollView.contentOffset.y;
        [super calProccessCircle:scrollY];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.isLoading == YES) {
        return;
    }
    
    if(decelerate == NO){
        return;
    }
    
    [super stopProccessCircle:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.loadingProccess == 1 ) {
                [self performSelector:@selector(refresh)];
            }
        });
    }];
}


-(void)refresh{
    
    [self startLoading];
    
    [self loadData];
}

@end
