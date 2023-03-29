//
//  SVReturnGoodsListVC.h
//  SAVI
//
//  Created by 杨忠平 on 2020/4/11.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVReturnGoodsListVC : UIViewController
@property (nonatomic,copy) void(^addWarehouseWares)(NSMutableArray *selectArr);
@end

NS_ASSUME_NONNULL_END
