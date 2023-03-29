
//
//  GoodsInfoView.m
//  ChoseGoodsType
//
//  Created by 澜海利奥 on 2018/1/30.
//  Copyright © 2018年 江萧. All rights reserved.
//

#import "GoodsInfoView.h"
#import "Header.h"
#import "SizeAttributeModel.h"
#import "JJPhotoManeger.h"
@interface GoodsInfoView()<JJPhotoDelegate>
@property(nonatomic, strong)UIImageView *goodsImage;
@property(nonatomic, strong)UILabel *goodsTitleLabel;
@property(nonatomic, strong)UILabel *goodsCountLabel;
@property(nonatomic, strong)UILabel *goodsPriceLabel;
@property(nonatomic,strong)NSMutableArray *imageArr;
@end
@implementation GoodsInfoView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //商品图片
        _goodsImage = [[UIImageView alloc] init];
        _goodsImage.image = [UIImage imageNamed:@"1"];
        _goodsImage.contentMode =  UIViewContentModeScaleAspectFill;
        _goodsImage.clipsToBounds  = YES;
        [self addSubview:_goodsImage];
//        if (IS_iPhone7_Plus) {
//            _goodsImage.sd_layout.centerXEqualToView(self).topSpaceToView(self,kSize(74)).widthIs(kSize(200)).heightIs(kSize(200));
//        }else{
            _goodsImage.sd_layout.centerXEqualToView(self).topSpaceToView(self,kSize(10)).widthIs(kSize(200)).heightIs(kSize(200));
//        }
        // 点击图片放大
        _imageArr = [NSMutableArray array];
        //        _picUrlArr = [NSMutableArray array];
        [_imageArr addObject:_goodsImage];
        _goodsImage.userInteractionEnabled = YES;
        //添加点击操作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [_goodsImage addGestureRecognizer:tap];
        
        //价格
        _goodsPriceLabel = [JXUIKit labelWithBackgroundColor:WhiteColor textColor:KBtncol textAlignment:NSTextAlignmentCenter numberOfLines:0 fontSize:0 font:[UIFont systemFontOfSize:14] text:@"197"];
        [self addSubview:_goodsPriceLabel]; _goodsPriceLabel.sd_layout.centerXEqualToView(self).heightIs(kSize(20)).widthIs(kSize(ScreenW)).topSpaceToView(_goodsImage, 0);
        
        //库存
        _goodsCountLabel = [JXUIKit labelWithBackgroundColor:WhiteColor textColor:[UIColor grayColor] textAlignment:NSTextAlignmentCenter numberOfLines:0 fontSize:0 font:[UIFont systemFontOfSize:14] text:@"库存"];
        [self addSubview:_goodsCountLabel]; _goodsCountLabel.sd_layout.centerXEqualToView(self).heightIs(kSize(20)).widthIs(kSize(ScreenW)).topSpaceToView(_goodsPriceLabel, 0);
        
        
        
        //选择提示文字
        _promatLabel = [JXUIKit labelWithBackgroundColor:WhiteColor textColor:[UIColor grayColor] textAlignment:NSTextAlignmentCenter numberOfLines:0 fontSize:0 font:[UIFont systemFontOfSize:14] text:@""];
        [self addSubview:_promatLabel];
        _promatLabel.sd_layout.centerXEqualToView(self).heightIs(kSize(20)).widthIs(kSize(ScreenW)).topSpaceToView(_goodsCountLabel, 0);
        
    }
    return self;
}


//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    [mg showLocalPhotoViewer:_imageArr selecView:view];
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    // NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}


-(void)initData:(GoodsModel *)model
{
    _model = model;
    [_goodsImage setImage:[UIImage imageNamed:@"foodimg"]];
//     [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.imageId]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    //[goodsImage sd_setImageWithURL:[NSURL URLWithString:[kThumbImageUrl stringByAppendingString:model.imageId]] placeholderImage:kDefaultImage];
    _goodsTitleLabel.text = model.title;
    _goodsCountLabel.text = [NSString stringWithFormat:@"库存：%@",model.totalStock];
    if (model.price.minPrice.integerValue == 0) {
        _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.price.minOriginalPrice];
    }else{
        _goodsPriceLabel.text = [NSString stringWithFormat:@"原价:¥%@ 会员价:¥%@",model.price.minOriginalPrice,model.price.minPrice];
    }
   
    
//    NSMutableAttributedString *attritu = [[NSMutableAttributedString alloc]initWithString:_goodsPriceLabel.text];
//    [attritu addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick), NSForegroundColorAttributeName: [UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0),
//                             NSFontAttributeName: [UIFont systemFontOfSize:13]
//                             } range:[_goodsPriceLabel.text rangeOfString:[NSString stringWithFormat:@"¥%@",model.price.minOriginalPrice]]];
//    _goodsPriceLabel.attributedText = attritu;
}

//根据选择的属性组合刷新商品信息
-(void)resetData:(SizeAttributeModel *)sizeModel
{
    //如果有图片就显示图片，没图片就显示默认图
    if (sizeModel.imageId.length>0) {
        NSLog(@"sizeModel.imageId = %@",sizeModel.imageId);
        
      [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sizeModel.imageId]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    }else
        [_goodsImage setImage:[UIImage imageNamed:@"foodimg"]];
    
    _goodsCountLabel.text = [NSString stringWithFormat:@"库存：%@",sizeModel.stock];
   // _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@ ¥%@",sizeModel.price,sizeModel.originalPrice];
    
    if (sizeModel.price.integerValue == 0) {
        _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",sizeModel.originalPrice];
    }else{
        _goodsPriceLabel.text = [NSString stringWithFormat:@"原价:¥%@ 会员价:¥%@ ",sizeModel.originalPrice,sizeModel.price];
        
        NSMutableAttributedString *attritu = [[NSMutableAttributedString alloc]initWithString:_goodsPriceLabel.text];
        [attritu addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleNone), NSForegroundColorAttributeName: [UIColor lightGrayColor],NSBaselineOffsetAttributeName:@(0),
                                 NSFontAttributeName: [UIFont systemFontOfSize:13]
                                 } range:[_goodsPriceLabel.text rangeOfString:[NSString stringWithFormat:@"会员价:¥%@",sizeModel.price]]];
        _goodsPriceLabel.attributedText = attritu;
    }
 
}

@end
