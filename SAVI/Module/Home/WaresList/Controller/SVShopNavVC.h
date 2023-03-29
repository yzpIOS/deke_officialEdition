//
//  SVShopNavVC.h
//  SAVI
//
//  Created by houming Wang on 2021/2/2.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVduoguigeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SVShopNavVC : UIViewController
@property (nonatomic,strong) SVduoguigeModel * model;
@property (nonatomic,copy) void (^deleteBlock)();
@end

NS_ASSUME_NONNULL_END
