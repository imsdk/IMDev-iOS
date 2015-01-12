//
//  IMGroupInfoEditViewController.m
//  IMDeveloper
//
//  Created by mac on 14/12/25.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMGroupInfoEditViewController.h"

@interface IMGroupInfoEditViewController ()<UITextViewDelegate> {
    UITextView *_textView;
    UITableView *_tableView;
    UIBarButtonItem *_rightBarButtonItem;
}

- (void)rightBarButtonItemClick:(id)sender;
@end

@implementation IMGroupInfoEditViewController

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
    [[self view] addSubview:_tableView];
    
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
    
    [_tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemClick:(id)sender {
    _content = [_textView text];
    
    if (_delegate && [_delegate respondsToSelector:@selector(customGroupInfoEdit:content:)]) {
        [_delegate customGroupInfoEdit:_type content:_content];
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark - textview delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (_type == 1) {
        if ([[textView text] length] + [text length] > 10 ) {
            return NO;
        }
    } else if(_type == 2) {
        if ([[textView text] length] + [text length] > 50 ) {
            return NO;
        }
    }
    
    if ([text isEqualToString:@"\n"]) {
        [[self view] endEditing:YES];
        
        return NO;
    }
    
    return YES;
}


@end
