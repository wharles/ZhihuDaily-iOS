//
//  HttpClient.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface HttpClient : NSObject

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchLatestNews;
- (RACSignal *)fetchThemes;
- (RACSignal *)fetchSections;
- (RACSignal *)fetchHots;

- (RACSignal *)fetchNewsContentWithId:(NSInteger)newsId;
- (RACSignal *)fetchThemeListWithId:(NSInteger)themeId;
- (RACSignal *)fetchSectionListWithId:(NSInteger)sectionId timestamp:(NSInteger)timestamp;

- (RACSignal *)fetchStartImage;

- (RACSignal *)fetchBeforeNewsWithDate:(NSInteger)dateNum;

@end
