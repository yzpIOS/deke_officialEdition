//
//  SVAddRecordVC.h
//  SAVI
//
//  Created by Sorgle on 2017/9/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPayManagementModel.h"
@protocol dateStrControllerDelegate<NSObject>
- (void)dateStrControllerCellClick:(NSString *)dateStr;
@end

@interface SVAddRecordVC : UIViewController
@property (nonatomic, weak) id<dateStrControllerDelegate> delegate;
@property (nonatomic,strong) SVPayManagementModel *model;
@property (nonatomic,assign) NSInteger indexType;
//block
@property (nonatomic,copy) void(^addRecordBlock)(NSString *date);

@end
