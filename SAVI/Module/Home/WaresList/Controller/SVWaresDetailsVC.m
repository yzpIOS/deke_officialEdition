//
//  SVWaresDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 2017/5/26.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVWaresDetailsVC.h"
//修改商品
#import "SVModifyWaresVC.h"
#import "SVduoguigeModel.h"
//查看销售记录
#import "SVWaresRecordVC.h"
#import "JJPhotoManeger.h"
#import "SVSpecModel.h"
#import "SVAtteilistModel.h"
#import "SVAddMoreSpecificationsVC.h"
#import "SVDetailAttrilistModel.h"
@interface SVWaresDetailsVC ()<JJPhotoDelegate>

@property (weak, nonatomic) IBOutlet UIView *duoguigeView;

//图片路径
@property (nonatomic,copy) NSString *imgURL;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

//名称
@property (weak, nonatomic) IBOutlet UILabel *waresName;
//价格
@property (weak, nonatomic) IBOutlet UILabel *money;
//库存
@property (weak, nonatomic) IBOutlet UILabel *inventory;

//款号
@property (weak, nonatomic) IBOutlet UILabel *barcode;
//分类
@property (weak, nonatomic) IBOutlet UILabel *waresClass;

@property (nonatomic, assign) NSInteger productcategory_id;
@property (nonatomic, assign) NSInteger productsubcategory_id;
@property (nonatomic, assign) NSInteger producttype_id;

@property (weak, nonatomic) IBOutlet UILabel *sv_p_memberprice;
//进价
@property (weak, nonatomic) IBOutlet UILabel *purchaseprice;
@property (weak, nonatomic) IBOutlet UILabel *symbol;
//查看按钮
//@property (weak, nonatomic) IBOutlet UIButton *see;
//规格
@property (weak, nonatomic) IBOutlet UILabel *specifications;
//单位
@property (weak, nonatomic) IBOutlet UILabel *unit;
//时间
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;

//弹框的textField
@property (nonatomic,assign) BOOL noLook;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property(nonatomic,strong)NSMutableArray *imageArr;

@property(nonatomic,strong)NSMutableArray *picUrlArr;

@property (nonatomic,strong) NSMutableArray *duoguigeArray;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@property (nonatomic,strong) NSMutableArray *masonryViewArray;
@property (nonatomic,strong) NSMutableArray *masonryViewArray2;
@property (nonatomic,strong) NSMutableArray *masonryViewArray3;
@property (nonatomic,strong) NSMutableArray *saveArray;

@property (nonatomic,strong) NSMutableArray *listAry1;
@property (nonatomic,strong) NSMutableArray *listAry2;

@property (nonatomic,strong) NSString *sv_pricing_method;

@property (nonatomic,strong) NSString *attri_group;

@property (weak, nonatomic) IBOutlet UIView *PurchasePriceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PurchasePrice_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_height;
@property (nonatomic,strong) NSMutableArray *productCustomdDetailList;

@property (nonatomic,strong) NSMutableArray *detailTextArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeight;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (nonatomic,strong) NSString * sv_p_memberprice1;
@property (nonatomic,strong) NSString * sv_p_memberprice2;
@property (nonatomic,strong) NSString * sv_p_memberprice3;
@property (nonatomic,strong) NSString * sv_p_memberprice4;
@property (nonatomic,strong) NSString * sv_p_memberprice5;

@property (nonatomic,strong) NSString * sv_p_tradeprice1;
@property (nonatomic,strong) NSString * sv_p_tradeprice2;
@property (nonatomic,strong) NSString * sv_p_tradeprice3;
@property (nonatomic,strong) NSString * sv_p_tradeprice4;
@property (nonatomic,strong) NSString * sv_p_tradeprice5;

@property (nonatomic,strong) NSString * sv_mnemonic_code;
@property (nonatomic,strong) NSString * sv_p_artno;
@property (nonatomic,strong) NSString * sv_p_minunitprice;
@property (nonatomic,strong) NSString * sv_p_mindiscount;
@property (nonatomic,strong) NSString * sv_guaranteeperiod;
//会员售价
@property (nonatomic,copy) NSString *sv_p_memberpriceStr;

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@end

