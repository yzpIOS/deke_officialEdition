//
//  SVInventoryDetailsVC.m
//  SAVI
//
//  Created by houming Wang on 2019/6/4.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInventoryDetailsVC.h"
#import "SVInventoryTopView.h"
#import "SVInvenDetaiCell.h"
#import "SVdraftListModel.h"
#import "SVPandianDetailModel.h"
#import "SVduoguigeModel.h"
#import "SVAddShopFlowLayout.h"
#import "SVPrintCollectionViewCell.h"
#import "SVDetaildraftFirmOfferCell.h"
#import "SVPrintFlowLayout.h"
#import "SVNewStockCheckVC.h"
#import "SVHomeVC.h"

static NSString *const inventoryCellID = @"SVInvenDetaiCell";
static NSString *const collectionViewCellID = @"SVDetaildraftFirmOfferCell";
@interface SVInventoryDetailsVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SVInventoryTopView *inventoryTopView;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) UICollectionView *PrintingCollectionView;
@property (nonatomic,strong) NSArray *sizeImageArray;
@property (nonatomic,strong) NSArray *sizeArray;
@property (nonatomic,strong) UIImageView *icon_imageView;
@property (nonatomic,strong) UIButton *icon_button;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
/**
 盈亏数量
 */
@property (nonatomic,assign) double number_num;
@property (nonatomic,assign) double cost_num;
@property (nonatomic,assign) double money_num;

@property (nonatomic,strong) UIButton *physicalCountBtn;
@property (nonatomic,strong) NSString *values;
@property (nonatomic,strong) UIButton *temporaryDraftBtn_two;
@property (nonatomic,assign) NSInteger countNum;
@property (nonatomic,strong) NSString *sv_storestock_check_no;
@property (nonatomic,strong) NSString *sv_storestock_check_r_no;
@property (nonatomic,assign) NSInteger jixupandianNum;


@end

