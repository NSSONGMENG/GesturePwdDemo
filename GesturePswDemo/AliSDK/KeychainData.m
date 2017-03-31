//
//  KeychainData.m
//  AliPayDemo
//
//  Created by pg on 15/7/15.
//  Copyright (c) 2015年 pg. All rights reserved.
//

#import "KeychainData.h"
#define KEYCHAIN_KEY  @"password_slider"



@implementation KeychainData


+ (void)setObject:(id)object forKey:(id)key{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

+ (id)objectForKey:(id)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)removeObjectForKey:(id)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}


#pragma mark --------------------------

+ (BOOL)isSave
{
    NSString *str = [self objectForKey:KEYCHAIN_KEY];
    if (str && str.length>0 && [str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    return NO;
}


+ (BOOL)isFirstInput:(NSString *)str
{
    NSString *oldStr = [self objectForKey:KEYCHAIN_KEY];
    if (oldStr && oldStr.length>0 && [oldStr isKindOfClass:[NSString class]])
    {
        return NO;
    }
    
    [self setObject:str forKey:KEYCHAIN_KEY];
    
    return YES;
}



+ (BOOL)isSecondInputRight:(NSString *)str
{
    NSString *oldStr = [self objectForKey:KEYCHAIN_KEY];
  
    if ([oldStr isKindOfClass:[NSNull class]]) {
        return NO;
    }
    else if (!oldStr || oldStr.length<1 || ![oldStr isKindOfClass:[NSString class]]) {
        return NO;
    }
    else if (oldStr.length==str.length  &&  [oldStr isEqualToString:str]) {
        return YES;
    }
    
    return NO;
}


+ (void)forgotPsw
{
    [self removeObjectForKey:KEYCHAIN_KEY];
}


+ (void)setPSW:(NSString *)str
{
    [self setObject:str forKey:KEYCHAIN_KEY];
}









@end
