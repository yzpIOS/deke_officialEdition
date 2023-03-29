//
//  SVSpendingDetailView.m
//  SAVI
//
//  Created by Sorgle on 2017/9/26.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSpendingDetailView.h"

@interface SVSpendingDetailView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation SVSpendingDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //线view
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = RGBA(223, 223, 223, 1);
        [self addSubview:self.lineView];
        
        self.colorView = [[UIView alloc]init];
        self.colorView.layer.cornerRadius = 1;
        self.colorView.backgroundColor = [UIColor redColor];
        [self addSubview:self.colorView];
        //
        self.payClasslabel = [[UILabel alloc]init];
//        self.payClasslabel.text = @"支付";
        self.payClasslabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.payClasslabel];
        
        self.ratiolabel = [[UILabel alloc]init];
        self.ratiolabel.textAlignment = NSTextAlignmentCenter;
//        self.ratiolabel.text = @"100%";
        self.ratiolabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.ratiolabel];
        
        self.moneylabel = [[UILabel alloc]init];
        self.moneylabel.textAlignment = NSTextAlignmentRight;
//        self.moneylabel.text = @"250";
        self.moneylabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.moneylabel];
        
    }
    return self;
}


- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    CGFloat width = self.bounds.size.width;
    //CGFloat height = self.bounds.size.height;
    
    self.lineView.frame = CGRectMake(0, 49, width, 1);
    self.colorView.frame = CGRectMake(20, 20, 10, 10);
    self.payClasslabel.frame = CGRectMake(50, 10, (width-50)/3, 30);
    self.ratiolabel.frame = CGRectMake(50+(width-50)/3, 10, (width-50)/3, 30);
    self.moneylabel.frame = CGRectMake(50+(width-50)/3*2, 10, (width-50)/3-20, 30);
    
}




@end
