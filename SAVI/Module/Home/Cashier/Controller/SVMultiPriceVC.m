//
//  SVMultiPriceVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/23.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVMultiPriceVC.h"
#import "SVSelectedGoodsModel.h"
#import "SVEjectPriceView.h"
@interface SVMultiPriceVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *StockLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailPriceLabel;//零售价
@property (weak, nonatomic) IBOutlet UILabel *totleMonay;
@property (weak, nonatomic) IBOutlet UITextField *NumberText;
//@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UIView *discountView;

@property (nonatomic,strong) SVEjectPriceView *ejectPriceView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSDictionary *dict;

@property (weak, nonatomic) IBOutlet UITextField *zhekouT;

@property (weak, nonatomic) IBOutlet UILabel *moneyName;

//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@end

@implementation SVMultiPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品";
    
    if (![SVTool isBlankString:self.model.sv_p_images]) {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.model.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    } else {
        
        self.iconImage.image = [UIImage imageNamed:@"foodimg"];
    }
    
    //名称
    self.nameLabel.text = self.model.sv_p_name;
    
    //库存
    float number = [self.model.sv_p_storage floatValue];
    self.StockLabel.text = [NSString stringWithFormat:@"%.f",number];
    
    //单价
    float num = [self.model.sv_p_unitprice floatValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%0.2f",num];
    
    self.retailPriceLabel.text = [NSString stringWithFormat:@"%0.2f",num];
    
    self.priceLabel.text = [NSString stringWithFormat:@"%0.2f",num];
    
    self.NumberText.text = [NSString stringWithFormat:@"%.0f",self.product_num];
    
    self.totleMonay.text = [NSString stringWithFormat:@"总价：￥%.2f",self.product_num *num];
    
    
    UITapGestureRecognizer *priceTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceTagClick)];
    [self.priceView addGestureRecognizer:priceTag];
    
//    UITapGestureRecognizer *discountTag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(discountTagClick)];
//    [self.discountView addGestureRecognizer:discountTag];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"money"] = self.model.sv_p_unitprice;
    dic1[@"name"] = @"零售价：";
    [self.dataArray addObject:dic1];
    if (!kStringIsEmpty(self.model.sv_p_memberprice) && self.model.sv_p_memberprice.floatValue >0 ) {
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        dic2[@"money"] = self.model.sv_p_memberprice;
        dic2[@"name"] = @"会员价：";
        [self.dataArray addObject:dic2];
    }
    
    if (!kStringIsEmpty(self.model.sv_p_memberprice1) && self.model.sv_p_memberprice1.floatValue >0 ) {
         NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
         dic3[@"money"] = self.model.sv_p_memberprice1;
         dic3[@"name"] = @"会员价1：";
         [self.dataArray addObject:dic3];
     }
    
    if (!kStringIsEmpty(self.model.sv_p_memberprice2) && self.model.sv_p_memberprice2.floatValue >0 ) {
         NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
         dic4[@"money"] = self.model.sv_p_memberprice2;
         dic4[@"name"] = @"会员价2：";
         [self.dataArray addObject:dic4];
     }
    
    if (!kStringIsEmpty(self.model.sv_p_memberprice3) && self.model.sv_p_memberprice3.floatValue >0 ) {
         NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
         dic5[@"money"] = self.model.sv_p_memberprice3;
         dic5[@"name"] = @"会员价3：";
         [self.dataArray addObject:dic5];
     }
    
    if (!kStringIsEmpty(self.model.sv_p_memberprice4) && self.model.sv_p_memberprice4.floatValue >0 ) {
         NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
         dic6[@"money"] = self.model.sv_p_memberprice4;
         dic6[@"name"] = @"会员价4：";
         [self.dataArray addObject:dic6];
     }
    
    if (!kStringIsEmpty(self.model.sv_p_memberprice5) && self.model.sv_p_memberprice5.floatValue >0 ) {
          NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
          dic7[@"money"] = self.model.sv_p_memberprice5;
          dic7[@"name"] = @"会员价5：";
          [self.dataArray addObject:dic7];
      }
    
//    if (!kStringIsEmpty(self.model.sv_purchaseprice) && self.model.sv_purchaseprice.floatValue > 0) {
//        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
//        dic3[@"money"] = self.model.sv_purchaseprice;
//        dic3[@"name"] = @"进货价";
//         [self.dataArray addObject:dic3];
//    }
    
    self.dict = self.dataArray[0];
    self.zhekouT.delegate = self;
    self.NumberText.delegate = self;
    self.priceLabel.delegate = self;
   
}



