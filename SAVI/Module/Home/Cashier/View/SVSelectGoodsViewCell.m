//
//  SVSelectGoodsViewCell.m
//  SAVI
//
//  Created by hashakey on 2017/5/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSelectGoodsViewCell.h"
#import "JJPhotoManeger.h"
#import "ZYInputAlertView.h"
@interface SVSelectGoodsViewCell ()<JJPhotoDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *unitprice;
@property (weak, nonatomic) IBOutlet UILabel *unit;




//@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_specs;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSMutableArray *picUrlArr;
@property (weak, nonatomic) IBOutlet UILabel *setMealLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightDistance;
@property (weak, nonatomic) IBOutlet UILabel *ku;

@end

@implementation SVSelectGoodsViewCell

- (void)setGoodsModel:(SVSelectedGoodsModel *)goodsModel {
    
    _goodsModel = goodsModel;
  //  NSLog(@"_goodsModel.product_num = %f",_goodsModel.product_num);
    
    [self updateCell];
}

//重载layoutSubviews，对cell里面子控件frame进行设置
- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
//    [self updateCell];
}

- (void)updateCell {
    self.ku.layer.cornerRadius = 5;
    self.ku.layer.masksToBounds = YES;
    //图片
//    if (![SVTool isBlankString:self.goodsModel.sv_p_images]) {
//        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.goodsModel.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//    } else {
//
//        self.iconView.image = [UIImage imageNamed:@"foodimg"];
//    }
    
    
    if ([self.goodsModel.sv_p_images containsString:@"UploadImg"]) {
        
        NSData *data = [self.goodsModel.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        if (kArrayIsEmpty(arr)) {
           // NSDictionary *dic = arr[0];
            NSString *sv_p_images_two = self.goodsModel.sv_p_images;
           // sv_p_images = sv_p_images_two;
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        
            //添加点击操作
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tap:)];
            [self.iconView addGestureRecognizer:tap];
            self.iconView.userInteractionEnabled = YES;
        }else{
            NSDictionary *dic = arr[0];
            NSString *sv_p_images_two = dic[@"code"];
           // sv_p_images = sv_p_images_two;
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        
            //添加点击操作
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tap:)];
            [self.iconView addGestureRecognizer:tap];
            self.iconView.userInteractionEnabled = YES;
        }
       // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"foodimg"];
    }
    
   // _imageArr = [NSMutableArray array];
    //        _picUrlArr = [NSMutableArray array];
  //  [_imageArr addObject:self.iconView];
   // self.iconView.userInteractionEnabled = YES;
  //  [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,_goodsModel.sv_p_images2]];
    //添加点击操作
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//    [tap addTarget:self action:@selector(tap:)];
//    [self.iconView addGestureRecognizer:tap];
    
    //名称
    self.goodsName.text = _goodsModel.sv_p_name;
    //单价
    float num = [_goodsModel.sv_p_unitprice floatValue];
    self.money.text = [NSString stringWithFormat:@"%0.2f",num];
    //库存
    double number = [_goodsModel.sv_p_storage doubleValue];
    self.unitprice.text = [NSString stringWithFormat:@"%.2f",number];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
//         self.countText.text = [NSString stringWithFormat:@"%.2f",_goodsModel.product_num];
        self.rightDistance.constant = 10;

        self.addNumberBtn.hidden = NO;
        self.countText.hidden = YES;
        
        if (self.goodsModel.sv_is_newspec == 0) {// 不是多规格的产品
             // self.countText.hidden = NO;
             [self.addNumberBtn setTitle:[NSString stringWithFormat:@"%.2f",_goodsModel.product_num] forState:UIControlStateNormal];
          //  self.addNumberBtn.titleLabel.text = [NSString stringWithFormat:@"%.2f",_goodsModel.product_num];
            
          }else{
              self.countText.hidden = YES;
              self.addNumberBtn.hidden = YES;
               // self.countText.text = [NSString stringWithFormat:@"%.2f",_goodsModel.clother_product_num];
          }
        
