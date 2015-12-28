//
//  SQLiteHelper.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/24.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteHelper : NSObject

+ (instancetype)sharedManager;

- (void)openDatabase;
- (BOOL)execSql:(NSString *)sql;
- (NSArray *)querySQL:(NSString *)sql;

@end
