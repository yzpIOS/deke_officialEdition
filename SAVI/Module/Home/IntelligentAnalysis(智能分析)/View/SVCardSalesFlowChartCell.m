//
//  SVCardSalesFlowChartCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/16.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVCardSalesFlowChartCell.h"

@interface SVCardSalesFlowChartCell()
@property (weak, nonatomic) IBOutlet UILabel *liushuihao;
@property (weak, nonatomic) IBOutlet UILabel *cikamingcheng;
@property (weak, nonatomic) IBOutlet UILabel *cikajine;
@property (weak, nonatomic) IBOutlet UIButton *chexiaoBtn;

@end
@implementation SVCardSalesFlowChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.liushuihao.adjustsFontSizeToFitWidth = YES;
    self.liushuihao.minimumScaleFactor = 0.5;
    
    self.cikamingcheng.adjustsFontSizeToFitWidth = YES;
    self.cikamingcheng.minimumScaleFactor = 0.5;
    
    self.cikajine.adjustsFontSizeToFitWidth = YES;
    self.cikajine.minimumScaleFactor = 0.5;
    
}



- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.liushuihao.text = dict[@"sv_serialnumber"];
    self.cikamingcheng.text = dict[@"sv_p_name"];
    self.cikajine.text = [NSString stringWithFormat:@"%.2f",[dict[@"amount"]floatValue]];
    if ([[NSString stringWithFormat:@"%@",dict[@"sv_mcr_sate"]] isEqualToString:@"1"]) { // 是已经撤销
        //self.chexiaoBtn.titleLabel.textColor = BackgroundColor;
        [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [self.cancleBtn setTitle:@"已撤销" forState:UIControlStateNormal];
        self.cancleBtn.userInteractionEnabled = NO;
       //  self.chexiaoBtn.titleLabel.text = @"已撤销";
    }else{
        [SVUserManager loadUserInfo];
        NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
        NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
        NSString *Revoke_Selling_Cards = [NSString stringWithFormat:@"%@",AnalyticsDic[@"Revoke_Selling_Cards"]]; // 撤销计次
        if (kDictIsEmpty(sv_versionpowersDict)) { // 会员分析
            [self.cancleBtn setTitleColor: [UIColor colorWithHexString:@"ED7B47"] forState:UIControlStateNormal];
             [self.cancleBtn setTitle:@"撤销" forState:UIControlStateNormal];
        }else{
           
            if (kStringIsEmpty(Revoke_Selling_Cards)) {
                [self.cancleBtn setTitleColor: [UIColor colorWithHexString:@"ED7B47"] forState:UIControlStateNormal];
                 [self.cancleBtn setTitle:@"撤销" forState:UIControlStateNormal];
            }else{
                if ([Revoke_Selling_Cards isEqualToString:@"1"]) {
                    [self.cancleBtn setTitleColor: [UIColor colorWithHexString:@"ED7B47"] forState:UIControlStateNormal];
                     [self.cancleBtn setTitle:@"撤销" forState:UIControlStateNormal];
                }else{
                    [self.cancleBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                     [self.cancleBtn setTitle:@"撤销" forState:UIControlStateNormal];
                    self.cancleBtn.userInteractionEnabled = NO;
                }
            }
        }
       
     
    }
}




@end
