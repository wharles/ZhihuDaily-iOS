//
//  BaseViewController.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic, nullable) UITableView *tableView;

@property (strong,nonatomic, nullable) UIRefreshControl *refreshControl;

@property (strong,nonatomic, nullable) NSArray *dataSource;

@property (copy, nonatomic, nullable) void(^refreshRequest)(_Nullable id x);

- (void)refreshComplete;

- (nullable id)initWithTitle:(nullable NSString*)title image:(nullable UIImage*)image selectedImage:(nullable UIImage*)selectedImage;

@end
