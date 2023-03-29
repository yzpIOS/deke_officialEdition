//
//  SVDetailsHistoryCell.m
//  SAVI
//
//  Created by Sorgle on 2017/6/27.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVDetailsHistoryCell.h"
#import "JJPhotoManeger.h"

@interface SVDetailsHistoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_unit;
//@property (weak, nonatomic) IBOutlet UILabel *sv_p_specs;
@property (weak, nonatomic) IBOutlet UILabel *Discount; // 折扣
@property (weak, nonatomic) IBOutlet UILabel *salesAmount; // 销售金额
@property(nonatomic,strong)NSMutableArray *imageArr;

@property (weak, nonatomic) IBOutlet UILabel *barCode;
// 优惠金额
@property (weak, nonatomic) IBOutlet UILabel *PreferentialAmount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waresNameCenterY;

@end

@implementation SVDetailsHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.waresName.adjustsFontSizeToFitWidth = YES;
       self.waresName.minimumScaleFactor = 0.5;
       self.iconView.layer.cornerRadius = 5;
       //        self.sv_p_specs.adjustsFontSizeToFitWidth = YES;
       //        self.sv_p_specs.minimumScaleFactor = 0.5;
       self.iconView.layer.masksToBounds = YES;
    NSString *sv_p_name = dict[@"sv_p_name"];
    if (kStringIsEmpty(sv_p_name)) {
        self.waresName.text = dict[@"sv_p_name"];
    }else{
        self.waresName.text = dict[@"product_name"];
    }
    self.returnButton.hidden = YES;
    NSArray *sv_p_imagesArray = dict[@"sv_p_images"];
    if (!kArrayIsEmpty(sv_p_imagesArray)) {
        NSDictionary *codeDic = sv_p_imagesArray[0];
        NSString *code = codeDic[@"code"];
        if (![SVTool isBlankString:code]) {
              [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,code]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
          }else{
              self.iconView.image = [UIImage imageNamed:@"foodimg"];
          }
    }else{
        self.iconView.image = [UIImage imageNamed:@"foodimg"];
    }
    
    NSString *extractedExpr = [NSString stringWithFormat:@"%.2f",[dict[@"product_price"] doubleValue]];
       self.money.text = extractedExpr;
    double count = [dict[@"product_num"] doubleValue] + [dict[@"sv_p_weight"] doubleValue];
    self.number.text = [NSString stringWithFormat:@"%.2f",count];
   self.salesAmount.text = [NSString stringWithFormat:@"%.2f元",[dict[@"product_total"] floatValue]];
   self.sv_p_unit.text = dict[@"sv_p_unit"];
  
    
    
}

