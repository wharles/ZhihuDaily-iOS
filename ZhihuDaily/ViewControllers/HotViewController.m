//
//  HotViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "HotViewController.h"
#import "ItemTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Hots.h"
#import "RequestManager.h"
#import <ReactiveCocoa.h>
#import "DetailViewController.h"

@interface HotViewController ()

@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听并请求数据
    [[RequestManager sharedManager] startRequestWithVCId:3];
    self.refreshRequest = ^(id x) {
        [[RequestManager sharedManager] startRequestWithVCId:3];
    };
    [[[RACObserve([RequestManager sharedManager], hots) ignore:nil] deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray* hotNews) {
         self.dataSource = hotNews;
         [self.tableView reloadData];
         [self refreshComplete];
     }];
}

#pragma mark - TableView DataSource Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell* cell = (ItemTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    Hots* hotNews = self.dataSource[indexPath.row];
    cell.titleLabel.text = hotNews.title;
    cell.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:16];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:hotNews.thumbnail]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Hots* hots = self.dataSource[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.newsId = hots.newsId;
    detailVC.title = @"热门消息";
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
