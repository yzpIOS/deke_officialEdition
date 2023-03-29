//
//  SVTransfersDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/24.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVTransfersDetailsVC.h"
//查看商品
#import "SVTransfersGoods.h"

@interface SVTransfersDetailsVC ()

@end

@implementation SVTransfersDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"调拨详情";
    
    
    
}

- (IBAction)lookTransfersGoods {
    
    SVTransfersGoods *VC = [[SVTransfersGoods alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}


@end
