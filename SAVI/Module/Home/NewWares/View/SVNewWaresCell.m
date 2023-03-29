//
//  SVNewWaresCell.m
//  SAVI
//
//  Created by Sorgle on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVNewWaresCell.h"

@implementation SVNewWaresCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.titleNameLabel.text = @"款号";
    }else{
        self.titleNameLabel.text = @"条码";
    }
}

/**
 如果是XIB,在XIB的.m文件里重写以下的两个方法，就可以取消tableviewcell被选中后的高亮效果
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

@end
