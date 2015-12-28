//
//  SectionListViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "SectionListViewController.h"
#import "ItemStyle1TableViewCell.h"
#import "SectionModel.h"
#import "DetailViewController.h"
#import "RequestManager.h"
#import "NSDate+Helper.h"
#import <ReactiveCocoa.h>
#import <UIImageView+WebCache.h>

@interface SectionListViewController ()

@end

@implementation SectionListViewController {
    UIActivityIndicatorView *_lodingView;
    NSInteger maxId;
    NSInteger timestamp;
    UIView *footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    float x = 0, y = 0;
    float w = self.view.bounds.size.width;
    float h = 44;
    footView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _lodingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _lodingView.center = footView.center;
    _lodingView.tag = 10;
    _lodingView.hidesWhenStopped = YES;
    [footView addSubview:_lodingView];
    
    self.tableView.tableFooterView = footView;
    
    //注册请求数据
    NSDate *date = [NSDate date];
    [[RequestManager sharedManager] startRequestWithVCId:6 requestParaId:self.sectionId timestamp:[date toTimestamp]];
    //注册刷新数据
    __weak SectionListViewController *weakSelf = self;
    self.refreshRequest = ^(id x) {
        [[RequestManager sharedManager] startRequestWithVCId:6 requestParaId:weakSelf.sectionId timestamp:[date toTimestamp]];
    };
    //注册监听sectionList属性变化
    [[[RACObserve([RequestManager sharedManager], sectionList) ignore:nil] deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(SectionList *sectionList) {
         Stories *tmp = [sectionList.stories firstObject];
         if (tmp != nil) {
             if (self.dataSource == nil || (maxId <= tmp.id && maxId != 0) ||
                 [[NSDate dateWithTimeIntervalSince1970:sectionList.timestamp] isSameDay:date]) {
                 //如果是第一次或者下拉刷新，执行直接赋值数组
                 self.dataSource = sectionList.stories;
             } else {
                 //点击了加载更多按钮，则之行先将数据加到一个临时可变数组，并入新
                 //请求的数据，然后赋值给data source
                 NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource];
                 [array addObjectsFromArray:sectionList.stories];
                 self.dataSource = array;
             }
             maxId = tmp.id;
             timestamp = sectionList.timestamp;
             [self.tableView reloadData];
         }
         [self refreshComplete];
     }];
}

#pragma mark - TableView DataSource Delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"SectionListCellStyle1";
    SectionModel* model = self.dataSource[indexPath.row];
    ItemStyle1TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ItemStyle1TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.titleImageView.layer.cornerRadius = 32;
        cell.titleImageView.layer.masksToBounds = YES;
        cell.titleImageView.image = [UIImage imageNamed:@"default"];
    }
    
    cell.titleLabel.text = model.displayDate;
    cell.descLabel.text = model.title;
    cell.descLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:12];
    cell.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15];
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.images]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionModel* model = self.dataSource[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.newsId = model.id;
    detailVC.title = @"栏目消息";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL endOfTable = (scrollView.contentOffset.y >= (self.dataSource.count * 72 - scrollView.frame.size.height));
    //load more data when end of table
    if(endOfTable && !scrollView.isDragging && !scrollView.isDecelerating){
        self.tableView.tableFooterView = footView;
        [(UIActivityIndicatorView*)[footView viewWithTag:10]startAnimating];
        [_lodingView startAnimating];
        //延时2s更新数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                           @synchronized(self) {
                               [[RequestManager sharedManager] startRequestWithVCId:6 requestParaId:self.sectionId timestamp:timestamp];
                           }
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [_lodingView stopAnimating];
                           });
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[RequestManager sharedManager] dispose];
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
