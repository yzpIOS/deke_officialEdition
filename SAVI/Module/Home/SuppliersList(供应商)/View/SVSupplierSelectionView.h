//
//  SVSupplierSelectionView.h
//  SAVI
//
//  Created by houming Wang on 2021/4/15.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSupplierSelectionView : UIView
@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) NSArray * DocumentTypeArray;
@property (weak, nonatomic) IBOutlet UIView *DocumentTypeView;
// sv_suid是供应商id
@property (nonatomic,copy) void (^supplierDetermineBlock)(NSString *start_date,NSString *end_date,NSInteger state1,NSInteger sv_enable,NSInteger sv_suid,NSInteger sv_order_type);
//// 对账的
//@property (nonatomic,copy) void (^ReconciliationBlock)(NSString *start_date,NSString *end_date,NSInteger state1,NSInteger sv_enable,NSInteger sv_suid,NSInteger sv_order_type);
@end

NS_ASSUME_NONNULL_END
