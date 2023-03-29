//
//  SVAddMoreSpecificationsVC.m
//  SAVI
//
//  Created by houming Wang on 2019/3/18.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVAddMoreSpecificationsVC.h"
#import "SVMoreColorVC.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"
#import "SVSetDimensionsVC.h"
#import "SVSetNumberVC.h"
#import "SVDetailAttrilistModel.h"
#import "SVWaresClassVC.h"
#import "SVInitialInventoryVC.h"
#import "SVColorOneModel.h"
#import "SVSizeTwoModel.h"
#import "SVUnitPickerView.h"
#import "SVduoguigeModel.h"
#import "ZYInputAlertView.h"
#import "SVAddShopDetailView.h"


#import "TZImagePickerController.h"
#import "UIView+TZLayout.h"
#import "TZTestCell.h"
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "TZAssetCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FLAnimatedImage.h"
#import "TZImageUploadOperation.h"
#import "HLPopTableView.h"
#import "UIView+HLExtension.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kViewMaxY(v)  (v.frame.origin.y + v.frame.size.height)
#define num  (ScreenH / 3*2)
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]
@interface SVAddMoreSpecificationsVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,/*修改头像*/UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,colorArrayClickDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic,assign) NSInteger maxCountTF;
@property (nonatomic,assign) NSInteger columnNumberTF;

@property (weak, nonatomic) IBOutlet UIView *classificationView;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIView *sizeView;
@property (weak, nonatomic) IBOutlet UIView *itemNumberView;
@property (weak, nonatomic) IBOutlet UIView *stockView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorHeight;
@property (weak, nonatomic) IBOutlet UIView *colorHeight_View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *big_color_height;
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;// 单位label

@property (weak, nonatomic) IBOutlet UIView *sizeHeight_View;// 那条线存放尺码的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeHeight;//约束存放尺码的
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UIView *uploadPictureView;

@property (nonatomic,strong) NSMutableArray *selectBtnArray;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//全局属性
//图片路径
//@property (nonatomic,copy) NSString *imgURL;
//@property (nonatomic,strong) NSString *groupnameStr;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) SVColorOneModel *oneModel;
@property (nonatomic,strong) SVSizeTwoModel *twoModel;

//单位
@property (nonatomic, strong) NSMutableArray *pickViewArr;
//自定义pickerView
@property(nonatomic,strong) SVUnitPickerView *pickerView;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
/**
 回调回来的二级分类名
 */
//@property (nonatomic, copy) NSString *className;
@property (weak, nonatomic) IBOutlet UILabel *initalLabel; // 库存
@property (weak, nonatomic) IBOutlet UILabel *itemNumberLabel; // 条码
@property (nonatomic,strong) NSString *spec_name;
/**
 @“选择分类”
 */
@property (nonatomic, copy) NSString *localName;
//@property (nonatomic, assign) NSInteger productcategory_id;
//@property (nonatomic, assign) NSInteger productsubcategory_id;
//@property (nonatomic, assign) NSInteger producttype_id;
@property (weak, nonatomic) IBOutlet UITextField *borCodeTextFirld;
@property (nonatomic,strong) NSMutableArray *ItemNumberArray;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *salePriceText;
@property (weak, nonatomic) IBOutlet UITextField *purchasePriceText;
//@property (weak, nonatomic) IBOutlet UITextField *memberPriceText;
// 进价的view
@property (weak, nonatomic) IBOutlet UIView *PurchasePriceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PurchasePrice_height;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigViewHeight;

//单位
//@property (nonatomic,copy) NSString *unit;
@property (weak, nonatomic) IBOutlet UIButton *saoBtn;

@property (nonatomic,strong) NSMutableArray *bigArray;

@property (nonatomic,strong) NSMutableArray *initialArray;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_height;
@property (nonatomic,strong) NSMutableArray *bigItemNumberArray;
@property (nonatomic,strong) NSMutableArray *specsDiffArray;
@property (nonatomic,strong) NSMutableArray *storageDiffArray;
@property (nonatomic,strong) NSMutableArray *artnoDiffArray;

@property (nonatomic,strong) NSMutableArray *firstSpecsDiffArray;
@property (nonatomic,strong) NSMutableArray *firstArtnoDiffArray;
@property (nonatomic,strong) NSMutableArray *firstStorageDiffArray;
@property (nonatomic,strong) NSMutableArray *threeColorArray;

@property (nonatomic,strong) NSMutableArray *oneModelArray;
@property (nonatomic,strong) NSMutableArray *attriModelArray;
@property (nonatomic,strong) NSMutableArray *twoModelArray;
@property (nonatomic,strong) NSMutableArray *atteilistModel2Array;
@property (nonatomic,strong) NSMutableArray *product_idArray;
@property (nonatomic,strong) NSString *spec_name_two;
@property (nonatomic,strong) NSString *ItemNumberStr;// 条码
@property (nonatomic,strong) NSString *InitialInventoryStr; // 初始库存
@property (weak, nonatomic) IBOutlet UISwitch *weighSwitch;
@property (nonatomic,assign) NSInteger switch_isOn;
@property (nonatomic,strong) NSMutableArray *editDictArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MoreInformationHeight;
@property (weak, nonatomic) IBOutlet UIView *moreInfoView;
/**
 * 是否点击
 */
@property (nonatomic ,assign) BOOL selected;
@property (weak, nonatomic) IBOutlet UIImageView *moreInfoIcon;
@property (weak, nonatomic) IBOutlet UIView *moreInformationView;

// 商品品牌
@property (weak, nonatomic) IBOutlet UIView *CommodityBrandView;
// 提成
@property (weak, nonatomic) IBOutlet UIView *CommissionView;
// 面料
@property (weak, nonatomic) IBOutlet UIView *FabricView;
// 性别
@property (weak, nonatomic) IBOutlet UIView *GenderView;
// 商品年份
@property (weak, nonatomic) IBOutlet UIView *CommodityYearView;
// 商品季节
@property (weak, nonatomic) IBOutlet UIView *CommoditySeasonView;
// 款式信息
@property (weak, nonatomic) IBOutlet UIView *StyleInformationView;
// 安全标准
@property (weak, nonatomic) IBOutlet UIView *safetyStandardsView;
// 执行标准
@property (weak, nonatomic) IBOutlet UIView *ExecutiveStandardView;


@property (nonatomic,strong) SVAddShopDetailView * addShopDetailView;
@property (nonatomic,strong) NSArray * CommodityBrandArray;
@property (nonatomic,strong) NSArray * FabricArray;
@property (nonatomic,strong) NSArray * genderListArray;
@property (nonatomic,strong) NSArray * SeasonlListArray;
@property (nonatomic,strong) NSArray * StyleListArray;
@property (nonatomic,strong) NSArray * StandardListArray;
@property (nonatomic,strong) NSArray * ExecutiveStandardArray;
@property (nonatomic,strong) NSMutableArray * selectUploadingArray;
// 新的单位数据
@property (nonatomic,strong) NSArray * companyArray;

@property (weak, nonatomic) IBOutlet UIView *gongyingshangView;
@property (nonatomic,strong) NSArray * Supplierlist;
@property (weak, nonatomic) IBOutlet UILabel *supplierLabel;
@property (weak, nonatomic) IBOutlet UITextField *remarksText;

@property (weak, nonatomic) IBOutlet UIView *duoguigeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *duoguigeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gengduoTop;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (weak, nonatomic) IBOutlet UIView *chushikucunView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chushikucunHeight;

@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceHeight;
@property (weak, nonatomic) IBOutlet UIView *priceLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLineViewHeight;

@property (weak, nonatomic) IBOutlet UIView *chushikucunViewLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chushikucunViewLineheight;

@property (weak, nonatomic) IBOutlet UILabel *titileNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ExecutiveStandardLabel;

@end

