//
//  PostTopicViewController.m
//  FirebaseGuideDemo
//
//  Created by 金秋成 on 16/9/29.
//  Copyright © 2016年 金秋成. All rights reserved.
//

#import "PostTopicViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseStorage/FirebaseStorage.h>
#import <MBProgressHUD.h>
@interface PostTopicViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
- (IBAction)postBtnClick:(id)sender;


@property (nonatomic,strong)FIRDatabaseReference * databaseRef;
@property (nonatomic,strong)FIRStorageReference  * storageRef;

@end

@implementation PostTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidTap)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
}


- (IBAction)postBtnClick:(id)sender {
    NSString * title= self.titleTextField.text;
    NSString * content = self.contentTextView.text;
    UIImage  * image   = self.imageView.image;
    if (title == nil || content == nil || image == nil) {
        return;
    }
    //将image转换为data
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    //获取当前时间戳
    NSTimeInterval timeinterval = [[NSDate  date]timeIntervalSince1970];
    //创建图片的引用 图片名为时间戳
    FIRStorageReference * picRef = [self.storageRef child:[NSString stringWithFormat:@"%lf",timeinterval]];
    //创建HUD
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //上传image的data 并获取上传任务
    FIRStorageUploadTask * dataTask = [picRef putData:imageData];
    //监听上传进度
    [dataTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
        if (snapshot.status == FIRStorageTaskStatusResume) {
            hud.mode = MBProgressHUDModeAnnularDeterminate;//进度条
            hud.label.text = @"正在上传图片";
            hud.progress = 0;
        }
        float progress = (float)snapshot.progress.completedUnitCount / (float)snapshot.progress.totalUnitCount;
        hud.progress = progress;//更新进度
    }];
    //监听上传失败
    [dataTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
        hud.mode = MBProgressHUDModeText;//提示框
        hud.label.text = snapshot.error.localizedDescription;
        [hud hideAnimated:YES afterDelay:2];
    }];
    __weak typeof(self) weakSelf = self;
    //content为html文件模板
    NSString * contentHTMLPath = [[NSBundle mainBundle]pathForResource:@"Content" ofType:@"html"];
    NSError * error = nil;
    NSString * contentHTMLString = [NSString stringWithContentsOfFile:contentHTMLPath
                                                             encoding:NSUTF8StringEncoding
                                                                error:&error];
    //监听上传成功
    [dataTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
        hud.mode = MBProgressHUDModeIndeterminate;//提示框
        hud.label.text = @"发布中";
        //拼装html
        
        NSString * perfectHTMLString = [[[contentHTMLString stringByReplacingOccurrencesOfString:@"$$title" withString:title]
                                                            stringByReplacingOccurrencesOfString:@"$$imageurl" withString:snapshot.metadata.downloadURL.absoluteString]
                                                            stringByReplacingOccurrencesOfString:@"$$content" withString:content];
        //生成默认topicid
        FIRDatabaseReference * childRef =  self.databaseRef.childByAutoId;
        //操作引用，赋值
        [childRef setValue:@{@"topicTitle"    : title,//设置标题
                            @"topicImageURL" : snapshot.metadata.downloadURL.absoluteString,//设置图片地址
                            @"topicDesc"     : content,//设置内容
                            @"topicHtml"     : perfectHTMLString,
                            @"auth"          : [[FIRAuth auth] currentUser].email,//设置作者的auth
                            @"createdate"    : @([[NSDate date]timeIntervalSince1970])}//设置发布日期的时间戳
                andPriority:@"createdate"//排序用
                withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                    hud.mode = MBProgressHUDModeText;//提示框
                    if (error) {
                        hud.label.text = error.localizedDescription;
                    }
                    else{
                        hud.label.text = @"发布成功";
                    }
                    [hud hideAnimated:YES afterDelay:2];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                }];

    }];
}


-(void)imageDidTap{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * pickedImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.imageView.image = pickedImage;
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



-(FIRStorageReference *)storageRef{
    if (!_storageRef) {
        _storageRef = [[FIRStorage storage]referenceForURL:@"gs://firstfirebase-298c7.appspot.com/image"];
    }
    return _storageRef;
}

-(FIRDatabaseReference *)databaseRef{
    if (!_databaseRef) {
        _databaseRef = [[FIRDatabase database] referenceFromURL:@"https://firstfirebase-298c7.firebaseio.com/news"];
    }
    return _databaseRef;
}



@end
