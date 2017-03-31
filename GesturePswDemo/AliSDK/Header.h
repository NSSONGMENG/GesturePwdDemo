//
//  Header.h
//  AliPayDemo
//
//  Created by pg on 15/7/10.
//  Copyright (c) 2015年 pg. All rights reserved.
//

#ifndef AliPayDemo_Header_h
#define AliPayDemo_Header_h


#endif

/******************* ITEM *********************/

#define ITEMRADIUS_OUTTER    72  //item的外圆直径
#define ITEMRADIUS_INNER     28  //item的内圆直径
#define ITEMRADIUS_LINEWIDTH 2.f   //item的线宽
#define ITEMWH               72  //item的宽高
#define ITEM_TOTAL_POSITION  270  // 整个item的顶点位置


/*********************** subItem *************************/

#define SUBITEMTOTALWH 52.f   // 整个subitem的大小
#define SUBITEMWH      12.f   //单个subitem的大小
#define SUBITEM_TOP    26.5f   //整个的subitem的顶点位置(y点)


/*********************** 颜色 *************************/

//选中颜色  浅红色
#define SELECTCOLOR UIColorFromHex(0xe3515b,1)

//圆圈颜色，白色半透明
#define CIRCLECOLOR UIColorFromHex(0xffffff,0.57)

//密码错误文字颜色
#define GESTUREPSW_ALERT_TEXTCOLOR UIColorFromHex(0xe3515b,1)

//密码错误颜色
#define GESTUREPSW_WRONGCOLOR UIColorFromHex(0xff5b66,1)

//十六进制颜色
#define UIColorFromHex(s,a)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:a]

/*********************** 文字提示语 *************************/
static  NSString    * GesturePwdSettingStr  = @"绘制手势密码图案，至少连接4个点";
static  NSString    * GesturePwdResetStr    = @"请再次滑动确认密码";
static  NSString    * GesturePwdSetSuccessStr = @"设置密码成功";
static  NSString    * GesturePWdConfirmSettingFailureStr = @"两次输入的密码不一致，请重新确认";

static  NSString    * GesturePwdInputOldPwdStr = @"请输入原始密码";
static  NSString    * GesturePwdInputNewPwdStr = @"请输入新密码";
static  NSString    * GesturePwdConfirmPwdStr = @"验证手势密码图案，至少连接4个点";
static  NSString    * GesturePwdConfirmSuccessStr = @"登录成功";
static  NSString    * GesturePwdConfirmFailureStr = @"密码错误，还可以输入%d次";
static  NSString    * GesturePwdConfirmFailureTooMany = @"错误次数太多，请稍后重试";








