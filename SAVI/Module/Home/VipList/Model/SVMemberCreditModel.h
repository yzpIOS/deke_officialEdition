//
//  SVMemberCreditModel.h
//  SAVI
//
//  Created by houming Wang on 2020/11/25.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberCreditModel : NSObject
//@property (weak, nonatomic) IBOutlet UILabel *order_running_id;
//@property (weak, nonatomic) IBOutlet UILabel *order_datetime;
//@property (weak, nonatomic) IBOutlet UILabel *order_money;
//@property (weak, nonatomic) IBOutlet UILabel *order_money2;
//@property (weak, nonatomic) IBOutlet UILabel *order_datetime2;


@property (nonatomic, copy) NSString *order_running_id;
@property (nonatomic, copy) NSString *order_datetime;
@property (nonatomic, copy) NSString *order_money;
@property(nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *order_money2;

@property (nonatomic, copy) NSString *sv_member_id;
@property (nonatomic, copy) NSString *sv_mw_order_id;
//@property (nonatomic, copy) NSString *sv_date;
@property (nonatomic,strong) NSString * sv_credit_money;
//@property (nonatomic, copy) NSString *sv_member_id;


@property (nonatomic,strong) NSString * sv_payment_method_name;
@property (nonatomic,strong) NSString * sv_money;
@property (nonatomic,strong) NSString * sv_order_id;
@property (nonatomic,strong) NSString * sv_date;
@end

NS_ASSUME_NONNULL_END