@implementation SVAddMoreSpecificationsVC
- (NSArray *)Supplierlist{
    if (!_Supplierlist) {
        _Supplierlist = [NSArray array];
    }
    return _Supplierlist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.titileNameLabel.text = @"款号";
    }else{
        self.titileNameLabel.text = @"条码";
    }
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];
    [self ProductApiConfigGetSv_Brand_Lib];
    [self ProductApiConfigGetFabricList];
    [self ProductApiConfigGetGenderList];
    [self ProductApiConfigGetSeasonlList];
    [self ProductApiConfigGetStyleList];
    [self ProductApiConfigGetStandardList];
    [self ProductApiConfigGetunitModelList];
    [self GetExecutivestandardList];
    [self SupplierGetSupplierlist];
    self.maxCountTF = 5;
    self.columnNumberTF = 4;
    

   
    [self.weighSwitch addTarget:self action:@selector(weighSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(MoreInformationTap:)];
    [self.moreInfoView addGestureRecognizer:tap];
    
    // 供应商
    UITapGestureRecognizer *gongyingshangtap = [[UITapGestureRecognizer alloc]init];
    [gongyingshangtap addTarget:self action:@selector(gongyingshangClick)];
    [self.gongyingshangView addGestureRecognizer:gongyingshangtap];
    
    // 商品品牌
    UITapGestureRecognizer *CommodityBrandViewTap = [[UITapGestureRecognizer alloc]init];
    [CommodityBrandViewTap addTarget:self action:@selector(CommodityBrandViewTapClick)];
    [self.CommodityBrandView addGestureRecognizer:CommodityBrandViewTap];
    // 提成
    UITapGestureRecognizer *CommissionViewTap = [[UITapGestureRecognizer alloc]init];
    [CommissionViewTap addTarget:self action:@selector(CommissionViewTapClick)];
    [self.CommissionView addGestureRecognizer:CommissionViewTap];
    
    // 面料
    UITapGestureRecognizer *FabricViewTap = [[UITapGestureRecognizer alloc]init];
    [FabricViewTap addTarget:self action:@selector(FabricViewTapClick)];
    [self.FabricView addGestureRecognizer:FabricViewTap];
    
    // 性别
    UITapGestureRecognizer *GenderViewTap = [[UITapGestureRecognizer alloc]init];
    [GenderViewTap addTarget:self action:@selector(GenderViewTapClick)];
    [self.GenderView addGestureRecognizer:GenderViewTap];
    
    // 商品年份
    UITapGestureRecognizer *CommodityYearViewTap = [[UITapGestureRecognizer alloc]init];
    [CommodityYearViewTap addTarget:self action:@selector(CommodityYearViewTapClick)];
    [self.CommodityYearView addGestureRecognizer:CommodityYearViewTap];
    
    // 商品季节
    UITapGestureRecognizer *CommoditySeasonViewTap = [[UITapGestureRecognizer alloc]init];
    [CommoditySeasonViewTap addTarget:self action:@selector(CommoditySeasonViewTapClick)];
    [self.CommoditySeasonView addGestureRecognizer:CommoditySeasonViewTap];
    
    // 款式信息
    UITapGestureRecognizer *StyleInformationViewTap = [[UITapGestureRecognizer alloc]init];
    [StyleInformationViewTap addTarget:self action:@selector(StyleInformationViewTapClick)];
    [self.StyleInformationView addGestureRecognizer:StyleInformationViewTap];
    
    // 安全标准
    UITapGestureRecognizer *safetyStandardsViewTap = [[UITapGestureRecognizer alloc]init];
    [safetyStandardsViewTap addTarget:self action:@selector(safetyStandardsViewTapClick)];
    [self.safetyStandardsView addGestureRecognizer:safetyStandardsViewTap];
    
    // 执行标准
    UITapGestureRecognizer *ExecutiveStandardViewTap = [[UITapGestureRecognizer alloc]init];
    [ExecutiveStandardViewTap addTarget:self action:@selector(ExecutiveStandardViewTapClick)];
    [self.ExecutiveStandardView addGestureRecognizer:ExecutiveStandardViewTap];
    
    self.MoreInformationHeight.constant = 0;
    self.moreInformationView.hidden = YES;
    
    if (self.editInterface == 1) {
        self.title = @"编辑商品";
        if (kArrayIsEmpty(self.duoguigeArray)) {
            
            // 是进价
            [SVUserManager loadUserInfo];
            NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
            NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
              if (kDictIsEmpty(sv_versionpowersDict)) {
//                    self.PurchasePriceView.hidden = NO;
//                    self.PurchasePrice_height.constant = 55;
                   // self.bigViewHeight.constant = 228;
              }else{
               NSString *Sv_purchaseprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_purchaseprice"]];
                  if ([Sv_purchaseprice isEqualToString:@"1"]) {
//                      self.PurchasePriceView.hidden = NO;
//                      self.PurchasePrice_height.constant = 55;
//                      //self.bigViewHeight.constant = 228;
                  }else{
                       self.PurchasePriceView.hidden = YES;
                      self.PurchasePrice_height.constant = 0;
                      self.lineView.hidden = YES;
                      self.lineViewHeight.constant = 0;
                      self.bigViewHeight.constant = self.bigViewHeight.constant - 55.5;
                  }
              }
            
            
            //零售价
            if (kDictIsEmpty(CommodityManageDic)) {
              //  self.RetailAndWholesalePrices.hidden = NO;
              
            }else{
                NSString *Sv_p_unitprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_p_unitprice"]];
                if (kStringIsEmpty(Sv_p_unitprice)) {
                  //  self.RetailAndWholesalePrices.hidden = NO;
                  
                }else{
                    if ([Sv_p_unitprice isEqualToString:@"1"]) {
                  
                     //   self.RetailAndWholesalePrices.hidden = NO;
                      
                }else{
                  //  self.RetailAndWholesalePrices.text = @"***";
                    self.priceView.hidden = YES;
                   self.priceHeight.constant = 0;
                   self.priceLineViewHeight.constant = 0;
                   self.priceLineView.hidden = YES;
                   self.bigViewHeight.constant = self.bigViewHeight.constant - 55.5;
                }
                }
            }
            
            self.duoguigeView.hidden = YES;
            self.big_color_height.constant = 0;
            self.gengduoTop.constant = 0;
          //  self.bigViewHeight.constant = 338
            self.chushikucunView.hidden = NO;
            self.chushikucunHeight.constant = 55;
        }else{
            
            // 是进价
            [SVUserManager loadUserInfo];
            NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
            NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
              if (kDictIsEmpty(sv_versionpowersDict)) {
//                    self.PurchasePriceView.hidden = NO;
//                    self.PurchasePrice_height.constant = 55;
                   // self.bigViewHeight.constant = 228;
              }else{
               NSString *Sv_purchaseprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_purchaseprice"]];
                  if ([Sv_purchaseprice isEqualToString:@"1"]) {
//                      self.PurchasePriceView.hidden = NO;
//                      self.PurchasePrice_height.constant = 55;
//                      //self.bigViewHeight.constant = 228;
                  }else{
                       self.PurchasePriceView.hidden = YES;
                      self.PurchasePrice_height.constant = 0;
                      self.lineView.hidden = YES;
                      self.lineViewHeight.constant = 0;
                      self.bigViewHeight.constant = self.bigViewHeight.constant - 55.5;
                  }
              }
            
            
            //零售价
            if (kDictIsEmpty(CommodityManageDic)) {
              //  self.RetailAndWholesalePrices.hidden = NO;
              
            }else{
                NSString *Sv_p_unitprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_p_unitprice"]];
                if (kStringIsEmpty(Sv_p_unitprice)) {
                  //  self.RetailAndWholesalePrices.hidden = NO;
                  
                }else{
                    if ([Sv_p_unitprice isEqualToString:@"1"]) {
                  
                     //   self.RetailAndWholesalePrices.hidden = NO;
                      
                }else{
                  //  self.RetailAndWholesalePrices.text = @"***";
                    self.priceView.hidden = YES;
                   self.priceHeight.constant = 0;
                   self.priceLineViewHeight.constant = 0;
                   self.priceLineView.hidden = YES;
                   self.bigViewHeight.constant = self.bigViewHeight.constant - 55.5;
                }
                }
            }
            
            self.duoguigeView.hidden = NO;
            self.big_color_height.constant = 224;
            self.gengduoTop.constant = 10;
            self.bigViewHeight.constant = self.bigViewHeight.constant - 55.5;
            self.chushikucunViewLine.hidden = YES;
          //  self.bigViewHeight.constant = 282.5;
            self.chushikucunViewLineheight.constant = 0;
            self.chushikucunView.hidden = YES;
            self.chushikucunHeight.constant = 0;
        }
        
        self.DeliveryPrice.text = self.DeliveryPriceStr;
        self.minimumPrice.text = self.minimumPriceStr;
        self.MinimumDiscount.text = self.MinimumDiscountStr;
        self.memberPrice.text = self.memberPriceStr;
        self.memberPrice1.text = self.memberPrice1Str;
        self.memberPrice2.text = self.memberPrice2Str;
        self.memberPrice3.text = self.memberPrice3Str;
        self.memberPrice4.text = self.memberPrice4Str;
        self.memberPrice5.text = self.memberPrice5Str;
        self.tradePrice.text = self.tradePriceStr;
        self.tradePrice1.text = self.tradePrice1Str;
        self.tradePrice2.text = self.tradePrice2Str;
        self.tradePrice3.text = self.tradePrice3Str;
        self.tradePrice4.text = self.tradePrice4Str;
        self.remarksText.text = self.sv_p_remark;
        if (!kStringIsEmpty(self.sv_unit_name)) {
            self.companyLabel.text = self.sv_unit_name;
        }
        
        if (!kStringIsEmpty(self.sv_suname)) {
            self.supplierLabel.text = self.sv_suname;
        }
        
       
        
        
        
       // _selectedPhotos
        NSLog(@"self.selectUploadingArray = %@",self.selectUploadingArray);
        for (NSDictionary *dict in self.imageArray) {
            NSString *code = dict[@"code"];
            if (!kDictIsEmpty(dict) && !kStringIsEmpty(code) && ![code isEqualToString:@"[]"] &&[code containsString:@"UploadImg"]) {
                NSString *url = [NSString stringWithFormat:@"%@%@",URLHeadPortrait,dict[@"code"]];
                [self.selectUploadingArray addObject:dict[@"code"]];
                UIImage *image = [self getImageFromURL:url];
                [_selectedPhotos addObject:image];
                [_collectionView reloadData];
            }
            
        }
        
       

        if (!kStringIsEmpty(self.product_integral) && ![self.product_integral containsString:@"null"]) {
            self.sv_product_integral.text = [NSString stringWithFormat:@"%@",self.product_integral];
        }
        
        // 提成数额
        if (!kStringIsEmpty(self.commissionratio) && ![self.commissionratio containsString:@"null"]) {
            self.sv_p_commissionratio.text = [NSString stringWithFormat:@"%@",self.commissionratio];
        }
        
        self.CommissionLabel.text = self.Commission;
       
    
        if (!kStringIsEmpty(self.CommodityBrand) && ![self.CommodityBrand containsString:@"null"]) {
            self.CommodityBrandLabel.text = [NSString stringWithFormat:@"%@",self.CommodityBrand];
        }
        
        if (!kStringIsEmpty(self.Fabric)) {
            self.FabricLabel.text = [NSString stringWithFormat:@"%@",self.Fabric];
        }
        if (!kStringIsEmpty(self.Gender) && ![self.Gender containsString:@"null"]) {
            self.GenderLabel.text = [NSString stringWithFormat:@"%@",self.Gender];
        }
        if (!kStringIsEmpty(self.CommodityYear) && ![self.CommodityYear containsString:@"null"]) {
            self.CommodityYearLabel.text = [NSString stringWithFormat:@"%@",self.CommodityYear];
        }
        if (!kStringIsEmpty(self.CommoditySeason) && ![self.CommoditySeason containsString:@"null"]) {
            self.CommoditySeasonLabel.text = [NSString stringWithFormat:@"%@",self.CommoditySeason];
        }
        if (!kStringIsEmpty(self.StyleInformation) && ![self.StyleInformation containsString:@"null"]) {
            self.StyleInformationLabel.text = [NSString stringWithFormat:@"%@",self.StyleInformation];
        }
        
        if (!kStringIsEmpty(self.safetyStandards) && ![self.safetyStandards containsString:@"null"]) {
            self.safetyStandardsLabel.text = [NSString stringWithFormat:@"%@",self.safetyStandards];
            
        }
  
//        // 是进价
//        [SVUserManager loadUserInfo];
//        NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
//          if (kDictIsEmpty(sv_versionpowersDict)) {
//                self.PurchasePriceView.hidden = NO;
//                self.PurchasePrice_height.constant = 55;
//               // self.bigViewHeight.constant = 228;
//          }else{
//           NSString *Sv_purchaseprice = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"CommodityManage"][@"Sv_purchaseprice"]];
//              if ([Sv_purchaseprice isEqualToString:@"1"]) {
//                  self.PurchasePriceView.hidden = NO;
//                  self.PurchasePrice_height.constant = 55;
//                  //self.bigViewHeight.constant = 228;
//              }else{
//                   self.PurchasePriceView.hidden = YES;
//                  self.PurchasePrice_height.constant = 0;
//                  self.view_height.constant = 0;
//                  self.bigViewHeight.constant = 166;
//              }
//          }
        
        
        
        NSString *urlStr2 = [URLhead stringByAppendingFormat:@"/product/GetSpecification?industrytype=%@&key=%@",[SVUserManager shareInstance].sv_uit_cache_id,[SVUserManager shareInstance].access_token];
        [[SVSaviTool sharedSaviTool] GET:urlStr2 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict8888 = %@",dict);
           NSArray *array = dict[@"values"];
            if (kArrayIsEmpty(array)) {
                [SVTool TextButtonActionWithSing:@"商品有误，不可以修改"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                SVColorOneModel *oneModel = [SVColorOneModel mj_objectWithKeyValues:dict[@"values"][0]];
                self.oneModel = oneModel;
                NSMutableDictionary *dict2 = dict[@"values"][1];
                NSLog(@"spec_name = %@",dict2[@"spec_name"]);
                
                SVSizeTwoModel *twoModel = [SVSizeTwoModel mj_objectWithKeyValues:dict[@"values"][1]];
                
                self.twoModel = twoModel;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
        
        if ([self.sv_pricing_method isEqualToString:@"1"]) {// 计重
            [self.weighSwitch setOn:YES animated:YES];
        }else{
            [self.weighSwitch setOn:NO animated:YES];
        }
        
        if (!kStringIsEmpty(self.imgURL)) {
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.imgURL]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
        }
        
        if (!kStringIsEmpty(self.barcode)) {
            self.borCodeTextFirld.text = self.barcode;
        }
        
        if (!kStringIsEmpty(self.waresName)) {
            self.nameText.text = self.waresName;
        }
        
        if (!kStringIsEmpty(self.classification)) {
            self.className.text = self.classification;
        }
        
        if (!kStringIsEmpty(self.price)) {
            self.salePriceText.text = self.price;
        }
        
        if (!kStringIsEmpty(self.purchaseprice)) {
            self.purchasePriceText.text = self.purchaseprice;
        }
        
//        if (!kStringIsEmpty(self.sv_p_memberprice)) {
//            self.memberPriceText.text = self.sv_p_memberprice;
//        }// 会员价
        
        if (!kStringIsEmpty(self.unit)) {
            self.companyLabel.text = self.unit;
        }
        
        
        if (kArrayIsEmpty(self.colorArray)) {
           // self.colorHeight.constant = 1;
//            self.big_color_height.constant = 0;
        }else{
            
            
            CGFloat tagBtnX = 16;
            CGFloat tagBtnY = 0;
            for (int i= 0; i<self.colorArray.count; i++) {
                
                CGSize tagTextSize = [self.colorArray[i] sizeWithFont:GlobalFont(12) maxSize:CGSizeMake(self.colorHeight_View.width-32-32, 30)];
                if (tagBtnX+tagTextSize.width+30 > self.colorHeight_View.width-32) {
                    
                    tagBtnX = 16;
                    tagBtnY += 30+15;
                }
                UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                tagBtn.tag = i;
                tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
                [tagBtn setTitle:self.colorArray[i] forState:UIControlStateNormal];
                [tagBtn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
                [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                CAShapeLayer *border = [CAShapeLayer layer];
                
                //虚线的颜色
                border.strokeColor = [UIColor orangeColor].CGColor;
                //填充的颜色
                border.fillColor = [UIColor clearColor].CGColor;
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tagBtn.bounds cornerRadius:5];
                
                //设置路径
                border.path = path.CGPath;
                
                border.frame = tagBtn.bounds;
                //虚线的宽度
                border.lineWidth = 1.f;
                //虚线的间隔
                border.lineDashPattern = @[@4, @2];
                
                tagBtn.layer.cornerRadius = 5.f;
                tagBtn.layer.masksToBounds = YES;
                
                [tagBtn.layer addSublayer:border];
                
                [self.colorHeight_View addSubview:tagBtn];
                
                tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
                
                self.colorHeight.constant = tagBtnY + 30;
                self.big_color_height.constant = 224+self.colorHeight.constant+ self.sizeHeight.constant;
                
            }
            
        }
        
        // 尺码
        if (kArrayIsEmpty(self.sizeTwoArray)) {
//            self.sizeHeight.constant = 1;
//            self.big_color_height.constant = 224 + self.colorHeight.constant + 1;
        }else{
            CGFloat tagBtnX = 16;
            CGFloat tagBtnY = 0;
            
            for (int i= 0; i<self.sizeTwoArray.count; i++) {
                SVDetailAttrilistModel *model = self.sizeTwoArray[i];
                CGSize tagTextSize = [model.attri_name sizeWithFont:GlobalFont(12) maxSize:CGSizeMake(self.sizeHeight_View.width-32-32, 30)];
                if (tagBtnX+tagTextSize.width+30 > self.sizeHeight_View.width-32) {
                    
                    tagBtnX = 16;
                    tagBtnY += 30+15;
                }
                UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                tagBtn.tag = i;
                tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
                [tagBtn setTitle:model.attri_name forState:UIControlStateNormal];
                [tagBtn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
                [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                CAShapeLayer *border = [CAShapeLayer layer];
                
                //虚线的颜色
                border.strokeColor = [UIColor orangeColor].CGColor;
                //填充的颜色
                border.fillColor = [UIColor clearColor].CGColor;
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tagBtn.bounds cornerRadius:5];
                
                //设置路径
                border.path = path.CGPath;
                
                border.frame = tagBtn.bounds;
                //虚线的宽度
                border.lineWidth = 1.f;
                //虚线的间隔
                border.lineDashPattern = @[@4, @2];
                
                tagBtn.layer.cornerRadius = 5.f;
                tagBtn.layer.masksToBounds = YES;
                
                [tagBtn.layer addSublayer:border];
                
                [self.sizeHeight_View addSubview:tagBtn];
                
                tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
                
                self.sizeHeight.constant = tagBtnY + 30;
                self.big_color_height.constant = 224+self.colorHeight.constant + self.sizeHeight.constant;
            }
        }
        
        
        __weak typeof(self) weakSelf = self;
        
        [weakSelf.duoguigeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
            SVduoguigeModel *duoguigeModel = weakSelf.duoguigeArray[index];
            
            // 尺码
            SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
            SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
            [weakSelf.firstSpecsDiffArray addObject:atteilistModel2.attri_name];
            self.spec_name_two = specModel2.spec_name;
            // 颜色的
            SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
            SVAtteilistModel *attriModel = specModel.attrilist.firstObject;
            [weakSelf.threeColorArray addObject:attriModel.attri_name];
            
            
            SVColorOneModel *oneModel = [[SVColorOneModel alloc] init];
            // 颜色的数据
            oneModel.spec_name = specModel.spec_name;
            oneModel.spec_id = [NSString stringWithFormat:@"%ld",(long)specModel.spec_id];
            oneModel.user_id = specModel.user_id;
            oneModel.industrytype_id = specModel.industrytype_id;
            oneModel.sv_is_multiplegroup = specModel.sv_is_multiplegroup.integerValue;
            oneModel.grouplist = specModel.grouplist;
            oneModel.sv_is_publish = specModel.sv_is_publish.integerValue;
            oneModel.sv_canbe_uploadimages = specModel.sv_canbe_uploadimages.integerValue;
            oneModel.sv_is_activity = specModel.sv_is_activity.integerValue;
            oneModel.effective = specModel.effective.integerValue;
            oneModel.sv_remark = specModel.sv_remark;
            oneModel.attri_group = specModel.attri_group;
            oneModel.sort = specModel.sort.integerValue;
            [self.oneModelArray addObject:oneModel];
            
            // 尺码的数据  sv_p_artno
            SVSizeTwoModel *twoModel = [[SVSizeTwoModel alloc] init];
            twoModel.spec_name = specModel2.spec_name;
            twoModel.spec_id = specModel.spec_id;
            twoModel.user_id = specModel.user_id.integerValue;
            twoModel.industrytype_id = specModel.industrytype_id;
            twoModel.sv_is_multiplegroup = specModel.sv_is_multiplegroup.integerValue;
            twoModel.grouplist = specModel.grouplist;
            twoModel.sv_is_publish = specModel.sv_is_publish.integerValue;
            twoModel.sv_canbe_uploadimages = specModel.sv_canbe_uploadimages.integerValue;
            twoModel.sv_is_activity = specModel.sv_is_activity.integerValue;
            twoModel.effective = specModel.effective.integerValue;
            twoModel.sv_remark = specModel.sv_remark;
            twoModel.attri_group = specModel.attri_group;
            twoModel.sort = specModel.sort;
            [self.twoModelArray addObject:twoModel];
            
            // 尺码底下attrilist的内容
            SVDetailAttrilistModel *model = [[SVDetailAttrilistModel alloc] init];
            model.attri_id = atteilistModel2.attri_id.integerValue;
            model.attri_group = atteilistModel2.attri_group;
            model.spec_id = atteilistModel2.spec_id;
            model.attri_code = atteilistModel2.attri_code;
            model.attri_name = atteilistModel2.attri_name;
            model.sv_remark = atteilistModel2.sv_remark;
            model.is_custom = atteilistModel2.is_custom.integerValue;
            model.effective = atteilistModel2.effective.integerValue;
            model.images_info = atteilistModel2.images_info;
            model.sort = atteilistModel2.sort;
            [self.atteilistModel2Array addObject:model];
            
            // 商品id
            [self.product_idArray addObject:duoguigeModel.id];
            
            // [self.sizeTwoArray addObject:model];
            // 库存
            [weakSelf.firstStorageDiffArray addObject:duoguigeModel.sv_p_storage];
            
            // 条码
            [weakSelf.firstArtnoDiffArray addObject:duoguigeModel.sv_p_artno];
            
            
        }];
        
        [self.editDictArray removeAllObjects];
        for (NSString *color in self.colorArray) {
            for (NSString *sizeStr in self.sizeStrArray) {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                [dictM setValue:color forKey:@"color"];
                [dictM setValue:sizeStr forKey:@"sizeStr"];
                [dictM setValue:@"" forKey:@"sv_p_artno"];
                [dictM setValue:@"0" forKey:@"sv_p_storage"];
                [self.editDictArray addObject:dictM];
            }
            }
        
        self.colorArray = self.threeColorArray; // 颜色名称
        self.specsDiffArray = self.firstSpecsDiffArray; // 尺码名称
        self.storageDiffArray = self.firstStorageDiffArray; // 库存
        self.artnoDiffArray = self.firstArtnoDiffArray; // 条码
        
        
        
        NSLog(@"规格\self.firstSpecsDiffArray==%@",self.firstSpecsDiffArray);
        NSLog(@"库存\self.storageDiffArray==%@",self.firstStorageDiffArray);
        NSLog(@"条码\firstArtnoDiffArray==%@",self.firstArtnoDiffArray);
        
    }else{
        self.title = @"新增商品";
        // 是进价
        [SVUserManager loadUserInfo];
        NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
        NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
          if (kDictIsEmpty(sv_versionpowersDict)) {
//                    self.PurchasePriceView.hidden = NO;
//                    self.PurchasePrice_height.constant = 55;
               // self.bigViewHeight.constant = 228;
          }else{
           NSString *Sv_purchaseprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_purchaseprice"]];
              if ([Sv_purchaseprice isEqualToString:@"1"]) {
//                      self.PurchasePriceView.hidden = NO;
//                      self.PurchasePrice_height.constant = 55;
//                      //self.bigViewHeight.constant = 228;
              }else{
                   self.PurchasePriceView.hidden = YES;
                  self.PurchasePrice_height.constant = 0;
                  self.lineView.hidden = YES;
                  self.lineViewHeight.constant = 0;
                  self.bigViewHeight.constant = self.bigViewHeight.constant - 55.5;
              }
          }
        
        
        //零售价
        if (kDictIsEmpty(CommodityManageDic)) {
          //  self.RetailAndWholesalePrices.hidden = NO;
          
        }else{
            NSString *Sv_p_unitprice = [NSString stringWithFormat:@"%@",CommodityManageDic[@"Sv_p_unitprice"]];
            if (kStringIsEmpty(Sv_p_unitprice)) {
              //  self.RetailAndWholesalePrices.hidden = NO;
              
            }else{
                if ([Sv_p_unitprice isEqualToString:@"1"]) {
              
                 //   self.RetailAndWholesalePrices.hidden = NO;
                  
            }else{
              //  self.RetailAndWholesalePrices.text = @"***";
                self.priceView.hidden = YES;
               self.priceHeight.constant = 0;
               self.priceLineViewHeight.constant = 0;
               self.priceLineView.hidden = YES;
               self.bigViewHeight.constant = self.bigViewHeight.constant - 55.5;
            }
            }
        }
        
        [self addLoadData];
    }
    
    NSLog(@"self.duoguigeArray = %@",self.duoguigeArray);
    
    
    self.switch_isOn = 0;// 开关一进来默认是关闭的
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.view.backgroundColor = BackgroundColor;
    // 上传图片
//    UITapGestureRecognizer *uploadPictureViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadPictureViewResponseEvent)];
//    [self.uploadPictureView addGestureRecognizer:uploadPictureViewTap];
    
    // 单位
    UITapGestureRecognizer *companyViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyViewResponseEvent)];
    [self.companyView addGestureRecognizer:companyViewTap];
    
    
    // 分类
    UITapGestureRecognizer *classificationViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(classificationViewResponseEvent)];
    [self.classificationView addGestureRecognizer:classificationViewTap];
    
    // 颜色
    UITapGestureRecognizer *colorViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(colorViewResponseEvent)];
    [self.colorView addGestureRecognizer:colorViewTap];
    
    // 尺寸
    UITapGestureRecognizer *sizeViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sizeViewResponseEvent)];
    [self.sizeView addGestureRecognizer:sizeViewTap];
    
    // 条码
    UITapGestureRecognizer *itemNumberViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemNumberViewResponseEvent)];
    [self.itemNumberView addGestureRecognizer:itemNumberViewTap];
    
    // 库存
    UITapGestureRecognizer *stockViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stockViewResponseEvent)];
    [self.stockView addGestureRecognizer:stockViewTap];
    
    //右上角按钮
    if (self.editInterface == 1) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    }else{
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    }
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self loadCompanyData];
    

}

