//
//  MainViewController.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "MainViewController.h"
#import "LatestViewController.h"
#import "ThemesViewController.h"
#import "HotViewController.h"
#import "SectionsViewController.h"
#import "BeforeViewController.h"
#import "JTHamburgerButton.h"
#import "MLKMenuPopover.h"
#import "FavoriteViewController.h"
#import "AboutViewController.h"

#import <ReactiveCocoa.h>

@interface MainViewController () <MLKMenuPopoverDelegate>

@property(nonatomic,strong) MLKMenuPopover *menuPopover;
@property(nonatomic,strong) NSArray *menuItems;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.menuItems = [NSArray arrayWithObjects:@"收藏", @"关于", nil];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    JTHamburgerButton *jtBtn = [[JTHamburgerButton alloc] initWithFrame:customView.bounds];
    [[jtBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // Hide already showing popover
        [self.menuPopover dismissMenuPopover];
        self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(20, 0, 66, 88) menuItems:self.menuItems];
        self.menuPopover.menuPopoverDelegate = self;
        [self.menuPopover showInView:self.view];
    }];
    [customView addSubview:jtBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    LatestViewController *lastVC = [[LatestViewController alloc] initWithTitle:@"最新消息" image:[UIImage imageNamed:@"test1"] selectedImage:[UIImage imageNamed:@"test0"]];
    
    ThemesViewController *themeVC = [[ThemesViewController alloc] initWithTitle:@"主题日报" image:[UIImage imageNamed:@"test1"] selectedImage:[UIImage imageNamed:@"test0"]];
    
    HotViewController *hotVC = [[HotViewController alloc] initWithTitle:@"热门消息" image:[UIImage imageNamed:@"test1"] selectedImage:[UIImage imageNamed:@"test0"]];
    
    SectionsViewController *sectionVC = [[SectionsViewController alloc] initWithTitle:@"栏目总览" image:[UIImage imageNamed:@"test1"] selectedImage:[UIImage imageNamed:@"test0"]];
    
    BeforeViewController *beforeVC = [[BeforeViewController alloc] initWithTitle:@"过往消息" image:[UIImage imageNamed:@"test1"] selectedImage:[UIImage imageNamed:@"test0"]];
    
    self.viewControllers = @[lastVC, themeVC, hotVC, sectionVC, beforeVC];
}

#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    if (selectedIndex == 0) {
        FavoriteViewController *favoriteViewController = [[FavoriteViewController alloc] init];
        [self.navigationController pushViewController:favoriteViewController animated:YES];
    }
    if (selectedIndex == 1) {
        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutViewController animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
