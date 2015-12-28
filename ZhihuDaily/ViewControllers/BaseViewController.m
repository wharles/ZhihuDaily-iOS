//
//  BaseViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "BaseViewController.h"
#import "ItemTableViewCell.h"
#import "RequestManager.h"

#import <ReactiveCocoa.h>

@interface BaseViewController ()

@end

@implementation BaseViewController {
    NSString* navTitle;
}

- (nullable id)initWithTitle:(nullable NSString*)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage {
    if (self = [super init]) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
        navTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //防止tableview最后一行被tabbar挡住
    self.tabBarController.edgesForExtendedLayout = UIRectEdgeNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //初始化TableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    //pull to refresh control
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    self.refreshControl.tintColor = [UIColor colorWithRed:231.0/255.0 green:95.0/255.0 blue:53.0/255.0 alpha:0.3];
    [self.tableView addSubview:self.refreshControl];
    //监听下拉刷新事件
    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.refreshRequest(x);
        });
    }];
}

- (void)refreshComplete {
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
}

#pragma mark - View Settings

- (void)viewWillAppear:(BOOL)animated {
    if (navTitle) {
        self.tabBarController.title = [NSString stringWithFormat:@"知乎日报·%@", navTitle];
    } else {
        self.tabBarController.title = @"知乎日报";
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.tableView.frame = bounds;
}

#pragma mark - TableView DataSource Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    ItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.titleImageView.layer.cornerRadius = 32;
        cell.titleImageView.layer.masksToBounds = YES;
        cell.titleImageView.image = [UIImage imageNamed:@"default"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
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
