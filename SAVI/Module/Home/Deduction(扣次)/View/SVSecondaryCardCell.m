//
//  SVSecondaryCardCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/10/28.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVSecondaryCardCell.h"
#import "SVCardRechargeInfoModel.h"
@interface SVSecondaryCardCell()
@property (weak, nonatomic) IBOutlet UIView *outView;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;


@end

@implementation SVSecondaryCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.outView.layer.cornerRadius = 10;
    self.outView.layer.masksToBounds = YES;
    self.chongBtn.layer.cornerRadius = 20;
    self.chongBtn.layer.masksToBounds = YES;
}

- (void)setModel:(SVCardRechargeInfoModel *)model
{
    
    _model = model;

    if (self.selectVC == 1) {
        self.chongBtn.hidden = YES;
        
        self.money.text = model.sv_p_unitprice;
        self.name.text = model.sv_p_name;
        NSString *startTime = [model.sv_dis_startdate substringToIndex:10];
        NSString *endTime = [model.sv_dis_enddate substringToIndex:10];
        if (![SVTool isBlankString:model.sv_p_images2]) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_p_images2]]];
            self.money.textColor = [UIColor whiteColor];
            self.name.textColor = [UIColor whiteColor];
            self.time.textColor = [UIColor whiteColor];
          
        } else {
            
            self.iconImage.image = nil;
            self.money.textColor = GlobalFontColor;
            self.name.textColor = GlobalFontColor;
            self.time.textColor = GlobalFontColor;
          
        }
        
        self.time.text = [NSString stringWithFormat:@"活动时间：%@至%@",startTime,endTime];
        
    }else if (self.selectVC == 2){
         self.chongBtn.hidden = YES;
        self.money.text = model.sv_p_unitprice;
        self.name.text = model.sv_p_name;
        if (![SVTool isBlankString:model.sv_p_images]) {
          //  if (!kStringIsEmpty(result)) {
                NSData *data = [model.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
              
                NSArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"arr = %@",arr);
        
            if (!kArrayIsEmpty(arr)) {
                NSDictionary *dic = arr[0];
              //  if ([self.goodsModel.sv_p_images containsString:@"UploadImg"]) {
                    NSString *UploadImg = [NSString stringWithFormat:@"%@",dic[@"code"]];
                if (![UploadImg containsString:@"UploadImg"]) {
                    self.iconImage.image = nil;
                   self.money.textColor = GlobalFontColor;
                   self.name.textColor = GlobalFontColor;
                   self.time.textColor = GlobalFontColor;
                }else{
                    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:dic[@"code"]]]];
                 
                   self.money.textColor = [UIColor whiteColor];
                   self.name.textColor = [UIColor whiteColor];
                   self.time.textColor = [UIColor whiteColor];
                }
            }else{
                 self.iconImage.image = nil;
                self.money.textColor = GlobalFontColor;
                self.name.textColor = GlobalFontColor;
                self.time.textColor = GlobalFontColor;
            }
           
        } else {
            self.money.textColor = GlobalFontColor;
            self.name.textColor = GlobalFontColor;
            self.time.textColor = GlobalFontColor;
            self.iconImage.image = nil;
        }
        
        self.time.text = [NSString stringWithFormat:@"充次时间：%@",model.buy_date];
    }else{
        self.chongBtn.hidden = NO;
        self.money.text = model.sv_p_unitprice;
        self.name.text = model.sv_p_name;
        NSString *startTime = [model.sv_dis_startdate substringToIndex:10];
        NSString *endTime = [model.sv_dis_enddate substringToIndex:10];
        if (![SVTool isBlankString:model.sv_p_images2]) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_p_images2]]];
            
            self.money.textColor = [UIColor whiteColor];
            self.name.textColor = [UIColor whiteColor];
            self.time.textColor = [UIColor whiteColor];
           
        } else {
            
            self.iconImage.image = nil;
            self.money.textColor = GlobalFontColor;
            self.name.textColor = GlobalFontColor;
            self.time.textColor = GlobalFontColor;
           
        }
        
        self.time.text = [NSString stringWithFormat:@"活动时间：%@至%@",startTime,endTime];
    }
    
 
}
- (IBAction)chongBtnClick:(id)sender {
    if (self.model_block) {
        self.model_block(_model);
    }
}

@end
