//
//  NSDate+Helper.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/15.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

- (NSInteger)toInteger;
- (NSInteger)toTimestamp;

- (BOOL)isSameDay:(NSDate *)date;

@end
