//
//  SVdraftListModel.h
//  SAVI
//
//  Created by houming Wang on 2019/6/10.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVdraftListModel : NSObject
@property (nonatomic,strong) NSString *sv_creation_date;
@property (nonatomic,strong) NSString *sv_storestock_check_no;
@property (nonatomic,strong) NSString *sv_storestock_check_r_no;
@property (nonatomic,strong) NSString *sv_storestock_check_r_opter;
@property (nonatomic,strong) NSString *sv_storestock_check_r_status;
@property (nonatomic,strong) NSString *productnum;
@property (nonatomic,strong) NSArray *storeStockCheckDetail;
@property (nonatomic,strong) NSString *checkmoney;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,strong) NSString *sv_storestock_check_r_status_name;

@end

NS_ASSUME_NONNULL_END
