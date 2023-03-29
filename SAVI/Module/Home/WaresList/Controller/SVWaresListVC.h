//
//  SVWaresListVC.h
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVduoguigeModel;
@class SVPurchaseManagementVC;
@interface SVWaresListVC : UIViewController

//记录:默认为0是商品列表跳转，1为新增进货跳转，2是新增退货跳转
@property (nonatomic,assign) NSInteger controllerNum;
@property (nonatomic,strong) NSMutableArray *selectModelArray;
@property (nonatomic,strong) NSMutableArray *purchaseArr;
@property (nonatomic,strong) SVPurchaseManagementVC *purchaseManagementVC;

//@property (nonatomic,copy) void(^addWarehouseWares)(NSString *sv_p_images2,NSString *sv_p_name,NSString *sv_p_unitprice,NSString *sv_p_storage,NSString *product_id,NSString *sv_pricing_method);

@property (nonatomic,copy) void(^addWarehouseWares)(NSMutableArray *selectArr);

@property (nonatomic,copy) void(^selectModelBlock)(SVduoguigeModel *model);
//@property (nonatomic,copy) void(^selectModelBlock)(NSMutableArray *selectArray);
@end
