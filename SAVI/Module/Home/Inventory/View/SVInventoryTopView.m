//
//  SVInventoryTopView.m
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInventoryTopView.h"

@implementation SVInventoryTopView

- (void)awakeFromNib{
    [super awakeFromNib];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.titleNameLabel.text = @"品名/款号";
    }else{
        
        self.titleNameLabel.text = @"品名/条码";
    }
}

@end
