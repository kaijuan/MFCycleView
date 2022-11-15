//
//  MFPageControl.m
//  MFCycleDemo
//
//  Created by xkjuan on 2022/9/05.
//

#import "MFPageControl.h"
#import "MFDotView.h"

/**
 *  默认总页数
 */
static NSInteger const kDefaultNumberOfPages = 0;

/**
 *  默认当前页码
 */
static NSInteger const kDefaultCurrentPage = 0;

/**
 *  默认 是否单页隐藏
 */
static BOOL const kDefaultHideForSinglePage = NO;

/**
 *  默认 是否居中
 */
static BOOL const kDefaultShouldResizeFromCenter = YES;

/**
 *  默认小圆点间距
 */
static NSInteger const kDefaultSpacingBetweenDots = 8;

/**
 *  默认小圆点size
 */
static CGSize const kDefaultDotSize = {8, 8};

@interface MFPageControl()
/// 小圆点集合
@property (strong, nonatomic) NSMutableArray *dots;

@end
@implementation MFPageControl

#pragma mark - Lifecycle

- (id)init{
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


/**
 *  初始化PageControl配置数据
 */
- (void)mf_initialization
{
    self.dotViewClass           = [MFDotView class];
    self.spacingBetweenDots     = kDefaultSpacingBetweenDots;
    self.numberOfPages          = kDefaultNumberOfPages;
    self.currentPage            = kDefaultCurrentPage;
    self.hidesForSinglePage     = kDefaultHideForSinglePage;
    self.shouldResizeFromCenter = kDefaultShouldResizeFromCenter;
    self.pageDicrection         = MFPageControlDirectionHorizontal;
}

#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view != self) {
        NSInteger index = [self.dots indexOfObject:touch.view];
        if ([self.delegate respondsToSelector:@selector(MFPageControl:didSelectPageAtIndex:)]) {
            [self.delegate MFPageControl:self didSelectPageAtIndex:index];
        }
    }
}

#pragma mark - Layout

- (void)sizeToFit{
    [self updateFrame:YES];
}

//居中显示并重置pageControl大小
- (void)updateFrame:(BOOL)overrideExistingFrame
{
    CGPoint center = self.center;
    CGSize requiredSize = [self sizeForNumberOfPages:self.numberOfPages];
    
    // 我们仅在授权和必要的情况下使用所需尺寸
    if (overrideExistingFrame || ((CGRectGetWidth(self.frame) < requiredSize.width || CGRectGetHeight(self.frame) < requiredSize.height) && !overrideExistingFrame)) {
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), requiredSize.width, requiredSize.height);
        if (self.shouldResizeFromCenter) {
            self.center = center;
        }
    }
    
    [self resetDotViews];
}

// 获取最小的size
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount{
    if (_pageDicrection == MFPageControlDirectionVertical) {
        return CGSizeMake(self.dotSize.width, (self.dotSize.height + self.spacingBetweenDots) * pageCount - self.spacingBetweenDots);;
    }
    return CGSizeMake((self.dotSize.width + self.spacingBetweenDots) * pageCount - self.spacingBetweenDots , self.dotSize.height);
}

/// 重置所有的点
- (void)resetDotViews
{
    for (UIView *dotView in self.dots) {
        [dotView removeFromSuperview];
    }
    
    [self.dots removeAllObjects];
    [self updateDots];
}

/// 更新并显示所有点的位置并显示高亮点
- (void)updateDots{
    if (self.numberOfPages == 0) {
        return;
    }
    
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        
        UIView *dot;
        if (i < self.dots.count) {
            dot = [self.dots objectAtIndex:i];
        } else {
            dot = [self generateDotView];
        }
        
        [self updateDotFrame:dot atIndex:i];
    }
    
    [self changeActivity:YES atIndex:self.currentPage];
    
    [self hideForSinglePage];
}

