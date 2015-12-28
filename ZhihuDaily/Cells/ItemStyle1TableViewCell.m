//
//  ItemStyle1TableViewCell.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/7.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "ItemStyle1TableViewCell.h"
#import <Masonry.h>

@implementation ItemStyle1TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.descLabel = [UILabel new];
        
        self.descLabel.numberOfLines = 0;
        [self addSubview:self.descLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(21));
            make.top.equalTo(self.contentView.mas_top).with.offset(4);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(3);
            make.left.equalTo(self.titleImageView.mas_right).with.offset(12);
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-4);
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