- (void)setSalesDetailsListModel:(SVSalesDetailsList *)salesDetailsListModel
{
    _salesDetailsListModel = salesDetailsListModel;
    
    self.waresName.adjustsFontSizeToFitWidth = YES;
    self.waresName.minimumScaleFactor = 0.5;
    self.Discount.adjustsFontSizeToFitWidth = YES;
    self.Discount.minimumScaleFactor = 0.5;
    self.PreferentialAmount.adjustsFontSizeToFitWidth = YES;
    self.PreferentialAmount.minimumScaleFactor = 0.5;
    self.money.adjustsFontSizeToFitWidth = YES;
    self.money.minimumScaleFactor = 0.5;
    self.barCode.adjustsFontSizeToFitWidth = YES;
    self.barCode.minimumScaleFactor = 0.5;
    self.iconView.layer.cornerRadius = 5;
    //        self.sv_p_specs.adjustsFontSizeToFitWidth = YES;
    //        self.sv_p_specs.minimumScaleFactor = 0.5;
    self.iconView.layer.masksToBounds = YES;

    
    if (![SVTool isBlankString:salesDetailsListModel.sv_p_specs]) {
        self.waresName.text = [NSString stringWithFormat:@"%@  %@",salesDetailsListModel.product_name,salesDetailsListModel.sv_p_specs];
    }else{
        self.waresName.text = [NSString stringWithFormat:@"%@",salesDetailsListModel.product_name];
    }
    [SVUserManager loadUserInfo];
    
    if ([salesDetailsListModel.product_name containsString:@"(套餐)"] || [[SVUserManager shareInstance].dec_payment_method isEqualToString:@"11"]) {
        self.returnButton.hidden = YES;
    }else{
        self.returnButton.hidden = NO;
    }
    
    self.barCode.text = salesDetailsListModel.sv_p_barcode;
    NSString *extractedExpr = [NSString stringWithFormat:@"%.2f",salesDetailsListModel.product_price];
    
    self.money.text = [NSString stringWithFormat:@"原价￥%@",extractedExpr];
    self.money.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.money.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.money.attributedText = newPrice;
   
    
    float count = salesDetailsListModel.product_num;
    if (kStringIsEmpty(salesDetailsListModel.sv_p_unit)) {
        self.number.text = [NSString stringWithFormat:@"x%.2f",count];
    }else{
        self.number.text = [NSString stringWithFormat:@"%.2f%@",count,salesDetailsListModel.sv_p_unit];
    }
   
    
    if (![SVTool isBlankString:salesDetailsListModel.sv_p_images2]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,salesDetailsListModel.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"foodimg"];
    }
    
    _imageArr = [NSMutableArray array];
    //        _picUrlArr = [NSMutableArray array];
    [_imageArr addObject:self.iconView];
    self.iconView.userInteractionEnabled = YES;
    //添加点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tap:)];
    [self.iconView addGestureRecognizer:tap];
    double discountAmount =(salesDetailsListModel.product_price - salesDetailsListModel.product_unitprice) *salesDetailsListModel.product_num;
    if (discountAmount != 0) {
        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠：%.2f",discountAmount];
        
    }else{
        [self noDiscount];
    }
    
    if (salesDetailsListModel.sv_preferential_data != NULL) {
        self.Discount.hidden = NO;
        NSArray *sv_preferential_data_array = [SVTool arrayWithJsonString:salesDetailsListModel.sv_preferential_data];
        if (!kArrayIsEmpty(sv_preferential_data_array) && [sv_preferential_data_array isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = (NSDictionary *)sv_preferential_data_array[0];
            if (!kDictIsEmpty(dict)) {
                NSString *t= [NSString stringWithFormat:@"%@",dict[@"t"]];
                NSString *v= [NSString stringWithFormat:@"%@",dict[@"v"]];
                NSString *m= [NSString stringWithFormat:@"%@",dict[@"m"]];
                NSString *s= [NSString stringWithFormat:@"%@",dict[@"s"]];
                self.Discount.text = s;
            }
        }else{
            self.Discount.hidden = YES;
        }
    }else{
        self.Discount.hidden = YES;
    }
    
//    NSLog(@"self.cardno = %ld",self.cardno);
//    NSString *s=[NSString stringWithFormat:@"%@",dict[@"s"]];
//
//    if (self.cardno == 0) { // 表示没有选择会员  [detalisHistoryModel.product_discount
//        double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] *count - [detalisHistoryModel.product_total_bak floatValue];
//        NSArray *sv_preferential_data = detalisHistoryModel.sv_preferential_data;
//        NSLog(@"sv_preferential_data = %@",sv_preferential_data);
//
//        if (PreferentialAmount != 0) {
//            if (!kArrayIsEmpty(sv_preferential_data) && [sv_preferential_data isKindOfClass:[NSArray class]]) {
//                NSDictionary *dict = (NSDictionary *)sv_preferential_data[0];
//                if (!kDictIsEmpty(dict)) {
//                    NSString *t= [NSString stringWithFormat:@"%@",dict[@"t"]];
//                    NSString *v= [NSString stringWithFormat:@"%@",dict[@"v"]];
//                    NSString *m= [NSString stringWithFormat:@"%@",dict[@"m"]];
//                    NSString *s= [NSString stringWithFormat:@"%@",dict[@"s"]];
//                    if (t.doubleValue == 4) { // 散客有改价要显示出来
//                        self.Discount.text = [NSString stringWithFormat:@"%@%.2f",s,v.doubleValue];
//                        self.PreferentialAmount.textColor = [UIColor grayColor];
//                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
//                    }else if (t.doubleValue == 6){
//                        self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue];
//                        self.PreferentialAmount.textColor = [UIColor grayColor];
//                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
//                    }else{
//                        [self oldDiscountPreferentialAmount:PreferentialAmount];
//                    }
//                }else{
//                    [self oldDiscountPreferentialAmount:PreferentialAmount];
//                }
//
//            }else{
//                [self oldDiscountPreferentialAmount:PreferentialAmount];
//            }
//
//
//        }
//    else{
//            [self noDiscount];
//        }
//
//    }else{
//        NSArray *sv_preferential_data = detalisHistoryModel.sv_preferential_data;
//        NSLog(@"sv_preferential_data = %@",sv_preferential_data);
//        if (!kArrayIsEmpty(sv_preferential_data) && [sv_preferential_data isKindOfClass:[NSArray class]]) {
//            NSDictionary *dict = (NSDictionary *)sv_preferential_data[0];
//            if (!kDictIsEmpty(dict)) {
//                NSString *t= [NSString stringWithFormat:@"%@",dict[@"t"]];
//                NSString *v= [NSString stringWithFormat:@"%@",dict[@"v"]];
//                NSString *m= [NSString stringWithFormat:@"%@",dict[@"m"]];
//                NSString *s= [NSString stringWithFormat:@"%@",dict[@"s"]];
//                if (t.doubleValue == 1) { // 是会员折扣
//                    if (v.doubleValue == 0 || v.doubleValue == 1) {
//                       // [self noDiscount];
//                        double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] - [detalisHistoryModel.product_total_bak floatValue];
//                        if (PreferentialAmount > 0) {
//                            [self oldDiscountPreferentialAmount:PreferentialAmount];
//
//                        }else{
//                            [self noDiscount];
//                        }
//                    }else{
//                        if (v.doubleValue > 1) {
//                            self.Discount.text = [NSString stringWithFormat:@"%@折",s];
//                        }else{
//                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
//                        }
//
//                        self.PreferentialAmount.textColor = [UIColor grayColor];
//                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
//                    }
//
//                }else if (t.doubleValue == 2){ // 分类折扣
//                    if (v.doubleValue == 0 || v.doubleValue == 1) {
//                       // [self noDiscount];
//                        double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] - [detalisHistoryModel.product_total_bak floatValue];
//                        if (PreferentialAmount > 0) {
//                            [self oldDiscountPreferentialAmount:PreferentialAmount];
//
//                        }else{
//                            [self noDiscount];
//                        }
//                    }else{
//                       // self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
//                        if (v.doubleValue > 1) {
//                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue];
//                        }else{
//                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
//                        }
//                        self.PreferentialAmount.textColor = [UIColor grayColor];
//                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
//                    }
//                }else if (t.doubleValue == 4){ // 会员价
//                    self.Discount.text = [NSString stringWithFormat:@"%@%.2f",s,v.doubleValue];
//                    self.PreferentialAmount.textColor = [UIColor grayColor];
//                    self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
//                }else if (t.doubleValue == 5){ // 最低单价
//                    self.Discount.text = [NSString stringWithFormat:@"%@%.2f",s,v.doubleValue];
//                    self.PreferentialAmount.textColor = [UIColor grayColor];
//                    self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
//                }else if (t.doubleValue == 6){ // 最低折扣
//                    if (v.doubleValue == 0 || v.doubleValue == 1) {
//                       // [self noDiscount];
//                        double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] - [detalisHistoryModel.product_total_bak floatValue];
//                        if (PreferentialAmount > 0) {
//                            [self oldDiscountPreferentialAmount:PreferentialAmount];
//
//                        }else{
//                            [self noDiscount];
//                        }
//                    }else{
//                       // self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
//                        if (v.doubleValue > 1) {
//                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue];
//                        }else{
//                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
//                        }
//                        self.PreferentialAmount.textColor = [UIColor grayColor];
//                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
//                    }
//                }else{ // 3促销
//                    self.Discount.text = [NSString stringWithFormat:@"%@%.2f",s,v.doubleValue];
//                    self.PreferentialAmount.textColor = [UIColor grayColor];
//                    self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
//                }
//            }else{
//                [self noDiscount];
//            }
//
//        }else{
//            double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] - [detalisHistoryModel.product_total_bak floatValue];
//            if (PreferentialAmount > 0) {
//                [self oldDiscountPreferentialAmount:PreferentialAmount];
//
//            }else{
//                [self noDiscount];
//            }
//
//
//
//        }
//    }
    
   
    
    self.salesAmount.text = [NSString stringWithFormat:@"￥%.2f",salesDetailsListModel.product_total];
}

