//
//  SVediteAndColorView.m
//  SAVI
//
//  Created by houming Wang on 2019/3/25.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVediteAndColorView.h"

@implementation SVediteAndColorView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.editView.layer.cornerRadius = 5;
    self.editView.layer.masksToBounds = YES;
    
    self.deleteView.layer.cornerRadius = 5;
    self.deleteView.layer.masksToBounds = YES;
}

@end
