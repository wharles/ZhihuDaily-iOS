//
//  NewsContent.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "NewsContent.h"

@implementation NewsContent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"body" : @"body",
             @"imageSource" : @"image_source",
             @"title" : @"title",
             @"image" : @"image",
             @"shareURL" : @"share_url",
             @"js" : @"js",
             @"gaPrefix" : @"ga_prefix",
             @"type" : @"type",
             @"id" : @"id",
             @"css" : @"css"
             };
}

@end
