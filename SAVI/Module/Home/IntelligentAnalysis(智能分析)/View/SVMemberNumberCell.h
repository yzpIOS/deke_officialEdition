//
//  SVMemberNumberCell.h
//  SAVI
//
//  Created by 杨忠平 on 2020/1/9.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberNumberCell : UITableViewCell
@property (nonatomic,assign) float memberOrder_receivable;
@property (nonatomic,strong) NSMutableArray *memberCountArray;
@end

NS_ASSUME_NONNULL_END
