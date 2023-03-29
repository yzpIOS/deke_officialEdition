//
//  SVHistoryCell.m
//  SAVI
//
//  Created by Sorgle on 2017/6/8.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVHistoryCell.h"

@interface SVHistoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *name;





@end

@implementation SVHistoryCell

-(void)setHistoryModel:(SVHistoryModel *)historyModel{
    _historyModel = historyModel;
    
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    /**
     商品名字
     */
    self.name.text = historyModel.product_name;
    
    /**
     件数
     */
//    float x = [historyModel.product_num floatValue];
//    
//    self.y+=x;
//    
//    
//    
//    self.number.text = [NSString stringWithFormat:@"%.f",self.y];
//    

    
    /**
     总价
     */
//    float money = [historyModel.order_receivable floatValue];
//    
//    self.unitprice.text = [NSString stringWithFormat:@"%0.2f",money];
    
    
    
}





@end
