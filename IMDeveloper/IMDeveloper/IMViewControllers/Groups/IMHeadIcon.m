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
#import "IMSDK+CustomUserInfo.h"
#import "IMSDK+Nickname.h"

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
    
    NSString *nickname = [g_pIMSDK nicknameOfUser:_customUserID];
    
    if ([nickname length] == 0) {
        nickname = _customUserID;
    }
    
    [_nameLabel setText:nickname];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeadImage:) name:IMReloadMainPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNickName:) name:IMNickNameUpdatedNotification object:nil];
    
    _headImage = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headImage == nil) {
        NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:customUserID];
        
        NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
        NSString *sex = nil;
        
        if ([customInfoArray count] > 0) {
            sex = [customInfoArray objectAtIndex:0];
        }
        
        if ([sex isEqualToString:@"女"]) {
            _headImage = [UIImage imageNamed:@"IM_head_female.png"];
        } else {
            _headImage = [UIImage imageNamed:@"IM_head_male.png"];
        }
        
        [g_pIMSDK requestMainPhotoOfUser:_customUserID success:^(UIImage *mainPhoto) {
            if (mainPhoto) {
                [[NSNotificationCenter defaultCenter] postNotificationName:IMReloadMainPhotoNotification object:_customUserID];
            }
            
        } failure:^(NSString *error) {
            
        }];
    }
    
    [_headView setImage:_headImage];
    
}

- (void)reloadHeadImage:(NSNotification *)note {
    if (![note.object isEqual:_customUserID]) {
        return;
    }
    
    _headImage = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headImage == nil) {
        _headImage = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [_headView setImage:_headImage];
}

- (void)reloadNickName:(NSNotification *)note {
    if (![note.object isEqualToString:_customUserID]) {
        return;
    }
    
    NSString *nickName = [g_pIMSDK nicknameOfUser:_customUserID];
    
    if ([nickName length] == 0) {
        nickName = _customUserID;
    }
    
    [_nameLabel setText:nickName];
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
