//
//  SVPrintCollectionViewCell.h
//  SAVI
//
//  Created by houming Wang on 2018/9/28.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVPrintCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UIImageView *oneIconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

//@property (weak, nonatomic) IBOutlet UIButton *size;

@property (nonatomic,copy) void(^selectStyleBlock)(NSInteger index);
@end
