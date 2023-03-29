//
//  SVAddInfoDetailCell.h
//  SAVI
//
//  Created by houming Wang on 2021/2/21.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVAddInfoDetailCell : UITableViewCell

@property (nonatomic,strong) NSDictionary * dict;
@property (weak, nonatomic) IBOutlet UIButton *choiceBtn;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UILabel *sv_foundation_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContont;


@end

NS_ASSUME_NONNULL_END
