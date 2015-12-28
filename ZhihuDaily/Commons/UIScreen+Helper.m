//
//  UIScreen+Helper.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/15.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "UIScreen+Helper.h"

@implementation UIScreen (Helper)

- (CGSize)actualResolution {
    CGSize rectSize = self.bounds.size;
    CGFloat scaleScreen = self.scale;
    rectSize.width *= scaleScreen;
    rectSize.height *= scaleScreen;
    return rectSize;
}

@end
