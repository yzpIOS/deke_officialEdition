//
//  SVProportionCell.h
//  SAVI
//
//  Created by 杨忠平 on 2020/1/3.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVProportionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UILabel *nameText;

@end

NS_ASSUME_NONNULL_END
