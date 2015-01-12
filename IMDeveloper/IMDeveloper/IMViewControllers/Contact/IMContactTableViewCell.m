//
//  IMContactTableViewCell.m
//  IMDeveloper
//
//  Created by mac on 14-12-11.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMContactTableViewCell.h"
#import "IMDefine.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"

@implementation IMContactTableViewCell {
    UIImageView *_headView;
    UILabel *_usernameLabel;
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
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
        
        [[_headView layer] setCornerRadius:5.0f];
        [_headView setContentMode:UIViewContentModeScaleAspectFill];
        [_headView setClipsToBounds:YES];
        [[self contentView] addSubview:_headView];
        
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, 200, 36)];
        
        [_usernameLabel setBackgroundColor:[UIColor clearColor]];
        [_usernameLabel setTextColor:[UIColor blackColor]];
        [_usernameLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        [[self contentView] addSubview:_usernameLabel];
    }
    return self;
}

- (void)setHeadPhoto:(UIImage *)headPhoto {
    _headPhoto = headPhoto;
    
    if (_headPhoto == nil) {
        _headPhoto = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [_headView setImage:_headPhoto];
}

- (void)setCustomUserID:(NSString *)customUserID {
    _customUserID = customUserID;
    [_usernameLabel setText:customUserID];
    
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

- (void)reloadHeadImage {
    _headPhoto = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headPhoto == nil) {
        _headPhoto = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [_headView setImage:_headPhoto];
}
@end
