//
//  SVErectLineView.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/11.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVErectLineView.h"

@implementation SVErectLineView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       
            self.namelabel = [[UILabel alloc]init];
            self.namelabel.textColor = GlobalFontColor;
            self.namelabel.font = [UIFont systemFontOfSize:12];
            self.namelabel.textAlignment = NSTextAlignmentCenter;
            
            self.colorView = [[UIView alloc]init];
            self.colorView.backgroundColor = navigationBackgroundColor;
            // self.colorView.centerY = self.namelabel.centerY;
            
            self.moneylabel = [[UILabel alloc]init];
            self.moneylabel.textColor = GlobalFontColor;
            self.moneylabel.font = [UIFont systemFontOfSize:13];
            self.moneylabel.textAlignment = NSTextAlignmentCenter;
            
            //        self.namberView = [[UIView alloc]init];
            //        self.namberView.backgroundColor = RGBA(139, 195, 47, 1);
            //        self.namberView.layer.cornerRadius = 10;
            //
            //        self.taglabel = [[UILabel alloc]init];
            //        self.taglabel.text = [NSString stringWithFormat:@"%ld",(long)self.tag];
            //        self.taglabel.textColor = [UIColor whiteColor];
            //        self.taglabel.font = [UIFont systemFontOfSize:12];
            //        self.taglabel.textAlignment = NSTextAlignmentCenter;
            
            self.colorView.frame = CGRectMake(0, CGRectGetMaxY(self.namelabel.frame) + 3, 0, 15);
            
            self.namelabel.frame = CGRectMake(0, 0, 30, 15);
            
            
            
            //    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.size.mas_equalTo(CGSizeMake(180, 22));
            //        make.left.mas_equalTo(self).with.offset(18);
            //        make.top.mas_equalTo(self.namelabel.mas_bottom).offset(3);
            //    }];
            
            
            self.colorView.layer.cornerRadius = 7.5;
            self.colorView.layer.masksToBounds = YES;
            
            self.moneylabel.frame = CGRectMake(CGRectGetMaxX(self.colorView.frame) + 10, 0, 100, 15);
            self.moneylabel.centerY = self.colorView.centerY;
            
            [self addSubview:self.namelabel];
            [self addSubview:self.colorView];
            [self addSubview:self.moneylabel];
        }
 
    return self;
}


@end
