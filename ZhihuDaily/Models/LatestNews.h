//
//  LatestNews.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "Stories.h"

@interface LatestNews : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSArray *stories;
@property (strong, nonatomic) NSArray *topStories;

@end
