//
//  SVPrintCollectionViewCell.m
//  SAVI
//
//  Created by houming Wang on 2018/9/28.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVPrintCollectionViewCell.h"

@interface SVPrintCollectionViewCell()
@property (nonatomic,strong) UIButton *fourSelect;

@end
@implementation SVPrintCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.layer.borderColor = [UIColor blackColor].CGColor;
//    self.layer.borderWidth = 1;
    
}

//- (IBAction)sizeClick:(UIButton * )btn {
//    
//    if (btn!= self.fourSelect) {
//       // self.fourSelect.layer.borderColor = ([UIColor colorWithHexString:@"D2D2D2"].CGColor);
//        self.fourSelect.selected = NO;
//        btn.selected = YES;
//        btn.layer.borderColor = ([UIColor colorWithHexString:@"5497EC"].CGColor);
//        self.fourSelect = btn;
//        NSLog(@"btn.titlevip天数 = %@",self.fourSelect.titleLabel.text);
//    }else{
//        self.fourSelect.selected = YES;
//    }
//}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    if(selected) {
      //  [self.on setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateNormal];
        self.oneIconImage.image = [UIImage imageNamed:@"ic_yixuan.png"];
    }else{
//         NSLog(@"普通");
       // [self.size setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
       self.oneIconImage.image = [UIImage imageNamed:@"ic_mo-ren"];
    }
    
}

@end
