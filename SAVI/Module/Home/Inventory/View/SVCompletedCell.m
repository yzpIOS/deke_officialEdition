//
//  SVCompletedCell.m
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVCompletedCell.h"
#import "SVdraftListModel.h"

@interface SVCompletedCell()
@property (weak, nonatomic) IBOutlet UILabel *pandiandanhao;
@property (weak, nonatomic) IBOutlet UILabel *shopNum;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *yingkuiL;


@end

@implementation SVCompletedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame{
    //    frame.origin.x += 10;
    frame.origin.y += 5;
    frame.size.height -= 5;
    //    frame.size.width -= 20;
    [super setFrame:frame];
}


- (void)setModel:(SVdraftListModel *)model
{
    _model = model;
    self.pandiandanhao.text = [NSString stringWithFormat:@"盘点单号：%@",model.sv_storestock_check_r_no];
    self.shopNum.text = [NSString stringWithFormat:@"共%@种商品",model.productnum];
    self.nameL.text = [NSString stringWithFormat:@"盘点人：%@",model.sv_storestock_check_r_opter];
    //    self.timeL.text = model.sv_creation_date;
    if (model.sv_creation_date.length < 19) {
        self.timeL.text = model.sv_creation_date;
    }else{
        self.timeL.text =[model.sv_creation_date substringToIndex:19];//截取掉下标2之前的字符串
        if ([self.timeL.text containsString:@"T"]) {
            NSString *string = [self.timeL.text stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            self.timeL.text = string;
        }
    }
    
    int count = model.checkmoney.intValue;
    if (count > 0) {
        self.yingkuiL.text = [NSString stringWithFormat:@"盈%i",count];
        self.yingkuiL.textColor = [UIColor redColor];
    }else if (count == 0){
        self.yingkuiL.text = @"平衡";
    }else{
        self.yingkuiL.text = [NSString stringWithFormat:@"亏%i",abs(count)];
        self.yingkuiL.textColor = navigationBackgroundColor;
    }
}


@end
