//
//  SVMoreSpecificationVC.m
//  SAVI
//
//  Created by houming Wang on 2018/12/3.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVMoreSpecificationVC.h"
//#import "ChoseView.h"
#import "SVduoguigeModel.h"
#import "SVAtteilistModel.h"
#import "SVSpecModel.h"
#import "SVNumBlockModel.h"

#import "ChoseGoodsTypeAlert.h"
#import "SizeAttributeModel.h"
#import "GoodsTypeModel.h"
#import "Header.h"
@interface SVMoreSpecificationVC ()<UITextFieldDelegate>
{
//    ChoseView *choseView;
    UIView *bgview;
    CGPoint center;
    NSMutableDictionary *stockarr;//商品库存量
    int goodsStock;
    
    
    GoodsModel *model;
}
@property (nonatomic,strong) NSMutableArray *duoguigeArray;
@property (nonatomic,strong) NSMutableArray *sizearr;//型号数组
@property (nonatomic,strong) NSMutableArray *colorarr;//分类数组
@property (nonatomic,strong) NSMutableArray *listAry1;
@property (nonatomic,strong) NSMutableArray *listAry2;
@property (nonatomic,strong) NSMutableArray *moneyArray;
@property (nonatomic,strong) NSMutableArray *moneyArray1;
@property (nonatomic,strong) NSMutableArray *memberPriceArray;// 会员售价
@property (nonatomic,strong) NSMutableArray *shop_sv_p_images2Array;// 图片

@property (nonatomic,strong) NSString *size;
@property (nonatomic,strong) NSString *color;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *memberPrice;// 会员价格
@property (nonatomic,strong) NSString *shop_sv_p_images2;
@end

@implementation SVMoreSpecificationVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.sv_p_name;
    self.view.backgroundColor = [UIColor whiteColor];
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    /**
     这些数据应该从服务器获得 没有服务器我就只能先写死这些数据了
     */
   [self loadduoguigeProduct];
    
   
}

