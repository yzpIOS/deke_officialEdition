//
//  SVWaresDetailsVC.h
//  SAVI
//
//  Created by Sorgle on 2017/5/26.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVWaresDetailsVC : UIViewController

//产品ID
@property (nonatomic,copy) NSString *productID;
@property (nonatomic,assign) NSInteger sv_is_newspec;

//修改后回调
@property (nonatomic,copy) void (^WaresDetailsBlock)();

@end
