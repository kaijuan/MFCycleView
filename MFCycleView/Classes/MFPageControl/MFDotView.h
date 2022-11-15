//
//  MFDotView.h
//  MFCycleDemo
//
//  Created by xkjuan on 2022/9/05.
//

#import "MFAbstractDotView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFDotView : MFAbstractDotView

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

@end

NS_ASSUME_NONNULL_END
