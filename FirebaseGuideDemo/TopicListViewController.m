//
//  TopicListViewController.m
//  FirebaseGuideDemo
//
//  Created by 金秋成 on 16/9/29.
//  Copyright © 2016年 金秋成. All rights reserved.
//

#import "TopicListViewController.h"
#import "TopicModel.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import "TopicDetailViewController.h"
@interface TopicListViewController ()
@property (nonatomic,strong)NSMutableArray * datasource;
@property (nonatomic,strong)FIRDatabaseReference * topicRef;
@end

@implementation TopicListViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        TopicModel * model =  self.datasource[indexPath.row];
        TopicDetailViewController * detailVC = segue.destinationViewController;
        detailVC.htmlString = model.topicHTMLString;
    }
}
-(FIRDatabaseReference *)topicRef{
    if (!_topicRef) {
        _topicRef = [[FIRDatabase database]referenceFromURL:@"https://firstfirebase-298c7.firebaseio.com/news"];
    }
    return _topicRef;
}


@end
