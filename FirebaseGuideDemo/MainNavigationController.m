//
//  MainNavigationController.m
//  FirebaseGuideDemo
//
//  Created by 金秋成 on 16/9/29.
//  Copyright © 2016年 金秋成. All rights reserved.
//

#import "MainNavigationController.h"
#import <FirebaseAuth/FirebaseAuth.h>
@interface MainNavigationController ()

@end

@implementation MainNavigationController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"logoutnoti" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLoginViewControllerIfNeed) name:@"logoutnoti" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showLoginViewControllerIfNeed];
}
-(void)showLoginViewControllerIfNeed{
    FIRUser * user = [[FIRAuth auth]currentUser];
    if (user == nil || user.isAnonymous) {
        UIViewController * loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
@end