-(void)setDetalisHistoryModel:(SVDetailsHistoryModel *)detalisHistoryModel{
    
    _detalisHistoryModel = detalisHistoryModel;
    self.waresName.adjustsFontSizeToFitWidth = YES;
    self.waresName.minimumScaleFactor = 0.5;
    self.Discount.adjustsFontSizeToFitWidth = YES;
    self.Discount.minimumScaleFactor = 0.5;
    self.PreferentialAmount.adjustsFontSizeToFitWidth = YES;
    self.PreferentialAmount.minimumScaleFactor = 0.5;
    self.money.adjustsFontSizeToFitWidth = YES;
    self.money.minimumScaleFactor = 0.5;
    self.barCode.adjustsFontSizeToFitWidth = YES;
    self.barCode.minimumScaleFactor = 0.5;
    self.iconView.layer.cornerRadius = 5;
    //        self.sv_p_specs.adjustsFontSizeToFitWidth = YES;
    //        self.sv_p_specs.minimumScaleFactor = 0.5;
    self.iconView.layer.masksToBounds = YES;

    
    if (![SVTool isBlankString:detalisHistoryModel.sv_p_specs]) {
        self.waresName.text = [NSString stringWithFormat:@"%@  %@",detalisHistoryModel.product_name,detalisHistoryModel.sv_p_specs];
    }else{
        self.waresName.text = [NSString stringWithFormat:@"%@",detalisHistoryModel.product_name];
    }
    [SVUserManager loadUserInfo];
    
    if ([detalisHistoryModel.product_name containsString:@"(套餐)"] || [[SVUserManager shareInstance].dec_payment_method isEqualToString:@"11"]) {
        self.returnButton.hidden = YES;
    }else{
        self.returnButton.hidden = NO;
    }
    
    self.barCode.text = detalisHistoryModel.sv_p_artno?:detalisHistoryModel.sv_p_barcode;
    
    
    NSString *extractedExpr = [NSString stringWithFormat:@"%.2f",[detalisHistoryModel.product_price doubleValue]];
    
    self.money.text = [NSString stringWithFormat:@"原价￥%@",extractedExpr];
    self.money.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.money.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.money.attributedText = newPrice;
   
    
    float count = detalisHistoryModel.product_num_bak.floatValue + detalisHistoryModel.sv_p_weight_bak.floatValue;
    if (kStringIsEmpty(_detalisHistoryModel.sv_p_unit)) {
        self.number.text = [NSString stringWithFormat:@"x%.2f",count];
    }else{
        self.number.text = [NSString stringWithFormat:@"%.2f%@",count,_detalisHistoryModel.sv_p_unit];
    }
   
    
    if (![SVTool isBlankString:detalisHistoryModel.sv_p_images2]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,detalisHistoryModel.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"foodimg"];
    }
    
    _imageArr = [NSMutableArray array];
    //        _picUrlArr = [NSMutableArray array];
    [_imageArr addObject:self.iconView];
    self.iconView.userInteractionEnabled = YES;
    //添加点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tap:)];
    [self.iconView addGestureRecognizer:tap];
    
    NSLog(@"self.cardno = %ld",self.cardno);
   // NSString *s=[NSString stringWithFormat:@"%@",dict[@"s"]];
    
    if (self.cardno == 0) { // 表示没有选择会员  [detalisHistoryModel.product_discount
        double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] *count - [detalisHistoryModel.product_total_bak floatValue];
        NSArray *sv_preferential_data = detalisHistoryModel.sv_preferential_data;
        NSLog(@"sv_preferential_data = %@",sv_preferential_data);
        
        if (PreferentialAmount != 0) {
            if (!kArrayIsEmpty(sv_preferential_data) && [sv_preferential_data isKindOfClass:[NSArray class]]) {
                NSDictionary *dict = (NSDictionary *)sv_preferential_data[0];
                if (!kDictIsEmpty(dict)) {
                    NSString *t= [NSString stringWithFormat:@"%@",dict[@"t"]];
                    NSString *v= [NSString stringWithFormat:@"%@",dict[@"v"]];
                    NSString *m= [NSString stringWithFormat:@"%@",dict[@"m"]];
                    NSString *s= [NSString stringWithFormat:@"%@",dict[@"s"]];
                    if (t.doubleValue == 4) { // 散客有改价要显示出来
                        self.Discount.text = [NSString stringWithFormat:@"%@%.2f",s,v.doubleValue];
                        self.PreferentialAmount.textColor = [UIColor grayColor];
                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
                    }else if (t.doubleValue == 6){
                        self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue];
                        self.PreferentialAmount.textColor = [UIColor grayColor];
                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
                    }else{
                        [self oldDiscountPreferentialAmount:PreferentialAmount];
                    }
                }else{
                    [self oldDiscountPreferentialAmount:PreferentialAmount];
                }
                
            }else{
                [self oldDiscountPreferentialAmount:PreferentialAmount];
            }
           
            
        }
    else{
            [self noDiscount];
        }
       
    }else{
        NSArray *sv_preferential_data = detalisHistoryModel.sv_preferential_data;
        NSLog(@"sv_preferential_data = %@",sv_preferential_data);
        if (!kArrayIsEmpty(sv_preferential_data) && [sv_preferential_data isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = (NSDictionary *)sv_preferential_data[0];
            if (!kDictIsEmpty(dict)) {
                NSString *t= [NSString stringWithFormat:@"%@",dict[@"t"]];
                NSString *v= [NSString stringWithFormat:@"%@",dict[@"v"]];
                NSString *m= [NSString stringWithFormat:@"%@",dict[@"m"]];
                NSString *s= [NSString stringWithFormat:@"%@",dict[@"s"]];
                if (t.doubleValue == 1) { // 是会员折扣
                    if (v.doubleValue == 0 || v.doubleValue == 1) {
                       // [self noDiscount];
                        double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] - [detalisHistoryModel.product_total_bak floatValue];
                        if (PreferentialAmount > 0) {
                            [self oldDiscountPreferentialAmount:PreferentialAmount];
                            
                        }else{
                            [self noDiscount];
                        }
                    }else{
                        if (v.doubleValue > 1) {
                            self.Discount.text = [NSString stringWithFormat:@"%@折",s];
                        }else{
                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
                        }
                       
                        self.PreferentialAmount.textColor = [UIColor grayColor];
                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
                    }
                  
                }else if (t.doubleValue == 2){ // 分类折扣
                    if (v.doubleValue == 0 || v.doubleValue == 1) {
                       // [self noDiscount];
                        double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] - [detalisHistoryModel.product_total_bak floatValue];
                        if (PreferentialAmount > 0) {
                            [self oldDiscountPreferentialAmount:PreferentialAmount];
                            
                        }else{
                            [self noDiscount];
                        }
                    }else{
                       // self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
                        if (v.doubleValue > 1) {
                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue];
                        }else{
                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
                        }
                        self.PreferentialAmount.textColor = [UIColor grayColor];
                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
                    }
                }else if (t.doubleValue == 4){ // 会员价
                    self.Discount.text = [NSString stringWithFormat:@"%@%.2f",s,v.doubleValue];
                    self.PreferentialAmount.textColor = [UIColor grayColor];
                    self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
                }else if (t.doubleValue == 5){ // 最低单价
                    self.Discount.text = [NSString stringWithFormat:@"%@%.2f",s,v.doubleValue];
                    self.PreferentialAmount.textColor = [UIColor grayColor];
                    self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
                }else if (t.doubleValue == 6){ // 最低折扣
                    if (v.doubleValue == 0 || v.doubleValue == 1) {
                       // [self noDiscount];
                        double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] - [detalisHistoryModel.product_total_bak floatValue];
                        if (PreferentialAmount > 0) {
                            [self oldDiscountPreferentialAmount:PreferentialAmount];
                            
                        }else{
                            [self noDiscount];
                        }
                    }else{
                       // self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
                        if (v.doubleValue > 1) {
                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue];
                        }else{
                            self.Discount.text = [NSString stringWithFormat:@"%@%.2f折",s,v.doubleValue * 10];
                        }
                        self.PreferentialAmount.textColor = [UIColor grayColor];
                        self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
                    }
                }else{ // 3促销
                    self.Discount.text = [NSString stringWithFormat:@"%@%.2f",s,v.doubleValue];
                    self.PreferentialAmount.textColor = [UIColor grayColor];
                    self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%@",m];
                }
            }else{
                [self noDiscount];
            }
           
        }else{
            double PreferentialAmount =[detalisHistoryModel.product_price doubleValue] - [detalisHistoryModel.product_total_bak floatValue];
            if (PreferentialAmount > 0) {
                [self oldDiscountPreferentialAmount:PreferentialAmount];
                
            }else{
                [self noDiscount];
            }
            
           
           
        }
    }
    
   
    
    self.salesAmount.text = [NSString stringWithFormat:@"￥%.2f",[detalisHistoryModel.product_total_bak floatValue]];
   // self.sv_p_unit.text = ;
    //   self.sv_p_specs.text = _detalisHistoryModel.sv_p_specs;
    
    
    
}
/**
 适配旧的优惠
 */