- (void)priceTagClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    self.ejectPriceView = [[NSBundle mainBundle] loadNibNamed:@"SVEjectPriceView" owner:nil options:nil].lastObject;
     int num = (int) ceil(self.dataArray.count / 3.0);
    self.ejectPriceView.frame = CGRectMake(0, ScreenH, ScreenW, num *100 +50);
    
    self.ejectPriceView.backgroundColor = RGBA(239, 239, 239, 1);
    __weak typeof(self) weakSelf = self;
    self.ejectPriceView.dictBlock = ^(NSDictionary * _Nonnull dict) {
        weakSelf.dict = dict;
        weakSelf.moneyName.text = dict[@"name"];
        float discount = self.zhekouT.text.floatValue * 0.1;
        weakSelf.retailPriceLabel.text = [NSString stringWithFormat:@"%0.2f",[dict[@"money"] floatValue] * discount];
        weakSelf.priceLabel.text = [NSString stringWithFormat:@"%0.2f",[dict[@"money"] floatValue] * discount];
        
        float num = [dict[@"money"] floatValue];
        
         weakSelf.totleMonay.text = [NSString stringWithFormat:@"总价：￥%.2f",weakSelf.NumberText.text.floatValue *num *discount];
        [weakSelf handlePan];
    };
    [self.ejectPriceView.cancleBtn addTarget:self action:@selector(handlePan) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.ejectPriceView];
    self.ejectPriceView.dataArray = self.dataArray;
    //实现弹出方法
    [UIView animateWithDuration:.5 animations:^{
        self.ejectPriceView.frame = CGRectMake(0, ScreenH-(num *100 +50), ScreenW, num *100 +50);
    }];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.zhekouT) {
        if (textField.text.floatValue > 10) {
            self.zhekouT.text = @"10";
            float num = [self.dict[@"money"] floatValue];
            float zhekou = self.zhekouT.text.floatValue;
            self.priceLabel.text = [NSString stringWithFormat:@"%0.2f",num *zhekou *0.1];
            
            self.retailPriceLabel.text = [NSString stringWithFormat:@"%0.2f",num *zhekou *0.1];
            
            self.totleMonay.text = [NSString stringWithFormat:@"总价：￥%.2f",self.NumberText.text.floatValue *num *zhekou *0.1];
        }else{
            self.zhekouT.text = textField.text;
            
            float num = [self.dict[@"money"] floatValue];
            float zhekou = textField.text.floatValue;
            self.priceLabel.text = [NSString stringWithFormat:@"%0.2f",num *zhekou *0.1];
            
            self.retailPriceLabel.text = [NSString stringWithFormat:@"%0.2f",num *zhekou *0.1];
            
            self.totleMonay.text = [NSString stringWithFormat:@"总价：￥%.2f",self.NumberText.text.floatValue *num *zhekou *0.1];
        }
    }else if (textField == self.priceLabel){
        self.zhekouT.text = @"10";
       // float num = [self.dict[@"money"] floatValue];
        float zhekou = self.zhekouT.text.floatValue;
      //  self.priceLabel.text = [NSString stringWithFormat:@"%0.2f",num *zhekou *0.1];
        
        self.retailPriceLabel.text = self.priceLabel.text;
        float num = self.retailPriceLabel.text.floatValue;
        self.totleMonay.text = [NSString stringWithFormat:@"总价：￥%.2f",self.NumberText.text.floatValue *num *zhekou *0.1];
    }else{
        
        
           // self.zhekouT.text = @"10";
            float num = [self.dict[@"money"] floatValue];
            float zhekou = self.zhekouT.text.floatValue;
//            self.priceLabel.text = [NSString stringWithFormat:@"%0.2f",num *zhekou *0.1];
//            
//            self.retailPriceLabel.text = [NSString stringWithFormat:@"%0.2f",num *zhekou *0.1];
            
            self.totleMonay.text = [NSString stringWithFormat:@"总价：￥%.2f",self.NumberText.text.floatValue *num *zhekou *0.1];

    }
}

- (IBAction)sureClick:(id)sender {
    
    if (self.NumberText.text.doubleValue > 0) {
         float product_num;
        //    if ([self.moneyName.text containsString:@"零售价"]) {
        //        NSLog(@"零售价");
        //        self.model.ImageHidden = @"1";
        //        self.model.priceChangeStr = self.priceLabel.text;
        //       // self.model.product_num = self.NumberText.text.floatValue;
        //       self.product_num = self.NumberText.text.floatValue;
        //    }else if ([self.moneyName.text containsString:@"会员价"]){
        //        self.model.ImageHidden = @"1";
        //        self.model.priceChangeStr = self.priceLabel.text;
        //       // self.model.product_num = self.NumberText.text.floatValue;
        //        self.product_num = self.NumberText.text.floatValue;
        //        NSLog(@"会员价");
        //    }else{
        //
        //    }
                self.model.isPriceChange = @"1";
                  self.model.ImageHidden = @"1";
                  self.model.priceChange = self.priceLabel.text;
                //  self.model.product_num = self.NumberText.text.floatValue;
                  NSLog(@"进货价");
                  self.product_num = self.NumberText.text.floatValue;
            
            if (self.multiModelBlock) {
                self.multiModelBlock(self.model, self.model.indexPath,self.product_num);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVTool TextButtonActionWithSing:@"没有输入数量"];
    }
    
}

- (void)discountTagClick{
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/**
 遮盖
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheView addGestureRecognizer:tap];
        
    }
    
    return _maskTheView;
    
}

//移除
- (void)handlePan{
    [self.maskTheView removeFromSuperview];
    int num = (int) ceil(self.dataArray.count / 3.0);
    [UIView animateWithDuration:.5 animations:^{
        self.ejectPriceView.frame = CGRectMake(0, ScreenH, ScreenW, num *100 +50);
        [self.ejectPriceView removeFromSuperview];
    }];
    
}


@end
