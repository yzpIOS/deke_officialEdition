//
//  SVAddWaresModel.h
//  SAVI
//
//  Created by Sorgle on 2017/6/3.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVAddWaresModel : NSObject

///**
// 图片
// */
//@property (nonatomic, copy) NSString *sv_p_images2;

/**
 商品
 */
@property (nonatomic, copy) NSString *sv_p_name;

/**
 价格
 */
@property (nonatomic, copy) NSString *sv_p_unitprice;

/**
 库存
 */
@property (nonatomic, copy) NSString *sv_p_storage;

/**
 ID
 */
//@property (nonatomic, copy) NSString *product_id;

@end
