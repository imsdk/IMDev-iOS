//
//  IMVersionInformationViewController.m
//  IMDeveloper
//
//  Created by mac on 15/3/23.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import "IMVersionInformationViewController.h"
#import "IMSDK.h"

@interface IMVersionInformationViewController ()

@end

@implementation IMVersionInformationViewController {
    UILabel *_verisonLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    _verisonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20, 100)];
    
    [_verisonLabel setText:[NSString stringWithFormat:@"版本号:v1.2.5\n\n版本信息:修复一些群聊bug"]];
    [_verisonLabel setNumberOfLines:0];
    [[self view] addSubview:_verisonLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