@implementation SVWaresDetailsVC

- (NSMutableArray *)productCustomdDetailList
{
    if (_productCustomdDetailList == nil) {
        _productCustomdDetailList = [NSMutableArray array];
    }
    return _productCustomdDetailList;
}

- (NSMutableArray *)duoguigeArray
{
    if (_duoguigeArray == nil) {
        _duoguigeArray = [NSMutableArray array];
    }
    return _duoguigeArray;
}

- (NSMutableArray *)masonryViewArray
{
    if (_masonryViewArray == nil) {
        _masonryViewArray = [NSMutableArray array];
    }
    return _masonryViewArray;
}

- (NSMutableArray *)masonryViewArray2
{
    if (_masonryViewArray2 == nil) {
        _masonryViewArray2 = [NSMutableArray array];
    }
    return _masonryViewArray2;
}

- (NSMutableArray *)masonryViewArray3
{
    if (_masonryViewArray3 == nil) {
        _masonryViewArray3 = [NSMutableArray array];
    }
    return _masonryViewArray3;
}

- (NSMutableArray *)saveArray
{
    if (_saveArray == nil) {
        _saveArray = [NSMutableArray array];
    }
    return _saveArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.titleNameLabel.text = @"款号";
    }else{
        self.titleNameLabel.text = @"条码";
    }
    //标题
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"产品详情";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
     self.navigationItem.title = @"产品详情";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
