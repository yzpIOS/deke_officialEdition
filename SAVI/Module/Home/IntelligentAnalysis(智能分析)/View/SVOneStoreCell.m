//
//  SVOneStoreCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/30.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVOneStoreCell.h"
#import "SVShopOverviewModel.h"
#import "SVStoreCategaryModel.h"

@interface SVOneStoreCell()
@property (weak, nonatomic) IBOutlet UILabel *totleMoney;
@property (weak, nonatomic) IBOutlet UILabel *Discount;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UILabel *fatherTotleMoney;
@property (weak, nonatomic) IBOutlet UILabel *fatherNumber;

@property (weak, nonatomic) IBOutlet UILabel *totleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation SVOneStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fatherView.layer.cornerRadius = 10;
    self.fatherView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setDataList:(NSMutableArray *)dataList
{
    self.fatherView.hidden = YES;
    _dataList = dataList;
    float order_receivable = 0.0;
    float order_pdgfee = 0.0;
    NSInteger count = 0;
    for (SVShopOverviewModel *model in self.dataList) {
        order_receivable += [model.order_receivable floatValue];
        order_pdgfee += [model.order_pdgfee floatValue];
        count += [model.orderciunt integerValue];
    }
    self.totleMoney.text = [NSString stringWithFormat:@"%.2f",order_receivable];
    self.Discount.text = [NSString stringWithFormat:@"%.2f",order_pdgfee];
     self.number.text = [NSString stringWithFormat:@"%ld",count];
}

- (void)setFatherDataList:(NSMutableArray *)FatherDataList
{
     self.fatherView.hidden = NO;
    _FatherDataList = FatherDataList;
   // _dataList = dataList;
    float order_receivable = 0.0;
   // float order_pdgfee = 0.0;
    NSInteger count = 0;
    for (SVShopOverviewModel *model in FatherDataList) {
        order_receivable += [model.order_receivable floatValue];
       // order_pdgfee += [model.order_pdgfee floatValue];
        count += [model.rcount integerValue];
    }
    self.fatherTotleMoney.text = [NSString stringWithFormat:@"%.2f",order_receivable];
    //self.Discount.text = [NSString stringWithFormat:@"%.2f",order_pdgfee];
    self.fatherNumber.text = [NSString stringWithFormat:@"%ld",count];
}

- (void)setMemberAnalysis:(NSDictionary *)memberAnalysis
{
    self.fatherView.hidden = YES;
    _memberAnalysis = memberAnalysis;
    self.totleLabel.text = @"储值总额";
    self.discountLabel.text = @"会员总数";
    self.numberLabel.text = @"新增会员";
    self.totleMoney.text = [NSString stringWithFormat:@"%.2f",[memberAnalysis[@"sv_mw_availableamount"] floatValue]];
    self.Discount.text = [NSString stringWithFormat:@"%.2f",[memberAnalysis[@"membercount"] floatValue]];
    self.number.text = [NSString stringWithFormat:@"%.2f",[memberAnalysis[@"lastdaycount"] floatValue]];
}



- (void)setDict:(NSDictionary *)dict
{
    self.fatherView.hidden = YES;
    _dict = dict;
    self.totleLabel.text = @"储值余额总计(元)";
    self.discountLabel.text = @"累计充值(元)";
    self.numberLabel.text = @"累计撤销(元)";
    self.totleMoney.text = [NSString stringWithFormat:@"%.2f",[dict[@"all_sv_mw_availableamount"] floatValue]];
    self.Discount.text = [NSString stringWithFormat:@"%.2f",[dict[@"sumup"] floatValue]];
    self.number.text = [NSString stringWithFormat:@"%.2f",[dict[@"sumcancel"] floatValue]];
}

- (void)setShopDict:(NSDictionary *)shopDict
{
    
    _shopDict = shopDict;
    self.fatherTotleMoney.text = [NSString stringWithFormat:@"%.2f",[shopDict[@"order_receivable"]floatValue]];
    //self.Discount.text = [NSString stringWithFormat:@"%.2f",order_pdgfee];
    self.fatherNumber.text = [NSString stringWithFormat:@"%.2f",[shopDict[@"count"]floatValue]];
    
    
}

- (void)setCatageryArray:(NSMutableArray *)catageryArray
{
    _catageryArray = catageryArray;
    float order_receivable = 0.0;
    // float order_pdgfee = 0.0;
    float count = 0;
    for (SVStoreCategaryModel *model in catageryArray) {
        order_receivable = [model.total_amount floatValue];
        // order_pdgfee += [model.order_pdgfee floatValue];
        count += [model.category_num floatValue];
    }
    self.fatherTotleMoney.text = [NSString stringWithFormat:@"%.2f",order_receivable];
    self.fatherNumber.text = [NSString stringWithFormat:@"%.2f",count];
}



@end
