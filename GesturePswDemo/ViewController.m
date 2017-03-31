//
//  ViewController.m
//  GesturePswDemo
//
//  Created by 宋猛 on 2017/3/30.
//  Copyright © 2017年 宋猛. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "GesturePswController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SVProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * fpBtn = [self createBtn];
    [fpBtn setTitle:@"指纹解锁" forState:UIControlStateNormal];
    [fpBtn addTarget:self action:@selector(fpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fpBtn];
    
    UIButton    * btn = [self createBtn];
    [btn setTitle:@"设置手势密码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton    * btn1 = [self createBtn];
    [btn1 setTitle:@"登录验证" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton    * btn2 = [self createBtn];
    [btn2 setTitle:@"重置手势密码" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    [fpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(45);
        make.top.equalTo(self.view).offset(100);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(45);
        make.top.equalTo(fpBtn.mas_bottom).offset(40);
    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(45);
        make.top.equalTo(btn.mas_bottom).offset(40);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(45);
        make.top.equalTo(btn1.mas_bottom).offset(40);
    }];
}

- (UIButton *)createBtn{
    UIButton    * btn = [UIButton new];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.layer.cornerRadius = 5.f;
    btn.clipsToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

#pragma mark -
#pragma mark - btn action

- (void)fpBtnAction:(UIButton *)btn{
    if ([self evaluatePolicy]){
        GesturePswController    * vc = [GesturePswController new];
        vc.state = GesturePswControllerStateConfirmFingerPwd;
        
        [self.navigationController pushViewController:[GesturePswController new] animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"指纹解锁不可用" maskType:SVProgressHUDMaskTypeBlack];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

- (void)btnAction:(UIButton *)btn{
    GesturePswController    * vc = [GesturePswController new];
    vc.state = GesturePswControllerStateSetting;
    
    [self.navigationController pushViewController:[GesturePswController new] animated:YES];
}

- (void)btn1Action:(UIButton *)btn{
    GesturePswController    * vc = [[GesturePswController alloc] initWithGesturePswControllerState:GesturePswControllerStateConfirm
                                                                                          nickName:@"ZhangSan"
                                                                                           iconUrl:@""
                                                                                        accountStr:@"20170330"];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)btn2Action:(UIButton *)btn{
    GesturePswController    * vc = [GesturePswController new];
    vc.state = GesturePswControllerStateReset;
    [self.navigationController pushViewController:vc animated:YES];
}

//验证指纹解锁是否可用
- (BOOL)evaluatePolicy
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    BOOL success;
    
    // test if we can evaluate the policy, this test will tell us if Touch ID is available and enrolled
    success = [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (success) {
        NSLog(@"指纹解锁可用");
        return YES;
    } else {
        NSLog(@"此设备指纹解锁不可用");
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
