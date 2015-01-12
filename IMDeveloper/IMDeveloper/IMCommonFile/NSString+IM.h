//
//  NSString+IM.h
//  IMDeveloper
//
//  Created by mac on 14-12-11.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IM)

- (NSString *)pinYin;
- (NSString *)firstCharactor;
NSInteger Array_sortByPinyin(NSString *string1, NSString *string2, void *keyForSorting);
@end
