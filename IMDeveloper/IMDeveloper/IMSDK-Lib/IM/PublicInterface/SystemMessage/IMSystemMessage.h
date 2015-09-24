//
//  IMSystemMessage.h
//  IMSDK
//
//  Created by lyc on 14-9-16.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSystemMessage : NSObject

@property (nonatomic, assign) UInt32 serverSendTime;
@property (nonatomic, copy) NSString *content;

@end
