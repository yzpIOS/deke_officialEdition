//
//  SVPaymentMethodCell.h
//  SAVI
//
//  Created by houming Wang on 2021/3/23.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVPaymentMethodCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *money;

@end

NS_ASSUME_NONNULL_END
