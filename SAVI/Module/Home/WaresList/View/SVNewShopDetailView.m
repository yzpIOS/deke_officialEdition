//
//  SVNewShopDetailView.m
//  SAVI
//
//  Created by houming Wang on 2021/2/3.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewShopDetailView.h"
#import "JJPhotoManeger.h"
#import "SVNewShopDetailCell.h"

static NSString *const SVNewShopDetailCellID = @"SVNewShopDetailCell";
@interface SVNewShopDetailView()<JJPhotoDelegate,UITableViewDelegate,UITableViewDataSource>

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

@property (weak, nonatomic) IBOutlet UILabel *maoliText;


@end

@implementation SVNewShopDetailView


- (void)awakeFromNib
{
    [super awakeFromNib];
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
    
    // GrossProfit_Rate
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
             self.GrossProfit.hidden = YES;
             self.maoliText.hidden = YES;
         }
         }
     }
}

- (void)loadProductApiGetProductDetail_new{
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ProductApi/GetProductDetail_new?key=%@&id=%@",[SVUserManager shareInstance].access_token,[SVUserManager shareInstance].product_id];
    NSLog(@"url---%@",url);
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic888---%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
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
            NSString *sv_p_images = data[@"sv_p_images"];
            if ([sv_p_images containsString:@"UploadImg"]) {
                
                NSData *data = [sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                NSDictionary *dic = arr[0];
                NSString *sv_p_images_two = dic[@"code"];
               // sv_p_images = sv_p_images_two;
                [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
                [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
            }else{
                self.icon.image = [UIImage imageNamed:@"foodimg"];
            }
            
            _imageArr = [NSMutableArray array];
            //        _picUrlArr = [NSMutableArray array];
            [_imageArr addObject:self.icon];
            self.icon.userInteractionEnabled = YES;
            [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images]];
            //添加点击操作
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tap:)];
            [self.icon addGestureRecognizer:tap];
            self.clothingName.text = data[@"sv_p_name"];
            self.ClothingSpecifications.text = [NSString stringWithFormat:@"%@  %@",data[@"sv_p_barcode"],data[@"sv_p_specs"]];
            self.RetailAndWholesalePrices.text = [NSString stringWithFormat:@"零售价：%@  %@",data[@"sv_p_unitprice"],[data[@"sv_p_tradeprice1"]doubleValue] == 0 ?@"":[NSString stringWithFormat:@"批发价：%@",data[@"sv_p_tradeprice1"]]];
           
           // @property (weak, nonatomic) IBOutlet UILabel *NumberOfSales;
            self.stock.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_p_storage"]doubleValue]];
            
            self.CommodityClassification.text = [NSString stringWithFormat:@"%@/%@",data[@"sv_pc_name"],data[@"sv_psc_name"]];
            self.CommodityBrand.text = data[@"sv_brand_name"];
          //  @property (weak, nonatomic) IBOutlet UILabel *CommodityBrand;
           // @property (weak, nonatomic) IBOutlet UILabel *ProductPoints;
            if ([data[@"sv_product_integral"]doubleValue] != 0) {
                self.ProductPoints.text = [NSString stringWithFormat:@"%.2f",[data[@"sv_product_integral"]doubleValue]];
            }
            
                // @property (weak, nonatomic) IBOutlet UILabel *CommodityCommission;
            if ([data[@"sv_p_commissionratio"]doubleValue] != 0) {
                self.CommodityCommission.text = [NSString stringWithFormat:@"%.2f元",[data[@"sv_p_commissionratio"]doubleValue]];
            }
            
            
            self.MembershipPrice.text = [data[@"MembershipPrice"]doubleValue] == 0 ?@"": [NSString stringWithFormat:@"%.2f",[data[@"sv_p_memberprice"]doubleValue]];
            
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
            
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
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
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

- (void)MoreInformationTap:(UITapGestureRecognizer *)tap{
    
    _selected = !_selected;

    if(_selected) {
        NSLog(@"选中");
        //实现弹出方法
        [UIView animateWithDuration:.3 animations:^{
            self.moreInfoHeight.constant = 385;
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

@end
