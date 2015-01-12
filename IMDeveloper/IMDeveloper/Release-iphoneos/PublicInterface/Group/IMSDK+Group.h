//
//  IMSDK+Group.h
//  IMSDK
//
//  Created by lyc on 14-10-24.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import "IMSDK.h"
#import "IMGroupInfo.h"

/**
 @header IMSDK+Group.h
 @abstract IMSDK群组类别，为IMSDK提供根据群ID获取群对象功能
 */
@interface IMSDK (Group)

/**
 @method
 @brief 根据群ID本地获取群组对象
 @param groupID  群组ID，群组ID不能超过64个字节
 @return 群组对象，可能为nil
 */
- (IMGroupInfo *)groupInfoWithGroupID:(NSString *)groupID;

@end