//         [self.addNumberBtn addTarget:self action:@selector(addNumberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        self.addNumberBtn.hidden = YES;
        self.countText.hidden = NO;
        self.rightDistance.constant = 0;
        
        if (self.goodsModel.sv_is_newspec == 0) {// 不是多规格的产品
             // self.countText.hidden = NO;
               self.countText.text = [NSString stringWithFormat:@"%.2f",_goodsModel.product_num];
          }else{
              self.countText.hidden = YES;
              self.addNumberBtn.hidden = YES;
               // self.countText.text = [NSString stringWithFormat:@"%.2f",_goodsModel.clother_product_num];
          }
    }
    
  
    //单位
    self.unit.text = _goodsModel.sv_p_unit;
    
    if (self.goodsModel.sv_product_type.integerValue == 0) {
        if (self.goodsModel.sv_pricing_method.integerValue == 0) {
            self.rightImage.hidden = YES;
        }else{
           self.rightImage.hidden = NO;
          // self.setMealLabel.text = @"称";
            self.rightImage.image = [UIImage imageNamed:@"Weighting"];
            double number = [_goodsModel.sv_p_storage doubleValue];
            double sv_p_total_weight = _goodsModel.sv_p_total_weight;
            self.unitprice.text = [NSString stringWithFormat:@"%.2f",number+sv_p_total_weight];
        }
    }else if (self.goodsModel.sv_product_type.integerValue == 1){
         self.rightImage.hidden = NO;
       // self.setMealLabel.text = @"组";
        self.rightImage.image = [UIImage imageNamed:@"combination"];
    }else if (self.goodsModel.sv_product_type.integerValue == 2){
         self.rightImage.hidden = NO;
         self.rightImage.image = [UIImage imageNamed:@"Setmeal"];
    }else{
        self.rightImage.hidden = YES;
    }
    
    if (self.goodsModel.product_num > 0) {
      //  self.icon_addImage.hidden = YES;
        self.reduceButton.hidden = NO;
    }else{
      //  self.icon_addImage.hidden = NO;
        self.reduceButton.hidden = YES;
    }

    
    //规格
    self.sv_p_specs.text = _goodsModel.sv_p_specs;

//    if (self.goodsModel.product_num == 0) {
//        [self hiddenYES];
//    } else {
//        [self hiddenNO];
//    }
    
    
    
}

