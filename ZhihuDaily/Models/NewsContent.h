//
//  NewsContent.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NewsContent : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *imageSource;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *shareURL;
@property (strong, nonatomic) NSArray *js;
@property (strong, nonatomic) NSString *gaPrefix;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSArray *css;

@end
