//
//  SQLiteHelper.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/24.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "SQLiteHelper.h"
#import <sqlite3.h>

@implementation SQLiteHelper {
    NSString *_fileName;
    sqlite3 *db;
}

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    if (!_sharedManager) {
        _sharedManager = [[self alloc] initWithDBFileName:@"News"];
        [_sharedManager openDatabase];
        [_sharedManager execSql:@"CREATE Table IF NOT EXISTS INFO (newsId VARCHAR(50) PRIMARY KEY ,name VARCHAR(50))"];
    }
    return _sharedManager;
}

- (id)initWithDBFileName:(NSString *)fileName {
    if (self = [super init]) {
        _fileName = fileName;
    }
    return self;
}

/**
 相当于连接字符串
 **/
- (NSString *)getFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    return [dir stringByAppendingPathComponent:_fileName];
}
/**
 打开数据库
 **/
- (void)openDatabase {
    if(sqlite3_open([[self getFilePath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"数据库打开失败。");
    }
}

/**
 插入数据
 **/
- (BOOL)execSql:(NSString *)sql {
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"数据库操作数据失败!");
        return NO;
    } else {
        return YES;
    }
}

/**
 查询数据
 **/
- (NSArray *)querySQL:(NSString *)sql {
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableDictionary *dict = nil;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *nsName = [NSString stringWithUTF8String:name];
            char *nid = (char *)sqlite3_column_text(statement, 0);
            NSInteger newsId = [[NSString stringWithUTF8String:nid] integerValue];
            
            dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(newsId) forKey:@"id"];
            [dict setObject:nsName forKey:@"name"];
            
            [array addObject:dict];
        }
        sqlite3_close(db);
        return array;
    } else {
        sqlite3_close(db);
        return nil;
    }
}

@end
