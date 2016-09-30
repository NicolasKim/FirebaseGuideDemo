# FirebaseGuideDemo

最近安装了一个谷歌浏览器的插件，叫“[掘金](http://gold.xitu.io/)”，它会根据你的关注给你推荐一些文章，个人觉得不错。通过掘金我发现了一篇讲解firebase的文章，之前也没有听说过，就进去看了一眼。so...let's get it started.

***
# 什么是[Firebase](https://firebase.google.com/)？
Firebase是一家***实时***后端数据库创业公司，它能帮助开发者很快的写出Web端和移动端的应用。自2014年10月Google收购Firebase以来，用户可以在更方便地使用Firebase的同时，结合Google的云服务。
***
#[Firebase](https://firebase.google.com/)能干什么？
Firebase能让你的App从零到一。也就是说它可以帮助手机以及网页应用的开发者轻松构建App。通过Firebase背后负载的框架就可以简单地开发一个App，无需服务器以及基础设施。

以上是百度的内容。

他类似于以前facebook的parse以及国内的leancloud，区别在于firebase是实时的，被命名叫Realtime Database ,也就是说如果数据库有变化，客户端会马上感知到。

以上为个人理解。

通过查阅firebase的文档，我写了一个简单的Demo。有登录、注册、topic列表、topic发布。
***
#### 现在让我们来部署一下开发环境。

首先你需要一个google账号、一台真机和vpn，没有的话就自行解决吧，去[firebase官网](https://firebase.google.com/)创建一个工程。
1. **登录后点击控制台，如图：**
   ![](http://upload-images.jianshu.io/upload_images/1724493-3c7da538a7892a48.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
2. **再点击创建工程**
   ![jietu2.png](http://upload-images.jianshu.io/upload_images/1724493-c3d04c4f984dc539.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
3. **输入项目名称，以及国家/地区后 点击创建工程。**
   ![](http://upload-images.jianshu.io/upload_images/1724493-06fc84938fce75e8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
4. **点击将‘firebase添加到您的应用。**
   ![](http://upload-images.jianshu.io/upload_images/1724493-9ede0e3d4a80d822.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
5. **之后就按照步骤填写app信息，复制plist文件到您的xcode工程目录下，并使用cocoapods下载依赖包**

**此时您的开发环境已经部署完毕！！！！！！！**

***
### 好戏才刚刚开始哦~~
首先我们确认一下工程的bundleid 是不是和刚才填写的一样。
好！接下来是登录与注册
为了节省UI布局上的时间，我们就使用storyborad，新建一个storyboad，起个名字就叫Login。然后暂时将target->MainInterface 设置为Login 方便调试。
![](http://upload-images.jianshu.io/upload_images/1724493-bc3c3d9f7ea3bcca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
在login.storyboard里新建两个viewcontroller 包在navigationcontroller里(第一个vc是登录，第二个是注册)，如图：
![](http://upload-images.jianshu.io/upload_images/1724493-26753a4646b627ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
新建两个类  一个叫SignInViewController（登录） 一个叫SignUpViewController（注册）
并将其跟storyboard里的viewcontroller 关联起来。目前的目录结构为这个样子，如图：
![](http://upload-images.jianshu.io/upload_images/1724493-db2bced6893e95ce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
**还顺利吗？那接着来！**

将SignInViewController的**email输入框**和**pass输入框**以**属性**的形式拖拽到.h文件里，之后将**signin按钮**以**action**的形式拖拽到.h里。

```
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
- (IBAction)signInBtnClick:(id)sender;
```

将SignUpViewController的**email输入框**和**pass输入框**以**属性**的形式拖拽到.h文件里，之后将**signup按钮**以**action**的形式拖拽到.h里。

```
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;
- (IBAction)SignUpBtnClick:(id)sender;
```



为了更友好的提示，我们再添加一个依赖库MBProgressHUD

```
pod 'MBProgressHUD', '~> 1.0.0'
```

**好！我们首先来做一下注册**

在pod file中添加

```
pod 'Firebase/Auth'
```
在SignUpViewController.m中

```
#import <FirebaseAuth/FirebaseAuth.h>
#import <MBProgressHUD.h>
```

编写.m里的

```
- (IBAction)SignUpBtnClick:(id)sender {
    //空值判断
    if (self.emailTextField.text.length == 0) return;
    if (self.passTextField.text.length == 0) return;
    
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
```

 好简单的注册页面逻辑写完了，我们运行一下，
![jietu-zhuce.png](http://upload-images.jianshu.io/upload_images/1724493-e08275c97ea253a4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
顺利的话应该提示注册成功。然后我们看一下firebase的控制台。
![](http://upload-images.jianshu.io/upload_images/1724493-324041d033438326.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
ok,成功了！！！！

**接下来是登录**

在SignInViewController.m中

```
#import <FirebaseAuth/FirebaseAuth.h>
#import <MBProgressHUD.h>
```

编写.m里的

```
- (IBAction)signInBtnClick:(id)sender {
    //空值判断
    if (self.emailTextField.text.length == 0) return;
    if (self.passTextField.text.length == 0) return;
    [self.view endEditing:YES];
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
        }
    }];
}
```

 好简单的登录页面逻辑写完了，我们运行一下
![](http://upload-images.jianshu.io/upload_images/1724493-ccc290da7e15b3fc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
顺利的话应该提示登录成功。

**到现在为止登录注册完成了！！！**

***
###接下来我们来体验一下firebase的Realtime Database。
1. 切换main interface到main.storyboard
   ![](http://upload-images.jianshu.io/upload_images/1724493-a00c0b4d613f1800.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2. 布局main.storyboard如图：
   ![](http://upload-images.jianshu.io/upload_images/1724493-35d3084c6584b332.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3.新建四个controller分别为
> - MainNavigationController //继承与UINavigationcontroller
> - TopicListViewController（topic列表） //继承与UITableviewController
> - PostTopicViewController（用户发布topic） //继承与UIViewController
> - TopicDetailViewController（topic详情） //继承与UIViewController

4.编写 **PostTopicViewController**
> - 添加依赖项到Podfile 并 pod install

>  
``` 
pod 'Firebase/Database' 
pod 'Firebase/Storage'
```

> - 在PostTopicViewController.m 文件 
>
```
#import <FirebaseAuth/FirebaseAuth.h>
#import <FirebaseDatabase/FirebaseDatabase.h> 
#import <FirebaseStorage/FirebaseStorage.h>
```
> - 拖拽storyboard中的控件到 PostTopicViewController.h文件 

> ```@interface PostTopicViewController ()
> @property (weak, nonatomic) IBOutlet UITextField *titleTextField;
> @property (weak, nonatomic) IBOutlet UIImageView *imageView;
> @property (weak, nonatomic) IBOutlet UITextView *contentTextView;
> ```
- (IBAction)postBtnClick:(id)sender;
  @end
```
> 为image view添加点击事件并添加弹出imagepickerviewcontroller 选择图片的逻辑，这个就不多说了一下代码复制粘贴即可
>
```
viewDidLoad 中添加以下代码
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidTap)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
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
```
>
- 创建数据库的引用和存储器的引用，这里科普一下**什么是引用？**
  这里引用的概念和我们熟知的概念有点相似还有点儿差异。
>
```
OC NSArray * arr = [NSArray new] //这里arr是一个数组对象的引用
Firebase的引用是远程数据库的引用，也就是说对引用操作就相当于对远程数据库操作。 
```
_**One More thing!!**_
>
其实firebase是一个nosql数据库，它没有一个特定的数据结构，他 的存储形式为**json** ，你可以以任意的结构存储在数据库中。比如说一个topic 可以多一个字段，也可以少一个字段。不信你可以试试，嘿嘿。
>
- 接下来我们创建像个属性并实现**getter**方法
>
```
@property (nonatomic,strong)FIRDatabaseReference * databaseRef;
@property (nonatomic,strong)FIRStorageReference  * storageRef;
```

> 
```
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
```
- 编写post按钮的点击事件 ，代码有点多，讲一下具体的思路，我们会把image存储到storage（这里停一下storage是文件存储系统，保存文件后会生成一个url），然后图片的URL、topic标题、topic内容、作者、html字符串和时间戳存储到 RealTimeDataBase中。
>
```
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
                             }] ;
    }];
  }
```
>RUN IT!!
![](http://upload-images.jianshu.io/upload_images/1724493-10761af3b3b1ac87.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
成功后我们去看一下firebase的console
![](http://upload-images.jianshu.io/upload_images/1724493-c80722f6569cf510.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](http://upload-images.jianshu.io/upload_images/1724493-ad0590786ae24f86.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

发布页面以完成！！

5.编写 TopicListViewController
> - 创建TopicModel模型
>
```
.h
#import <Foundation/Foundation.h>
@interface TopicModel : NSObject
@property (nonatomic,strong)NSString * topicId;
@property (nonatomic,strong)NSString * topicTitle;
@property (nonatomic,strong)NSString * topicDesc;
@property (nonatomic,strong)NSString * topicImageURL;
@property (nonatomic,strong)NSString * authName;
@property (nonatomic,strong)NSDate   * postDate;
@property (nonatomic,strong)NSString * topicHTMLString;
@end
```
> 
```
.m
#import "TopicModel.h"
@implementation TopicModel
@end
```
> .m中引入头文件
>
```
#import "TopicModel.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseAuth/FirebaseAuth.h>
```
- .m中添加一个数据库的引用和一个数据源，并重写数据库引用的getter，如下：
>
```
@property (nonatomic,strong)NSMutableArray * datasource;
@property (nonatomic,strong)FIRDatabaseReference * topicRef;
```
>
```
-(FIRDatabaseReference *)topicRef{
    if (!_topicRef) {
        _topicRef = [[FIRDatabase database]referenceFromURL:@"https://firstfirebase-298c7.firebaseio.com/news"];
    }
    return _topicRef;
}
```
用以下代码替换你的**viewdidload**
>
```
- (void)viewDidLoad {
    [super viewDidLoad];
    //数据源创建
    self.datasource = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    //登录监听
    [[FIRAuth auth]addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if (user) {
            //如果当前有登录用户,根据priority进行排序，并获取最新的20调数据
            FIRDatabaseQuery * query =[[weakSelf.topicRef queryOrderedByPriority] queryLimitedToFirst:20];
            //监听数据库值得变化，当数据库数据有变动，比如topic条数添加/删除时 会触发此block
            FIRDatabaseHandle handle = [query observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary * dict = snapshot.value;
                [self.datasource removeAllObjects];
                //便利查询的值
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    TopicModel * model = [[TopicModel alloc]init];
                    model.topicId      = key;//topic的唯一值
                    model.topicDesc    = obj[@"topicDesc"];
                    model.topicImageURL = obj[@"topicImageURL"];
                    model.authName      = obj[@"auth"] ?: @"unknown" ;
                    model.topicTitle    = obj[@"topicTitle"];
                    model.topicHTMLString = obj[@"topicHtml"];
                    NSTimeInterval interval = [obj[@"createdate"] doubleValue];
                    if (interval > 0) {
                        model.postDate      = [NSDate dateWithTimeIntervalSince1970:[obj[@"createdate"] doubleValue]];
                    }
                    [weakSelf.datasource addObject:model];
                    //刷新列表
                    [weakSelf.tableView reloadData];
                }];
            }];
        }
    }];
  }
```
实现tableview的代理
> 
```
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
  }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
  }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicModel * model = self.datasource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = model.topicTitle;
    cell.detailTextLabel.text = model.topicDesc;
    return cell;
  }
  -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
  }
