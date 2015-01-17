//
//  IMSDKManager.m
//  IMDeveloper
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 IMSDK. All rights reserved.
//

#import "IMSDKManager.h"

static IMSDKManager *sharedIMSDK = nil;

@implementation IMSDKManager {
    NSMutableArray *_recentChatObjects;
}

- (NSMutableArray *)recentChatObjects {
    if (!_recentChatObjects) {
        _recentChatObjects = [[NSMutableArray alloc] initWithCapacity:32];
    }
    
    return _recentChatObjects;
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedIMSDK = [[self alloc] init];
    });
    return sharedIMSDK;
}

- (void)removeRecentChatObject:(NSString *)object {
    if ([_recentChatObjects containsObject:object]) {
        [_recentChatObjects removeObject:object];
    }
}

@end