@implementation SVInventoryDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.selectNum == 3) {
        self.title = @"已添加的商品";
    }else{
        self.title = @"盘点详情";
    }
    
    [self setUpTableView];
    [self setUpbottomView_two];
    UIButton* leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"blackBack"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(setviewinfo) forControlEvents:UIControlEventTouchUpInside];
    //    [self.navigationItem setleftBarButtonItem:leftBtnItem];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
     self.navigationController.navigationBar.tintColor = GlobalFontColor;
    
    if (self.selectNum == 1) {
        [self loadDataSv_storestock_check_r_no:self.model.sv_storestock_check_r_no];
    }else if (self.selectNum == 3){ // 已添加商品
        if (!kStringIsEmpty(self.sv_storestock_addshop_check_r_no)) {
            self.jixupandianNum = 1;
            [self loadDataSv_storestock_check_r_no:self.sv_storestock_addshop_check_r_no];
        }
      
        for (NSInteger i = 0; i < self.selectModelArray.count; i++) {
            SVduoguigeModel *model = self.selectModelArray[i];
            model.list_number = i + 1;
        }
        [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVDetaildraftFirmOfferCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
        self.PrintingCollectionView.delegate = self;
        self.PrintingCollectionView.dataSource = self;
        
    }else{
        
        [self loadDataSv_storestock_check_r_no:self.model.sv_storestock_check_r_no];
        
        [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVDetaildraftFirmOfferCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
        self.PrintingCollectionView.delegate = self;
        self.PrintingCollectionView.dataSource = self;
    }
    
    NSLog(@"self.selectModelArray = %@",self.selectModelArray);
    
}

- (void)setviewinfo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadDataSv_storestock_check_r_no:(NSString *)sv_storestock_check_r_no{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/GetSelectStoreStockCheckApproveInfo?key=%@&sv_storestock_check_r_no=%@&getcheckdetailstate=true",[SVUserManager shareInstance].access_token,sv_storestock_check_r_no];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic详情 = %@",dic);
        //         self.modelArr = [SVPandianDetailModel mj_objectArrayWithKeyValuesArray:self.model.storeStockCheckDetail];
        if ([dic[@"succeed"] intValue] == 1) {
            NSDictionary *dict = dic[@"values"];
            if (!kDictIsEmpty(dict)) {
                NSArray *array=dic[@"values"][@"storeStockCheckDetail"];
                if (!kArrayIsEmpty(array)) {
                    self.modelArr = [SVPandianDetailModel mj_objectArrayWithKeyValuesArray:array];
                }
                
                NSLog(@"self.modelArr = %@",self.modelArr);
                
                self.sv_storestock_check_no = dic[@"values"][@"sv_storestock_check_no"];
                self.sv_storestock_check_r_no = dic[@"values"][@"sv_storestock_check_r_no"];
                
                // 盈亏数量
                double number_num = 0;
                double number_store = 0;
                
                double cost_num = 0;
                // int cost_store = 0;
                double money_num = 0;
                for (NSInteger i = 0; i < self.modelArr.count; i++) {
                    
                    SVPandianDetailModel *model = self.modelArr[i];
                    
                    model.number = i + 1;
                    if ([model.sv_storestock_checkdetail_checknum isEqualToString:@"-1"]) {
                        
                    }else{
                        number_num += model.sv_storestock_checkdetail_checknum.doubleValue;
                        number_store += model.sv_storestock_checkdetail_checkbeforenum.doubleValue;
                        
                        cost_num += (model.sv_storestock_checkdetail_checknum.doubleValue - model.sv_storestock_checkdetail_checkbeforenum.doubleValue) * model.sv_storestock_checkdetail_checkoprice.doubleValue;
                        
                        money_num += (model.sv_storestock_checkdetail_checknum.doubleValue - model.sv_storestock_checkdetail_checkbeforenum.doubleValue) * model.sv_storestock_checkdetail_checkprice.doubleValue;
                    }
                    
                    
                    NSLog(@"----money_num = %i",money_num);
                    // cost_store += model.sv_storestock_checkdetail_checkbeforenum.intValue;
                }
                
                self.number_num =number_num - number_store;
                self.cost_num = cost_num;
                self.money_num = money_num;
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}


- (void)setUpTableView{
    if (self.selectNum == 1) {// 是从完成
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight-BottomHeight)];
        //  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }else if (self.selectNum == 4){
        // self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        if ([self.model.sv_storestock_check_r_status_name containsString:@"待审核"]) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight-60-BottomHeight)];
            
        }else{
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight-BottomHeight)];
        }
    }else if (self.selectNum == 3){
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight - 60-BottomHeight)];
    }else if (self.selectNum == 5){
        if ([self.model.sv_storestock_check_r_status_name containsString:@"待审核"]) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-60-BottomHeight)];
            
        }else{
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-BottomHeight)];
        }
    }else{
        if ([self.model.sv_storestock_check_r_status_name containsString:@"待审核"]) {
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight-60-BottomHeight)];
            
        }else{
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight-BottomHeight)];
        }
        
    }
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVInvenDetaiCell" bundle:nil] forCellReuseIdentifier:inventoryCellID];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置tableView的估算高度
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)setUpbottomView_two{
    
    if (self.selectNum == 3) {
        UIView *bottomView_two = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-TopHeight - 60-BottomHeight, ScreenW, 60)];
        bottomView_two.backgroundColor = [UIColor redColor];
        [self.view addSubview:bottomView_two];
        
        UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cleanBtn addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
        [cleanBtn setTitle:@"删除" forState:UIControlStateNormal];
        [cleanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [cleanBtn setBackgroundColor:[UIColor whiteColor]];
        [cleanBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [bottomView_two addSubview:cleanBtn];
        [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bottomView_two.mas_left);
            make.width.mas_equalTo(ScreenW /3 * 1);
            make.top.mas_equalTo(bottomView_two.mas_top);
            make.bottom.mas_equalTo(bottomView_two.mas_bottom);
        }];
        
        UIButton *temporaryDraftBtn_two = [UIButton buttonWithType:UIButtonTypeCustom];
        self.temporaryDraftBtn_two = temporaryDraftBtn_two;
        [temporaryDraftBtn_two addTarget:self action:@selector(temporaryDraftClick_two) forControlEvents:UIControlEventTouchUpInside];
        [temporaryDraftBtn_two setTitle:@"暂存草稿" forState:UIControlStateNormal];
        [temporaryDraftBtn_two.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [temporaryDraftBtn_two setBackgroundColor:BackgroundColor];
        [temporaryDraftBtn_two setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [bottomView_two addSubview:temporaryDraftBtn_two];
        [temporaryDraftBtn_two mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cleanBtn.mas_right);
            make.width.mas_equalTo(ScreenW /3 *1);
            make.top.mas_equalTo(bottomView_two.mas_top);
            make.bottom.mas_equalTo(bottomView_two.mas_bottom);
        }];
        
        UIButton *physicalCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //  physicalCountBtn.userInteractionEnabled = NO;
        self.physicalCountBtn = physicalCountBtn;
        //        physicalCountBtn
        [physicalCountBtn addTarget:self action:@selector(physicalCountClick) forControlEvents:UIControlEventTouchUpInside];
        [physicalCountBtn setTitle:@"完成盘点" forState:UIControlStateNormal];
        [physicalCountBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [physicalCountBtn setBackgroundColor:navigationBackgroundColor];
        [physicalCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomView_two addSubview:physicalCountBtn];
        [physicalCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(temporaryDraftBtn_two.mas_right);
            make.width.mas_equalTo(ScreenW /3*1);
            make.height.mas_equalTo(60);
            make.bottom.mas_equalTo(bottomView_two.mas_bottom);
        }];
    }else if (self.selectNum == 2){
        if ([self.model.sv_storestock_check_r_status_name containsString:@"待审核"]) {
            UIView *bottomView_two = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-TopHeight - 60-BottomHeight, ScreenW, 60)];
            bottomView_two.backgroundColor = [UIColor redColor];
            [self.view addSubview:bottomView_two];
            
            UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cleanBtn addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
            [cleanBtn setTitle:@"删除" forState:UIControlStateNormal];
            [cleanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [cleanBtn setBackgroundColor:[UIColor whiteColor]];
            [cleanBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:cleanBtn];
            [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(bottomView_two.mas_left);
                make.width.mas_equalTo(ScreenW /3 * 1);
                make.top.mas_equalTo(bottomView_two.mas_top);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
            
            UIButton *ContinueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [ContinueBtn addTarget:self action:@selector(ContinueBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [ContinueBtn setTitle:@"继续盘点" forState:UIControlStateNormal];
            [ContinueBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [ContinueBtn setBackgroundColor:[UIColor colorWithHexString:@"879dff"]];
            [ContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:ContinueBtn];
            [ContinueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cleanBtn.mas_right);
                make.width.mas_equalTo(ScreenW /3*1);
                make.height.mas_equalTo(60);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
            
            UIButton *physicalCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [physicalCountBtn addTarget:self action:@selector(physicalCountClick) forControlEvents:UIControlEventTouchUpInside];
            [physicalCountBtn setTitle:@"完成盘点" forState:UIControlStateNormal];
            [physicalCountBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [physicalCountBtn setBackgroundColor:navigationBackgroundColor];
            [physicalCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:physicalCountBtn];
            [physicalCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ContinueBtn.mas_right);
                make.width.mas_equalTo(ScreenW /3*1);
                make.height.mas_equalTo(60);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
        }
        
    }else if (self.selectNum == 4){
        if ([self.model.sv_storestock_check_r_status_name containsString:@"待审核"]) {
            UIView *bottomView_two = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - TopHeight - 60-BottomHeight, ScreenW, 60)];
            bottomView_two.backgroundColor = [UIColor redColor];
            [self.view addSubview:bottomView_two];
            
            UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cleanBtn addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
            [cleanBtn setTitle:@"删除" forState:UIControlStateNormal];
            [cleanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [cleanBtn setBackgroundColor:[UIColor whiteColor]];
            [cleanBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:cleanBtn];
            [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(bottomView_two.mas_left);
                make.width.mas_equalTo(ScreenW /3 * 1);
                make.top.mas_equalTo(bottomView_two.mas_top);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
            
            UIButton *ContinueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [ContinueBtn addTarget:self action:@selector(ContinueBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [ContinueBtn setTitle:@"继续盘点" forState:UIControlStateNormal];
            [ContinueBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [ContinueBtn setBackgroundColor:[UIColor colorWithHexString:@"879dff"]];
            [ContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:ContinueBtn];
            [ContinueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cleanBtn.mas_right);
                make.width.mas_equalTo(ScreenW /3*1);
                make.height.mas_equalTo(60);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
            
            
            UIButton *physicalCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [physicalCountBtn addTarget:self action:@selector(physicalCountClick) forControlEvents:UIControlEventTouchUpInside];
            [physicalCountBtn setTitle:@"完成盘点" forState:UIControlStateNormal];
            [physicalCountBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [physicalCountBtn setBackgroundColor:navigationBackgroundColor];
            [physicalCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:physicalCountBtn];
            [physicalCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ContinueBtn.mas_right);
                make.width.mas_equalTo(ScreenW /3*1);
                make.height.mas_equalTo(60);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
        }
    }else if (self.selectNum == 5){
        if ([self.model.sv_storestock_check_r_status_name containsString:@"待审核"]) {
            UIView *bottomView_two = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 60-BottomHeight, ScreenW, 60)];
            bottomView_two.backgroundColor = [UIColor redColor];
            [self.view addSubview:bottomView_two];
            
            UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cleanBtn addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
            [cleanBtn setTitle:@"删除" forState:UIControlStateNormal];
            [cleanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [cleanBtn setBackgroundColor:[UIColor whiteColor]];
            [cleanBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:cleanBtn];
            [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(bottomView_two.mas_left);
                make.width.mas_equalTo(ScreenW /3 * 1);
                make.top.mas_equalTo(bottomView_two.mas_top);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
            
            UIButton *ContinueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [ContinueBtn addTarget:self action:@selector(ContinueBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [ContinueBtn setTitle:@"继续盘点" forState:UIControlStateNormal];
            [ContinueBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [ContinueBtn setBackgroundColor:[UIColor colorWithHexString:@"879dff"]];
            [ContinueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:ContinueBtn];
            [ContinueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cleanBtn.mas_right);
                make.width.mas_equalTo(ScreenW /3*1);
                make.height.mas_equalTo(60);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
            
            UIButton *physicalCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [physicalCountBtn addTarget:self action:@selector(physicalCountClick) forControlEvents:UIControlEventTouchUpInside];
            [physicalCountBtn setTitle:@"完成盘点" forState:UIControlStateNormal];
            [physicalCountBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [physicalCountBtn setBackgroundColor:navigationBackgroundColor];
            [physicalCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bottomView_two addSubview:physicalCountBtn];
            [physicalCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ContinueBtn.mas_right);
                make.width.mas_equalTo(ScreenW /3*1);
                make.height.mas_equalTo(60);
                make.bottom.mas_equalTo(bottomView_two.mas_bottom);
            }];
        }
        
    }
    
}

#pragma mark - 暂存草稿
- (void)temporaryDraftClick_two{
    self.temporaryDraftBtn_two.userInteractionEnabled = NO;
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
        
        dic[@"sv_storestock_checkdetail_pid"] = [NSString stringWithFormat:@"%@",model.product_id];
        dic[@"sv_checkdetail_pricing_method"] = [NSString stringWithFormat:@"%@",model.sv_pricing_method];
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
        
        dic[@"sv_storestock_checkdetail_checkoprice"] = [NSString stringWithFormat:@"%@",model.sv_p_originalprice];
        if (kStringIsEmpty(model.sv_p_storage)) {
            dic[@"sv_storestock_checkdetail_checkbeforenum"] = @(0);
        }else{
//            dic[@"sv_storestock_checkdetail_checkbeforenum"] = [NSString stringWithFormat:@"%@",model.sv_p_storage];
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
    //  sv_storestock_checkdetail_checkbeforenum
    
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
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您未输入实盘，确定保存草稿吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //解释数据
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"dic是否成功 = %@",dic);
                NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                
                if ([suc isEqualToString:@"1"]) {
                   // [SVTool TextButtonAction:self.view withSing:@"暂存草稿成功"];
                    [SVTool TextButtonActionWithSing:@"暂存草稿成功"];
                    if (self.jixupandianNum == 1) {
                        // 返回到任意界面
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[SVHomeVC class]]) {
                                
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                        }
                    }else{
                        self.physicalCountBtn.userInteractionEnabled = YES;
                        [self.physicalCountBtn setBackgroundColor:navigationBackgroundColor];
                        self.temporaryDraftBtn_two.userInteractionEnabled = NO;
                        [self.temporaryDraftBtn_two setBackgroundColor:BackgroundColor];
                        self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                        if (self.successBlock) {
                            self.successBlock();
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
            
                }else{
                   // [SVTool TextButtonAction:self.view withSing:@"保存失败"];
                    [SVTool TextButtonActionWithSing:@"保存失败"];
                }
                self.temporaryDraftBtn_two.userInteractionEnabled = YES;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                self.temporaryDraftBtn_two.userInteractionEnabled = YES;
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
        
        self.countNum = array.count - FirmOfferNumArray.count;
        // parame[@"requestInventory"] =
        
        [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解释数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic是否成功 = %@",dic);
            NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
            
            if ([suc isEqualToString:@"1"]) {
               // [SVTool TextButtonAction:self.view withSing:@"暂存草稿成功"];
                [SVTool TextButtonActionWithSing:@"暂存草稿成功"];
                if (self.jixupandianNum == 1) {
                    // 返回到任意界面
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[SVHomeVC class]]) {
                            
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                }else{
                    self.physicalCountBtn.userInteractionEnabled = YES;
                    [self.physicalCountBtn setBackgroundColor:navigationBackgroundColor];
                    self.temporaryDraftBtn_two.userInteractionEnabled = NO;
                    [self.temporaryDraftBtn_two setBackgroundColor:BackgroundColor];
                    self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                    if (self.successBlock) {
                        self.successBlock();
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
           
            }else{
               // [SVTool TextButtonAction:self.view withSing:@"保存失败"];
                [SVTool TextButtonActionWithSing:@"保存失败"];
            }
            self.temporaryDraftBtn_two.userInteractionEnabled = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            self.temporaryDraftBtn_two.userInteractionEnabled = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    }
    
}

#pragma mark - 继续盘点
- (void)ContinueBtnClick{
    SVNewStockCheckVC *vc = [[SVNewStockCheckVC alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    for (SVPandianDetailModel *model in self.modelArr) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        dictM[@"product_id"] = model.sv_storestock_checkdetail_pid;
        dictM[@"sv_pricing_method"] = model.sv_checkdetail_pricing_method;
        dictM[@"sv_p_barcode"] = model.sv_storestock_checkdetail_pbcode;
        dictM[@"sv_p_name"] = model.sv_storestock_checkdetail_pname;
        dictM[@"sv_p_specs"] = model.sv_storestock_checkdetail_specs;
        dictM[@"sv_p_unit"] = model.sv_storestock_checkdetail_unit;
        dictM[@"v_p_unitprice"] = model.sv_storestock_checkdetail_checkprice;
        dictM[@"sv_p_originalprice"] = model.sv_storestock_checkdetail_checkoprice;
       // dictM[@"sv_p_storage"] = model.sv_storestock_checkdetail_checkbeforenum;
        dictM[@"productcategory_id"] = model.sv_storestock_checkdetail_categoryid;
        dictM[@"sv_pc_name"] = model.sv_storestock_checkdetail_categoryname;
        dictM[@"sv_remark"] = model.sv_remark;
        
        if ([model.sv_storestock_checkdetail_checkbeforenum isEqualToString:@"0"]) {
            dictM[@"sv_p_storage"] = @"";
        }else{
            dictM[@"sv_p_storage"] = model.sv_storestock_checkdetail_checkbeforenum;
        }
        
       dictM[@"sv_storestock_checkdetail_id"] =  model.sv_storestock_checkdetail_id;
        
        if ([model.sv_storestock_checkdetail_checknum isEqualToString:@"-1"]) {
             dictM[@"FirmOfferNum"] = @"";
        }else{
             dictM[@"FirmOfferNum"] = model.sv_storestock_checkdetail_checknum;
        }
        
        dictM[@"sv_storestock_check_list_no"] = model.sv_storestock_check_list_no;
        dictM[@"sv_checkdetail_type"] = @"1";
        dictM[@"isSelect"] = @"1";
        [array addObject:dictM];
    }
    vc.modelArr = array;
    vc.sv_storestock_check_no = self.sv_storestock_check_no;
    vc.sv_storestock_check_r_no = self.model.sv_storestock_check_r_no;
    vc.selectNumber = 1;
    self.jixupandianNum = 1; //
    vc.addShopTotleNum = self.modelArr.count;
    vc.modelArrayBlock = ^(NSString * _Nonnull sv_storestock_check_r_no, NSString * _Nonnull values) {
        [self loadDataSv_storestock_check_r_no:sv_storestock_check_r_no];
        self.values = values;
    };

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 删除草稿
- (void)cleanClick{
    if (self.selectNum == 3) {
        if (self.jixupandianNum == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要删除该草稿吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [SVUserManager loadUserInfo];
                NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/DeleteStoreStockCheckBatchNum?key=%@&sv_storestock_check_no=%@&sv_storestock_check_r_no=%@",[SVUserManager shareInstance].access_token,self.sv_storestock_check_no,self.sv_storestock_check_r_no];
                
                [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //解释数据
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                    if ([suc isEqualToString:@"1"]) {
                       // [SVTool TextButtonAction:self.view withSing:@"删除草稿成功"];
                        [SVTool TextButtonActionWithSing:@"删除草稿成功"];
                        //            self.physicalCountBtn.userInteractionEnabled = YES;
                        //            self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                        
                        // 返回到任意界面
                        for (UIViewController *temp in self.navigationController.viewControllers) {
                            if ([temp isKindOfClass:[SVHomeVC class]]) {
                                
                                [self.navigationController popToViewController:temp animated:YES];
                            }
                        }
                        
//                        if (self.successBlock) {
//                            self.successBlock();
//                        }
//
//
//
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
//
//                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                       // [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                        [SVTool TextButtonActionWithSing:dic[@"errmsg"]];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
            if (self.successBlock) {
                self.successBlock();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
     
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要删除该草稿吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [SVUserManager loadUserInfo];
            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/DeleteStoreStockCheckBatchNum?key=%@&sv_storestock_check_no=%@&sv_storestock_check_r_no=%@",[SVUserManager shareInstance].access_token,self.sv_storestock_check_no,self.sv_storestock_check_r_no];
            
            [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //解释数据
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                if ([suc isEqualToString:@"1"]) {
                   // [SVTool TextButtonAction:self.view withSing:@"删除草稿成功"];
                    [SVTool TextButtonActionWithSing:@"删除草稿成功"];
                    //            self.physicalCountBtn.userInteractionEnabled = YES;
                    //            self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                    if (self.successBlock) {
                        self.successBlock();
                    }
                    
                    
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    //[SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                    [SVTool TextButtonActionWithSing:dic[@"errmsg"]];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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



#pragma mark - 完成盘点
- (void)physicalCountClick{
    
    if (self.jixupandianNum == 1) {
        
        if (self.selectNum == 3) { //是已添加商品
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
                
                dic[@"sv_storestock_checkdetail_pid"] = [NSString stringWithFormat:@"%@",model.product_id];
                dic[@"sv_checkdetail_pricing_method"] = [NSString stringWithFormat:@"%@",model.sv_pricing_method];
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
                                  //  [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                                    [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                                    // 返回到任意界面
                                    for (UIViewController *temp in self.navigationController.viewControllers) {
                                        if ([temp isKindOfClass:[SVHomeVC class]]) {
                                            
                                            [self.navigationController popToViewController:temp animated:YES];
                                        }
                                    }
                                    
//                                    if (self.successBlock) {
//                                        self.successBlock();
//                                    }
//
//                                    // 发送通知给接受通知的页面刷新
//                                    //                                if (self.selectNum == 5) {
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
//                                    //                                }
//
//
//                                    [self.navigationController popViewControllerAnimated:YES];
                                }else{
                                    //                                [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                                    [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                                }
                                
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                //隐藏提示框
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                //        [SVTool requestFailed];
                                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            }];
                            
                            
                        }else{
                            [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                        }
                        self.physicalCountBtn.userInteractionEnabled = YES;
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        self.physicalCountBtn.userInteractionEnabled = YES;
                        //隐藏提示框
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        //        [SVTool requestFailed];
                        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    }];
                    
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您确定要完成该盘点吗？(%ld)种商品未盘",countNum] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    // [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
                    
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
                                      //  [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                                        [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                                        //            self.physicalCountBtn.userInteractionEnabled = YES;
                                        //            self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                                        
                                        // 返回到任意界面
                                        for (UIViewController *temp in self.navigationController.viewControllers) {
                                            if ([temp isKindOfClass:[SVHomeVC class]]) {
                                                
                                                [self.navigationController popToViewController:temp animated:YES];
                                            }
                                        }
                                        
//                                        if (self.successBlock) {
//                                            self.successBlock();
//                                        }
//
//                                        //                                    if (self.selectNum == 5) {
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
//                                        //                                    }
//
//                                        [self.navigationController popViewControllerAnimated:YES];
                                    }else{
                                        //[SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                                        [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                                    }
                                    
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    //隐藏提示框
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    //        [SVTool requestFailed];
                                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                                }];
                                //                            if (self.successBlock) {
                                //                                self.successBlock();
                                //                            }
                                
                            }else{
                                //  [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                                [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                            }
                            self.physicalCountBtn.userInteractionEnabled = YES;
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            self.physicalCountBtn.userInteractionEnabled = YES;
                            //隐藏提示框
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //        [SVTool requestFailed];
                            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                        }];
                        
                        
                    }];
                    //  [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
                    
                    [alert addAction:cancelAction];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }
        }else{
            [SVUserManager loadUserInfo];
            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/AppSelectStoreStockCheckInfo?key=%@&sv_storestock_check_no=%@",[SVUserManager shareInstance].access_token,self.values];
            //        [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //
            //        }];
            [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //解释数据
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                if ([suc isEqualToString:@"1"]) {
                   // [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                    [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                    if (self.successBlock) {
                        self.successBlock();
                    }
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //隐藏提示框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //        [SVTool requestFailed];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            }];
        }
 
    }else{
        
        if (self.selectNum == 3) {
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
                
                dic[@"sv_storestock_checkdetail_pid"] = [NSString stringWithFormat:@"%@",model.product_id];
                dic[@"sv_checkdetail_pricing_method"] = [NSString stringWithFormat:@"%@",model.sv_pricing_method];
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

            
            if (kArrayIsEmpty(FirmOfferNumArray)) {
                
                ALERT(@"未输入实盘，不能盘点");
            }else{
                
                NSInteger countNum = array.count - FirmOfferNumArray.count;
                
                if (countNum == 0) {
                    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                    
                    [parame setObject:array forKey:@"StoreStockCheckDetail"];
                    
                    //  self.countNum = array.count - FirmOfferNumArray.count;
                    // parame[@"requestInventory"] =
                    
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
                                 //   [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                                    [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                                    
                                    if (self.successBlock) {
                                        self.successBlock();
                                    }
                                    
                                    // 发送通知给接受通知的页面刷新
                                    //                                if (self.selectNum == 5) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                                    //                                }
                                    
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                }else{
                                    //                                [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                                    [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                                }
                                
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                //隐藏提示框
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                //        [SVTool requestFailed];
                                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            }];
                            
                            
                        }else{
                            [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                        }
                        self.physicalCountBtn.userInteractionEnabled = YES;
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        self.physicalCountBtn.userInteractionEnabled = YES;
                        //隐藏提示框
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        //        [SVTool requestFailed];
                        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    }];
                    
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您确定要完成该盘点吗？(%ld)种商品未盘",countNum] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    // [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
                    
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                        
                        [parame setObject:array forKey:@"StoreStockCheckDetail"];
                        
                        //  self.countNum = array.count - FirmOfferNumArray.count;
                        // parame[@"requestInventory"] =
                        
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
                                       // [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                                        [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                                        //            self.physicalCountBtn.userInteractionEnabled = YES;
                                        //            self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                                        if (self.successBlock) {
                                            self.successBlock();
                                        }
                                        
                                        //                                    if (self.selectNum == 5) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                                        //                                    }
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }else{
                                        //[SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                                        [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                                    }
                                    
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    //隐藏提示框
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    //        [SVTool requestFailed];
                                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                                }];
                                //                            if (self.successBlock) {
                                //                                self.successBlock();
                                //                            }
                                
                            }else{
                                //  [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                                [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                            }
                            self.physicalCountBtn.userInteractionEnabled = YES;
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            self.physicalCountBtn.userInteractionEnabled = YES;
                            //隐藏提示框
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //        [SVTool requestFailed];
                            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                        }];
                        
                        
                    }];
                    //  [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
                    
                    [alert addAction:cancelAction];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }
        }else{
            self.physicalCountBtn.userInteractionEnabled = NO;
            [SVUserManager loadUserInfo];
            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Repertory/AddStoreStockCheckRecordInfoWithBatchNumber?key=%@",[SVUserManager shareInstance].access_token];
            
            NSMutableArray *array = [NSMutableArray array];
            NSMutableArray *FirmOfferNumArray = [NSMutableArray array];
            for (SVPandianDetailModel *model in self.modelArr) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"sv_storestock_checkdetail_id"] = model.sv_storestock_checkdetail_id;
                dic[@"sv_checkdetail_type"] = @"1";
                dic[@"sv_storestock_checkdetail_pid"] = model.sv_storestock_checkdetail_pid;
                dic[@"sv_checkdetail_pricing_method"] = model.sv_checkdetail_pricing_method;
                dic[@"sv_storestock_checkdetail_pbcode"] = model.sv_storestock_checkdetail_pbcode;
                dic[@"sv_storestock_checkdetail_pname"] = model.sv_storestock_checkdetail_pname;
                dic[@"sv_storestock_checkdetail_specs"] = model.sv_storestock_checkdetail_specs;
                dic[@"sv_storestock_checkdetail_unit"] = model.sv_storestock_checkdetail_unit;
                dic[@"sv_storestock_checkdetail_checkprice"] = model.sv_storestock_checkdetail_checkprice;
                dic[@"sv_storestock_checkdetail_checkoprice"] = model.sv_storestock_checkdetail_checkoprice;
                if (kStringIsEmpty(model.sv_storestock_checkdetail_checkbeforenum)) {
                    dic[@"sv_storestock_checkdetail_checkbeforenum"] = @(0);
                }else{
                    dic[@"sv_storestock_checkdetail_checkbeforenum"] = model.sv_storestock_checkdetail_checkbeforenum;
                }
                //            StoreStockCheckDetail
                //  dic[@"sv_storestock_checkdetail_checkbeforenum"] = @"0";
                dic[@"sv_storestock_checkdetail_categoryid"] = model.sv_storestock_checkdetail_categoryid;
                dic[@"sv_storestock_checkdetail_categoryname"] = model.sv_storestock_checkdetail_categoryname;
                dic[@"sv_remark"] = model.sv_remark;
                
                if ([model.sv_storestock_checkdetail_checknum isEqualToString:@"-1"]) {
                    dic[@"sv_storestock_checkdetail_checknum"] = @"-1";
                }else{
                    dic[@"sv_storestock_checkdetail_checknum"] = model.sv_storestock_checkdetail_checknum;
                    [FirmOfferNumArray addObject:dic];
                }
                [array addObject:dic];
            }
            
            if (kArrayIsEmpty(FirmOfferNumArray)) {
                
                ALERT(@"未输入实盘，不能盘点");
            }else{
                
                NSInteger countNum = array.count - FirmOfferNumArray.count;
                
                if (countNum == 0) {
                    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                    
                    [parame setObject:array forKey:@"StoreStockCheckDetail"];
                    [parame setObject:self.sv_storestock_check_no forKey:@"sv_storestock_check_no"];
                    [parame setObject:self.sv_storestock_check_r_no forKey:@"sv_storestock_check_r_no"];
                    
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
                                NSLog(@"dic555555 = %@",dic);
                                NSString *suc = [NSString stringWithFormat:@"%@",dic[@"succeed"]];
                                
                                if ([suc isEqualToString:@"1"]) {
                                  //  [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                                    [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                                    if (self.successBlock) {
                                        self.successBlock();
                                    }
                                    
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                                    
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                }else{
                                    [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                                }
                                
                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                //隐藏提示框
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                //        [SVTool requestFailed];
                                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                            }];
                            
                            
                        }else{
                            [SVTool TextButtonAction:self.view withSing:@"盘点异常"];
                        }
                        self.physicalCountBtn.userInteractionEnabled = YES;
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        self.physicalCountBtn.userInteractionEnabled = YES;
                        //隐藏提示框
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        //        [SVTool requestFailed];
                        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    }];
                    
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您确定要完成该盘点吗？(%ld)种商品未盘",countNum] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
                    
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
                        
                        [parame setObject:array forKey:@"StoreStockCheckDetail"];
                        [parame setObject:self.sv_storestock_check_no forKey:@"sv_storestock_check_no"];
                        [parame setObject:self.sv_storestock_check_r_no forKey:@"sv_storestock_check_r_no"];
                        //  self.countNum = array.count - FirmOfferNumArray.count;
                        // parame[@"requestInventory"] =
                        
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
                                      //  [SVTool TextButtonAction:self.view withSing:@"完成盘点成功"];
                                        [SVTool TextButtonActionWithSing:@"完成盘点成功"];
                                        //            self.physicalCountBtn.userInteractionEnabled = YES;
                                        //            self.values = [NSString stringWithFormat:@"%@",dic[@"values"]];
                                        if (self.successBlock) {
                                            self.successBlock();
                                        }
                                        
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName1" object:nil];
                                        
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }else{
                                        [SVTool TextButtonAction:self.view withSing:@"盘点异常"];
                                    }
                                    
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    //隐藏提示框
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    //        [SVTool requestFailed];
                                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                                }];
                            }else{
                                // [SVTool TextButtonAction:self.view withSing:dic[@"errmsg"]];
                                [SVTool TextButtonAction:self.view withSing:@"盘点失败"];
                            }
                            self.physicalCountBtn.userInteractionEnabled = YES;
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
    
   
}

