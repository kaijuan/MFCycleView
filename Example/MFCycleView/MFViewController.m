//
//  MFViewController.m
//  MFCycleView
//
//  Created by XiaoDuo on 11/15/2022.
//  Copyright (c) 2022 XiaoDuo. All rights reserved.
//

#import "MFViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface MFViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // 1、每次滑动一个 滑动多个
    // 2、默认显示图片。url图片和本地图片 （优先级最高）
    // 3、左拉右拉刷新
    // 4、cycleView和pageControl pod的时候分开
    // 5、cycleView代理添加滑动接口
    // 6、应用到X1项目
    // 7、周末发到git、下周发布文档
    // 8、边距contentInset 上下和左右分开
    // 9、spacingAtItemsInPagerView代理改为属性使用
    
    
    self.title = @"主界面";
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = UIColor.whiteColor;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"水平方向%@页",indexPath.row == 0 ? @"一" : @"多"];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"垂直方向%@页",indexPath.row == 0 ? @"一" : @"多"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        FirstViewController *vc = [[FirstViewController alloc] init];
        vc.scrollOneEveryTime = indexPath.row==0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        SecondViewController *vc = [[SecondViewController alloc] init];
        vc.scrollOneEveryTime = indexPath.row==0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    return _tableView;
}

-(UIStatusBarStyle)preferredStatusBarStyle{

    if (@available(iOS 13.0, *)){
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return UIStatusBarStyleDarkContent;
        }
    }
    return UIStatusBarStyleDefault;
}

@end
