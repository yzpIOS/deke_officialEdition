//
//  SVShopNavVC.m
//  SAVI
//
//  Created by houming Wang on 2021/2/2.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVShopNavVC.h"
#import "XBYScrollerMenuView.h"
#import "SVNewShopDetailView.h"
#import "SVNewShopSalesRecordView.h"
#import "SVPurchasingRecordsView.h"
#import "SVSVNewShopDetailViewVC.h"
#import "SVAddMoreSpecificationsVC.h"

#import "JJPhotoManeger.h"
#import "SVNewShopDetailCell.h"
#import "SVDetailAttrilistModel.h"

static NSString *const SVNewShopDetailCellID = @"SVNewShopDetailCell";
@interface SVShopNavVC ()<XBYScrollerMenuDelegate,JJPhotoDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) NSArray *titleData;
@property (nonatomic,strong) UIView *titleViewTwo;
@property (nonatomic,strong) SVNewShopDetailView *view1;
@property (nonatomic,strong) SVNewShopSalesRecordView *view2;
@property (nonatomic,strong) SVPurchasingRecordsView *view3;


@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *clothingName;
@property (weak, nonatomic) IBOutlet UILabel *ClothingSpecifications;

@property (weak, nonatomic) IBOutlet UILabel *RetailAndWholesalePrices;

@property (weak, nonatomic) IBOutlet UILabel *TotalSales;
@property (weak, nonatomic) IBOutlet UILabel *GrossProfit;
@property (weak, nonatomic) IBOutlet UILabel *TotalSalesNumber;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfSales;
@property (weak, nonatomic) IBOutlet UILabel *stock;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;


@property (weak, nonatomic) IBOutlet UILabel *CommodityClassification;

@property (weak, nonatomic) IBOutlet UILabel *CommodityBrand;
@property (weak, nonatomic) IBOutlet UILabel *ProductPoints;

@property (weak, nonatomic) IBOutlet UILabel *CommodityCommission;

@property (weak, nonatomic) IBOutlet UILabel *MembershipPrice;

@property (weak, nonatomic) IBOutlet UILabel *DeliveryPrice;

@property (weak, nonatomic) IBOutlet UILabel *buyingPrice;

@property (weak, nonatomic) IBOutlet UILabel *supplier;

@property(nonatomic,strong)NSMutableArray *picUrlArr;
@property(nonatomic,strong)NSMutableArray *imageArr;

@property (weak, nonatomic) IBOutlet UIView *MoreInformationView;

/**
 * 是否点击
 */
@property (nonatomic ,assign) BOOL selected;
@property (nonatomic ,assign) BOOL selectedTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreInfoHeight;
@property (weak, nonatomic) IBOutlet UIView *moreInfoView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *duoguigeArray;

@property (weak, nonatomic) IBOutlet UIView *SpecificationDetails;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SpecificationDetailsHeight;

@property (weak, nonatomic) IBOutlet UIImageView *moreInfoIcon;

@property (weak, nonatomic) IBOutlet UILabel *CreationTime;
@property (weak, nonatomic) IBOutlet UILabel *Fabric;
@property (weak, nonatomic) IBOutlet UILabel *GenderInformation;
@property (weak, nonatomic) IBOutlet UILabel *CommodityYear;

@property (weak, nonatomic) IBOutlet UILabel *CommoditySeason;
@property (weak, nonatomic) IBOutlet UILabel *StyleInformation;
@property (weak, nonatomic) IBOutlet UILabel *safetyStandards;
@property (weak, nonatomic) IBOutlet UILabel *ExecutiveStandard;


@property (weak, nonatomic) IBOutlet UIView *memberPriceView;


@property (weak, nonatomic) IBOutlet UIView *MultiMemberView;
@property (weak, nonatomic) IBOutlet UILabel *memberPrice1;
@property (weak, nonatomic) IBOutlet UILabel *memberPrice2;
@property (weak, nonatomic) IBOutlet UILabel *memberPrice3;
@property (weak, nonatomic) IBOutlet UILabel *memberPrice4;
@property (weak, nonatomic) IBOutlet UILabel *memberPrice5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MultiMemberHeight;

