//
//  SectionModel.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "SectionModel.h"

@implementation SectionModel

+ (NSDictionary*)JSONKeyPathsByPropertyKey {
    return @{
             @"images" : @"images",
             @"date" : @"date",
             @"id" : @"id",
             @"displayDate" : @"display_date",
             @"title" : @"title"
             };
}

+ (NSValueTransformer *)imagesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSArray *arryImg = value;
        return [arryImg firstObject];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

@end

@implementation SectionList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"timestamp" : @"timestamp",
             @"stories" : @"stories",
             @"name" : @"name"
             };
}

+ (NSValueTransformer *)storiesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *array, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter modelsOfClass:[SectionModel class] fromJSONArray:array error:nil];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

@end
