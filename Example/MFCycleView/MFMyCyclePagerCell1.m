//
//  MFMyCyclePagerCell1.m
//  MFCycleDemo
//
//  Created by xkjuan on 2022/9/13.
//

#import "MFMyCyclePagerCell1.h"

@interface MFMyCyclePagerCell1 ()

@property (nonatomic, strong, readwrite) UILabel *itemLabel;

@end

@implementation MFMyCyclePagerCell1

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2];
        self.contentView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
        
        [self.contentView addSubview:self.itemLabel];
        
        self.itemLabel.text = @"默认类型1";
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.itemLabel.frame = CGRectMake(10, 10, self.contentView.bounds.size.width - 20, self.contentView.bounds.size.height - 20);
}

- (UILabel *)itemLabel{
    if (!_itemLabel) {
        _itemLabel = [UILabel new];
        _itemLabel.textColor = UIColor.whiteColor;
        _itemLabel.numberOfLines = 0;
        _itemLabel.font = [UIFont systemFontOfSize:28];
    }
    return _itemLabel;
}

@end

@interface MFMyCyclePagerCell2 ()

@property (nonatomic, strong, readwrite) UILabel *itemLabel;

@end

@implementation MFMyCyclePagerCell2

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.2];
        self.contentView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        
        [self.contentView addSubview:self.itemLabel];
        
        self.itemLabel.text = @"默认类型1";
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.itemLabel.frame = CGRectMake(10, 10, self.contentView.bounds.size.width - 20, self.contentView.bounds.size.height - 20);
}

- (UILabel *)itemLabel{
    if (!_itemLabel) {
        _itemLabel = [UILabel new];
        _itemLabel.textColor = UIColor.whiteColor;
        _itemLabel.numberOfLines = 0;
        _itemLabel.font = [UIFont systemFontOfSize:28];
    }
    return _itemLabel;
}

@end
