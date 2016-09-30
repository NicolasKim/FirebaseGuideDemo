//
//  SignUpViewController.m
//  FirebaseGuideDemo
//
//  Created by 金秋成 on 16/9/28.
//  Copyright © 2016年 金秋成. All rights reserved.
//

#import "SignUpViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <MBProgressHUD.h>
@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)SignUpBtnClick:(id)sender {
    //空值判断
    if (self.emailTextField.text.length == 0) return;
    if (self.passTextField.text.length == 0) return;
    [self.view endEditing:YES];
    //hud创建并显示
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[FIRAuth auth]createUserWithEmail:self.emailTextField.text password:self.passTextField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        //切换提示框样式
        hud.mode = MBProgressHUDModeText;
        if (error) {
            hud.label.text = [error localizedDescription];
            [hud hideAnimated:YES afterDelay:2];
        }
        else{
            hud.label.text = @"注册成功";
            [hud hideAnimated:YES afterDelay:2];
        }
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
