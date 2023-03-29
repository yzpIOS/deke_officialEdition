//
//  SVMemberdiscountCell.h
//  SAVI
//
//  Created by houming Wang on 2020/12/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVMemberdiscountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *MinimumDiscount;
@property (weak, nonatomic) IBOutlet UITextField *MinimumPrice;
@property (weak, nonatomic) IBOutlet UITextField *MemberPrice;
@end

NS_ASSUME_NONNULL_END