//    [self requestData];
    
    self.purchaseprice.hidden = YES;
    self.symbol.hidden = YES;
    
    //添加修改按钮
    UIBarButtonItem *releaseButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ModifyOne"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = releaseButon;
    
    self.noLook = YES;
    self.lookButton.layer.cornerRadius = 4;
    
    self.iconImage.layer.cornerRadius = 5;
    self.iconImage.layer.masksToBounds = YES;

    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
      if (kDictIsEmpty(sv_versionpowersDict)) {
            self.PurchasePriceView.hidden = NO;
            self.PurchasePrice_height.constant = 50;
      }else{
       NSString *Sv_purchaseprice = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"CommodityManage"][@"Sv_purchaseprice"]];
          if ([Sv_purchaseprice isEqualToString:@"1"]) {
              self.PurchasePriceView.hidden = NO;
              self.PurchasePrice_height.constant = 50;
          }else{
               self.PurchasePriceView.hidden = YES;
                             self.PurchasePrice_height.constant = 0;
                             self.view_height.constant = 0;
          }
      }
    
    
    if (self.sv_is_newspec == 1) {
        self.duoguigeView.hidden = NO;
    }
    
    [self loadduoguigeProduct];
    
}
// 加载多个产品
- (void)loadduoguigeProduct{
    
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetMorespecSubProductList?id=%@&key=%@",self.productID,[SVUserManager shareInstance].access_token];
    NSLog(@"urlStr = %@",urlStr);
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
       NSLog(@"dic8888 = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
        NSArray *Product_array = dic[@"values"][@"productCustomdDetailList"];
        if (kArrayIsEmpty(Product_array)) {
            self.duoguigeArray = nil;
        }else{
            self.duoguigeArray = [SVduoguigeModel mj_objectArrayWithKeyValuesArray:dic[@"values"][@"productCustomdDetailList"]];
        }
       
        [self.detailTextArray removeAllObjects];
        [self.detailView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // 新建一个数组，保存所有颜色
        NSMutableArray *colorsArray = [NSMutableArray array];
        // 只保存不同的颜色
        NSMutableArray *colorsArray2 = [NSMutableArray array];
        
        // 大数组保存各种颜色
        NSMutableArray *bigColorArrays = [NSMutableArray array];

        
        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *sizes = [NSMutableArray array];
        
        for (SVduoguigeModel *model in self.duoguigeArray) {
            // 取得颜色模型
            if (model.sv_is_active == 0) { // 不是删除的产品
                SVSpecModel *specModel = model.sv_cur_spec.firstObject;
                SVAtteilistModel *attriModel = specModel.attrilist.firstObject;
                [colorsArray addObject:attriModel.attri_name];
                [colors addObject:attriModel.attri_name];
                
                SVSpecModel *specModel2 = model.sv_cur_spec.lastObject;
                SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
                self.attri_group = atteilistModel2.attri_group;
                
                [sizes addObject:atteilistModel2.attri_name];
            }
           
        }
        
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
        
        NSDictionary *dic2 = [NSDictionary dictionary];
        dic2 = dic[@"values"];
        
        self.imgURL = [NSString stringWithFormat:@"%@",dic2[@"sv_p_images2"]];
        
        //名称
        self.waresName.text = dic2[@"sv_p_name"];
        //售价
        self.money.text = [NSString stringWithFormat:@"%@",dic2[@"sv_p_unitprice"]];
        //库存
        self.inventory.text = [NSString stringWithFormat:@"%@", dic2[@"sv_p_storage"]];
        //款号
        self.barcode.text = [NSString stringWithFormat:@"%@",dic2[@"sv_p_barcode"]];
        // 计重还是计件商品
       // self.sv_pricing_method = dic2[@"sv_pricing_method"];
        self.sv_pricing_method = [NSString stringWithFormat:@"%@",dic2[@"sv_pricing_method"]];
        //分类
        if ([dic2[@"sv_pc_name"] isEqual:[NSNull null]]) {
            self.waresClass.text = @"";
        } else {
            self.waresClass.text = [NSString stringWithFormat:@"%@",dic2[@"sv_pc_name"]];
            self.producttype_id = [dic2[@"producttype_id"] integerValue];
            self.productcategory_id = [dic2[@"productcategory_id"] integerValue];
            self.productsubcategory_id = [dic2[@"productsubcategory_id"] integerValue];
        }
        
        
        //进价
        self.purchaseprice.text = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_purchaseprice"] floatValue]];
        //规格
        self.specifications.text = [NSString stringWithFormat:@"%@",dic2[@"sv_p_specs"]];
        //单位
        self.unit.text = [NSString stringWithFormat:@"%@",dic2[@"sv_p_unit"]];
        
//        sv_mnemonic_code
//        sv_p_artno
        NSString *sv_mnemonic_code = [NSString stringWithFormat:@"%@",dic2[@"sv_mnemonic_code"]];
        if (!kStringIsEmpty(sv_mnemonic_code)) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"助词码";
            dictM[@"detailText"] = sv_mnemonic_code;
            self.sv_mnemonic_code = sv_mnemonic_code;
            [self.detailTextArray addObject:dictM];
        }
        
        NSString *sv_guaranteeperiod = [NSString stringWithFormat:@"%@",dic2[@"sv_guaranteeperiod"]];
        if (!kStringIsEmpty(sv_guaranteeperiod)) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"质保天数";
            dictM[@"detailText"] = sv_guaranteeperiod;
            self.sv_guaranteeperiod = sv_guaranteeperiod;
            [self.detailTextArray addObject:dictM];
        }
        
        NSString *sv_p_artno = [NSString stringWithFormat:@"%@",dic2[@"sv_p_artno"]];
        if (!kStringIsEmpty(sv_p_artno)) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"条码";
            dictM[@"detailText"] = sv_p_artno;
            self.sv_p_artno = sv_p_artno;
            [self.detailTextArray addObject:dictM];
        }
        
        // 最低价
        NSString *sv_p_minunitprice = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_minunitprice"] doubleValue]];
        if (sv_p_minunitprice.doubleValue > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"最低价";
            dictM[@"detailText"] = sv_p_minunitprice;
            self.sv_p_minunitprice = sv_p_minunitprice;
            [self.detailTextArray addObject:dictM];
        }
        // 最低折
        NSString *sv_p_mindiscount = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_mindiscount"]doubleValue]];
        if (sv_p_mindiscount.doubleValue > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"最低折";
            dictM[@"detailText"] = sv_p_mindiscount;
            self.sv_p_mindiscount = sv_p_mindiscount;
            [self.detailTextArray addObject:dictM];
        }
      
            // 会员价
            NSString *sv_p_memberprice = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice"] doubleValue]];
            if (sv_p_memberprice.doubleValue > 0) {
                self.sv_p_memberprice.text = sv_p_memberprice;
                self.sv_p_memberpriceStr = sv_p_memberprice;
            }
        
        // 批发价和会员价
        if ([dic2[@"sv_p_memberprice1"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"会员价1";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice1"] doubleValue]];
            self.sv_p_memberprice1 =  [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice1"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        if ([dic2[@"sv_p_memberprice2"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"会员价2";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice2"] doubleValue]];
            self.sv_p_memberprice2 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice2"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        if ([dic2[@"sv_p_memberprice3"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"会员价3";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice3"] doubleValue]];
            self.sv_p_memberprice3 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice3"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        if ([dic2[@"sv_p_memberprice4"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"会员价4";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice4"] doubleValue]];
            self.sv_p_memberprice4 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice4"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        if ([dic2[@"sv_p_memberprice5"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"会员价5";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice5"] doubleValue]];
            self.sv_p_memberprice5 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_memberprice5"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        // 批发价
        if ([dic2[@"sv_p_tradeprice1"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"批发价1";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice1"] doubleValue]];
            self.sv_p_tradeprice1 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice1"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        if ([dic2[@"sv_p_tradeprice2"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"批发价2";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice2"] doubleValue]];
            self.sv_p_tradeprice2 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice2"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        if ([dic2[@"sv_p_tradeprice3"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"批发价3";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice3"] doubleValue]];
            self.sv_p_tradeprice3 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice3"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        if ([dic2[@"sv_p_tradeprice4"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"批发价4";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice4"] doubleValue]];
            self.sv_p_tradeprice4 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice4"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        if ([dic2[@"sv_p_tradeprice5"] doubleValue] > 0) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"name"] = @"批发价5";
            dictM[@"detailText"] = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice5"] doubleValue]];
            self.sv_p_tradeprice5 = [NSString stringWithFormat:@"%.2f",[dic2[@"sv_p_tradeprice5"] doubleValue]];
            [self.detailTextArray addObject:dictM];
        }
        
        
        if (!kArrayIsEmpty(self.detailTextArray)) {
            self.detailHeight.constant = self.detailTextArray.count *50 + self.detailTextArray.count - 1;
            for (int i = 0; i < self.detailTextArray.count; i++) {
                NSDictionary *dict = self.detailTextArray[i];
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 50 *i +i, ScreenW, 50)];
                view.backgroundColor = [UIColor whiteColor];
                [self.detailView addSubview:view];
                UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 30)];
                leftLabel.textColor = [UIColor colorWithHexString:@"686868"];
                leftLabel.font = [UIFont systemFontOfSize:15];
              //  NSDictionary *dict = weakSelf.textArray[i];
                leftLabel.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
                [leftLabel sizeToFit];
                leftLabel.centerY = 50/2;
                [view addSubview:leftLabel];
                
               
                UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 10 - 150, 10, 150, 30)];
                rightLabel.textColor = [UIColor colorWithHexString:@"686868"];
                
                rightLabel.font = [UIFont systemFontOfSize:15];
                //  NSDictionary *dict = weakSelf.textArray[i];
                rightLabel.text = [NSString stringWithFormat:@"%@",dict[@"detailText"]];
               
               // [rightLabel sizeToFit];
                rightLabel.textAlignment = NSTextAlignmentRight;
                
                rightLabel.centerY = 50/2;
                [view addSubview:rightLabel];
            }
        }
        
        NSLog(@"去重前==%@",colorsArray);

        // 去重
        for (NSString *color in colorsArray) {
            if (![colorsArray2 containsObject:color]) {
                if (colorsArray2.count) {
                    NSString *color1 = colorsArray2.firstObject;
                    NSLog(@"测试：%@有%ld个",color1,colorsArray2.count);
                    NSArray *tempArr = [NSArray arrayWithArray:colorsArray2];
                    [bigColorArrays addObject:tempArr];
                    colorsArray2 = [NSMutableArray array];
                    [colorsArray2 addObject:color];
                }else {
                    [colorsArray2 addObject:color];
                }
            }else {
                [colorsArray2 addObject:color];
            }
        }
        
        
        NSString *color1 = colorsArray2.firstObject;
        NSLog(@"%@有%ld个",color1,colorsArray2.count);
        NSArray *tempArr = [NSArray arrayWithArray:colorsArray2];
        [bigColorArrays addObject:tempArr];
        
         NSLog(@"bigColorArrays = %@",bigColorArrays);

        CGFloat maxY = 0;
        for (NSArray *colorArray in bigColorArrays) {
            
            UILabel *leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY , self.oneView.frame.size.width, colorArray.count*50 + colorArray.count - 1)];
            leftLabel2.backgroundColor = [UIColor whiteColor];
            leftLabel2.textColor = [UIColor colorWithHexString:@"555555"];
            leftLabel2.font = [UIFont systemFontOfSize:15];
            leftLabel2.text = colorArray.firstObject;
            leftLabel2.textAlignment = NSTextAlignmentCenter;
            [self.oneView addSubview:leftLabel2];
            maxY = CGRectGetMaxY(leftLabel2.frame)+1;
        }
        
        NSMutableArray *chicunArray = [NSMutableArray array];
        CGFloat maxYTwo = 0;
        for (SVduoguigeModel *model in self.duoguigeArray) {
            if (model.sv_is_active == 0) {
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, maxYTwo, self.twoView.frame.size.width, 50)];
                label2.backgroundColor = [UIColor whiteColor];
                label2.textAlignment = NSTextAlignmentCenter;
                label2.text = model.sv_p_specs;
                if (model.sv_cur_spec.count >= 2) {
                    SVSpecModel *SpecModel = model.sv_cur_spec[1];
                    SVAtteilistModel *AtteilistModel = SpecModel.attrilist[0];
                    label2.text = AtteilistModel.attri_name;
                    label2.font = [UIFont systemFontOfSize:15];
                    label2.textColor = [UIColor colorWithHexString:@"555555"];
                    [self.twoView addSubview:label2];
                    maxYTwo = CGRectGetMaxY(label2.frame)+1;
                    [chicunArray addObject:AtteilistModel.attri_name];
                }else{
                   SVSpecModel *SpecModel = model.sv_cur_spec[0];
                    SVAtteilistModel *AtteilistModel = SpecModel.attrilist[0];
                    label2.text = AtteilistModel.attri_name;
                    label2.font = [UIFont systemFontOfSize:15];
                    label2.textColor = [UIColor colorWithHexString:@"555555"];
                    [self.twoView addSubview:label2];
                    maxYTwo = CGRectGetMaxY(label2.frame)+1;
                    [chicunArray addObject:AtteilistModel.attri_name];
                }
                
                
            }
      
        }
        
        
        CGFloat maxYThree = 0;
        NSMutableArray *kucunArray = [NSMutableArray array];
        for (SVduoguigeModel *model in self.duoguigeArray) {
            if (model.sv_is_active == 0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, maxYThree, self.threeView.frame.size.width, 50)];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor whiteColor];
                label.text = model.sv_p_storage;
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = [UIColor colorWithHexString:@"555555"];
                [self.threeView addSubview:label];
                maxYThree = CGRectGetMaxY(label.frame)+1;
                [kucunArray addObject:model.sv_p_storage];
            }
          
        }
        
        self.height.constant = 48+(kucunArray.count + 1) *50 +kucunArray.count + 2;
        //请求数据
        [self requestData];
            
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)test_masonry_vertical_fixSpace2{
    // 实现masonry垂直固定控件高度方法
    [self.masonryViewArray3 mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:1];
    
    // 设置array的水平方向的约束
    [self.masonryViewArray3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.threeView.mas_left);
        make.width.mas_equalTo(self.threeView.mas_width);
        make.height.mas_equalTo(50);
     
    }];
}

 #pragma mark - 查看商品销售响应方法
