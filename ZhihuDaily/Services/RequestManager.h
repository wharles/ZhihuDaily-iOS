//
//  RequestManager.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>
#import "SectionModel.h"
#import "Stories.h"
#import "LatestNews.h"
#import "NewsContent.h"
#import "StartImage.h"

@interface RequestManager : NSObject

+ (instancetype)sharedManager;

@property (strong, nonatomic, readonly) LatestNews *latestStories;
@property (strong, nonatomic, readonly) NSArray *themes;
@property (strong, nonatomic, readonly) NSArray *sections;
@property (strong, nonatomic, readonly) NSArray *hots;
@property (strong, nonatomic, readonly) NewsContent *newsContent;
@property (strong, nonatomic, readonly) NSArray *themeList;
@property (strong, nonatomic, readonly) SectionList *sectionList;
@property (strong, nonatomic, readonly) StartImage *startImage;
@property (strong, nonatomic, readonly) NSArray *beforeNews;

@property (strong, nonatomic, readonly) NSNumber *requestMap;

- (void)startRequestWithVCId:(NSInteger)vcId;
- (void)startRequestWithVCId:(NSInteger)vcId requestParaId:(NSInteger)paraId;
- (void)startRequestWithVCId:(NSInteger)vcId requestParaId:(NSInteger)paraId timestamp:(NSInteger)timestamp;

- (void)dispose;

@end
