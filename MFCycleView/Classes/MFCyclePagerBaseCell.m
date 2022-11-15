//
//  MFCyclePagerBaseCell.m
//  MFCycleDemo
//
//  Created by xkjuan on 2022/9/6.
//

#import "MFCyclePagerBaseCell.h"

@interface MFCyclePagerBaseCell ()

@property(strong,nonatomic,readwrite)UIImageView          *imgView;

@end

@implementation MFCyclePagerBaseCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =  [super initWithFrame:frame]) {
        
        self.backgroundColor = self.contentView.backgroundColor = UIColor.clearColor;
        
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imgView.frame = self.contentView.bounds;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

@end
