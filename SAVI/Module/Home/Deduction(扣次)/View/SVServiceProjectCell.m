//
//  SVServiceProjectCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/21.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVServiceProjectCell.h"
#import "HLPopTableView.h"
#import "UIView+HLExtension.h"
#import "SVduoguigeModel.h"
@interface SVServiceProjectCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIView *purchaseView;
@property (weak, nonatomic) IBOutlet UIView *giveView;

@property (weak, nonatomic) IBOutlet UIView *priceView;

@property (weak, nonatomic) IBOutlet UIView *termOfValidityView;

@property (weak, nonatomic) IBOutlet UILabel *purchaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *giveLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *termOfValidityLabel;

@property(retain,nonatomic) NSMutableString *string;  //NSMutableString用来处理可变对象，如需要处理字符串并更改字符串中的字符
@property(retain,nonatomic) NSMutableString *stringNumber;
@property (weak, nonatomic) IBOutlet UIButton *yearBtn;
@property (nonatomic,strong) NSString *selectTime;



@property (nonatomic,assign) NSInteger selctNumber;
@end

@implementation SVServiceProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    //    self.icon.layer.cornerRadius = 35;
    //    self.icon.layer.masksToBounds = YES;
    self.btn_7.layer.cornerRadius = 25;
    self.btn_7.layer.masksToBounds = YES;
    
    self.btn_8.layer.cornerRadius = 25;
    self.btn_8.layer.masksToBounds = YES;
    self.btn_9.layer.cornerRadius = 25;
    self.btn_9.layer.masksToBounds = YES;
    self.btn_4.layer.cornerRadius = 25;
    self.btn_4.layer.masksToBounds = YES;
    self.btn_5.layer.cornerRadius = 25;
    self.btn_5.layer.masksToBounds = YES;
    self.btn_6.layer.cornerRadius = 25;
    self.btn_6.layer.masksToBounds = YES;
    self.btn_1.layer.cornerRadius = 25;
    self.btn_1.layer.masksToBounds = YES;
    self.btn_2.layer.cornerRadius = 25;
    self.btn_2.layer.masksToBounds = YES;
    self.btn_3.layer.cornerRadius = 25;
    self.btn_3.layer.masksToBounds = YES;
    self.btn_circle.layer.cornerRadius = 25;
    self.btn_circle.layer.masksToBounds = YES;
    self.btn_0.layer.cornerRadius = 25;
    self.btn_0.layer.masksToBounds = YES;
    self.btn_clear_0.layer.cornerRadius = 25;
    self.btn_clear_0.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 5;
    self.icon.layer.masksToBounds = YES;
    
    self.purchaseView.layer.cornerRadius = 15;
    self.purchaseView.layer.masksToBounds = YES;
    self.giveView.layer.cornerRadius = 15;
    self.giveView.layer.masksToBounds = YES;
    
    self.priceView.layer.cornerRadius = 15;
    self.priceView.layer.masksToBounds = YES;
    self.termOfValidityView.layer.cornerRadius = 15;
    self.termOfValidityView.layer.masksToBounds = YES;
    
    self.purchaseLabel.adjustsFontSizeToFitWidth = YES;
    self.purchaseLabel.minimumScaleFactor = 0.5;
    self.giveLabel.adjustsFontSizeToFitWidth = YES;
    self.giveLabel.minimumScaleFactor = 0.5;
    
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    self.priceLabel.minimumScaleFactor = 0.5;
    self.termOfValidityLabel.adjustsFontSizeToFitWidth = YES;
    self.termOfValidityLabel.minimumScaleFactor = 0.5;
    
    UITapGestureRecognizer *purchaseViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(purchaseViewTapClick)];
    self.purchaseView.userInteractionEnabled = YES;
    [self.purchaseView addGestureRecognizer:purchaseViewTap];
    
    self.purchaseView.layer.borderWidth = 1;
    self.purchaseView.layer.borderColor = navigationBackgroundColor.CGColor;
    
    
    UITapGestureRecognizer *giveViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giveViewTapClick)];
    self.giveView.userInteractionEnabled = YES;
    [self.giveView addGestureRecognizer:giveViewTap];
    
    UITapGestureRecognizer *priceViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceViewTapClick)];
    self.priceView.userInteractionEnabled = YES;
    [self.priceView addGestureRecognizer:priceViewTap];
    
    UITapGestureRecognizer *termOfValidityViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termOfValidityViewTapClick)];
    self.termOfValidityView.userInteractionEnabled = YES;
    [self.termOfValidityView addGestureRecognizer:termOfValidityViewTap];
    
    self.selctNumber = 1;
    
    self.string=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
    self.stringNumber = [[NSMutableString alloc]init];
    
    //    [self.selectBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    //     [self.selectBtn setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateSelected];
    self.selectTime = @"年";
}



- (void)setModel:(SVduoguigeModel *)model
{
    _model = model;
    self.nameL.text = model.sv_p_name;
   // self.specL.text = model.sv_p_specs;
    self.moneyL.text = model.sv_p_unitprice;
    self.purchaseLabel.text = @"必填";
    self.giveLabel.text = @"";
    self.priceLabel.text = @"必填";
    self.termOfValidityLabel.text = @"";
    [self purchaseViewTapClick];
   // self.stockpurchasePriceLabel.text = model.sv_purchaseprice;
    if (![SVTool isBlankString:model.sv_p_images]) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    } else {
        
        self.icon.image = [UIImage imageNamed:@"foodimg"];
    }
    
}