```
好运行一下
![](http://upload-images.jianshu.io/upload_images/1724493-88675a54be7422fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
好你发布过的topic已经显示数来了，你可以试着发布一个新的topic，看看列表会不会更新。肯定会更新的哦~

6.编写 TopicDetailViewController
> TopicDetailViewController内部只有一个web view用来加载我们在发布topic时拼装的html字符串。
> 在.h文件中添加一个属性，并从storyboard中将web view拖拽为一个属性，如下：
>
```
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic,strong)NSString * htmlString;
```
> 然后将viewdidload替换为以下代码：
> 
```
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webview loadHTMLString:self.htmlString baseURL:nil];
  }
```
> 在TopicListViewController.m 里添加storyboard的跳转逻辑
>
```
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        TopicModel * model =  self.datasource[indexPath.row];
        TopicDetailViewController * detailVC = segue.destinationViewController;
        detailVC.htmlString = model.topicHTMLString;
    }
  }
```
>
运行一下，点击列表进入topic详情
![](http://upload-images.jianshu.io/upload_images/1724493-6a11f9009823e9cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
好这样topic模块儿完成了

这是最后一关了！关联登录模块儿和topic模块儿
> 逻辑很简单，当前没有用户登录时就present登录界面
将MainNavigationController.m的内容替换为以下代码
> 
```
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
```
还没有完继续
> 当我们登录或者注册成功后需要将页面消失掉
在注册成功和登录成功的if条件分支下，添加以下代码：
> 
```
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
```
运行并登录看结果！！！

#大功告成！！！！

![](https://github.com/NicolasKim/FirebaseGuideDemo/blob/master/firebase-gif.gif)

完整demo请参见 本人github仓库->[FirebaseGuideDemo](https://github.com/NicolasKim/FirebaseGuideDemo/tree/tag-demo)。

这是我在简书写的第一篇文章，花了我三天的业余时间去完成，
写了一个全新的demo，一边写代码一边写文章，有什么不足的地方尽管说，我都会听进去。
```