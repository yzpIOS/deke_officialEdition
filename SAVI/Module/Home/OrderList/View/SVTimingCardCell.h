//
//  SVTimingCardCell.h
//  SAVI
//
//  Created by houming Wang on 2019/2/21.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVSettlementTimesCountModel;
@interface SVTimingCardCell : UICollectionViewCell
@property (nonatomic,strong) SVSettlementTimesCountModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (nonatomic,assign) NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (nonatomic,copy) void(^selctModelBlock)(SVSettlementTimesCountModel *model);
@end