- (void)oldDiscountPreferentialAmount:(double)PreferentialAmount{
    if (self.detalisHistoryModel.product_discount.doubleValue !=1 && self.detalisHistoryModel.product_discount.doubleValue !=0) {
        if (self.detalisHistoryModel.product_discount.doubleValue > 1) {
            self.Discount.text = [NSString stringWithFormat:@"整单%.2f折",self.detalisHistoryModel.product_discount.doubleValue];
        }else{
            self.Discount.text = [NSString stringWithFormat:@"整单%.2f折",self.detalisHistoryModel.product_discount.doubleValue *10];
        }
       
    }else{
        if (self.detalisHistoryModel.product_discount.doubleValue > 1) {
            self.Discount.text = [NSString stringWithFormat:@"会员%.2f折",self.detalisHistoryModel.sv_member_discount.doubleValue];
        }else{
//            self.Discount.text = [NSString stringWithFormat:@"会员%.2f折",self.detalisHistoryModel.sv_member_discount.doubleValue *10];
            [self.Discount mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(0);
                    
            }];
        }
        
    }
    
    
    self.PreferentialAmount.textColor = [UIColor grayColor];
    self.PreferentialAmount.text = [NSString stringWithFormat:@"优惠￥%.2f",PreferentialAmount];
}


