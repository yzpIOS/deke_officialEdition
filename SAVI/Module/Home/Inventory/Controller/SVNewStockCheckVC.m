//
//  SVNewStockCheckVC.m
//  SAVI
//
//  Created by houming Wang on 2019/5/29.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVNewStockCheckVC.h"
#import "SVLabelPrintingVC.h"
#import "SVShopSingleTemplateVC.h"
#import "SVInventoryRecordVC.h"
#import "SVSelectedGoodsModel.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#import "SVduoguigeModel.h"
#import "SVInventoryDetailsVC.h"
#import "SVPandianDetailModel.h"
#import "SVHomeVC.h"
#define num  ScreenH / 2

@interface SVNewStockCheckVC ()<OneViewControllerDelegate,selectMoreModelDelegate>
@property (nonatomic,strong) NSArray *titleData;
@property (nonatomic,strong) NSString *name_two;
@property (nonatomic,strong) SVSelectedGoodsModel *model;
@property (nonatomic,strong) UILabel *addShopLabel;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) NSMutableArray *selectModelArray;
@property (nonatomic,strong) UIView *payView;
@property (nonatomic,strong) NSString *values;
@property (nonatomic,assign)  NSInteger aa;
@property (nonatomic,strong) QQLBXScanViewController *LBXScanViewVc;
@property (nonatomic,strong) UIButton *physicalCountBtn;
@property (nonatomic,strong) UIButton *temporaryDraftBtn;// 暂存草稿
@property (nonatomic,strong) UIView *bottomView_two;
@end

@implementation SVNewStockCheckVC
- (void)viewDidLoad {
    
    self.selectIndex = 1;
    self.menuViewStyle = WMMenuViewStyleLine;
    //  self.menuItemWidth = ScreenW / 3 *2 / 6;
    self.progressHeight = 1;
    self.titleColorNormal = GlobalFontColor;
    self.titleColorSelected = navigationBackgroundColor;
    
    self.titleFontName = @"PingFangSC-Medium";
    
    self.title = @"盘点";
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"盘点记录" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self setUpbottomView_two];
    self.addShopTotleNum = 0;
 
//   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pandianPostArray:) name:@"pandianPostArray" object:nil];
    
    [super viewDidLoad];
    
   
    
    
}

- (void)setModelArr:(NSMutableArray *)modelArr
{
    _modelArr = modelArr;
    
    if (!kArrayIsEmpty(self.modelArr)) {
        for (NSDictionary *dict in self.modelArr) {
            SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:dict];
            [self.selectModelArray addObject:model];
        }
    }
    
    [self.bottomView_two removeFromSuperview];
    [self setUpbottomView_two];
    self.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",modelArr.count];
}


//- (void)dealloc{
//     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pandianPostArray" object:nil];
//}

//#pragma mark - 盘点详情中继续盘点的通知
//- (void)pandianPostArray:(NSNotification *)noti{
//    NSDictionary *dict = [noti userInfo];
//    NSMutableArray *modelArr = dict[@"modelArr"];
//    self.modelArr = modelArr;
//   
//   // self.modelArr = modelArr;
//}

//#pragma mark - 继续盘点的返回
//- (void)setModelArr:(NSMutableArray *)modelArr
//{
//      = modelArr;
//    [self.bottomView_two removeFromSuperview];
//    [self setUpbottomView_two];
//    self.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",modelArr.count];
//}



#pragma mark - 盘点记录点击
- (void)selectbuttonResponseEvent{
   
    SVInventoryRecordVC *inventoryRecordVC = [[SVInventoryRecordVC alloc] init];
    [self.navigationController pushViewController:inventoryRecordVC animated:YES];
}

