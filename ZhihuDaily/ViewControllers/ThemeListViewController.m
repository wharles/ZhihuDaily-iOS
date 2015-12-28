//
//  ThemeListViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "ThemeListViewController.h"
#import "Stories.h"
#import "ItemTableViewCell.h"
#import "DetailViewController.h"
#import "RequestManager.h"
#import <ReactiveCocoa.h>
#import <UIImageView+WebCache.h>

@interface ThemeListViewController ()

@end

@implementation ThemeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //单例请求
    [[RequestManager sharedManager] startRequestWithVCId:5 requestParaId:self.themeId];
    //下拉刷新
    __weak ThemeListViewController *weakSelf = self;
    self.refreshRequest = ^(id x) {
        [[RequestManager sharedManager] startRequestWithVCId:5 requestParaId:weakSelf.themeId];
    };
    //监听并请求数据
    [[[RACObserve([RequestManager sharedManager], themeList) ignore:nil] deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *themeList) {
         self.dataSource = themeList;
         [self.tableView reloadData];
         [self refreshComplete];
     }];
}

#pragma mark - TableView DataSource Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell* cell = (ItemTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    Stories* story = self.dataSource[indexPath.row];
    cell.titleLabel.text = story.title;
    cell.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:16];
    if (![story.images isEqual:@""] && story.images != nil) {
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:story.images]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Stories* story = self.dataSource[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.newsId = story.id;
    detailVC.title = @"主题消息";
    [self.navigationController pushViewController:detailVC animated:YES];
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
