//
//  SVNewProductListVC.m
//  SAVI
//
//  Created by houming Wang on 2021/1/18.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewProductListVC.h"
#import "SVNewProductListCell.h"
#import "SVduoguigeModel.h"
#import "SVClassificationView.h"
#import "SVNewCommodityScreeningView.h"
#import "SVShopNavVC.h"
#import "SVNewShopDetailVC.h"
#import "SVSVNewShopDetailViewVC.h"
#import "SVAddMoreSpecificationsVC.h"
#import "SVLabelPrintingVC.h"
#import "SVWaresOneClassVC.h"
#import "SVClassficationModel.h"
#import "SVExpandBtn.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
static NSString *const ID = @"SVNewProductListCell";
@interface SVNewProductListVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *categoryView;
@property (weak, nonatomic) IBOutlet UIButton *sortView;
@property (weak, nonatomic) IBOutlet UIButton *earlyWarningView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SVExpandBtn *qrcode;
@property (nonatomic,strong) NSString *productsubcategory_id;// 小分类的ID
//记录刷新次数
@property (nonatomic,assign) NSInteger page;
//标记 从属于第几个一级分类
@property (nonatomic, assign) NSInteger tableviewIndex;
//商品模型数组
@property (nonatomic, strong) NSMutableArray *goodsModelArr;

@property (nonatomic,strong) NSString *productcategory_id;

//提示此分类没有商品
@property (nonatomic,strong) UIImageView *img;
//提示搜索没有此商品
@property (nonatomic,strong) UILabel *noWares;

@property (strong,nonatomic) UIButton *addButton;
//第一个tableViewcell的数组
@property (nonatomic, strong) NSMutableArray *bigNameArr;
@property (nonatomic, strong) NSMutableArray *bigIDArr;
/**
 * 是否点击
 */
@property (nonatomic ,assign) BOOL selected;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) SVClassificationView * classificationView;
@property (nonatomic,strong) SVNewCommodityScreeningView * newCommodityScreeningView;
//@property (nonatomic,strong) NSString * user_id;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**
 ^(NSString * _Nonnull user_id, NSString * _Nonnull Product_state, NSString * _Nonnull Stock_type, NSString * _Nonnull Stock_Min, NSString * _Nonnull Stock_Max, NSString * _Nonnull Stock_date_type, NSString * _Nonnull Stock_date_start, NSString * _Nonnull Stock_date_end, NSString * _Nonnull year, NSString * _Nonnull sv_brand_ids, NSString * _Nonnull fabric_ids)
 */
@property (nonatomic,strong) NSString * user_id;
@property (nonatomic,strong) NSString * Product_state;
@property (nonatomic,strong) NSString * Stock_type;
@property (nonatomic,strong) NSString * Stock_Min;
@property (nonatomic,strong) NSString * Stock_Max;
@property (nonatomic,strong) NSString * Stock_date_type;
@property (nonatomic,strong) NSString * Stock_date_start;
@property (nonatomic,strong) NSString * Stock_date_end;
@property (nonatomic,strong) NSString * year;
@property (nonatomic,strong) NSString * sv_brand_ids;
@property (nonatomic,strong) NSString * fabric_ids;


@property (nonatomic,strong) NSString * Pc_ids;//一级分类
@property (nonatomic,strong) NSString * Psc_ids; // 二级分类
@property (weak, nonatomic) IBOutlet UIButton *screenBtn;
@property (nonatomic,strong) NSMutableArray * categaryArray;
@end

@implementation SVNewProductListVC
- (NSMutableArray *)categaryArray
{
    if (!_categaryArray) {
        _categaryArray = [NSMutableArray array];
    }
    return _categaryArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.topView.backgroundColor = navigationBackgroundColor;
    self.categoryView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.categoryView.layer.borderWidth = 1;
    self.categoryView.layer.cornerRadius = 5;
    self.categoryView.layer.masksToBounds = YES;
    self.categoryView.alpha = 0.5;
    
    self.contentLabel.textColor = GlobalFontColor;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNewProductListCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.twoTableView setSeparatorColor:cellSeparatorColor];
    //从偏好设置里拿到大分类数组
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
//    self.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
    self.productcategory_id = 0;
    self.productsubcategory_id = @"-1"; // 默认是-1全部
    self.user_id = [SVUserManager shareInstance].user_id;
    self.page = 1;
  //  self.user_id = user_id;
    self.Product_state = @"0";
    self.Stock_type = @"-2";
    self.Stock_Min = @"";
    self.Stock_Max = @"";
    self.Stock_date_type = @"0";
    self.Stock_date_start = @"";
    self.Stock_date_end = @"";
    self.year = @"";
    self.sv_brand_ids = @"";
    self.fabric_ids = @"";
    self.Pc_ids = @"";
    self.Psc_ids = @"";
    
    // 获取商品页面的简单描述  getProductApiGetProductSimpleDesc
    [self getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:@"" Stock_date_end:@"" year:@"" Stock_date_type:@"0" source:@"" keywards:@"" Psc_ids:@"" pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:@"0" Stock_Min:@"" Stock_type:@"-2" fabric_ids:@"" Pc_ids:@"" Stock_Max:@"" sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:@"" user_id:self.user_id page:self.page];
    
    
    
    [self getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:@"" Stock_date_end:@"" year:@"" Stock_date_type:@"0" source:@"" keywards:@"" Psc_ids:@"" pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:@"0" Stock_Min:@"" Stock_type:@"-2" fabric_ids:@"" Pc_ids:@"" Stock_Max:@"" sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:@"" user_id:self.user_id page:self.page];
    
    
    
    [self setupRefresh];
    
    [self setUpBottomBtn];
    
    [self ProductApiGetProductcategoryProducttype_id];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneditSuccessPost) name:@"editSuccessPost" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"editSuccessPost" object:nil];
}

