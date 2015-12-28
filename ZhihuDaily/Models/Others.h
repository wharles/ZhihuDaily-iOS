//
//  Others.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/4.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mantle/Mantle.h>

@interface Others : MTLModel<MTLJSONSerializing>

@property (assign, nonatomic) NSInteger color;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *desc;
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *name;

@end
