//
//  IMUserLocation.h
//  IMSDK
//
//  Created by lyc on 14-9-3.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @header IMUserLocation.h
 @abstract 周围用户对象，包含经纬度等地理位置信息
 */
@interface IMUserLocation : NSObject

/**
 @property
 @brief 用户名
 */
@property (nonatomic, copy) NSString *customUserID;

/**
 @property
 @brief 纬度
 */
@property (nonatomic, assign) double latitude;

/**
 @property
 @brief 经度
 */
@property (nonatomic, assign) double longitude;

@end