- (void)oneditSuccessPost{
 
    // 获取商品页面的简单描述  getProductApiGetProductSimpleDesc
    [self getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:@"" Stock_date_end:@"" year:@"" Stock_date_type:@"0" source:@"" keywards:@"" Psc_ids:@"" pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:@"0" Stock_Min:@"" Stock_type:@"-2" fabric_ids:@"" Pc_ids:@"" Stock_Max:@"" sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:@"" user_id:self.user_id page:self.page];
    
    
    
    [self getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:@"" Stock_date_end:@"" year:@"" Stock_date_type:@"0" source:@"" keywards:@"" Psc_ids:@"" pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:@"0" Stock_Min:@"" Stock_type:@"-2" fabric_ids:@"" Pc_ids:@"" Stock_Max:@"" sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:@"" user_id:self.user_id page:self.page];
}


- (void)ProductApiGetProductcategoryProducttype_id{
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApi/GetProductcategory?key=%@&page=1&pagesize=100&producttype_id=-1",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic ==== %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"id"] = @"";
            dictM[@"sv_pc_name"] = @"全部";
            [self.categaryArray addObject:dictM];
            NSDictionary *data = dic[@"data"];
            NSArray *listArray = data[@"list"];
            [self.categaryArray addObjectsFromArray:listArray];
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
           // dic[@"msg"];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    
}

- (void)setUpBottomBtn{

    //底部按钮
    UIButton *dayin_button = [[UIButton alloc]init];
    
    [dayin_button setImage:[UIImage imageNamed:@"dayin_icon"] forState:UIControlStateNormal];
    [dayin_button addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dayin_button];
    [dayin_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.right.mas_equalTo(self.view).offset(-30);
    }];

    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 22.5;
    [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addVipbuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(dayin_button.mas_top).offset(-10);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
    if (kDictIsEmpty(CommodityManageDic)) {
        button.hidden = NO;
    }else{
        NSString *AddCommodity = [NSString stringWithFormat:@"%@",CommodityManageDic[@"AddCommodity"]];
        if (kStringIsEmpty(AddCommodity)) {
            button.hidden = NO;
        }else{
            if ([AddCommodity isEqualToString:@"1"]) {
          
                button.hidden = NO;
        }else{
            button.hidden = YES;
        }
        }
    }
}

- (void)addWaresButton{
    SVLabelPrintingVC *tableVC = [[SVLabelPrintingVC alloc] init];
                    tableVC.controllerNum = 0;
          self.hidesBottomBarWhenPushed=YES;
                //跳转界面有导航栏的
         [self.navigationController pushViewController:tableVC animated:YES];
                //显示tabBar
         self.hidesBottomBarWhenPushed=YES;
}

