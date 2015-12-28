//
//  ThemesViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "ThemesViewController.h"
#import "ItemStyle1TableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Others.h"
#import "RequestManager.h"
#import <ReactiveCocoa.h>
#import "ThemeListViewController.h"

#import "HttpClient.h"

@interface ThemesViewController ()

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听并请求数据
    [[RequestManager sharedManager] startRequestWithVCId:1];
    self.refreshRequest = ^(id x) {
        [[RequestManager sharedManager] startRequestWithVCId:1];
    };
    [[[RACObserve([RequestManager sharedManager], themes) ignore:nil] deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray* newTheme) {
         self.dataSource = newTheme;
         [self.tableView reloadData];
         [self refreshComplete];
     }];
}

#pragma mark - TableView DataSource Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifierStyle1";
    ItemStyle1TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ItemStyle1TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.titleImageView.layer.cornerRadius = 32;
        cell.titleImageView.layer.masksToBounds = YES;
        cell.titleImageView.image = [UIImage imageNamed:@"default"];
    }
    //add code here
    Others* other = self.dataSource[indexPath.row];
    cell.titleLabel.text = other.name;
    cell.descLabel.text = other.desc;
    cell.descLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:12];
    cell.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:other.thumbnail]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Others* other = self.dataSource[indexPath.row];
    ThemeListViewController* themeListVC = [[ThemeListViewController alloc] init];
    themeListVC.themeId = other.id;
    themeListVC.title = other.name;
    [self.navigationController pushViewController:themeListVC animated:YES];
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
