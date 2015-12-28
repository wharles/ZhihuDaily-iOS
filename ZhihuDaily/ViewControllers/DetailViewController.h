//
//  DetailViewController.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsContent.h"

@interface DetailViewController : UIViewController

@property (assign, nonatomic) NSInteger newsId;
@property (strong,nonatomic)UIActivityIndicatorView* spinner;

@end
