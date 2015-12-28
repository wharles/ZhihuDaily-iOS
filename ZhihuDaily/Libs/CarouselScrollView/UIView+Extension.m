//
//  UIView+Extension.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/4.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)actualHeight {
    return self.frame.size.height;
}

- (CGFloat)actualWidth {
    return self.frame.size.width;
}

- (CGFloat)actualX {
    return self.frame.origin.x;
}

- (CGFloat)actualY {
    return self.frame.origin.y;
}

- (void)setActualHeight:(CGFloat)actualHeight {
    CGRect temp = self.frame;
    temp.size.height = actualHeight;
    self.frame = temp;
}

- (void)setActualWidth:(CGFloat)actualWidth {
    CGRect temp = self.frame;
    temp.size.width = actualWidth;
    self.frame = temp;
}

- (void)setActualX:(CGFloat)actualX {
    CGRect temp = self.frame;
    temp.origin.x = actualX;
    self.frame = temp;
}

- (void)setActualY:(CGFloat)actualY {
    CGRect temp = self.frame;
    temp.origin.y = actualY;
    self.frame = temp;
}

@end
