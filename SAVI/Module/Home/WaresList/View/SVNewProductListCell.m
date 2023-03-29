//
//  SVNewProductListCell.m
//  SAVI
//
//  Created by houming Wang on 2021/1/20.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewProductListCell.h"
#import "SVduoguigeModel.h"
#import "JJPhotoManeger.h"

@interface SVNewProductListCell()<JJPhotoDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *waresName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *inventory;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_specs;
@property (weak, nonatomic) IBOutlet UILabel *barCode;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSMutableArray *picUrlArr;
@end

@implementation SVNewProductListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SVduoguigeModel *)model
{
    _model = model;
    self.iconImg.layer.cornerRadius = 5;
    self.iconImg.layer.masksToBounds = YES;
    
    if ([self.model.sv_p_images containsString:@"UploadImg"]) {
        
        NSData *data = [self.model.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = arr[0];
        NSString *sv_p_images_two = dic[@"code"];
       // sv_p_images = sv_p_images_two;
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    
        //添加点击操作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [self.iconImg addGestureRecognizer:tap];
        self.iconImg.userInteractionEnabled = YES;
       // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
    }else{
        self.iconImg.image = [UIImage imageNamed:@"foodimg"];
    }
    
    self.waresName.text = _model.sv_p_name;
    self.waresName.textColor = GlobalFontColor;
    
    self.money.text = [NSString stringWithFormat:@"￥%.2f",[_model.sv_p_unitprice floatValue]];
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
    if (kDictIsEmpty(CommodityManageDic)) {
        self.money.hidden = NO;
      
    }else{
        NSString *Sv_p_unitprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_p_unitprice"]];
        if (kStringIsEmpty(Sv_p_unitprice)) {
            self.money.hidden = NO;
          
        }else{
            if ([Sv_p_unitprice isEqualToString:@"1"]) {
          
                self.money.hidden = NO;
              
        }else{
          //  self.RetailAndWholesalePrices.hidden = YES;
            self.money.text = @"***";
        }
        }
    }
    
   
    self.barCode.text = model.sv_p_barcode;
    self.inventory.text = [NSString stringWithFormat:@"库：%@",_model.sv_p_storage];
    
    self.sv_p_specs.text = _model.sv_p_specs;
}


//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    if ([self.model.sv_p_images containsString:@"UploadImg"]) {
        
        NSData *data = [self.model.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
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
          [self.iconImg addGestureRecognizer:tap];
        //        _picUrlArr = [NSMutableArray array];
        [self.imageArr addObject:self.iconImg];
        self.iconImg.userInteractionEnabled = YES;
    }
        
    }
    
    [SVUserManager loadUserInfo];
    [SVUserManager shareInstance].picUrlArr = self.picUrlArr;
    [SVUserManager saveUserInfo];
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
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

@end
