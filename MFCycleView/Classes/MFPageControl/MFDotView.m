//
//  MFDotView.m
//  MFCycleDemo
//
//  Created by xkjuan on 2022/9/05.
//

#import "MFDotView.h"

static CGFloat const jkAnimationDuration = 1;

@implementation MFDotView

#pragma mark - Lifecycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self mf_initialization];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self mf_initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self mf_initialization];
    }
    
    return self;
}

- (void)mf_initialization{
    _currentPageIndicatorTintColor  = [UIColor whiteColor];
    _pageIndicatorTintColor         = [UIColor colorWithWhite:1 alpha:0.1];
    
    self.layer.cornerRadius         = CGRectGetWidth(self.frame) / 2;
}

//转变状态
- (void)changeActivityState:(BOOL)active{
    if (active) {
        [self animateToActiveState];
    } else {
        [self animateToDisactiveState];
    }
}


- (void)animateToActiveState{
    [UIView animateWithDuration:jkAnimationDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = self->_currentPageIndicatorTintColor;
        self.transform = CGAffineTransformMakeScale(1.4, 1.4);
    } completion:nil];
}

- (void)animateToDisactiveState{
    [UIView animateWithDuration:jkAnimationDuration delay:0 usingSpringWithDamping:.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = self->_pageIndicatorTintColor;
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
