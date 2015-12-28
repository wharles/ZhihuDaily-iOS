//
//  SectionsViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "SectionsViewController.h"
#import "ItemStyle1TableViewCell.h"
#import "SectionListViewController.h"
#import "ItemTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "Others.h"
#import "RequestManager.h"
#import <ReactiveCocoa.h>

@interface SectionsViewController ()

@end

@implementation SectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //监听并请求数据
    [[RequestManager sharedManager] startRequestWithVCId:2];
    self.refreshRequest = ^(id x) {
        [[RequestManager sharedManager] startRequestWithVCId:2];
    };
    [[[RACObserve([RequestManager sharedManager], sections) ignore:nil] deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray* newSections) {
         self.dataSource = newSections;
         [self.tableView reloadData];
         [self refreshComplete];
     }];
}

#pragma mark - TableView DataSource Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"SectionsCellStyle1";
    Others* other = self.dataSource[indexPath.row];
    if ([other.desc isEqual:@""]) {
        ItemTableViewCell* cell = (ItemTableViewCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
        
        cell.titleLabel.text = other.name;
        cell.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15];
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:other.thumbnail]];
        return cell;
        
    } else {
        ItemStyle1TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ItemStyle1TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.titleImageView.layer.cornerRadius = 32;
            cell.titleImageView.layer.masksToBounds = YES;
            cell.titleImageView.image = [UIImage imageNamed:@"default"];
        }
        
        cell.titleLabel.text = other.name;
        cell.descLabel.text = other.desc;
        cell.descLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:12];
        cell.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15];
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:other.thumbnail]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Others* other = self.dataSource[indexPath.row];
    SectionListViewController* sectionListVC = [[SectionListViewController alloc] init];
    sectionListVC.sectionId = other.id;
    sectionListVC.title = other.name;
    [self.navigationController pushViewController:sectionListVC animated:YES];
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
