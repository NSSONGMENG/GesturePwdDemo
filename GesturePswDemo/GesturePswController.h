//
//  GesturePswController.h
//  GesturePswDemo
//
//  Created by 宋猛 on 2017/3/30.
//  Copyright © 2017年 宋猛. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GesturePswControllerState) {
    GesturePswControllerStateSetting,   //设置手势密码
    GesturePswControllerStateConfirm,   //验证手势密码
    GesturePswControllerStateReset,     //重置手势密码
    GesturePswControllerStateConfirmFingerPwd,  //验证指纹密码
};
@interface GesturePswController : UIViewController


/** 用户头像url */
@property (nonatomic, copy) NSString    * iconUrl;

/** 用户昵称 */
@property (nonatomic, copy) NSString    * nickName;

/** 账号 */
@property (nonatomic, copy) NSString    * accountStr;

/** 页面类型，设置or验证 */
@property (nonatomic, assign) GesturePswControllerState state;


/**
 初始化方法

 @param state 页面类型
 
 @return obj
 */
- (instancetype)initWithState:(GesturePswControllerState)state;

/**
 初始化方法

 @param state 页面类型
 @param nickName 昵称
 @param iconUrl 头像地址
 @param accountStr 账号字符串
 @return obj
 */
- (instancetype)initWithGesturePswControllerState:(GesturePswControllerState)state
                                         nickName:(NSString *)nickName
                                          iconUrl:(NSString *)iconUrl
                                       accountStr:(NSString *)accountStr;

@end
