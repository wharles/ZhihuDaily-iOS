//
//  Stories.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/3.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Stories : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *images;
@property (strong, nonatomic) NSString *image;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *gaPrefix;
@property (strong, nonatomic) NSString *title;

@end
