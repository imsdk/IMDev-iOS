//
//  IMMyselfInfoTableViewCell.m
//  IMDeveloper
//
//  Created by mac on 14-12-12.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMMyselfInfoTableViewCell.h"
#import "IMDefine.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"
#import "IMMyself.h"

@implementation IMMyselfInfoTableViewCell {
    UIImageView *_headView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 5, 70, 70)];
        
        [[_headView layer] setCornerRadius:5.0f];
        [_headView setClipsToBounds:YES];
        [_headView setContentMode:UIViewContentModeScaleAspectFill];
        [[self contentView] addSubview:_headView];
        
    }
    return self;
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

@end