#pragma mark - 网络链接转UIImage
-(UIImage *)getImageFromURL:(NSString *)fileURL
{
    
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

#pragma mark - 点击供应商的View  供应商用单位的pickerView来显示 单位有新的View显示了
- (void)gongyingshangClick{
    
    //pickerView指定代理
    self.pickerView.unitPicker.delegate = self;
    self.pickerView.unitPicker.dataSource = self;
    
    //为空是提示
//    if (kArrayIsEmpty(self.Supplierlist)) {
//        [SVTool TextButtonAction:self.view withSing:@"单位数据为空，可到电脑端添加单位"];
//        return;
//    }
    
    //    [self.view addSubview:self.maskTheView];
    //    [self.view addSubview:self.pickerView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
}

#pragma mark - 加载供应商的数据
- (void)SupplierGetSupplierlist{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Supplier/GetSupplierlist?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11545454= %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            NSArray *array = dic[@"values"];
            self.Supplierlist = array;
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

#pragma mark - 单位数据
- (void)ProductApiConfigGetunitModelList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetunitModelList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.companyArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

#pragma mark - 点击单位view
- (void)companyViewResponseEvent{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    self.addShopDetailView.listArray = self.companyArray;
    self.addShopDetailView.addBtn.hidden = NO;
    self.addShopDetailView.titleDetail.text = @"单位";
    __weak typeof(self) weakSelf = self;
//    self.addShopDetailView.StandardListBlock = ^{
//        [weakSelf ProductApiConfigGetStandardList];
//    };
    
    self.addShopDetailView.companyBlock = ^{
        [weakSelf ProductApiConfigGetunitModelList];
    };
    
    self.addShopDetailView.companyBlock2 = ^(NSDictionary * _Nonnull dict) {
        weakSelf.companyLabel.text = dict[@"sv_unit_name"];
        weakSelf.sv_unit_name = dict[@"sv_unit_name"];
        weakSelf.company_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
        [weakSelf handlePan];
    };
    NSLog(@"weakSelf.company_id = %@",weakSelf.company_id);
//    self.addShopDetailView.StandardListBlock2 = ^(NSDictionary * _Nonnull dict) {
//
//    };
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
    
}

// 商品品牌
- (void)CommodityBrandViewTapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    self.addShopDetailView.listArray = self.CommodityBrandArray;
    self.addShopDetailView.titleDetail.text = @"商品品牌";
    self.addShopDetailView.addBtn.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.addShopDetailView.Sv_Brand_LibBlock = ^{
        [weakSelf ProductApiConfigGetSv_Brand_Lib];
    };
    
    self.addShopDetailView.Sv_Brand_LibBlock2 = ^(NSDictionary * _Nonnull dict) {
        weakSelf.CommodityBrandLabel.text = dict[@"sv_brand_name"];
        weakSelf.CommodityBrand = dict[@"sv_brand_name"];
        weakSelf.sv_brand_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
        [weakSelf handlePan];
    };
    
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
}

// 提成
- (void)CommissionViewTapClick{
    
    NSArray * arr = @[@"元",@"%"];
    HLPopTableView * hlPopView = [HLPopTableView initWithFrame:CGRectMake(0, 0, self.CommissionView.width,100) dependView:self.CommissionView textArr:arr block:^(NSString *region_name, NSInteger index) {
        self.CommissionLabel.text = region_name;
        NSLog(@"region_name = %@",region_name);
    }];
    [self.view addSubview:hlPopView];
    
}

// 面料
- (void)FabricViewTapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    self.addShopDetailView.listArray = self.FabricArray;
    self.addShopDetailView.titleDetail.text = @"面料列表";
    self.addShopDetailView.addBtn.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.addShopDetailView.mianliaoBlock = ^{
        [weakSelf ProductApiConfigGetFabricList];
    };
    
    self.addShopDetailView.mianliaoBlock2 = ^(NSDictionary * _Nonnull dict) {
        weakSelf.FabricLabel.text = dict[@"sv_foundation_name"];
        weakSelf.Fabric = dict[@"sv_foundation_name"];
        weakSelf.sv_product_fabric_id = [NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]];
        [weakSelf handlePan];
    };
    
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
}
// 性别信息
- (void)GenderViewTapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    self.addShopDetailView.listArray = self.genderListArray;
    self.addShopDetailView.titleDetail.text = @"性别信息";
    self.addShopDetailView.addBtn.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.addShopDetailView.GenderListBlock = ^{
        [weakSelf ProductApiConfigGetGenderList];
    };

    self.addShopDetailView.GenderListBlock2 = ^(NSDictionary * _Nonnull dict) {
        weakSelf.GenderLabel.text = dict[@"sv_foundation_name"];
        weakSelf.Gender = dict[@"sv_foundation_name"];
        weakSelf.sv_product_gender_id = [NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]];
        [weakSelf handlePan];
    };
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
}
// 商品年份
- (void)CommodityYearViewTapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    NSArray *array = @[@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017"];
    self.addShopDetailView.listArray = array;
    self.addShopDetailView.titleDetail.text = @"商品年份";
    self.addShopDetailView.addBtn.hidden = YES;
    __weak typeof(self) weakSelf = self;
//    self.addShopDetailView.SeasonlListBlock = ^{
//        [weakSelf ProductApiConfigGetSeasonlList];
//    };

    self.addShopDetailView.CommodityYearBlock2 = ^(NSString * _Nonnull year) {
        weakSelf.CommodityYearLabel.text = year;
        weakSelf.CommodityYear = year;
        [weakSelf handlePan];
    };
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
}
// 商品季节
- (void)CommoditySeasonViewTapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    self.addShopDetailView.listArray = self.SeasonlListArray;
    self.addShopDetailView.titleDetail.text = @"商品季节";
    self.addShopDetailView.addBtn.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.addShopDetailView.SeasonlListBlock = ^{
        [weakSelf ProductApiConfigGetSeasonlList];
    };

    self.addShopDetailView.SeasonlListBlock2 = ^(NSDictionary * _Nonnull dict) {
        weakSelf.CommoditySeasonLabel.text = dict[@"sv_foundation_name"];
        weakSelf.CommoditySeason = dict[@"sv_foundation_name"];
        weakSelf.sv_product_season_id = [NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]];
        [weakSelf handlePan];
    };
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
}
// 款式信息
- (void)StyleInformationViewTapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    self.addShopDetailView.listArray = self.StyleListArray;
    self.addShopDetailView.titleDetail.text = @"款式信息";
    self.addShopDetailView.addBtn.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.addShopDetailView.StyleListBlock = ^{
        [weakSelf ProductApiConfigGetStyleList];
    };
    

    self.addShopDetailView.StyleListBlock2 = ^(NSDictionary * _Nonnull dict) {
        weakSelf.StyleInformationLabel.text = dict[@"sv_foundation_name"];
        weakSelf.StyleInformation = dict[@"sv_foundation_name"];
        weakSelf.sv_product_style_id = [NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]];
        [weakSelf handlePan];
    };
    
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
}
// 安全标准
- (void)safetyStandardsViewTapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    self.addShopDetailView.listArray = self.StandardListArray;
    self.addShopDetailView.addBtn.hidden = NO;
    self.addShopDetailView.titleDetail.text = @"安全标准";
    __weak typeof(self) weakSelf = self;
    self.addShopDetailView.StandardListBlock = ^{
        [weakSelf ProductApiConfigGetStandardList];
    };
    
    self.addShopDetailView.StandardListBlock2 = ^(NSDictionary * _Nonnull dict) {
        weakSelf.safetyStandardsLabel.text = dict[@"sv_foundation_name"];
        weakSelf.safetyStandards = dict[@"sv_foundation_name"];
        weakSelf.sv_product_standard_id = [NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]];
        [weakSelf handlePan];
    };
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
}

#pragma mark - 执行标准
- (void)ExecutiveStandardViewTapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.addShopDetailView];
    self.addShopDetailView.listArray = self.ExecutiveStandardArray;
    self.addShopDetailView.addBtn.hidden = NO;
    self.addShopDetailView.titleDetail.text = @"执行标准";
    __weak typeof(self) weakSelf = self;
    self.addShopDetailView.ExecutiveStandardBlock = ^{
        [weakSelf GetExecutivestandardList];
    };
    
    self.addShopDetailView.ExecutiveStandardBlock2 = ^(NSDictionary * _Nonnull dict) {
        weakSelf.ExecutiveStandardLabel.text = dict[@"sv_foundation_name"];
        weakSelf.sv_executivestandard = dict[@"sv_foundation_name"];
        weakSelf.sv_executivestandard_id = [NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]];
        [weakSelf handlePan];
    };
    //实现弹出方法
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0,ScreenH - num, ScreenW, num);
    }];
}

#pragma mark - 加载数据接口
// 商品品牌接口
- (void)ProductApiConfigGetSv_Brand_Lib{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetSv_Brand_Lib?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.CommodityBrandArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

// 面料接口
- (void)ProductApiConfigGetFabricList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetFabricList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.FabricArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}
// 性别
- (void)ProductApiConfigGetGenderList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetGenderList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.genderListArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

// 季节
- (void)ProductApiConfigGetSeasonlList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetSeasonlList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.SeasonlListArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

// 款式
- (void)ProductApiConfigGetStyleList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetStyleList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.StyleListArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}


// 安全标准
- (void)ProductApiConfigGetStandardList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetStandardList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.StandardListArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

#pragma mark - 执行标准
- (void)GetExecutivestandardList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetExecutivestandardList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.ExecutiveStandardArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

#pragma clang diagnostic pop

#pragma mark - 点击更多按钮
- (void)MoreInformationTap:(UITapGestureRecognizer *)tap{
    
    _selected = !_selected;

    if(_selected) {
        NSLog(@"选中");
        //实现弹出方法
        [UIView animateWithDuration:.2 animations:^{
            self.MoreInformationHeight.constant = 1330;
            self.moreInformationView.hidden = NO;
        }];
        
        [UIView animateWithDuration:.2 animations:^{
            //旋转
            self.moreInfoIcon.transform = CGAffineTransformRotate(self.moreInfoIcon.transform, M_PI);
        }];
        
        
    }else {
        NSLog(@"取消选中");
        //实现弹出方法
        [UIView animateWithDuration:.2 animations:^{
            self.MoreInformationHeight.constant =0;
            self.moreInformationView.hidden = YES;
        }];
        
        [UIView animateWithDuration:.2 animations:^{
            //旋转
            self.moreInfoIcon.transform = CGAffineTransformRotate(self.moreInfoIcon.transform, M_PI);
        }];
    }
    
    
  
}

#pragma mark - 点击计重商品
- (void)weighSwitchClick:(UISwitch *)swi{
    if (swi.isOn) {// 开着开关
        self.switch_isOn = 1;
    }else{
        self.switch_isOn = 0;
    }
}

#pragma mark - 保存按钮的使用
- (void)selectbuttonResponseEvent{
    
        if (self.editInterface == 1) {
            
            if (kStringIsEmpty(self.borCodeTextFirld.text)) {
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }
               
                return;
            }
            if (kStringIsEmpty(self.nameText.text)) {
                [SVTool TextButtonAction:self.view withSing:@"名称不能为空"];
                return;
            }
            
            if (kStringIsEmpty(self.className.text)) {
                [SVTool TextButtonAction:self.view withSing:@"分类不能为空"];
                return;
            }
            
            if (kStringIsEmpty(self.salePriceText.text)) {
                [SVTool TextButtonAction:self.view withSing:@"售价不能为空"];
                return;
            }
            
//            if (kArrayIsEmpty(self.colorArray)) {
//                [SVTool TextButtonAction:self.view withSing:@"颜色不能为空"];
//                return;
//            }
//
//            if (kArrayIsEmpty(self.sizeTwoArray)) {
//                [SVTool TextButtonAction:self.view withSing:@"尺码不能为空"];
//                return;
//            }
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [SVUserManager loadUserInfo];
            
            NSMutableArray *arraydata = [NSMutableArray array];
            NSMutableArray *arraydataResult = [NSMutableArray array];
            NSMutableArray *arraydataResult2 = [NSMutableArray array];
            for (NSDictionary *dict in self.editDictArray) {
                for (SVduoguigeModel *duoguigeModel in self.duoguigeArray) {
                  //  SVduoguigeModel *duoguigeModel = weakSelf.duoguigeArray[index];
                   NSString *color = dict[@"color"];
                     NSString *sizeStr = dict[@"sizeStr"];
                    // 尺码
                    SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
                    SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
                  //  [weakSelf.firstSpecsDiffArray addObject:atteilistModel2.attri_name];
                  //  self.spec_name_two = specModel2.spec_name;
                    // 颜色的
                    SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
                    SVAtteilistModel *attriModel = specModel.attrilist.firstObject;
                   // [weakSelf.threeColorArray addObject:attriModel.attri_name];
                    
                    if ([atteilistModel2.attri_name isEqualToString:sizeStr] && [attriModel.attri_name isEqualToString:color]) {
                        [arraydataResult addObject:duoguigeModel];
                        [arraydata addObject:dict];
                        
                    }
                }
            }
            
            NSLog(@"arraydata = %@",arraydata);
            NSLog(@"arraydataResult = %@",arraydataResult);
            
            NSArray *diffArray = [self filterArr:arraydata andArr2:self.editDictArray];
            NSLog(@"diffArray = %@",diffArray);
            [arraydataResult2 addObjectsFromArray:arraydataResult];
             [arraydataResult2 addObjectsFromArray:diffArray];
            NSLog(@"arraydataResult2 = %@",arraydataResult2);
            

            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApi/RetailSpecProductUpdate?key=%@&sv_p_source=300",[SVUserManager shareInstance].access_token];
            NSMutableDictionary *productinfo = [NSMutableDictionary dictionary];
            NSMutableArray *productCustomdDetailList = [NSMutableArray array];
            

            
            for (NSInteger i = 0; i < arraydataResult2.count; i++) {
//                SVDetailAttrilistModel *model = DetailAttrilistModelArray[i];
//                SVColorOneModel *oneModel = self.oneModelArray[i];
//                SVSizeTwoModel *twoModel = self.twoModelArray[i];
                // 尺码
                           
                if ([arraydataResult2[i] isKindOfClass:[NSDictionary class]]) {
                      // 是新增的商品
                                  
                    NSDictionary *dict = arraydataResult2[i];
                    
                    NSString *product_id = @"0";
                    NSMutableDictionary *productinfo_detail_one = [NSMutableDictionary dictionary];
                    
                    [productinfo_detail_one setObject:product_id forKey:@"id"];
                    
                    //                        if (kArrayIsEmpty(self.ItemNumberArray)) {
                    //                            [productinfo_detail_one setObject:self.artnoDiffArray[i] forKey:@"sv_p_artno"];
                    //                        }else{
                    NSString *sv_p_artno = dict[@"sv_p_artno"];
                    
                    if (kStringIsEmpty(sv_p_artno) || [sv_p_artno isEqualToString:@"0"]) {
                        [self.navigationItem.rightBarButtonItem setEnabled:YES];
                        return[SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                    }else{
                        [productinfo_detail_one setObject:dict[@"sv_p_artno"] forKey:@"sv_p_artno"];
                    }
                  
                    // }
                    
                    [productinfo_detail_one setObject:kStringIsEmpty(self.imgURL)?@"":self.imgURL forKey:@"sv_p_images"];
                    
                    [productinfo_detail_one setObject:@"0" forKey:@"sv_pricing_method"];
                    
                    //                        if (kArrayIsEmpty(self.initialArray)) {
                    //                            [productinfo_detail_one setObject:[self.storageDiffArray[i] isEqual:@""]?@"0":self.storageDiffArray[i] forKey:@"sv_p_storage"];
                    //                        }else{
                    [productinfo_detail_one setObject:dict[@"sv_p_storage"] forKey:@"sv_p_storage"];
                    
                    // }
                    
                    
                    NSMutableArray *sv_cur_spec = [NSMutableArray array];
                    // 设置颜色信息
                    NSMutableDictionary *colorDic = [NSMutableDictionary dictionary];
                    
                    [colorDic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:1]] forKey:@"spec_id"];
                    [colorDic setObject:@"颜色" forKey:@"spec_name"];
                    [colorDic setObject:@"0" forKey:@"user_id"];
                    [colorDic setObject:@"18" forKey:@"industrytype_id"];
                    
                    [colorDic setObject:@"false" forKey:@"sv_is_multiplegroup"];
                    
                    
                    [colorDic setObject:@"" forKey:@"grouplist"];
                    
                    
                    [colorDic setObject: @"true" forKey:@"sv_is_publish"];
                    
                    [colorDic setObject:@"false" forKey:@"sv_is_activity"];
                    
                    [colorDic setObject: @"true" forKey:@"sv_canbe_uploadimages"];
                    
                    
                    [colorDic setObject: @"true" forKey:@"effective"];
                    
                    
                    [colorDic setObject:@"" forKey:@"sv_remark"];
                    
                    
                    [colorDic setObject:@"" forKey:@"attri_group"];
                    
                    
                    [colorDic setObject:@"1"forKey:@"sort"];
                    
                    NSMutableArray *attrilist = [NSMutableArray array];
                    NSMutableDictionary *attrilistDic = [NSMutableDictionary dictionary];
                    
                    [attrilistDic setObject:@"0" forKey:@"attri_id"];
                    [attrilistDic setObject:@"" forKey:@"attri_group"];
                    
                    [attrilistDic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:1]] forKey:@"spec_id"];
                    
                    [attrilistDic setObject:@"" forKey:@"attri_code"];
                    
                    [attrilistDic setObject:dict[@"color"] forKey:@"attri_name"];
                    
                    [attrilistDic setObject:@"" forKey:@"sv_remark"];
                    
                    [attrilistDic setObject:@"false" forKey:@"is_custom"];
                    
                    [attrilistDic setObject:@"true" forKey:@"effective"];
                    
                    [attrilistDic setObject:@"" forKey:@"images_info"];
                    
                    [attrilistDic setObject:@"1" forKey:@"sort"];
                    [attrilist addObject:attrilistDic];
                    [colorDic setObject:attrilist forKey:@"attrilist"];
                    
                    
                    // 尺码信息
                    NSMutableDictionary *SizeInformationDic = [NSMutableDictionary dictionary];
                    
                    [SizeInformationDic setObject:@"2" forKey:@"spec_id"];
                    //  NSLog(@"self.twoModel.spec_id = %ld",self.twoModel.spec_id);
                    [SizeInformationDic setObject:@"尺码" forKey:@"spec_name"];
                    
                    [SizeInformationDic setObject:@"0" forKey:@"user_id"];
                    
                    [SizeInformationDic setObject:@"18" forKey:@"industrytype_id"];
                    
                    [SizeInformationDic setObject:@"false" forKey:@"sv_is_multiplegroup"];
                    
                    
                    [SizeInformationDic setObject:@"" forKey:@"grouplist"];
                    
                    [SizeInformationDic setObject: @"true" forKey:@"sv_is_publish"];
                    
                    [SizeInformationDic setObject:@"false" forKey:@"sv_is_activity"];
                    
                    [SizeInformationDic setObject: @"true" forKey:@"sv_canbe_uploadimages"];
                    
                    [SizeInformationDic setObject:@"true"forKey:@"effective"];
                    
                    [SizeInformationDic setObject:@"" forKey:@"sv_remark"];
                    
                    [SizeInformationDic setObject:@"" forKey:@"attri_group"];
                    
                    [SizeInformationDic setObject:@"2" forKey:@"sort"];
                    
                    NSMutableArray *attrilist_array = [NSMutableArray array];
                    NSMutableDictionary *attrilist_dic = [NSMutableDictionary dictionary];
                    
                    [attrilist_dic setObject:@"0" forKey:@"attri_id"];
                    
                    [attrilist_dic setObject:self.attri_group forKey:@"attri_group"];
                    
                    [attrilist_dic setObject:@"2" forKey:@"spec_id"];
                    
                  //  [attrilist_dic setObject:@"" forKey:@"attri_code"];
                    
                    [attrilist_dic setObject:dict[@"sizeStr"] forKey:@"attri_name"];
                    
                    [attrilist_dic setObject:@"" forKey:@"sv_remark"];
                    
                    [attrilist_dic setObject:@"false" forKey:@"is_custom"];
                    
                    [attrilist_dic setObject:@"true" forKey:@"effective"];
                    
                    [attrilist_dic setObject: @"" forKey:@"images_info"];
                    
                    [attrilist_dic setObject:@"2" forKey:@"sort"];
                    
                    [attrilist_array addObject:attrilist_dic];
                    
                    [SizeInformationDic setObject:attrilist_array forKey:@"attrilist"];
                    
                    [sv_cur_spec addObject:colorDic];
                    [sv_cur_spec addObject:SizeInformationDic];
                    if (kArrayIsEmpty(arraydataResult2)) {
                        [productinfo_detail_one setObject:@"false" forKey:@"sv_is_newspec"];
                    }else{
                        [productinfo_detail_one setObject:@"true" forKey:@"sv_is_newspec"];
                    }
                  
                    
                    [productinfo_detail_one setObject:@"false" forKey:@"sv_is_active"];
                    
                    [productinfo_detail_one setObject:sv_cur_spec forKey:@"sv_cur_spec"];
                    [productCustomdDetailList addObject:productinfo_detail_one];
                    
                    }else{
                   // NSLog(@"不是字典类型");
                  
                    SVduoguigeModel *duoguigeModel = arraydataResult2[i];
                    
                    SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
                    SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
                    //  [weakSelf.firstSpecsDiffArray addObject:atteilistModel2.attri_name];
                    // self.spec_name_two = specModel2.spec_name;
                    // 颜色的
                    SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
                    SVAtteilistModel *attriModel = specModel.attrilist.firstObject;
                  //  [weakSelf.threeColorArray addObject:attriModel.attri_name];
                    
                   // NSString *product_id = duoguigeModel.product_id;
                        NSString *product_id = duoguigeModel.id;
                        NSMutableDictionary *productinfo_detail_one = [NSMutableDictionary dictionary];

                        [productinfo_detail_one setObject:product_id forKey:@"id"];

//                        if (kArrayIsEmpty(self.ItemNumberArray)) {
//                            [productinfo_detail_one setObject:self.artnoDiffArray[i] forKey:@"sv_p_artno"];
//                        }else{
                        if (kStringIsEmpty(duoguigeModel.sv_p_artno) || [duoguigeModel.sv_p_artno isEqualToString:@"0"]) {
                            [self.navigationItem.rightBarButtonItem setEnabled:YES];
                            return [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                        }else{
                            [productinfo_detail_one setObject:duoguigeModel.sv_p_artno forKey:@"sv_p_artno"];
                        }
                    
                       // }

                        [productinfo_detail_one setObject:kStringIsEmpty(self.imgURL)?@"":self.imgURL forKey:@"sv_p_images"];

                        [productinfo_detail_one setObject:@"0" forKey:@"sv_pricing_method"];

//                        if (kArrayIsEmpty(self.initialArray)) {
//                            [productinfo_detail_one setObject:[self.storageDiffArray[i] isEqual:@""]?@"0":self.storageDiffArray[i] forKey:@"sv_p_storage"];
//                        }else{
                    [productinfo_detail_one setObject:duoguigeModel.sv_p_storage forKey:@"sv_p_storage"];

                       //


                        NSMutableArray *sv_cur_spec = [NSMutableArray array];
                        // 设置颜色信息
                        NSMutableDictionary *colorDic = [NSMutableDictionary dictionary];

                        [colorDic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:specModel.spec_id]] forKey:@"spec_id"];
                        [colorDic setObject:[NSString stringWithFormat:@"%@",specModel.spec_name] forKey:@"spec_name"];
                        [colorDic setObject:[NSString stringWithFormat:@"%@",specModel.user_id] forKey:@"user_id"];
                        [colorDic setObject:[NSString stringWithFormat:@"%@",specModel.industrytype_id] forKey:@"industrytype_id"];

                    [colorDic setObject:specModel.sv_is_multiplegroup.intValue == 1? @"true":@"false" forKey:@"sv_is_multiplegroup"];


                        [colorDic setObject:@"" forKey:@"grouplist"];


                    [colorDic setObject:specModel.sv_is_publish.intValue == 1? @"true":@"false" forKey:@"sv_is_publish"];

                    [colorDic setObject:specModel.sv_is_activity.intValue == 1? @"true":@"false" forKey:@"sv_is_activity"];

                    [colorDic setObject:specModel.sv_canbe_uploadimages.intValue == 1? @"true":@"false" forKey:@"sv_canbe_uploadimages"];


                    [colorDic setObject:specModel.effective.intValue == 1? @"true":@"false" forKey:@"effective"];


                        [colorDic setObject:[NSString stringWithFormat:@"%@",specModel.sv_remark] forKey:@"sv_remark"];


                        [colorDic setObject:[NSString stringWithFormat:@"%@",specModel.attri_group] forKey:@"attri_group"];


                        [colorDic setObject:[NSString stringWithFormat:@"%@",specModel.sort] forKey:@"sort"];

                        NSMutableArray *attrilist = [NSMutableArray array];
                        NSMutableDictionary *attrilistDic = [NSMutableDictionary dictionary];

                        [attrilistDic setObject:@"0" forKey:@"attri_id"];
                        [attrilistDic setObject:[NSString stringWithFormat:@"%@",attriModel.attri_group] forKey:@"attri_group"];

                        [attrilistDic setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:attriModel.spec_id]] forKey:@"spec_id"];

                        [attrilistDic setObject:@"" forKey:@"attri_code"];

                    [attrilistDic setObject:attriModel.attri_name forKey:@"attri_name"];

                        [attrilistDic setObject:[NSString stringWithFormat:@"%@",attriModel.sv_remark] forKey:@"sv_remark"];

                        [attrilistDic setObject:@"false" forKey:@"is_custom"];

                        [attrilistDic setObject:@"true" forKey:@"effective"];

                        [attrilistDic setObject:@"" forKey:@"images_info"];

                        [attrilistDic setObject:@"0" forKey:@"sort"];
                        [attrilist addObject:attrilistDic];
                        [colorDic setObject:attrilist forKey:@"attrilist"];



                        // 尺码信息
                        NSMutableDictionary *SizeInformationDic = [NSMutableDictionary dictionary];

                        [SizeInformationDic setObject:[NSString stringWithFormat:@"%ld",specModel2.spec_id] forKey:@"spec_id"];
                        //  NSLog(@"self.twoModel.spec_id = %ld",self.twoModel.spec_id);
                    [SizeInformationDic setObject:specModel2.spec_name forKey:@"spec_name"];

                        [SizeInformationDic setObject:[NSString stringWithFormat:@"%@",specModel2.user_id] forKey:@"user_id"];

                        [SizeInformationDic setObject:specModel2.industrytype_id forKey:@"industrytype_id"];

                    [SizeInformationDic setObject:specModel2.sv_is_multiplegroup.intValue == 1? @"true":@"false" forKey:@"sv_is_multiplegroup"];


                        [SizeInformationDic setObject:@"" forKey:@"grouplist"];

                    [SizeInformationDic setObject:specModel2.sv_is_publish.intValue == 1? @"true":@"false" forKey:@"sv_is_publish"];

                    [SizeInformationDic setObject:specModel2.sv_is_activity.intValue == 1? @"true":@"false" forKey:@"sv_is_activity"];

                    [SizeInformationDic setObject:specModel2.sv_canbe_uploadimages.intValue == 1? @"true":@"false" forKey:@"sv_canbe_uploadimages"];

                        [SizeInformationDic setObject:@"true"forKey:@"effective"];

                        [SizeInformationDic setObject:@"" forKey:@"sv_remark"];

                        [SizeInformationDic setObject:specModel2.attri_group forKey:@"attri_group"];

                        [SizeInformationDic setObject:[NSString stringWithFormat:@"%@",specModel2.sort] forKey:@"sort"];

                        NSMutableArray *attrilist_array = [NSMutableArray array];
                        NSMutableDictionary *attrilist_dic = [NSMutableDictionary dictionary];

                        [attrilist_dic setObject:[NSString stringWithFormat:@"%@",atteilistModel2.attri_id] forKey:@"attri_id"];

                        [attrilist_dic setObject:[NSString stringWithFormat:@"%@",atteilistModel2.attri_group] forKey:@"attri_group"];

                        [attrilist_dic setObject:[NSString stringWithFormat:@"%ld",atteilistModel2.spec_id] forKey:@"spec_id"];

                        [attrilist_dic setObject:[NSString stringWithFormat:@"%@",atteilistModel2.attri_code] forKey:@"attri_code"];

                        [attrilist_dic setObject:[NSString stringWithFormat:@"%@",atteilistModel2.attri_name] forKey:@"attri_name"];

                        [attrilist_dic setObject:[NSString stringWithFormat:@"%@",atteilistModel2.sv_remark] forKey:@"sv_remark"];

                    [attrilist_dic setObject:atteilistModel2.is_custom.intValue == 1? @"true":@"false" forKey:@"is_custom"];

                        [attrilist_dic setObject:@"true" forKey:@"effective"];

                        [attrilist_dic setObject: [NSString stringWithFormat:@"%@",atteilistModel2.images_info] forKey:@"images_info"];

                        [attrilist_dic setObject:[NSString stringWithFormat:@"%@",atteilistModel2.sort] forKey:@"sort"];

                        [attrilist_array addObject:attrilist_dic];

                        [SizeInformationDic setObject:attrilist_array forKey:@"attrilist"];

                        [sv_cur_spec addObject:colorDic];
                        [sv_cur_spec addObject:SizeInformationDic];

                       // [productinfo_detail_one setObject:@"true" forKey:@"sv_is_newspec"];
                        if (kArrayIsEmpty(arraydataResult2)) {
                            [productinfo_detail_one setObject:@"false" forKey:@"sv_is_newspec"];
                        }else{
                            [productinfo_detail_one setObject:@"true" forKey:@"sv_is_newspec"];
                        }
                        [productinfo_detail_one setObject:@"false" forKey:@"sv_is_active"];

                        [productinfo_detail_one setObject:sv_cur_spec forKey:@"sv_cur_spec"];
                        [productCustomdDetailList addObject:productinfo_detail_one];
                    }

                }
            
            [productinfo setObject:productCustomdDetailList forKey:@"productCustomdDetailList"];

            [productinfo setObject:self.product_id forKey:@"id"];

            [productinfo setObject:[NSString stringWithFormat:@"%ld",self.productcategory_id] forKey:@"productcategory_id"];

            [productinfo setObject:[NSString stringWithFormat:@"%ld",self.productsubcategory_id] forKey:@"productsubcategory_id"];

            [productinfo setObject:[NSString stringWithFormat:@"%ld",self.producttype_id] forKey:@"producttype_id"];
            
            if (kArrayIsEmpty(productCustomdDetailList)) {
                [productinfo setObject:@"false" forKey:@"sv_is_newspec"];
            }else{
                [productinfo setObject:@"true" forKey:@"sv_is_newspec"];
            }
           


            [productinfo setObject:@"" forKey:@"sv_mnemonic_code"];

            [productinfo setObject:self.borCodeTextFirld.text forKey:@"sv_p_barcode"];

