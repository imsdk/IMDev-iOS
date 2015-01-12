//
//  IMAroundViewCell.h
//  IMDeveloper
//
//  Created by mac on 14-12-15.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMAroundViewCell : UIView

@property (nonatomic, strong) UIImage *headPhoto;
@property (nonatomic, copy) NSString *customUserID;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, strong) UILabel *signatureLabel;

@end
