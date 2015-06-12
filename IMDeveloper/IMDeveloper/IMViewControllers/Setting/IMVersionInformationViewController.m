//
//  IMVersionInformationViewController.m
//  IMDeveloper
//
//  Created by mac on 15/3/23.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import "IMVersionInformationViewController.h"
#import "IMSDK.h"

@interface IMVersionInformationViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation IMVersionInformationViewController {
    UILabel *_verisonLabel;
    
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [[self view] addSubview:_tableView];
    
//    _verisonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20, 160)];
//    
//    [_verisonLabel setText:[NSString stringWithFormat:@"版本号:v1.2.6\n\n版本信息:1、新增注册界面\n               2、修复了一些bug\n\n版权所有:爱朦通信科技有限公司"]];
//    [_verisonLabel setNumberOfLines:0];
//    [[self view] addSubview:_verisonLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    
    if ([indexPath row] == 0) {
        [[cell textLabel] setText:@"版本号"];
        [[cell detailTextLabel] setText:@"v1.3.2"];
    } else if ([indexPath row] == 1) {
        [[cell textLabel] setText:@"版本信息"];
        [[cell detailTextLabel] setText:@"聊天界面优化"];
        [[cell detailTextLabel] setNumberOfLines:0];
    } else {
        [[cell textLabel] setText:@"版权所有"];
        [[cell detailTextLabel] setText:@"爱朦通信科技有限公司"];
    }
    
    [[cell detailTextLabel] setTextAlignment:NSTextAlignmentLeft];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 1) {
        return 66;
    } else {
        return 44;
    }
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
