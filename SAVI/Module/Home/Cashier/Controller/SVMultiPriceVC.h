//
//  SVMultiPriceVC.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/23.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVSelectedGoodsModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVMultiPriceVC : UIViewController
@property (nonatomic,strong) SVSelectedGoodsModel *model;
@property (nonatomic,assign) float product_num;
@property (nonatomic, copy)void(^multiModelBlock)(SVSelectedGoodsModel *model ,NSIndexPath *indexPath,double product_num);

@end

NS_ASSUME_NONNULL_END
