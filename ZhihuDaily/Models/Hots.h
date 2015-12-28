//
//  Hots.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/7.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Hots : MTLModel<MTLJSONSerializing>

@property (assign, nonatomic) NSInteger newsId;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *title;

@end
