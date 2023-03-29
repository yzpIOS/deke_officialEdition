//
//  SVSmallClassCell.m
//  SAVI
//
//  Created by Sorgle on 2017/9/22.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSmallClassCell.h"

@implementation SVSmallClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//collectionViewCell里覆写这个
//- (void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
//    if (selected) {
//        //选中时
//            self.img.image = [UIImage imageNamed:@"select_red"];
//            self.titleLabel.textColor = RGBA(240, 195, 66, 1);
//    }else{
//        //非选中
//        self.img.image = [UIImage imageNamed:@"chargeType"];
//        self.titleLabel.textColor = [UIColor blackColor];
//    }
//    
//}

@end
