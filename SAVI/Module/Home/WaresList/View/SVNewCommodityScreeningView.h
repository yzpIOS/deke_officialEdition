//
//  SVNewCommodityScreeningView.h
//  SAVI
//
//  Created by houming Wang on 2021/1/28.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVNewCommodityScreeningView : UIView
@property (nonatomic,copy) void (^CommodityScreeningBlock)(NSString *user_id,NSString *Product_state,NSString *Stock_type,NSString *Stock_Min,NSString *Stock_Max,NSString *Stock_date_type,NSString *Stock_date_start,NSString *Stock_date_end,NSString *year,NSString *sv_brand_ids,NSString *fabric_ids);

@property (nonatomic,copy) void (^canBlock)();
@end

NS_ASSUME_NONNULL_END
