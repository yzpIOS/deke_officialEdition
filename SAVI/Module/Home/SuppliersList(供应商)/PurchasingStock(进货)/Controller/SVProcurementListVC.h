//
//  SVProcurementListVC.h
//  SAVI
//
//  Created by Sorgle on 2017/12/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVProcurementListVC : SVBaseVC

//记录:默认为0是商品列表跳转，1为新增退货跳转
@property (nonatomic,assign) NSInteger controllerNum;

//记录筛选
@property (nonatomic,assign) NSInteger oneState;
@property (nonatomic,assign) NSInteger twoState;
@property (nonatomic,assign) NSInteger threeState;
@property (nonatomic,assign) NSInteger fourState;

//block
//@property (nonatomic,copy) ()();
@property (nonatomic,copy) void (^procurementListBlock)(NSDictionary *dic);

@end