- (void)tagClick{
    if (self.multiPriceBlock) {
        self.multiPriceBlock(self.goodsModel);
    }
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    if ([self.goodsModel.sv_p_images containsString:@"UploadImg"]) {
        
        NSData *data = [self.goodsModel.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        if (kArrayIsEmpty(arr)) {
            NSString *sv_p_images_two = self.goodsModel.sv_p_images;
            [self.picUrlArr removeAllObjects];
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [self.picUrlArr addObject:imageUrl];
            [tap addTarget:self action:@selector(tap:)];
            [self.iconView addGestureRecognizer:tap];
          //        _picUrlArr = [NSMutableArray array];
          [self.imageArr addObject:self.iconView];
          self.iconView.userInteractionEnabled = YES;
            
        }else{
            [self.picUrlArr removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *dic = arr[i];
                NSString *sv_p_images_two = dic[@"code"];
               // sv_p_images = sv_p_images_two;
               
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two];
               // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
                NSLog(@"sv_p_images_two----%@",[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]);
               
                 [self.picUrlArr addObject:imageUrl];
                NSLog(@"self.picUrlArr = %@",self.picUrlArr);
                  //添加点击操作
                  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
                  [tap addTarget:self action:@selector(tap:)];
                  [self.iconView addGestureRecognizer:tap];
                //        _picUrlArr = [NSMutableArray array];
                [self.imageArr addObject:self.iconView];
                self.iconView.userInteractionEnabled = YES;
            }
                
            }
            
            [SVUserManager loadUserInfo];
            [SVUserManager shareInstance].picUrlArr = self.picUrlArr;
            [SVUserManager saveUserInfo];
            UIImageView *view = (UIImageView *)tap.view;
            JJPhotoManeger *mg = [JJPhotoManeger maneger];
            mg.delegate = self;
            [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
        }
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
}

- (NSMutableArray *)picUrlArr
{
    if (_picUrlArr == nil) {
        _picUrlArr = [NSMutableArray array];
    }
    return _picUrlArr;
}

- (NSMutableArray *)imageArr
{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}


-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    //  NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

//减按钮
- (IBAction)countReduce:(UIButton *)sender {
    
     [self blockMethods];
//    if (_goodsModel.sv_pricing_method.integerValue == 1) { // 是计重的
//        ZYInputAlertView *alertView = [ZYInputAlertView alertView];
//        alertView.confirmBgColor = navigationBackgroundColor;
//        alertView.colorLabel.text = @"输入重量";
//        alertView.placeholder = @"输入重量";
//        alertView.inputTextView.keyboardType = UIKeyboardTypeDecimalPad;
//        [alertView show];
//        alertView.textfieldStrBlock = ^(NSString *str) {
//            float product_num = str.floatValue;
//            if (product_num > self.goodsModel.product_num) {
//                [SVTool TextButtonActionWithSing:@"请输入正确数据"];
//            }else{
//                self.goodsModel.product_num -= product_num;
//
//                if (self.goodsModel.product_num == 0) {
//                    self.goodsModel.ImageHidden = @"0";// 让他出现加号
//                    self.icon_addImage.hidden = NO;
//                    self.reduceButton.hidden = YES;
//
//                }
//
//
//            }
//
//        };
//    }else{
//        //先赋值，后判断
//      //  self.goodsModel.product_num --;
//
////        if (self.goodsModel.product_num == 1) {
////            self.goodsModel.ImageHidden = @"0";// 让他出现加号
////            self.icon_addImage.hidden = NO;
////            self.reduceButton.hidden = YES;
////        }
//
////        if (self.goodsModel.product_num == 0) {
////            self.goodsModel.ImageHidden = @"0";// 让他出现加号
////            self.icon_addImage.hidden = NO;
////            self.reduceButton.hidden = YES;
////          //  [self hiddenYES];
////
////        }
//
//        [self blockMethods];
//    }
  
}

//加按钮
#pragma mark - 点击加号
- (IBAction)countAdd:(UIButton *)sender {
   NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable];
    
    if (_goodsModel.sv_pricing_method.integerValue == 1) { // 是计重的
        if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"1"] || kStringIsEmpty(ZeroInventorySales_sv_detail_is_enable)) {
            if (_goodsModel.sv_p_storage.floatValue > 0) {
                //先判断，后赋值
                [self hiddenNO];
                ZYInputAlertView *alertView = [ZYInputAlertView alertView];
                alertView.confirmBgColor = navigationBackgroundColor;
                alertView.colorLabel.text = @"输入重量";
                alertView.placeholder = @"输入重量";
                alertView.inputTextView.keyboardType = UIKeyboardTypeDecimalPad;
                [alertView show];
                alertView.textfieldStrBlock = ^(NSString *str) {
                    float product_num = str.floatValue;
                    self.goodsModel.product_num += product_num;
                    
                    //让图变大变小的图
                    self.countText.transform = CGAffineTransformMakeScale(1, 1);
                    [UIView animateWithDuration:0.1   animations:^{
                        self.countText.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    }completion:^(BOOL finish){
                        [UIView animateWithDuration:0.1      animations:^{
                            self.countText.transform = CGAffineTransformMakeScale(0.9, 0.9);
                        }completion:^(BOOL finish){
                            [UIView animateWithDuration:0.1   animations:^{
                                self.countText.transform = CGAffineTransformMakeScale(1, 1);
                            }completion:^(BOOL finish){
                            }];
                        }];
                    }];
                    
                    [self blockMethods];
                };
            }else{
                [SVTool TextButtonActionWithSing:@"库存不足，无法添加商品"];
            }
        }else{
            //先判断，后赋值
            [self hiddenNO];
            ZYInputAlertView *alertView = [ZYInputAlertView alertView];
            alertView.confirmBgColor = navigationBackgroundColor;
            alertView.colorLabel.text = @"输入重量";
            alertView.placeholder = @"输入重量";
            alertView.inputTextView.keyboardType = UIKeyboardTypeDecimalPad;
            [alertView show];
            alertView.textfieldStrBlock = ^(NSString *str) {
                float product_num = str.floatValue;
                self.goodsModel.product_num += product_num;
                
                //让图变大变小的图
                self.countText.transform = CGAffineTransformMakeScale(1, 1);
                [UIView animateWithDuration:0.1   animations:^{
                    self.countText.transform = CGAffineTransformMakeScale(1.5, 1.5);
                }completion:^(BOOL finish){
                    [UIView animateWithDuration:0.1      animations:^{
                        self.countText.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    }completion:^(BOOL finish){
                        [UIView animateWithDuration:0.1   animations:^{
                            self.countText.transform = CGAffineTransformMakeScale(1, 1);
                        }completion:^(BOOL finish){
                        }];
                    }];
                }];
                
                [self blockMethods];
            };
        }
       
        
   
        
    }else{
        
        if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"] || kStringIsEmpty(ZeroInventorySales_sv_detail_is_enable)) {
            if (_goodsModel.sv_p_storage.floatValue > 0) {
                //先判断，后赋值
                [self hiddenNO];
                self.goodsModel.product_num ++;
                
                
                //让图变大变小的图
                self.countText.transform = CGAffineTransformMakeScale(1, 1);
                [UIView animateWithDuration:0.1   animations:^{
                    self.countText.transform = CGAffineTransformMakeScale(1.5, 1.5);
                }completion:^(BOOL finish){
                    [UIView animateWithDuration:0.1      animations:^{
                        self.countText.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    }completion:^(BOOL finish){
                        [UIView animateWithDuration:0.1   animations:^{
                            self.countText.transform = CGAffineTransformMakeScale(1, 1);
                        }completion:^(BOOL finish){
                        }];
                    }];
                }];
                
                [self blockMethods];
                
                if (self.shopCartBlock) {
                    self.shopCartBlock(self.addButton.imageView);
                }
            }else{
                [SVTool TextButtonActionWithSing:@"库存不足，无法添加商品"];
            }
            
        }else{
            //先判断，后赋值
            [self hiddenNO];
            self.goodsModel.product_num ++;
            
            
            //让图变大变小的图
            self.countText.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateWithDuration:0.1   animations:^{
                self.countText.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }completion:^(BOOL finish){
                [UIView animateWithDuration:0.1      animations:^{
                    self.countText.transform = CGAffineTransformMakeScale(0.9, 0.9);
                }completion:^(BOOL finish){
                    [UIView animateWithDuration:0.1   animations:^{
                        self.countText.transform = CGAffineTransformMakeScale(1, 1);
                    }completion:^(BOOL finish){
                    }];
                }];
            }];
            
            [self blockMethods];
            
            if (self.shopCartBlock) {
                self.shopCartBlock(self.addButton.imageView);
            }
        }
        
       
    }
    
  
    
    

}
    
//输入框--UITextField
- (IBAction)countTextAdd:(UITextField *)sender {

    if ([sender.text floatValue] == 0) {
        [self hiddenYES];
    }else{
        [self hiddenNO];
    }
    
    //让图变大变小的
    self.countText.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.1   animations:^{
        self.countText.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1      animations:^{
            self.countText.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1   animations:^{
                self.countText.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL finish){
            }];
        }];
    }];

    
    self.goodsModel.product_num = sender.text.floatValue;

    [self blockMethods];
    
}

/**
 调用block
 */
-(void)blockMethods{
    
    if (self.countChangeBlock) {
        self.countChangeBlock(self.goodsModel,self.indexPatch);
    }
   // self.countText.text = [NSString stringWithFormat:@"%.2f", self.goodsModel.product_num];
}
/**
 YES隐藏的方法
 */
-(void)hiddenYES{
    self.reduceButton.hidden = YES;
    self.countText.textColor = RGBA(203, 203, 203, 1);
   // [self.addButton setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
}

/**
 NO隐藏的方法
 */
-(void)hiddenNO{
    self.reduceButton.hidden = NO;
    self.countText.textColor = [UIColor blackColor];
   // [self.addButton setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
}
 
    

@end
