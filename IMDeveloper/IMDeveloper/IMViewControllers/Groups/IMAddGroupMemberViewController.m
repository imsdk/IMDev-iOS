//
//  IMAddGroupMemberViewController.m
//  IMDeveloper
//
//  Created by mac on 14/12/25.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMAddGroupMemberViewController.h"
#import "IMContactViewController.h"
#import "IMSearchUserViewController.h"
#import "IMDefine.h"
#import "NSString+IM.h"
#import "IMUserInformationViewController.h"
#import "IMContactTableViewCell.h"
#import "IMGroupListViewController.h"
#import "IMSearchMemberViewController.h"

//IMSDK Headers
#import "IMMyself+Relationship.h"
#import "IMSDK+MainPhoto.h"
#import "IMMyself+Group.h"

@interface IMAddGroupMemberViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

// add friends
- (void)addFriends:(id)sender;
//load data
- (NSMutableArray *)classifyData:(NSArray *)array;
- (void)searchUserForCustomUserID:(NSString *)searchString;
- (NSArray *)searchSubString:(NSString *)searchString inArray:(NSArray *)sourceArray;

@end

@implementation IMAddGroupMemberViewController {
    //Data
    NSMutableArray *_friendList;
    NSMutableArray *_searchResult;
    NSMutableArray *_friendTitles;
    NSIndexPath *_lastIndex;
    NSString *_selectedCustomUserID;
    
    //UI
    UIBarButtonItem *_leftBarButtonItem;
    UIBarButtonItem *_rightBarButtonItem;
    UIBarButtonItem *_doneBarButtonItem;
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
        _friendTitles = [[NSMutableArray alloc] initWithCapacity:32];
        _searchResult = [[NSMutableArray alloc] initWithCapacity:32];
        
        //notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReloadFriendlistNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReloadBlacklistNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查找" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    _doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBarButtonItemClick:)];
    
    [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:_rightBarButtonItem,_doneBarButtonItem,nil]];
    
    _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick:)];
    
    [[self navigationItem] setLeftBarButtonItem:_leftBarButtonItem];
    
    CGRect rect = [[self view] bounds];
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setEditing:YES];
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
    
    _totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [_totalNumLabel setBackgroundColor:[UIColor clearColor]];
    [_totalNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_totalNumLabel setTextColor:[UIColor grayColor]];
    [_totalNumLabel setFont:[UIFont systemFontOfSize:18]];
    [customTableFooterView addSubview:_totalNumLabel];
    
    if ([_friendList count] > 0) {
        [_totalNumLabel setText:[NSString stringWithFormat:@"%lu位联系人",(unsigned long)[_friendList count]]];
    } else {
        [_totalNumLabel setText:@"您当前还没有好友，快去添加好友吧"];
    }
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    [_searchDisplayController setDelegate:self];
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setSearchResultsDelegate:self];
    [[_searchDisplayController searchResultsTableView] setEditing:YES];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneBarButtonItemClick:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMAddGroupMemberNotification object:_selectedCustomUserID];
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonItemClick:(id)sender {
    if (sender != _rightBarButtonItem) {
        return;
    }
    
    IMSearchMemberViewController *controller = [[IMSearchMemberViewController alloc] init];
    
    [controller setCustomUserIDs:_customUserIDs];
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)leftBarButtonItemClick:(id)sender {
    if (sender != _leftBarButtonItem) {
        return;
    }
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData {
    [_friendTitles removeAllObjects];
    
    NSArray *friendList = [g_pIMMyself friends];
    
    _friendList = [self classifyData:friendList];
    
    [_tableView reloadData];
    
    if ([_friendList count] > 0) {
        [_totalNumLabel setText:[NSString stringWithFormat:@"%lu位联系人",(unsigned long)[_friendList count]]];
    } else {
        [_totalNumLabel setText:@"您当前还没有好友，快去添加好友吧"];
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
        if ([_friendTitles count] <= section) {
            return nil;
        }
        
        if (section == 0) {
            return nil;
        }
        
        return [_friendTitles objectAtIndex:section];
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
        return [_friendList count];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 0) {
            return 1;
        }
        
        if ([_friendList count] <= section) {
            return 0;
        }
        
        NSMutableArray *array = [_friendList objectAtIndex:section];
        
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
    
        NSMutableArray *array = nil;
        
        if ([_friendList count] <= [indexPath section]) {
            return cell;
        }
        
        array = [_friendList objectAtIndex:[indexPath section]];
        
        if ([array count] <= [indexPath row]) {
            return cell;
        }
        
        customUserID = [array objectAtIndex:[indexPath row]];
        
        if (customUserID == _selectedCustomUserID) {
            [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            _lastIndex = indexPath;
        }
        
    } else {
        //search result
        if ([_searchResult count] <= [indexPath row]) {
            return cell;
        }
        
        customUserID = [_searchResult objectAtIndex:[indexPath row]];
        if (customUserID == _selectedCustomUserID) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
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
    if (_lastIndex && _lastIndex != indexPath) {
        [_tableView deselectRowAtIndexPath:_lastIndex animated:YES];
    }
    
    IMContactTableViewCell *cell = (IMContactTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    _selectedCustomUserID = [cell customUserID];
    
    if (tableView == _tableView) {
        _lastIndex = indexPath;
    } else {
        [_searchDisplayController setActive:NO animated:NO];
        [_tableView reloadData];
        _lastIndex = nil;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_tableView == tableView) {
        _lastIndex = nil;
        _selectedCustomUserID = nil;
    } else {
        [_searchDisplayController setActive:NO animated:NO];
        [_tableView reloadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        NSArray *array = [_friendList objectAtIndex:[indexPath section]];
        
        NSString *customUserID = [array objectAtIndex:[indexPath row]];
        if ([_customUserIDs containsObject:customUserID]) {
            return UITableViewCellEditingStyleNone;
        }
    } else {
        NSString *customUserID = [_searchResult objectAtIndex:[indexPath row]];
        if ([_customUserIDs containsObject:customUserID]) {
            return UITableViewCellEditingStyleNone;
        }
    }
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}


#pragma mark - notifications

- (void)reloadData {
    [self loadData];
}

@end
