//
//  UserPhoneViewController.m
//  LeonisSaleDemo
//
//  Created by leo-mobile-lily on 2/9/15.
//  Copyright (c) 2015 Leonis&Co. All rights reserved.
//

#import "UserPhoneViewController.h"

@interface UserPhoneViewController ()
@property (nonatomic,strong) NSMutableArray * settings;
@end

@implementation UserPhoneViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initValues];
}

-(void)initValues{
    self.settings = [[NSMutableArray alloc]init];
    //version
    NSString* txt = [NSString stringWithFormat:@"%@ - %@",[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"],[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"]];
    [self.settings addObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                              NSLocalizedString(@"LEFT_SETTING_INFO_VERSION",@"アプリバージョン"), @"section",
                                @"1",@"copy"
                              ,[[NSArray alloc] initWithObjects:
                                [[NSDictionary alloc] initWithObjectsAndKeys:
                                 txt, @"text"
                                 ,nil]
                                ,nil], @"values"
                              ,nil]
     ];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.settings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.settings objectAtIndex:section] objectForKey:@"values"] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [[self.settings objectAtIndex:section] objectForKey:@"section"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserInfoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary * dic = [[[self.settings objectAtIndex:indexPath.section] objectForKey:@"values"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"text"];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.detailTextLabel.text = [dic objectForKey:@"detail"];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([self isThisCanBeCopyed:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isThisCanBeCopyed:indexPath]) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[UIPasteboard generalPasteboard] setString:cell.textLabel.text];
    }
}

-(BOOL)isThisCanBeCopyed:(NSIndexPath*)indexPath{
    NSDictionary * dic = [self.settings objectAtIndex:indexPath.section];
    if ([dic.allKeys containsObject:@"copy"]) {
        return YES;
    }
    return NO;
}
@end
