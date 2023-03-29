//
//  SVSecondaryRecordModel.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSecondaryRecordModel : NSObject
@property (nonatomic,strong) NSString *sv_mcr_productname;
@property (nonatomic,strong) NSString *sv_mcr_count;
@property (nonatomic,strong) NSString *sv_mcr_money;
@property (nonatomic,strong) NSString *sv_mcr_payment;
@property (nonatomic,strong) NSString *sv_mcr_date;

@end

NS_ASSUME_NONNULL_END