- (void)setUpbottomView_two{
    
    UIView *bottomView_two = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-TopHeight - 50-BottomHeight, ScreenW, 50 )];
    self.bottomView_two = bottomView_two;
    bottomView_two.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomView_two];
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = [UIColor whiteColor];
    [bottomView_two addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView_two.mas_left);
        make.width.mas_equalTo(ScreenW * 0.5);
        make.top.mas_equalTo(bottomView_two.mas_top);
        make.bottom.mas_equalTo(bottomView_two.mas_bottom);
    }];
    
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClick)];
    [oneView addGestureRecognizer:tag];
    
    UILabel *addShopLabel = [[UILabel alloc] init];
    self.addShopLabel = addShopLabel;
    addShopLabel.text = @"未盘点";
    [addShopLabel setTextColor:[UIColor grayColor]];
    [addShopLabel setFont:[UIFont systemFontOfSize:14]];
    [oneView addSubview:addShopLabel];
    [addShopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView.mas_left).offset(10);
        make.centerY.mas_equalTo(oneView.mas_centerY);
    }];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [oneView addSubview:icon];
    icon.image = [UIImage imageNamed:@"brithdaySmall"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(oneView.mas_right).offset(-10);
        make.centerY.mas_equalTo(oneView.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    //
    // UIView *TemporaryDraftView = [[UIView alloc] init];
    UIButton *temporaryDraftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.temporaryDraftBtn = temporaryDraftBtn;
    [temporaryDraftBtn addTarget:self action:@selector(temporaryDraftClick) forControlEvents:UIControlEventTouchUpInside];
    [temporaryDraftBtn setTitle:@"暂存草稿" forState:UIControlStateNormal];
    [temporaryDraftBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [temporaryDraftBtn setBackgroundColor:BackgroundColor];
    [temporaryDraftBtn setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    [bottomView_two addSubview:temporaryDraftBtn];
    [temporaryDraftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oneView.mas_right);
        make.width.mas_equalTo(ScreenW /4 *1);
        make.top.mas_equalTo(bottomView_two.mas_top);
        make.bottom.mas_equalTo(bottomView_two.mas_bottom);
    }];
    
    UIButton *physicalCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.physicalCountBtn = physicalCountBtn;
    [physicalCountBtn addTarget:self action:@selector(physicalCountClick) forControlEvents:UIControlEventTouchUpInside];
    [physicalCountBtn setTitle:@"完成盘点" forState:UIControlStateNormal];
    [physicalCountBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [physicalCountBtn setBackgroundColor:navigationBackgroundColor];
    [physicalCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView_two addSubview:physicalCountBtn];
    [physicalCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(temporaryDraftBtn.mas_right);
        make.width.mas_equalTo(ScreenW /4*1);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(bottomView_two.mas_bottom);
    }];
    
    
    
}



#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}



#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    switch (index) {
        case 0:{
            
            //添加一些扫码或相册结果处理
            QQLBXScanViewController *vc = [QQLBXScanViewController new];
            vc.libraryType = [Global sharedManager].libraryType;
            vc.scanCodeType = [Global sharedManager].scanCodeType;
            vc.selectNumber = 1;
            vc.isStockPurchase = 0;// 0是盘点
            vc.stockCheckVC = self;
            vc.style = [StyleDIY weixinStyle];
            self.LBXScanViewVc = vc;
            __weak __typeof(self) weakSelf = self;
            vc.selectDuoguigeModel = ^(SVduoguigeModel *model) {
                
                weakSelf.aa = 1;
                if (weakSelf.selectModelArray.count == 0) {
                    weakSelf.aa = 0;
                    weakSelf.addShopTotleNum += 1;
                    weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
                    [weakSelf.selectModelArray addObject:model];
                }else{
                    for (SVduoguigeModel *modell in weakSelf.selectModelArray) {
                        if (model.product_id == modell.product_id) {
                            [weakSelf.selectModelArray removeObject:modell];
                            weakSelf.addShopTotleNum -= 1;
                            // [SVTool TextButtonAction:self.view withSing:@"已经添加过了"];
                            break;
                        }else{
                            
                        }
                    }
                }
                
                if (weakSelf.aa == 1) {
                    weakSelf.addShopTotleNum += 1;
                    weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
                    [weakSelf.selectModelArray addObject:model];
                }
                
            };
            
            //镜头拉远拉近功能
            vc.isVideoZoom = YES;
            
            
            return vc;
            
            
            
        }
            
            break;
        default:{
            
            SVLabelPrintingVC *vc = [[SVLabelPrintingVC alloc] init];
            vc.stockCheckVC = self;
            vc.controllerNum = 2;
            vc.modelArr = self.modelArr;
            __weak typeof(self) weakSelf = self;
            vc.selectDuoguigeModel = ^(SVduoguigeModel *model) {
                weakSelf.aa = 1;
                if (weakSelf.selectModelArray.count == 0) {
                    weakSelf.aa = 0;
                   // model.sv_checkdetail_type = @"0";
                    weakSelf.addShopTotleNum += 1;
                    weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
                    [weakSelf.selectModelArray addObject:model];
                }else{
                    for (SVduoguigeModel *modell in weakSelf.selectModelArray) {
                        if (model.product_id == modell.product_id) {
                            [weakSelf.selectModelArray removeObject:modell];
                            weakSelf.addShopTotleNum -= 1;
                            
                            break;
                        }else{
                            
                        }
                    }
                }
                
                if (weakSelf.aa == 1) {

                        weakSelf.addShopTotleNum = weakSelf.selectModelArray.count + 1;
                        weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
                      //  model.sv_checkdetail_type = @"0";
                        [weakSelf.selectModelArray addObject:model];
                    
                   // }
                
                }
            };
            
          
            vc.removeDuoguigeModel = ^(SVduoguigeModel *model) {
                for (SVduoguigeModel *modell in weakSelf.selectModelArray) {
                    if (model.product_id == modell.product_id) {
                        [weakSelf.selectModelArray removeObject:modell];
                        weakSelf.addShopTotleNum -= 1;
                        
                        break;
                    }else{
                        
                    }
                }
                
             //   weakSelf.addShopTotleNum = weakSelf.selectModelArray.count -1;
                if (weakSelf.addShopTotleNum == 0) {
                    weakSelf.addShopLabel.text = @"未盘点";
                }else{
                    weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
                }
                
            };
            
            return vc;
            
        }
            break;
            
            
    }
    
    
}


