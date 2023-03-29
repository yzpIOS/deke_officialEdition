//
//  SVOrderProductListModel.h
//  SAVI
//
//  Created by 杨忠平 on 2020/3/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVOrderProductListModel : NSObject
@property (nonatomic,strong) NSString *product_name;
@property (nonatomic,strong) NSString *sv_p_images2;
@property (nonatomic,strong) NSString *sv_product_unitprice;
@property (nonatomic,assign) double sv_product_num;
@property (nonatomic,strong) NSString *product_discount;
@property (nonatomic,strong) NSString *sv_p_weight_bak;
@property (nonatomic,strong) NSString *product_num_bak;
@property (nonatomic,strong) NSString *sv_p_specs;
@property (nonatomic,strong) NSString *sv_p_barcode;
@property (nonatomic,strong) NSString *product_price;
@property (nonatomic,strong) NSString *product_total_bak;
@property (nonatomic,strong) NSString *product_unitprice;
@property (nonatomic,strong) NSString *order_receivable_bak;







@end

NS_ASSUME_NONNULL_END
