//
//  Stories.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "Stories.h"

@implementation Stories

+ (NSDictionary*)JSONKeyPathsByPropertyKey {
    return @{
             @"images" : @"images",
             @"image" : @"image",
             @"type" : @"type",
             @"id" : @"id",
             @"gaPrefix" : @"ga_prefix",
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
