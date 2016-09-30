//
//  SignInViewController.h
//  FirebaseGuideDemo
//
//  Created by 金秋成 on 16/9/28.
//  Copyright © 2016年 金秋成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
- (IBAction)signInBtnClick:(id)sender;
@end
