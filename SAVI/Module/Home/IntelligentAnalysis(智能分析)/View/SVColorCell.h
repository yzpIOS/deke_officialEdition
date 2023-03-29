//
//  SVColorCell.h
//  SAVI
//
//  Created by 杨忠平 on 2020/1/7.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVColorCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSDictionary *consumeDict;

@property (nonatomic,strong) NSDictionary *memberDict;

@property (nonatomic,strong) NSDictionary *activeDict;



@end

NS_ASSUME_NONNULL_END