- (IBAction)lookWaresRecord {
    
    SVWaresRecordVC *VC = [[SVWaresRecordVC alloc]init];
    
    VC.productID = self.productID;
    VC.unitName = self.unit.text;
    VC.sv_is_newspec = self.sv_is_newspec;
    
    [self.navigationController pushViewController:VC animated:YES];
}

//查看进价隐藏调用方法
- (IBAction)seeBtnClick {
    
    [SVUserManager loadUserInfo];
    // [SVUserManager shareInstance].isStore integerValue] == 1 || [[SVUserManager shareInstance].is_SalesclerkLogin integerValue] == 1
    //判断是权限，只有店主能看
    if ([[SVUserManager shareInstance].addShop isEqualToString:@"0"]) {
        [SVTool TextButtonAction:self.view withSing:@"无此权限，查看"];
        return;
    }
    
    if (self.noLook == YES) {
        
        //创建弹框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入登陆密码" preferredStyle:UIAlertControllerStyleAlert];
        
        //在弹框加textfield
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            
            textField.placeholder = @"密码";
            
            textField.secureTextEntry = YES;
            
            
        }];
        //创建查看按钮
        UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *login = alertController.textFields.firstObject;
            
            //当字符串里有数字和字母混合时，不能直接用“==”来作判断，如：login.text == [SVUserManager shareInstance].passwd
            if ([login.text isEqualToString:[SVUserManager shareInstance].passwd] ) {
            
                self.purchaseprice.hidden = NO;
                self.symbol.hidden = NO;
                
                [self.lookButton setTitle:@"隐藏" forState:UIControlStateNormal];
                
                self.noLook = NO;
                
            } else {
                self.noLook = YES;
//                [SVProgressHUD showErrorWithStatus:@"密码错误"];
//                //用延迟来移除提示框
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                });
                [SVTool TextButtonAction:self.view withSing:@"密码错误"];
            }
            
            
        }];
        //创建取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        //将按钮添加到UIAlertController弹框上
        [alertController addAction:derAction];
        [alertController addAction:cancelAction];
        //将弹框添加到View上
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    } else {
        self.noLook = YES;
        self.purchaseprice.hidden = YES;
        self.symbol.hidden = YES;
        [self.lookButton setTitle:@"查看" forState:UIControlStateNormal];
    }
    
}
////查看进价隐藏调用方法


