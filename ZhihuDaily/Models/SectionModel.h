//
//  SectionModel.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/9.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SectionModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *images;
@property (assign, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *displayDate;
@property (strong, nonatomic) NSString *title;

@end

@interface SectionList : MTLModel<MTLJSONSerializing>

@property (assign, nonatomic) NSInteger timestamp;
@property (strong, nonatomic) NSArray *stories;
@property (strong, nonatomic) NSString *name;

@end