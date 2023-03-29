//
//  SVWaresListVC.h
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVNewStockCheckVC;
@class SVduoguigeModel;
@interface SVLabelPrintingVC : UIViewController

//记录:默认为0是商品列表跳转，1为盘点选商品  2是盘点商品的 ，3是服务商品
@property (nonatomic,assign) NSInteger controllerNum;
@property (nonatomic,strong) NSMutableArray *selectModelArray;
@property (nonatomic,strong) NSMutableArray *purchaseArr;
@property (nonatomic,weak) SVNewStockCheckVC *stockCheckVC;
//@property (nonatomic,copy) void(^addWarehouseWares)(NSString *sv_p_images2,NSString *sv_p_name,NSString *sv_p_unitprice,NSString *sv_p_storage,NSString *product_id,NSString *sv_pricing_method);
@property (nonatomic,strong) NSMutableArray *modelArr;


@property (nonatomic,copy) void(^selectDuoguigeModel)(SVduoguigeModel *model);
@property (nonatomic,copy) void(^addWarehouseWares)(NSMutableArray *selectArr);
@end
