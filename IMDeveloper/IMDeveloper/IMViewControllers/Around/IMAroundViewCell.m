//
//  IMAroundViewCell.m
//  IMDeveloper
//
//  Created by mac on 14-12-15.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "IMAroundViewCell.h"
#import "UIView+IM.h"
#import "IMDefine.h"

//IMSDK Headers
#import "IMSDK+MainPhoto.h"

@implementation IMAroundViewCell {
    UIImageView *_headView;
    UILabel *_customUserIDLabel;
    UILabel *_distanceLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, frame.size.height - 10, frame.size.height - 10)];
        
        [_headView setBackgroundColor:[UIColor clearColor]];
        [[_headView layer] setCornerRadius:5.0f];
        [_headView setContentMode:UIViewContentModeScaleAspectFill];
        [_headView setClipsToBounds:YES];
        [self addSubview:_headView];
        
        _signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 80, 10, 80, frame.size.height - 20)];
        
        [_signatureLabel setBackgroundColor:[UIColor clearColor]];
        [_signatureLabel setTextAlignment:NSTextAlignmentCenter];
        [_signatureLabel setNumberOfLines:2];
        [_signatureLabel setTextColor:[UIColor darkGrayColor]];
        [_signatureLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [[_signatureLabel layer] setCornerRadius:3.0f];
        [_signatureLabel setClipsToBounds: YES];
        [self addSubview:_signatureLabel];
        
        _customUserIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headView.right + 10, 5, frame.size.width - _headView.width - _signatureLabel.width - 60, frame.size.height / 2 - 5)];
        
        [_customUserIDLabel setBackgroundColor:[UIColor clearColor]];
        [_customUserIDLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [self addSubview:_customUserIDLabel];
        
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_customUserIDLabel.left, _customUserIDLabel.bottom + 10, _customUserIDLabel.width, frame.size.height/2 - 15)];
        
        [_distanceLabel setBackgroundColor:[UIColor clearColor]];
        [_distanceLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [_distanceLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_distanceLabel];
        
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

- (void)setDistance:(NSString *)distance {
    _distance = distance;
    
    [_distanceLabel setText:_distance];
}

- (void)setCustomUserID:(NSString *)customUserID {
    _customUserID = customUserID;
    
    [_customUserIDLabel setText:_customUserID];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeadImage) name:IMReloadMainPhotoNotification(customUserID) object:nil];
}

- (void)setSignature:(NSString *)signature {
    _signature = signature;
    
    [_signatureLabel setText:_signature];
    
    CGSize size;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        size = [_signature sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(80, self.frame.size.height - 20) lineBreakMode:NSLineBreakByCharWrapping];
    } else {
        size = [_signature boundingRectWithSize:CGSizeMake(80, self.frame.size.height - 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil].size;
        
    }
    
    [_signatureLabel setFrame:CGRectMake(self.frame.size.width - size.width - 12, (self.frame.size.height - size.height) / 2 - 2 , size.width + 4, size.height + 4)];
    if ([_signature length] > 0) {
        [_signatureLabel setBackgroundColor:[UIColor lightGrayColor]];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
   
    
}

- (void)reloadHeadImage {
    _headPhoto = [g_pIMSDK mainPhotoOfUser:_customUserID];
    
    if (_headPhoto == nil) {
        _headPhoto = [UIImage imageNamed:@"IM_head_default.png"];
    }
    
    [_headView setImage:_headPhoto];
}

@end
