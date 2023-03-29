//
//  SVSeeWaresVC.h
//  SAVI
//
//  Created by Sorgle on 2017/7/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSeeWaresVC : UIViewController

///点击结算带过来的数组
@property (nonatomic, strong) NSMutableArray *orderArr;
//接总价格过来
@property (nonatomic,assign) float money;
//件数
@property (nonatomic,assign) float number1;


//清空回调的block
@property (nonatomic,copy) void(^emptyBlock)();

@end
