//
//  IMSDK+CustomerService.h
//  IMSDK
//
//  Created by mac on 15/4/1.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMSDK.h"
#import "IMCustomerServiceInfo.h"
#import "IMServiceInfo.h"

@protocol IMSDKCustomerServiceDelegate <NSObject>

@optional

- (void)customerServiceDidInitialize;

- (void)didRequestServiceInfo:(IMServiceInfo *)serviceInfo
             WithCustomUserID:(NSString *)customUserID
               clientSendTime:(UInt32)timeIntervalSince1970 ;
- (void)failedToRequestServiceInfoWithCustomUserID:(NSString *)customUserID
                                    clientSendTime:(UInt32)timeIntervalSince1970
                                             error:(NSString *)error;
@end


@interface IMSDK (CustomerService)

@property (nonatomic, weak) id<IMSDKCustomerServiceDelegate> customerServiceDelegate;

- (NSArray *)customerServiceList;

//客服账号信息
- (IMCustomerServiceInfo *)customerServiceInfoWithCustomUserID:(NSString *)customUserID;

- (IMServiceInfo *)serviceInfoWithCustomUserID:(NSString *)customUserID;

- (BOOL)isCustomerService:(NSString *)customUserID; //客服账号

- (BOOL)isServiceID:(NSString *)customUserID; //服务号

- (BOOL)customerServiceInitialized;

- (UInt32)requestServiceInfoWithCustomUserID:(NSString *)customUserID success:(void (^)(IMServiceInfo *serviceInfo))success failure:(void (^)(NSString *error))failure;

@end
