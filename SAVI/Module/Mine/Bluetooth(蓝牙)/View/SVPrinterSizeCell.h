//
//  SVPrinterSizeCell.h
//  SAVI
//
//  Created by houming Wang on 2018/5/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVPrinterSizeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *ontButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;

@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@property (nonatomic,copy) void (^printerSixeCellBlock)(NSInteger num);

@end
