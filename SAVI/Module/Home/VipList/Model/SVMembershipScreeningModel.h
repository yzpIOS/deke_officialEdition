//
//  SVMembershipScreeningModel.h
//  SAVI
//
//  Created by houming Wang on 2020/12/1.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMembershipScreeningModel : NSObject
// 分组
@property (nonatomic,strong) NSString *membergroup_id;
@property (nonatomic,strong) NSString *sv_mg_name;
@property (nonatomic,strong) NSString *user_id;
@end

NS_ASSUME_NONNULL_END
