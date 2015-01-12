//
//  IMSDK+LoginHistory.h
//  IMSDK
//
//  Created by mac on 14-12-5.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMSDK.h"

@interface IMSDK (LoginHistory)

@property (nonatomic, assign)BOOL saveHistory;

/**
 登录用户名的集合
 */
- (NSArray *)loginHistories;

/**
 移除某个用户的登录历史
 */
- (void)removeLoginHistoryWithCustomUserID:(NSString *)customUserID;

/**
 删除所有登录历史
 */
- (void)removeLoginHistories;

@end
