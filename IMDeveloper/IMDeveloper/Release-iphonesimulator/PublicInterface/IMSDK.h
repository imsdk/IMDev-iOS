//
//  IMSDK.h
//  IMSDK
//
//  Created by lyc on 14-9-14.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @header IMSDK.h
 @abstract IMSDK的核心类之一，包含IMSDK的基本信息
 */
@interface IMSDK : NSObject

/**
 @property
 @brief 最新版本ID
 */
@property (nonatomic, readonly) UInt32 versionID;

/**
 @property
 @brief 最新版本号，包含主要更新功能点
 */
@property (nonatomic, readonly) NSString *versionNumber;

/**
 @property
 @brief 版本名
 */
@property (nonatomic, readonly) NSString *versionName;

/**
 @property
 @brief Apple Notification Push功能的设备标识
 */
@property (nonatomic, strong) NSData *deviceToken;

/**
 @method
 @brief 获取IMSDK单例
 */
+ (id)sharedInstance;

@end

#define g_pIMSDK [IMSDK sharedInstance]
