//
//  MFCyclePagerView.m
//  MFCycleDemo
//
//  Created by xkjuan on 2022/7/11.
//

#import "MFCyclePagerView.h"
#import "MFPageControl.h"
#import "MFCyclePagerBaseCell.h"

@interface MFCyclePagerView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout  *layout;

@property (nonatomic, assign) BOOL didReloadData;

@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) MFPageControl *pageControl;

@property (nonatomic, assign) BOOL isScrolling;

@end

@implementation MFCyclePagerView

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self removeTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self mf_initialization];
        [self mf_configMainUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self mf_initialization];
    [self mf_configMainUI];
}

- (void)mf_initialization{
    _autoScrollInterval = 3;
    _autoAnimateInterval = 0.35;
    _scrollDirection = MFCycleScrollDirectionHorizontal;
    _infiniteLoop = YES;
    _pageSpacingWidth = 0.000001f;
    _showPageControl = YES;
    _autoScroll = YES;
    _hidesForSinglePage = YES;
    _scrollOneEveryTime = NO;
    _insetWidth = 0;
}

- (void)mf_configMainUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _layout = layout;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.scrollsToTop = YES;
    [_collectionView registerClass:[MFCyclePagerBaseCell class] forCellWithReuseIdentifier:NSStringFromClass([MFCyclePagerBaseCell class])];
    [self addSubview:_collectionView];
}

- (void)mf_configPageControlUI{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整

    if (self.dataArr.count == 0) return;

    if ((self.dataArr.count == 1) && self.hidesForSinglePage) return;

    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:0];

    NSLog(@"indexOnPageControl:%d",indexOnPageControl);

    MFPageControl *pageControl = [[MFPageControl alloc] init];
    pageControl.numberOfPages = self.dataArr.count;
    pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = indexOnPageControl;
    if (_scrollDirection == MFCycleScrollDirectionHorizontal) {
        pageControl.pageDicrection = MFPageControlDirectionHorizontal;
    }else{
        pageControl.pageDicrection = MFPageControlDirectionVertical;
    }
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % MAX(self.dataArr.count, 1);
}

- (void)registerClass:(Class)Class{
    [_collectionView registerClass:Class forCellWithReuseIdentifier:NSStringFromClass(Class)];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _collectionView.frame = self.bounds;
    
    if (_scrollDirection == MFCycleScrollDirectionHorizontal){
        _layout.itemSize = CGSizeMake(self.collectionView.bounds.size.width - _insetWidth * 2, self.collectionView.bounds.size.height);
    }else{
        _layout.itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height - _insetWidth * 2);
    }
    
    if (_collectionView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    if (self.pageControl.pageDicrection == MFPageControlDirectionVertical) {
        self.pageControl.frame = CGRectMake(self.bounds.size.width - 30, 0, 30, self.bounds.size.height);
    }else{
        self.pageControl.frame = CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30);
    }

    if ([self.pageControl isKindOfClass:[MFPageControl class]]) {
        MFPageControl *pageControl = (MFPageControl *)_pageControl;
        [pageControl sizeToFit];
        self.pageControl.hidden = !_showPageControl;
    }
}

#pragma mark - set interface
- (void)setDataArr:(NSArray *)dataArr{
    
    [self removeTimer];
    
    _dataArr = dataArr;
    
    _totalItemsCount = self.infiniteLoop ? dataArr.count * 200 : dataArr.count;
    
    if (_dataArr.count>1) {
        self.collectionView.scrollEnabled = YES;
        [self addTimer];
    }else{
        self.collectionView.scrollEnabled = NO;
    }
    
    [self mf_configPageControlUI];
    
    [self.collectionView reloadData];
}

- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self removeTimer];
    
    if (_autoScroll) {
        [self addTimer];
    }
}

- (void)setScrollOneEveryTime:(BOOL)scrollOneEveryTime{
    _scrollOneEveryTime = scrollOneEveryTime;
    
    self.collectionView.pagingEnabled = scrollOneEveryTime;
}

- (void)setInsetWidth:(CGFloat)insetWidth{
    _insetWidth = insetWidth;
    
    if (_scrollDirection == MFCycleScrollDirectionHorizontal) {
        _collectionView.contentInset = UIEdgeInsetsMake(0, insetWidth, 0, insetWidth);
    }else{
        _collectionView.contentInset = UIEdgeInsetsMake(insetWidth*10, 0, insetWidth, 0);
    }
    
    [self.collectionView reloadData];
}

- (void)setPageSpacingWidth:(CGFloat)pageSpacingWidth{
    _pageSpacingWidth = pageSpacingWidth;
    
    [self.collectionView reloadData];
}

- (void)setScrollDirection:(MFCycleScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    
    if (scrollDirection == MFCycleScrollDirectionHorizontal) {
        if (_layout){
            _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        }
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, _insetWidth, 0, _insetWidth);
        
        if (_pageControl) {
            _pageControl.pageDicrection = MFPageControlDirectionHorizontal;
        }
    }else{
        if (_layout){
            _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        }
        
        _collectionView.contentInset = UIEdgeInsetsMake(_insetWidth, 0, _insetWidth, 0);
        
        if (_pageControl) {
            _pageControl.pageDicrection = MFPageControlDirectionVertical;
        }
    }
}

- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;

    self.pageControl.hidden = !showPageControl;
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize{
    _pageControlDotSize = pageControlDotSize;
    [self mf_configPageControlUI];
    
    if ([self.pageControl isKindOfClass:[MFPageControl class]]) {
        MFPageControl *pageContol = (MFPageControl *)_pageControl;
        pageContol.dotSize = pageControlDotSize;
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;

    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;

    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

#pragma mark - Delegate
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return _totalItemsCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerView:cellForItemAtIndex:)]) {
        return [self.delegate pagerView:self cellForItemAtIndex:itemIndex];
    }
    
    MFCyclePagerBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MFCyclePagerBaseCell class]) forIndexPath:indexPath];
    
    id model = [self.dataArr objectAtIndex:itemIndex];
    if ([model isKindOfClass:[NSString class]]) {
        cell.imgView.image = self.placeholderImage;
    }else if ([model isKindOfClass:[UIImage class]]){
        cell.imgView.image = model;
    }else{
        cell.imgView.image = nil;
    }
    return cell;
}

////设置每个item的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(self.collectionView.bounds.size.width-self.contentInset.left - self.contentInset.right, self.collectionView.bounds.size.height-self.contentInset.top - self.contentInset.bottom);
//}
//
////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsZero;
//}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return _pageSpacingWidth;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return _pageSpacingWidth;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(cyclePagerView:didSelectItemAtIndex:)]) {
        [self.delegate cyclePagerView:self didSelectItemAtIndex:itemIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (!self.dataArr.count) return; // 解决清除timer时偶尔会出现的问题
    NSInteger currentIndex = [self mf_currentPageIndex];
    int itemIndex = [self pageControlIndexWithCurrentCellIndex:currentIndex];
    
    if ([self.delegate respondsToSelector:@selector(cyclePagerView:didScrollToIndex:)]) {
        [self.delegate cyclePagerView:self didScrollToIndex:itemIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isScrolling = NO;
    if (_autoScroll) {
        [self removeTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"--%s:(%.2f, %.2f)--",__func__,self.collectionView.contentOffset.x,self.collectionView.contentOffset.y);
    if (!self.dataArr.count) return; // 解决清除timer时偶尔会出现的问题
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"--%s:(%.2f, %.2f)--tracking:%d",__func__,self.collectionView.contentOffset.x,self.collectionView.contentOffset.y,self.tracking);
    
    if (!self.tracking) {
        return;
    }
    
    if (_isScrolling) return;
    _isScrolling = YES;

    if (self.autoScroll) {
        [self addTimer];
    }

    NSInteger currentIndex = [self mf_currentPageIndex];
    [self scrollToCurrentIndex:currentIndex anition:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"--%s:(%.2f, %.2f)--tracking:%d",__func__,self.collectionView.contentOffset.x,self.collectionView.contentOffset.y,self.tracking);
    
    if (self.tracking) {
        return;
    }
    
    if (_isScrolling) return;
    _isScrolling = YES;
    
    if (self.autoScroll) {
        [self addTimer];
    }
    
    NSInteger currentIndex = [self mf_currentPageIndex];
    [self scrollToCurrentIndex:currentIndex anition:NO];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithClass:(Class)Class forIndex:(NSInteger)index; {
    return [_collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(Class) forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

//获取当前位置
- (NSInteger)mf_currentPageIndex{
    NSInteger index = 0;
    
    if (_scrollDirection == MFCycleScrollDirectionHorizontal) {
        
        CGFloat withItem = self.collectionView.frame.size.width - self.insetWidth * 2 + self.pageSpacingWidth;
        CGFloat offWidth = _scrollOneEveryTime ? -withItem/10 : withItem/10;
        
        index = (NSInteger)(self.collectionView.contentOffset.x - offWidth)/withItem + 1;
    }else{
        CGFloat highItem = self.collectionView.frame.size.height - self.insetWidth * 2 + self.pageSpacingWidth;
        CGFloat offHeight = _scrollOneEveryTime ? highItem/2 : highItem/10;
        
        index = (NSInteger)(self.collectionView.contentOffset.y - offHeight)/highItem+1;
    }
    return MAX(0, index);
}

#pragma mark - timer

- (void)addTimer {
    if (_timer || _autoScrollInterval <= 0) {
        return;
    }
    _timer = [NSTimer timerWithTimeInterval:_autoScrollInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (!_timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)timerFired{
    NSLog(@"--%s:(%.2f, %.2f)--tracking:%d",__func__,self.collectionView.contentOffset.x,self.collectionView.contentOffset.y,self.tracking);
    
    if (!self.superview || !self.window || self.dataArr.count == 0 || self.tracking) {
        return;
    }
    
    if (![self.collectionView visibleCells].count) {
        return;
    }
    
    NSInteger currentIndex = [self mf_currentPageIndex];
    NSLog(@"%zd",currentIndex);
    currentIndex = currentIndex + 1;
    
    [self scrollToCurrentIndex:currentIndex anition:YES];
}

- (void)scrollToCurrentIndex:(NSInteger)targetIndex anition:(BOOL)animation{
    
    CGFloat duration = animation ? _autoAnimateInterval : 0.1;
    if (targetIndex >= _totalItemsCount){
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            duration = 0;
        }else{
            targetIndex = MAX(0, _totalItemsCount - 1);
        }
    }
    
    [UIView animateWithDuration:duration animations:^{
        if (self.scrollOneEveryTime) {
            if (self->_scrollDirection == MFCycleScrollDirectionHorizontal) {
                self.collectionView.contentOffset = CGPointMake((self.frame.size.width - self.insetWidth * 2 + self.pageSpacingWidth) * targetIndex - self.insetWidth,0);
            }else{
                self.collectionView.contentOffset = CGPointMake(0, (self.frame.size.height - self.insetWidth * 2 + self.pageSpacingWidth) * targetIndex - self.insetWidth);
            }
        }
        
    } completion:^(BOOL finished) {
        self.isScrolling = NO;
    }];
    
    if (!self.scrollOneEveryTime) {
        if (duration) {
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }else{
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }
    
    self.pageControl.currentPage = targetIndex % MAX(1, self.dataArr.count);
}

- (BOOL)tracking {
    return _collectionView.tracking;
}

@end
