//
//  SVHistoryDateilsCell.m
//  SAVI
//
//  Created by Sorgle on 2018/2/10.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVHistoryDateilsCell.h"
#import "JJPhotoManeger.h"

@interface SVHistoryDateilsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *waresName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIImageView *retired;
@property (weak, nonatomic) IBOutlet UILabel *MultiSpecificationL;
@property (weak, nonatomic) IBOutlet UILabel *Discount;
@property (weak, nonatomic) IBOutlet UILabel *salesAmount;

//件数总数
@property (nonatomic,assign) float sum;
@property(nonatomic,strong)NSMutableArray *imageArr;
@end

@implementation SVHistoryDateilsCell

-(void)setHistoryModel:(SVHistoryDateilsModel *)historyModel{
    _historyModel = historyModel;
    
    self.iconImg.layer.cornerRadius = 5;
    self.iconImg.layer.masksToBounds = YES;
    
    self.waresName.text = historyModel.product_name;
    
    self.money.text = [NSString stringWithFormat:@"%.2f",[historyModel.product_price floatValue]];
    
    self.number.text = [NSString stringWithFormat:@"%@",historyModel.product_num];
    if ([SVTool isBlankString:historyModel.sv_p_specs]) {
        self.MultiSpecificationL.hidden = YES;
    }else{
        self.MultiSpecificationL.hidden = NO;
         self.MultiSpecificationL.text = [NSString stringWithFormat:@"%@",historyModel.sv_p_specs];
    }
    
    if (![SVTool isBlankString:historyModel.sv_p_images2]) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,historyModel.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    }else{
        self.iconImg.image = [UIImage imageNamed:@"foodimg"];
    }
    
    if (historyModel.sv_p_memberprice == 0) {
        if ([historyModel.product_discount isEqualToString:@"1"] || [historyModel.product_discount isEqualToString:@"0"]) {
            self.Discount.text = @"无折扣";
        }else{
            self.Discount.text = [NSString stringWithFormat:@"%.4f折",[historyModel.product_discount doubleValue]];
        }
    }else{
        self.Discount.text = [NSString stringWithFormat:@"会员价(%.2f)",historyModel.sv_p_memberprice];
    }
    
       self.salesAmount.text = [NSString stringWithFormat:@"%.2f元",[historyModel.product_total floatValue]];
//}
//else{
//    if ([historyModel.product_discount isEqualToString:@"1"] || [historyModel.product_discount isEqualToString:@"0"]) {
//        self.Discount.text = @"无折扣";
//    }else{
//        self.Discount.text = [NSString stringWithFormat:@"%.4f折",[detalisHistoryModel.product_discount doubleValue]];
//    }

    _imageArr = [NSMutableArray array];
    //        _picUrlArr = [NSMutableArray array];
    [_imageArr addObject:self.iconImg];
    self.iconImg.userInteractionEnabled = YES;
    //添加点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tap:)];
    [self.iconImg addGestureRecognizer:tap];
   
    NSString *state = [NSString stringWithFormat:@"%@",historyModel.order_stutia];
    float stateNum = [state floatValue];
    if (stateNum == 2) {
        
        //已退
        self.retired.image = [UIImage imageNamed:@"ic_retired"];
        
    } else {
        
        self.retired.hidden = YES;
        
    }
    
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
