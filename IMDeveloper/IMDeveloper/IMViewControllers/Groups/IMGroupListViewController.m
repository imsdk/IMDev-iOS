//
//  IMGroupListViewController.m
//  IMDeveloper
//
//  Created by mac on 14/12/23.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMGroupListViewController.h"
#import "IMDefine.h"
#import "IMContactTableViewCell.h"
#import "NSString+IM.h"
#import "IMGroupDialogViewController.h"
#import "IMCreateGroupViewController.h"

//IMSDK Headers
#import "IMGroupInfo.h"
#import "IMSDK+Group.h"
#import "IMMyself+Group.h"

@interface IMGroupListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, IMGroupInfoUpdateDelegate>

- (void)initViews;
- (void)initData;

@end

@implementation IMGroupListViewController {
    NSMutableArray *_groupList;
    NSMutableArray *_searchResult;
    
    //ui
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;
    UILabel *_totalNumLabel;
    UIBarButtonItem *_rightBarButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_titleLabel setText:@"群聊"];
    
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建群" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    _groupList = [[NSMutableArray alloc] initWithCapacity:32];
    _searchResult = [[NSMutableArray alloc] initWithCapacity:32];
    
    [self initViews];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:IMGroupListDidInitializeNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClick:(id)sender {
    if (sender != _rightBarButtonItem) {
        return;
    }
    
    IMCreateGroupViewController *controller = [[IMCreateGroupViewController alloc] init];
    
    [[self navigationController] pushViewController:controller animated:YES];
    
}

- (void)initViews {
    CGRect rect = [[self view] bounds];
    
    rect.size.height -= 64;
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:RGB(242, 242, 242)];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    [_searchBar setDelegate:self];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    [_searchBar setPlaceholder:@"搜索群"];
    
    UIView *customTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    
    [customTableHeaderView addSubview:_searchBar];
    [_tableView setTableHeaderView:customTableHeaderView];
    
    UIView *customTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    
    [customTableFooterView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:customTableFooterView];
    
    _totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 88)];
    
    [_totalNumLabel setBackgroundColor:[UIColor clearColor]];
    [_totalNumLabel setTextAlignment:NSTextAlignmentCenter];
    [_totalNumLabel setTextColor:[UIColor grayColor]];
    [_totalNumLabel setNumberOfLines:0];
    [_totalNumLabel setFont:[UIFont systemFontOfSize:18]];
    [customTableFooterView addSubview:_totalNumLabel];
    
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    
    [_searchDisplayController setDelegate:self];
    [_searchDisplayController setSearchResultsDataSource:self];
    [_searchDisplayController setSearchResultsDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:IMReloadGroupListNotification object:nil];
}

- (void)initData {
    [_groupList removeAllObjects];
    NSArray *array = [g_pIMMyself myGroupList];
    
    for (NSString *groupID in array) {
        IMGroupInfo *info = [g_pIMSDK groupInfoWithGroupID:groupID];
        
        [info setDelegate:self];
        
        if (info) {
            [_groupList addObject:info];
        }
    }
    
    if (![g_pIMMyself groupInitialized] && [g_pIMMyself loginStatus] == IMMyselfLoginStatusLogined) {
        [_totalNumLabel setText:@"正在获取群组列表..."];
        [_totalNumLabel setCenter:CGPointMake(160, 240)];

    }else if ([_groupList count] == 0) {
        [_totalNumLabel setText:@"当前没有加入任何群组，您可以去创建一个群"];
        [_totalNumLabel setCenter:CGPointMake(160, 240)];

    } else  {
        [_totalNumLabel setText:[NSString stringWithFormat:@"%lu个群组",(unsigned long)[_groupList count]]];
        [_totalNumLabel setFrame:CGRectMake(10, 0, 300, 88)];
    }
    
    [_tableView reloadData];
}

- (void)reloadData {
    [self initData];
}

- (void)searchGroupWithGroupName:(NSString *)searchString {
    [_searchResult removeAllObjects];
    
    [_searchResult addObjectsFromArray:[self searchSubString:searchString inArray:_groupList]];
    
}

- (NSArray *)searchSubString:(NSString *)searchString inArray:(NSArray *)sourceArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (IMGroupInfo *info in sourceArray) {
        if (![info isKindOfClass:[IMGroupInfo class]]) {
            continue;
        }
        
        if (![[info groupName] isKindOfClass:[NSString class]]) {
                continue;
        }
            
        NSRange range = [[[(NSString *)[info groupName] pinYin] uppercaseString] rangeOfString:[searchString uppercaseString]];
            
        if (range.location != NSNotFound) {
            [resultArray addObject:info];
        }
    }
    
    NSArray *sortArray = [resultArray sortedArrayUsingFunction:Array_sortByPinyin context:NULL];
    
    return sortArray;
}


#pragma mark - searchBar delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchGroupWithGroupName:searchString];
    return YES;
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return [_groupList count];
    }
    
    return [_searchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    
    IMContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[IMContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell setHeadPhoto:[UIImage imageNamed:@"IM_head_default"]];
    
    if (tableView == _tableView) {
        if ([_groupList count] <= [indexPath row]) {
            return cell;
        }
        
        IMGroupInfo *info = [_groupList objectAtIndex:[indexPath row]];
        
        [cell setCustomUserID:[info groupName]];
    } else {
        if ([_searchResult count] <= [indexPath section]) {
            return cell;
        }
        
        IMGroupInfo *info = [_searchResult objectAtIndex:[indexPath row]];
        
        [cell setCustomUserID:[info groupName]];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IMGroupDialogViewController *controller = [[IMGroupDialogViewController alloc] init];
    IMGroupInfo *info = nil;
    
    if (_tableView == tableView) {
        if ([_groupList count] <= [indexPath row]) {
            return;
        }
        
        info = [_groupList objectAtIndex:[indexPath row]];

        if (!info || ![info groupID]) {
            return;
        }
    } else {
        if ([_searchResult count] <= [indexPath row]) {
            return;
        }
        
        info = [_searchResult objectAtIndex:[indexPath row]];
        
        if (!info || ![info groupID]) {
            return;
        }
        
    }

    [controller setGroupID: [info groupID]];

    [[self navigationController] pushViewController:controller animated:YES];
    
}


#pragma mark - IMGroupInfoDelegate

- (void)didUpdateGroupInfo:(IMGroupInfo *)groupInfo {
    [_tableView reloadData];
}

- (void)didUpdateMemberListForGroupInfo:(IMGroupInfo *)groupInfo {
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