#pragma mark - 修改按钮响应方法
-(void)onClickedOKbtn{
    
    [SVUserManager loadUserInfo];
    if (![[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        
        if (!kArrayIsEmpty(self.duoguigeArray)) {
            
            return [SVTool TextButtonAction:self.view withSing:@"目前仅支持服装行业修改"];
            
            SVAddMoreSpecificationsVC *VC = [[SVAddMoreSpecificationsVC alloc] init];
            [SVUserManager loadUserInfo];
            //判断是权限，只有店主能看
            if ([[SVUserManager shareInstance].addShop isEqualToString:@"0"]) {
                [SVTool TextButtonAction:self.view withSing:@"无此权限，查看"];
                return;
            }
            //全局属性
            VC.imgURL = self.imgURL;
            
            //产品ID
            VC.product_id = self.productID;
            
            //款号
            VC.barcode = self.barcode.text;
            
            ////商品名称
            VC.waresName = self.waresName.text;
            
            ////分类
            VC.classification = self.waresClass.text;
            //
            ////售价
            VC.price = self.money.text;
            
            ////库存
            VC.inventory = self.inventory.text;
            /// 计重还是计件
            VC.sv_pricing_method = self.sv_pricing_method;
            ///
            VC.sv_p_memberprice = self.sv_p_memberprice.text;
            
            ////进价
            VC.purchaseprice = self.purchaseprice.text;
            
            ////规格
            VC.specifications = self.specifications.text;

            ////单位
            VC.unit = self.unit.text;
            
            VC.producttype_id = self.producttype_id;
            VC.productcategory_id = self.productcategory_id;
            VC.productsubcategory_id = self.productsubcategory_id;
            VC.firstColorArray = self.listAry1;
            VC.allColorArray = self.listAry1;
            VC.colorArray = self.listAry1;
            NSMutableArray *sizeArray = [NSMutableArray array];
            for (NSString *sizeStr in self.listAry2) {
                SVDetailAttrilistModel *model = [[SVDetailAttrilistModel alloc] init];
                model.attri_name = sizeStr;
                [sizeArray addObject:model];
            }
            
            VC.editInterface = 1;
            VC.sizeStrArray = self.listAry2;
            
            
            VC.sizeTwoArray = sizeArray;
            
            VC.duoguigeArray = self.duoguigeArray;
            
            VC.attri_group = self.attri_group;
            VC.firstSizeArray = self.listAry2;
            VC.product_id = self.productID;
            //   VC.diffcultFirstColorArray = self.listAry1;
            [self.navigationController pushViewController:VC animated:YES];
        }else{
                [SVUserManager loadUserInfo];
                //判断是权限，只有店主能看
                if ([[SVUserManager shareInstance].addShop isEqualToString:@"0"]) {
                    [SVTool TextButtonAction:self.view withSing:@"无此权限，查看"];
                    return;
                }
            
                SVModifyWaresVC *VC = [[SVModifyWaresVC alloc]init];
                //全局属性
                VC.imgURL = self.imgURL;
            
                //产品ID
                VC.product_id = self.productID;
            
                //款号
                VC.barcode = self.barcode.text;
            
                ////商品名称
                VC.waresName = self.waresName.text;
            
                ////分类
                VC.classification = self.waresClass.text;
                //
                ////售价
                VC.price = self.money.text;
            
                /// 计重还是计件
                VC.sv_pricing_method = self.sv_pricing_method;
            
                ////库存
                VC.inventory = self.inventory.text;
            
                ///
              //  VC.sv_p_memberprice = self.sv_p_memberpriceStr;
            
                ////进价
                VC.purchaseprice = self.purchaseprice.text;
            
                ////规格
                VC.specifications = self.specifications.text;
            
                ////单位
                VC.unit = self.unit.text;
            
                VC.producttype_id = self.producttype_id;
                VC.productcategory_id = self.productcategory_id;
                VC.productsubcategory_id = self.productsubcategory_id;
            
            
            VC.sv_p_memberprice = self.sv_p_memberpriceStr;
            VC.sv_p_memberprice1 = self.sv_p_memberprice1;
            VC.sv_p_memberprice2 = self.sv_p_memberprice2;
            VC.sv_p_memberprice3 = self.sv_p_memberprice3;
            VC.sv_p_memberprice4 = self.sv_p_memberprice4;
            VC.sv_p_memberprice5 = self.sv_p_memberprice5;
            VC.sv_p_tradeprice1 = self.sv_p_tradeprice1;
            VC.sv_p_tradeprice2 = self.sv_p_tradeprice2;
            VC.sv_p_tradeprice3 = self.sv_p_tradeprice3;
            VC.sv_p_tradeprice4 = self.sv_p_tradeprice4;
            VC.sv_p_tradeprice5 = self.sv_p_tradeprice5;
    //        sv_mnemonic_code;
    //        @property (nonatomic,strong) NSString * sv_p_artno;
    //        @property (nonatomic,strong) NSString * sv_p_minunitprice;
    //        @property (nonatomic,strong) NSString * sv_p_mindiscount;
            VC.sv_mnemonic_code = self.sv_mnemonic_code;
            VC.sv_p_artno = self.sv_p_artno;
            VC.sv_p_minunitprice = self.sv_p_minunitprice;
            VC.sv_p_mindiscount = self.sv_p_mindiscount;
            VC.sv_guaranteeperiod = self.sv_guaranteeperiod;
            
                __weak typeof(self) weakSelf = self;
                VC.ModifyWaresBlock = ^(){
                    self.sv_p_memberpriceStr = @"";
                    self.sv_p_memberprice1 = @"";
                    self.sv_p_memberprice2= @"";
                    self.sv_p_memberprice3= @"";
                    self.sv_p_memberprice4= @"";
                    self.sv_p_memberprice5= @"";

                    self.sv_p_tradeprice1= @"";
                    self.sv_p_tradeprice2= @"";
                    self.sv_p_tradeprice3= @"";
                    self.sv_p_tradeprice4= @"";
                    self.sv_p_tradeprice5= @"";
                    self.sv_p_mindiscount = @"";
                    self.sv_p_minunitprice = @"";
                    self.sv_p_memberprice.text = @"";
                    //重新数据
                    [weakSelf requestData];
                    [weakSelf loadduoguigeProduct];
                    //block
                    if (weakSelf.WaresDetailsBlock) {
                        weakSelf.WaresDetailsBlock();
                    }
                };
            
                [self.navigationController pushViewController:VC animated:YES];
        }
    }
 
 

    
}


#pragma mark -  获取产品实体
-(void)requestData{
    //URL
    //NSString *strURL = [URLhead stringByAppendingFormat:@"/product/%@?key=%@",self.productID,[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    [SVUserManager loadUserInfo];
    NSString *strURL = [URLhead stringByAppendingFormat:@"/product/%@?key=%@",self.productID,[SVUserManager shareInstance].access_token];
  //  NSLog(@"%@",strURL);
    
    //请求
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *dict = dic[@"values"];
        NSLog(@"dict====%@",dict);
        
        
        self.imgURL = [NSString stringWithFormat:@"%@",dict[@"sv_p_images2"]];
        if (![SVTool isBlankString:self.imgURL]) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.imgURL]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        }
        
        _imageArr = [NSMutableArray array];
//        _picUrlArr = [NSMutableArray array];
        [_imageArr addObject:self.iconImage];
        self.iconImage.userInteractionEnabled = YES;
        //添加点击操作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [self.iconImage addGestureRecognizer:tap];
        //imageView 放入数组
//        [_imageArr addObject:image];
        
        //名称
        self.waresName.text = dict[@"sv_p_name"];
        //钱
        self.money.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_unitprice"]];
        //库存
        self.inventory.text = [NSString stringWithFormat:@"%@", dict[@"sv_p_storage"]];
        //款号
        self.barcode.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]];
        //分类
        if ([dict[@"sv_pc_name"] isEqual:[NSNull null]]) {
            self.waresClass.text = @"";
        } else {
            self.waresClass.text = [NSString stringWithFormat:@"%@",dict[@"sv_pc_name"]];
            self.producttype_id = [dict[@"producttype_id"] integerValue];
            self.productcategory_id = [dict[@"productcategory_id"] integerValue];
            self.productsubcategory_id = [dict[@"productsubcategory_id"] integerValue];
        }
        if (!([dict[@"sv_p_memberprice"] intValue] == 0)) {
            self.sv_p_memberprice.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_memberprice"]];
        }
        
        //进价
        self.purchaseprice.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_purchaseprice"] floatValue]];
        //规格
        self.specifications.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_specs"]];
        //单位
        self.unit.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_unit"]];
        //创建时间
        NSString *dateTime = [NSString stringWithFormat:@"%@",dict[@"sv_p_adddate"]];
        self.date.text = [dateTime substringWithRange:NSMakeRange(0, 10)];
        self.time.text = [dateTime substringWithRange:NSMakeRange(11, 5)];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
                        
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

- (NSMutableArray *)detailTextArray
{
    if (_detailTextArray == nil) {
        _detailTextArray = [NSMutableArray array];
    }
    return _detailTextArray;
}

@end
