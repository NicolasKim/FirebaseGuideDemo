//
//  SignInViewController.m
//  FirebaseGuideDemo
//
//  Created by 金秋成 on 16/9/28.
//  Copyright © 2016年 金秋成. All rights reserved.
//

#import "SignInViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <MBProgressHUD.h>

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)signInBtnClick:(id)sender {
    //空值判断
    if (self.emailTextField.text.length == 0) return;
    if (self.passTextField.text.length == 0) return;
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    //hud创建并显示
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FIRAuth auth]signInWithEmail:self.emailTextField.text
                          password:self.passTextField.text
                        completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        //切换提示框样式
        hud.mode = MBProgressHUDModeText;
        if (error) {
            hud.label.text = [error localizedDescription];
            [hud hideAnimated:YES afterDelay:2];
        }
        else{
            hud.label.text = @"授权成功";
            [hud hideAnimated:YES afterDelay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}
@end
