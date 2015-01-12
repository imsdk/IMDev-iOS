//
//  IMDefine.h
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+IM.h"
#import "UIImage+IM.h"

#define IMDeveloper_APPKey @"d3fecc6841c022fc7b7021dd"
#define IMLoginCustomUserID @"IMLoginCustomUserID"
#define IMLastLoginTime @"IMLastLoginTime"
#define IMLoginPassword @"IMLoginPassword"
#define IMShowGroupMemberName(customUserID, groupID) [NSString stringWithFormat:@"showGroupMemberName:%@_%@",customUserID,groupID]

#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

#define IMLoginStatusChangedNotification @"IMLoginStatusChangedNotification"
#define IMLogoutNotification @"IMLogoutNotification"
#define IMGroupListDidInitializeNotification @"IMGroupListDidInitializeNotification"
#define IMRelationshipDidInitializeNotification @"IMRelationshipDidInitializeNotification"
#define IMCustomUserInfoDidInitializeNotification @"IMCustomUserInfoDidInitializeNotification"
#define IMReloadBlacklistNotification @"IMReloadBlacklistNotification"
#define IMReloadFriendlistNotification @"IMReloadFriendlistNotification"
#define IMReloadMainPhotoNotification(customUserID) [NSString stringWithFormat:@"IMReloadMainPhotoNotification%@",customUserID]
#define IMAddGroupMemberNotification @"IMAddGroupMemberNotification"
#define IMReloadGroupListNotification @"IMReloadGroupListNotification"
#define IMRemovedGroupNotification(groupID) [NSString stringWithFormat:@"IMRemovedGroupNotification%@",groupID]
#define IMDeleteGroupNotification(groupID) [NSString stringWithFormat:@"IMDeleteGroupNotification%@",groupID]
#define IMShowGroupMemberNameNotification(groupID) [NSString stringWithFormat:@"IMShowGroupMemberNameNotification%@",groupID]