- (void)setUpUI{
    ChoseGoodsTypeAlert *_alert = [[ChoseGoodsTypeAlert alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andHeight:kHeight];
    _alert.alpha = 0;
    // [[UIApplication sharedApplication].keyWindow addSubview:_alert];
    
    [self.view addSubview:_alert];
    __weak typeof(self) weakSelf = self;
    _alert.selectSize = ^(SizeAttributeModel *sizeModel) {
        //sizeModel 选择的属性模型
        NSString *str = [NSString stringWithFormat:@"选择了：%@,\n 原价==%@,\n 库存==%@,\n ID==%@,\n 会员价==%@",sizeModel.value,sizeModel.originalPrice,sizeModel.stock,sizeModel.sizeid,sizeModel.price];
        
      
//        [JXUIKit showSuccessWithStatus:str];
        
        
        // 构建返回上一个控制器的模型
        SVSelectedGoodsModel *model = [[SVSelectedGoodsModel alloc]init];
        // 找到颜色尺寸
        if (sizeModel.value.length) {
            NSRange range ;
            NSString *attriString = sizeModel.value;
            range.location = [sizeModel.value rangeOfString:@","].location;
            model.color = [attriString substringToIndex:range.location];
            model.size = [attriString substringFromIndex:range.location+1];
            NSLog(@"model.color==%@   model.size==%@",model.color,model.size);
        }
        model.sv_p_unitprice = sizeModel.originalPrice;// 原价
        model.product_num = sizeModel.count.integerValue;// 数量
        model.sv_p_name = self.sv_p_name; // 商品名称
        model.sv_p_memberprice = sizeModel.price;// 会员价
        model.sv_p_images2 = sizeModel.imageId; // 图片
        model.product_id = sizeModel.sizeid; // id
        model.sv_is_newspec = 1;// 是多规格
        model.sv_p_storage = sizeModel.stock;// 库存
        model.sv_p_unit = sizeModel.sv_p_unit;
        model.sv_p_barcode = sizeModel.sv_p_barcode;
        model.sv_p_specs = sizeModel.value;// 规格
        model.sv_purchaseprice = sizeModel.sv_purchaseprice;// 进货价
        NSLog(@"model = %@--%@--%@--%ld",sizeModel.value,model.sv_p_unitprice,model.sv_p_memberprice,model.product_num);
        
        self.numBlock(model);
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    };
    [_alert initData:model];
    
    
    [_alert showView];
}


- (void)loadduoguigeProduct{

    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetMorespecSubProductList?id=%@&key=%@",self.productID,[SVUserManager shareInstance].access_token];
    NSLog(@"urlStr = %@",urlStr);

    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
       NSLog(@"dic8888 = %@",dic);

        self.duoguigeArray = [SVduoguigeModel mj_objectArrayWithKeyValuesArray:dic[@"values"][@"productCustomdDetailList"]];
        
        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *sizes = [NSMutableArray array];
        NSMutableArray *sizeAttributeArray = [NSMutableArray array];
        [self.duoguigeArray enumerateObjectsUsingBlock:^(SVduoguigeModel *duoguigeModel, NSUInteger idx, BOOL * _Nonnull stop) {
            // 颜色
            NSString *colorStr = @"";
            SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
            SVAtteilistModel *atteilistModel = specModel.attrilist.firstObject;
            colorStr = atteilistModel.attri_name;
            [colors addObject:colorStr];
            // 尺码
            NSString *sizeStr = @"";
            SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
            SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
            sizeStr = atteilistModel2.attri_name;
            [sizes addObject:sizeStr];
            
            // 商品可选规格属性（就是返回的数据的模型的各个字段）
            if (duoguigeModel.sv_p_specs.length) {
                
                SizeAttributeModel *sizeAttModel = [[SizeAttributeModel alloc]init];
                sizeAttModel.sizeid = duoguigeModel.product_id; // 商品ID
                sizeAttModel.value = duoguigeModel.sv_p_specs; // 可选属性组合
                sizeAttModel.price = duoguigeModel.sv_p_memberprice; // 会员价
                sizeAttModel.originalPrice = duoguigeModel.sv_p_unitprice; // 原价
                sizeAttModel.stock = duoguigeModel.sv_p_storage;//库存
                sizeAttModel.imageId = duoguigeModel.sv_p_images2;// 图片
                sizeAttModel.sv_p_unit = duoguigeModel.sv_p_unit;// 单位
                sizeAttModel.sv_p_barcode = duoguigeModel.sv_p_barcode; // 款号
                sizeAttModel.sv_purchaseprice = duoguigeModel.sv_purchaseprice; // 进货价
                [sizeAttributeArray addObject:sizeAttModel];
            }
        }];
        // 颜色去重
        for (NSString *str in colors) {
            if (![self.listAry1 containsObject:str]) {
                [self.listAry1 addObject:str];
            }
        }
        // 尺码去重
        for (NSString *str in sizes) {
            if (![self.listAry2 containsObject:str]) {
                [self.listAry2 addObject:str];
            }
        }
        model = [[GoodsModel alloc] init];
        model.imageId = self.sv_p_images2;
        model.goodsNo = @"商品名";
        model.title = @"商品标题";
        model.totalStock = @"0";
        
        //价格信息
        model.price = [[GoodsPriceModel alloc] init];
        model.price.minPrice = @"0";
        model.price.maxPrice = @"0";
        model.price.minOriginalPrice = @"0";
        model.price.maxOriginalPrice = @"0";
        
        //属性-应该从服务器获取属性列表
        GoodsTypeModel *type = [[GoodsTypeModel alloc] init];
        type.selectIndex = -1;
        type.typeName = @"尺码";
        type.typeArray = self.listAry2;
        
        GoodsTypeModel *type2 = [[GoodsTypeModel alloc] init];
        type2.selectIndex = -1;
        type2.typeName = @"颜色";
        type2.typeArray = self.listAry1;
        model.itemsList = @[type,type2];
        NSLog(@"sizeAttributeArray = %@",sizeAttributeArray);
        
        //属性组合数组-有时候不同的属性组合价格库存都会有差异，选择完之后要对应修改商品的价格、库存图片等信息，可能是获得商品信息时将属性数组一并返回，也可能属性选择后再请求服务器获得属性组合对应的商品信息，根据自己的实际情况调整
        model.sizeAttribute = sizeAttributeArray;
        
        [self setUpUI];
       
//      [self initview];

        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}




#pragma mark - 懒加载
- (NSMutableArray *)duoguigeArray
{
    if (_duoguigeArray == nil) {
        _duoguigeArray = [NSMutableArray array];
    }
    return _duoguigeArray;
}

- (NSMutableArray *)sizearr
{
    if (_sizearr == nil) {
        _sizearr = [NSMutableArray array];
    }
    return _sizearr;
}

- (NSMutableArray *)colorarr
{
    if (_colorarr == nil) {
        _colorarr = [NSMutableArray array];
    }
    return _colorarr;
}

- (NSMutableArray *)listAry1
{
    if (_listAry1 == nil) {
        _listAry1 = [NSMutableArray array];
    }
    return _listAry1;
}

- (NSMutableArray *)listAry2
{
    if (_listAry2 == nil) {
        _listAry2 = [NSMutableArray array];
    }
    return _listAry2;
}

- (NSMutableArray *)moneyArray
{
    if (_moneyArray == nil) {
        _moneyArray = [NSMutableArray array];
    }
    return _moneyArray;
}

- (NSMutableArray *)moneyArray1
{
    if (_moneyArray1 == nil) {
        _moneyArray1 = [NSMutableArray array];
    }
    return _moneyArray1;
}

// 会员价
- (NSMutableArray *)memberPriceArray{
    if (_memberPriceArray == nil) {
        _memberPriceArray = [NSMutableArray array];
    }
    return _memberPriceArray;
}

// 图片
- (NSMutableArray *)shop_sv_p_images2Array{
    if (_shop_sv_p_images2Array == nil) {
        _shop_sv_p_images2Array = [NSMutableArray array];
    }
    return _shop_sv_p_images2Array;
}

@end
