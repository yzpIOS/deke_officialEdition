//
//  SVShopSingleTemplateVC.h
//  SAVI
//
//  Created by houming Wang on 2019/4/8.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol selectMoreModelDelegate<NSObject>
- (void)selectMoreModelClick:(NSMutableArray *)selectModelArray;
@end

@interface SVShopSingleTemplateVC : UIViewController
@property (nonatomic,strong) NSMutableArray *purchaseArr;

@property (nonatomic,strong) NSString *productID;
@property (nonatomic,strong) NSString *sv_p_name;
@property (nonatomic,strong) NSString *sv_p_images2;
@property (nonatomic,strong) NSString *sv_p_unitprice;
@property (nonatomic,strong) NSString *sv_p_barcode;
@property (nonatomic,strong) NSString *sv_p_images;
@property (nonatomic,assign) NSInteger selectNumber; // 选择1是选择商品来的，其他是盘点的
@property (nonatomic,assign) NSInteger isStockPurchase; // 0是盘点    1是进货的
@property (nonatomic, weak) id<selectMoreModelDelegate> delegate;
@property (nonatomic, weak) id<selectMoreModelDelegate> delegateTwo;
@end

NS_ASSUME_NONNULL_END