- (void)addVipbuttonResponseEvent{
    SVAddMoreSpecificationsVC *vc = [[SVAddMoreSpecificationsVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - 上下拉刷新
-(void)setupRefresh{
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        self.tagBtn.selected = NO;
//         self.tagBtn.layer.borderColor =[UIColor grayColor].CGColor;
//         self.tagBtn.backgroundColor = [UIColor whiteColor];
//        // self.tagBtn.titleLabel.textColor = GlobalFontColor;
//        [self.tagBtn setTitleColor:GlobalFontColor forState:UIControlStateNormal];
        self.page = 1;
       // self.sao = YES;
        self.searchBar.text = nil;
        self.productsubcategory_id = @"-1"; // 默认是-1全部
        
        /**
         获取产品列表
         
         @param checkchildartno 包含子商品条码搜索，默认不查询，适用于需要直接搜索子商品条码的情景
         @param sv_product_type 0为普通商品，1为包装，2为套餐 3 原料
         @param Stock_date_start 库存入库时间开始 Stock_date_type=4必传值
         @param Stock_date_end 库存入库时间结束 Stock_date_type=4必传值
         @param year 年份
         @param Stock_date_type 库存入库时间 1一周，2半个月，3一个月,4根据时间范围查询0全部
         @param source 排序字段默认商品id source=storage库存排序
         @param keywards 模糊查询 支持编码/名称/条码查询
         @param Psc_ids 二级分类id
         @param pagesize 页数
         @param withMorespcSubList 多规格查询
         @param sv_is_morespecs 是否多规格商品
         @param Product_state 商品状态 0上架,-1：下架 1全部
         @param Stock_Min 库存最小 Stock_type=-3必须传值
         @param Stock_type 库存类型 1正库存。-1负库存，0零库存，-2全部，-3根据范围查询
         @param fabric_ids 成分
         @param Pc_ids 一级分类id
         @param Stock_Max 库存最大 Stock_type=-3必须传值
         @param sv_recommend_type 是否推荐 -1全部 0 推荐，1未推荐
         @param isQueryAllStore 是否查询所有店铺
         @param product_type 商品类型 -1全部，0标准，1多规格，2多单位，3服务商品，4包装组合，5计重，6计时
         @param BeOverdue_type 过期类型 1已过期，0未过期 -1全部
         @param sv_brand_ids 品牌
         @param user_id 门店id -1全部门店
         @param page 页码
         */
       // [self getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:@"" Stock_date_end:@"" year:@"" Stock_date_type:@"0" source:@"" keywards:self.searchBar.text Psc_ids:self.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:@"0" Stock_Min:@"" Stock_type:@"-2" fabric_ids:@"" Pc_ids:self.Pc_ids Stock_Max:@"" sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:@"" user_id:self.user_id page:self.page];
        
        [self getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:self.Stock_date_start Stock_date_end:self.Stock_date_end year:self.year Stock_date_type:self.Stock_date_type source:@"" keywards:self.searchBar.text Psc_ids:self.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:self.Product_state Stock_Min:self.Stock_Min Stock_type:self.Stock_type fabric_ids:self.fabric_ids Pc_ids:self.Pc_ids Stock_Max:self.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:self.sv_brand_ids user_id:self.user_id page:self.page];
        
        [self getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:self.Stock_date_start Stock_date_end:self.Stock_date_end year:self.year Stock_date_type:self.Stock_date_type source:@"" keywards:self.searchBar.text Psc_ids:self.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:self.Product_state Stock_Min:self.Stock_Min Stock_type:self.Stock_type fabric_ids:self.fabric_ids Pc_ids:self.Pc_ids Stock_Max:self.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:self.sv_brand_ids user_id:self.user_id page:self.page];
    }];
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    //上拉刷新
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
      //  [self getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:@"" Stock_date_end:@"" year:@"" Stock_date_type:@"0" source:@"" keywards:self.searchBar.text Psc_ids:@"" pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:@"0" Stock_Min:@"" Stock_type:@"-2" fabric_ids:@"" Pc_ids:@"" Stock_Max:@"" sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:@"" user_id:self.user_id page:self.page];
        [self getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:self.Stock_date_start Stock_date_end:self.Stock_date_end year:self.year Stock_date_type:self.Stock_date_type source:@"" keywards:self.searchBar.text Psc_ids:self.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:self.Product_state Stock_Min:self.Stock_Min Stock_type:self.Stock_type fabric_ids:self.fabric_ids Pc_ids:self.Pc_ids Stock_Max:self.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:self.sv_brand_ids user_id:self.user_id page:self.page];
        
        [self getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:self.Stock_date_start Stock_date_end:self.Stock_date_end year:self.year Stock_date_type:self.Stock_date_type source:@"" keywards:self.searchBar.text Psc_ids:self.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:self.Product_state Stock_Min:self.Stock_Min Stock_type:self.Stock_type fabric_ids:self.fabric_ids Pc_ids:self.Pc_ids Stock_Max:self.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:self.sv_brand_ids user_id:self.user_id page:self.page];
    }];
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在拼命加载中ing ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多的数据了" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    
    // 设置正在刷新状态的动画图片
    [footer setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;
    
}

