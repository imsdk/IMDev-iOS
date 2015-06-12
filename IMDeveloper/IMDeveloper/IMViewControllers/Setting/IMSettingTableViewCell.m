//
//  IMSettingTableViewCell.m
//  IMDeveloper
//
//  Created by mac on 14-12-12.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMSettingTableViewCell.h"
#import "IMDefine.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"
#import "IMSDK+CustomUserInfo.h"
#import "IMSDK+Nickname.h"

@implementation IMSettingTableViewCell {
    UIImageView *_headView;
    UILabel *_usernameLabel;
    UILabel *_locationLabel;
    UILabel *_customUserIDLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 70, 70)];
        
        [[_headView layer] setCornerRadius:5.0f];
        [_headView setClipsToBounds:YES];
        [_headView setContentMode:UIViewContentModeScaleAspectFill];
        [[self contentView] addSubview:_headView];
        
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 2, 200, 46)];
        
        [_usernameLabel setBackgroundColor:[UIColor clearColor]];
        [_usernameLabel setTextColor:[UIColor blackColor]];
        [_usernameLabel setFont:[UIFont systemFontOfSize:20]];
        [[self contentView] addSubview:_usernameLabel];
        
        _customUserIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 48, 200, 28)];
        
        [_customUserIDLabel setTextColor:[UIColor grayColor]];
        [_customUserIDLabel setFont:[UIFont systemFontOfSize:15]];
        [_customUserIDLabel setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:_customUserIDLabel];
    }
    return self;
}

- (void)setNickname:(NSString *)nickname {
    _nickname = nickname;
    
    if ([nickname length] == 0) {
        _nickname = _customUserID;
    }
    
    [_usernameLabel setText:_nickname];
}

- (void) setCustomUserID:(NSString *)customUserID {
    _customUserID = customUserID;
    
    [_customUserIDLabel setText:[NSString stringWithFormat:@"爱萌账号:%@",_customUserID]];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeadImage:) name:IMReloadMainPhotoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNickName:) name:IMNickNameUpdatedNotification object:nil];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHeadPhoto:(UIImage *)headPhoto {
    _headPhoto = headPhoto;
    [_headView setImage:_headPhoto];
}

- (void)reloadHeadImage:(NSNotification *)note {
    if (![note.object isEqual:_customUserID]) {
        return;
    }
    
    _headPhoto = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headPhoto == nil) {
        NSString *customInfo = [g_pIMSDK customUserInfoWithCustomUserID:_customUserID];
        
        NSArray *customInfoArray = [customInfo componentsSeparatedByString:@"\n"];
        NSString *sex = nil;
        
        if ([customInfoArray count] > 0) {
            sex = [customInfoArray objectAtIndex:0];
        }
        
        if ([sex isEqualToString:@"女"]) {
            _headPhoto = [UIImage imageNamed:@"IM_head_female.png"];
        } else {
            _headPhoto = [UIImage imageNamed:@"IM_head_male.png"];
        }
    }
    
    [_headView setImage:_headPhoto];
}

- (void)reloadNickName:(NSNotification *)note {
    if (![note.object isEqualToString:_customUserID]) {
        return;
    }
    
    NSString *nickName = [g_pIMSDK nicknameOfUser:_customUserID];
    
    if ([nickName length] == 0) {
        nickName = _customUserID;
    }
    
    [_usernameLabel setText:nickName];
}

@end
