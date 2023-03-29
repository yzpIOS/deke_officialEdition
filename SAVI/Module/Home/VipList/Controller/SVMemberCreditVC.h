//
//  SVMemberCreditVC.h
//  SAVI
//
//  Created by houming Wang on 2020/11/24.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberCreditVC : UIViewController
@property (nonatomic,strong) NSString * member_id;

@property (nonatomic,copy) void (^successBlock)();
@end

NS_ASSUME_NONNULL_END
