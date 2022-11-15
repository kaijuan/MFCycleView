//
//  MFPageControl.h
//  MFCycleDemo
//
//  Created by xkjuan on 2022/9/05.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 布局方向
typedef NS_ENUM(NSUInteger, MFPageControlDirection) {
    MFPageControlDirectionHorizontal = 0,
    MFPageControlDirectionVertical
};

@protocol MFPageControlDelegate;

@interface MFPageControl : UIControl
/**
 *  自定义的小圆点
 */
@property (nonatomic) Class dotViewClass;

/**
 *  普通状态小圆点图片
 */
@property (nonatomic) UIImage *dotImage;
/**
 *  高亮状态小圆点图片
 */
@property (nonatomic) UIImage *currentDotImage;
/**
 *  小圆点size 默认8 x 8
 */
@property (nonatomic) CGSize dotSize;
/**
 *  小圆点size 默认8 x 8
 */
@property (nonatomic) MFPageControlDirection pageDicrection;

/**
 *  小圆点普通颜色
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 *  小圆点高亮颜色
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 *  原点之间间距 默认8
 */
@property (nonatomic) NSInteger spacingBetweenDots;

/**
 *  设置pageControl的代理
 */
@property(nonatomic,assign) id<MFPageControlDelegate> delegate;
/**
 *  设置pageControl的页码总数 即小圆点总数
 */
@property (nonatomic) NSInteger numberOfPages;


/**
 *  当前页码
 */
@property (nonatomic) NSInteger currentPage;


/**
 *  单页时是否隐藏，默认 NO不隐藏
 */
@property (nonatomic) BOOL hidesForSinglePage;


/**
 *  是否扩大  默认 YES.
 */
@property (nonatomic) BOOL shouldResizeFromCenter;


/**
 *  返回PageControl的最小的size
 */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;


@end

@protocol MFPageControlDelegate <NSObject>

@optional
- (void)MFPageControl:(MFPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
