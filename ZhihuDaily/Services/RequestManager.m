//
//  RequestManager.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "RequestManager.h"
#import "HttpClient.h"
#import <TSMessage.h>

@interface RequestManager ()

@property (strong, nonatomic, readwrite) LatestNews *latestStories;
@property (strong, nonatomic, readwrite) NSArray *themes;
@property (strong, nonatomic, readwrite) NSArray *sections;
@property (strong, nonatomic, readwrite) NSArray *hots;
@property (strong, nonatomic, readwrite) NewsContent *newsContent;
@property (strong, nonatomic, readwrite) NSArray *themeList;
@property (strong, nonatomic, readwrite) SectionList *sectionList;
@property (strong, nonatomic, readwrite) StartImage *startImage;
@property (strong, nonatomic, readwrite) NSArray *beforeNews;

@property (strong, nonatomic, readwrite) NSNumber *requestMap;
@property (assign, nonatomic) NSInteger requestId;
@property (assign, nonatomic) NSInteger timestamp;

@property (strong, nonatomic )HttpClient *client;

@end

@implementation RequestManager {
    Reachability *hostReach;
}

/**
 单利模式用于管理数据请求
 **/
+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

/**
 初始化
 **/
- (id)init {
    if (self = [super init]) {
        _client = [[HttpClient alloc] init];
        [[[[RACObserve(self, requestMap) ignore:nil] flattenMap:^RACStream *(NSNumber *vcId) {
            NSArray *signalMap = @[[self updateLatestNews], [self updateThemes], [self updateSections], [self updateHots],
                                   [self updateNewsContent], [self updateThemeList], [self updateSectionList], [self updateStartImage],
                                   [self updateBeforeNews]];
            return signalMap[vcId.intValue];
            }] deliverOn:RACScheduler.mainThreadScheduler] subscribeError:^(NSError *error) {
            [TSMessage showNotificationWithTitle:@"错误" subtitle:@"请求出错！" type:TSMessageNotificationTypeError];
        }];
    }
    return self;
}

/**
 检查网络连接
 **/
- (void)startRequestWithVCId:(NSInteger)vcId {
    Reachability* reach = [Reachability reachabilityWithHostname:@"cn.bing.com"];
    reach.reachableOnWWAN = NO;
    NSParameterAssert([reach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status != NotReachable) {
        self.requestMap = @(vcId);
    }
}

/**
 检查网络连接带请求参数
 **/
- (void)startRequestWithVCId:(NSInteger)vcId requestParaId:(NSInteger)paraId {
    self.requestId = paraId;
    [self startRequestWithVCId:vcId];
}

- (void)startRequestWithVCId:(NSInteger)vcId requestParaId:(NSInteger)paraId timestamp:(NSInteger)timestamp {
    self.timestamp = timestamp;
    [self startRequestWithVCId:vcId requestParaId:paraId];
}

/**
 开始更新最新消息
 **/
- (RACSignal *)updateLatestNews {
    return [[self.client fetchLatestNews] doNext:^(LatestNews* latestNews) {
        self.latestStories = latestNews;
    }];
}

/**
 开始更新知乎主题日报
 **/
- (RACSignal *)updateThemes {
    return [[self.client fetchThemes] doNext:^(NSArray* others) {
        self.themes = others;
    }];
}

/**
 开始更新栏目列表
 **/
- (RACSignal *)updateSections {
    return [[self.client fetchSections] doNext:^(NSArray* sections) {
        self.sections = sections;
    }];
}

/**
 开始更新最热消息
 **/
- (RACSignal *)updateHots {
    return [[self.client fetchHots] doNext:^(NSArray* hots) {
        self.hots = hots;
    }];
}

- (RACSignal *)updateNewsContent {
    return [[self.client fetchNewsContentWithId:self.requestId] doNext:^(NewsContent *content) {
        self.newsContent = content;
    }];
}

- (RACSignal *)updateThemeList {
    return [[self.client fetchThemeListWithId:self.requestId] doNext:^(NSArray *themeList) {
        self.themeList = themeList;
    }];
}

- (RACSignal *)updateSectionList {
    return [[self.client fetchSectionListWithId:self.requestId timestamp:self.timestamp] doNext:^(SectionList *sectionList) {
        self.sectionList = sectionList;
    }];
}

- (RACSignal *)updateStartImage {
    return [[self.client fetchStartImage] doNext:^(StartImage *startImage) {
        self.startImage = startImage;
    }];
}

- (RACSignal *)updateBeforeNews {
    return [[self.client fetchBeforeNewsWithDate:self.requestId] doNext:^(NSArray *beforeNews) {
        self.beforeNews = beforeNews;
    }];
}

- (void)dispose {
    self.sectionList = nil;
    self.timestamp = 0;
}

@end
