//
//  IMLocalSystemMessageHistory.h
//  IMSDK
//
//  Created by lyc on 14-9-16.
//  Copyright (c) 2014年 lyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMSystemMessage.h"

@interface IMLocalSystemMessageHistory : NSObject

- (NSInteger)systemMessageCount;
- (IMSystemMessage *)systemMessageAtIndex:(NSInteger)index;

@end
