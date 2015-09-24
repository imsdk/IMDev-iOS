//
//  IMCustomerServiceInfo.h
//  IMSDK
//
//  Created by mac on 15/4/1.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMCustomerServiceInfo : NSObject

@property (nonatomic, readonly) NSString *customUserID;
@property (nonatomic, readonly) NSString *nickName;
@property (nonatomic, readonly) NSString *email;

@end