//            [productinfo setObject:kStringIsEmpty(self.imgURL) ? @"": self.imgURL forKey:@"sv_p_images"];
            
            NSMutableArray *sv_p_imagesArray = [NSMutableArray array];
            for (NSString *imageUrl in self.selectUploadingArray) {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                dictM[@"code"] = imageUrl;
                dictM[@"isdefault"] = @"true";
                [sv_p_imagesArray addObject:dictM];
            }
            
          //  [productinfo setObject:sv_p_images forKey:@"sv_p_images"];
            if (!kArrayIsEmpty(sv_p_imagesArray)) {
                NSString *sv_p_images = [self arrayToJSONString:sv_p_imagesArray];
                NSLog(@"sv_p_images = %@",sv_p_images);
                [productinfo setObject:sv_p_images forKey:@"sv_p_images"];
            }
            
            [productinfo setObject:self.nameText.text forKey:@"sv_p_name"];

            [productinfo setObject:kStringIsEmpty(self.purchasePriceText.text) ? @"0":self.purchasePriceText.text forKey:@"sv_p_originalprice"];

           // [productinfo setObject:@"" forKey:@"sv_p_remark"];
            [productinfo setObject:kStringIsEmpty(self.remarksText.text)?@"":self.remarksText.text forKey:@"sv_p_remark"];
//            if (!kStringIsEmpty(self.sv_suid)) {
//                [productinfo setObject:self.sv_suid forKey:@"sv_suid"];
//            }
           
            
            [productinfo setObject:[self.sv_unit_name isEqualToString:@"单位选择"] ? @"":self.sv_unit_name forKey:@"sv_unit_name"];
             
             if (!kStringIsEmpty(self.sv_suid)) {
                 [productinfo setObject:self.sv_suid forKey:@"sv_suid"];
             }
             
             if (!kStringIsEmpty(self.company_id)) {
                 [productinfo setObject:self.company_id forKey:@"sv_unit_id"];
             }

            [productinfo setObject:self.salePriceText.text forKey:@"sv_p_unitprice"];
//            [productinfo setObject:self.memberPriceText.text forKey:@"sv_p_memberprice"];// 会员价

            [productinfo setObject:@"0" forKey:@"sv_pricing_method"];

            [productinfo setObject:@"" forKey:@"sv_product_brand"];

            [productinfo setObject:kStringIsEmpty(self.purchasePriceText.text) ? @"0":self.purchasePriceText.text forKey:@"sv_purchaseprice"];
            NSLog(@"productinfo修改 = %@",productinfo);
        
//        if (!kStringIsEmpty(self.CommodityBrand)) {
//            [productinfo setObject:self.CommodityBrand forKey:@"sv_brand_name"];
//        }
            
            if (kArrayIsEmpty(productCustomdDetailList)) {
                [productinfo setObject:kStringIsEmpty(self.sv_p_storageText.text)?@"0":self.sv_p_storageText.text forKey:@"sv_p_storage"];
            }
            
        // 积分
        if (!kStringIsEmpty(self.sv_product_integral.text) && ![self.sv_product_integral.text containsString:@"null"]) {
            [productinfo setObject:self.sv_product_integral.text forKey:@"sv_product_integral"];
        }
        
        // 提成数额
        if (!kStringIsEmpty(self.sv_p_commissionratio.text) && ![self.sv_p_commissionratio.text containsString:@"null"]) {
            [productinfo setObject:self.sv_p_commissionratio.text forKey:@"sv_p_commissionratio"];
        }
        // 提成元还是%
        if ([self.CommissionLabel.text isEqualToString:@"元"]) {
            [productinfo setObject:[NSNumber numberWithInteger:1] forKey:@"sv_p_commissiontype"];
        }else{
            [productinfo setObject:[NSNumber numberWithInteger:0] forKey:@"sv_p_commissiontype"];
        }
        
        
        
        if (!kStringIsEmpty(self.CommodityBrand) && ![self.CommodityBrand containsString:@"null"]) {
            [productinfo setObject:self.CommodityBrand forKey:@"sv_brand_name"];
        }
        
        if (!kStringIsEmpty(self.Fabric) && ![self.Fabric containsString:@"null"]) {
            [productinfo setObject:self.Fabric forKey:@"fabric_name"];
        }
        if (!kStringIsEmpty(self.Gender) && ![self.Gender containsString:@"null"]) {
            [productinfo setObject:self.Gender forKey:@"gender_name"];
        }
        if (!kStringIsEmpty(self.CommodityYear) && ![self.CommodityYear containsString:@"null"]) {
            [productinfo setObject:self.CommodityYear forKey:@"sv_particular_year"];
        }
        if (!kStringIsEmpty(self.CommoditySeason) && ![self.CommoditySeason containsString:@"null"]) {
            [productinfo setObject:self.CommoditySeason forKey:@"season_name"];
        }
        if (!kStringIsEmpty(self.StyleInformation) && ![self.StyleInformation containsString:@"null"]) {
            [productinfo setObject:self.StyleInformation forKey:@"style_name"];
        }
        
        if (!kStringIsEmpty(self.safetyStandards) && ![self.safetyStandards containsString:@"null"]) {
            [productinfo setObject:self.safetyStandards forKey:@"standard_name"];
        }
            
            if (!kStringIsEmpty(self.sv_executivestandard) && ![self.sv_executivestandard containsString:@"null"]) {
                [productinfo setObject:self.sv_executivestandard forKey:@"sv_executivestandard"];
            }
        
        [productinfo setObject:kStringIsEmpty(self.sv_brand_id) ? @"0":self.sv_brand_id forKey:@"sv_brand_id"];
        [productinfo setObject:kStringIsEmpty(self.sv_product_fabric_id) ? @"0":self.sv_product_fabric_id forKey:@"sv_product_fabric_id"];
        [productinfo setObject:kStringIsEmpty(self.sv_product_gender_id) ? @"0":self.sv_product_gender_id forKey:@"sv_product_gender_id"];

        [productinfo setObject:kStringIsEmpty(self.sv_product_season_id) ? @"0":self.sv_product_season_id forKey:@"sv_product_season_id"];
        [productinfo setObject:kStringIsEmpty(self.sv_product_style_id) ? @"0":self.sv_product_style_id forKey:@"sv_product_style_id"];
        [productinfo setObject:kStringIsEmpty(self.sv_product_standard_id) ? @"0":self.sv_product_standard_id forKey:@"sv_product_standard_id"];
            
        [productinfo setObject:kStringIsEmpty(self.sv_executivestandard_id) ? @"0":self.sv_executivestandard_id forKey:@"sv_executivestandard_id"];
        
        
        // 配送价
        [productinfo setObject:kStringIsEmpty(self.DeliveryPrice.text) ? @"0.00":self.DeliveryPrice.text forKey:@"sv_distributionprice"];
        // 最低价
        [productinfo setObject:kStringIsEmpty(self.minimumPrice.text) ? @"0.00":self.minimumPrice.text forKey:@"sv_p_minunitprice"];
        // 最低折
        [productinfo setObject:kStringIsEmpty(self.MinimumDiscount.text) ? @"0.00":self.MinimumDiscount.text forKey:@"sv_p_mindiscount"];
        
        //会员售价
        [productinfo setObject:kStringIsEmpty(self.memberPrice.text) ? @"0.00":self.memberPrice.text forKey:@"sv_p_memberprice"];
    
        
       // 处理新增的数据
        [productinfo setObject:kStringIsEmpty(self.memberPrice1.text) ? @"0.00":self.memberPrice1.text forKey:@"sv_p_memberprice1"];
        
        [productinfo setObject:kStringIsEmpty(self.memberPrice2.text) ? @"0.00":self.memberPrice2.text forKey:@"sv_p_memberprice2"];
        
        [productinfo setObject:kStringIsEmpty(self.memberPrice3.text) ? @"0.00":self.memberPrice3.text forKey:@"sv_p_memberprice3"];
        
        [productinfo setObject:kStringIsEmpty(self.memberPrice4.text) ? @"0.00":self.memberPrice4.text forKey:@"sv_p_memberprice4"];
        
        [productinfo setObject:kStringIsEmpty(self.memberPrice5.text) ? @"0.00":self.memberPrice5.text forKey:@"sv_p_memberprice5"];
        
        // 批发价 tradePrice
        [productinfo setObject:kStringIsEmpty(self.tradePrice.text) ? @"0.00":self.tradePrice.text forKey:@"sv_p_tradeprice1"];
        
        [productinfo setObject:kStringIsEmpty(self.tradePrice1.text) ? @"0.00":self.tradePrice1.text forKey:@"sv_p_tradeprice2"];
        
        [productinfo setObject:kStringIsEmpty(self.tradePrice2.text) ? @"0.00":self.tradePrice2.text forKey:@"sv_p_tradeprice3"];
        
        [productinfo setObject:kStringIsEmpty(self.tradePrice3.text) ? @"0.00":self.tradePrice3.text forKey:@"sv_p_tradeprice4"];
        
        [productinfo setObject:kStringIsEmpty(self.tradePrice4.text) ? @"0.00":self.tradePrice4.text forKey:@"sv_p_tradeprice5"];
        
        NSLog(@"productinfo = %@",productinfo);
                
            
            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:productinfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //解析数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"dict = %@",dict);
                if ([dict[@"code"] integerValue] == 1) {
                    [SVTool TextButtonAction:self.view withSing:@"修改成功"];
                    //用延迟来移除提示框
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                    if (self.editSuccessBlock) {
                        self.editSuccessBlock();
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"editSuccessPost" object:nil];
                   
                }else{
                    [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
                }
                
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            }];
            
            
            
        }else{
            
            if (kStringIsEmpty(self.borCodeTextFirld.text)) {
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }
                return;
            }
            if (kStringIsEmpty(self.nameText.text)) {
                [SVTool TextButtonAction:self.view withSing:@"名称不能为空"];
                return;
            }
            
            if (kStringIsEmpty(self.className.text)) {
                [SVTool TextButtonAction:self.view withSing:@"分类不能为空"];
                return;
            }
            
            if (kStringIsEmpty(self.salePriceText.text)) {
                [SVTool TextButtonAction:self.view withSing:@"售价不能为空"];
                return;
            }
            
