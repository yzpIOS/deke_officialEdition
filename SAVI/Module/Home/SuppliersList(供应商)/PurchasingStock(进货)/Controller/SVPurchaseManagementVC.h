//
//  SVPurchaseManagementVC.h
//  SAVI
//
//  Created by houming Wang on 2019/8/2.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPurchaseManagementVC : UIViewController
@property (nonatomic,copy) void(^addWarehouseWares)(NSMutableArray *selectArr);
@property (nonatomic,assign) NSInteger controllerNum;
@property (nonatomic,strong) NSMutableArray *selectModelArray;
@end

NS_ASSUME_NONNULL_END