#pragma mark - 分类的点击
- (IBAction)classificationClick:(UIButton *)btn{
    NSLog(@"%d",_selected);

      _selected = !_selected;

      if(_selected) {
          NSLog(@"选中");
          self.categoryView.alpha = 1;
          
          [self.view addSubview:self.maskOneView];
          [self.view addSubview:self.classificationView];
          self.classificationView.categaryArray = self.categaryArray;
          
          __weak typeof(self) weakSelf = self;
          self.classificationView.confirmBlock = ^(NSMutableArray * _Nonnull oneSelectModelArray, NSMutableArray * _Nonnull twoSelectModelArray) {
              NSLog(@"oneSelectModelArray = %@",oneSelectModelArray);
              NSLog(@"twoSelectModelArray = %@",twoSelectModelArray);

              NSString *nameStr;

              for (int i = 0 ; i < oneSelectModelArray.count; i++) {
                  if (i == 0) {
                      SVClassficationModel *model = oneSelectModelArray[i];
                      nameStr = [NSString stringWithFormat:@"%@,",model.id];
                  }else{
                      SVClassficationModel *model = oneSelectModelArray[i];
                      nameStr = [nameStr stringByAppendingFormat:@"%@,",model.id];
                  }
              }
              NSString *str3 = [nameStr substringToIndex:nameStr.length-1];//str3 = "this"
              weakSelf.Pc_ids = kStringIsEmpty(str3)?@"":str3;
              
              
              NSString *nameStr2;

              for (int i = 0 ; i < twoSelectModelArray.count; i++) {
                  if (i == 0) {
                      SVClassficationModel *model = twoSelectModelArray[i];
                      nameStr2 = [NSString stringWithFormat:@"%@,",model.productsubcategory_id];
                  }else{
                      SVClassficationModel *model = twoSelectModelArray[i];
                      nameStr2 = [nameStr2 stringByAppendingFormat:@"%@,",model.productsubcategory_id];
                  }
              }
              NSString *str4 = [nameStr2 substringToIndex:nameStr2.length-1];//str3 = "this"
              weakSelf.Psc_ids = kStringIsEmpty(str4)?@"":str4;
              
              weakSelf.page = 1;
              [weakSelf getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:weakSelf.searchBar.text Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
              
              [weakSelf getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:weakSelf.searchBar.text Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
              
              weakSelf.categoryView.alpha = 0.5;
              [weakSelf vipCancelResponseEvent];
              NSLog(@"weakSelf.Pc_ids = %@",weakSelf.Pc_ids);
              NSLog(@"weakSelf.Psc_ids = %@",weakSelf.Psc_ids);
          };
          //实现弹出方法
          [UIView animateWithDuration:.3 animations:^{
              self.classificationView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenW, ScreenH / 2*1);
          }];
      }else {
          NSLog(@"取消选中");
          self.categoryView.alpha = 0.5;
          [self vipCancelResponseEvent];
      }
}



#pragma mark - 筛选
- (IBAction)screenClick:(UIButton *)btn{
    
    NSLog(@"%d",_selected);
    [UIView animateWithDuration:.3 animations:^{
        //旋转
        self.screenBtn.imageView.transform = CGAffineTransformRotate(self.screenBtn.imageView.transform, M_PI);
    }];
      _selected = !_selected;

      if(_selected) {
          NSLog(@"选中"); [self.view addSubview:self.maskOneView];
          [self.view addSubview:self.newCommodityScreeningView];
          __weak typeof(self) weakSelf = self;
          self.newCommodityScreeningView.CommodityScreeningBlock = ^(NSString * _Nonnull user_id, NSString * _Nonnull Product_state, NSString * _Nonnull Stock_type, NSString * _Nonnull Stock_Min, NSString * _Nonnull Stock_Max, NSString * _Nonnull Stock_date_type, NSString * _Nonnull Stock_date_start, NSString * _Nonnull Stock_date_end, NSString * _Nonnull year, NSString * _Nonnull sv_brand_ids, NSString * _Nonnull fabric_ids) {
              weakSelf.user_id = kStringIsEmpty(user_id)?@"":user_id;
              weakSelf.Product_state = kStringIsEmpty(Product_state)?@"":Product_state;
              weakSelf.Stock_type = Stock_type;
              weakSelf.Stock_Min = kStringIsEmpty(Stock_Min)?@"":Stock_Min;
              weakSelf.Stock_Max = kStringIsEmpty(Stock_Max)?@"":Stock_Max;
              weakSelf.Stock_date_type = kStringIsEmpty(Stock_date_type)?@"0":Stock_date_type;
              weakSelf.Stock_date_start = kStringIsEmpty(Stock_date_start)?@"":Stock_date_start;
              weakSelf.Stock_date_end = kStringIsEmpty(Stock_date_end)?@"":Stock_date_end;
              weakSelf.year = kStringIsEmpty(year)?@"":year;
              weakSelf.sv_brand_ids = kStringIsEmpty(sv_brand_ids)?@"":sv_brand_ids;
              weakSelf.fabric_ids = kStringIsEmpty(fabric_ids)?@"":fabric_ids;
              
            /**
             self.user_id = [SVUserManager shareInstance].user_id;
             self.page = 1;
           //  self.user_id = user_id;
             self.Product_state = @"0";
             self.Stock_type = @"-2";
             self.Stock_Min = @"";
             self.Stock_Max = @"";
             self.Stock_date_type = @"0";
             self.Stock_date_start = @"";
             self.Stock_date_end = @"";
             self.year = @"";
             self.sv_brand_ids = @"";
             self.fabric_ids = @"";
             self.Pc_ids = @"";
             self.Psc_ids = @"";
             */
              weakSelf.page = 1;
              [weakSelf getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:weakSelf.searchBar.text Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
              
              
              [weakSelf getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:weakSelf.searchBar.text Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
              
              [weakSelf vipCancelResponseEvent];
          };
          //实现弹出方法
          [UIView animateWithDuration:.3 animations:^{
              self.newCommodityScreeningView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenW, self.view.height - self.topView.height);
          }];
          
          self.newCommodityScreeningView.canBlock = ^{
              [weakSelf vipCancelResponseEvent];
          };
      }else {
          NSLog(@"取消选中");
        //  self.categoryView.alpha = 0.5;
          [self vipCancelResponseEvent];
      }

}
#pragma mark - 获取商品页面的简单描述
- (void)getProductApiGetProductSimpleDesc:(NSString *)checkchildartno sv_product_type:(NSString *)sv_product_type Stock_date_start:(NSString *)Stock_date_start Stock_date_end:(NSString *)Stock_date_end year:(NSString *)year Stock_date_type:(NSString *)Stock_date_type source:(NSString *)source keywards:(NSString *)keywards Psc_ids:(NSString *)Psc_ids pagesize:(NSInteger)pagesize withMorespcSubList:(NSString *)withMorespcSubList sv_is_morespecs:(NSString *)sv_is_morespecs Product_state:(NSString *)Product_state Stock_Min:(NSString *)Stock_Min Stock_type:(NSString *)Stock_type fabric_ids:(NSString *)fabric_ids Pc_ids:(NSString *)Pc_ids Stock_Max:(NSString *)Stock_Max sv_recommend_type:(NSString *)sv_recommend_type isQueryAllStore:(NSString *)isQueryAllStore product_type:(NSString *)product_type BeOverdue_type:(NSString *)BeOverdue_type sv_brand_ids:(NSString *)sv_brand_ids user_id:(NSString *)user_id page:(NSInteger)page{
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApi/GetProductSimpleDesc?key=%@&checkchildartno=%@&sv_product_type=%@&Stock_date_start=%@&Stock_date_end=%@&year=%@&Stock_date_type=%@&source=%@&keywards=%@&Psc_ids=%@&pagesize=%ld&withMorespcSubList=%@&sv_is_morespecs=%@&Product_state=%@&Stock_Min=%@&Stock_type=%@&fabric_ids=%@&Pc_ids=%@&Stock_Max=%@&sv_recommend_type=%@&isQueryAllStore=%@&product_type=%@&BeOverdue_type=%@&sv_brand_ids=%@&user_id=%@&page=%ld",[SVUserManager shareInstance].access_token,checkchildartno,sv_product_type,Stock_date_start,Stock_date_end,year,Stock_date_type,source,keywards,Psc_ids,pagesize,withMorespcSubList,sv_is_morespecs,Product_state,Stock_Min,Stock_type,fabric_ids,Pc_ids,Stock_Max,sv_recommend_type,isQueryAllStore,product_type,BeOverdue_type,sv_brand_ids,user_id,page];
    NSString *strURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic---%@",dic);
        if ([dic[@"code"] intValue] == 1) {
            self.contentLabel.hidden = NO;
           NSDictionary *data = dic[@"data"];
            NSArray *list = data[@"list"];
            if (!kArrayIsEmpty(list)) {
                NSDictionary *dict = list[0];
                self.contentLabel.text = [NSString stringWithFormat:@"共%.0f个商品，库存%.2f件，总成本%.2f",[dict[@"sum"]doubleValue],[dict[@"sumCountMoreThan0"] doubleValue],[dict[@"sumCostMoreThan0"] doubleValue]];
                
                //  CommodityTotalCostQuery
                  [SVUserManager loadUserInfo];
                  NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
                  NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
                  if (kDictIsEmpty(CommodityManageDic)) {
                   
                  }else{
                      NSString *CommodityTotalCostQuery = [NSString stringWithFormat:@"%@",CommodityManageDic[@"CommodityTotalCostQuery"]];
                      if (kStringIsEmpty(CommodityTotalCostQuery)) {
                       
                      }else{
                          if ([CommodityTotalCostQuery isEqualToString:@"1"]) {
                        
                          
                      }else{
                          self.contentLabel.text = [NSString stringWithFormat:@"共%.0f个商品，库存%.2f件，总成本***",[dict[@"sum"]doubleValue],[dict[@"sumCountMoreThan0"] doubleValue]];
                      }
                      }
                  }
            }
        }else{
            self.contentLabel.hidden = YES;
        }
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
   
}



#pragma mark - 数据请求
/**
 获取产品列表
 
 @param checkchildartno 包含子商品条码搜索，默认不查询，适用于需要直接搜索子商品条码的情景
 @param sv_product_type 0为普通商品，1为包装，2为套餐 3 原料
 @param Stock_date_start 库存入库时间开始 Stock_date_type=4必传值
 @param Stock_date_end 库存入库时间结束 Stock_date_type=4必传值
 @param year 年份
 @param Stock_date_type 库存入库时间 1一周，2半个月，3一个月,4根据时间范围查询0全部
 @param source 排序字段默认商品id source=storage库存排序
 @param keywards 模糊查询 支持编码/名称/条码查询
 @param Psc_ids 二级分类id
 @param pagesize 页数
 @param withMorespcSubList 多规格查询
 @param sv_is_morespecs 是否多规格商品
 @param Product_state 商品状态 0上架,-1：下架 1全部
 @param Stock_Min 库存最小 Stock_type=-3必须传值
 @param Stock_type 库存类型 1正库存。-1负库存，0零库存，-2全部，-3根据范围查询
 @param fabric_ids 成分
 @param Pc_ids 一级分类id
 @param Stock_Max 库存最大 Stock_type=-3必须传值
 @param sv_recommend_type 是否推荐 -1全部 0 推荐，1未推荐
 @param isQueryAllStore 是否查询所有店铺
 @param product_type 商品类型 -1全部，0标准，1多规格，2多单位，3服务商品，4包装组合，5计重，6计时
 @param BeOverdue_type 过期类型 1已过期，0未过期 -1全部
 @param sv_brand_ids 品牌
 @param user_id 门店id -1全部门店
 @param page 页码
 */
- (void)getGteProductList:(NSString *)checkchildartno sv_product_type:(NSString *)sv_product_type Stock_date_start:(NSString *)Stock_date_start Stock_date_end:(NSString *)Stock_date_end year:(NSString *)year Stock_date_type:(NSString *)Stock_date_type source:(NSString *)source keywards:(NSString *)keywards Psc_ids:(NSString *)Psc_ids pagesize:(NSInteger)pagesize withMorespcSubList:(NSString *)withMorespcSubList sv_is_morespecs:(NSString *)sv_is_morespecs Product_state:(NSString *)Product_state Stock_Min:(NSString *)Stock_Min Stock_type:(NSString *)Stock_type fabric_ids:(NSString *)fabric_ids Pc_ids:(NSString *)Pc_ids Stock_Max:(NSString *)Stock_Max sv_recommend_type:(NSString *)sv_recommend_type isQueryAllStore:(NSString *)isQueryAllStore product_type:(NSString *)product_type BeOverdue_type:(NSString *)BeOverdue_type sv_brand_ids:(NSString *)sv_brand_ids user_id:(NSString *)user_id page:(NSInteger)page{
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [SVUserManager loadUserInfo];
//    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApi/GteProductList?key=%@&pageIndex=%li&pageSize=%li&category=%li&producttype_id=%@&name=%@&isn=%@&read_morespec=%@",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,(long)category,producttype_id,name,isn,read_morespec];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApi/GteProductList?key=%@&checkchildartno=%@&sv_product_type=%@&Stock_date_start=%@&Stock_date_end=%@&year=%@&Stock_date_type=%@&source=%@&keywards=%@&Psc_ids=%@&pagesize=%ld&withMorespcSubList=%@&sv_is_morespecs=%@&Product_state=%@&Stock_Min=%@&Stock_type=%@&fabric_ids=%@&Pc_ids=%@&Stock_Max=%@&sv_recommend_type=%@&isQueryAllStore=%@&product_type=%@&BeOverdue_type=%@&sv_brand_ids=%@&user_id=%@&page=%ld",[SVUserManager shareInstance].access_token,checkchildartno,sv_product_type,Stock_date_start,Stock_date_end,year,Stock_date_type,source,keywards,Psc_ids,pagesize,withMorespcSubList,sv_is_morespecs,Product_state,Stock_Min,Stock_type,fabric_ids,Pc_ids,Stock_Max,sv_recommend_type,isQueryAllStore,product_type,BeOverdue_type,sv_brand_ids,user_id,page];
    NSString *strURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic4444---%@",dic);
        
//        NSDictionary *valuesDic = dic[@"values"];
//
//        NSArray *listArr = valuesDic[@"list"];
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            NSArray *list = data[@"list"];
            
            if (self.page == 1) {
                [self.goodsModelArr removeAllObjects];
            }
            
            if (!kArrayIsEmpty(list)) {
                NSArray *modelArray = [SVduoguigeModel mj_objectArrayWithKeyValuesArray:list];
                [self.goodsModelArr addObjectsFromArray:modelArray];
                
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
   
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        

        [self.tableView reloadData];
        
        //是否正在刷新
        if ([self.tableView.mj_header isRefreshing]) {
            //结束刷新状态
            [self.tableView.mj_header endRefreshing];
        }
        
        //是否正在刷新
        if ([self.tableView.mj_footer isRefreshing]) {
            //结束刷新状态
            [self.tableView.mj_footer endRefreshing];
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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self addSearchBar];
    
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

#pragma mark - - - 添加搜索栏
- (void)addSearchBar {
    //添加方法二
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, ScreenW - 70, 38)];
    
    titleView.backgroundColor = [UIColor colorWithRed:121/255.0f green:142/255.0f blue:235/255.0f alpha:1];
//    titleView.backgroundColor = [UIColor whiteColor];
//    titleView.alpha = 0.5;
    //UIColor *color =  self.navigationController.navigationBar.tintColor;
    //[titleView setBackgroundColor:color];
    
   // saosao2white
    
    //扫一扫按钮
    self.qrcode = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
 //   self.qrcode.hidden = YES;
    self.qrcode.frame = CGRectMake(titleView.width - 50, 0, 40, 38);
    self.qrcode.centerY = titleView.centerY;
    [self.qrcode setImage:[UIImage imageNamed:@"saosao2white"] forState:UIControlStateNormal];
    [self.qrcode addTarget:self action:@selector(OrderNumberQueryResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.qrcode];
//    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(titleView.mas_right).offset(5);
//        make.centerY.mas_equalTo(titleView.mas_centerY);
//    }];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, titleView.width - 60, 38)];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.searchBar.placeholder = @"输入商品名称/款号";
    }else{
        self.searchBar.placeholder = @"输入商品名称/条码";
    }
   
    self.searchBar.alpha = 0.8;
  //  self.searchBar.backgroundColor = [UIColor clearColor];
    titleView.layer.cornerRadius = 19;
    titleView.layer.masksToBounds = YES;
   // titleView.backgroundColor = [UIColor clearColor];
    //设置背景图是为了去掉上下黑线
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    //设置背景色
    self.searchBar.backgroundColor = [UIColor clearColor];
    // 修改cancel
    self.searchBar.showsCancelButton=NO;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.keyboardType=UIKeyboardTypeDefault;
    //self.searchBar.searchBarStyle = UISearchBarStyleMinimal;//没有背影，透明样式
    self.searchBar.delegate = self;
    // 修改cancel
    self.searchBar.showsSearchResultsButton=NO;

    UITextField * searchField;
    if (@available(iOS 13.0, *)) { // iOS 11
        searchField = _searchBar.searchTextField;
        
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入商品名称/款号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
        }else{
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入商品名称/条码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
        }
        
      
           // 输入文本颜色
           searchField.textColor = [UIColor whiteColor];
           searchField.font = [UIFont systemFontOfSize:12];
           searchField.backgroundColor = [UIColor clearColor];
    }else{
        searchField =  [_searchBar valueForKey:@"_searchField"];
        
        
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入商品名称/款号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
        }else{
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入商品名称/条码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}]; //
        }
        // 默认文本大小
       
        
        if (searchField) {
              [searchField setBackgroundColor:[UIColor clearColor]];
          }
          // 输入文本颜色
          searchField.textColor = [UIColor whiteColor];
          searchField.font = [UIFont systemFontOfSize:12];
    }
    
    searchField.leftView = nil;
    // 输入文本颜色
    searchField.textColor = [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:12];

    //只有编辑时出现出现那个叉叉
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;

    [titleView addSubview:self.searchBar];

    self.navigationItem.titleView = titleView;
    
}

