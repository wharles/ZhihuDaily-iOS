//
//  LatestNews.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "LatestNews.h"

@implementation LatestNews

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date" : @"date",
             @"stories" : @"stories",
             @"topStories" : @"top_stories"
             };
}

+ (NSValueTransformer *)storiesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[Stories class] fromJSONArray:array error:nil];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

+ (NSValueTransformer *)topStoriesJSONTransformer {
    return [LatestNews storiesJSONTransformer];
}

@end
