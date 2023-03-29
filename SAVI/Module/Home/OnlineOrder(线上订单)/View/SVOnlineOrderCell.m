//
//  SVOnlineOrderCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/3/17.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVOnlineOrderCell.h"
#import "SVOnlineTobeDelivered.h"

@interface SVOnlineOrderCell()
@property (weak, nonatomic) IBOutlet UILabel *daifahuoLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telNumber;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tihuoshijianLabel;

@end
@implementation SVOnlineOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.daifahuoLabel.layer.cornerRadius = 5;
    self.daifahuoLabel.layer.masksToBounds = YES;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setModel:(SVOnlineTobeDelivered *)model
{
    _model = model;
    
   
    NSString *dateTime = [NSString stringWithFormat:@"%@",model.wt_datetime];
    NSString *oneTime = [dateTime substringWithRange:NSMakeRange(5, 5)];
    NSString *twoTime = [dateTime substringWithRange:NSMakeRange(11, 8)];
    
    NSString *threeTime = [dateTime substringWithRange:NSMakeRange(0, 10)];
    NSString *fourTime = [dateTime substringWithRange:NSMakeRange(11, 5)];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",oneTime,twoTime];
    self.nameLabel.text = model.sv_receipt_name;
    self.telNumber.text = model.sv_receipt_phone;
    if ([model.sv_shipping_methods isEqualToString:@"0"]) {
        self.topNameLabel.text = @"到店自提";
        self.sureBtn.hidden = YES;
        self.tihuoshijianLabel.hidden = NO;
        self.tihuoshijianLabel.text = [NSString stringWithFormat:@"提货时间：%@ %@",threeTime,fourTime];
        self.daifahuoLabel.text = @"待自提";
    }else if ([model.sv_shipping_methods isEqualToString:@"1"]){
        self.topNameLabel.text = @"商家配送";
        self.sureBtn.hidden = NO;
        self.tihuoshijianLabel.hidden = YES;
        self.daifahuoLabel.text = @"待配送";
      //  self.tihuoshijianLabel.text = [NSString stringWithFormat:@"提货时间：%@",model.wt_datetime];
    }
    
//    if ([model.sv_delivery_status isEqualToString:@"0"]) {
//        self.daifahuoLabel.text = @"待确认";
//        self.daifahuoLabel.backgroundColor = navigationBackgroundColor;
//        self.sureBtn.hidden = NO;
//         [self.sureBtn setTitle:@"确认配送" forState:UIControlStateNormal];
//    }else if ([model.sv_delivery_status isEqualToString:@"1"]){
//        self.daifahuoLabel.text = @"待发货";
//        self.daifahuoLabel.backgroundColor = [UIColor colorWithHexString:@"4FBE59"];
//        self.sureBtn.hidden = NO;
//        [self.sureBtn setTitle:@"确认发货" forState:UIControlStateNormal];
//    }else if ([model.sv_delivery_status isEqualToString:@"2"]){
//        self.daifahuoLabel.text = @"已发货";
//        self.daifahuoLabel.backgroundColor = [UIColor colorWithHexString:@"4FBE59"];
//        self.sureBtn.hidden = NO;
//        [self.sureBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//    }else if ([model.sv_delivery_status isEqualToString:@"3"]){
//        self.daifahuoLabel.text = @"已收货";
//        self.daifahuoLabel.backgroundColor = [UIColor colorWithHexString:@"4FBE59"];
//        self.sureBtn.hidden = YES;
//      //[self.sureBtn setTitle:@"确认发货" forState:UIControlStateNormal];
//    }else if ([model.sv_delivery_status isEqualToString:@"4"]){
//        self.daifahuoLabel.text = @"已退货";
//        self.daifahuoLabel.backgroundColor = [UIColor colorWithHexString:@"4FBE59"];
//        self.sureBtn.hidden = YES;
//     //   [self.sureBtn setTitle:@"确认发货" forState:UIControlStateNormal];
//    }else if ([model.sv_delivery_status isEqualToString:@"5"]){
//        self.daifahuoLabel.text = @"已完成";
//        self.daifahuoLabel.backgroundColor = [UIColor colorWithHexString:@"4FBE59"];
//        self.sureBtn.hidden = YES;
//       // [self.sureBtn setTitle:@"确认发货" forState:UIControlStateNormal];
//    }
 

    
    self.contentLabel.text = model.sv_receipt_address;
    
}


@end
