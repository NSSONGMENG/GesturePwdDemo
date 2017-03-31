//
//  GesturePswController.m
//  GesturePswDemo
//
//  Created by 宋猛 on 2017/3/30.
//  Copyright © 2017年 宋猛. All rights reserved.
//

#import "GesturePswController.h"
#import "Masonry.h"
#import "AliPayViews.h"
#import "Header.h"
#import "SVProgressHUD.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define KnickNameFont   [UIFont fontWithName:@"PingFangHK-Semibold" size:16]
#define KnickNameColor  UIColorFromHex(0xffffff,1)
#define KaccountFont    [UIFont fontWithName:@"PingFangHK-Semibold" size:15]
#define KaccountColor   UIColorFromHex(0x99abba,1)
#define KimgViewHW  52
#define KimgViewBorderWidth     1.f
#define KimgViewBorderColor     UIColorFromHex(0xd4d4d4,1).CGColor

@interface GesturePswController ()

@property (nonatomic, strong) AliPayViews   * gestureView;
@property (nonatomic, strong) UIImageView   * imgView;
@property (nonatomic, strong) UILabel       * nickNameLab;
@property (nonatomic, strong) UILabel       * accountLab;

/** 重新登录按钮 */
@property (nonatomic, strong) UIButton      * reLoginBtn;

@end

@implementation GesturePswController


/**
 初始化方法
 
 @param state 页面类型
 
 @return obj
 */
- (instancetype)initWithState:(GesturePswControllerState)state{
    if (self = [super init]) {
        _state = state;
    }
    return self;
}

- (instancetype)initWithGesturePswControllerState:(GesturePswControllerState)state
                                         nickName:(NSString *)nickName
                                          iconUrl:(NSString *)iconUrl
                                       accountStr:(NSString *)accountStr{
    if (self = [super init]) {
        _state = state;
        _nickName = nickName;
        _iconUrl = iconUrl;
        _accountStr = accountStr;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromHex(0x4c6072, 1);
    
    switch (_state) {
        case GesturePswControllerStateSetting:{
            [self createSettingPage];
            self.title = @"设置手势密码";
            break;
        }
        case GesturePswControllerStateReset:{
            [self createSettingPage];
            self.title = @"重置手势密码";
            break;
        }
        case GesturePswControllerStateConfirmFingerPwd:{
            [self createConfirmFingerPwdPage];
            break;
        }
        default:
            [self createConfirmPage];
            break;
    }
}

#pragma mark - UI
//设置手势密码
- (void)createSettingPage{
    [self.view addSubview:self.gestureView];
    if (_state == GesturePswControllerStateReset) {
        self.gestureView.gestureModel = GesturePWDModelResetPwdModel;
    }
    else{
        self.gestureView.gestureModel = GesturePWDModelSetPwdModel;
    }
    
    [_gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.right.bottom.equalTo(self.view);
    }];
}

//手势登录验证
- (void)createConfirmPage{
    [self.view addSubview:self.gestureView];
    self.gestureView.gestureModel = GesturePWDModelConfirmPwdModel;

    self.nickNameLab.text = self.nickName;
    self.accountLab.text = [NSString stringWithFormat:@"账户:%@",self.accountStr];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.nickNameLab];
    [self.view addSubview:self.accountLab];
    [self.view addSubview:self.reLoginBtn];
    
    [_gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.accountLab.mas_bottom).offset(36);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(71);
        make.width.height.mas_equalTo(52);
    }];
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(9);
        make.centerX.equalTo(self.view);
    }];
    [self.accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.nickNameLab.mas_bottom).offset(8);
    }];
    [self.reLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(- 10);
        make.centerX.equalTo(self.view);
    }];
}

//指纹验证
- (void)createConfirmFingerPwdPage{
    UILabel * lab = [UILabel new];
    lab.text = @"请验证指纹";
    [self.view addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

//指纹验证
- (void)evaluatePolicy{
     LAContext *context = [[LAContext alloc] init];
     
     // show the authentication UI with our reason string
     [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过home键验证已有手机指纹" reply:
      ^(BOOL success, NSError *authenticationError) {
          if (success) {
              NSLog(@"finger print confirm success ~~");
              [self back];
          } else {
              NSLog(@"finger print confirm failure : %@ ",authenticationError.localizedDescription);
              [SVProgressHUD showInfoWithStatus:@"验证失败，请重按指纹" maskType:SVProgressHUDMaskTypeBlack];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [SVProgressHUD dismiss];
              });
          }
      }];
}

#pragma mark - btn Action
- (void)reloginAction:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - getter
//手势视图
- (AliPayViews *)gestureView{
    if (!_gestureView) {
        switch (_state) {
            case GesturePswControllerStateSetting:
                _gestureView = [[AliPayViews alloc] initWithModel:GesturePWDModelSetPwdModel];
                break;
            case GesturePswControllerStateConfirm:
                _gestureView = [[AliPayViews alloc] initWithModel:GesturePWDModelConfirmPwdModel];
                break;
            case GesturePswControllerStateReset:
                _gestureView = [[AliPayViews alloc] initWithModel:GesturePWDModelResetPwdModel];
                break;
            case GesturePswControllerStateConfirmFingerPwd:
                _gestureView = nil;
                break;
        }
        
        __weak  typeof(self) weakself = self;
        _gestureView.block = ^(NSString *pswString){
            [weakself back];
        };
    }
    return _gestureView;
}

- (UILabel *)nickNameLab{
    if (!_nickNameLab) {
        _nickNameLab = [UILabel new];
        _nickNameLab.font = KnickNameFont;
        _nickNameLab.textColor = KnickNameColor;
        _nickNameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nickNameLab;
}

- (UILabel *)accountLab{
    if (!_accountLab) {
        _accountLab = [UILabel new];
        _accountLab.font = KaccountFont;
        _accountLab.textColor = KaccountColor;
        _accountLab.textAlignment = NSTextAlignmentCenter;
    }
    return _accountLab;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.backgroundColor = [UIColor clearColor];
        _imgView.layer.cornerRadius = KimgViewHW / 2;
        _imgView.clipsToBounds = YES;
        _imgView.layer.borderWidth = KimgViewBorderWidth;
        _imgView.layer.borderColor = KimgViewBorderColor;
    }
    return _imgView;
}

- (UIButton *)reLoginBtn{
    if (!_reLoginBtn) {
        _reLoginBtn = [UIButton new];
        [_reLoginBtn addTarget:self action:@selector(reloginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reLoginBtn setTitle:@"重新登录" forState:UIControlStateNormal];
        _reLoginBtn.backgroundColor = [UIColor clearColor];
        _reLoginBtn.titleLabel.font = KaccountFont;
    }
    return _reLoginBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