//            if (kArrayIsEmpty(self.colorArray)) {
//                [SVTool TextButtonAction:self.view withSing:@"颜色不能为空"];
//                return;
//            }
//
//            if (kArrayIsEmpty(self.sizeTwoArray)) {
//                [SVTool TextButtonAction:self.view withSing:@"尺码不能为空"];
//                return;
//            }
            
            
            [self.bigArray removeAllObjects];
            NSMutableArray *colorArrayM = [NSMutableArray array];
            for (NSString *str in self.colorArray) {
                for (NSInteger i = 0; i < self.sizeTwoArray.count; i++) {
                    [colorArrayM addObject:str];
                }
            }
            
            for (NSInteger i = 0; i < self.colorArray.count; i++) {
                [self.bigArray addObjectsFromArray:self.sizeTwoArray];
            }
            
            
            
            NSLog(@"colorArrayM = %@",colorArrayM);// 颜色
            NSLog(@"self.bigArray = %@",self.bigArray); // 全部尺寸
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [SVUserManager loadUserInfo];
            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApi/RetailSpecProductAdd?key=%@&sv_p_source=300",[SVUserManager shareInstance].access_token];
            NSMutableDictionary *productinfo = [NSMutableDictionary dictionary];
            NSMutableArray *productCustomdDetailList = [NSMutableArray array];
            for (NSInteger i = 0; i < self.bigArray.count; i++) {
                SVDetailAttrilistModel *model = self.bigArray[i];
                NSMutableDictionary *productinfo_detail_one = [NSMutableDictionary dictionary];
                
                [productinfo_detail_one setObject:@"0" forKey:@"product_id"];
                if (kArrayIsEmpty(self.ItemNumberArray)) {
                  //  [productinfo_detail_one setObject:@"" forKey:@"sv_p_artno"];
                    [self.navigationItem.rightBarButtonItem setEnabled:YES];
                    return [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }else{
                    [productinfo_detail_one setObject:self.ItemNumberArray[i] forKey:@"sv_p_artno"];
                }
                
                
                [productinfo_detail_one setObject:kStringIsEmpty(self.imgURL)?@"":self.imgURL forKey:@"sv_p_images"];
                
                [productinfo_detail_one setObject:self.switch_isOn == 1? @"1" : @"0" forKey:@"sv_pricing_method"];
                
                if (kArrayIsEmpty(self.initialArray)) {
                    [productinfo_detail_one setObject:@"0" forKey:@"sv_p_storage"];
                }else{
                    [productinfo_detail_one setObject:self.initialArray[i] forKey:@"sv_p_storage"];
                    // [productinfo_detail_one setObject:self.ItemNumberArray[i] forKey:@"sv_p_artno"];
                }
                
                NSMutableArray *sv_cur_spec = [NSMutableArray array];
                // 设置颜色信息
                NSMutableDictionary *colorDic = [NSMutableDictionary dictionary];
                
                [colorDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.spec_id] forKey:@"spec_id"];
                
                [colorDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.spec_name] forKey:@"spec_name"];
                
                [colorDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.user_id] forKey:@"user_id"];
                
                [colorDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.industrytype_id] forKey:@"industrytype_id"];
                
                [colorDic setObject:self.oneModel.sv_is_multiplegroup == 1? @"true":@"false" forKey:@"sv_is_multiplegroup"];
                
                
                [colorDic setObject:@"" forKey:@"grouplist"];
                
                
                [colorDic setObject:self.oneModel.sv_is_publish == 1? @"true":@"false" forKey:@"sv_is_publish"];
                
                [colorDic setObject:self.oneModel.sv_is_activity == 1? @"true":@"false" forKey:@"sv_is_activity"];
                
                [colorDic setObject:self.oneModel.sv_canbe_uploadimages== 1? @"true":@"false" forKey:@"sv_canbe_uploadimages"];
                
                
                [colorDic setObject:@"true" forKey:@"effective"];
                
                
                [colorDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.sv_remark] forKey:@"sv_remark"];
                
                
                [colorDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.attri_group] forKey:@"attri_group"];
                
                
                [colorDic setObject:[NSString stringWithFormat:@"%ld",self.oneModel.sort] forKey:@"sort"];
                
                NSMutableArray *attrilist = [NSMutableArray array];
                NSMutableDictionary *attrilistDic = [NSMutableDictionary dictionary];
                
                [attrilistDic setObject:@"0" forKey:@"attri_id"];
                [attrilistDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.attri_group] forKey:@"attri_group"];
                
                [attrilistDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.spec_id] forKey:@"spec_id"];
                
                [attrilistDic setObject:@"" forKey:@"attri_code"];
                
                [attrilistDic setObject:colorArrayM[i] forKey:@"attri_name"];
                
                [attrilistDic setObject:[NSString stringWithFormat:@"%@",self.oneModel.sv_remark] forKey:@"sv_remark"];
                
                [attrilistDic setObject:@"false" forKey:@"is_custom"];
                
                [attrilistDic setObject:@"true" forKey:@"effective"];
                
                [attrilistDic setObject:@"" forKey:@"images_info"];
                
                [attrilistDic setObject:@"0" forKey:@"sort"];
                [attrilist addObject:attrilistDic];
                [colorDic setObject:attrilist forKey:@"attrilist"];
                
                
                
                // 尺码信息
                NSMutableDictionary *SizeInformationDic = [NSMutableDictionary dictionary];
                //  NSLog(@"self.twoModel.spec_name = %@",self.twoModel.spec_name);
                
                [SizeInformationDic setObject:[NSString stringWithFormat:@"%ld",self.twoModel.spec_id] forKey:@"spec_id"];
                //  NSLog(@"self.twoModel.spec_id = %ld",self.twoModel.spec_id);
                [SizeInformationDic setObject:@"尺码" forKey:@"spec_name"];
                
                [SizeInformationDic setObject:[NSString stringWithFormat:@"%ld",self.twoModel.user_id] forKey:@"user_id"];
                
                [SizeInformationDic setObject:self.twoModel.industrytype_id forKey:@"industrytype_id"];
                
                [SizeInformationDic setObject:self.twoModel.sv_is_multiplegroup == 1? @"true":@"false" forKey:@"sv_is_multiplegroup"];
                
                
                [SizeInformationDic setObject:@"" forKey:@"grouplist"];
                
                [SizeInformationDic setObject:self.twoModel.sv_is_publish == 1? @"true":@"false" forKey:@"sv_is_publish"];
                
                [SizeInformationDic setObject:self.twoModel.sv_is_activity == 1? @"true":@"false" forKey:@"sv_is_activity"];
                
                [SizeInformationDic setObject:self.twoModel.sv_canbe_uploadimages == 1? @"true":@"false" forKey:@"sv_canbe_uploadimages"];
                
                [SizeInformationDic setObject:@"true"forKey:@"effective"];
                
                [SizeInformationDic setObject:@"" forKey:@"sv_remark"];
                
                [SizeInformationDic setObject:self.twoModel.attri_group forKey:@"attri_group"];
                
                [SizeInformationDic setObject:[NSString stringWithFormat:@"%@",self.twoModel.sort] forKey:@"sort"];
                
                NSMutableArray *attrilist_array = [NSMutableArray array];
                NSMutableDictionary *attrilist_dic = [NSMutableDictionary dictionary];
                
                [attrilist_dic setObject:[NSString stringWithFormat:@"%ld",model.attri_id] forKey:@"attri_id"];
                
                [attrilist_dic setObject:[NSString stringWithFormat:@"%@",model.attri_group] forKey:@"attri_group"];
                
                [attrilist_dic setObject:[NSString stringWithFormat:@"%ld",model.spec_id] forKey:@"spec_id"];
                
                [attrilist_dic setObject:[NSString stringWithFormat:@"%@",model.attri_code] forKey:@"attri_code"];
                
                [attrilist_dic setObject:[NSString stringWithFormat:@"%@",model.attri_name] forKey:@"attri_name"];
                if (kStringIsEmpty(model.sv_remark)) {
                    [attrilist_dic setObject:@"" forKey:@"sv_remark"];
                }else{
                    [attrilist_dic setObject:[NSString stringWithFormat:@"%@",model.sv_remark] forKey:@"sv_remark"];
                }
                
                
                [attrilist_dic setObject:model.is_custom == 1? @"true":@"false" forKey:@"is_custom"];
                
                [attrilist_dic setObject:@"true" forKey:@"effective"];
                
                [attrilist_dic setObject: [NSString stringWithFormat:@"%@",model.images_info] forKey:@"images_info"];
                
                [attrilist_dic setObject:[NSString stringWithFormat:@"%@",model.sort] forKey:@"sort"];
                
                [attrilist_array addObject:attrilist_dic];
                
                [SizeInformationDic setObject:attrilist_array forKey:@"attrilist"];
                
                [sv_cur_spec addObject:colorDic];
                [sv_cur_spec addObject:SizeInformationDic];
                
                [productinfo_detail_one setObject:@"true" forKey:@"sv_is_newspec"];
                
                [productinfo_detail_one setObject:@"false" forKey:@"sv_is_active"];
                
                [productinfo_detail_one setObject:sv_cur_spec forKey:@"sv_cur_spec"];
                [productCustomdDetailList addObject:productinfo_detail_one];
            }
            
            [productinfo setObject:productCustomdDetailList forKey:@"productCustomdDetailList"];
            
            [productinfo setObject:@"0" forKey:@"product_id"];
            
            [productinfo setObject:[NSString stringWithFormat:@"%ld",self.productcategory_id] forKey:@"productcategory_id"];
            
            [productinfo setObject:[NSString stringWithFormat:@"%ld",self.productsubcategory_id] forKey:@"productsubcategory_id"];
            
            if (kArrayIsEmpty(self.initialArray)) {
                [productinfo setObject:kStringIsEmpty(self.sv_p_storageText.text)?@"0":self.sv_p_storageText.text forKey:@"sv_p_storage"];
            }
            
            [productinfo setObject:[NSString stringWithFormat:@"%ld",self.producttype_id] forKey:@"producttype_id"];
            if (kArrayIsEmpty(self.colorArray) || kArrayIsEmpty(self.sizeTwoArray)){
                [productinfo setObject:@"false" forKey:@"sv_is_newspec"];
                [productinfo setObject:@"false" forKey:@"sv_is_morespecs"];
            }else{
                [productinfo setObject:@"true" forKey:@"sv_is_newspec"];
                [productinfo setObject:@"true" forKey:@"sv_is_morespecs"];
            }
           
            NSMutableArray *sv_p_imagesArray = [NSMutableArray array];
            for (NSString *imageUrl in self.selectUploadingArray) {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                dictM[@"code"] = imageUrl;
                dictM[@"isdefault"] = @"true";
                [sv_p_imagesArray addObject:dictM];
            }
            
          //  [productinfo setObject:sv_p_images forKey:@"sv_p_images"];
            if (!kArrayIsEmpty(sv_p_imagesArray)) {
                NSString *sv_p_images = [self arrayToJSONString:sv_p_imagesArray];
                NSLog(@"sv_p_images = %@",sv_p_images);
                [productinfo setObject:sv_p_images forKey:@"sv_p_images"];
            }

            [productinfo setObject:@"" forKey:@"sv_mnemonic_code"];
            
            [productinfo setObject:self.borCodeTextFirld.text forKey:@"sv_p_barcode"];
            
           // [productinfo setObject:kStringIsEmpty(self.imgURL) ? @"": self.imgURL forKey:@"sv_p_images"];
            
            [productinfo setObject:self.nameText.text forKey:@"sv_p_name"];
            
            [productinfo setObject:kStringIsEmpty(self.purchasePriceText.text) ? @"0":self.purchasePriceText.text forKey:@"sv_p_originalprice"];
            
            [productinfo setObject:kStringIsEmpty(self.remarksText.text)?@"":self.remarksText.text forKey:@"sv_p_remark"];
            
            NSLog(@"self.companyLabel.text = %@",self.companyLabel.text);
            
            if (!kStringIsEmpty(self.sv_unit_name)) {
                [productinfo setObject:[self.sv_unit_name isEqualToString:@"单位选择"] ? @"":self.sv_unit_name forKey:@"sv_unit_name"];
            }
            
            if (!kStringIsEmpty(self.sv_suid)) {
                [productinfo setObject:self.sv_suid forKey:@"sv_suid"];
            }
            
            if (!kStringIsEmpty(self.company_id)) {
                [productinfo setObject:self.company_id forKey:@"sv_unit_id"];
            }
            
            [productinfo setObject:self.salePriceText.text forKey:@"sv_p_unitprice"];
           // [productinfo setObject:self.memberPriceText.text forKey:@"sv_p_memberprice"];// 会员价
            //  [productinfo setObject:@"0" forKey:@"sv_pricing_method"];
            [productinfo setObject:self.switch_isOn == 1? @"1" : @"0" forKey:@"sv_pricing_method"];
            [productinfo setObject:@"" forKey:@"sv_product_brand"];
            
            [productinfo setObject:kStringIsEmpty(self.purchasePriceText.text) ? @"0":self.purchasePriceText.text forKey:@"sv_purchaseprice"];
            
            if (!kStringIsEmpty(self.CommodityBrand)) {
                [productinfo setObject:self.CommodityBrand forKey:@"sv_brand_name"];
            }
            // 积分
            if (!kStringIsEmpty(self.sv_product_integral.text)) {
                [productinfo setObject:self.sv_product_integral.text forKey:@"sv_product_integral"];
            }
            
            // 提成数额
            if (!kStringIsEmpty(self.sv_p_commissionratio.text)) {
                [productinfo setObject:self.sv_p_commissionratio.text forKey:@"sv_p_commissionratio"];
            }
            // 提成元还是%
            if ([self.CommissionLabel.text isEqualToString:@"元"]) {
                [productinfo setObject:[NSNumber numberWithInteger:1] forKey:@"sv_p_commissiontype"];
            }else{
                [productinfo setObject:[NSNumber numberWithInteger:0] forKey:@"sv_p_commissiontype"];
            }
            
            if (!kStringIsEmpty(self.Fabric)) {
                [productinfo setObject:self.Fabric forKey:@"fabric_name"];
            }
            if (!kStringIsEmpty(self.Gender)) {
                [productinfo setObject:self.Gender forKey:@"gender_name"];
            }
            if (!kStringIsEmpty(self.CommodityYear)) {
                [productinfo setObject:self.CommodityYear forKey:@"sv_particular_year"];
            }
            if (!kStringIsEmpty(self.CommoditySeason)) {
                [productinfo setObject:self.CommoditySeason forKey:@"season_name"];
            }
            if (!kStringIsEmpty(self.StyleInformation)) {
                [productinfo setObject:self.StyleInformation forKey:@"style_name"];
            }
            
            if (!kStringIsEmpty(self.safetyStandards)) {
                [productinfo setObject:self.safetyStandards forKey:@"standard_name"];
            }
            
            if (!kStringIsEmpty(self.sv_executivestandard)) {
                [productinfo setObject:self.sv_executivestandard forKey:@"sv_executivestandard"];
            }
            
            [productinfo setObject:kStringIsEmpty(self.sv_brand_id) ? @"0":self.sv_brand_id forKey:@"sv_brand_id"];
            [productinfo setObject:kStringIsEmpty(self.sv_product_fabric_id) ? @"0":self.sv_product_fabric_id forKey:@"sv_product_fabric_id"];
            [productinfo setObject:kStringIsEmpty(self.sv_product_gender_id) ? @"0":self.sv_product_gender_id forKey:@"sv_product_gender_id"];
    
            [productinfo setObject:kStringIsEmpty(self.sv_product_season_id) ? @"0":self.sv_product_season_id forKey:@"sv_product_season_id"];
            [productinfo setObject:kStringIsEmpty(self.sv_product_style_id) ? @"0":self.sv_product_style_id forKey:@"sv_product_style_id"];
            [productinfo setObject:kStringIsEmpty(self.sv_product_standard_id) ? @"0":self.sv_product_standard_id forKey:@"sv_product_standard_id"];
            [productinfo setObject:kStringIsEmpty(self.sv_executivestandard_id) ? @"0":self.sv_executivestandard_id forKey:@"sv_executivestandard_id"];
            
            // 配送价
            [productinfo setObject:kStringIsEmpty(self.DeliveryPrice.text) ? @"0.00":self.DeliveryPrice.text forKey:@"sv_distributionprice"];
            // 最低价
            [productinfo setObject:kStringIsEmpty(self.minimumPrice.text) ? @"0.00":self.minimumPrice.text forKey:@"sv_p_minunitprice"];
            // 最低折
            [productinfo setObject:kStringIsEmpty(self.MinimumDiscount.text) ? @"0.00":self.MinimumDiscount.text forKey:@"sv_p_mindiscount"];
            
            //会员售价
            [productinfo setObject:kStringIsEmpty(self.memberPrice.text) ? @"0.00":self.memberPrice.text forKey:@"sv_p_memberprice"];
        
            
           // 处理新增的数据
            [productinfo setObject:kStringIsEmpty(self.memberPrice1.text) ? @"0.00":self.memberPrice1.text forKey:@"sv_p_memberprice1"];
            
            [productinfo setObject:kStringIsEmpty(self.memberPrice2.text) ? @"0.00":self.memberPrice2.text forKey:@"sv_p_memberprice2"];
            
            [productinfo setObject:kStringIsEmpty(self.memberPrice3.text) ? @"0.00":self.memberPrice3.text forKey:@"sv_p_memberprice3"];
            
            [productinfo setObject:kStringIsEmpty(self.memberPrice4.text) ? @"0.00":self.memberPrice4.text forKey:@"sv_p_memberprice4"];
            
            [productinfo setObject:kStringIsEmpty(self.memberPrice5.text) ? @"0.00":self.memberPrice5.text forKey:@"sv_p_memberprice5"];
            
            
            // 批发价 tradePrice
            [productinfo setObject:kStringIsEmpty(self.tradePrice.text) ? @"0.00":self.tradePrice.text forKey:@"sv_p_tradeprice1"];
            
            [productinfo setObject:kStringIsEmpty(self.tradePrice1.text) ? @"0.00":self.tradePrice1.text forKey:@"sv_p_tradeprice2"];
            
            [productinfo setObject:kStringIsEmpty(self.tradePrice2.text) ? @"0.00":self.tradePrice2.text forKey:@"sv_p_tradeprice3"];
            
            [productinfo setObject:kStringIsEmpty(self.tradePrice3.text) ? @"0.00":self.tradePrice3.text forKey:@"sv_p_tradeprice4"];
            
            [productinfo setObject:kStringIsEmpty(self.tradePrice4.text) ? @"0.00":self.tradePrice4.text forKey:@"sv_p_tradeprice5"];
            
            NSLog(@"productinfo = %@",productinfo);
            
            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:productinfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //解析数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"dict = %@",dict);
                if ([dict[@"code"] integerValue] == 1) {
                    [SVTool TextButtonAction:self.view withSing:@"新增成功"];
                    //用延迟来移除提示框
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@",dict[@"msg"]]];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"editSuccessPost" object:nil];
                
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.navigationItem.rightBarButtonItem setEnabled:YES];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            }];
        }
  //  }
}

