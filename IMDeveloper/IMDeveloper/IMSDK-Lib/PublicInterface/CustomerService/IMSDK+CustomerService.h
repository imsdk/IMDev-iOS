//
//  IMSDK+CustomerService.h
//  IMSDK
//
//  Created by mac on 15/4/1.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMSDK.h"
#import "IMCustomerServiceInfo.h"

@protocol IMSDKCustomerServiceDelegate <NSObject>

- (void)customerServiceDidInitialize;

@end


@interface IMSDK (CustomerService)

@property (nonatomic, weak) id<IMSDKCustomerServiceDelegate> customerServiceDelegate;

- (NSArray *)customerServiceList;

- (IMCustomerServiceInfo *)customerServiceInfoWithCustomUserID:(NSString *)customUserID;

- (BOOL)isCustomerService:(NSString *)customUserID;

- (BOOL)customerServiceInitialized;

@end
