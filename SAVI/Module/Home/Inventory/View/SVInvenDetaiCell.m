//
//  SVInvenDetaiCell.m
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInvenDetaiCell.h"
#import "SVPandianDetailModel.h"
#import "SVduoguigeModel.h"
@interface SVInvenDetaiCell()
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *bcodeL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *shipanL;
@property (weak, nonatomic) IBOutlet UILabel *storeL;
@property (weak, nonatomic) IBOutlet UILabel *yingL;
@property (weak, nonatomic) IBOutlet UILabel *totleL;

@end
@implementation SVInvenDetaiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVPandianDetailModel *)model
{
    _model = model;
    self.numberL.text = [NSString stringWithFormat:@"%ld",model.number];
    self.bcodeL.text = model.sv_storestock_checkdetail_pbcode;
    self.bcodeL.adjustsFontSizeToFitWidth = YES;
    self.bcodeL.minimumScaleFactor = 0.5;
    
    if (kStringIsEmpty(model.sv_storestock_checkdetail_specs)) {
        self.nameL.text = model.sv_storestock_checkdetail_pname;
        self.nameL.adjustsFontSizeToFitWidth = YES;
        self.nameL.minimumScaleFactor = 0.5;
    }else{
        self.nameL.text = [NSString stringWithFormat:@"%@ (%@)",model.sv_storestock_checkdetail_pname,model.sv_storestock_checkdetail_specs];
        self.nameL.adjustsFontSizeToFitWidth = YES;
        self.nameL.minimumScaleFactor = 0.5;
    }
   
    self.priceL.text = [NSString stringWithFormat:@"￥%@",model.sv_storestock_checkdetail_checkprice];
    if ([model.sv_storestock_checkdetail_checknum isEqualToString:@"-1"]) {
        self.shipanL.text = @"--";
        self.totleL.text = @"--";
        self.yingL.text = @"--";
    }else{
        self.shipanL.text = model.sv_storestock_checkdetail_checknum;
        
        int yingCount = model.sv_storestock_checkdetail_checknum.intValue - model.sv_storestock_checkdetail_checkbeforenum.intValue;
        if (yingCount > 0) {
            self.yingL.text = [NSString stringWithFormat:@"盈%i",yingCount];
            self.yingL.textColor = [UIColor redColor];
            self.shipanL.textColor = [UIColor redColor];
            self.totleL.textColor = [UIColor redColor];
        }else if (yingCount == 0){
            self.yingL.text = @"平衡";
        }else{
            self.yingL.text = [NSString stringWithFormat:@"亏%i",abs(yingCount)];
            self.yingL.textColor = navigationBackgroundColor;
            self.shipanL.textColor = navigationBackgroundColor;
            self.totleL.textColor = navigationBackgroundColor;
        }
        double count = model.sv_storestock_checkdetail_checkprice.doubleValue * model.sv_storestock_checkdetail_checknum.doubleValue;
        double count2 = model.sv_storestock_checkdetail_checkprice.doubleValue * model.sv_storestock_checkdetail_checkbeforenum.doubleValue;
        double count3 = count - count2;
        self.totleL.text = [NSString stringWithFormat:@"￥%.2f",count3];
        self.totleL.adjustsFontSizeToFitWidth = YES;
        self.totleL.minimumScaleFactor = 0.5;
    }
    
   // model.sv_storestock_checkdetail_checkbeforenum = @"100";
    self.storeL.text = [NSString stringWithFormat:@"库存：%@",model.sv_storestock_checkdetail_checkbeforenum];
    self.storeL.adjustsFontSizeToFitWidth = YES;
    self.storeL.minimumScaleFactor = 0.5;

}

- (void)setDuoguigeModel:(SVduoguigeModel *)duoguigeModel
{
    _duoguigeModel = duoguigeModel;
    
    self.numberL.text = [NSString stringWithFormat:@"%ld",duoguigeModel.list_number];
    self.bcodeL.text = duoguigeModel.sv_p_barcode;
    self.bcodeL.adjustsFontSizeToFitWidth = YES;
    self.bcodeL.minimumScaleFactor = 0.5;
    self.nameL.text = duoguigeModel.sv_p_name;
    self.nameL.adjustsFontSizeToFitWidth = YES;
    self.nameL.minimumScaleFactor = 0.5;
    self.priceL.text = [NSString stringWithFormat:@"￥%@",duoguigeModel.sv_p_unitprice];
    if (kStringIsEmpty(duoguigeModel.FirmOfferNum)) {
        self.shipanL.text = @"--";
        self.yingL.text = @"--";
        self.totleL.text = @"--";
        self.yingL.textColor = [UIColor grayColor];
    }else{
        self.shipanL.text = duoguigeModel.FirmOfferNum;
        
        int yingCount = duoguigeModel.FirmOfferNum.intValue - duoguigeModel.sv_p_storage.intValue;
        if (yingCount > 0) {
              self.yingL.text = [NSString stringWithFormat:@"盈%i",yingCount];
            self.yingL.textColor = [UIColor redColor];
            self.shipanL.textColor = [UIColor redColor];
            self.totleL.textColor = [UIColor redColor];
        }else if (yingCount == 0){
            self.yingL.text = @"平衡";
        }else{
            self.yingL.text = [NSString stringWithFormat:@"亏%i",abs(yingCount)];
            self.yingL.textColor = navigationBackgroundColor;
            self.shipanL.textColor = navigationBackgroundColor;
            self.totleL.textColor = navigationBackgroundColor;
        }
        
            double count = duoguigeModel.sv_p_unitprice.doubleValue * duoguigeModel.FirmOfferNum.doubleValue;
            double count2 = duoguigeModel.sv_p_unitprice.doubleValue * duoguigeModel.sv_p_storage.doubleValue;
            double count3 = count - count2;
        self.totleL.text = [NSString stringWithFormat:@"￥%.2f",count3];
        self.totleL.adjustsFontSizeToFitWidth = YES;
        self.totleL.minimumScaleFactor = 0.5;
      //  self.totleL.textColor = [UIColor grayColor];
        
    }
    
    
   // self.shipanL.textColor = [UIColor grayColor];
//    // model.sv_storestock_checkdetail_checkbeforenum = @"100";
    self.storeL.text = [NSString stringWithFormat:@"库存：%@",duoguigeModel.sv_p_storage];
    
  
    

}

@end