/**
 没有优惠
 */
- (void)noDiscount{
    if (kStringIsEmpty(self.barCode.text)) {
        [self.waresName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);

        }];
    }else{
        [self.waresName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY).offset(-10);

        }];
        
        [self.barCode mas_updateConstraints:^(MASConstraintMaker *make) {
          //  make.centerY.mas_equalTo(self.mas_centerY);
            make.top.mas_equalTo(self.waresName.mas_bottom).offset(0);
           // make.bottom.mas_equalTo(self.iconView.mas_bottom);
        }];
    }
   

    
    
    [self.Discount mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            
    }];
    
    [self.number mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.mas_centerY);
            
    }];
    
    [self.PreferentialAmount mas_updateConstraints:^(MASConstraintMaker *make) {
         make.height.mas_equalTo(0);
            
    }];
    
    [self.salesAmount mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
            
    }];
    
    [self.money mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
            
    }];
    
    
    
//    if (self.cardno != 0) { // 表示没有选择会员  [detalisHistoryModel.product_discount isEqualToString:@"1"] ||
//        if (self.detalisHistoryModel.sv_p_memberprice == 0) {
//            if ( [self.detalisHistoryModel.product_discount isEqualToString:@"1"] ||[self.detalisHistoryModel.product_discount isEqualToString:@"0"]) {
//               // self.Discount.text = @"无折扣";
//            }else{
//                self.Discount.text = [NSString stringWithFormat:@"%.3f折",[self.detalisHistoryModel.product_discount doubleValue]];
//            }
//        }else{
//           // self.Discount.text = [NSString stringWithFormat:@"会员价(%.2f)",detalisHistoryModel.sv_p_memberprice];
//        }
//    }else{ // [detalisHistoryModel.product_discount isEqualToString:@"1"] ||
//        if ( [self.detalisHistoryModel.product_discount isEqualToString:@"1"] ||[self.detalisHistoryModel.product_discount isEqualToString:@"0"]) {
//          //  self.Discount.text = @"无折扣";
//        }else{
//            self.Discount.text = [NSString stringWithFormat:@"%.3f折",[self.detalisHistoryModel.product_discount doubleValue]];
//        }
//    }
}


//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    // [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    [mg showLocalPhotoViewer:_imageArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    // NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

@end
