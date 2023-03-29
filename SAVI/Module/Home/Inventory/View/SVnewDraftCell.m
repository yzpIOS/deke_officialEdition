//
//  SVnewDraftCell.m
//  SAVI
//
//  Created by houming Wang on 2019/6/3.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVnewDraftCell.h"
#import "SVdraftListModel.h"
@interface SVnewDraftCell()
@property (weak, nonatomic) IBOutlet UILabel *pandiandanhao;
@property (weak, nonatomic) IBOutlet UILabel *shopNum;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end
@implementation SVnewDraftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVdraftListModel *)model
{
    _model = model;
    self.pandiandanhao.text = [NSString stringWithFormat:@"盘点单号：%@",model.sv_storestock_check_r_no];
    self.shopNum.text = [NSString stringWithFormat:@"共%@种商品",model.productnum];
    self.nameL.text = [NSString stringWithFormat:@"盘点人：%@",model.sv_storestock_check_r_opter];
    if (model.sv_creation_date.length < 19) {
        self.timeL.text = model.sv_creation_date;
    }else{
        self.timeL.text =[model.sv_creation_date substringToIndex:19];//截取掉下标2之前的字符串
        if ([self.timeL.text containsString:@"T"]) {
            NSString *string = [self.timeL.text stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            self.timeL.text = string;
        }
    }
    
    
}



@end
