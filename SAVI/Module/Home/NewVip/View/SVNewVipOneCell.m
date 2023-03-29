//
//  SVNewVipOneCell.m
//  SAVI
//
//  Created by Sorgle on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVNewVipOneCell.h"
#import "SVWaresListVC.h"

@implementation SVNewVipOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//点击扫描按钮
- (IBAction)scanningButton {
    SVWaresListVC *tableVC = [[SVWaresListVC alloc]init];
    //跳转界面有导航栏的
    tableVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
//    [self presentViewController:tableVC animated:YES completion:nil];
    
    
}

@end
