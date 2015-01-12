//
//  IMHeadIcon.m
//  IMDeveloper
//
//  Created by mac on 14/12/24.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMHeadIcon.h"
#import "UIView+IM.h"
#import "IMDefine.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"

@implementation IMHeadIcon {
    UIImage *_headImage;
    
    UIImageView *_headView;
    UILabel *_nameLabel;
    UIImageView *_deleteView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
        
        [[_headView layer] setCornerRadius:5.0];
        [_headView setBackgroundColor:[UIColor clearColor]];
        [_headView setContentMode:UIViewContentModeScaleAspectFill];
        [_headView setClipsToBounds:YES];
        [self addSubview:_headView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _headView.bottom, _headView.width, 20)];
        
        [_nameLabel setNumberOfLines:1];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_nameLabel];
        
        _deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
        
        [_deleteView setImage:[UIImage imageNamed:@"IM_delete_member.png"]];
        [self addSubview:_deleteView];
        [_deleteView setHidden:YES];
    }
    return self;
}

- (void)setCustomUserID:(NSString *)customUserID {
    if (![customUserID isKindOfClass:[NSString class]]) {
        return;
    }
    
    _customUserID = customUserID;
    [_nameLabel setText:customUserID];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeadImage) name:IMReloadMainPhotoNotification(_customUserID) object:nil];
    
    _headImage = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headImage == nil) {
        _headImage = [UIImage imageNamed:@"IM_head_default.png"];
        [g_pIMSDK requestMainPhotoOfUser:_customUserID success:^(UIImage *mainPhoto) {
            if (mainPhoto) {
                [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadMainPhotoNotification(_customUserID) object:nil];
            }
            
        } failure:^(NSString *error) {
            
        }];
    }
    
    [_headView setImage:_headImage];
    
}

- (void)reloadHeadImage {
    _headImage = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headImage == nil) {
        _headImage = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [_headView setImage:_headImage];
}

- (void)setDeleteStatus:(BOOL)deleteStatus {
    _deleteStatus = deleteStatus;
    
    if (_deleteStatus) {
        [_deleteView setHidden:NO];
    } else {
        [_deleteView setHidden:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
