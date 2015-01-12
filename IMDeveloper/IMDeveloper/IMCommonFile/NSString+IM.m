//
//  NSString+IM.m
//  IMDeveloper
//
//  Created by mac on 14-12-11.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

#import "NSString+IM.h"

@implementation NSString (IM)

- (NSString *)pinYin

{
    
    //先转换为带声调的拼音
    
    NSMutableString *str = [self mutableCopy];
    
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    
    //再转换为不带声调的拼音
    
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    
    return str;
    
    
}

//补充:

//获取拼音首字母

- (NSString *)firstCharactor

{
    
    //1.先传化为拼音
    
    NSString *pinYin = [self.pinYin uppercaseString];
    
    //2.获取首字母
    
    return [pinYin substringToIndex:1];
    
}

NSInteger Array_sortByPinyin(NSString *string1, NSString *string2, void *keyForSorting){
    
    return [[[string1 pinYin] uppercaseString] compare:[[string2 pinYin] uppercaseString] ];
}
@end