#pragma mark - UISearchBarDelegate代理方法
//点击搜索栏中的textFiled触发
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.qrcode.hidden = YES;
}

//当用停止编辑时，会调这个方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    self.qrcode.hidden = NO;
    
}

//输入内容就会触发
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//}

//当输入框内容发生变化时，就会触发，能够及时获取到输入框最新的内容
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""]) {
        self.qrcode.hidden = YES;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.qrcode.hidden = NO;
    }
    return YES;
}

//输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //设置为NO则，当没有数据时，则提示没有找到此商品
  //  self.sao = NO;
    
    //设置为显示
    self.qrcode.hidden = NO;
    
    NSString *Str = searchBar.text;
    
    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //   NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //提示查询
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在查询中…"];
    
    [self getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:self.Stock_date_start Stock_date_end:self.Stock_date_end year:self.year Stock_date_type:self.Stock_date_type source:@"" keywards:Str Psc_ids:self.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:self.Product_state Stock_Min:self.Stock_Min Stock_type:self.Stock_type fabric_ids:self.fabric_ids Pc_ids:self.Pc_ids Stock_Max:self.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:self.sv_brand_ids user_id:self.user_id page:self.page];
    
    [self getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:self.Stock_date_start Stock_date_end:self.Stock_date_end year:self.year Stock_date_type:self.Stock_date_type source:@"" keywards:Str Psc_ids:self.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:self.Product_state Stock_Min:self.Stock_Min Stock_type:self.Stock_type fabric_ids:self.fabric_ids Pc_ids:self.Pc_ids Stock_Max:self.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:self.sv_brand_ids user_id:self.user_id page:self.page];
    
    //移除第一响应者
    [searchBar resignFirstResponder];
    
}