- (void)hideForSinglePage{
    if (self.dots.count == 1 && self.hidesForSinglePage) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

/// 更新特定dot的位置
- (void)updateDotFrame:(UIView *)dot atIndex:(NSInteger)index{
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    // dots一直居中
    if (_pageDicrection == MFPageControlDirectionVertical) {
        x = (CGRectGetWidth(self.frame) - self.dotSize.width) / 2;
        y = (self.dotSize.height + self.spacingBetweenDots) * index + ( (CGRectGetHeight(self.frame) - [self sizeForNumberOfPages:self.numberOfPages].height) / 2);
    }else{
        x = (self.dotSize.width + self.spacingBetweenDots) * index + ( (CGRectGetWidth(self.frame) - [self sizeForNumberOfPages:self.numberOfPages].width) / 2);
        y = (CGRectGetHeight(self.frame) - self.dotSize.height) / 2;
    }
    
    dot.frame = CGRectMake(x, y, self.dotSize.width, self.dotSize.height);
}
/// 更新当前选中dot高亮状态
- (void)changeActivity:(BOOL)active atIndex:(NSInteger)index{
    if (self.dotViewClass) {
        MFDotView *abstractDotView = (MFDotView *)[self.dots objectAtIndex:index];
        if ([abstractDotView respondsToSelector:@selector(changeActivityState:)]) {
            [abstractDotView changeActivityState:active];
        } else {
            NSLog(@"自定义 view : %@ 必须实现 'changeActivityState' 方法，或者继承 %@ 类", self.dotViewClass, [MFDotView class]);
        }
    } else if (self.dotImage && self.currentDotImage) {
        UIImageView *dotView = (UIImageView *)[self.dots objectAtIndex:index];
        dotView.image = (active) ? self.currentDotImage : self.dotImage;
    }
}

- (UIView *)generateDotView{
    UIView *dotView;
    
    if (self.dotViewClass) {
        dotView = [[self.dotViewClass alloc] initWithFrame:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height)];
        if ([dotView isKindOfClass:[MFDotView class]]) {
            if (self.pageIndicatorTintColor) {
                ((MFDotView *)dotView).pageIndicatorTintColor = self.pageIndicatorTintColor;
                ((MFDotView *)dotView).backgroundColor        = self.pageIndicatorTintColor;
            }
            if (self.currentPageIndicatorTintColor) {
                ((MFDotView *)dotView).currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
            }
        }
    } else {
        dotView = [[UIImageView alloc] initWithImage:self.dotImage];
        dotView.frame = CGRectMake(0, 0, self.dotSize.width, self.dotSize.height);
    }
    
    if (dotView) {
        [self addSubview:dotView];
        [self.dots addObject:dotView];
    }
    
    dotView.userInteractionEnabled = YES;
    return dotView;
}

#pragma mark -

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    
    //重置更新并显示
    [self resetDotViews];
}

- (void)setSpacingBetweenDots:(NSInteger)spacingBetweenDots{
    _spacingBetweenDots = spacingBetweenDots;
    
    [self resetDotViews];
}

- (void)setPageDicrection:(MFPageControlDirection)pageDicrection{
    _pageDicrection = pageDicrection;
    
    [self resetDotViews];
}

///
- (void)setCurrentPage:(NSInteger)currentPage{
    //第一页或当前页 不需要刷新显示
    if (self.numberOfPages == 0 || currentPage == _currentPage) {
        _currentPage = currentPage;
        return;
    }
    
    //之前选中的点改为非选中
    [self changeActivity:NO atIndex:_currentPage];
    _currentPage = currentPage;
    
    //选中后更新颜色
    [self changeActivity:YES atIndex:_currentPage];
}

- (void)setDotImage:(UIImage *)dotImage{
    _dotImage = dotImage;
    [self resetDotViews];
    _dotViewClass = nil;
}

- (void)setCurrentDotImage:(UIImage *)currentDotImage{
    _currentDotImage = currentDotImage;
    [self resetDotViews];
    _dotViewClass = nil;
}

- (void)setDotViewClass:(Class)dotViewClass{
    _dotViewClass = dotViewClass;
    self.dotSize = CGSizeZero;
    [self resetDotViews];
}

#pragma mark - Getters
- (NSMutableArray *)dots{
    if (!_dots) {
        _dots = [[NSMutableArray alloc] init];
    }
    return _dots;
}

- (CGSize)dotSize{
    if (self.dotImage && CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        _dotSize = self.dotImage.size;
    } else if (self.dotViewClass && CGSizeEqualToSize(_dotSize, CGSizeZero)) {
        _dotSize = kDefaultDotSize;
    }
    return _dotSize;
}

@end
