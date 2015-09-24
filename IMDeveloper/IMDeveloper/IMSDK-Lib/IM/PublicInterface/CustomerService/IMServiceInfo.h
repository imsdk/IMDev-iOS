//
//  IMServiceInfo.h
//  IMSDK
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(UInt8, IMServiceType) {
    IMServiceTypeCustomerService = 1,
};

@interface IMServiceInfo : NSObject

@property (nonatomic, readonly) NSString *customUserID;        //服务号ID
@property (nonatomic, readonly) IMServiceType serviceType;     //服务号类型
@property (nonatomic, readonly) NSString *serviceName;         //服务号名称
@property (nonatomic, readonly) NSString *logoFileID;          //logo头像的文件ID
@property (nonatomic, readonly) NSString *serviceDescription;  //服务号简介


@end
