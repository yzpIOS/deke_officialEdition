//
//  SVRightScreenVIew.h
//  SAVI
//
//  Created by houming Wang on 2020/11/20.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVRightScreenVIew : UIView
@property (nonatomic,copy) void (^InquirySalesBlock)(NSString *Shop,NSString *memberInfo,NSString *pay,NSString *Consumers,NSString *Sourcesofconsumption,NSString *SerialNumber,NSString *commodity,NSString *sv_employee_id);

//@property (nonatomic,copy) void (^InquirySalesBlock)(NSString *Shop,NSString *memberInfo,NSString *pay,NSString *Consumers,NSString *Sourcesofconsumption,NSString *SerialNumber,NSString *commodity,NSString *Operator,NSString *sv_employee_id);
//self.sv_employee_id
//记录支付方式
@property (nonatomic,copy) NSString *payName;
// 选了什么关键字
@property (nonatomic,copy) NSString *searchSelectName;
// 散客会员
@property (nonatomic,strong) NSString *type;
// 订单号关键字
@property (nonatomic,strong) NSString *liushui;
// 店铺查询
@property (nonatomic,strong) NSString *storeid;
// 操作员信息关键字
//@property (nonatomic,strong) NSString *seller;
// 指定会员的会员ID
@property (nonatomic,strong) NSString *memberId;
// 订单来源
@property (nonatomic,strong) NSString *orderSource;
// 商品信息
@property (nonatomic,strong) NSString *product;
// 搜索会员信息
@property (nonatomic,strong) NSString *seachMemberStr;

@property (nonatomic,strong) NSString *sv_employee_id;// 操作人员的ID
@property (nonatomic,strong) NSString *shopId; // 店铺ID
@property (nonatomic,copy) void (^cancleBlock)();
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopInfoLabel;
@end

NS_ASSUME_NONNULL_END
