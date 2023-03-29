//
//  SVRankingsView.m
//  SAVI
//
//  Created by Sorgle on 2017/12/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVRankingsView.h"

@interface SVRankingsView ()

@property (nonatomic, strong) UIView *namberView;

@end

@implementation SVRankingsView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.namelabel = [[UILabel alloc]init];
        self.namelabel.textColor = GlobalFontColor;
        self.namelabel.font = [UIFont systemFontOfSize:12];
        
        self.colorView = [[UIView alloc]init];
        self.colorView.backgroundColor = navigationBackgroundColor;

        self.moneylabel = [[UILabel alloc]init];
        self.moneylabel.textColor = GlobalFontColor;
        self.moneylabel.font = [UIFont systemFontOfSize:13];
        
        self.namberView = [[UIView alloc]init];
        self.namberView.backgroundColor = RGBA(139, 195, 47, 1);
        self.namberView.layer.cornerRadius = 10;
        
        self.taglabel = [[UILabel alloc]init];
        self.taglabel.text = [NSString stringWithFormat:@"%ld",(long)self.tag];
        self.taglabel.textColor = [UIColor whiteColor];
        self.taglabel.font = [UIFont systemFontOfSize:12];
        self.taglabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.namelabel];
        [self addSubview:self.colorView];
        [self addSubview:self.moneylabel];
        [self addSubview:self.namberView];
        [self.namberView addSubview:self.taglabel];
        
    }
    return self;
}

-(void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    
    //确定子控件的frame (这里得到的self的frame/bounds才是准确的)
    //CGFloat width = self.bounds.size.width;
    //CGFloat height = self.bounds.size.height;
    
    
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.height.mas_equalTo(13);
        make.left.mas_equalTo(self).with.offset(60);
        make.top.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-30);
    }];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 22));
        make.left.mas_equalTo(self.namelabel.mas_left);
        make.top.mas_equalTo(self.namelabel.mas_bottom).offset(3);
    }];

    
//    self.colorView.layer.cornerRadius = 11;
//    self.colorView.layer.masksToBounds = YES;

    [self.moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.mas_equalTo(self.colorView.mas_centerY);
        make.top.mas_equalTo(self.namelabel.mas_bottom).offset(6);
        make.left.mas_equalTo(self.colorView.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-16);
    }];
    
    [self.namberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(self.moneylabel.mas_centerY);
        make.right.mas_equalTo(self.colorView.mas_left).offset(-10);
    }];
    
    [self.taglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.center.mas_equalTo(self.namberView);
    }];
    
    
}

@end