//数组转为json字符串
- (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@"\\" withString:@""];
      NSString *jsonResult2 = [jsonResult stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonResult2;
}

- (void)addLoadData{
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetAutomaticallyGenerateMemberId?key=%@&plusone=true",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        // NSLog(@"dict款号 = %@",dict);
        
        if ([dict[@"succeed"] integerValue] == 1) {
            self.borCodeTextFirld.text = dict[@"values"];
            // self.barcode = self.oneCell.barcode.text;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 加载单位的旧接口
- (void)loadCompanyData{
    // [self.pickViewArr removeAllObjects];
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user/getUserconfig?key=%@",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *a,*b,*c,*d;
        if ([dict[@"succeed"]integerValue]==1) {
            a=[[dict objectForKey:@"values"]objectForKey:@"sv_uc_unit"];
            b=[a stringByReplacingOccurrencesOfString:@"[" withString:@""];
            c=[b stringByReplacingOccurrencesOfString:@"]" withString:@""];
            d=[c stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            //            for (NSString *str in a) {
            //                [self.pickViewArr addObject:str];
            //            }
            NSArray *strArr=[d componentsSeparatedByString:@","];
            [self.pickViewArr addObjectsFromArray:strArr];
            //                        [self.supplierPcikerView reloadAllComponents];
            //
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 扫码按钮

- (IBAction)saomaClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name) {
//        //提示加载中
//        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
//        [SVUserManager loadUserInfo];
//        NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetGoodsInfoByBarcode?key=%@&barcode=%@",[SVUserManager shareInstance].access_token,name];
//        [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"444dic = %@",dic);
//            NSDictionary *dic55 = dic[@"values"];
//            if (kDictIsEmpty(dic55)) {
//                weakSelf.borCodeTextFirld.text = name;
//                weakSelf.barcode = name;
//            }else{
//                NSString *name_text = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_goods_name"]];
//                if (![SVTool isBlankString:name_text]) {
//                    self.nameText.text = name_text;
//                }
//                NSString *probarcodelib_barcode = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_barcode"]];
//                if (![SVTool isBlankString:probarcodelib_barcode]) {
//                    self.borCodeTextFirld.text = probarcodelib_barcode;
//                }
//
//                NSString *probarcodelib_price = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_price"]];
//                if (![SVTool isBlankString:probarcodelib_price]) {
//                    self.salePriceText.text = probarcodelib_price;
//                }
//
//                NSLog(@"dic = %@",dic);
//            }
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        }];
//
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        // weakSelf.borCodeTextFirld.text = number;
//    };
//
    
    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetGoodsInfoByBarcode?key=%@&barcode=%@",[SVUserManager shareInstance].access_token,resultStr];
        [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"444dic = %@",dic);
            NSDictionary *dic55 = dic[@"values"];
            if (kDictIsEmpty(dic55)) {
                weakSelf.borCodeTextFirld.text = resultStr;
                weakSelf.barcode = resultStr;
            }else{
                NSString *name_text = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_goods_name"]];
                if (![SVTool isBlankString:name_text]) {
                    self.nameText.text = name_text;
                }
                NSString *probarcodelib_barcode = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_barcode"]];
                if (![SVTool isBlankString:probarcodelib_barcode]) {
                    self.borCodeTextFirld.text = probarcodelib_barcode;
                }
                
                NSString *probarcodelib_price = [NSString stringWithFormat:@"%@",dic[@"values"][@"probarcodelib_price"]];
                if (![SVTool isBlankString:probarcodelib_price]) {
                    self.salePriceText.text = probarcodelib_price;
                }
                
                NSLog(@"dic = %@",dic);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // weakSelf.borCodeTextFirld.text = number;
    };
//        self.hidesBottomBarWhenPushed=YES;
              //跳转界面有导航栏的
      // [self.navigationController pushViewController:vc animated:YES];
    
    //设置点击时的背影色
    [self.saoBtn setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.saoBtn setBackgroundColor:[UIColor clearColor]];
        
        [self.navigationController pushViewController:vc animated:YES];
    });
}






