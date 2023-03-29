//
//  SVCardSalesFlowChartCell.h
//  SAVI
//
//  Created by 杨忠平 on 2020/1/16.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVCardSalesFlowChartCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *Printingbtn;


@end

NS_ASSUME_NONNULL_END
