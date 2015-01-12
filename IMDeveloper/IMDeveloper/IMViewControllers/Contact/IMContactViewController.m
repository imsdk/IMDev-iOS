//
//  IMContactViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMContactViewController.h"
#import "IMSearchUserViewController.h"
#import "IMDefine.h"
#import "NSString+IM.h"
#import "IMUserInformationViewController.h"
#import "IMContactTableViewCell.h"
#import "IMGroupListViewController.h"

//IMSDK Headers
#import "IMMyself+Relationship.h"
#import "IMSDK+MainPhoto.h"

@interface IMContactViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

// add friends
- (void)addFriends:(id)sender;
//load data
- (NSMutableArray *)classifyData:(NSArray *)array;
- (void)searchUserForCustomUserID:(NSString *)searchString;
- (NSArray *)searchSubString:(NSString *)searchString inArray:(NSArray *)sourceArray;

@end

@implementation IMContactViewController {
    //Data
    NSMutableArray *_friendList;
    NSMutableArray *_searchResult;
    NSMutableArray *_friendTitles;
    
    //UI
    UIBarButtonItem *_rightBarButtonItem;
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    UILabel *_totalNumLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"联系人"];
        [_titleLabel setText:@"联系人"];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"IM_contact_normal.png"]];
     
        _friendTitles = [[NSMutableArray alloc] initWithCapacity:32];
        _searchResult = [[NSMutableArray alloc] initWithCapacity:32];
        
        //notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReloadFriendlistNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReloadBlacklistNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:IMRelationshipDidInitializeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addFriends:)];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    CGRect rect = [[self view] bounds];
    
    rect.size.height -= 114;
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:RGB(242, 242, 242)];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [_searchBar setDelegate:self];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    [_searchBar setPlaceholder:@"搜索好友"];
    
    UIView *customTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    
    [customTableHeaderView addSubview:_searchBar];
    [_tableView setTableHeaderView:customTableHeaderView];
    
    UIView *customTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    
    [customTableFooterView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:customTableFooterView];
    
    _totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)];
    
    [_totalNumLabel setBackgroundColor:[UIColor clearColor]];
    [_totalNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_totalNumLabel setTextColor:[UIColor grayColor]];
    [_totalNumLabel setNumberOfLines:0];
    [_totalNumLabel setFont:[UIFont systemFontOfSize:18]];
    [customTableFooterView addSubview:_totalNumLabel];
    
    if (![g_pIMMyself relationshipInitialized] && [g_pIMMyself loginStatus] == IMMyselfLoginStatusLogined) {
        [_totalNumLabel setText:@"正在获取好友列表..."];
        [_totalNumLabel setCenter:CGPointMake(160, 180)];
    }else if ([_friendList count] > 0) {
        [_totalNumLabel setText:[NSString stringWithFormat:@"%lu位联系人",(unsigned long)[_friendList count]]];
        [_totalNumLabel setFrame:CGRectMake(10, 0, 300, 44)];

    } else {
        [_totalNumLabel setText:@"您当前还没有好友，快去添加好友吧"];
        [_totalNumLabel setCenter:CGPointMake(160, 180)];

    }

    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    [_searchDisplayController setDelegate:self];
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setSearchResultsDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFriends:(id)sender {
    if (sender != _rightBarButtonItem) {
        return;
    }
    
    IMSearchUserViewController *controller = [[IMSearchUserViewController alloc] init];
    
    [controller setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)loadData {
    [_friendTitles removeAllObjects];
    
    NSArray *friendList = [g_pIMMyself friends];
    
    _friendList = [self classifyData:friendList];
    
    [_tableView reloadData];
    
    if (![g_pIMMyself relationshipInitialized] && [g_pIMMyself loginStatus] == IMMyselfLoginStatusLogined) {
        [_totalNumLabel setText:@"正在获取好友列表..."];
        [_totalNumLabel setCenter:CGPointMake(160, 180)];
    }else if ([_friendList count] > 0) {
        [_totalNumLabel setText:[NSString stringWithFormat:@"%lu位联系人",(unsigned long)[friendList count]]];
        [_totalNumLabel setFrame:CGRectMake(10, 0, 300, 44)];

    } else {
        [_totalNumLabel setText:@"您当前还没有好友，快去添加好友吧"];
        [_totalNumLabel setCenter:CGPointMake(160, 180)];
        
    }
}


- (NSMutableArray *)classifyData:(NSArray *)array {
    NSMutableArray *classificationArray = [[NSMutableArray alloc] initWithCapacity:32];
    
    array = [array sortedArrayUsingFunction:Array_sortByPinyin context:NULL];
    
    NSInteger offset = 0;
    
    NSMutableArray *symbolArray = [[NSMutableArray alloc] initWithCapacity:32];
    
    for (char c = 'A'; c <= 'Z'; c ++) {
        NSMutableArray *characterArray = [[NSMutableArray alloc] initWithCapacity:32];
        
        for (NSInteger i = offset; i < [array count]; i ++) {
            NSString *customUserID = [array objectAtIndex:i];
            
            if (![customUserID isKindOfClass:[NSString class]]) {
                offset ++;
                continue;
            }
            
            if (![[customUserID firstCharactor] isEqualToString:[NSString stringWithFormat:@"%c",c]]) {
                if ([[customUserID firstCharactor] compare:@"A"] == NSOrderedAscending ||
                    [[customUserID firstCharactor] compare:@"Z"] == NSOrderedDescending) {
                    [symbolArray addObject:customUserID];
                    offset ++;
                    continue;
                }
                
                break;
            }
            
            [characterArray addObject:customUserID];
            offset ++;
        }
        
        if ([characterArray count] > 0) {
            
            [_friendTitles addObject:[NSString stringWithFormat:@"%c",c]];
            
            [classificationArray addObject:characterArray];
        }
    }
    
    if ([symbolArray count] > 0) {
        [_friendTitles addObject:@"#"];
        
        [classificationArray addObject:symbolArray];
    }
    
    return classificationArray;
}

- (void)searchUserForCustomUserID:(NSString *)searchString {
    [_searchResult removeAllObjects];
    
    [_searchResult addObjectsFromArray:[self searchSubString:searchString inArray:_friendList]];
    
}

- (NSArray *)searchSubString:(NSString *)searchString inArray:(NSArray *)sourceArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (NSArray *array in sourceArray) {
        if (![array isKindOfClass:[NSArray class]]) {
            continue;
        }
        
        for (NSString *customUserID in array) {
            if (![customUserID isKindOfClass:[NSString class]]) {
                continue;
            }
            
            NSRange range = [[[customUserID pinYin] uppercaseString] rangeOfString:[searchString uppercaseString]];
            
            if (range.location != NSNotFound) {
                [resultArray addObject:customUserID];
            }
        }
    }
    
    NSArray *sortArray = [resultArray sortedArrayUsingFunction:Array_sortByPinyin context:NULL];
    
    return sortArray;
}


