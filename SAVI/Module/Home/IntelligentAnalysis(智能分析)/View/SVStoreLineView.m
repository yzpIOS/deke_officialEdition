//
//  SVStoreLineView.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/30.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVStoreLineView.h"

@implementation SVStoreLineView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.namelabel = [[UILabel alloc]init];
        self.namelabel.textColor = GlobalFontColor;
        self.namelabel.font = [UIFont systemFontOfSize:12];
        self.namelabel.frame = CGRectMake(0, 0, 300, 15);
        
        // 颜色条
        self.colorView = [[UIView alloc]init];
        self.colorView.backgroundColor = navigationBackgroundColor;
        self.colorView.frame = CGRectMake(0, CGRectGetMaxY(self.namelabel.frame) + 3, 0, 15);
        self.colorView.layer.cornerRadius = 7.5;
        self.colorView.layer.masksToBounds = YES;
        
        // 钱
        self.moneylabel = [[UILabel alloc]init];
        self.moneylabel.textColor = GlobalFontColor;
         UIFont *fnt = [UIFont systemFontOfSize:12];
       // self.moneylabel.textColor= [UIColor colorWithHexString:@"666666"];
        self.moneylabel.font = fnt;
        // 根据字体得到NSString的尺寸
        CGSize sizeThree = [self.moneylabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        // 名字的H
        CGFloat nameHThree = sizeThree.height;
        // 名字的W
        CGFloat nameWThree = sizeThree.width;
       self.moneylabel.frame = CGRectMake(CGRectGetMaxX(self.colorView.frame) + 10, 25, nameWThree, nameHThree);

        
        //排行数
        self.taglabel = [[UILabel alloc]init];
      //  self.taglabel.text = [NSString stringWithFormat:@"%ld",(long)self.tag];
        self.taglabel.textColor = GlobalFontColor;
        self.taglabel.font = [UIFont systemFontOfSize:12];
        self.taglabel.textAlignment = NSTextAlignmentCenter;
        self.taglabel.font = fnt;
        CGSize sizeThree2 = [self.taglabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
        // 名字的H
        CGFloat nameHThree2 = sizeThree2.height;
        // 名字的W
        CGFloat nameWThree2 = sizeThree2.width;
        
         self.taglabel.frame = CGRectMake(CGRectGetMaxX(self.moneylabel.frame) +10, 0, nameWThree2, nameHThree2);
        self.taglabel.centerY = self.moneylabel.centerY;
        
       // 底部内容
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.textColor = GlobalFontColor;
       self.contentLabel.font = fnt;
        self.contentLabel.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
       // 根据字体得到NSString的尺寸
       CGSize sizeThree3 = [self.contentLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
       // 名字的H
       CGFloat nameHThree3 = sizeThree3.height;
       // 名字的W
       CGFloat nameWThree3 = sizeThree3.width;
      self.contentLabel.frame = CGRectMake(0, CGRectGetMaxY(self.colorView.frame) + 3 , nameWThree3, nameHThree3);
    
        [self addSubview:self.namelabel];
        [self addSubview:self.colorView];
        [self addSubview:self.moneylabel];
        [self addSubview:self.taglabel];
      
        
    //   [self.namberView addSubview:self.taglabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.state == 1) {
        [self addSubview:self.contentLabel];
    }
}


//-(void)layoutSubviews {
//    // 一定要调用super的方法
//    [super layoutSubviews];
//    
//    //确定子控件的frame (这里得到的self的frame/bounds才是准确的)
//    //CGFloat width = self.bounds.size.width;
//    //CGFloat height = self.bounds.size.height;
//    
//    
////    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.size.height.mas_equalTo(15);
////        make.left.mas_equalTo(self.mas_left).offset(18);
////        make.top.mas_equalTo(self);
////        make.width.mas_equalTo(200);
////       // make.right.mas_equalTo(self).offset(-30);
////    }];
//    self.namelabel.frame = CGRectMake(8, 0, 300, 15);
//    
//    
//    
////    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.size.mas_equalTo(CGSizeMake(180, 22));
////        make.left.mas_equalTo(self).with.offset(18);
////        make.top.mas_equalTo(self.namelabel.mas_bottom).offset(3);
////    }];
//    self.colorView.frame = CGRectMake(8, CGRectGetMaxY(self.namelabel.frame) + 3, 200, 15);
//    
//    self.colorView.layer.cornerRadius = 7.5;
//    self.colorView.layer.masksToBounds = YES;
//    
////    [self.moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        //make.centerY.mas_equalTo(self.colorView.mas_centerY);
//////        make.top.mas_equalTo(self.namelabel.mas_bottom).offset(6);
//////        make.left.mas_equalTo(self.colorView.mas_right).offset(5);
//////        make.right.mas_equalTo(self.mas_right).offset(-16);
////
////        make.size.height.mas_equalTo(15);
////        make.right.mas_equalTo(self.colorView.mas_right);
////        make.top.mas_equalTo(self);
////        make.width.mas_equalTo(100);
////       // make.right.mas_equalTo(self).offset(-30);
////    }];
//    
//    self.moneylabel.frame = CGRectMake(CGRectGetMaxX(self.colorView.frame) + 10, 0, 100, 15);
//    self.moneylabel.centerY = self.colorView.centerY;
//    
////    [self.namberView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.size.mas_equalTo(CGSizeMake(20, 20));
////        make.centerY.mas_equalTo(self.moneylabel.mas_centerY);
////        make.right.mas_equalTo(self.colorView.mas_left).offset(-10);
////    }];
////
////    [self.taglabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.size.mas_equalTo(CGSizeMake(20, 20));
////        make.center.mas_equalTo(self.namberView);
////    }];
//    
//    
//}

@end
