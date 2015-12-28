//
//  BeforeViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "BeforeViewController.h"
#import <ReactiveCocoa.h>
#import "RequestManager.h"
#import "ItemTableViewCell.h"
#import "Stories.h"
#import "DetailViewController.h"
#import "NSDate+Helper.h"
#import <UIImageView+WebCache.h>

@interface BeforeViewController ()

@end

@implementation BeforeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePicker.locale = locale;
    [[datePicker rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UIDatePicker *control) {
        [[RequestManager sharedManager] startRequestWithVCId:8 requestParaId:[datePicker.date toInteger]];
    }];
    self.tableView.tableHeaderView = datePicker;
    
    //监听并请求数据
    [[RequestManager sharedManager] startRequestWithVCId:8 requestParaId:[datePicker.date toInteger]];
    self.refreshRequest = ^(id x) {
        [[RequestManager sharedManager] startRequestWithVCId:8 requestParaId:[datePicker.date toInteger]];
    };
    [[[RACObserve([RequestManager sharedManager], beforeNews) ignore:nil] deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray* beforeNews) {
         self.dataSource = beforeNews;
         [self.tableView reloadData];
         [self refreshComplete];
     }];
}

#pragma mark - TableView DataSource Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell* cell = (ItemTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    Stories* news = self.dataSource[indexPath.row];
    cell.titleLabel.text = news.title;
    cell.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:16];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:news.images]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Stories* news = self.dataSource[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.newsId = news.id;
    detailVC.title = @"过往消息";
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
