//
//  IMCommentListInfo.h
//  IMSDK
//
//  Created by mac on 15/6/30.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMCommentListInfo : NSObject

@property (nonatomic, readonly) NSString *topicID;
@property (nonatomic, readonly) NSMutableArray *commentList;

@end
