//
//  SVPayView.m
//  SAVI
//
//  Created by Sorgle on 2017/12/11.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVPayView.h"

@interface SVPayView ()



@end

@implementation SVPayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.colorView = [[UIView alloc]init];
        [self addSubview:self.colorView];
        
        self.paylabel = [[UILabel alloc]init];
        self.paylabel.textColor = GlobalFontColor;
        self.paylabel.font = [UIFont systemFontOfSize:12];
        self.paylabel.textAlignment = NSTextAlignmentLeft;
        self.paylabel.adjustsFontSizeToFitWidth = YES;
        self.paylabel.minimumScaleFactor = 0.5;
        [self addSubview:self.paylabel];
        
        self.yuanlabel = [[UILabel alloc]init];
        self.yuanlabel.text = @"元";
        self.yuanlabel.textColor = RGBA(182, 182, 182, 1);
        self.yuanlabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.yuanlabel];
        
        self.moneylabel = [[UILabel alloc]init];
        self.moneylabel.textColor = RedFontColor;
        self.moneylabel.font = [UIFont systemFontOfSize:15];
        self.moneylabel.textAlignment = NSTextAlignmentRight;
        self.moneylabel.adjustsFontSizeToFitWidth = YES;
        self.moneylabel.minimumScaleFactor = 0.5;
        [self addSubview:self.moneylabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    
    //确定子控件的frame (这里得到的self的frame/bounds才是准确的)
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
//    self.colorView.frame = CGRectMake(0, 5, 5, 5);
//    self.paylabel.frame = CGRectMake(5, 0, (width - 10)/3, height);
//    self.moneylabel.frame = CGRectMake(5 + (width - 10)/3, 0, (width - 10)/3*2, height);
//    self.yuanlabel.frame = CGRectMake(width - 5, height - 5, 5, 5);
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9, 9));
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self);
    }];
    
    [self.paylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, height));
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.colorView.mas_right).offset(6);
    }];
    
    [self.yuanlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width-15-65-30, height));
        //make.left.mas_equalTo(self.paylabel.mas_right);
        make.right.mas_equalTo(self.yuanlabel.mas_left).offset(-3);
        make.centerY.mas_equalTo(self);
    }];
    
}


@end
