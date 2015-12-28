//
//  NSDate+Helper.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/15.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

- (NSInteger)toInteger {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return [destDateString integerValue];
}

- (NSInteger)toTimestamp {
     return [self timeIntervalSince1970] * 1000;
}

- (BOOL)isSameDay:(NSDate *)date {
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    if ((int)(([self timeIntervalSince1970] + timezoneFix) / (24 * 3600)) - (int)(([date timeIntervalSince1970] + timezoneFix) / (24 * 3600)) == 0)
    {
        return YES;
    }
    return NO;
}

@end
