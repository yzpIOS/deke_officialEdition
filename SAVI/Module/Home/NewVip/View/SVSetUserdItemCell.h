//
//  SVSetUserdItemCell.h
//  SAVI
//
//  Created by 杨忠平 on 2019/11/13.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSetUserdItemCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic, copy)void(^countBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy)void(^selectCountBlock)(NSString *selectStr,NSIndexPath *indexPath);

@property (nonatomic, copy)void(^removeCountBlock)(NSString *selectStr,NSIndexPath *indexPath);
@end

NS_ASSUME_NONNULL_END