/**
 退出键盘响应方法
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //移除第一响应者
    [self.searchBar resignFirstResponder];
    
    //退出设置为显示
    self.qrcode.hidden = NO;
    
}



#pragma mark - 扫码点击
- (void)OrderNumberQueryResponseEvent{
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//    VC.hidesBottomBarWhenPushed = YES;
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//        [weakSelf getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:name Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
//
//
//        [weakSelf getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:name Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
//
//    };
//
//    [self.navigationController pushViewController:VC animated:YES];
//    self.hidesBottomBarWhenPushed = YES;
    
    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        [weakSelf getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:resultStr Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
        
        
        [weakSelf getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:resultStr Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
    
    return self.goodsModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVNewProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[SVNewProductListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    SVduoguigeModel *model = [self.goodsModelArr objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SVShopNavVC *vc = [[SVShopNavVC alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.deleteBlock = ^{
        weakSelf.page = 1;
        [weakSelf getGteProductList:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:weakSelf.searchBar.text Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
        
        
        [weakSelf getProductApiGetProductSimpleDesc:@"false" sv_product_type:@"0" Stock_date_start:weakSelf.Stock_date_start Stock_date_end:weakSelf.Stock_date_end year:weakSelf.year Stock_date_type:weakSelf.Stock_date_type source:@"" keywards:weakSelf.searchBar.text Psc_ids:weakSelf.Psc_ids pagesize:20 withMorespcSubList:@"false" sv_is_morespecs:@"true" Product_state:weakSelf.Product_state Stock_Min:weakSelf.Stock_Min Stock_type:weakSelf.Stock_type fabric_ids:weakSelf.fabric_ids Pc_ids:weakSelf.Pc_ids Stock_Max:weakSelf.Stock_Max sv_recommend_type:@"-1" isQueryAllStore:@"false" product_type:@"-1" BeOverdue_type:@"0" sv_brand_ids:weakSelf.sv_brand_ids user_id:weakSelf.user_id page:weakSelf.page];
    };
    SVduoguigeModel *model = [self.goodsModelArr objectAtIndex:indexPath.row];
    vc.model = model;
    [SVUserManager loadUserInfo];
    [SVUserManager shareInstance].product_id = model.id;
    [SVUserManager saveUserInfo];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
//    SVNewShopDetailVC *vc = [[SVNewShopDetailVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.hidesBottomBarWhenPushed = YES;
    
}

#pragma mark 返回一个WMPageController对象
- (WMPageController *) getPages {
    //WMPageController中包含的页面数组
    NSArray *controllers = [NSArray arrayWithObjects:[SVSVNewShopDetailViewVC class], [UIViewController class], nil];
    //WMPageController控件的标题数组
    NSArray *titles = [NSArray arrayWithObjects:@"体育新闻", @"娱乐新闻", nil];
    //用上面两个数组初始化WMPageController对象
    WMPageController *pageController = [[WMPageController alloc] initWithViewControllerClasses:controllers andTheirTitles:titles];
    //设置WMPageController每个标题的宽度
    pageController.menuItemWidth = 100;
    //设置WMPageController标题栏的高度
    pageController.menuView.height = 35;
    //设置WMPageController选中的标题的颜色
    pageController.titleColorSelected = [UIColor colorWithRed:200 green:0 blue:0 alpha:1];
    return pageController;
}

#pragma mark - 取消按钮
- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
    self.categoryView.alpha = 0.5;
    _selected = NO;
    [self.classificationView removeFromSuperview];
    [self.newCommodityScreeningView removeFromSuperview];
}

- (SVClassificationView *)classificationView{
    if (!_classificationView) {
        _classificationView = [[NSBundle mainBundle]loadNibNamed:@"SVClassificationView" owner:nil options:nil].lastObject;
        _classificationView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenW, ScreenH/2*1);
        [_classificationView.ClassifiedManagement addTarget:self action:@selector(ClassifiedManagementClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _classificationView;
}

#pragma mark - 分类管理
- (void)ClassifiedManagementClick{
    //跳转会员详情界面
    //self.hidesBottomBarWhenPushed = YES;
    SVWaresOneClassVC *VC = [[SVWaresOneClassVC alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

- (SVNewCommodityScreeningView *)newCommodityScreeningView{
    if (!_newCommodityScreeningView) {
        _newCommodityScreeningView = [[NSBundle mainBundle]loadNibNamed:@"SVNewCommodityScreeningView" owner:nil options:nil].lastObject;
        _newCommodityScreeningView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenW, self.view.height - self.topView.height);
        
    }
    return _newCommodityScreeningView;
}




#pragma mark - 等级遮盖View
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenW, self.view.height - self.topView.height)];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    return 60;
  
}

- (NSMutableArray *)goodsModelArr {
    
    if (!_goodsModelArr) {
        
        _goodsModelArr = [NSMutableArray array];

    }
    return _goodsModelArr;
}

-(NSMutableArray *)bigNameArr{
    if (!_bigNameArr) {
        _bigNameArr = [NSMutableArray array];
    }
    return _bigNameArr;
}

-(NSMutableArray *)bigIDArr{
    if (!_bigIDArr) {
        _bigIDArr = [NSMutableArray array];
    }
    return _bigIDArr;
}

@end
