//
//  Hots.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/7.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "Hots.h"

@implementation Hots

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"newsId" : @"news_id",
             @"thumbnail" : @"thumbnail",
             @"title" : @"title",
             @"url" : @"url"
             };
}

@end