/**
 购买
 */
- (void)purchaseViewTapClick{
    [self.string setString:@""];//清空字符
    self.giveView.layer.borderWidth = 0;
    self.giveView.layer.borderColor = [UIColor clearColor].CGColor;
    self.priceView.layer.borderWidth = 0;
    self.priceView.layer.borderColor = [UIColor clearColor].CGColor;
    self.termOfValidityView.layer.borderWidth = 0;
    self.termOfValidityView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.purchaseView.layer.borderWidth = 1;
    self.purchaseView.layer.borderColor = navigationBackgroundColor.CGColor;
    self.selctNumber = 1;
}

/**
 赠送
 */
- (void)giveViewTapClick{
    [self.string setString:@""];//清空字符
    self.purchaseView.layer.borderWidth = 0;
    self.purchaseView.layer.borderColor = [UIColor clearColor].CGColor;
    self.priceView.layer.borderWidth = 0;
    self.priceView.layer.borderColor = [UIColor clearColor].CGColor;
    self.termOfValidityView.layer.borderWidth = 0;
    self.termOfValidityView.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    self.giveView.layer.borderWidth = 1;
    self.giveView.layer.borderColor = navigationBackgroundColor.CGColor;
    self.selctNumber = 2;
}
/**
 价格
 */
- (void)priceViewTapClick{
    [self.string setString:@""];//清空字符
    self.purchaseView.layer.borderWidth = 0;
    self.purchaseView.layer.borderColor = [UIColor clearColor].CGColor;
    self.giveView.layer.borderWidth = 0;
    self.giveView.layer.borderColor = [UIColor clearColor].CGColor;
    self.termOfValidityView.layer.borderWidth = 0;
    self.termOfValidityView.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    self.priceView.layer.borderWidth = 1;
    self.priceView.layer.borderColor = navigationBackgroundColor.CGColor;
    self.selctNumber = 3;
}

/**
 有效期
 */
- (void)termOfValidityViewTapClick{
    [self.string setString:@""];//清空字符
    self.purchaseView.layer.borderWidth = 0;
    self.purchaseView.layer.borderColor = [UIColor clearColor].CGColor;
    self.giveView.layer.borderWidth = 0;
    self.giveView.layer.borderColor = [UIColor clearColor].CGColor;
    self.priceView.layer.borderWidth = 0;
    self.priceView.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    self.termOfValidityView.layer.borderWidth = 1;
    self.termOfValidityView.layer.borderColor = navigationBackgroundColor.CGColor;
    self.selctNumber = 4;
}

- (IBAction)keyBoardNumberClick:(id)sender {
   // self.shiLabel.text = self.string;
    if (self.selctNumber == 1) {
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.purchaseLabel.text = self.string;
    }else if (self.selctNumber == 2){
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.giveLabel.text = self.string;
    }else if (self.selctNumber == 3){
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.priceLabel.text = self.string;
    }else{
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.termOfValidityLabel.text = self.string;
    }
    
}

- (IBAction)cleanClick:(id)sender {
   // self.shiLabel.text = @"";
    [self.string setString:@""];//清空字符
   // self.yingkuiLabel.text = self.string;
    
    if (self.selctNumber == 1) {
        self.purchaseLabel.text = @"必填";
        
        [self.string setString:@""];//清空字符
    }else if (self.selctNumber == 2){
        self.giveLabel.text = @"";
        [self.string setString:@""];//清空字符
    }else if (self.selctNumber == 3){
        self.priceLabel.text = @"必填";
        [self.string setString:@""];//清空字符
    }else{
        self.termOfValidityLabel.text = @"";
        [self.string setString:@""];//清空字符
    }
}
#pragma mark - 点击年按钮
- (IBAction)yearClick:(UIButton *)sender {
    
    NSArray * arr = @[@"年",@"月",@"日"];
    HLPopTableView * hlPopView = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.width-5,150) dependView:sender textArr:arr block:^(NSString *region_name, NSInteger index) {
        self.selectTime = region_name;
        [self.yearBtn setTitle:region_name forState:UIControlStateNormal];
        NSLog(@"region_name = %@",region_name);
    }];
    [self addSubview:hlPopView];

}
- (IBAction)sureClick:(UIButton *)sender {
    if ([self.purchaseLabel.text isEqualToString:@"必填"]) {
        return [SVTool TextButtonActionWithSing:@"购买必填"];
    }else if ([self.priceLabel.text isEqualToString:@"必填"]){\
        return [SVTool TextButtonActionWithSing:@"价格必填"];
    }else{
        if (self.sureBtnClickBlock) {
            _model.isSelect = @"1";
            _model.purchase = self.purchaseLabel.text;
            if (kStringIsEmpty(self.giveLabel.text)) {
                _model.give = @"";
            }else{
                _model.give = self.giveLabel.text;
            }
            
            _model.price = self.priceLabel.text;
            if (kStringIsEmpty(self.termOfValidityLabel.text)) {
                _model.termOfValidity = @"";
            }else{
                _model.termOfValidity = self.termOfValidityLabel.text;
            }
            
            _model.time = self.selectTime;
            self.sureBtnClickBlock(sender.tag, _model);
        }
    }
  
}

@end
