//
//  SVShopSalesDetailsCell.m
//  SAVI
//
//  Created by houming Wang on 2020/12/23.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVShopSalesDetailsCell.h"
#import "SVDetailsHistoryModel.h"
#import "JJPhotoManeger.h"

@interface SVShopSalesDetailsCell()
@property (weak, nonatomic) IBOutlet UILabel *product_name; // 名称
@property (weak, nonatomic) IBOutlet UILabel *sv_p_barcode; // 款号
@property (weak, nonatomic) IBOutlet UILabel *contentText; // 内容

@property (weak, nonatomic) IBOutlet UILabel *price; // 单价
@property (weak, nonatomic) IBOutlet UILabel *number; // 数量
@property (weak, nonatomic) IBOutlet UILabel *money; // 金额
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property(nonatomic,strong)NSMutableArray *imageArr;



@end

@implementation SVShopSalesDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.money.adjustsFontSizeToFitWidth = YES;
    self.money.minimumScaleFactor = 0.5;
    
    self.price.adjustsFontSizeToFitWidth = YES;
    self.price.minimumScaleFactor = 0.5;
    
    self.number.adjustsFontSizeToFitWidth = YES;
    self.number.minimumScaleFactor = 0.5;
    
    self.sv_p_barcode.adjustsFontSizeToFitWidth = YES;
    self.sv_p_barcode.minimumScaleFactor = 0.5;
}

- (void)setModel:(SVDetailsHistoryModel *)model
{
    self.product_name.text = model.product_name;
    self.sv_p_barcode.text = model.sv_p_barcode;
   // self.contentText.text = model.product_name;
    
    NSString *timeString = model.order_datetime;
    NSString *time1 = [timeString substringToIndex:10];
    NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
    if (!kStringIsEmpty(model.sv_mr_name)) {
        self.contentText.text = [NSString stringWithFormat:@"%@ %@ | %@",time1,time2,model.sv_mr_name];
    }else{
        self.contentText.text = [NSString stringWithFormat:@"%@ %@ | 散客",time1,time2];
    }
    
    float count = model.product_num.floatValue + model.sv_p_weight_bak.floatValue;
 
        self.number.text = [NSString stringWithFormat:@"x%.2f",count];
   
       

    if (![SVTool isBlankString:model.sv_p_images2]) {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,model.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
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
    
    self.price.text = model.product_unitprice;
   // self.number.text = model.product_name;
    self.money.text = [NSString stringWithFormat:@"￥%.2f",[model.product_total_bak floatValue]];
   // self.money.text = model.product_name;
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