- (void)selectMoreModelClick:(NSMutableArray *)selectModelArray
{
    NSMutableArray *arr1 = [NSMutableArray array];
    for (SVduoguigeModel *model in selectModelArray) {
        [arr1 addObject:model.product_id];
    }
    
    NSMutableArray *arr2 = [NSMutableArray array];
    for (SVduoguigeModel *modell in self.selectModelArray) {
        [arr2 addObject:modell.product_id];
    }
    NSPredicate * filterPredicate_same = [NSPredicate predicateWithFormat:@"SELF IN %@",arr1];
    NSArray * filter_no = [arr2 filteredArrayUsingPredicate:filterPredicate_same];
    NSLog(@"-----%@",filter_no);
    if (kArrayIsEmpty(filter_no)) {
        self.addShopTotleNum += selectModelArray.count;
        self.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",self.addShopTotleNum];
        [self.selectModelArray addObjectsFromArray:selectModelArray];
    }else{
        //        [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"已添加过%ld个相同的商品"],filter_no.count];
        NSLog(@"%ld",filter_no.count);
        NSInteger count = filter_no.count;
        [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"已添加过%ld个相同的商品",count]];
    }
    
    
}


- (void)OneViewControllerCellClick:(NSString *)name
{
    [self getDataPageIndex:1 pageSize:1 category:0 name:name isn:name read_morespec:@"false"];
}

#pragma mark - 点击数量
- (void)tagClick{
    
    if (self.selectModelArray.count > 0) {
        
        SVInventoryDetailsVC *inventoryDetailVc = [[SVInventoryDetailsVC alloc] init];
        if (!kStringIsEmpty(self.sv_storestock_check_r_no)) {
            inventoryDetailVc.sv_storestock_addshop_check_r_no = self.sv_storestock_check_r_no;
            
        }
        inventoryDetailVc.successBlock = ^{
            self.addShopTotleNum = 0;
            [self.selectModelArray removeAllObjects];
            [self.modelArr removeAllObjects];
            self.addShopLabel.text = @"未盘点";
            [self.LBXScanViewVc.sameModelArray removeAllObjects];
            self.LBXScanViewVc.detailView.hidden = YES;
        };
        inventoryDetailVc.selectNum = 3;// 这是已经添加的商品
        inventoryDetailVc.selectModelArray = self.selectModelArray;
        // inventoryDetailVc.model = self.modelArr[indexPath.row];
        [self.navigationController pushViewController:inventoryDetailVc animated:YES];
    }
    
    
}

#pragma mark - 数据请求
/**
 获取产品列表
 
 @param pageIndex 第几页
 @param pageSize 每页有几个
 @param category 只限大分类
 @param name 搜索关键字
 */
