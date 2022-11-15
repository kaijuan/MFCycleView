//
//  MFCyclePagerView.h
//  MFCycleDemo
//
//  Created by xkjuan on 2022/7/11.
//

#import <UIKit/UIKit.h>
#import "MFCyclePagerBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

/// 滚动方向
typedef NS_ENUM(NSUInteger, MFCycleScrollDirection) {
    MFCycleScrollDirectionHorizontal,
    MFCycleScrollDirectionVertical
};

@class MFCyclePagerView;
@protocol MFCyclePagerViewDelegate <NSObject>

- (NSInteger)numberOfItemsInPagerView:(MFCyclePagerView *)pageView;

- (__kindof UICollectionViewCell *)pagerView:(MFCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index;

@optional
/** 点击图片回调 */
- (void)cyclePagerView:(MFCyclePagerView *)cyclePagerView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cyclePagerView:(MFCyclePagerView *)cyclePagerView didScrollToIndex:(NSInteger)index;

@end

@interface MFCyclePagerView : UIView

@property (nonatomic, weak) id <MFCyclePagerViewDelegate> delegate;

@property (nonatomic, strong) NSArray                   *dataArr;
/** 默认图片 */
@property (nonatomic, strong) UIImage                   *placeholderImage;
/** 自动滚动间隔时间, 默认3s */
@property (nonatomic, assign) CGFloat                   autoScrollInterval;
/** 自动滚动时间, 默认0.35s */
@property (nonatomic, assign) CGFloat                   autoAnimateInterval;
/** 是否自动滚动,默认Yes */
@property (nonatomic, assign) BOOL                      autoScroll;
/** 是否无限循环,默认Yes */
@property (nonatomic, assign) BOOL                      infiniteLoop;
/** 是否每次滚动一个,默认NO */
@property (nonatomic, assign) BOOL                      scrollOneEveryTime;
/** 自动滚动方向, 默认横向 */
@property (nonatomic, assign) MFCycleScrollDirection    scrollDirection;

@property (nonatomic)         CGFloat                   insetWidth;

@property (nonatomic, assign) CGFloat                   pageSpacingWidth;


/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL                      showPageControl;
/** 是否在只有一条数据时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL                               hidesForSinglePage;
/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize                    pageControlDotSize;

// indicatorTint color
@property (nonatomic, strong, nullable) UIColor         *pageIndicatorTintColor;
@property (nonatomic, strong, nullable) UIColor         *currentPageIndicatorTintColor;

- (void)registerClass:(Class)Class;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithClass:(Class)Class forIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
