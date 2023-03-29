//
//  SVCardFlowChartCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/1/16.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVCardFlowChartCell.h"

@interface SVCardFlowChartCell()
@property (weak, nonatomic) IBOutlet UILabel *liushuihao;
@property (weak, nonatomic) IBOutlet UILabel *xiangmumingcheng;
@property (weak, nonatomic) IBOutlet UILabel *huiyuanmingcheng;
@property (weak, nonatomic) IBOutlet UILabel *koucicishu;

@end
@implementation SVCardFlowChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.liushuihao.adjustsFontSizeToFitWidth = YES;
    self.liushuihao.minimumScaleFactor = 0.5;
    
    self.xiangmumingcheng.adjustsFontSizeToFitWidth = YES;
    self.xiangmumingcheng.minimumScaleFactor = 0.5;
    
    self.huiyuanmingcheng.adjustsFontSizeToFitWidth = YES;
    self.huiyuanmingcheng.minimumScaleFactor = 0.5;
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.liushuihao.text = dict[@"order_running_id"];
    self.xiangmumingcheng.text = dict[@"sv_p_name"];
    self.huiyuanmingcheng.text = dict[@"sv_mr_name"];
    self.koucicishu.text = dict[@"product_num"];
    
    if ([[NSString stringWithFormat:@"%@",dict[@"sv_mcr_sate"]] isEqualToString:@"1"]) { // 是已经撤销
        //self.chexiaoBtn.titleLabel.textColor = BackgroundColor;
        [self.cancleBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [self.cancleBtn setTitle:@"已撤销" forState:UIControlStateNormal];
        self.cancleBtn.userInteractionEnabled = NO;
        //  self.chexiaoBtn.titleLabel.text = @"已撤销";
    }else{
        //        [self.chexiaoBtn setTitleColor:[UIColor colorWithHexString:@"ED7B47"] forState:UIControlStateNormal];
        //        self.chexiaoBtn.titleLabel.textColor = [UIColor colorWithHexString:@"ED7B47"];
//        [self.cancleBtn setTitleColor: [UIColor colorWithHexString:@"ED7B47"] forState:UIControlStateNormal];
//        [self.cancleBtn setTitle:@"撤销" forState:UIControlStateNormal];
        // self.chexiaoBtn.titleLabel.text = @"撤销";
        //  [self.chexiaoBtn setTitle:@"撤销" forState:UIControlStateNormal];
        
        [SVUserManager loadUserInfo];
        NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
        NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
        NSString *RevokeRecharge = [NSString stringWithFormat:@"%@",AnalyticsDic[@"RevokeRecharge"]]; // 撤销计次
        if (kDictIsEmpty(sv_versionpowersDict)) { // 会员分析
            [self.cancleBtn setTitleColor: [UIColor colorWithHexString:@"ED7B47"] forState:UIControlStateNormal];
             [self.cancleBtn setTitle:@"撤销" forState:UIControlStateNormal];
        }else{
           
            if (kStringIsEmpty(RevokeRecharge)) {
                [self.cancleBtn setTitleColor: [UIColor colorWithHexString:@"ED7B47"] forState:UIControlStateNormal];
                 [self.cancleBtn setTitle:@"撤销" forState:UIControlStateNormal];
            }else{
                if ([RevokeRecharge isEqualToString:@"1"]) {
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
