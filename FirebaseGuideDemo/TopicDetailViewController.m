//
//  TopicDetailViewController.m
//  FirebaseGuideDemo
//
//  Created by 金秋成 on 16/9/29.
//  Copyright © 2016年 金秋成. All rights reserved.
//

#import "TopicDetailViewController.h"

@interface TopicDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webview loadHTMLString:self.htmlString baseURL:nil];
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
