//
//  CarouselScrollView.h
//  ZhihuDaily
//
//  Created by Koudai on 15/12/4.
//  Copyright © 2015年 Charlies Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CarouselScrollViewPageControlAlimentRight,
    CarouselScrollViewPageControlAlimentCenter
} CarouselScrollViewPageControlAliment;

typedef enum {
    CarouselScrollViewPageControlStyleClassic,
    CarouselScrollViewPageControlStyleAnimated,
    CarouselScrollViewPageControlStyleNone
} CarouselScrollViewPageControlStyle;

@class CarouselScrollView;

@protocol CarouselScrollViewDelegate <NSObject>

- (void)carouselScrollView:(CarouselScrollView*)carouselScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface CarouselScrollView : UIView

// 本地图片数组
@property (nonatomic, strong) NSArray *localizationImagesGroup;

// 网络图片 url string 数组
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

// 每张图片对应要显示的文字数组
@property (nonatomic, strong) NSArray *titlesGroup;

//自动滚动时间间隔，默认2s
@property (assign,nonatomic)CGFloat autoScrollTimeInterval;
//是否无限循环，默认YES
@property (assign,nonatomic)BOOL infiniteLoop;
//是否默认滚动，默认YES
@property (assign,nonatomic)BOOL autoScroll;

@property (weak,nonatomic)id<CarouselScrollViewDelegate> delegate;

//是否显示分页控件
@property (assign,nonatomic)BOOL showPageControl;
//是否只有一张图片时隐藏pageControl，默认YES
@property (assign,nonatomic)BOOL hidesForSinglePage;
//pagecontrol 样式，默认为动画样式
@property (assign,nonatomic)CarouselScrollViewPageControlStyle pageControlStyle;
//默认图片
@property (strong,nonatomic)UIImage* placeholderImage;
//分页控件位置
@property (assign,nonatomic)CarouselScrollViewPageControlAliment pageControlAliment;
// 分页控件小圆标大小
@property (assign,nonatomic)CGSize pageControlDotSize;

// 分页控件小圆标颜色
@property (strong,nonatomic)UIColor* dotColor;

@property (strong,nonatomic)UIColor* titleLabelTextColor;
@property (strong,nonatomic)UIFont* titleLabelTextFont;
@property (strong,nonatomic)UIColor* titleLabelBackgroundColor;
@property (assign,nonatomic)CGFloat titleLabelHeight;

+ (instancetype)carouselScrollViewWithFrame:(CGRect)frame imagesGroup:(NSArray *)imagesGroup;
+ (instancetype)carouselScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLStringsGroup;

@end
