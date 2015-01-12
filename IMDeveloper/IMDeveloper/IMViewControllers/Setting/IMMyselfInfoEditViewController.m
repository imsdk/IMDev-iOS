//
//  IMMyselfInfoEditViewController.m
//  IMDeveloper
//
//  Created by mac on 14-12-12.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMMyselfInfoEditViewController.h"

@interface IMMyselfInfoEditViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate> {
    UITextView *_textView;
    UITableView *_tableView;
    UIBarButtonItem *_rightBarButtonItem;
}

- (void)rightBarButtonItemClick:(id)sender;
@end

@implementation IMMyselfInfoEditViewController {
    NSIndexPath *_lastSelectIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    [[self navigationItem] setRightBarButtonItem:_rightBarButtonItem];
    
    _tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [[self view] addSubview:_tableView];
    
    switch (_type) {
        case 2:
        case 3:
        {
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, 300, 200)];
            
            [[_textView layer] setCornerRadius:5.0f];
            [_textView setText:_content];
            [_textView setFont:[UIFont systemFontOfSize:15.0f]];
            [_textView becomeFirstResponder];
            [_textView setDelegate:self];
            
            UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
            
            [tableHeaderView setBackgroundColor:[UIColor clearColor]];
            [tableHeaderView addSubview:_textView];
            [_tableView setTableHeaderView:tableHeaderView];
        }
            break;
            
        default:
            break;
    }

    [_tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClick:(id)sender {
    if (_type == 1) {
        if ([_lastSelectIndex row] == 0) {
            _content = @"男";
        }else {
            _content = @"女";
        }
    } else {
        _content = [_textView text];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(customUerInfoEdit:content:)]) {
        [_delegate customUerInfoEdit:_type content:_content];
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == 1) {
        return 2;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (_type == 1) {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:@"男"];
        } else {
            [[cell textLabel] setText:@"女"];
        }
        
        if ([_content isEqualToString:[[cell textLabel] text]]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            _lastSelectIndex = indexPath;
        } else {
            if ([_content length] == 0) {
                if ([indexPath row] == 0) {
                    _lastSelectIndex = indexPath;
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];

            }
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:_lastSelectIndex];
    if (cell) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    _lastSelectIndex = indexPath;
}


#pragma mark - textview delegate 

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if (_type == 2) {
        if ([[textView text] length] + [text length] > 12 ) {
            return NO;
        }
    } else if(_type == 3) {
        if ([[textView text] length] + [text length] > 25 ) {
            return NO;
        }
    }
    
    if ([text isEqualToString:@"\n"]) {
        [[self view] endEditing:YES];
        
        return NO;
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
