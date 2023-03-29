//
//  SVMultiSpecificationCell.m
//  SAVI
//
//  Created by houming Wang on 2018/12/3.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVMultiSpecificationCell.h"
#import "JJPhotoManeger.h"
@interface SVMultiSpecificationCell()<UITextFieldDelegate,JJPhotoDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *unitprice;
@property (weak, nonatomic) IBOutlet UILabel *unit;




//@property (weak, nonatomic) IBOutlet UILabel *sv_p_specs;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSMutableArray *picUrlArr;
@end
@implementation SVMultiSpecificationCell


- (void)setGoodsModel:(SVSelectedGoodsModel *)goodsModel {
    
    _goodsModel = goodsModel;
    [self updateCell];
}

//重载layoutSubviews，对cell里面子控件frame进行设置
- (void)layoutSubviews {
    [super layoutSubviews];
   // self.countText.delegate = self;
    [self updateCell];
}

//- (void)setLabelStr:(NSString *)labelStr
//{
//    _labelStr = labelStr;
//    NSLog(@"labelStr = %@",labelStr);
//    
//    self.countLabel.text = labelStr;
//}


- (void)updateCell {
    
    //图片
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    if (![SVTool isBlankString:self.goodsModel.sv_p_images]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.goodsModel.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    } else {
        
        self.iconView.image = [UIImage imageNamed:@"foodimg"];
    }
    
    _imageArr = [NSMutableArray array];
    //        _picUrlArr = [NSMutableArray array];
    [_imageArr addObject:self.iconView];
    self.iconView.userInteractionEnabled = YES;
    [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,self.goodsModel.sv_p_images2]];
    //添加点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tap:)];
    [self.iconView addGestureRecognizer:tap];
    
    //名称
    self.goodsName.text = _goodsModel.sv_p_name;
    //单价
    float num = [_goodsModel.sv_p_unitprice floatValue];
    self.money.text = [NSString stringWithFormat:@"%0.2f",num];
    //库存
    float number = [_goodsModel.sv_p_storage floatValue];
    self.unitprice.text = [NSString stringWithFormat:@"%.f",number];
   // self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)_goodsModel.product_num];
    //单位
    self.unit.text = _goodsModel.sv_p_unit;
    
    //规格
    //  self.sv_p_specs.text = _goodsModel.sv_p_specs;
    
    //单价
    //    float num = [_goodsModel.sv_p_unitprice floatValue];
    //    NSString *name = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%0.2f",num],_goodsModel.sv_p_specs];
    //
    //    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:name];
    //    //设置文本颜色
    //    [hogan addAttribute:NSForegroundColorAttributeName value:GreyFontColor range:NSMakeRange(_goodsModel.sv_p_unitprice.length+4, _goodsModel.sv_p_specs.length)];
    //    //设置文本字体大小
    //    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(_goodsModel.sv_p_unitprice.length+4, _goodsModel.sv_p_specs.length)];
    //
    //    self.money.attributedText = hogan;
    
    
//    if (self.goodsModel.product_num == 0) {
//        [self hiddenYES];
//    } else {
//        [self hiddenNO];
//    }
    
}
- (IBAction)addClick:(id)sender {
    if (_goodsModel.sv_is_newspec == 0) {// 不是多规格
        if (self.countChangeBlock) {
             _goodsModel.product_num = 1;
            NSLog(@"_goodsModel.product_num = %ld",_goodsModel.product_num);
            
            self.countChangeBlock(self.goodsModel,self.indexPatch);
        }
        
        if (self.SingleShopCartBlock) {
           
            self.SingleShopCartBlock(self.addButton.imageView);
        }
        
    }else{
        if (self.countChangeBlock) {
            self.countChangeBlock(self.goodsModel,self.indexPatch);
        }
    }
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    //  NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
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



@end
