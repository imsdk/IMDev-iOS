//
//  IMMyself+RecentGroups.h
//  IMSDK
//
//  Created by mac on 15/1/2.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import "IMMyself.h"
#import "IMGroupInfo.h"

/**
 @header IMMyself+RecentGroups
 @abstract IMMyself最近聊天群组，为IMMyself提供获取和移除最近聊天群组功能。
 */
@interface IMMyself (RecentGroups)

/**
 @method
 @brief 获取最近聊天群组
 @return 最近聊天群组ID的集合
 */
- (NSArray *)recentGroups;

/**
 @method
 @brief 从最近联系人中移除某个用户（本地移除）
 @param customUserID 移除对象的用户名
 */
- (void)removeRecentGroup:(NSString *)groupID;

@end