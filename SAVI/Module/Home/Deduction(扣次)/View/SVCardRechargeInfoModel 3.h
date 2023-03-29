//
//  SVCardRechargeInfoModel.h
//  SAVI
//
//  Created by 杨忠平 on 2019/11/26.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVCardRechargeInfoModel : NSObject
@property (nonatomic,strong) NSString *sv_p_unitprice;
@property (nonatomic,strong) NSString *sv_p_name;
@property (nonatomic,strong) NSString *sv_dis_startdate;
@property (nonatomic,strong) NSString *sv_dis_enddate;
@property (nonatomic,strong) NSString *sv_p_images2;
@property (nonatomic,strong) NSString *sv_p_remark;
@property (nonatomic,strong) NSString *sv_p_images;

@property (nonatomic,strong) NSString *buy_date;
@property (nonatomic,strong) NSString *combination_new;

@property (nonatomic,strong) NSString *sv_mcc_leftcount;
@property (nonatomic,strong) NSString *sv_mcc_sumcount;
@property (nonatomic,strong) NSString *validity_date;
@property (nonatomic,strong) NSString *product_id;
@property (nonatomic,strong) NSString *sv_serialnumber;
@property (nonatomic,strong) NSString *userecord_id;





@end

NS_ASSUME_NONNULL_END
