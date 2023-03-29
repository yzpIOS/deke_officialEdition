//
//  SVIntegralInputVIew.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/12.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVIntegralInputVIew.h"

@implementation SVIntegralInputVIew

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
}

@end
