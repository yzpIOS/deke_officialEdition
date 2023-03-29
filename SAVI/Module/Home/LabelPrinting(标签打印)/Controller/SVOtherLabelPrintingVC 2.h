//
//  SVOtherLabelPrintingVC.h
//  SAVI
//
//  Created by houming Wang on 2019/4/8.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVOtherLabelPrintingVC : UIViewController
//记录:默认为0是商品列表跳转，1为新增进货跳转
@property (nonatomic,assign) NSInteger controllerNum;

@property (nonatomic,strong) NSMutableArray *purchaseArr;

//@property (nonatomic,copy) void(^addWarehouseWares)(NSString *sv_p_images2,NSString *sv_p_name,NSString *sv_p_unitprice,NSString *sv_p_storage,NSString *product_id,NSString *sv_pricing_method);

@property (nonatomic,copy) void(^addWarehouseWares)(NSMutableArray *selectArr);
@end

NS_ASSUME_NONNULL_END
