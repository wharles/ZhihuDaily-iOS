//
//  StartImage.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/15.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface StartImage : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *img;

@end