#pragma mark - searchBar delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchUserForCustomUserID:searchString];
    return YES;
}

#pragma mark - table view datasource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return _friendTitles;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if ([_friendTitles count] <= section - 1) {
            return nil;
        }
        
        if (section == 0) {
            return nil;
        }
        
        return [_friendTitles objectAtIndex:section - 1];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if(section == 0) {
            return 0;
        }
        
        return 24.0f;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return [_friendList count] + 1;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 0) {
            return 1;
        }
        
        if ([_friendList count] <= section - 1) {
            return 0;
        }
        
        NSMutableArray *array = [_friendList objectAtIndex:section - 1];
        
        return [array count];
    }
    
    return [_searchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[IMContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *customUserID = nil;
    
    if (tableView == _tableView) {
        //list
        if ([indexPath section] == 0) {
            customUserID = @"群聊";
        } else  {
            NSMutableArray *array = nil;
            
            if ([_friendList count] <= [indexPath section] - 1) {
                return cell;
            }
            
            array = [_friendList objectAtIndex:[indexPath section] - 1];
            
            if ([array count] <= [indexPath row]) {
                return cell;
            }
            
            customUserID = [array objectAtIndex:[indexPath row]];

        }
        
    } else {
        //search result
        if ([_searchResult count] <= [indexPath row]) {
            return cell;
        }
        
        customUserID = [_searchResult objectAtIndex:[indexPath row]];
    }
    
    [(IMContactTableViewCell *)cell setCustomUserID: customUserID];
    
    UIImage *image = nil;
    
    if ([indexPath section] == 0) {
        image = [UIImage imageNamed:@"IM_head_default.png"];
    } else {
        image = [g_pIMSDK mainPhotoOfUser:customUserID];
    }
    
    if (image == nil) {
        image = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [(IMContactTableViewCell *)cell setHeadPhoto:image];
    
    return cell;
}


#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *customUserID = nil;
    
    if (_tableView == tableView) {
        if ([indexPath section] == 0) {
            IMGroupListViewController *controller = [[IMGroupListViewController alloc] init];
            
            [controller setHidesBottomBarWhenPushed:YES];
            [[self navigationController] pushViewController:controller animated:YES];
            return;
        }
        
        if ([_friendList count] <= [indexPath section] - 1) {
            return;
        }
        
        NSArray *array = [_friendList objectAtIndex:[indexPath section] - 1];
        
        if (![array isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if ([array count] <= [indexPath row]) {
            return;
        }

        customUserID = [array objectAtIndex:[indexPath row]];
        
        if (![customUserID isKindOfClass:[NSString class]]) {
            return;
        }
            
    } else {
        if ([_searchResult count] <= [indexPath row]) {
            return;
        }
        
        customUserID = [_searchResult objectAtIndex:[indexPath row]];
        
        if (![customUserID isKindOfClass:[NSString class]]) {
            return;
        }
    }
    
    IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
    
    [controller setCustomUserID:customUserID];
    [controller setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:controller animated:YES];
}


#pragma mark - notifications

- (void)reloadData {
    [self loadData];
}


@end