- (void)getDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize category:(NSInteger)category name:(NSString *)name isn:(NSString *)isn read_morespec:(NSString *)read_morespec{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&pageIndex=%li&pageSize=%li&category=%li&name=%@&isn=%@&read_morespec=%@",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,(long)category,name,isn,read_morespec];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic收银记账 = %@",dic);
        
        NSDictionary *valuesDic = dic[@"values"];
        
        NSArray *listArr = valuesDic[@"list"];
        
        SVSelectedGoodsModel *model = [SVSelectedGoodsModel mj_objectWithKeyValues:listArr[0]];
        // self.model = model;
        
        if (model.sv_is_newspec == 1) { // 是多规格的商品
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
            
            
        }else{// 不是多规格的商品
            
        }
        
        NSLog(@"dic = %@",dic);
        
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        
    }];
}


#pragma mark - 暂存草稿
- (void)temporaryDraftClick{
    
        if (!kArrayIsEmpty(self.selectModelArray)) {
            self.temporaryDraftBtn.userInteractionEnabled = NO;
            [SVUserManager loadUserInfo];
            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/AddStoreStockCheckRecordInfoWithBatchNumber?key=%@",[SVUserManager shareInstance].access_token];
          //  NSString *sv_storestock_check_list_no;
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *FirmOfferNumArray = [NSMutableArray array];
            for (SVduoguigeModel *model in self.selectModelArray) {
                NSLog(@"model.sv_storestock_check_list_no = %@",model.sv_storestock_check_list_no);
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (!kStringIsEmpty(model.sv_storestock_checkdetail_id)) {
                    dic[@"sv_storestock_checkdetail_id"] = model.sv_storestock_checkdetail_id;
                }
                
                if (kStringIsEmpty(model.sv_checkdetail_type)) {
                     dic[@"sv_checkdetail_type"] = @"0";
                }else{
                    dic[@"sv_checkdetail_type"] = [NSString stringWithFormat:@"%@",model.sv_checkdetail_type];
                }

                if (!kStringIsEmpty(model.sv_storestock_check_list_no)) {
                   dic[@"sv_storestock_check_list_no"] = [NSString stringWithFormat:@"%@",model.sv_storestock_check_list_no];
                }
                
                NSString *product_id = [NSString stringWithFormat:@"%@",model.product_id];
                int product_id_int = product_id.intValue;
                dic[@"sv_storestock_checkdetail_pid"] = [NSNumber numberWithInt:product_id_int];
             NSString *sv_pricing_method = [NSString stringWithFormat:@"%@",model.sv_pricing_method];
                int sv_pricing_method_int = sv_pricing_method.intValue;
                dic[@"sv_checkdetail_pricing_method"] = [NSNumber numberWithInt:sv_pricing_method_int];
                
                dic[@"sv_storestock_checkdetail_pbcode"] = [NSString stringWithFormat:@"%@",model.sv_p_barcode];
                dic[@"sv_storestock_checkdetail_pname"] = [NSString stringWithFormat:@"%@",model.sv_p_name];
                dic[@"sv_storestock_checkdetail_specs"] = [NSString stringWithFormat:@"%@",model.sv_p_specs];
                dic[@"sv_storestock_checkdetail_unit"] = [NSString stringWithFormat:@"%@",model.sv_p_unit];
                if (kStringIsEmpty(model.sv_p_unitprice)) {
                     dic[@"sv_storestock_checkdetail_checkprice"] = @(0);
                }else{
                    NSString *sv_p_unitprice = [NSString stringWithFormat:@"%@",model.sv_p_unitprice];
                    double sv_p_unitprice_double = sv_p_unitprice.doubleValue;
                     dic[@"sv_storestock_checkdetail_checkprice"] = [NSNumber numberWithDouble:sv_p_unitprice_double];
                }
               NSString *sv_p_originalprice = [NSString stringWithFormat:@"%@",model.sv_p_originalprice];
                double sv_p_originalprice_double = sv_p_originalprice.doubleValue;
                dic[@"sv_storestock_checkdetail_checkoprice"] = [NSNumber numberWithDouble:sv_p_originalprice_double];
                if (kStringIsEmpty(model.sv_p_storage)) {
                    dic[@"sv_storestock_checkdetail_checkbeforenum"] = @(0);
                }else{
//                   NSString *sv_p_storage = [NSString stringWithFormat:@"%@",model.sv_p_storage];
//                    int sv_p_storage_int = sv_p_storage.intValue;
//                    dic[@"sv_storestock_checkdetail_checkbeforenum"] = [NSNumber numberWithInt:sv_p_storage_int];
                    
                    NSString *sv_p_storageStr = [NSString stringWithFormat:@"%.4f",model.sv_p_storage.doubleValue];
                    double sv_p_storage = sv_p_storageStr.doubleValue;
                    dic[@"sv_storestock_checkdetail_checkbeforenum"] = [NSNumber numberWithDouble:sv_p_storage];
                }
                
                double checkafternum = model.sv_p_storage.doubleValue - model.FirmOfferNum.doubleValue;
                 dic[@"sv_storestock_checkdetail_checkafternum"] = [NSNumber numberWithDouble:checkafternum];
                
                //  dic[@"sv_storestock_checkdetail_checkbeforenum"] = @"0";
                dic[@"sv_storestock_checkdetail_categoryid"] = [NSString stringWithFormat:@"%@",model.productcategory_id];
                dic[@"sv_storestock_checkdetail_categoryname"] = model.sv_pc_name;
                dic[@"sv_remark"] = model.sv_remark;
                
                if (kStringIsEmpty(model.FirmOfferNum)) {
                    dic[@"sv_storestock_checkdetail_checknum"] = @(-1);
                }else{
                   NSString *FirmOfferNumStr = [NSString stringWithFormat:@"%.4f",model.FirmOfferNum.doubleValue];
                    double FirmOfferNum = FirmOfferNumStr.doubleValue;
                    dic[@"sv_storestock_checkdetail_checknum"] = [NSNumber numberWithDouble:FirmOfferNum];
                    [FirmOfferNumArray addObject:dic];
                }
                
                [array addObject:dic];
            }

            
            if (kArrayIsEmpty(FirmOfferNumArray)) {
                
                
                NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                
                [parame setObject:array forKey:@"StoreStockCheckDetail"];
                if (kStringIsEmpty(self.sv_storestock_check_r_no)) {
                    [parame setObject:@"" forKey:@"sv_storestock_check_r_no"];
                }else{
                    [parame setObject:self.sv_storestock_check_r_no forKey:@"sv_storestock_check_r_no"];
                }
                
                if (kStringIsEmpty(self.sv_storestock_check_no)) {
                    [parame setObject:@"" forKey:@"sv_storestock_check_no"];
                }else{
                    [parame setObject:self.sv_storestock_check_no forKey:@"sv_storestock_check_no"];
                }
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"您未输入实盘，确定保存草稿吗？"];
                //设置文本颜色
                [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 13)];
                //设置文本字体大小
                [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 13)];
                [alert setValue:hogan forKey:@"attributedTitle"];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
                
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [SVTool IndeterminateButtonAction:self.view withSing:nil];
                    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        //解释数据
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"dic是否成功 = %@",dic);
                        NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                        
                        if ([suc isEqualToString:@"1"]) {
                            [SVTool TextButtonAction:self.view withSing:@"暂存草稿成功"];
                            
                            self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                            
                            if (self.selectNumber == 1) {// 继续盘点那边过来的
                                if (self.modelArrayBlock) {
                                self.modelArrayBlock(self.selectModelArray,self.values);
                                }
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                            self.addShopTotleNum = 0;
                            [self.selectModelArray removeAllObjects];
                            self.addShopLabel.text = @"未盘点";
                            [self.LBXScanViewVc.sameModelArray removeAllObjects];
                            self.LBXScanViewVc.detailView.hidden = YES;
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                            //[self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                        }
                        self.temporaryDraftBtn.userInteractionEnabled = YES;
//                        //隐藏提示框
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        self.temporaryDraftBtn.userInteractionEnabled = YES;
                        //隐藏提示框
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        //        [SVTool requestFailed];
                        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    }];
                    
                    
                }];
                [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
                
                [alert addAction:cancelAction];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];

            }else{
                [SVTool IndeterminateButtonAction:self.view withSing:nil];
                NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                
                [parame setObject:array forKey:@"StoreStockCheckDetail"];
                if (kStringIsEmpty(self.sv_storestock_check_r_no)) {
                     [parame setObject:@"" forKey:@"sv_storestock_check_r_no"];
                }else{
                     [parame setObject:self.sv_storestock_check_r_no forKey:@"sv_storestock_check_r_no"];
                }
                
                if (kStringIsEmpty(self.sv_storestock_check_no)) {
                     [parame setObject:@"" forKey:@"sv_storestock_check_no"];
                }else{
                     [parame setObject:self.sv_storestock_check_no forKey:@"sv_storestock_check_no"];
                }
               
               
                // self.countNum = array.count - FirmOfferNumArray.count;
                // parame[@"requestInventory"] =
                
                [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //解释数据
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"dic是否成功 = %@",dic);
                    NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                    
                    if ([suc isEqualToString:@"1"]) {
                        [SVTool TextButtonAction:self.view withSing:@"暂存草稿成功"];
                        
                        self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                        
                        if (self.selectNumber == 1) {// 继续盘点那边过来的
                            if (self.modelArrayBlock) {
                        self.modelArrayBlock(self. sv_storestock_check_r_no,self.values);
                            }
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                        
                        self.addShopTotleNum = 0;
                        [self.selectModelArray removeAllObjects];
                        self.addShopLabel.text = @"未盘点";
                        [self.LBXScanViewVc.sameModelArray removeAllObjects];
                        self.LBXScanViewVc.detailView.hidden = YES;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                        // [self.navigationController popViewControllerAnimated:YES];
                        //隐藏提示框
                  //  [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }else{
                        [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                    }
                    self.temporaryDraftBtn.userInteractionEnabled = YES;
                  
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    self.temporaryDraftBtn.userInteractionEnabled = YES;
                    //隐藏提示框
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //        [SVTool requestFailed];
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                }];
            }
        }else{
            ALERT(@"没有添加商品");
        }
        
   // }
   
}

