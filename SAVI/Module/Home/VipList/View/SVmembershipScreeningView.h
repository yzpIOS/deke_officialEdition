//
//  SVmembershipScreeningView.h
//  SAVI
//
//  Created by houming Wang on 2020/12/1.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVmembershipScreeningView : UIView
// 请求所需要的参数
@property (nonatomic,assign) NSInteger dengji;
@property (nonatomic,assign) NSInteger fenzhu;
@property (nonatomic,strong) NSString * biaoqian;
@property (nonatomic,assign) NSInteger liusi;
@property (nonatomic,assign) NSInteger hascredit;
@property (nonatomic,strong) NSString * start_deadline;
@property (nonatomic,strong) NSString * end_deadline;
@property (nonatomic,strong) NSString * storeId;
@property (nonatomic,strong) NSString * reg_start_date;
@property (nonatomic,strong) NSString * reg_end_date;
@property (nonatomic,strong) NSString *sv_employee_id;// 操作人员的ID
@property (nonatomic,assign) NSInteger reg_source;

@property (nonatomic,copy) void (^cancleBlock)();

@property (nonatomic,copy) void (^membershipScreeningBlock)(NSString * storeId,NSInteger reg_source,NSString *sv_employee_id,NSInteger dengji,NSInteger fenzhu,NSString* biaoqian,NSInteger liusi,NSInteger hascredit,NSString * start_deadline,NSString * end_deadline,NSString * reg_start_date,NSString * reg_end_date);
@end

NS_ASSUME_NONNULL_END
