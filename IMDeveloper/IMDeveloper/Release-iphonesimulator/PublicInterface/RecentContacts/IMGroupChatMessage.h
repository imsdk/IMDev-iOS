//
//  IMGroupChatMessage.h
//  IMSDK
//
//  Created by lyc on 15-1-13.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(UInt8, IMGroupChatMessageType) {
    IMGroupChatMessageTypeText = 0,
    IMGroupChatMessageTypeAudio = 1,
    IMGroupChatMessageTypePhoto = 2
};

@interface IMGroupChatMessage : NSObject

@property (nonatomic, readonly) NSString *fromCustomUserID;
@property (nonatomic, readonly) NSString *groupID;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UInt32 clientSendTime;
@property (nonatomic, readonly) UInt64 serverSendTime;
@property (nonatomic, readonly) BOOL isReceivedMessage;
@property (nonatomic, readonly) IMGroupChatMessageType type;
@property (nonatomic, readonly) NSData *data;

@end
