//
//  SVDeductionDetailVC.h
//  SAVI
//
//  Created by 杨忠平 on 2019/10/22.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVDeductionDetailVC : UIViewController
@property (nonatomic,strong) NSMutableArray *timesCountArr;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *level;
@property (nonatomic,strong) NSString *headimg;
@property (nonatomic,strong) NSString *storedValue;
@property (nonatomic,strong) NSString *sv_mw_sumpoint;
@property (nonatomic,strong) NSString *sv_mr_birthday;
@property (nonatomic,strong) NSString *sv_mr_cardno;
@property (nonatomic,strong) NSString *sv_mw_availablepoint;
@property(retain,nonatomic) NSString *member_id;
@property (nonatomic,strong) NSString *discount;
@property (nonatomic,strong) NSString *tel;
@end

NS_ASSUME_NONNULL_END
