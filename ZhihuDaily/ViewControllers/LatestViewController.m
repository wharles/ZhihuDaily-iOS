//
//  LatestViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "LatestViewController.h"
#import "ItemTableViewCell.h"
#import "RequestManager.h"
#import "Stories.h"
#import <ReactiveCocoa.h>
#import <UIImageView+WebCache.h>
#import "CarouselScrollView.h"
#import "DetailViewController.h"

@interface LatestViewController () <CarouselScrollViewDelegate>

@end

@implementation LatestViewController {
    CarouselScrollView *_scrollView;
    NSMutableArray *imagesURLs;
    NSMutableArray *titles;
    NSArray* topNews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.automaticallyAdjustsScrollViewInsets = NO;
    //设置Header Frame
    CGFloat x = 0,y = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width;
    
    //创建轮播
    _scrollView = [CarouselScrollView carouselScrollViewWithFrame:CGRectMake(x, y, width, height) imageURLStringsGroup:nil];
    _scrollView.pageControlAliment = CarouselScrollViewPageControlAlimentRight;
    _scrollView.titleLabelHeight = 80;
    _scrollView.delegate = self;
    _scrollView.dotColor = [UIColor colorWithRed:231.0 / 255.0 green:95.0 / 255.0 blue:53.0 / 255.0 alpha:0.3];
    _scrollView.placeholderImage = [UIImage imageNamed:@"topImg1"];
    self.tableView.tableHeaderView = _scrollView;
    //监听并请求数据
    [[RequestManager sharedManager] startRequestWithVCId:0];
    [[[RACObserve([RequestManager sharedManager], latestStories) ignore:nil] deliverOn:RACScheduler.mainThreadScheduler]
        subscribeNext:^(LatestNews *newStories) {
            self.dataSource = newStories.stories;
            [self.tableView reloadData];
            topNews = newStories.topStories;
            //初始化数组
            imagesURLs = [[NSMutableArray alloc] init];
            titles = [[NSMutableArray alloc] init];
            for (Stories *story in newStories.topStories) {
                [imagesURLs addObject:story.image];
                [titles addObject:story.title];
            }
            _scrollView.imageURLStringsGroup = imagesURLs;
            _scrollView.titlesGroup = titles;
            [self refreshComplete];
    }];
    
    self.refreshRequest = ^(id x) {
        [[RequestManager sharedManager] startRequestWithVCId:0];
    };
}

#pragma mark - TableView DataSource Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = (ItemTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        Stories* story = self.dataSource[indexPath.row];
        cell.titleLabel.text = story.title;
        cell.titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:16];
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:story.images]];
    }
    return cell;
}

/**
 跳转到详情页
 **/
- (void)navigationToDetialPageWithPara:(Stories *)story {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.newsId = story.id;
    detailVC.title = @"最新消息";
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Stories* story = self.dataSource[indexPath.row];
    [self navigationToDetialPageWithPara:story];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)carouselScrollView:(CarouselScrollView *)carouselScrollView didSelectItemAtIndex:(NSInteger)index {
    Stories* story = topNews[index];
    [self navigationToDetialPageWithPara:story];
}

@end