#pragma mark - 完成盘点
- (void)physicalCountClick{
    
    if (kArrayIsEmpty(self.selectModelArray)) {
        ALERT(@"没有添加商品");
    }else{
        
        self.physicalCountBtn.userInteractionEnabled = NO;
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/AddStoreStockCheckRecordInfoWithBatchNumber?key=%@",[SVUserManager shareInstance].access_token];
        
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *FirmOfferNumArray = [NSMutableArray array];
        for (SVduoguigeModel *model in self.selectModelArray) {
            NSLog(@"model.sv_storestock_check_list_no = %@",model.sv_storestock_check_list_no);
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (!kStringIsEmpty(model.sv_storestock_checkdetail_id)) {
                dic[@"sv_storestock_checkdetail_id"] = model.sv_storestock_checkdetail_id;
            }
            
            if (kStringIsEmpty(model.sv_checkdetail_type)) {
                dic[@"sv_checkdetail_type"] = @"0";
            }else{
                dic[@"sv_checkdetail_type"] = [NSString stringWithFormat:@"%@",model.sv_checkdetail_type];
            }
            
            if (!kStringIsEmpty(model.sv_storestock_check_list_no)) {
                dic[@"sv_storestock_check_list_no"] = [NSString stringWithFormat:@"%@",model.sv_storestock_check_list_no];
            }
           NSString *product_id = [NSString stringWithFormat:@"%@",model.product_id];
            int product_id_int = product_id.intValue;
            dic[@"sv_storestock_checkdetail_pid"] = [NSNumber numberWithInt:product_id_int];
          NSString *sv_pricing_method = [NSString stringWithFormat:@"%@",model.sv_pricing_method];
            int sv_pricing_method_int = sv_pricing_method.intValue;
            
            dic[@"sv_checkdetail_pricing_method"] = [NSNumber numberWithInt:sv_pricing_method_int];
            
            dic[@"sv_storestock_checkdetail_pbcode"] = [NSString stringWithFormat:@"%@",model.sv_p_barcode];
            dic[@"sv_storestock_checkdetail_pname"] = [NSString stringWithFormat:@"%@",model.sv_p_name];
            dic[@"sv_storestock_checkdetail_specs"] = [NSString stringWithFormat:@"%@",model.sv_p_specs];
            dic[@"sv_storestock_checkdetail_unit"] = [NSString stringWithFormat:@"%@",model.sv_p_unit];
            if (kStringIsEmpty(model.sv_p_unitprice)) {
                dic[@"sv_storestock_checkdetail_checkprice"] = @(0);
            }else{
              double sv_p_unitprice = model.sv_p_unitprice.doubleValue;
                dic[@"sv_storestock_checkdetail_checkprice"] = [NSNumber numberWithDouble:sv_p_unitprice];
            }
            
            NSString *sv_p_originalprice=[NSString stringWithFormat:@"%@",model.sv_p_originalprice];
            double sv_p_originalprice_double = sv_p_originalprice.doubleValue;
            dic[@"sv_storestock_checkdetail_checkoprice"] = [NSNumber numberWithDouble:sv_p_originalprice_double];
            if (kStringIsEmpty(model.sv_p_storage)) {
                dic[@"sv_storestock_checkdetail_checkbeforenum"] = @(0);
            }else{
                NSString *sv_p_storageStr = [NSString stringWithFormat:@"%.4f",model.sv_p_storage.doubleValue];
                 double sv_p_storage = sv_p_storageStr.doubleValue;
                dic[@"sv_storestock_checkdetail_checkbeforenum"] = [NSNumber numberWithDouble:sv_p_storage];
            }
            
            double sv_p_storage = model.sv_p_storage.doubleValue - model.FirmOfferNum.doubleValue;
            dic[@"sv_storestock_checkdetail_checkafternum"] = [NSNumber numberWithDouble:sv_p_storage];
            
            //  dic[@"sv_storestock_checkdetail_checkbeforenum"] = @"0";
            dic[@"sv_storestock_checkdetail_categoryid"] = [NSString stringWithFormat:@"%@",model.productcategory_id];
            dic[@"sv_storestock_checkdetail_categoryname"] = model.sv_pc_name;
            dic[@"sv_remark"] = model.sv_remark;
            
            if (kStringIsEmpty(model.FirmOfferNum)) {
                dic[@"sv_storestock_checkdetail_checknum"] = @(-1);
            }else{
                NSString *FirmOfferNumStr = [NSString stringWithFormat:@"%.4f",model.FirmOfferNum.doubleValue];
                double FirmOfferNum = FirmOfferNumStr.doubleValue;
                dic[@"sv_storestock_checkdetail_checknum"] = [NSNumber numberWithDouble:FirmOfferNum];
                [FirmOfferNumArray addObject:dic];
            }
            
            [array addObject:dic];
        }
        //  sv_storestock_checkdetail_checkbeforenum
        
        if (kArrayIsEmpty(FirmOfferNumArray)) {
            
            ALERT(@"未输入实盘，不能盘点");
        }else{
            
            NSInteger countNum = array.count - FirmOfferNumArray.count;
            
            if (countNum == 0) {
                NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                
                [parame setObject:array forKey:@"StoreStockCheckDetail"];
                if (kStringIsEmpty(self.sv_storestock_check_r_no)) {
                    [parame setObject:@"" forKey:@"sv_storestock_check_r_no"];
                }else{
                    [parame setObject:self.sv_storestock_check_r_no forKey:@"sv_storestock_check_r_no"];
                }
                
                if (kStringIsEmpty(self.sv_storestock_check_no)) {
                    [parame setObject:@"" forKey:@"sv_storestock_check_no"];
                }else{
                    [parame setObject:self.sv_storestock_check_no forKey:@"sv_storestock_check_no"];
                }
                
                //  self.countNum = array.count - FirmOfferNumArray.count;
                // parame[@"requestInventory"] =
                [SVTool IndeterminateButtonAction:self.view withSing:nil];
                [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //解释数据
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"dic是否成功 = %@",dic);
                    NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                    
                    if ([suc isEqualToString:@"1"]) {
                        
                        self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                        
                        [SVUserManager loadUserInfo];
                        NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/AppSelectStoreStockCheckInfo?key=%@&sv_storestock_check_no=%@",[SVUserManager shareInstance].access_token,self.values];
                        [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            //解释数据
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                            NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                            if ([suc isEqualToString:@"1"]) {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                              //  [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                                [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                                if (self.selectNumber == 1) { // 继续盘点过来的
                                    // #import "SVHomeVC.h"
                                    
                                    // 返回到任意界面
                                    for (UIViewController *temp in self.navigationController.viewControllers) {
                                        if ([temp isKindOfClass:[SVHomeVC class]]) {
                                            
                                            [self.navigationController popToViewController:temp animated:YES];
                                        }
                                    }
                                }else{
                                    self.addShopTotleNum = 0;
                                    [self.selectModelArray removeAllObjects];
                                    self.addShopLabel.text = @"未盘点";
                                    [self.LBXScanViewVc.sameModelArray removeAllObjects];
                                    self.LBXScanViewVc.detailView.hidden = YES;
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                                }
                              
                                
                            }else{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            }
                            
                            self.physicalCountBtn.userInteractionEnabled = YES;
//                            //隐藏提示框
//                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             self.physicalCountBtn.userInteractionEnabled = YES;
                            //隐藏提示框
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //        [SVTool requestFailed];
                            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                        }];
                        
                        
                    }else{
                        [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     self.physicalCountBtn.userInteractionEnabled = YES;
                    //隐藏提示框
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //        [SVTool requestFailed];
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                }];
                
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您确定要完成该盘点吗？(%ld)种商品未盘",countNum]];
                //设置文本颜色
                [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 13)];
                //设置文本字体大小
                [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 13)];
                [alert setValue:hogan forKey:@"attributedTitle"];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
                
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                    
                    [parame setObject:array forKey:@"StoreStockCheckDetail"];
                    if (kStringIsEmpty(self.sv_storestock_check_r_no)) {
                        [parame setObject:@"" forKey:@"sv_storestock_check_r_no"];
                    }else{
                        [parame setObject:self.sv_storestock_check_r_no forKey:@"sv_storestock_check_r_no"];
                    }
                    
                    if (kStringIsEmpty(self.sv_storestock_check_no)) {
                        [parame setObject:@"" forKey:@"sv_storestock_check_no"];
                    }else{
                        [parame setObject:self.sv_storestock_check_no forKey:@"sv_storestock_check_no"];
                    }
                    
                    //  self.countNum = array.count - FirmOfferNumArray.count;
                    // parame[@"requestInventory"] =
                    [SVTool IndeterminateButtonAction:self.view withSing:nil];
                    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        //解释数据
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"dic是否成功 = %@",dic);
                        NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                        
                        if ([suc isEqualToString:@"1"]) {
                            
                            self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                            
                            [SVUserManager loadUserInfo];
                            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/AppSelectStoreStockCheckInfo?key=%@&sv_storestock_check_no=%@",[SVUserManager shareInstance].access_token,self.values];
                            [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                //解释数据
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                                if ([suc isEqualToString:@"1"]) {
                                    
                                    if (self.selectNumber == 1) {
                                       // #import "SVHomeVC.h"
                                        
                                        // 返回到任意界面
                                        for (UIViewController *temp in self.navigationController.viewControllers) {
                                            if ([temp isKindOfClass:[SVHomeVC class]]) {
                                                
                                                [self.navigationController popToViewController:temp animated:YES];
                                            }
                                        }
                                    }else{
//                                        [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                                        [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                                        self.addShopTotleNum = 0;
                                        [self.selectModelArray removeAllObjects];
                                        self.addShopLabel.text = @"未盘点";
                                        [self.LBXScanViewVc.sameModelArray removeAllObjects];
                                        self.LBXScanViewVc.detailView.hidden = YES;
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                                    }
                                   
                                    
                                }else{
                                    [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                                }
                                
                                 self.physicalCountBtn.userInteractionEnabled = YES;
                               //  [MBProgressHUD hideHUDForView:self.view animated:YES];
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                //隐藏提示框
                                 self.physicalCountBtn.userInteractionEnabled = YES;
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                //        [SVTool requestFailed];
                                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            }];
                            //                            if (self.successBlock) {
                            //                                self.successBlock();
                            //                            }
                            
                        }else{
                            [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                        }
                         self.physicalCountBtn.userInteractionEnabled = YES;
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         self.physicalCountBtn.userInteractionEnabled = YES;
                        //隐藏提示框
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        //        [SVTool requestFailed];
                        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    }];
                    
                    
                }];
                [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
                
                [alert addAction:cancelAction];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            
        }
    }
}

/**
 遮盖
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheView addGestureRecognizer:tap];
        
    }
    
    return _maskTheView;
    
}




- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    //    if (self.iskaiguan == NO) {
    //        return CGRectMake(0, 0, HomePageScreen / 3 *2, 64);
    //    }else{
    //        return CGRectMake(0, 0, ScreenW /3*2, 64);
    //    }
    return CGRectMake(0, 0, ScreenW, 50);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
   
    return CGRectMake(0, 50, ScreenW, ScreenH - TopHeight - 50 - 50-BottomHeight);
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}

#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            _titleData = @[@"扫款号", @"选商品"];
        }else{
            
            _titleData = @[@"扫条码", @"选商品"];
        }
        
    }
    return _titleData;
}

- (NSMutableArray *)selectModelArray
{
    if (!_selectModelArray) {
        _selectModelArray = [NSMutableArray array];
    }
    
    return _selectModelArray;
}
@end