#pragma mark - 上传图片
- (void)uploadPictureViewResponseEvent{
    ///**
    // *  弹出提示框
    // */
    ////初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 点击分类
- (void)classificationViewResponseEvent{
    self.hidesBottomBarWhenPushed = YES;
    SVWaresClassVC *VC = [[SVWaresClassVC alloc]init];
    
    //对象有一个Block属性，然而这个Block属性中又引用了对象的其他成员变量，那么就会对这个变量本身产生强引用，那么变量本身和他自己的Block属性就形成了循环引用。因此我们需要对其进行处理进行弱引用。
    __weak typeof(self) weakSelf = self;
    VC.nameBlock = ^(NSString *name,NSString *productcategory_id,NSString *productsubcategory_id,NSString *producttype_id) {
        //        //把回调回来的二级分类名用全局属性保存
        weakSelf.className.text = name;
        
        weakSelf.productcategory_id = [productcategory_id integerValue];
        
        weakSelf.productsubcategory_id = [productsubcategory_id integerValue];
        
        weakSelf.producttype_id = [producttype_id integerValue];
        //
        //        [weakSelf.tableView reloadData];
        
    };
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - 颜色
- (void)colorViewResponseEvent{
    //    if (self.editInterface == 1) {
    //   self.sizeView.userInteractionEnabled = NO;
    SVMoreColorVC *vc = [[SVMoreColorVC alloc]init];
    vc.editInterface = self.editInterface;
    if (self.editInterface == 1) {
        if (!kArrayIsEmpty(self.allColorArray)) {
            vc.colorArray = self.allColorArray;
            vc.firstColorArray = self.firstColorArray;
            
        }
    }else{
        if (!kArrayIsEmpty(self.colorArray)) {
            vc.colorArray = self.colorArray;
            // vc.firstColorArray = self.firstColorArray;
            
        }
    }
    
    vc.view.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    vc.delegate = self;
    if (version < 8.0) { // iOS 7 实现的方式略有不同(设置self)
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        // iOS8以下必须使用rootViewController,否则背景会变黑
        [self.view.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    } else { // iOS 8 以上实现（设置vc）
        
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        //如果控制器属于navigationcontroller或者tababrControlelr子控制器,不使用UIModalPresentationFullScreen 的话, bar 会盖住你的modal出来的控制器
        [self presentViewController:vc animated:YES completion:^{
            // 也可以在这里做一些完成modal后需要做得事情
        }];
    }
    
}

#pragma mark - 点击颜色的代理方法
- (void)colorArrayClick:(NSMutableArray *)array
{
    if (self.editInterface == 1) {
        self.allColorArray = array;

        [self.editDictArray removeAllObjects];
        for (NSString *color in self.allColorArray) {
            for (NSString *sizeStr in self.sizeStrArray) {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                [dictM setValue:color forKey:@"color"];
                [dictM setValue:sizeStr forKey:@"sizeStr"];
                [dictM setValue:@"" forKey:@"sv_p_artno"];
                [dictM setValue:@"0" forKey:@"sv_p_storage"];
                [self.editDictArray addObject:dictM];
            }
            }

        
        [self.colorHeight_View.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSLog(@"array = %@",array);
        if (kArrayIsEmpty(array)) {
            self.colorHeight.constant = 1;
            self.big_color_height.constant = 224;
            
        }else{
            CGFloat tagBtnX = 16;
            CGFloat tagBtnY = 0;
            
            for (int i= 0; i<array.count; i++) {
                
                CGSize tagTextSize = [array[i] sizeWithFont:GlobalFont(12) maxSize:CGSizeMake(self.colorHeight_View.width-32-32, 30)];
                if (tagBtnX+tagTextSize.width+30 > self.colorHeight_View.width-32) {
                    
                    tagBtnX = 16;
                    tagBtnY += 30+15;
                }
                UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                tagBtn.tag = i;
                tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
                [tagBtn setTitle:array[i] forState:UIControlStateNormal];
                [tagBtn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
                [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                CAShapeLayer *border = [CAShapeLayer layer];
                
                //虚线的颜色
                border.strokeColor = [UIColor orangeColor].CGColor;
                //填充的颜色
                border.fillColor = [UIColor clearColor].CGColor;
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tagBtn.bounds cornerRadius:5];
                
                //设置路径
                border.path = path.CGPath;
                
                border.frame = tagBtn.bounds;
                //虚线的宽度
                border.lineWidth = 1.f;
                //虚线的间隔
                border.lineDashPattern = @[@4, @2];
                
                tagBtn.layer.cornerRadius = 5.f;
                tagBtn.layer.masksToBounds = YES;
                
                [tagBtn.layer addSublayer:border];
                
                
                [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.colorHeight_View addSubview:tagBtn];
                
                tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
                
                self.colorHeight.constant = tagBtnY + 30;
                self.big_color_height.constant = 224+self.colorHeight.constant+ self.sizeHeight.constant;
            }
            
        }
    }else{
        self.colorArray = array;
        
        [self.colorHeight_View.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSLog(@"array = %@",array);
        if (kArrayIsEmpty(array)) {
            self.colorHeight.constant = 1;
            self.big_color_height.constant = 224;
            
        }else{
            CGFloat tagBtnX = 16;
            CGFloat tagBtnY = 0;
            
            for (int i= 0; i<array.count; i++) {
                
                CGSize tagTextSize = [array[i] sizeWithFont:GlobalFont(12) maxSize:CGSizeMake(self.colorHeight_View.width-32-32, 30)];
                if (tagBtnX+tagTextSize.width+30 > self.colorHeight_View.width-32) {
                    
                    tagBtnX = 16;
                    tagBtnY += 30+15;
                }
                UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                tagBtn.tag = i;
                tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
                [tagBtn setTitle:array[i] forState:UIControlStateNormal];
                [tagBtn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
                [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                CAShapeLayer *border = [CAShapeLayer layer];
                
                //虚线的颜色
                border.strokeColor = [UIColor orangeColor].CGColor;
                //填充的颜色
                border.fillColor = [UIColor clearColor].CGColor;
                
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tagBtn.bounds cornerRadius:5];
                
                //设置路径
                border.path = path.CGPath;
                
                border.frame = tagBtn.bounds;
                //虚线的宽度
                border.lineWidth = 1.f;
                //虚线的间隔
                border.lineDashPattern = @[@4, @2];
                
                tagBtn.layer.cornerRadius = 5.f;
                tagBtn.layer.masksToBounds = YES;
                
                [tagBtn.layer addSublayer:border];
                
                
                [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.colorHeight_View addSubview:tagBtn];
                
                tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
                
                self.colorHeight.constant = tagBtnY + 30;
                self.big_color_height.constant = 224+self.colorHeight.constant+ self.sizeHeight.constant;
            }
            
        }
    }
    
}

- (void)tagBtnClick:(UIButton *)btn{
    
}

- (NSArray *)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];//得到两个数组中不同的数据
    NSArray * reslutFilteredArray = [arr2 filteredArrayUsingPredicate:filterPredicate];
    if (reslutFilteredArray.count > 0){
        return reslutFilteredArray;
        
    }
    return nil;
    
}


#pragma mark - 尺寸
- (void)sizeViewResponseEvent{
    if (self.editInterface == 1) {
        self.hidesBottomBarWhenPushed = YES;
        SVSetDimensionsVC *setDimensionsVC = [[SVSetDimensionsVC alloc] init];
        setDimensionsVC.selectIndex = self.selectIndex;
        setDimensionsVC.editInterface = self.editInterface;
        if (!kArrayIsEmpty(self.sizeTwoArray)) {
            setDimensionsVC.sizeTwoArray = self.sizeTwoArray;
            setDimensionsVC.attri_group = self.attri_group;
            setDimensionsVC.firstSizeArray = self.firstSizeArray;
            
        }
        
        [self.navigationController pushViewController:setDimensionsVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
        __weak typeof(self) weakSelf = self;
        
        setDimensionsVC.selectArrayBlock = ^(NSMutableArray * _Nonnull array, NSInteger selectIndex, SVColorOneModel * _Nonnull oneModel, SVSizeTwoModel * _Nonnull twoModel, NSString * _Nonnull spec_name) {
            
            NSMutableArray *detailArray = [NSMutableArray array];
            for (SVDetailAttrilistModel *detailmodel in array) {
                [detailArray addObject:detailmodel.attri_name];
            }
            
            weakSelf.sizeStrArray = detailArray;
            
            weakSelf.spec_name = spec_name;
            weakSelf.selectIndex = selectIndex;
            weakSelf.twoModel = twoModel;
            weakSelf.oneModel = oneModel;
            weakSelf.sizeTwoArray = array;
            
            
            [self.editDictArray removeAllObjects];
                   for (NSString *color in self.allColorArray) {
                       for (NSString *sizeStr in self.sizeStrArray) {
                           NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                           [dictM setValue:color forKey:@"color"];
                           [dictM setValue:sizeStr forKey:@"sizeStr"];
                           [dictM setValue:@"" forKey:@"sv_p_artno"];
                           [dictM setValue:@"0" forKey:@"sv_p_storage"];
                           [self.editDictArray addObject:dictM];
                       }
            }
            

            [weakSelf.sizeHeight_View.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            if (kArrayIsEmpty(weakSelf.sizeTwoArray)) {
                weakSelf.sizeHeight.constant = 1;
                weakSelf.big_color_height.constant = 224 + weakSelf.colorHeight.constant + 1;
            }else{
                CGFloat tagBtnX = 16;
                CGFloat tagBtnY = 0;
                
                for (int i= 0; i<weakSelf.sizeTwoArray.count; i++) {
                    SVDetailAttrilistModel *model = weakSelf.sizeTwoArray[i];
                    CGSize tagTextSize = [model.attri_name sizeWithFont:GlobalFont(12) maxSize:CGSizeMake(weakSelf.sizeHeight_View.width-32-32, 30)];
                    if (tagBtnX+tagTextSize.width+30 > weakSelf.sizeHeight_View.width-32) {
                        
                        tagBtnX = 16;
                        tagBtnY += 30+15;
                    }
                    UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    tagBtn.tag = i;
                    tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
                    [tagBtn setTitle:model.attri_name forState:UIControlStateNormal];
                    [tagBtn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
                    [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    
                    CAShapeLayer *border = [CAShapeLayer layer];
                    
                    //虚线的颜色
                    border.strokeColor = [UIColor orangeColor].CGColor;
                    //填充的颜色
                    border.fillColor = [UIColor clearColor].CGColor;
                    
                    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tagBtn.bounds cornerRadius:5];
                    
                    //设置路径
                    border.path = path.CGPath;
                    
                    border.frame = tagBtn.bounds;
                    //虚线的宽度
                    border.lineWidth = 1.f;
                    //虚线的间隔
                    border.lineDashPattern = @[@4, @2];
                    
                    tagBtn.layer.cornerRadius = 5.f;
                    tagBtn.layer.masksToBounds = YES;
                    
                    [tagBtn.layer addSublayer:border];
                    
                    
                    [tagBtn addTarget:weakSelf action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [weakSelf.sizeHeight_View addSubview:tagBtn];
                    
                    tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
                    
                    weakSelf.sizeHeight.constant = tagBtnY + 30;
                    weakSelf.big_color_height.constant = 224+weakSelf.colorHeight.constant + weakSelf.sizeHeight.constant;
                }
            }
        };
    }else{
        self.hidesBottomBarWhenPushed = YES;
        SVSetDimensionsVC *setDimensionsVC = [[SVSetDimensionsVC alloc] init];
        setDimensionsVC.selectIndex = self.selectIndex;
        if (!kArrayIsEmpty(self.sizeTwoArray)) {
            setDimensionsVC.sizeTwoArray = self.sizeTwoArray;
            setDimensionsVC.attri_group = self.attri_group;
            setDimensionsVC.firstSizeArray = self.firstSizeArray;
            
        }
        
        
        [self.navigationController pushViewController:setDimensionsVC animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
        __weak typeof(self) weakSelf = self;
        
        setDimensionsVC.selectArrayBlock = ^(NSMutableArray * _Nonnull array, NSInteger selectIndex, SVColorOneModel * _Nonnull oneModel, SVSizeTwoModel * _Nonnull twoModel, NSString * _Nonnull spec_name) {
            //    NSLog(@"weakSelf.twoModel.spec_name = %@",weakSelf.twoModel.spec_name);
            weakSelf.attri_group = spec_name; // 特殊的命名
            weakSelf.spec_name = spec_name;
            weakSelf.selectIndex = selectIndex;
            weakSelf.twoModel = twoModel;
            weakSelf.oneModel = oneModel;
            weakSelf.sizeTwoArray = array;
            [weakSelf.sizeHeight_View.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            if (kArrayIsEmpty(weakSelf.sizeTwoArray)) {
                weakSelf.sizeHeight.constant = 1;
                weakSelf.big_color_height.constant = 224 + weakSelf.colorHeight.constant + 1;
            }else{
                CGFloat tagBtnX = 16;
                CGFloat tagBtnY = 0;
                
                for (int i= 0; i<weakSelf.sizeTwoArray.count; i++) {
                    SVDetailAttrilistModel *model = weakSelf.sizeTwoArray[i];
                    CGSize tagTextSize = [model.attri_name sizeWithFont:GlobalFont(12) maxSize:CGSizeMake(weakSelf.sizeHeight_View.width-32-32, 30)];
                    if (tagBtnX+tagTextSize.width+30 > weakSelf.sizeHeight_View.width-32) {
                        
                        tagBtnX = 16;
                        tagBtnY += 30+15;
                    }
                    UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    tagBtn.tag = i;
                    tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
                    [tagBtn setTitle:model.attri_name forState:UIControlStateNormal];
                    [tagBtn setTitleColor: [UIColor orangeColor] forState:UIControlStateNormal];
                    [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                    
                    CAShapeLayer *border = [CAShapeLayer layer];
                    
                    //虚线的颜色
                    border.strokeColor = [UIColor orangeColor].CGColor;
                    //填充的颜色
                    border.fillColor = [UIColor clearColor].CGColor;
                    
                    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tagBtn.bounds cornerRadius:5];
                    
                    //设置路径
                    border.path = path.CGPath;
                    
                    border.frame = tagBtn.bounds;
                    //虚线的宽度
                    border.lineWidth = 1.f;
                    //虚线的间隔
                    border.lineDashPattern = @[@4, @2];
                    
                    tagBtn.layer.cornerRadius = 5.f;
                    tagBtn.layer.masksToBounds = YES;
                    
                    [tagBtn.layer addSublayer:border];
                    
                    
                    [tagBtn addTarget:weakSelf action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [weakSelf.sizeHeight_View addSubview:tagBtn];
                    
                    tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
                    
                    weakSelf.sizeHeight.constant = tagBtnY + 30;
                    weakSelf.big_color_height.constant = 224+weakSelf.colorHeight.constant + weakSelf.sizeHeight.constant;
                }
            }
        };
    }
    
    
}


#pragma mark -- 将数组拆分成固定长度

/**
 *  将数组拆分成固定长度的子数组
 *
 *  @param array 需要拆分的数组
 *
 *  @param subSize 指定长度
 *
 */
- (NSMutableArray *)splitArray: (NSMutableArray *)array withSubSize : (NSInteger)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [NSMutableArray array];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (NSInteger i = 0; i < count; i ++) {
        //数组下标
        NSInteger index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [NSMutableArray array];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        NSInteger j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
    
}



#pragma mark - 条码
- (void)itemNumberViewResponseEvent{
    if (self.editInterface == 1) {
        if (kArrayIsEmpty(self.colorArray)) {
            [SVTool TextButtonAction:self.view withSing:@"颜色不能为空"];
        }else if (kArrayIsEmpty(self.sizeTwoArray)){
            [SVTool TextButtonAction:self.view withSing:@"尺码不能为空"];
        }else if (kStringIsEmpty(self.borCodeTextFirld.text)){
            [SVUserManager loadUserInfo];
            if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
            }else{
                [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
            }
        }else{
            
            self.itemNumberLabel.text = @"修改";
            
            NSMutableArray *arraydata = [NSMutableArray array];
            NSMutableArray *arraydataResult = [NSMutableArray array];
            NSMutableArray *arraydataResult2 = [NSMutableArray array];
            for (NSDictionary *dict in self.editDictArray) {
                for (SVduoguigeModel *duoguigeModel in self.duoguigeArray) {
                    //  SVduoguigeModel *duoguigeModel = weakSelf.duoguigeArray[index];
                    NSString *color = dict[@"color"];
                    NSString *sizeStr = dict[@"sizeStr"];
                    // 尺码
                    SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
                    SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
                    //  [weakSelf.firstSpecsDiffArray addObject:atteilistModel2.attri_name];
                    //  self.spec_name_two = specModel2.spec_name;
                    // 颜色的
                    SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
                    SVAtteilistModel *attriModel = specModel.attrilist.firstObject;
                    if ([atteilistModel2.attri_name isEqualToString:sizeStr] && [attriModel.attri_name isEqualToString:color]) {
                        [arraydataResult addObject:duoguigeModel];
                        [arraydata addObject:dict];
                        
                    }
                }
            }
            
            NSLog(@"arraydata = %@",arraydata);
            NSLog(@"arraydataResult = %@",arraydataResult);
            
            NSArray *diffArray = [self filterArr:arraydata andArr2:self.editDictArray];
            NSLog(@"diffArray = %@",diffArray);
            [arraydataResult2 addObjectsFromArray:arraydataResult];
            if (!kArrayIsEmpty(diffArray)) {
                [arraydataResult2 addObjectsFromArray:diffArray];
            }
            
            NSLog(@"arraydataResult2 = %@",arraydataResult2);
            
            self.hidesBottomBarWhenPushed = YES;
            SVSetNumberVC *setNumberVC = [[SVSetNumberVC alloc] init];
            setNumberVC.arraydataResult2 = arraydataResult2;
          //  setNumberVC.colorArray = self.colorArray; // 颜色
            setNumberVC.editInterface = self.editInterface;
            setNumberVC.borcodeStr = self.borCodeTextFirld.text;

            [self.navigationController pushViewController:setNumberVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            
            setNumberVC.textArrayBlock = ^(NSMutableArray * _Nonnull array) {
                
                for (int i = 0; i < arraydataResult2.count; i++) {
                    if ([arraydataResult2[i] isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dictM = arraydataResult2[i];
                        dictM[@"sv_p_artno"] = array[i];
                    }else{
                         SVduoguigeModel *duoguigeModel = arraydataResult2[i];
                        duoguigeModel.sv_p_artno = array[i];
                    }
              //  _ItemNumberArray = array;
             //   NSLog(@"_ItemNumberArray = %@",_ItemNumberArray);
                
                }
            };
        }
    }else{
        if (kArrayIsEmpty(self.colorArray) && !kArrayIsEmpty(self.sizeTwoArray)) {
            if (kStringIsEmpty(self.borCodeTextFirld.text)){
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }
            }else{
                [SVTool TextButtonAction:self.view withSing:@"不能单选尺码"];
                
            }
        }else if (!kArrayIsEmpty(self.colorArray) && kArrayIsEmpty(self.sizeTwoArray)){
            if (kStringIsEmpty(self.borCodeTextFirld.text)){
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }
            }else{
                [SVTool TextButtonAction:self.view withSing:@"不能单选颜色"];
            }
            
        }else if (!kArrayIsEmpty(self.colorArray) && !kArrayIsEmpty(self.sizeTwoArray)){
            if (kStringIsEmpty(self.borCodeTextFirld.text)){
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }
            }else{
                //   [SVTool TextButtonAction:self.view withSing:@"不能单选尺码"];
                self.itemNumberLabel.text = @"修改";
                self.hidesBottomBarWhenPushed = YES;
                SVSetNumberVC *setNumberVC = [[SVSetNumberVC alloc] init];
                setNumberVC.colorArray = self.colorArray;
                NSMutableArray *bigArray = [NSMutableArray array];
                for (NSInteger i = 0; i < self.colorArray.count; i++) {
                    [bigArray addObjectsFromArray:self.sizeTwoArray];
                }
                NSLog(@"bigArray = %@",bigArray);
                
                setNumberVC.borcodeStr = self.borCodeTextFirld.text;
                setNumberVC.sizeArray = bigArray;
                setNumberVC.numberArray = self.sizeTwoArray;
                setNumberVC.ItemNumberArray = self.ItemNumberArray;
                NSLog(@"self.sizeArray.count = %ld, self.sizeArray = %@",self.sizeTwoArray.count, self.sizeTwoArray);
                
                [self.navigationController pushViewController:setNumberVC animated:YES];
                self.hidesBottomBarWhenPushed = YES;
                
                setNumberVC.textArrayBlock = ^(NSMutableArray * _Nonnull array) {
                    
                    _ItemNumberArray = array;
                    NSLog(@"_ItemNumberArray = %@",_ItemNumberArray);
                    
                    
                };
            }
        }else{
            __weak typeof(self) weakSelf = self;
            ZYInputAlertView *alertView = [ZYInputAlertView alertView];
            alertView.confirmBgColor = navigationBackgroundColor;
            // alertView.inputTextView.text = @"输入开心的事儿···";
            alertView.colorLabel.text = @"输入条码";
            alertView.placeholder = @"输入条码";
            alertView.inputTextView.keyboardType = UIKeyboardTypeDefault;
            alertView.textfieldStrBlock = ^(NSString *str) {
                weakSelf.itemNumberLabel.text = str;
                weakSelf.ItemNumberStr = str;
                //                [weakSelf.tagArray removeObjectAtIndex:weakSelf.tagArray.count - 1];
                //                [weakSelf.tagArray addObject:str];
                //                [weakSelf.tagArray addObject:@"新增颜色"];
                //                [[weakSelf.colorView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                //                [weakSelf createUI];
            };
            
            [alertView show];
            
        }
        
    }
    
}

#pragma mark - 库存
- (void)stockViewResponseEvent{
    if (self.editInterface == 1) {
        if (kArrayIsEmpty(self.colorArray)) {
            [SVTool TextButtonAction:self.view withSing:@"颜色不能为空"];
        }else if (kArrayIsEmpty(self.sizeTwoArray)){
            [SVTool TextButtonAction:self.view withSing:@"尺码不能为空"];
        }else{
            
            self.hidesBottomBarWhenPushed = YES;
            self.initalLabel.text = @"修改";
            //  NSMutableArray *bigArray = [NSMutableArray array];
            
            NSMutableArray *arraydata = [NSMutableArray array];
            NSMutableArray *arraydataResult = [NSMutableArray array];
            NSMutableArray *arraydataResult2 = [NSMutableArray array];
            for (NSDictionary *dict in self.editDictArray) {
                for (SVduoguigeModel *duoguigeModel in self.duoguigeArray) {
                    //  SVduoguigeModel *duoguigeModel = weakSelf.duoguigeArray[index];
                    NSString *color = dict[@"color"];
                    NSString *sizeStr = dict[@"sizeStr"];
                    // 尺码
                    SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
                    SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
                    //  [weakSelf.firstSpecsDiffArray addObject:atteilistModel2.attri_name];
                    //  self.spec_name_two = specModel2.spec_name;
                    // 颜色的
                    SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
                    SVAtteilistModel *attriModel = specModel.attrilist.firstObject;
                    // [weakSelf.threeColorArray addObject:attriModel.attri_name];
                    
                    if ([atteilistModel2.attri_name isEqualToString:sizeStr] && [attriModel.attri_name isEqualToString:color]) {
                        [arraydataResult addObject:duoguigeModel];
                        [arraydata addObject:dict];
                        
                    }
                }
            }
            
            NSLog(@"arraydata = %@",arraydata);
            NSLog(@"arraydataResult = %@",arraydataResult);
            
            NSArray *diffArray = [self filterArr:arraydata andArr2:self.editDictArray];
            NSLog(@"diffArray = %@",diffArray);
            [arraydataResult2 addObjectsFromArray:arraydataResult];
            [arraydataResult2 addObjectsFromArray:diffArray];
            NSLog(@"arraydataResult2 = %@",arraydataResult2);
            self.hidesBottomBarWhenPushed = YES;
            SVInitialInventoryVC *initialInventoryVC = [[SVInitialInventoryVC alloc] init];
           // initialInventoryVC.colorArray = self.colorArray;
            initialInventoryVC.editInterface = self.editInterface;
            initialInventoryVC.arraydataResult2 = arraydataResult2;
//            initialInventoryVC.sizeArray = self.storageDiffArray;
//            initialInventoryVC.numberArray = self.sizeTwoArray;
//            initialInventoryVC.specsDiffArray = self.specsDiffArray;
            // SVInitialInventoryVC *vc = [[SVInitialInventoryVC alloc] init];
            [self.navigationController pushViewController:initialInventoryVC animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            
            initialInventoryVC.stockBlock = ^(NSMutableArray * _Nonnull array) {
             //   self.initialArray = array;
                
                for (int i = 0; i < arraydataResult2.count; i++) {
                    if ([arraydataResult2[i] isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dictM = arraydataResult2[i];
                        dictM[@"sv_p_storage"] = array[i];
                    }else{
                        SVduoguigeModel *duoguigeModel = arraydataResult2[i];
                        duoguigeModel.sv_p_storage = array[i];
                    }
                            //  _ItemNumberArray = array;
                           //   NSLog(@"_ItemNumberArray = %@",_ItemNumberArray);
                              
            }
                
            };
        }
    }else{
        
        if (kArrayIsEmpty(self.colorArray) && !kArrayIsEmpty(self.sizeTwoArray)) {
            if (kStringIsEmpty(self.borCodeTextFirld.text)){
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }
            }else{
                [SVTool TextButtonAction:self.view withSing:@"不能单选尺码"];
                
            }
        }else if (!kArrayIsEmpty(self.colorArray) && kArrayIsEmpty(self.sizeTwoArray)){
            if (kStringIsEmpty(self.borCodeTextFirld.text)){
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }
            }else{
                [SVTool TextButtonAction:self.view withSing:@"不能单选颜色"];
            }
            
        }else if (!kArrayIsEmpty(self.colorArray) && !kArrayIsEmpty(self.sizeTwoArray)){
            if (kStringIsEmpty(self.borCodeTextFirld.text)){
                [SVUserManager loadUserInfo];
                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
                    [SVTool TextButtonAction:self.view withSing:@"款号不能为空"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:@"条码不能为空"];
                }
            }else{
                
                self.hidesBottomBarWhenPushed = YES;
                self.initalLabel.text = @"修改";
                NSMutableArray *bigArray = [NSMutableArray array];
                self.hidesBottomBarWhenPushed = YES;
                SVInitialInventoryVC *initialInventoryVC = [[SVInitialInventoryVC alloc] init];
                initialInventoryVC.colorArray = self.colorArray;
                for (NSInteger i = 0; i < self.colorArray.count; i++) {
                    [bigArray addObjectsFromArray:self.sizeTwoArray];
                }
                // setNumberVC.borcodeStr = self.borCodeTextFirld.text;
                initialInventoryVC.sizeArray = bigArray;
                initialInventoryVC.numberArray = self.sizeTwoArray;
                
                // SVInitialInventoryVC *vc = [[SVInitialInventoryVC alloc] init];
                [self.navigationController pushViewController:initialInventoryVC animated:YES];
                self.hidesBottomBarWhenPushed = YES;
                
                initialInventoryVC.stockBlock = ^(NSMutableArray * _Nonnull array) {
                    self.initialArray = array;
                    
                };
            }
        }else{
//            __weak typeof(self) weakSelf = self;
//            ZYInputAlertView *alertView = [ZYInputAlertView alertView];
//            alertView.confirmBgColor = navigationBackgroundColor;
//            // alertView.inputTextView.text = @"输入开心的事儿···";
//            alertView.colorLabel.text = @"输入库存";
//            alertView.placeholder = @"输入库存";
//            alertView.inputTextView.keyboardType = UIKeyboardTypeDecimalPad;
//            alertView.textfieldStrBlock = ^(NSString *str) {
//                weakSelf.initalLabel.text = str;
//                weakSelf.InitialInventoryStr = str;
//                //                [weakSelf.tagArray removeObjectAtIndex:weakSelf.tagArray.count - 1];
//                //                [weakSelf.tagArray addObject:str];
//                //                [weakSelf.tagArray addObject:@"新增颜色"];
//                //                [[weakSelf.colorView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//                //                [weakSelf createUI];
//            };
//
//            [alertView show];
            [SVTool TextButtonAction:self.view withSing:@"颜色和尺码不能为空"];
            
        }
        
    }
    
    
}


-(UIImage *)oldIMG{
    _oldIMG = (_oldIMG)?_oldIMG:[UIImage imageNamed:@"test.png"];
    return _oldIMG;
}


-(UIImageView *)OldIMGV{
    if(!_OldIMGV){
        _OldIMGV = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                64,
                                                                kScreenWidth,
                                                                (kScreenHeight-64-30)/2)];
        
        _OldIMGV.layer.masksToBounds = YES;
        _OldIMGV.contentMode = UIViewContentModeScaleAspectFit;
        _OldIMGV.image = self.oldIMG;
        _OldIMGV.backgroundColor = [UIColor colorWithRed:0.388 green:0.666 blue:1.000 alpha:1.000];
    }
    return _OldIMGV;
}

-(UIImageView *)NewIMGV{
    if(!_NewIMGV){
        
        _NewIMGV = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                kViewMaxY(self.OldIMGV)+15,
                                                                kScreenWidth,
                                                                (kScreenHeight + 80)/2)];
        
        _NewIMGV.layer.masksToBounds = NO;
        _NewIMGV.contentMode = UIViewContentModeScaleAspectFit;
        _NewIMGV.backgroundColor = [UIColor colorWithRed:1.000 green:0.318 blue:0.333 alpha:1.000];
    }
    return _NewIMGV;
}

-(CGSize)NewIMGSize{
    return CGSizeMake(self.NewIMGV.frame.size.width*2,
                      self.NewIMGV.frame.size.height*2);
}

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.Supplierlist.count;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  //  self.unit = self.Supplierlist[row];
    NSDictionary *dict = self.Supplierlist[row];
    NSString *sv_suname = dict[@"sv_suname"];
    return sv_suname;
}

- (NSMutableArray *)ItemNumberArray
{
    if (!_ItemNumberArray) {
        _ItemNumberArray = [NSMutableArray array];
    }
    
    return _ItemNumberArray;
}

#pragma mark - 懒加载和照片
- (NSMutableArray *)editDictArray{
    if (_editDictArray == nil) {
        _editDictArray = [NSMutableArray array];
    }
    
    return _editDictArray;
}

- (SVAddShopDetailView *)addShopDetailView {
    if (!_addShopDetailView) {
        _addShopDetailView = [[[NSBundle mainBundle]loadNibNamed:@"SVAddShopDetailView" owner:nil options:nil] lastObject];
        _addShopDetailView.frame = CGRectMake(0, ScreenH, ScreenW, num);
        _addShopDetailView.backgroundColor = RGBA(239, 239, 239, 1);
        _addShopDetailView.layer.cornerRadius = 10;
        _addShopDetailView.layer.masksToBounds = YES;
        
        [_addShopDetailView.cancle addTarget:self action:@selector(handlePan) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addShopDetailView;
}

- (void)handlePan{
    [self.maskTheView removeFromSuperview];
    [UIView animateWithDuration:.2 animations:^{
        self.addShopDetailView.frame = CGRectMake(0, ScreenH, ScreenW, num);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.addShopDetailView removeFromSuperview];
        });
    }];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
 
    }
    return _imagePickerVc;
}

#pragma mark - 添加多图片
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.backgroundColor = BackgroundColor;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 10, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.uploadPictureView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSInteger contentSizeH = 14 * 35 + 20;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.scrollView.contentSize = CGSizeMake(0, contentSizeH + 5);
//    });

    _margin = 4;
    _itemWH = 72;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = 0;
   // _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
//    CGFloat collectionViewY = CGRectGetMaxY(self.scrollView.frame);
    self.collectionView.frame = CGRectMake(0, 0, self.view.tz_width, 80);
   // [self.collectionView reloadData];
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.editInterface == 1) {
        NSInteger countN = self.maxCountTF - _selectedPhotos.count;
        if (countN > 0) {
            return _selectedPhotos.count + 1;
        }else{
            return _selectedPhotos.count;
        }
    }else{
        if (_selectedPhotos.count >= self.maxCountTF) {
            return _selectedPhotos.count;
        }
            for (PHAsset *asset in _selectedAssets) {
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                    return _selectedPhotos.count;
                }
            }
        return _selectedPhotos.count + 1;
    }
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.gifLable.hidden = YES;
    } else {
        if (self.editInterface == 1) {
            cell.imageView.image = _selectedPhotos[indexPath.item];
            cell.deleteBtn.hidden = NO;
        }else{
            cell.imageView.image = _selectedPhotos[indexPath.item];
            cell.asset = _selectedAssets[indexPath.item];
            cell.deleteBtn.hidden = NO;
        }
    }
   // if (!self.allowPickingGifSwitch.isOn) {
        cell.gifLable.hidden = YES;
   // }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) {
        BOOL showSheet = YES;
        if (showSheet) {
            NSString *takePhotoTitle = @"拍照";
          //  if (self.showTakeVideoBtnSwitch.isOn && self.showTakePhotoBtnSwitch.isOn) {
                takePhotoTitle = @"相机";
//            } else if (self.showTakeVideoBtnSwitch.isOn) {
//                takePhotoTitle = @"拍摄";
//            }
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhotoTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            [alertVc addAction:takePhotoAction];
            UIAlertAction *imagePickerAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushTZImagePickerController];
            }];
            [alertVc addAction:imagePickerAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:cancelAction];
            UIPopoverPresentationController *popover = alertVc.popoverPresentationController;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            if (popover) {
                popover.sourceView = cell;
                popover.sourceRect = cell.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
            [self presentViewController:alertVc animated:YES completion:nil];
        } else {
            [self pushTZImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
           
        if (self.editInterface != 1) {
            PHAsset *asset = _selectedAssets[indexPath.item];
            BOOL isVideo = NO;
            isVideo = asset.mediaType == PHAssetMediaTypeVideo;

    //        } else { // preview photos / 预览照片
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.item];
                imagePickerVc.maxImagesCount = self.maxCountTF ;
                imagePickerVc.allowPickingGif = NO;
                imagePickerVc.autoSelectCurrentWhenDone = NO;
                imagePickerVc.allowPickingOriginalPhoto = YES;
                imagePickerVc.allowPickingMultipleVideo = NO;
                imagePickerVc.showSelectedIndex = YES;
                imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
                imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                    self->_selectedPhotos = [NSMutableArray arrayWithArray:photos];
                    self->_selectedAssets = [NSMutableArray arrayWithArray:assets];
                    self->_isSelectOriginalPhoto = isSelectOriginalPhoto;
                    [self->_collectionView reloadData];
                    self->_collectionView.contentSize = CGSizeMake(0, ((self->_selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
                }];
                [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.editInterface == 1) {
        UIImage *image = _selectedPhotos[sourceIndexPath.item];
        [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
        [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
        
//        id asset = _selectedAssets[sourceIndexPath.item];
//        [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
//        [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
        
        [_collectionView reloadData];
    }else{
        UIImage *image = _selectedPhotos[sourceIndexPath.item];
        [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
        [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
        
        id asset = _selectedAssets[sourceIndexPath.item];
        [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
        [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
        
        [_collectionView reloadData];
    }
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (self.editInterface == 1) {
        NSInteger countN = self.maxCountTF - _selectedPhotos.count;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:countN columnNumber:self.columnNumberTF delegate:self pushPhotoPickerVc:YES];
        
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
//    if (self.maxCountTF > 1) {
//        // 1.设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
 
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = YES;

    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    // 设置拍照时是否需要定位，仅对选择器内部拍照有效，外部拍照的，请拷贝demo时手动把pushImagePickerController里定位方法的调用删掉
    // imagePickerVc.allowCameraLocation = NO;
    
    // 自定义gif播放方案
    [[TZImagePickerConfig sharedInstance] setGifImagePlayBlock:^(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
        FLAnimatedImageView *animatedImageView;
        for (UIView *subview in imageView.subviews) {
            if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
                animatedImageView = (FLAnimatedImageView *)subview;
                animatedImageView.frame = imageView.bounds;
                animatedImageView.animatedImage = nil;
            }
        }
        if (!animatedImageView) {
            animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
            animatedImageView.runLoopMode = NSDefaultRunLoopMode;
            [imageView addSubview:animatedImageView];
        }
        animatedImageView.animatedImage = animatedImage;
    }];
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}else{
        if (self.maxCountTF <= 0) {
            return;
        }

        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCountTF columnNumber:self.columnNumberTF delegate:self pushPhotoPickerVc:YES];

    #pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        
        if (self.maxCountTF > 1) {
            // 1.设置目前已经选中的图片数组
            imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
        }
        imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
        imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
        imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
        [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
            imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
        }];

        imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
        imagePickerVc.showPhotoCannotSelectLayer = YES;
        imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
     
        // 3. Set allow picking video & photo & originalPhoto or not
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
        
        // 4. 照片排列按修改时间升序
        imagePickerVc.sortAscendingByModificationDate = YES;
        
        // imagePickerVc.minImagesCount = 3;
        // imagePickerVc.alwaysEnableDoneBtn = YES;
        
        // imagePickerVc.minPhotoWidthSelectable = 3000;
        // imagePickerVc.minPhotoHeightSelectable = 2000;
        
        /// 5. Single selection mode, valid when maxImagesCount = 1
        /// 5. 单选模式,maxImagesCount为1时才生效
        imagePickerVc.showSelectBtn = NO;
        imagePickerVc.allowCrop = NO;
        imagePickerVc.needCircleCrop = NO;
        // 设置竖屏下的裁剪尺寸
        NSInteger left = 30;
        NSInteger widthHeight = self.view.tz_width - 2 * left;
        NSInteger top = (self.view.tz_height - widthHeight) / 2;
        imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
        imagePickerVc.scaleAspectFillCrop = YES;

        imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
        
        // 设置是否显示图片序号
        imagePickerVc.showSelectedIndex = YES;
        
        // 设置拍照时是否需要定位，仅对选择器内部拍照有效，外部拍照的，请拷贝demo时手动把pushImagePickerController里定位方法的调用删掉
        // imagePickerVc.allowCameraLocation = NO;
        
        // 自定义gif播放方案
        [[TZImagePickerConfig sharedInstance] setGifImagePlayBlock:^(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
            FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
            FLAnimatedImageView *animatedImageView;
            for (UIView *subview in imageView.subviews) {
                if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
                    animatedImageView = (FLAnimatedImageView *)subview;
                    animatedImageView.frame = imageView.bounds;
                    animatedImageView.animatedImage = nil;
                }
            }
            if (!animatedImageView) {
                animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
                animatedImageView.runLoopMode = NSDefaultRunLoopMode;
                [imageView addSubview:animatedImageView];
            }
            animatedImageView.animatedImage = animatedImage;
        }];
        
        // 设置首选语言 / Set preferred language
        // imagePickerVc.preferredLanguage = @"zh-Hans";
        
    #pragma mark - 到这里为止
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        }];
        
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
//        if (self.showTakeVideoBtnSwitch.isOn) {
//            [mediaTypes addObject:(NSString *)kUTTypeMovie];
//        }
       // if (self.showTakePhotoBtnSwitch.isOn) {
            [mediaTypes addObject:(NSString *)kUTTypeImage];
       // }
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = YES;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        // save photo and get asset / 保存图片，获取到asset
       
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:self.location completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
              
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];

                    [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                //  NSLog(@"图片获取&上传完成");
                NSString *loadImage_path = @"/system/UploadImg";
                
                NSString *urlStr= [URLHeadPicture stringByAppendingFormat:@"%@?key=%@",loadImage_path,[SVUserManager shareInstance].access_token];
                [SVTool IndeterminateButtonAction:self.view withSing:@"图片保存中…"];
                // NSData *newIMGData = [self resetSizeOfImageData:image maxSize:50];

                NSData *newIMGData = [image bb_compressWithMaxLength:50 size:CGSizeMake(750, 1334)];
                [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    //上传的参数(上传图片，以文件流的格式)
                    [formData appendPartWithFileData:newIMGData
                     
                                                name:@"icon"
                     
                                            fileName:@"icon.jpg"
                     
                                            mimeType:@"image/jpeg"];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    
                    if ([dic[@"succeed"] integerValue] == 1) {
                        
                        //                    [SVTool ];
                        if ([self changeImagePath:dic[@"values"]].length <= 0) {
                            [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
                        }else{
                            NSString *imgURL = [self changeImagePath:dic[@"values"]];
                            NSMutableArray *imageArray = [NSMutableArray array];
                            [imageArray addObject:imgURL];
                            [self.selectUploadingArray addObjectsFromArray:imageArray];
                            //                                    self.collectionView relo
                            NSLog(@"self.selectUploadingArray = %@", self.selectUploadingArray);
                           
                         //  [MBProgressHUD hideHUDForView:self.view animated:YES];
                        }
                        
                    } else {
                        
                        [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
                        
                    }
                    
                    if (self.selectUploadingArray.count == _selectedPhotos.count) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [_collectionView reloadData];
                    }
                    
                   
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //        [SVTool requestFailed];
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    
    if (self.editInterface == 1) {
        [_selectedPhotos addObject:image];
      //  _selectedAssets = [NSMutableArray arrayWithArray:asset];
       // _isSelectOriginalPhoto = isSelectOriginalPhoto;
        [_collectionView reloadData];
    }else{
        [_selectedAssets addObject:asset];
        [_selectedPhotos addObject:image];
        [_collectionView reloadData];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    if (self.editInterface == 1) {
        [_selectedPhotos addObjectsFromArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
       
    }else{
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        _isSelectOriginalPhoto = isSelectOriginalPhoto;
      //  [_collectionView reloadData];
    }
   
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        NSLog(@"location:%@",phAsset.location);
    }
    
    // 3. 获取原图的示例，用队列限制最大并发为1，避免内存暴增
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    for (NSInteger i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
      
        TZImageUploadOperation *operation = [[TZImageUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
            if (isDegraded) return;
          //  NSLog(@"图片获取&上传完成");
            NSString *loadImage_path = @"/system/UploadImg";
            
            NSString *urlStr= [URLHeadPicture stringByAppendingFormat:@"%@?key=%@",loadImage_path,[SVUserManager shareInstance].access_token];
           

            // NSData *newIMGData = [self resetSizeOfImageData:image maxSize:50];
           // NSData *newIMGData = [photo bb_compressWithMaxLength:50 sizeMultiple:0];
            NSData *newIMGData = [photo bb_compressWithMaxLength:50 size:CGSizeMake(750, 1334)];

            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [SVTool IndeterminateButtonAction:self.view withSing:@"图片保存中…"];
                //上传的参数(上传图片，以文件流的格式)
                [formData appendPartWithFileData:newIMGData
                 
                                            name:@"icon"
                 
                                        fileName:@"icon.jpg"
                 
                                        mimeType:@"image/jpeg"];
                
                        } progress:^(NSProgress * _Nonnull uploadProgress) {
                            
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                            
                            if ([dic[@"succeed"] integerValue] == 1) {
                                
                                //                    [SVTool ];
                                if ([self changeImagePath:dic[@"values"]].length <= 0) {
                                    [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
                                }else{
                                    NSString *imgURL = [self changeImagePath:dic[@"values"]];
                                    NSMutableArray *imageArray = [NSMutableArray array];
                                    [imageArray addObject:imgURL];
                                    [self.selectUploadingArray addObjectsFromArray:imageArray];
//                                    self.collectionView relo
                                    NSLog(@"self.selectUploadingArray6666 = %@", self.selectUploadingArray);
                                  //  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    
                                 
                                }
                                
                            } else {
                                
                                [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
                                
                            }
                            
                          
//                            if (self.selectUploadingArray.count == _selectedPhotos.count) {
//
//                            }
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [_collectionView reloadData];
                           
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            //        [SVTool requestFailed];
                            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                        }];
            
            
            
        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            NSLog(@"获取原图进度 %f", progress);
        }];
        [self.operationQueue addOperation:operation];
    }
}

//截掉图片拼接路径
-(NSString*)changeImagePath:(NSString*)path{
    return  [path stringByReplacingOccurrencesOfString:URLHeadPortrait withString:@""];
}


// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {

    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanBeDisplayed:(PHAsset *)asset {

    return YES;
}

// Decide asset can be selected
// 决定照片能否被选中
- (BOOL)isAssetCanBeSelected:(PHAsset *)asset {
   
    return YES;
}

#pragma mark - 删除图片

- (void)deleteBtnClik:(UIButton *)sender {
    if (self.editInterface == 1) {
        if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
            [_selectedPhotos removeObjectAtIndex:sender.tag];
            [self.selectUploadingArray removeObjectAtIndex:sender.tag];
            [self.collectionView reloadData];
            return;
        }
        
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [self.selectUploadingArray removeObjectAtIndex:sender.tag];
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self->_collectionView reloadData];
        }];
    }else{
        if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
            [_selectedPhotos removeObjectAtIndex:sender.tag];
            [_selectedAssets removeObjectAtIndex:sender.tag];
            [self.collectionView reloadData];
            return;
        }
        
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self->_collectionView reloadData];
        }];
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
        // NSLog(@"图片名字:%@",fileName);
    }
}

