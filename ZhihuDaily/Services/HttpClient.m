//
//  HttpClient.m
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import "HttpClient.h"
#import <Mantle.h>
#include "LatestNews.h"
#import "Others.h"
#import "Hots.h"
#import "NewsContent.h"
#import "SectionModel.h"
#import "StartImage.h"
#import "UIScreen+Helper.h"

@interface HttpClient ()

@property (strong,nonatomic)NSURLSession *session;

@end

@implementation HttpClient

- (id)init {
    if (self = [super init]) {
        //设置NSURLSession
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

/**
 通用URL请求获取json并通知
 **/

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSError* jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (!jsonError) {
                    [subscriber sendNext:json];
                } else {
                    [subscriber sendError:jsonError];
                }
            } else {
                [subscriber sendError:error];
            }
        }];
        [dataTask resume];
        //释放请求
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doNext:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

/**
 请求模版，用于请求返回json包含一个array节点的接口
 **/
- (RACSignal *)fetchDataModelOfCalss:(Class)class nodeName:(NSString *)name withURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        RACSequence *list = [json[name] rac_sequence];
        return [[list map:^id(NSDictionary *dict) {
            return [MTLJSONAdapter modelOfClass:class fromJSONDictionary:dict error:nil];
        }] array];
    }];
}

#pragma mark - 知乎日报的主要栏目列表

/**
 获取最新的消息
 **/
- (RACSignal *)fetchLatestNews {
    NSString *urlString = @"http://news-at.zhihu.com/api/4/news/latest";
    NSURL *url = [NSURL URLWithString:urlString];
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[LatestNews class] fromJSONDictionary:json error:nil];
    }];
}

/**
 获取主题日报
 **/
- (RACSignal *)fetchThemes {
    NSString *urlString = @"http://news-at.zhihu.com/api/4/themes";
    return [self fetchDataModelOfCalss:[Others class] nodeName:@"others" withURLString:urlString];
}

/**
 获取栏目列表
 **/
- (RACSignal *)fetchSections {
    NSString *urlString = @"http://news-at.zhihu.com/api/3/sections";
    return [self fetchDataModelOfCalss:[Others class] nodeName:@"data"withURLString:urlString];
}

/**
 获取热门消息
 **/
- (RACSignal *)fetchHots {
    NSString *urlString = @"http://news-at.zhihu.com/api/3/news/hot";
    return [self fetchDataModelOfCalss:[Hots class] nodeName:@"recent" withURLString:urlString];
}

/**
 过往消息
 **/
- (RACSignal *)fetchBeforeNewsWithDate:(NSInteger)dateNum {
    NSString *urlString = [NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%ld", (long)dateNum];
    return [self fetchDataModelOfCalss:[Stories class] nodeName:@"stories" withURLString:urlString];
}

#pragma mark - 知乎日报的具体内容

/**
 获取新闻具体内容
 **/
- (RACSignal *)fetchNewsContentWithId:(NSInteger)newsId {
    NSString *urlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%ld", (long)newsId];
    NSURL *url = [NSURL URLWithString:urlString];
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[NewsContent class] fromJSONDictionary:json error:nil];
    }];
}

#pragma mark - 知乎日报的二级列表

/**
 获取主题内容列表
 **/
- (RACSignal *)fetchThemeListWithId:(NSInteger)themeId {
    NSString *urlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%ld", (long)themeId];
    return [self fetchDataModelOfCalss:[Stories class] nodeName:@"stories" withURLString:urlString];
}

/**
 获取栏目列表
 **/
- (RACSignal *)fetchSectionListWithId:(NSInteger)sectionId timestamp:(NSInteger)timestamp {
    NSString *urlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/3/section/%ld/before/%ld", (long)sectionId, (long)timestamp];
    NSURL *url = [NSURL URLWithString:urlString];
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[SectionList class] fromJSONDictionary:json error:nil];
    }];
}

/**
 软件启动splash图片
 **/
- (RACSignal *)fetchStartImage {
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat w = [screen actualResolution].width;
    NSString *resolution = (w == 1080 ? @"1080*1776" : @"720*1184");
    NSString *urlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/start-image/%@", resolution];
    NSURL *url = [NSURL URLWithString:urlString];
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *dict) {
        return [MTLJSONAdapter modelOfClass:[StartImage class] fromJSONDictionary:dict error:nil];
    }];
}

@end
