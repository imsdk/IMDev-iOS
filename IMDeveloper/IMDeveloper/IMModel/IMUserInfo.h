//
//  IMUserObject.h
//  IMDeveloper
//
//  Created by mac on 14-12-10.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUserInfo : NSObject

@property (nonatomic, copy) NSString *customUserID;
@property (nonatomic, assign) NSInteger sex; // 0 stand for male,1 stand for female;
@property (nonatomic, copy) NSString *signature;

@end
