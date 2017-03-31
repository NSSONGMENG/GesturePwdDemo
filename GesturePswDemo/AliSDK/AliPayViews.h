//
//  AliPayViews.h
//  AliPayDemo
//
//  Created by pg on 15/7/9.
//  Copyright (c) 2015年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    GesturePWDModelAlertPwdModel,    //修改密码 (需要先输入老密码)
    GesturePWDModelSetPwdModel,      //重置密码（无论存不存老密码都一并删除，在重新设置密码）
    GesturePWDModelValidatePwdModel, //验证密码 (输入一遍，进行验证)
    GesturePWDModelDeletePwdModel,   //删除密码
    NoneModel
}GesturePWDModel;


typedef void (^PasswordBlock) (NSString *pswString);


@interface AliPayViews : UIView
@property(nonatomic , assign)GesturePWDModel gestureModel;
@property(nonatomic , strong)PasswordBlock block;



@end
