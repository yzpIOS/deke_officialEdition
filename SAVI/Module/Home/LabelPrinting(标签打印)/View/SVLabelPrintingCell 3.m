//
//  SVLabelPrintingCell.m
//  SAVI
//
//  Created by houming Wang on 2019/7/2.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVLabelPrintingCell.h"
#import "SVduoguigeModel.h"
#import "JJPhotoManeger.h"
@interface SVLabelPrintingCell()<JJPhotoDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *waresName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *inventory;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_specs;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property (weak, nonatomic) IBOutlet UIImageView *cell_icon;
@property(nonatomic,strong)NSMutableArray *picUrlArr;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@end
@implementation SVLabelPrintingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVduoguigeModel *)model {
    
    _model = model;
    
    [self updateCell];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateCell];
    
}


- (void)updateCell {
    
//    [self.cellButton setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
//    [self.cellButton setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    if ([_model.isSelect isEqualToString:@"1"]) {
        self.cell_icon.image = [UIImage imageNamed:@"ic_yixuan.png"];
    }
    else{
        self.cell_icon.image = [UIImage imageNamed:@"ic_mo-ren"];
    }
    
    
    if (self.model.sv_product_type.integerValue == 0) {
        if (self.model.sv_pricing_method.integerValue == 0) {
            self.rightImage.hidden = YES;
        }else{
            self.rightImage.hidden = NO;
            self.rightImage.image = [UIImage imageNamed:@"Weighting"];
        }
    }else if (self.model.sv_product_type.integerValue == 1){
        self.rightImage.hidden = NO;
        // self.setMealLabel.text = @"组";
        self.rightImage.image = [UIImage imageNamed:@"combination"];
    }else if (self.model.sv_product_type.integerValue == 2){
        self.rightImage.hidden = NO;
        self.rightImage.image = [UIImage imageNamed:@"Setmeal"];
    }else{
        self.rightImage.hidden = YES;
    }
    
    
    self.iconImg.layer.cornerRadius = 5;
    self.iconImg.layer.masksToBounds = YES;
    if (![SVTool isBlankString:self.model.sv_p_images]) {
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.model.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        
    } else {
        
        self.iconImg.image = [UIImage imageNamed:@"foodimg"];
    }
    
    _imageArr = [NSMutableArray array];
    //        _picUrlArr = [NSMutableArray array];
    [_imageArr addObject:self.iconImg];
    self.iconImg.userInteractionEnabled = YES;
    [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,self.model.sv_p_images2]];
    //添加点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tap:)];
    [self.iconImg addGestureRecognizer:tap];
    self.waresName.text = _model.sv_p_name;
    
    self.money.text = [NSString stringWithFormat:@"%.2f",[_model.sv_p_unitprice floatValue]];
    
    self.inventory.text = _model.sv_p_storage;
    
    self.sv_p_specs.text = _model.sv_p_specs;
    
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    //  NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

@end