#pragma mark - UITextFieldDelegate  textFiled的代理
//编辑完成时调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
//    switch (textField.tag) {
//        case 0:
//    }
    
    switch (textField.tag) {
        case 1:{
            
           // NSString *text = [NSString stringWithFormat:@"%@",textField.text];
            self.MinimumDiscount.text = nil;
            self.memberPrice.text = nil;
        }
             
            break;
            
        case 2:{
           NSString *text = [NSString stringWithFormat:@"%@",textField.text];
            if (text.doubleValue > 20 || text.doubleValue < 0) {
                textField.text = @"10";
            }
                self.minimumPrice.text = nil;
          
                self.memberPrice.text = nil;

            
            
           
        }
            
            break;
            
        case 3:{
        
                self.minimumPrice.text = nil;
                self.MinimumDiscount.text = nil;
        
            
        }
            
            break;
            
        case 5:{
            NSString *text = [NSString stringWithFormat:@"%@",textField.text];
            if (text.doubleValue > 100 || text.doubleValue < 0) {
                self.sv_p_commissionratio.text = @"100";
            }
            
        }
            
            break;
        default:
            break;
    }
}


/**
 单位选择
 */
-(SVUnitPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[NSBundle mainBundle] loadNibNamed:@"SVUnitPickerView" owner:nil options:nil].lastObject;
        _pickerView.frame = CGRectMake(0, 0, 320, 230);
        _pickerView.center = self.view.center;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.layer.cornerRadius = 10;
        
        [_pickerView.unitCancel addTarget:self action:@selector(unitCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView.unitDetermine addTarget:self action:@selector(unitDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerView;
}

/**
 遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unitCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}

- (void)unitCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self handlePan];
}
#pragma mark - 点击供应商
//点击手势的点击事件
- (void)unitDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    //获取pickerView中第0列的选中值
    NSInteger row=[self.pickerView.unitPicker selectedRowInComponent:0];
    NSDictionary *dict = [self.Supplierlist objectAtIndex:row];
    self.supplierLabel.text = dict[@"sv_suname"];
    self.sv_suid = [NSString stringWithFormat:@"%@",dict[@"sv_suid"]];
}

#pragma mark - 懒加载
//单位数组
- (NSMutableArray *)pickViewArr {
    
    if (!_pickViewArr) {
        
        _pickViewArr = [NSMutableArray array];
    }
    return _pickViewArr;
    
}

- (NSMutableArray *)bigArray
{
    if (_bigArray == nil) {
        _bigArray = [NSMutableArray array];
    }
    return _bigArray;
}

- (NSMutableArray *)sizeTwoArray
{
    if (_sizeTwoArray == nil) {
        _sizeTwoArray = [NSMutableArray array];
    }
    return _sizeTwoArray;
}

- (NSMutableArray *)initialArray
{
    if (_initialArray == nil) {
        _initialArray = [NSMutableArray array];
    }
    return _initialArray;
}


- (NSMutableArray *)bigItemNumberArray
{
    if (_bigItemNumberArray == nil) {
        _bigItemNumberArray = [NSMutableArray array];
    }
    
    return _bigItemNumberArray;
}

- (NSMutableArray *)specsDiffArray
{
    if (_specsDiffArray == nil) {
        _specsDiffArray = [NSMutableArray array];
    }
    return _specsDiffArray;
}


- (NSMutableArray *)firstSpecsDiffArray
{
    if (_firstSpecsDiffArray == nil) {
        _firstSpecsDiffArray = [NSMutableArray array];
    }
    return _firstSpecsDiffArray;
}

- (NSMutableArray *)storageDiffArray
{
    if (_storageDiffArray == nil) {
        _storageDiffArray = [NSMutableArray array];
    }
    return _storageDiffArray;
}

- (NSMutableArray *)artnoDiffArray
{
    if (_artnoDiffArray == nil) {
        _artnoDiffArray = [NSMutableArray array];
    }
    
    return _artnoDiffArray;
}

- (NSMutableArray *)firstArtnoDiffArray
{
    if (_firstArtnoDiffArray == nil) {
        _firstArtnoDiffArray = [NSMutableArray array];
    }
    
    return _firstArtnoDiffArray;
}

- (NSMutableArray *)firstStorageDiffArray
{
    if (_firstStorageDiffArray == nil) {
        _firstStorageDiffArray = [NSMutableArray array];
    }
    
    return _firstStorageDiffArray;
}



- (NSMutableArray *)threeColorArray
{
    if (_threeColorArray == nil) {
        _threeColorArray = [NSMutableArray array];
    }
    
    return _threeColorArray;
}

- (NSMutableArray *)oneModelArray
{
    if (_oneModelArray == nil) {
        _oneModelArray = [NSMutableArray array];
    }
    
    return _oneModelArray;
}

- (NSMutableArray *)twoModelArray
{
    if (_twoModelArray == nil) {
        _twoModelArray = [NSMutableArray array];
    }
    
    return _twoModelArray;
}

- (NSMutableArray *)attriModelArray
{
    if (_attriModelArray == nil) {
        _attriModelArray = [NSMutableArray array];
    }
    
    return _attriModelArray;
}

- (NSMutableArray *)atteilistModel2Array
{
    if (_atteilistModel2Array == nil) {
        _atteilistModel2Array = [NSMutableArray array];
    }
    
    return _atteilistModel2Array;
}

- (NSMutableArray *)product_idArray
{
    if (_product_idArray == nil) {
        _product_idArray = [NSMutableArray array];
    }
    
    return _product_idArray;
}

- (NSArray *)companyArray
{
    if (!_companyArray) {
        _companyArray = [NSArray array];
    }
    return _companyArray;
}

- (NSMutableArray *)selectUploadingArray
{
    if (!_selectUploadingArray) {
        _selectUploadingArray = [NSMutableArray array];
    }
    return _selectUploadingArray;
}

@end
