//
//  IMBlackListViewController.m
//  IMDeveloper
//
//  Created by mac on 14/12/29.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMBlackListViewController.h"
#import "IMContactTableViewCell.h"
#import "IMUserInformationViewController.h"

//IMSDK Headers
#import "IMMyself+Relationship.h"
#import "IMSDK+MainPhoto.h"

@interface IMBlackListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation IMBlackListViewController {
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_titleLabel setText:@"黑名单"];
    
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [[self view] addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[g_pIMMyself blacklistUsers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    
    IMContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[IMContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if ([[g_pIMMyself blacklistUsers] count] <= [indexPath row]) {
        return  cell;
    }
    
    UIImage *headPhoto = [g_pIMSDK mainPhotoOfUser:[[g_pIMMyself blacklistUsers] objectAtIndex:[indexPath row]]];
    
    if (headPhoto == nil) {
        headPhoto = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [cell setHeadPhoto:headPhoto];
    [cell setCustomUserID:[[g_pIMMyself blacklistUsers] objectAtIndex:[indexPath row]]];
    
    return cell;
}


#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[g_pIMMyself blacklistUsers] count] <= [indexPath row]) {
        return;
    }
    
    NSString *customUserID = [[g_pIMMyself blacklistUsers] objectAtIndex:[indexPath row]];
    
    IMUserInformationViewController *controller = [[IMUserInformationViewController alloc] init];
    
    [controller setCustomUserID:customUserID];
    [controller setFromUserDialogView:NO];
    [[self navigationController] pushViewController:controller animated:YES];
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
