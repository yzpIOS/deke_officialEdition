//
//  SVSeveralCopiesCell.h
//  SAVI
//
//  Created by houming Wang on 2018/5/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSeveralCopiesCell : UITableViewCell

@property (nonatomic,copy) void (^severalCopiesCellBlock)(NSInteger num);

@end
