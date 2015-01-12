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

@implementation IMSettingTableViewCell {
    UIImageView *_headView;
    UILabel *_usernameLabel;
    UILabel *_locationLabel;
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
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 42, 200, 26)];
        
        [_locationLabel setTextColor:[UIColor grayColor]];
        [_locationLabel setFont:[UIFont systemFontOfSize:15]];
        [_locationLabel setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:_locationLabel];
    }
    return self;
}

- (void)setLocation:(NSString *)location {
    _location = location;
    
    if (_location == nil) {
        _location = @"未填写";
    }
    
    [_locationLabel setText:[NSString stringWithFormat:@"地区:%@",location]];
}

- (void) setCustomUserID:(NSString *)customUserID {
    _customUserID = customUserID;
    
    [_usernameLabel setText:_customUserID];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeadImage) name:IMReloadMainPhotoNotification(customUserID) object:nil];
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

- (void)reloadHeadImage {
    _headPhoto = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headPhoto == nil) {
        _headPhoto = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [_headView setImage:_headPhoto];
}

@end
