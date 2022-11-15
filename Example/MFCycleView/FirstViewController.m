//
//  FirstViewController.m
//  MFCycleDemo
//
//  Created by xkjuan on 2022/9/13.
//

#import "FirstViewController.h"
#import "MFCyclePagerView.h"
#import "MFMyCyclePagerCell1.h"

@interface FirstViewController ()<MFCyclePagerViewDelegate>

@property (nonatomic, strong) MFCyclePagerView *bannerView;

@property (nonatomic, strong) NSArray           *dataArr;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"水平";
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bannerView];
    
    [self.bannerView registerClass:[MFMyCyclePagerCell1 class]];
    [self.bannerView registerClass:[MFMyCyclePagerCell2 class]];
    
    NSMutableArray *tmpList = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        [tmpList addObject:@(i)];
    }
    self.bannerView.dataArr = self.dataArr = tmpList.copy;
    
    //1、滚动动画
    //2、无限循环
    //3、自适应高度（先不做）、停留时间autoScrollInterval、多行显示、
    //4、pageControl拓展
    //5、cell留白间距
    //6、
    
    //写一个类似Z2声音专区的cell
    
    NSLog(@"controller view :(%.2f, %.2f)",self.view.bounds.size.width,self.view.bounds.size.height);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.bannerView.frame = CGRectMake(10, 100 , self.view.bounds.size.width - 20, self.view.bounds.size.height - 250);
}

#pragma mark - MFCyclePagerViewDelegate

- (__kindof UICollectionViewCell *)pagerView:(MFCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index{
    if (index%2 == 0) {
        MFMyCyclePagerCell1 *cell = [pagerView dequeueReusableCellWithClass:[MFMyCyclePagerCell1 class] forIndex:index];
        NSNumber *numObj = [self.dataArr objectAtIndex:index];
        cell.imgView.image = nil;
        if (numObj) {
            cell.itemLabel.text = [NSString stringWithFormat:@"默认类型1的第%zd行",index];
        }else{
            cell.itemLabel.text = nil;
        }
        return cell;
    }
    
    MFMyCyclePagerCell2 *cell = [pagerView dequeueReusableCellWithClass:[MFMyCyclePagerCell2 class] forIndex:index];
    NSNumber *numObj = [self.dataArr objectAtIndex:index];
    cell.imgView.image = nil;
    if (numObj) {
        cell.itemLabel.text = [NSString stringWithFormat:@"默认类型2的第%zd行",index];
    }else{
        cell.itemLabel.text = nil;
    }
    return cell;
}

- (NSInteger)numberOfItemsInPagerView:(id)pageView{
    return self.dataArr.count;
}

- (void)cyclePagerView:(MFCyclePagerView *)cyclePagerView didSelectItemAtIndex:(NSInteger)index{
    
}

#pragma mark - lazy

- (MFCyclePagerView *)bannerView{
    if (!_bannerView) {
         CGRect frame = CGRectMake(10, 100 , self.view.bounds.size.width - 20, self.view.bounds.size.height - 250);
        _bannerView = [[MFCyclePagerView alloc] initWithFrame:frame];
        _bannerView.delegate = self;
        _bannerView.backgroundColor = UIColor.lightGrayColor;
        _bannerView.autoScrollInterval = 3;
        _bannerView.autoAnimateInterval = 0.25;
        _bannerView.pageSpacingWidth = 20;
        _bannerView.insetWidth = 35;
        _bannerView.scrollOneEveryTime = _scrollOneEveryTime;
        _bannerView.scrollDirection = MFCycleScrollDirectionHorizontal;
        _bannerView.showPageControl = YES;
        _bannerView.currentPageIndicatorTintColor = UIColor.orangeColor;
        _bannerView.pageIndicatorTintColor = UIColor.whiteColor;
        _bannerView.infiniteLoop = YES;
    }
    return _bannerView;
}

@end
