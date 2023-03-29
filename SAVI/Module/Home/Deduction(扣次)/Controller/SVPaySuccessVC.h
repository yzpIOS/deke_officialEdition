//
//  SVPaySuccessVC.h
//  SAVI
//
//  Created by 杨忠平 on 2019/11/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPaySuccessVC : UIViewController
@property (nonatomic,assign) float money;
@property (nonatomic,strong) NSDictionary * result;
@property (nonatomic,strong) NSString *queryId;
@property (nonatomic,strong) NSString * paymentStr;
@property (nonatomic,strong) NSString * sv_p_name;
@property (nonatomic,assign) double storedValue;
@property (nonatomic,strong) NSString * member_tel;
@end

NS_ASSUME_NONNULL_END