//展示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.selectNum == 3) {
        self.inventoryTopView = [[NSBundle mainBundle] loadNibNamed:@"SVInventoryTopView" owner:nil options:nil].lastObject;
        
        self.inventoryTopView.pandiandanhaoL.text = @"盘点单号：--";
        self.inventoryTopView.caogaoL.hidden = YES;
        
        self.inventoryTopView.caogaoL.layer.cornerRadius = self.inventoryTopView.caogaoL.height / 2;
        self.inventoryTopView.caogaoL.layer.masksToBounds = YES;
        
        self.inventoryTopView.totleshopL.text = [NSString stringWithFormat:@"共%ld种商品",self.selectModelArray.count];
        self.inventoryTopView.nameL.text = @"盘点人：--";
        //        NSString *time = [self.model.sv_creation_date stringByReplacingOccurrencesOfString:@" " withString:@"T"];//替换字符
        //        self.inventoryTopView.timeL.text = time;
        
        if (self.model.sv_creation_date.length < 19) {
            self.inventoryTopView.timeL.text = self.model.sv_creation_date;
        }else{
            self.inventoryTopView.timeL.text =[self.model.sv_creation_date substringToIndex:19];//截取掉下标2之前的字符串
            if ([self.inventoryTopView.timeL.text containsString:@"T"]) {
                NSString *string = [self.inventoryTopView.timeL.text stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                self.inventoryTopView.timeL.text = string;
            }
        }
        
        self.inventoryTopView.number_num.text = @"--";
        
        self.inventoryTopView.cost_num.text = @"--";
        
        self.inventoryTopView.money_num.text = @"--";
        
        
        [self.inventoryTopView.costDeficifBtn addTarget:self action:@selector(costDeficifClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.inventoryTopView.moneyDeficifBtn addTarget:self action:@selector(moneyDeficifBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.inventoryTopView = [[NSBundle mainBundle] loadNibNamed:@"SVInventoryTopView" owner:nil options:nil].lastObject;
        
        self.inventoryTopView.pandiandanhaoL.text = [NSString stringWithFormat:@"盘点单号：%@",self.model.sv_storestock_check_r_no];
        if ([self.model.sv_storestock_check_r_status_name isEqualToString:@"待审核"]) {
            self.inventoryTopView.caogaoL.text = @"草稿";
        }else{
            self.inventoryTopView.caogaoL.text = @"完成";
        }
        
        self.inventoryTopView.caogaoL.layer.cornerRadius = self.inventoryTopView.caogaoL.height / 2;
        self.inventoryTopView.caogaoL.layer.masksToBounds = YES;
        
        self.inventoryTopView.totleshopL.text = [NSString stringWithFormat:@"共%@种商品",self.model.productnum];
        self.inventoryTopView.nameL.text = [NSString stringWithFormat:@"盘点人：%@",self.model.sv_storestock_check_r_opter];
        
        if (self.model.sv_creation_date.length < 19) {
            self.inventoryTopView.timeL.text = self.model.sv_creation_date;
        }else{
            self.inventoryTopView.timeL.text =[self.model.sv_creation_date substringToIndex:19];//截取掉下标2之前的字符串
            if ([self.inventoryTopView.timeL.text containsString:@"T"]) {
                NSString *string = [self.inventoryTopView.timeL.text stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                self.inventoryTopView.timeL.text = string;
            }
        }
        
        if (self.number_num > 0) {
            self.inventoryTopView.number_num.text = [NSString stringWithFormat:@"%.2f",self.number_num];
        }else if (self.number_num == 0){
            self.inventoryTopView.number_pingheng.hidden = NO;
            self.inventoryTopView.number_text.hidden = YES;
            self.inventoryTopView.number_num.hidden = YES;
        }else{
            self.inventoryTopView.number_num.text = [NSString stringWithFormat:@"%.2f",fabs(self.number_num)];
            self.inventoryTopView.number_num.textColor = navigationBackgroundColor;
            self.inventoryTopView.number_text.text = @"亏";
            self.inventoryTopView.number_text.textColor = navigationBackgroundColor;
        }
        
        if (self.cost_num > 0) {
            self.inventoryTopView.cost_num.text = [NSString stringWithFormat:@"%.2f",self.cost_num];
        }else if (self.cost_num == 0){
            self.inventoryTopView.cost_pingheng.hidden = NO;
            self.inventoryTopView.cost_text.hidden = YES;
            self.inventoryTopView.cost_num.hidden = YES;
        }else{
            self.inventoryTopView.cost_num.text = [NSString stringWithFormat:@"%.2f",fabs(self.cost_num)];
            self.inventoryTopView.cost_num.textColor = navigationBackgroundColor;
            self.inventoryTopView.cost_text.text = @"亏";
            self.inventoryTopView.cost_text.textColor = navigationBackgroundColor;
        }
        
        
        if (self.money_num > 0) {
            self.inventoryTopView.money_num.text = [NSString stringWithFormat:@"%.2f",self.money_num];
        }else if (self.money_num == 0){
            self.inventoryTopView.money_pingheng.hidden = NO;
            self.inventoryTopView.money_text.hidden = YES;
            self.inventoryTopView.money_num.hidden = YES;
        }else{
            self.inventoryTopView.money_num.text = [NSString stringWithFormat:@"%.2f",fabs(self.money_num)];
            self.inventoryTopView.money_num.textColor = navigationBackgroundColor;
            self.inventoryTopView.money_text.text = @"亏";
            self.inventoryTopView.money_text.textColor = navigationBackgroundColor;
        }
        
        
        
        [self.inventoryTopView.costDeficifBtn addTarget:self action:@selector(costDeficifClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.inventoryTopView.moneyDeficifBtn addTarget:self action:@selector(moneyDeficifBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self.inventoryTopView;
}

- (void)costDeficifClick{
    ALERT(@"盈亏成本=(实盘数-库存数)*成本价");
}

- (void)moneyDeficifBtnClick{
    ALERT(@"盈亏金额=(实盘数-库存数)*售价");
}

//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 201;
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectNum == 3) {
        return self.selectModelArray.count;
    }else{
        return self.modelArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVInvenDetaiCell *cell = [tableView dequeueReusableCellWithIdentifier:inventoryCellID];
    if (!cell) {
        cell = [[SVInvenDetaiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inventoryCellID];
    }
    if (self.selectNum == 3) {
        cell.duoguigeModel = self.selectModelArray[indexPath.row];
    }else{
        cell.model = self.modelArr[indexPath.row];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectNum == 3) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
        [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
        [self.PrintingCollectionView reloadData];
        [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
    }else if (self.selectNum == 2){
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
        [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
        [self.PrintingCollectionView reloadData];
        [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
    }else if (self.selectNum == 4){
        if ([self.model.sv_storestock_check_r_status_name containsString:@"待审核"]) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
            [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
            [self.PrintingCollectionView reloadData];
            [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
        }
    }else if (self.selectNum == 5){
        if ([self.model.sv_storestock_check_r_status_name containsString:@"待审核"]) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
            [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
            [self.PrintingCollectionView reloadData];
            [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
        }
    }
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.selectNum == 3) {
        return self.selectModelArray.count;
    }else{
        return self.modelArr.count;
    }
    
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1 ;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectNum == 3) {
        SVDetaildraftFirmOfferCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
        cell.model = self.selectModelArray[indexPath.row];
        cell.sureBtn.tag = indexPath.row;
        __weak typeof(self) weakSelf = self;
        cell.sureBtnClickBlock = ^(NSInteger selctCount, SVduoguigeModel * _Nonnull model_two) {
            if (selctCount+ 1 == self.selectModelArray.count) {
                [weakSelf.selectModelArray replaceObjectAtIndex:selctCount withObject:model_two];
                
                [weakSelf handlePan];
                //             [weakSelf.PrintingCollectionView reloadData];
            }else{
                [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selctCount + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        };
        
        return cell;
    }else{
        SVDetaildraftFirmOfferCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
        cell.model_two = self.modelArr[indexPath.row];
        cell.sureBtn.tag = indexPath.row;
        __weak typeof(self) weakSelf = self;
        cell.sureBtnClickBlock_two = ^(NSInteger selctCount, SVPandianDetailModel * _Nonnull model_two) {
            if (selctCount+ 1 == self.modelArr.count) {
                [weakSelf.modelArr replaceObjectAtIndex:selctCount withObject:model_two];
                
                [weakSelf handlePan];
                
            }else{
                [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selctCount + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                
            }
            
        };
        
        return cell;
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

//移除
- (void)handlePan{
    
    if (self.selectNum == 3) {
        //        // 盈亏数量
        int number_num = 0;
        int number_store = 0;
        
        int cost_num = 0;
        // int cost_store = 0;
        int money_num = 0;
        for (NSInteger i = 0; i < self.selectModelArray.count; i++) {
            SVduoguigeModel *model = self.selectModelArray[i];
            model.list_number = i + 1;
            
            number_num += model.FirmOfferNum.doubleValue;
            number_store += model.sv_p_storage.doubleValue;
            
            cost_num += (model.FirmOfferNum.doubleValue - model.sv_p_storage.doubleValue) * model.sv_p_originalprice.doubleValue;
            
            money_num += (model.FirmOfferNum.doubleValue - model.sv_p_storage.doubleValue) * model.sv_p_unitprice.doubleValue;
            
        }
        
        self.number_num =number_num - number_store;
        self.cost_num = cost_num;
        self.money_num = money_num;
    }else{
        //        // 盈亏数量
        int number_num = 0;
        int number_store = 0;
        
        int cost_num = 0;
        // int cost_store = 0;
        int money_num = 0;
        for (NSInteger i = 0; i < self.modelArr.count; i++) {
            SVPandianDetailModel *model = self.modelArr[i];
            model.number = i + 1;
            
            number_num += model.sv_storestock_checkdetail_checknum.doubleValue;
            number_store += model.sv_storestock_checkdetail_checkbeforenum.doubleValue;
            
            cost_num += (model.sv_storestock_checkdetail_checknum.doubleValue - model.sv_storestock_checkdetail_checkbeforenum.doubleValue) * model.sv_storestock_checkdetail_checkoprice.doubleValue;
            
            money_num += (model.sv_storestock_checkdetail_checknum.doubleValue - model.sv_storestock_checkdetail_checkbeforenum.doubleValue) * model.sv_storestock_checkdetail_checkprice.doubleValue;
            
        }
        
        self.number_num =number_num - number_store;
        self.cost_num = cost_num;
        self.money_num = money_num;
    }
    
    
    [self.tableView reloadData];
    [self.maskTheView removeFromSuperview];
    [self.PrintingCollectionView removeFromSuperview];
    [self.icon_button removeFromSuperview];
    
}

- (NSMutableArray *)modelArr
{
    if (_modelArr == nil) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (UICollectionView *)PrintingCollectionView
{
    if (_PrintingCollectionView == nil) {
        SVAddShopFlowLayout *layout = [[SVAddShopFlowLayout alloc] init];
        
        _PrintingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight,ScreenW, 550) collectionViewLayout:layout];
        // _PrintingCollectionView.automaticallyAdjustsScrollViewInsets = false;
        _PrintingCollectionView.backgroundColor = [UIColor clearColor];
        // _PrintingCollectionView.showsVerticalScrollIndicator = NO;
        _PrintingCollectionView.showsHorizontalScrollIndicator = NO;
        
    }
    
    
    
    return _PrintingCollectionView;
}

- (UIImageView *)icon_imageView
{
    if (_icon_imageView == nil) {
        _icon_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_PrintingCollectionView.frame) - 20, 40, 40)];
        _icon_imageView.image = [UIImage imageNamed:@"close"];
    }
    
    return _icon_imageView;
}

- (UIButton *)icon_button
{
    if (_icon_button == nil) {
        _icon_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _icon_button.frame = CGRectMake(ScreenW /2 - 20, CGRectGetMaxY(_PrintingCollectionView.frame) - 20, 40, 40);
        [_icon_button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_icon_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _icon_button;
}

- (void)btnClick{
    [self handlePan];
}

///**
// 遮盖
// */
//-(UIView *)maskTheView{
//    if (!_maskTheView) {
//
//        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
//        [_maskTheView addGestureRecognizer:tap];
//
//    }
//
//    return _maskTheView;
//
//}


@end
