//
//  CarouselCollectionViewCell.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/4.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;

@property (strong, nonatomic) UIView *headView;

@property (nonatomic, assign) BOOL hasConfigured;

@end
