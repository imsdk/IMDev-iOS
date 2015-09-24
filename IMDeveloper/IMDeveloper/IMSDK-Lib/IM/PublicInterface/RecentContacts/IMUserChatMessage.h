//
//  IMUserChatMessage.h
//  IMSDK
//
//  Created by lyc on 15-1-13.
//  Copyright (c) 2015年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(UInt8, IMUserChatMessageType) {
    IMUserChatMessageTypeText = 0,
    IMUserChatMessageTypeAudio = 1,
    IMUserChatMessageTypePhoto = 2,
    IMUserChatMessageTypeNotice = 20,
};

@interface IMUserChatMessage : NSObject

@property (nonatomic, readonly) NSString *fromCustomUserID;
@property (nonatomic, readonly) NSString *toCustomUserID;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UInt32 clientSendTime;
@property (nonatomic, readonly) UInt64 serverSendTime;
@property (nonatomic, readonly) BOOL isReceivedMessage;
@property (nonatomic, readonly) IMUserChatMessageType type;
@property (nonatomic, readonly) NSData *data;

@end
