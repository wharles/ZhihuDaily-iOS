//
//  ItemTableViewCell.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "ItemTableViewCell.h"
#import <Masonry.h>

@implementation ItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

/**
 设置cell的布局
 **/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat spacing = 12.0f;
        self.titleImageView = [UIImageView new];
        self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:self.titleImageView];
        [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(spacing);
            make.size.mas_equalTo(CGSizeMake(64.0, 64.0));
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.tag = 21;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY).with.priorityLow();
            make.left.equalTo(self.titleImageView.mas_right).with.offset(spacing);
            make.right.equalTo(self.contentView.mas_right).with.offset(-spacing);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