@property (weak, nonatomic) IBOutlet UIImageView *sanjiaoxingTwo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TwoViewHeight;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (nonatomic,strong) NSDictionary *data;

@property (nonatomic,strong) NSMutableArray *listAry1;
@property (nonatomic,strong) NSMutableArray *listAry2;
@property (nonatomic,strong) NSString *attri_group;

@property (nonatomic, assign) NSInteger productcategory_id;
@property (nonatomic, assign) NSInteger productsubcategory_id;
@property (nonatomic, assign) NSInteger producttype_id;
@property (weak, nonatomic) IBOutlet UILabel *maoliText;

@end

@implementation SVShopNavVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.hidesBackButton = YES;
    
       UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0, SCREEN_WIDTH + 20, 40)];
    self.titleViewTwo = titleView;
      // titleView.intrinsicContentSize = CGSizeMake(SCREEN_WIDTH, TopHeight);
     //   titleView.backgroundColor = [UIColor redColor];
      // titleView.backgroundColor = [UIColor clearColor];
       self.navigationItem.titleView = self.titleViewTwo;
    
   // self.automaticallyAdjustsScrollViewInsets=YES;
   
    
    XBYScrollerMenuView *vc=[[XBYScrollerMenuView alloc]initWithFrame:CGRectMake(-10, 0, SCREEN_WIDTH /4 *3, 38) showArrayButton:NO];
    vc.delegate=self;
    vc.backgroundColor=[UIColor clearColor];
    vc.selectedColorT=[UIColor whiteColor];
    vc.noSlectedColor=[UIColor whiteColor];
    vc.LineColor = [UIColor whiteColor];
    vc.titleFont = [UIFont systemFontOfSize:18];
    vc.myTitleArray=@[@"商品详情",@"销售记录",@"采购记录"];
  //  vc.currentIndex=0;
    
    if (@available(iOS 11.0, *)) {
      //  vc.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
       } else {
           // Fallback on earlier versions
           self.automaticallyAdjustsScrollViewInsets = NO;
       }

    [self.titleViewTwo addSubview:vc];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /4 *3, 5, SCREEN_WIDTH /4 *1 -20, 30)];
    rightView.layer.borderWidth = 1;
    rightView.layer.borderColor = [UIColor whiteColor].CGColor;
    rightView.layer.cornerRadius = 15;
    rightView.layer.masksToBounds = YES;
    [self.titleViewTwo addSubview:rightView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [rightView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(rightView.mas_centerX);
        make.top.mas_equalTo(rightView.mas_top).offset(5);
        make.bottom.mas_equalTo(rightView.mas_bottom).offset(-5);
        make.width.mas_equalTo(1);
        
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"shopPopDian"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(shopDetailClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rightView.mas_centerY);
        make.left.mas_equalTo(rightView.mas_left).offset(10);
        
    }];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"shopPop"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(shopClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rightView.mas_centerY);
        make.right.mas_equalTo(rightView.mas_right).offset(-10);
        
    }];
    
   
    
    [self loadProductApiGetProductDetail_new];
    [self loadProductApiGetProductSalesdetailed];
    //添加点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(MoreInformationTap:)];
    [self.MoreInformationView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *membertap = [[UITapGestureRecognizer alloc]init];
    [membertap addTarget:self action:@selector(Moremembertap:)];
    [self.memberPriceView addGestureRecognizer:membertap];
    
    self.moreInfoHeight.constant = 0;
    self.moreInfoView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewShopDetailCell" bundle:nil] forCellReuseIdentifier:SVNewShopDetailCellID];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.SpecificationDetails.hidden = YES;
    self.SpecificationDetailsHeight.constant = 0;
    self.MultiMemberView.hidden = YES;
    self.MultiMemberHeight.constant = 0;
    
    self.TwoViewHeight.constant = 439;
    
    self.icon.layer.cornerRadius = 10;
    self.icon.layer.masksToBounds = YES;
    
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    
    self.MoreInformationView.layer.cornerRadius = 10;
    self.MoreInformationView.layer.masksToBounds = YES;
    
    self.moreInfoView.layer.cornerRadius = 10;
    self.moreInfoView.layer.masksToBounds = YES;
    
    self.SpecificationDetails.layer.cornerRadius = 10;
    self.SpecificationDetails.layer.masksToBounds = YES;
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 控制全屏手势什么时候触发
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
   // Sv_p_unitprice
    
   
    
    // 限制系统边缘滑动手势
   // self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)loadProductApiGetProductDetail_new{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ProductApi/GetProductDetail_new?key=%@&id=%@",[SVUserManager shareInstance].access_token,[SVUserManager shareInstance].product_id];
    NSLog(@"url---%@",url);
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic888---%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.data = data;
            NSArray *Product_array = data[@"productCustomdDetailList"];
            if (kArrayIsEmpty(Product_array)) {
                self.duoguigeArray = nil;
                self.SpecificationDetails.hidden = YES;
                self.SpecificationDetailsHeight.constant = 0;
            }else{
                self.duoguigeArray = [SVduoguigeModel mj_objectArrayWithKeyValuesArray:Product_array];
                
                self.SpecificationDetails.hidden = NO;
                self.SpecificationDetailsHeight.constant = 97 + 54*self.duoguigeArray.count;
            }
            
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
            
            
            NSString *sv_p_images = data[@"sv_p_images"];
            if ([sv_p_images containsString:@"UploadImg"]) {
                
                NSData *data = [sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                NSDictionary *dic = arr[0];
                NSString *sv_p_images_two = dic[@"code"];
                [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
              //  _imageArr = [NSMutableArray array];
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
                      [self.icon addGestureRecognizer:tap];
                    //        _picUrlArr = [NSMutableArray array];
                    [self.imageArr addObject:self.icon];
                    self.icon.userInteractionEnabled = YES;
                }
               
            }else{
                self.icon.image = [UIImage imageNamed:@"foodimg"];
            }
            
            self.producttype_id = [data[@"producttype_id"] integerValue];
            self.productcategory_id = [data[@"productcategory_id"] integerValue];
            self.productsubcategory_id = [data[@"productsubcategory_id"] integerValue];
            
           
        
            self.clothingName.text = data[@"sv_p_name"];
            self.ClothingSpecifications.text = [NSString stringWithFormat:@"%@  %@",data[@"sv_p_barcode"],data[@"sv_p_specs"]];
            self.RetailAndWholesalePrices.text = [NSString stringWithFormat:@"零售价：%@  %@",data[@"sv_p_unitprice"],[data[@"sv_p_tradeprice1"]doubleValue] == 0 ?@"":[NSString stringWithFormat:@"批发价：%@",data[@"sv_p_tradeprice1"]]];
           
           // @property (weak, nonatomic) IBOutlet UILabel *NumberOfSales;
            self.stock.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_p_storage"]doubleValue]];
            NSString *sv_psc_name = data[@"sv_psc_name"];
            if (kStringIsEmpty(sv_psc_name) ) {
              NSString *sv_pc_name = [NSString stringWithFormat:@"%@",data[@"sv_pc_name"]];
                if (kStringIsEmpty(sv_pc_name) || [sv_pc_name containsString:@"null"]) {
                    self.CommodityClassification.text = @"";
                }else{
                    self.CommodityClassification.text = [NSString stringWithFormat:@"%@",data[@"sv_pc_name"]];
                }
               
            }else{
                self.CommodityClassification.text = [NSString stringWithFormat:@"%@/%@",data[@"sv_pc_name"],data[@"sv_psc_name"]];
            }
            
            self.CommodityBrand.text = data[@"sv_brand_name"];
          //  @property (weak, nonatomic) IBOutlet UILabel *CommodityBrand;
           // @property (weak, nonatomic) IBOutlet UILabel *ProductPoints;   VC.memberPriceStr = [NSString stringWithFormat:@"%@",self.data[@"sv_p_memberprice"]];
            if ([data[@"sv_product_integral"]doubleValue] != 0) {
                self.ProductPoints.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_product_integral"]doubleValue]];
            }
            
                // @property (weak, nonatomic) IBOutlet UILabel *CommodityCommission;
            if ([data[@"sv_p_commissiontype"]doubleValue] == 0) {
                self.CommodityCommission.text = [NSString stringWithFormat:@"%.2f%@",[data[@"sv_p_commissionratio"]doubleValue],@"%"];
                
            }else{
                self.CommodityCommission.text = [NSString stringWithFormat:@"%.2f元",[data[@"sv_p_commissionratio"]doubleValue]];
            }
            
            
            self.MembershipPrice.text = [data[@"sv_p_memberprice"]doubleValue] == 0 ?@"": [NSString stringWithFormat:@"%.2f",[data[@"sv_p_memberprice"]doubleValue]];
            
            if ([data[@"sv_distributionprice"]doubleValue] != 0) {
                self.DeliveryPrice.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_distributionprice"]doubleValue]];
            }
           
            if ([data[@"sv_purchaseprice"]doubleValue] != 0) {
                self.buyingPrice.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_purchaseprice"]doubleValue]];
            }
            

            self.supplier.text = data[@"sv_suname"];
            
            NSString *timeString = data[@"sv_p_adddate"];
            NSString *time1 = [timeString substringToIndex:10];
            NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
            self.CreationTime.text = [NSString stringWithFormat:@"%@ %@",time1,time2];
            
            self.Fabric.text = data[@"fabric_name"];
            self.GenderInformation.text = data[@"gender_name"];
            self.CommodityYear.text = [data[@"sv_particular_year"] doubleValue] == 0 ? @"": [NSString stringWithFormat:@"%@",data[@"sv_particular_year"]];

            self.CommoditySeason.text = data[@"season_name"];
            self.StyleInformation.text = data[@"style_name"];
            self.safetyStandards.text = data[@"standard_name"];
            self.ExecutiveStandard.text = data[@"sv_executivestandard"];
            
            if ([data[@"sv_p_memberprice1"]doubleValue] != 0) {
                self.memberPrice1.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_p_memberprice1"]doubleValue]];
            }
           
            if ([data[@"sv_p_memberprice2"]doubleValue] != 0) {
                self.memberPrice2.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_p_memberprice2"]doubleValue]];
            }
            
            if ([data[@"sv_p_memberprice3"]doubleValue] != 0) {
                self.memberPrice3.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_p_memberprice3"]doubleValue]];
            }
            
            if ([data[@"sv_p_memberprice4"]doubleValue] != 0) {
                self.memberPrice4.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_p_memberprice4"]doubleValue]];
            }
            
            if ([data[@"sv_p_memberprice5"]doubleValue] != 0) {
                self.memberPrice5.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_p_memberprice5"]doubleValue]];
            }
            
            
            [SVUserManager loadUserInfo];
            NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
            NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
       
            //零售价
            if (kDictIsEmpty(CommodityManageDic)) {
                self.RetailAndWholesalePrices.hidden = NO;
              
            }else{
                NSString *Sv_p_unitprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_p_unitprice"]];
                if (kStringIsEmpty(Sv_p_unitprice)) {
                    self.RetailAndWholesalePrices.hidden = NO;
                  
                }else{
                    if ([Sv_p_unitprice isEqualToString:@"1"]) {
                  
                        self.RetailAndWholesalePrices.hidden = NO;
                      
                }else{
                    self.RetailAndWholesalePrices.text = @"***";
                   
                }
                }
            }
            
            // 进货价 Sv_purchaseprice
            if (kDictIsEmpty(CommodityManageDic)) {
                self.buyingPrice.hidden = NO;
              
            }else{
                NSString *Sv_purchaseprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_purchaseprice"]];
                if (kStringIsEmpty(Sv_purchaseprice)) {
                    self.buyingPrice.hidden = NO;
                  
                }else{
                    if ([Sv_purchaseprice isEqualToString:@"1"]) {
                  
                        self.buyingPrice.hidden = NO;
                      
                }else{
                    self.buyingPrice.text = @"***";
                   
                }
                }
            }
            
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

- (void)loadProductApiGetProductSalesdetailed{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ProductApi/GetProductSalesdetailed?key=%@&pageSize=100&pageIndex=1&keywards=&startDate=&endDate=&id=%@&user_id=%@",[SVUserManager shareInstance].access_token,[SVUserManager shareInstance].product_id,[SVUserManager shareInstance].user_id];
    NSLog(@"url---%@",url);
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic888---%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            NSDictionary *values = data[@"values"];
       
            self.TotalSales.text = [NSString stringWithFormat:@"%.2f",[values[@"sales_Total"]doubleValue]];
            self.GrossProfit.text = [NSString stringWithFormat:@"%.2f",[values[@"profit_Total"] doubleValue]];
            self.TotalSalesNumber.text = [NSString stringWithFormat:@"%.2f笔",[values[@"total_num"]doubleValue]];
            self.saleNum.text = [NSString stringWithFormat:@"%.2f",[values[@"total_num"]doubleValue]];
            self.NumberOfSales.text = [NSString stringWithFormat:@"%.2f笔",[values[@"total_num"]doubleValue]];
            
            [SVUserManager loadUserInfo];
            NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
            NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
            if (kDictIsEmpty(CommodityManageDic)) {
                self.GrossProfit.hidden = NO;
                self.maoliText.hidden = NO;
            }else{
                NSString *GrossProfit_Rate = [NSString stringWithFormat:@"%@",CommodityManageDic[@"GrossProfit_Rate"]];
                if (kStringIsEmpty(GrossProfit_Rate)) {
                    self.GrossProfit.hidden = NO;
                    self.maoliText.hidden = NO;
                }else{
                    if ([GrossProfit_Rate isEqualToString:@"1"]) {
                  
                        self.GrossProfit.hidden = NO;
                        self.maoliText.hidden = NO;
                }else{
                    self.GrossProfit.text = @"***";
                   // self.maoliText.text = @"***";
                }
                }
            }
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

- (void)MoreInformationTap:(UITapGestureRecognizer *)tap{
    
    _selected = !_selected;

    if(_selected) {
        NSLog(@"选中");
        //实现弹出方法
        [UIView animateWithDuration:.3 animations:^{
            self.moreInfoHeight.constant = 440;
            self.moreInfoView.hidden = NO;
        }];
        
        [UIView animateWithDuration:.3 animations:^{
            //旋转
            self.moreInfoIcon.transform = CGAffineTransformRotate(self.moreInfoIcon.transform, M_PI);
        }];
        
        
    }else {
        NSLog(@"取消选中");
        //实现弹出方法
        [UIView animateWithDuration:.3 animations:^{
            self.moreInfoHeight.constant =0;
            self.moreInfoView.hidden = YES;
        }];
        
        [UIView animateWithDuration:.3 animations:^{
            //旋转
            self.moreInfoIcon.transform = CGAffineTransformRotate(self.moreInfoIcon.transform, M_PI);
        }];
    }
    
    
  
}


- (void)Moremembertap:(UITapGestureRecognizer *)tap{
    _selectedTwo = !_selectedTwo;

    if(_selectedTwo) {
        NSLog(@"选中");
        //实现弹出方法
        [UIView animateWithDuration:.3 animations:^{
            self.MultiMemberHeight.constant = 274;
            self.TwoViewHeight.constant = 713;
            self.MultiMemberView.hidden = NO;
        }];
        
        [UIView animateWithDuration:.3 animations:^{
            //旋转
            self.sanjiaoxingTwo.transform = CGAffineTransformRotate(self.sanjiaoxingTwo.transform, M_PI);
        }];
        
        
    }else {
        NSLog(@"取消选中");
        //实现弹出方法
        [UIView animateWithDuration:.3 animations:^{
            self.MultiMemberHeight.constant =0;
            self.TwoViewHeight.constant = 439;
            self.MultiMemberView.hidden = YES;
        }];
        
        [UIView animateWithDuration:.3 animations:^{
            //旋转
            self.sanjiaoxingTwo.transform = CGAffineTransformRotate(self.sanjiaoxingTwo.transform, M_PI);
        }];
    }
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    [SVUserManager loadUserInfo];
    [SVUserManager shareInstance].picUrlArr = _picUrlArr;
    [SVUserManager saveUserInfo];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.duoguigeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVNewShopDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SVNewShopDetailCellID];
    if (!cell) {
        cell = [[SVNewShopDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVNewShopDetailCellID];
    }
    
    cell.model = self.duoguigeArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


- (NSMutableArray *)duoguigeArray
{
    if (_duoguigeArray == nil) {
        _duoguigeArray = [NSMutableArray array];
    }
    return _duoguigeArray;
}




- (void)shopDetailClick{
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"编辑" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"删除" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
  // NSArray *items = @[cashTitle,menuTitle];
//    [SVUserManager loadUserInfo];
//    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
//    NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
//    if (kDictIsEmpty(CommodityManageDic)) {
//       // button.hidden = NO;
//    }else{
//        NSString *UpdateCommodity = [NSString stringWithFormat:@"%@",CommodityManageDic[@"UpdateCommodity"]];
//
//        if (kStringIsEmpty(UpdateCommodity)) {
//          //  button.hidden = NO;
//        }else{
//            if ([UpdateCommodity isEqualToString:@"1"]) {
//
//              //  button.hidden = NO;
//        }else{
//           // button.hidden = YES;
//        }
//        }
//    }
    
    NSArray *items = [NSArray array];

    [SVUserManager loadUserInfo];
              NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
              NSDictionary *CommodityManage = sv_versionpowersDict[@"CommodityManage"];
              NSString *UpdateCommodity = [NSString stringWithFormat:@"%@",CommodityManage[@"UpdateCommodity"]];
               NSString *DeleteCommodity = [NSString stringWithFormat:@"%@",CommodityManage[@"DeleteCommodity"]];
              if (kDictIsEmpty(sv_versionpowersDict)) {
                  items = @[cashTitle,menuTitle];
              }else{
                  if (kStringIsEmpty(UpdateCommodity) && kStringIsEmpty(DeleteCommodity)) {
                      items = @[cashTitle,menuTitle];
                  }else{
                      if ([UpdateCommodity isEqualToString:@"1"] && [DeleteCommodity isEqualToString:@"1"]) {
                          items = @[cashTitle,menuTitle];
                      }else{
                          if ([UpdateCommodity isEqualToString:@"0"] && [DeleteCommodity isEqualToString:@"0"]) {
                              items = @[];
                          }else{
                              if ([UpdateCommodity isEqualToString:@"1"]) {
                            //  _titleData = @[@"商品销售"];
                              items = @[cashTitle];
                          }

                           if ([DeleteCommodity isEqualToString:@"1"]) {
                               items = @[menuTitle];
                           }
                      }
                  }
                  }
              }
    
    if (kArrayIsEmpty(items)) {
        return [SVTool TextButtonAction:self.view withSing:@"请去开通修改和删除的权限"];
    }

    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW- 54, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        if ([item.title isEqualToString:@"编辑"]) {
            SVAddMoreSpecificationsVC *VC = [[SVAddMoreSpecificationsVC alloc] init];
//                SVAddMoreSpecificationsVC *VC = [[SVAddMoreSpecificationsVC alloc] init];
            [SVUserManager loadUserInfo];
            //判断是权限，只有店主能看
            if ([[SVUserManager shareInstance].addShop isEqualToString:@"0"]) {
                [SVTool TextButtonAction:self.view withSing:@"无此权限，查看"];
                return;
            }
            if (!kDictIsEmpty(self.data)) {
                //全局属性
               // VC.imgURL = self.imgURL;
                
                //产品ID
                VC.product_id = [NSString stringWithFormat:@"%@",self.data[@"id"]];
                
                //款号
                VC.barcode = self.data[@"sv_p_barcode"];
                
                ////商品名称
                VC.waresName = self.data[@"sv_p_name"];
                
                ////分类  sv_psc_name
                VC.classification = self.data[@"sv_pc_name"];
                //
                ////售价
                VC.price = [NSString stringWithFormat:@"%@",self.data[@"sv_p_unitprice"]];
                
                ////库存 sv_p_storage
                VC.inventory = [NSString stringWithFormat:@"%@",self.data[@"sv_p_storage"]];
                
                ////进价 sv_purchaseprice
                VC.purchaseprice = [NSString stringWithFormat:@"%@",self.data[@"sv_purchaseprice"]];
                //规格
//                    self.specifications.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_specs"]];
                //单位
//                    self.unit.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_unit"]];
                ////规格
                VC.specifications =  [NSString stringWithFormat:@"%@",self.data[@"sv_p_specs"]];
    
                ////单位
                VC.unit = [NSString stringWithFormat:@"%@",self.data[@"sv_p_unit"]];
                
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
                
                // 单位
                VC.company_id = [NSString stringWithFormat:@"%@",self.data[@"sv_unit_id"]];
                VC.sv_unit_name = self.data[@"sv_unit_name"];
                VC.sv_suid = [NSString stringWithFormat:@"%@",self.data[@"sv_suid"]];
                VC.sv_suname = self.data[@"sv_suname"];
                // 更多
                // 商品品牌
                VC.CommodityBrandLabel.text = self.data[@"sv_brand_name"];
                VC.CommodityBrand = self.data[@"sv_brand_name"];
                
              //  VC.sv_product_integral.text = [NSString stringWithFormat:@"%@",self.data[@"sv_product_integral"]];
                VC.product_integral = [NSString stringWithFormat:@"%@",self.data[@"sv_product_integral"]];
                VC.commissionratio = [NSString stringWithFormat:@"%@",self.data[@"sv_p_commissionratio"]];
              //  VC.sv_p_commissionratio.text = [NSString stringWithFormat:@"%@",self.data[@"sv_p_commissionratio"]];
                if ([self.data[@"sv_p_commissiontype"] doubleValue] == 1) { // 是元
                    VC.CommissionLabel.text = @"元";
                    VC.Commission = @"元";
                }else{
                    VC.CommissionLabel.text = @"%";
                    VC.Commission = @"%";
                }
                
                NSString *sv_p_images = self.data[@"sv_p_images"];
               // NSString *sv_agent_custom_config = cus_info[@"sv_agent_custom_config"];
                if (!kStringIsEmpty(sv_p_images)) {
                    NSData *data = [sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
                    NSArray *sv_p_imagesArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                    
                    VC.imageArray = sv_p_imagesArray;
                }
                
                NSString * Fabric = [NSString stringWithFormat:@"%@",self.data[@"fabric_name"]];
                if (![Fabric containsString:@"null"]) {
                    VC.Fabric = Fabric;
                }
               
                VC.Gender = [NSString stringWithFormat:@"%@",self.data[@"gender_name"]];
                VC.CommodityYear = [NSString stringWithFormat:@"%@",self.data[@"sv_particular_year"]];
                VC.CommoditySeason = [NSString stringWithFormat:@"%@",self.data[@"season_name"]];
                VC.StyleInformation = [NSString stringWithFormat:@"%@",self.data[@"style_name"]];
                VC.safetyStandards = [NSString stringWithFormat:@"%@",self.data[@"standard_name"]];
                VC.sv_executivestandard = [NSString stringWithFormat:@"%@",self.data[@"sv_executivestandard"]];
                
                
                VC.sv_product_standard_id = [NSString stringWithFormat:@"%@",self.data[@"sv_product_standard_id"]];
                VC.sv_product_fabric_id = [NSString stringWithFormat:@"%@",self.data[@"sv_product_fabric_id"]];
                VC.sv_product_gender_id = [NSString stringWithFormat:@"%@",self.data[@"sv_product_gender_id"]];
                VC.sv_product_season_id = [NSString stringWithFormat:@"%@",self.data[@"sv_product_season_id"]];
                VC.sv_product_style_id = [NSString stringWithFormat:@"%@",self.data[@"sv_product_style_id"]];
                VC.sv_brand_id = [NSString stringWithFormat:@"%@",self.data[@"sv_brand_id"]];
                VC.sv_executivestandard_id = [NSString stringWithFormat:@"%@",self.data[@"sv_executivestandard_id"]];
                
                
                VC.DeliveryPriceStr = [NSString stringWithFormat:@"%@",self.data[@"sv_distributionprice"]];
                
                VC.minimumPriceStr = [NSString stringWithFormat:@"%@",self.data[@"sv_p_minunitprice"]];
                VC.MinimumDiscountStr = [NSString stringWithFormat:@"%@",self.data[@"sv_p_mindiscount"]];
                VC.sv_p_remark = [NSString stringWithFormat:@"%@",self.data[@"sv_p_remark"]];
                
                VC.memberPriceStr = [NSString stringWithFormat:@"%@",self.data[@"sv_p_memberprice"]];
                VC.memberPrice1Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_memberprice1"]];
                VC.memberPrice2Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_memberprice2"]];
                VC.memberPrice3Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_memberprice3"]];
                VC.memberPrice4Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_memberprice4"]];
                VC.memberPrice5Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_memberprice5"]];
                // 批发价
                VC.tradePriceStr = [NSString stringWithFormat:@"%@",self.data[@"sv_p_tradeprice1"]];
                VC.tradePrice1Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_tradeprice2"]];
                VC.tradePrice2Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_tradeprice3"]];
                VC.tradePrice3Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_tradeprice4"]];
                VC.tradePrice4Str = [NSString stringWithFormat:@"%@",self.data[@"sv_p_tradeprice5"]];

                [self.navigationController pushViewController:VC animated:YES];
                
                __weak typeof(self) weakSelf = self;
                VC.editSuccessBlock = ^{
                    [weakSelf loadProductApiGetProductDetail_new];
                    [weakSelf loadProductApiGetProductSalesdetailed];
                };
               // [self.navigationController pushViewController:VC animated:YES];
            }else{
                [SVTool TextButtonAction:self.view withSing:@"暂无数据"];
            }
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           // http://wpf.decerp.cc/product?key=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkZWNfc2FsZXNjbGVya19pZCI6IjAiLCJzdl9lbXBsb3llZV9uYW1lIjoiIiwib3BlcmF0aW5ncGxhdGZvcm0iOiIiLCJzeXN0ZW1uYW1lIjoiIiwic3ZfYXBwX3ZlcnNpb24iOiIiLCJvcmRlcl9vcGVyYXRvciI6IiIsImRlY19pc3NhbGVzY2xlcmsiOiJGYWxzZSIsImlhdCI6IjE2MTQ3NTkyNzQiLCJUb2tlblR5cGUiOiJDb21tb25Ub2tlbk1vZGVsIiwiZXhwIjoxNjE1MzY0MDc0LCJpc3MiOiIyOTAyNzY0MiIsImF1ZCI6IjI5MDI3NjQyIn0.K-QHyA1vTZTijXHs3xC4TBs7yHpIuf7AD9FMhtPbLmA&ids=25971070
                NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&ids=%@",[SVUserManager shareInstance].access_token,self.model.id];
                [[SVSaviTool sharedSaviTool] DELETE:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"dic888---%@",dic);
                    if ([dic[@"succeed"] intValue] == 1) {
                        [SVTool TextButtonActionWithSing:@"删除商品成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        if (self.deleteBlock) {
                            self.deleteBlock();
                        }
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:derAction];
            
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
//        switch (index) {
//            case 0:
//            {
//             
//            }
//                break;
//                
//                
//            default:
//            {
//               
//            }
//                break;
//        }
    
      
      //  }
    }];
}

- (void)shopClick{
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    NSLog(@"选中%d",index);
    if (index == 0) {
       // self.view.hidden = NO;
        self.view2.hidden = YES;
        self.view3.hidden = YES;
    }else if (index == 1){
      //  self.view.hidden = YES;
//        [self.view2 removeFromSuperview];
        if (!self.view2) {
            self.view2 = [[NSBundle mainBundle]loadNibNamed:@"SVNewShopSalesRecordView" owner:nil options:nil].lastObject;
            // self.view2.hidden = YES;
            self.view2.frame = CGRectMake(0, 0, ScreenW, ScreenH - TopHeight);
            [self.view addSubview:self.view2];
        }
        self.view2.hidden = NO;
        self.view3.hidden = YES;
       
    }else if (index == 2){
       // [self.view3 removeFromSuperview];
        if (!self.view3) {
            self.view3 = [[NSBundle mainBundle]loadNibNamed:@"SVPurchasingRecordsView" owner:nil options:nil].lastObject;
            // self.view3.hidden = YES;
            self.view3.frame = CGRectMake(0, 0, ScreenW, ScreenH - TopHeight);
            [self.view addSubview:self.view3];
        }
        
       
        self.view3.hidden = NO;
        self.view2.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = navigationBackgroundColor;

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
    
}



- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = [UIColor whiteColor];

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
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
@end
