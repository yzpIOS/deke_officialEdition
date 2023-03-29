//
//  SVDataDef.h
//  SAVI
//
//  Created by 杨忠平 on 2022/7/23.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define PSResponseStatusSuccessStr @"000000"
#define PSResponseStatusSuccessCode 1
#define PSResponseStatusMobileVerifyFailedStr @"011001"
#define PSResponseStatusFailedCode 0
#define PSResponseStatusSuccessStr200 @"200"
@interface SVDataDef : NSObject

@end

#pragma mark ------------------ 公用 ---------------------

@interface SVMembershipLevelList : NSObject
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSString *sv_ml_name;
@property (nonatomic,assign) double sv_ml_commondiscount;
@property (nonatomic,assign) NSInteger sv_ml_endpoint;
@property (nonatomic,assign) NSInteger memberlevel_id;
@property (nonatomic,assign) NSInteger indexNum;
@property (nonatomic,assign) NSInteger sv_ml_initpoint;
@property (nonatomic,strong) NSString *sv_grade_price;
@property (nonatomic,strong) NSString *bgImageStr;

@end

@interface SVProductResultsData : NSObject
@property (nonatomic,assign) double dealNumber;
@property (nonatomic,assign) double orderCouponMoney;
@property (nonatomic,assign) double dealMoney;
@property (nonatomic,assign) double couponMoney;
@property (nonatomic,assign) double totalMoney;
@property (nonatomic,assign) double freeZeroMoney;
@property (nonatomic,assign) double dealPrice;
@property (nonatomic,assign) double orderChangeMoney;
@property (nonatomic,strong) NSArray * orderPromotions;
@property (nonatomic,strong) NSArray * productResults;
@end

@interface SVProductResultslList : NSObject
//@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *barCode;
@property (nonatomic,strong) NSString *productId;
@property (nonatomic,assign) double number;
@property (nonatomic,assign) double orderCouponMoney;
@property (nonatomic,assign) double dealMoney;
@property (nonatomic,assign) double totalMoney;
@property (nonatomic,assign) double price;
@property (nonatomic,assign) double dealPrice;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSArray * orderPromotions;
@property (nonatomic,strong) NSString *sepcs;
@property (nonatomic,strong) NSString *preferential;
@property (nonatomic,assign) double discountAmount;
@property (nonatomic,assign) double productChangePrice;
@property (nonatomic,strong) id buyStepPromotion;
@property (nonatomic,strong) NSString *sv_p_images;

@property (nonatomic,strong) NSString *sv_p_images2;

@end


@interface SVOrderPromotions : NSObject
@property (nonatomic,assign) double number;
@property (nonatomic,assign) double money;
@property (nonatomic,assign) double couponMoney;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) id promotionDescription;
@end

@interface SVPromotionDescription : NSObject
@property (nonatomic,assign) double t;
@property (nonatomic,assign) double v;
@property (nonatomic,assign) double m;
@property (nonatomic,strong) NSString *s;
@end

@interface SVOrderData : NSObject
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *order_datetime;
@end


@interface SVSalesDetails : NSObject
@property (nonatomic,assign) double numcount;
@property (nonatomic,assign) double order_receivable_bak_new;
@property (nonatomic,assign) double order_money;
@property (nonatomic,strong) NSString* order_payment;
@property (nonatomic,strong) NSString* order_payment1;
@property (nonatomic,strong) NSString* order_payment2;
@property (nonatomic,strong) NSString* salesperson;
@property (nonatomic,strong) NSString* order_datetime;
@property (nonatomic,strong) NSString* sv_remarks;
@property (nonatomic,strong) NSArray *list;
@property (nonatomic,assign) double order_money1;
@property (nonatomic,assign) double order_money2;
@property (nonatomic,strong) NSString* consumeusername;
@property (nonatomic,strong) NSString* sv_mr_name;
@end

@interface SVSalesDetailsList : NSObject

@property (nonatomic,strong) NSString* product_name;

@property (nonatomic,strong) NSString* sv_p_barcode;
@property (nonatomic,assign) double product_num;
@property (nonatomic,assign) double product_total;
@property (nonatomic,assign) double product_price;
@property (nonatomic,assign) double product_unitprice;
@property (nonatomic,strong) NSString *sv_p_specs;
@property (nonatomic,strong) NSString *sv_p_unit;
@property (nonatomic,strong) NSString *sv_preferential_data;
@property (nonatomic,strong) NSString *sv_p_images2;

@end

@interface SVSalesResultData : NSObject
@property (nonatomic,strong) NSString* queryId;
@property (nonatomic,assign) NSInteger svWithoutListId;
@property (nonatomic,assign) NSInteger svOrderListId;
@end



NS_ASSUME_NONNULL_END
