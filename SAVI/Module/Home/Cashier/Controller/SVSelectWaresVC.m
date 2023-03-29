//
//  SVSelectWaresVC.m
//  SAVI
//
//  Created by Sorgle on 17/5/19.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSelectWaresVC.h"
//底部view
#import "SVwaresFooterButton.h"
//模型
#import "SVSelectedGoodsModel.h"
//二分类的cell
#import "SVSelectGoodsViewCell.h"
//结算
#import "SVCheckoutV.h"
//选择会员
#import "SVVipSelectVC.h"
//查看购物车
#import "SVSeeWaresVC.h"

#import "SVSeeWaresView.h"
//购物车模型
#import "SVOrderDetailsModel.h"
// 多规格控制器
#import "SVMoreSpecificationVC.h"
#import "SVNumBlockModel.h"
#import "SVMultiSpecificationCell.h"
#import "SVExpandBtn.h"
#import "SVViewController.h"
#import "SVCashierSpecModel.h"
#import "SVShopSingleTemplateVC.h"
#import "SVOrderListVC.h"
#import "SVduoguigeModel.h"
#import "ZYInputAlertView.h"
#import "SVMultiPriceVC.h"
#import "IIGuideViewController.h"
#import "NSString+Extension.h"
#import "ZJViewShow.h"
#import "SVNewSettlementVC.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
//#import "PurchaseCarAnimationTool.h"
#define num  (ScreenH / 2)
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]
static NSString *selectWaresOneID = @"selectWaresOneCell";
static NSString *selectWaresTwoID = @"selectWaresTwoCell";
static NSString *selectWaresThreeID = @"SVMultiSpecificationCell";

@interface SVSelectWaresVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CAAnimationDelegate,selectMoreModelDelegate,IIGuideViewControllerDelegate>
//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SVExpandBtn *qrcode;
@property (strong, nonatomic) SVExpandBtn *sanjiao;
//选择商品的底部按钮
@property (nonatomic,strong) SVwaresFooterButton *waresFooterButton;
//选择会员按钮
@property (nonatomic,strong) UIButton *button;
//提示此分类没有商品
@property (nonatomic,strong) UIImageView *img;
//提示搜索没有此商品
@property (nonatomic,strong) UILabel *noWares;
@property (strong,nonatomic) UIButton *addButton;
@property (nonatomic,assign) BOOL sao;

//tableView
@property (nonatomic,strong) UITableView *oneTableView;
@property (nonatomic,strong) UITableView *twoTableView;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;

//第一个tableViewcell的数组
@property (nonatomic, strong) NSMutableArray *bigNameArr;
@property (nonatomic, strong) NSMutableArray *bigIDArr;
//商品模型数组
@property (nonatomic, strong) NSMutableArray *goodsModelArr;
//@property (nonatomic,strong) NSNumber *productcategory_id;
//@property (nonatomic,assign) NSInteger productcategory_id;
@property (nonatomic,strong) NSString *productcategory_id;
//标记 从属于第几个一级分类
@property (nonatomic, assign) NSInteger tableviewIndex;
//选择好的挂单数组
@property (nonatomic, strong) NSArray *guaDanArr;
//动图的属性
@property (nonatomic,strong) UIBezierPath *path;
//@property (nonatomic,strong) CALayer *layer;
@property (nonatomic,strong) SVMultiSpecificationCell *cell;

//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) SVSeeWaresView *seeWaresView;

@property (nonatomic,assign) NSInteger sumCount;
@property (nonatomic,assign) NSInteger secSumCount;
@property (nonatomic,assign) double sumMoney;
@property (nonatomic,strong) NSMutableArray *shopArray;
@property (nonatomic,strong)  NSMutableArray *temp;

@property (nonatomic,strong) SVMoreSpecificationVC *moreSpecificationVC;
@property (nonatomic,assign) NSInteger indexRow;

// 从购物车返回的数据
@property (nonatomic,assign) NSInteger shopMoney;
@property (nonatomic,assign) NSInteger shopNum;
//@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,assign) NSInteger product_num;

@property (nonatomic,strong) UIButton *cleanBnt;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger GuidedGraph; // 等于1的时候才能调用

@property (nonatomic,strong) UIView *categoryView;// 小分类的view
@property (nonatomic,strong) NSArray *categoryArray;// 选择商品会员价
@property (nonatomic,strong) NSMutableArray *categoryIdArr;
@property (nonatomic,strong) UIButton * tagBtn;
@property (nonatomic,strong) NSString *productsubcategory_id;// 小分类的ID
/**

 * 是否点击

 */
@property (nonatomic ,assign) BOOL selected;
@property (nonatomic,strong) NSMutableArray *dataArr;
/**
 分类折数组
 */
@property (nonatomic,strong) NSArray *getUserLevelArray;
@property (nonatomic,strong) ZJViewShow *showView;
@property (nonatomic ,assign) BOOL isCategoryDisCount;
//@property (nonatomic,strong) SVSelectedGoodsModel *goodsModel;
@property (nonatomic,assign) BOOL isScanButtonResponseEvent;
@property (nonatomic,strong) NSString * sv_mw_availablepoint;
@property (nonatomic,strong) NSString * sv_mw_sumpoint;
@property (nonatomic,strong) NSString * sv_mr_birthday;
@property (nonatomic,strong) NSString * level;
@end

@implementation SVSelectWaresVC

- (NSArray *)sv_discount_configArray{
    if (!_sv_discount_configArray) {
        _sv_discount_configArray = [NSArray array];
    }
    
    return _sv_discount_configArray;
}

- (NSArray *)getUserLevelArray{
    if (!_getUserLevelArray) {
        _getUserLevelArray = [NSArray array];
    }
    
    return _getUserLevelArray;
}

- (NSArray *)categoryArray{
    if (!_categoryArray) {
        _categoryArray = [NSArray array];
    }
    
    return _categoryArray;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.GuidedGraph = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableviewIndex = 0;
    //标题
    self.navigationItem.title = @"选择商品";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
    //添加搜索栏
    [self addSearchBar];
    
    //从偏好设置里拿到大分类数组
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
    self.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
    self.productsubcategory_id = @"-1"; // 默认是-1全部
#pragma mark - 添加tableView
    //tabeleView
    self.oneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW/8*2, ScreenH-TopHeight-50-50-BottomHeight)];
    //设置样式
    self.oneTableView.tableFooterView = [[UIView alloc]init];
    self.oneTableView.showsVerticalScrollIndicator = NO;
    self.oneTableView.backgroundColor = BackgroundColor;
    //改变cell分割线的颜色
    [self.oneTableView setSeparatorColor:[UIColor whiteColor]];
    // 设置距离左右各10的距离
    [self.oneTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //指定代理
    self.oneTableView.delegate = self;
    self.oneTableView.dataSource = self;
    // 添加一个view用来存放小分类
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 1)];
    categoryView.backgroundColor = BackgroundColor;
    self.categoryView = categoryView;
    
    self.twoTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenW/8*2, CGRectGetMaxY(categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-50-BottomHeight-categoryView.height)];
    //设置样式
    self.twoTableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.twoTableView setSeparatorColor:cellSeparatorColor];
    // 设置距离左右各10的距离
    [self.twoTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    //指定代理
    self.twoTableView.delegate = self;
    self.twoTableView.dataSource = self;
    
    [self.view addSubview:self.oneTableView];
    [self.view addSubview:categoryView];
    [self.view addSubview:self.twoTableView];
    //注册cell
    [self.oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:selectWaresOneID];
    
//    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]) {
//        [self.twoTableView registerNib:[UINib nibWithNibName:@"SVMultiSpecificationCell" bundle:nil] forCellReuseIdentifier:selectWaresThreeID];
//    }else{
        [self.twoTableView registerNib:[UINib nibWithNibName:@"SVSelectGoodsViewCell" bundle:nil] forCellReuseIdentifier:selectWaresTwoID];
  //  }
    
    if (!kArrayIsEmpty(self.goodsArr)) {

        [self optimizeSettlement];

           if (kArrayIsEmpty(self.goodsArr)) {
               // 改名称
               [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
           }else{
               // 改名称
               [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
           }
    }
    //调用刷新
    [self setupRefresh];
    
#pragma mark - 请求数据
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    //在没有点击的情况下，设置数组索引为0
    self.tableviewIndex = 0;
    //调用数据
    [self getDataPageIndex:1 pageSize:20 category:@"0" producttype_id:self.productsubcategory_id name:@"" isn:@"" read_morespec:@"true"];
    
    //默认选中第一行
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
#pragma mark - 添加提示
    //默认为YES,则提示此分类没有商品
    self.sao = YES;
    
    //提示没有此商品信息
    self.noWares = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.noWares.hidden = YES;
    self.noWares.text = @"没有此商品信息";
    self.noWares.textColor = [UIColor grayColor];
    self.noWares.center = CGPointMake(self.twoTableView.frame.size.width/2, self.twoTableView.frame.size.height/5 * 2);
    self.noWares.textAlignment = NSTextAlignmentCenter;
    [self.twoTableView addSubview:self.noWares];
    
    //提示该分类下没有商品
    self.img = [[UIImageView alloc]initWithFrame:CGRectMake((self.twoTableView.frame.size.width - 122.5) / 2, (self.twoTableView.frame.size.height - 132.5) / 3, 122.5, 132.5)];
    self.img.image = [UIImage imageNamed:@"noWares"];
    self.img.hidden = YES;
    [self.twoTableView addSubview:self.img];
    
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
    if (kDictIsEmpty(CommodityManageDic)) {
        [self setUpBottomAddBtn];
    }else{
         NSString *AddCommodity = [NSString stringWithFormat:@"%@",CommodityManageDic[@"AddCommodity"]];
        if (kStringIsEmpty(AddCommodity)) {
             [self setUpBottomAddBtn];
        }else{
            if ([AddCommodity isEqualToString:@"1"]) {
            [self setUpBottomAddBtn];
                       }else{
                           
                       }
        }
       
    }

    //添加底部按钮
    [self.waresFooterButton.orderButton addTarget:self action:@selector(orderButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.waresFooterButton.settlementButton addTarget:self action:@selector(settlementButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.waresFooterButton];
    
    // 改名称
    [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
    
    
    //不同的需求，出现不同的右上角
    if (![SVTool isBlankString:self.name]) {
        //从”会员详情”跳转到“会员销售”时，就会走这里，此时的右上角是不可点击响应的（正确创建方式，这样显示的图片就没有问题了）
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
//        label.text = [self.name substringToIndex:1];
//        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = navigationBackgroundColor;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = [UIColor whiteColor];
//        label.layer.cornerRadius = 11;
//        label.layer.masksToBounds = YES;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:label];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
             view.backgroundColor = [UIColor clearColor];
             
             self.button = [[UIButton alloc]initWithFrame:CGRectMake(45, 10, 50, 25)];
             //        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
             //        self.button = [[UIButton alloc] init];
             [view addSubview:self.button];
        UIButton *cleanBnt = [[UIButton alloc]initWithFrame:CGRectMake(100-5-20, 12, 20, 20)];
        self.button.titleLabel.font = [UIFont systemFontOfSize:11];
             self.button.layer.borderColor = [UIColor blackColor].CGColor;
             self.button.layer.borderWidth = 1;
             self.button.layer.cornerRadius = 10;
             self.button.layer.masksToBounds = YES;
             [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
               self.cleanBnt = cleanBnt;
               [cleanBnt setImage:[UIImage imageNamed:@"clean_white"] forState:UIControlStateNormal];
               [view addSubview:cleanBnt];
               self.cleanBnt.hidden = YES;
               [self.button addTarget:self action:@selector(rightbuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
               self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
               //
               [self.cleanBnt addTarget:self action:@selector(cleanMemberButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        self.button.frame = CGRectMake(20, 10, 50, 25);
                 [self.button setTitle:self.name forState:UIControlStateNormal];
                 self.cleanBnt.hidden = NO;
                 self.cleanBnt.frame = CGRectMake(75, 12, 20, 20);
        
    } else {
        //添加右上角按钮（正确创建方式，这样显示的图片就没有问题了）
        
        //先添加一个view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        view.backgroundColor = [UIColor clearColor];
        
        self.button = [[UIButton alloc]initWithFrame:CGRectMake(45, 10, 50, 25)];
        //        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        //        self.button = [[UIButton alloc] init];
        [view addSubview:self.button];
        //        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.right.mas_offset(view.mas_right);
        //            make.centerY.mas_equalTo(view.mas_centerY);
        //            make.width.mas_equalTo(50);
        //            make.height.mas_equalTo(25);
        //        }];
        // [self.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
        [self.button setTitle:@"选择会员" forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:11];
        self.button.layer.borderColor = [UIColor blackColor].CGColor;
        self.button.layer.borderWidth = 1;
        self.button.layer.cornerRadius = 10;
        self.button.layer.masksToBounds = YES;
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        UIButton *cleanBnt = [[UIButton alloc]initWithFrame:CGRectMake(100-5-20, 12, 20, 20)];
        self.cleanBnt = cleanBnt;
        [cleanBnt setImage:[UIImage imageNamed:@"clean_white"] forState:UIControlStateNormal];
        [view addSubview:cleanBnt];
        self.cleanBnt.hidden = YES;
        [self.button addTarget:self action:@selector(rightbuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
        //
        [self.cleanBnt addTarget:self action:@selector(cleanMemberButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        

    }
    
  
   NSString *catetoryId =(NSString *)self.bigIDArr[0];
    [self loadDataWithID:catetoryId];
    
    // 获取分类折
    self.getUserLevelArray = [SVUserManager shareInstance].getUserLevel;
     NSLog(@"getUserLevelArray = %@",self.getUserLevelArray);
    



//<<<<<<< HEAD
//   // [self loadMember];
//=======
//  //  [self loadMember];
//>>>>>>> origin/oem_deduction_fenleizhe



 //  [self loadMember];
    

    
}

- (void)loadMember{
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
       
       [SVUserManager loadUserInfo];
       NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/getUserconfig?key=%@",[SVUserManager shareInstance].access_token];
       //get请求
       [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           //解析数据
           NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
           NSLog(@"dictData = %@",dictData);
           NSDictionary *dict = dictData[@"values"];
           NSArray *getUserLevelArray = dict[@"getUserLevel"];
           if (!kArrayIsEmpty(getUserLevelArray)) {
               NSDictionary *disDict = getUserLevelArray[0];
              NSString *str = disDict[@"sv_discount_config"];
              NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
               self.dataArr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"dataArr = %@",self.dataArr);

               if (!kStringIsEmpty(str)) {
                   NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                   self.dataArr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"dataArr = %@",self.dataArr);
               }
           }
         
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
       }];
}





- (void)setUpBottomAddBtn{
    //添加按钮
    self.addButton = [[UIButton alloc] init];
    self.addButton.hidden = YES;
    self.addButton.layer.cornerRadius = 6;
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.addButton setTitle:@"+ 新增商品" forState:UIControlStateNormal];
    [self.addButton setBackgroundColor:navigationBackgroundColor];
    [self.addButton addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.twoTableView addSubview:self.addButton];
    //addButtonFrame
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.centerX.mas_equalTo(self.img.mas_centerX);
        make.top.mas_equalTo(self.img.mas_bottom).offset(20);
    }];
}


#pragma mark - 请求小分类数据
- (void)loadDataWithID:(NSString *)catetoryId{

    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetCategoryById?key=%@&cid=%@",[SVUserManager shareInstance].access_token,catetoryId];

    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        NSArray *aar = dict[@"values"];
    
        self.categoryArray = aar;
        if (kArrayIsEmpty(aar)) {
            self.categoryView.frame = CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 0);
            self.twoTableView.frame = CGRectMake(ScreenW/8*2, CGRectGetMaxY(self.categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-50-BottomHeight-self.categoryView.height);
        }else{
            [self.categoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.categoryView.frame = CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 55);
            self.twoTableView.frame = CGRectMake(ScreenW/8*2, CGRectGetMaxY(self.categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-50-BottomHeight-self.categoryView.height);
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.showsHorizontalScrollIndicator = FALSE; //水平
            scrollView.backgroundColor = [UIColor clearColor];
            [self.categoryView addSubview:scrollView];
            
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.categoryView.mas_left);
                make.right.mas_equalTo(self.categoryView.mas_right);
                make.top.mas_equalTo(self.categoryView.mas_top);
                make.bottom.mas_equalTo(self.categoryView.mas_bottom);
            }];
        
                       CGFloat tagBtnX = 10;
                       CGFloat tagBtnY = 7.5;
                       
                       for (int i= 0; i<aar.count; i++) {
                           NSDictionary *dict = aar[i];
                           NSString *sv_psc_name = dict[@"sv_psc_name"];
//                           CGSize tagTextSize = [sv_psc_name sizeWithFont:GlobalFont(12) maxSize:CGSizeMake(ScreenW/8*6, 30)];
                           CGSize tagTextSize = [sv_psc_name sizeWithFont:GlobalFont(12) maxSize:CGSizeMake(ScreenW/8*6, 40)];

                           UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                           [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
                           tagBtn.tag = i;
                           tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+30, 40);
                           [tagBtn setTitle:sv_psc_name forState:UIControlStateNormal];
                           [tagBtn setTitleColor: GlobalFontColor forState:UIControlStateNormal];
                         //  [tagBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
                           [tagBtn setBackgroundColor:[UIColor whiteColor]];
      
                           tagBtn.layer.cornerRadius = 5.f;
                           tagBtn.layer.masksToBounds = YES;

                           
                           [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                           [scrollView addSubview:tagBtn];
                           
                           tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;

                       }
            
            scrollView.contentSize = CGSizeMake(tagBtnX, 0);
                       
        }
        NSLog(@"aar = %@",aar);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - 点击小分类
- (void)tagBtnClick:(UIButton *)btn{
        self.tagBtn.selected = NO;
         self.tagBtn.layer.borderColor =[UIColor grayColor].CGColor;
         self.tagBtn.backgroundColor = [UIColor whiteColor];
        // self.tagBtn.titleLabel.textColor = GlobalFontColor;
          [self.tagBtn setTitleColor:GlobalFontColor forState:UIControlStateNormal];
         btn.selected = YES;
         btn.layer.borderColor = [[UIColor clearColor] CGColor];
        // btn.backgroundColor = [UIColor whiteColor];
         [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [btn setBackgroundColor:navigationBackgroundColor];
         self.tagBtn = btn;
        NSDictionary *dict = self.categoryArray[btn.tag];
         self.productsubcategory_id = (NSString *)dict[@"productsubcategory_id"];
        [self getDataPageIndex:1 pageSize:20 category:self.productcategory_id producttype_id:self.productsubcategory_id name:@"" isn:@"" read_morespec:@"true"];

}



///MARK: - IIGuideViewControllerDelegate
#pragma mark - 引导图代理方法
- (IIGuideItem *)guideViewController:(IIGuideViewController *)guideViewController itemForGuideAtIndex:(NSUInteger)index {
    CGRect frame = CGRectZero;
    CGFloat cornerRadius = 0.0;
    IIGuideItem *item = self.guideItems[index];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]){
        if (index == 0) {
              frame = CGRectMake(ScreenW/7*2 + 60, 50 + TopHeight, ScreenW - (ScreenW/7*2 + 60)- 80, 80);
             // frame = self.purpleView.frame;
              cornerRadius = 10.0;
          }else if (index == 1) {
              frame = CGRectMake((ScreenW/7*2 + 60) + (ScreenW - (ScreenW/7*2 + 60)- 80), 50 + TopHeight + 40, 40, 40);
             // cornerRadius = CGRectGetHeight(frame) * 0.5;
          }else if (index == 2){
             frame = CGRectMake(0, ScreenH - _waresFooterButton.waresView.height -BottomHeight, _waresFooterButton.waresView.width, _waresFooterButton.waresView.height);
          }
    }else{
        if (index == 0) {
              frame = CGRectMake(ScreenW/7*2 + 60, 50 + TopHeight, ScreenW - (ScreenW/7*2 + 60)- 80, 80);
             // frame = self.purpleView.frame;
              cornerRadius = 10.0;
        }else if (index == 1){
            frame = CGRectMake(0, ScreenH - _waresFooterButton.waresView.height-BottomHeight, _waresFooterButton.waresView.width, _waresFooterButton.waresView.height);
        }
    }
  
    item.frame = frame;
    item.cornerRadius = cornerRadius;
    return item;
}

-(void)guideViewControllerDidSelectNoLongerRemind:(IIGuideViewController *)guideViewController {
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"skipTutorial"];
}

- (void)guideViewControllerDidSelectRemindMe:(IIGuideViewController *)guideViewController {
    //[J2NotificationView showWithStatus:@"下次进入App重新提醒"];
}

- (NSInteger)numberOfGuidesInGuideViewController:(IIGuideViewController *)guideViewController {
    return self.guideItems.count;
}

- (NSArray *)guideItems {
    IIGuideItem *item0 = IIGuideItem.new;
    item0.title = @"点击这里添加商品！";
    
    IIGuideItem *item1 = IIGuideItem.new;
    item1.title = @"如果你是零售版本，点击这里可以改价";
    
    IIGuideItem *item2 = IIGuideItem.new;
    item2.title = @"点击购物车可以对商品删除或者增加";
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]){
        return @[item0,item1,item2];
    }else{
        return @[item0,item2];
    }
    
}

#pragma mark - 删除会员
- (void)cleanMemberButtonResponseEvent{
    self.name = nil;
    self.phone = nil;
    self.discount = nil;
    self.member_id = nil;
    self.storedValue = nil;
    self.headimg = nil;
    self.sv_mr_cardno = nil;
    self.member_Cumulative = nil;
    self.grade = nil;
    self.cleanBnt.hidden = YES;
    self.sv_discount_configArray = nil;
    [self.button setTitle:@"选择会员" forState:UIControlStateNormal];
    self.button.frame = CGRectMake(45, 10, 50, 25);

    [self optimizeSettlement];
}

//MARK:点击返回按钮（你也可以自定义一个返回按钮）
-(BOOL)navigationShouldPopOnBackButton {
    
    if (self.goodsArr.count == 0) {
        //返回上一控制器
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"有商品未结算,确定退出吗?"];
        //设置文本颜色
        [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 13)];
        //设置文本字体大小
        [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 13)];
        [alert setValue:hogan forKey:@"attributedTitle"];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //返回上一控制器
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
        
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    return YES;
}

#pragma mark - 上下拉刷新
-(void)setupRefresh{
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.tagBtn.selected = NO;
         self.tagBtn.layer.borderColor =[UIColor grayColor].CGColor;
         self.tagBtn.backgroundColor = [UIColor whiteColor];
        // self.tagBtn.titleLabel.textColor = GlobalFontColor;
        [self.tagBtn setTitleColor:GlobalFontColor forState:UIControlStateNormal];
        self.page = 1;
        self.sao = YES;
        self.searchBar.text = nil;
        self.productsubcategory_id = @"-1"; // 默认是-1全部
        //调用请求
//        [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@"" isn:@"" read_morespec:@"true"];
        [self getDataPageIndex:self.page pageSize:20 category:self.productcategory_id producttype_id:self.productsubcategory_id name:@"" isn:@"" read_morespec:@"true"];
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
    
    self.twoTableView.mj_header = header;
    
    //上拉刷新
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page = 0;
        
        NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        
        if (ary_1.count < 20) {
            
            self.page = 2;
            
        } else {
            
            if (ary_1.count % 20 == 0) {
                self.page = (ary_1.count+20) / 20;
            } else {
                self.page = (ary_1.count+20) / 20 + 1;
            }
            
        }
        //调用请求
//        [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@"" isn:@"" read_morespec:@"true"];
        [self getDataPageIndex:self.page pageSize:20 category:self.productcategory_id producttype_id:self.productsubcategory_id name:@"" isn:@"" read_morespec:@"true"];
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
    
    self.twoTableView.mj_footer = footer;
    
}

#pragma mark - - - 添加搜索栏
- (void)addSearchBar{
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    //是否在搜索框右侧显示一个图书的按钮，默认为NO
    //searchbar.showsBookmarkButton = NO;
    //是否显示搜索结果按钮，默认为NO
    //searchbar.showsSearchResultsButton = NO;
    //是否显示取消按钮，默认为NO
    //searchbar.showsCancelButton=NO;
    //是否显示搜索结果按钮，默认为NO
    //searchbar.showsSearchResultsButton=NO;
    
    //和其他文本输入控件的placeholder相同，在输入文字时就会消失
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.searchBar.placeholder = @"请输入商品名称或款号";
    }else{
        self.searchBar.placeholder = @"请输入商品名称或条码";
    }
    //默认风格
    self.searchBar.barStyle=UIBarStyleDefault;
    //设置键盘类型
    self.searchBar.keyboardType= UIKeyboardTypeDefault;
    //指定代理
    self.searchBar.delegate = self;
    //为UISearchBar添加背景图片
    //searchbar.backgroundColor = [UIColor whiteColor];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
    
     UITextField * searchField;
    if (@available(iOS 13.0, *)) {
        [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
            searchField = _searchBar.searchTextField;
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入商品名称或款号" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:GlobalFontColor}]; //
               // 输入文本颜色
               searchField.textColor = GlobalFontColor;
               searchField.font = [UIFont systemFontOfSize:12];
        }else{
            searchField = _searchBar.searchTextField;
            searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入商品名称或条码" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:GlobalFontColor}]; //
               // 输入文本颜色
               searchField.textColor = GlobalFontColor;
               searchField.font = [UIFont systemFontOfSize:12];
        }
       
    }else{
     // [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
      searchField = [_searchBar valueForKey:@"_searchField"];
         // 输入文本颜色
         searchField.textColor = GlobalFontColor;
        // searchField.font = [UIFont systemFontOfSize:15];
         // 默认文本大小
         [searchField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
         
         //只有编辑时出现那个叉叉
         searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
  
    
   // searchField.attributedPlaceholder =
    
    //只有编辑时出现那个叉叉
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:13];
    
    //添加到view中
    [self.view addSubview:self.searchBar];
    
    //扫一扫按钮
    self.qrcode = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
    [self.qrcode setImage:[UIImage imageNamed:@"saosao"] forState:UIControlStateNormal];
    [self.qrcode addTarget:self action:@selector(scanButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBar addSubview:self.qrcode];
    [self.qrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchBar.mas_centerY);
        make.right.mas_equalTo(self.searchBar.mas_right).offset(-20);
    }];
    
    
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
    self.sao = NO;
    
    //设置为显示
    self.qrcode.hidden = NO;
    
    NSString *Str = searchBar.text;
    
    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //提示查询
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在查询中…"];
    //设置数组索引为0
    self.tableviewIndex = 0;
    //默认选中第一行
    self.productcategory_id = 0;
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self.categoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.categoryView.frame = CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 0);
    self.twoTableView.frame = CGRectMake(ScreenW/8*2, CGRectGetMaxY(self.categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-50-BottomHeight-self.categoryView.height);
    //调用请求
    self.page = 1;
    //调用请求
   // [self getDataPageIndex:self.page pageSize:20 category:0 name:keyStr isn:keyStr read_morespec:@"true"];
    [self getDataPageIndex:1 pageSize:20 category:@"" producttype_id:@"-1" name:keyStr isn:keyStr read_morespec:@"true"];
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

#pragma mark - 跳转扫一扫响应方法
- (void)scanButtonResponseEvent{
    
    self.page = 1;
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
   __weak typeof(self) weakSelf = self;
//    VC.saosao_Block = ^(NSString *name){
//      //  [weakSelf.navigationController popViewControllerAnimated:YES];
//        //设置为NO则，当没有数据时，则提示没有找到此商品
//        weakSelf.sao = NO;
//
//        //提示查询
//        [SVTool IndeterminateButtonAction:weakSelf.view withSing:@"正在查询中…"];
//        //设置数组索引为0
//        weakSelf.tableviewIndex = 0;
//        //默认选中第一行
//        weakSelf.productcategory_id = 0;
//        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [weakSelf.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//
//       // weakSelf.searchBar.text = name;
//        [weakSelf.categoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        weakSelf.categoryView.frame = CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 0);
//        weakSelf.twoTableView.frame = CGRectMake(ScreenW/8*2, CGRectGetMaxY(weakSelf.categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-50-BottomHeight-weakSelf.categoryView.height);
//        //调用请求
//      //  [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:name isn:name read_morespec:@"false"];
//        weakSelf.isScanButtonResponseEvent = YES;
//        [weakSelf getDataPageIndex:1 pageSize:20 category:weakSelf.productcategory_id producttype_id:@"-1" name:name isn:name read_morespec:@"true"];
//
//    };
//
//    [self.navigationController pushViewController:VC animated:YES];
    
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        //  [weakSelf.navigationController popViewControllerAnimated:YES];
          //设置为NO则，当没有数据时，则提示没有找到此商品
          weakSelf.sao = NO;

          //提示查询
          [SVTool IndeterminateButtonAction:weakSelf.view withSing:@"正在查询中…"];
          //设置数组索引为0
          weakSelf.tableviewIndex = 0;
          //默认选中第一行
          weakSelf.productcategory_id = 0;
          NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
          [weakSelf.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];

         // weakSelf.searchBar.text = name;
          [weakSelf.categoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
          weakSelf.categoryView.frame = CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 0);
          weakSelf.twoTableView.frame = CGRectMake(ScreenW/8*2, CGRectGetMaxY(weakSelf.categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-50-BottomHeight-weakSelf.categoryView.height);
          //调用请求
        //  [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:name isn:name read_morespec:@"false"];
          weakSelf.isScanButtonResponseEvent = YES;
          [weakSelf getDataPageIndex:1 pageSize:20 category:weakSelf.productcategory_id producttype_id:@"-1" name:resultStr isn:resultStr read_morespec:@"true"];
    };
        self.hidesBottomBarWhenPushed=YES;
              //跳转界面有导航栏的
       [self.navigationController pushViewController:vc animated:YES];
              //显示tabBar
       self.hidesBottomBarWhenPushed=YES;
    
}

#pragma mark - 新增商品跳转响应方法
-(void)addWaresButton{
    
    //设置按钮点击时的背影色
    [self.addButton setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.addButton setBackgroundColor:navigationBackgroundColor];
        
        SVNewWaresVC *VC = [[SVNewWaresVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    });
}

#pragma mark - 会员选择按钮响应方法
-(void)rightbuttonResponseEvent{
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]) {
        
        SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
        
        __weak typeof(self) weakSelf = self;
        
        VC.vipBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *sv_mw_availablepoint, NSString *sv_mw_sumpoint, NSString *sv_mr_birthday, NSString *sv_mr_pwd, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id, NSString *user_id) {
           // ClassifiedBookArray 是没有作用的
            for (NSDictionary *dict in self.getUserLevelArray) {
                NSString *memberlevel_id_getUserLevel = [NSString stringWithFormat:@"%@",dict[@"memberlevel_id"]];
                if ([memberlevel_id_getUserLevel isEqualToString:memberlevel_id]) {
                    NSString *sv_discount_config_json = dict[@"sv_discount_config"];
                    NSData *data = [sv_discount_config_json dataUsingEncoding:NSUTF8StringEncoding];
                    if (data != NULL) {
                        self.sv_discount_configArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                        NSLog(@"self.sv_discount_configArray = %@",self.sv_discount_configArray);
                    }
                    
                    break;
                }
            }

            weakSelf.button.frame = CGRectMake(20, 10, 50, 25);
            [weakSelf.button setTitle:name forState:UIControlStateNormal];
            self.cleanBnt.hidden = NO;
            self.cleanBnt.frame = CGRectMake(75, 12, 20, 20);
            weakSelf.name = name;
            weakSelf.phone = phone;
            if ([SVTool isBlankString:discount]) {
                discount = @"0";
                weakSelf.discount = discount;
            }else{
                weakSelf.discount = discount;
            }
            
            NSLog(@"weakSelf.discount = %@",weakSelf.discount);
            weakSelf.member_id = member_id;
            weakSelf.storedValue = storedValue;
            weakSelf.headimg = headimg;
            weakSelf.sv_mr_cardno = sv_mr_cardno;
            weakSelf.member_Cumulative = sv_mw_availablepoint;
            
            weakSelf.sv_mw_availablepoint = sv_mw_availablepoint;
            weakSelf.sv_mw_sumpoint = sv_mw_sumpoint;
            weakSelf.sv_mr_birthday = sv_mr_birthday;
            weakSelf.level = level;
            //  SVSelectedGoodsModel *Secmodel in self.shopArray
//            if ([SVUserManager shareInstance].rankPromotion_sv_detail_is_enable.doubleValue == 1) { // 开关开了
                weakSelf.grade = grade;
//            }else{
//                weakSelf.grade = nil;
//            }
           
            weakSelf.sv_mr_pwd = sv_mr_pwd;

            [self optimizeSettlement];
        };
        [self.navigationController pushViewController:VC animated:YES];
        
    }else{
        SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
        
        __weak typeof(self) weakSelf = self;
    
        VC.vipBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *sv_mw_availablepoint, NSString *sv_mw_sumpoint, NSString *sv_mr_birthday, NSString *sv_mr_pwd, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id, NSString *user_id) {
            for (NSDictionary *dict in self.getUserLevelArray) {
                NSString *memberlevel_id_getUserLevel = [NSString stringWithFormat:@"%@",dict[@"memberlevel_id"]];
                if ([memberlevel_id_getUserLevel isEqualToString:memberlevel_id]) {
                   NSString *sv_discount_config_json = dict[@"sv_discount_config"];
                    NSData *data = [sv_discount_config_json dataUsingEncoding:NSUTF8StringEncoding];
                    if (data != NULL) {
                        self.sv_discount_configArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                        NSLog(@"self.sv_discount_configArray = %@",self.sv_discount_configArray);
                    }
                    
                    break;
                }
            }
            
            
            if (![SVTool isBlankString:name]) {
                [weakSelf.button setTitle:[name substringToIndex:1] forState:UIControlStateNormal];
            }else{
                // [weakSelf.button setTitle:@"" forState:UIControlStateNormal];
            }
   
            weakSelf.button.frame = CGRectMake(20, 10, 50, 25);
            [weakSelf.button setTitle:name forState:UIControlStateNormal];
            self.cleanBnt.hidden = NO;
            self.cleanBnt.frame = CGRectMake(75, 12, 20, 20);
            
            weakSelf.name = name;
            weakSelf.phone = phone;
            if ([SVTool isBlankString:discount]) {
                discount = @"0";
                weakSelf.discount = discount;
            }else{
                weakSelf.discount = discount;
            }
            
            //  self.cleanBnt.hidden = NO;
            // weakSelf.discount = discount;
            weakSelf.member_id = member_id;
            weakSelf.storedValue = storedValue;
            weakSelf.headimg = headimg;
            weakSelf.sv_mr_cardno = sv_mr_cardno;
            weakSelf.member_Cumulative = sv_mw_availablepoint;
            weakSelf.sv_mr_pwd = sv_mr_pwd;

                weakSelf.grade = grade;
//            }else{
//                weakSelf.grade = nil;
//            }
            
//            self.nameLabel.text = name;
//            self.codeText.text = phone;
          
            
            
          //  self.balance.text = storedValue;
            self.sv_mw_availablepoint = sv_mw_availablepoint;
            self.sv_mw_sumpoint = sv_mw_sumpoint;
            self.sv_mr_birthday = sv_mr_birthday;
            
            self.level = level;
            [self optimizeSettlement];
        };
        
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}

#pragma mark - 跳转到购物车
-(void)waresViewResponse{
    
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]) {
        if (self.goodsArr.count > 0) {
            SVViewController *vc = [[SVViewController alloc] init];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSMutableDictionary *dict in self.goodsArr) {
                if ([dict[@"product_num"]doubleValue] != 0) {
                    //会员ID
                    if (![SVTool isBlankString:self.member_id]) {
                        [dict setObject:self.member_id forKey:@"member_id"];
                        [dict setObject:self.discount forKey:@"discount"];
                    }else{
                        [dict setObject:@"" forKey:@"member_id"];
                        [dict setObject:@"" forKey:@"discount"];
                    }
                    
                    //                SVCashierSpecModel *model = [SVCashierSpecModel mj_objectWithKeyValues:dict];
                    
                    [modelArray addObject:dict];
                }
            }
            __weak typeof(self) weakSelf = self;
            // 清空按钮的点击
            //            vc.cleanBlock = ^(NSMutableArray *modelArray) {
            //                [modelArray removeAllObjects];
            //                weakSelf.goodsArr = modelArray;
            //            };
            
            vc.modelArr = modelArray;
            vc.grade = self.grade;
            vc.sumCount = self.waresFooterButton.sumCount;
            vc.sv_discount_configArray = self.sv_discount_configArray;
            vc.arrayBlock = ^(NSMutableArray *modelArray) {
                if (kArrayIsEmpty(modelArray)) {
                    // 改名称
                    [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
                    
                }else{
                    // 改名称
                    [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
                    
                }
                NSLog(@"modelArray = %@",modelArray);
                weakSelf.goodsArr = modelArray;
                [self optimizeSettlement];
                
            };
            
            
            vc.view.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
            double version = [UIDevice currentDevice].systemVersion.doubleValue;
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
            
            
        }else{
            [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
            return;
        }
        
    }else{
        if (self.goodsArr.count == 0) {
            [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
            return;
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.seeWaresView];
        
     //  [self.seeWaresView.modelArr removeAllObjects];
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSMutableDictionary *dict in self.goodsArr) {
            //会员ID
            NSLog(@"商品的dict = %@",dict);
            if ([dict[@"product_num"]doubleValue] > 0) {
                if (![SVTool isBlankString:self.member_id]) {
                    [dict setObject:self.member_id forKey:@"member_id"];
                    [dict setObject:self.discount forKey:@"discount"];
                }else{
                    [dict setObject:@"" forKey:@"member_id"];
                    [dict setObject:@"" forKey:@"discount"];
                }
                
                [modelArray addObject:dict];

            }

        }
        
        self.seeWaresView.grade = self.grade;
        self.seeWaresView.sv_discount_configArray = self.sv_discount_configArray;
        self.seeWaresView.modelArr = modelArray;
        
        
        if (kArrayIsEmpty(self.goodsArr)) {
            // 改名称
            [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
        }else{
            // 改名称
            [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
        }
        
//        self.seeWaresView.sumLabel.text = [NSString stringWithFormat:@"%lu",self.goodsArr.count];
//        self.seeWaresView.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.waresFooterButton.sumCount];
//
//        [self.seeWaresView.tableView reloadData];
        
        __weak typeof(self) weakSelf = self;
//        if (self.seeWaresView.dictArrBlock) {
            self.seeWaresView.dictArrBlock = ^(NSMutableArray *dictArray) {
                weakSelf.goodsArr = dictArray;
               
                [weakSelf optimizeSettlement];
                
                [weakSelf.twoTableView reloadData];
                
               
            };

        //实现弹出方法
        [UIView animateWithDuration:.5 animations:^{
            self.seeWaresView.frame = CGRectMake(0, num, ScreenW, ScreenH-num);
        }];
    }
    
    
}


#pragma mark - 挂单按钮响应方法
-(void)orderButtonResponseEvent{
    
    if (self.goodsArr.count == 0) {
        //        [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
        //        return;
        
        //        SVOrderListVC *vc = [[SVOrderListVC alloc] init];
        //        [self.navigationController pushViewController:vc animated:YES];
        
        NSInteger number = 7+1;
        NSInteger index = number;
        NSString *nums = [SVUserManager shareInstance].sv_app_config;
        if (index > nums.length) {
            // 给100，如果长度不够时，也可以点击
            SVOrderListVC *tableVC = [[SVOrderListVC alloc]init];
            [self setUpOperatorPrivilege:100 withUIViewController:tableVC];
        }else{
            SVOrderListVC *tableVC = [[SVOrderListVC alloc]init];
            [self setUpOperatorPrivilege:index withUIViewController:tableVC];
        }
        
    }else{
        //让按钮不可点
        [self.waresFooterButton.orderButton setEnabled:NO];
        //不用交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
        //提示在支付中
        [SVTool TextButtonAction:self.view withSing:nil];
        
        NSMutableArray *guaDanArr = [NSMutableArray array];
        
         for (NSDictionary *dict in self.goodsArr) {
                  NSLog(@"self.goodsArr33333 = %@",self.goodsArr);
                  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                  [dic setObject:dict[@"product_id"] forKey:@"product_id"];
                  [dic setObject:dict[@"sv_p_name"] forKey:@"product_name"];

             NSString *priceChangeNum = [NSString stringWithFormat:@"%@",dict[@"isPriceChange"]];
                if ([priceChangeNum isEqualToString:@"1"]) { // 是改价
                 [dic setObject:dict[@"priceChange"] forKey:@"product_unitprice"];
                }else{
                 [dic setObject:dict[@"sv_p_unitprice"] forKey:@"product_unitprice"];
                 }
                 
                  [dic setObject:dict[@"sv_pricing_method"] forKey:@"sv_pricing_method"];
          
                  [dic setObject:[NSString stringWithFormat:@"%f",[dict[@"product_num"] doubleValue]] forKey:@"product_num"];
                  [dic setObject:dict[@"sv_p_barcode"] forKey:@"sv_p_barcode"];
                  [dic setObject:dict[@"sv_product_type"] forKey:@"sv_product_type"];
                  
           
                  [guaDanArr addObject:dic];
              }
        
        [SVUserManager loadUserInfo];
        NSString *token = [SVUserManager shareInstance].access_token;
        
        NSString *timeStr = [JWXUtils genTimeStamp];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
//        [parameters setObject:timeStr forKey:@"wt_nober"];
        NSLog(@"self.order = %@",self.orderID);
              if (![SVTool isBlankString:self.sv_without_list_id]) {
                  NSLog(@"self.sv_without_list_id = %@",self.sv_without_list_id);
                  
                  [parameters setObject:self.sv_without_list_id forKey:@"sv_without_list_id"];
              }
              
              if (![SVTool isBlankString:self.orderID]) {
                  NSLog(@"self.order = %@",self.orderID);
                  [parameters setObject:self.orderID forKey:@"wt_nober"];
              }else{
                  [parameters setObject:timeStr forKey:@"wt_nober"];
                  NSLog(@"timeStr = %@",timeStr);
                  
              }
        
        [parameters setObject:guaDanArr forKey:@"prlist"];
        [parameters setObject:token forKey:@"access_token"];
        if (![SVTool isBlankString:self.member_id]) {
            [parameters setObject:self.member_id forKey:@"member_id"];
        }
        
        NSString *strURL = [URLhead stringByAppendingFormat:@"/order/Post_guadan?key=%@",token];
        
        [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            
            if ([dic[@"succeed"] integerValue] == 1) {
                
                [SVTool TextButtonAction:self.view withSing:@"挂单成功"];
                // 改名称
                [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
                
                self.name = nil;
                self.phone = nil;
                self.discount = nil;
                self.member_id = nil;
                self.storedValue = nil;
                self.headimg = nil;
                self.sv_mr_cardno = nil;
              //  weakSelf.sv_mr_cardno = sv_mr_cardno;
                self.member_Cumulative = nil;
                self.sv_mr_pwd = nil;
                [self.button setTitle:@"选择会员" forState:UIControlStateNormal];
                self.cleanBnt.hidden = YES;
                self.grade = nil;
                self.button.frame = CGRectMake(45, 10, 50, 25);
                //            [self.button setTitle:nil forState:UIControlStateNormal];
                //            [self.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
                // 发出通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_ORDERLIST_VISIBLE_NOTI" object:@"1"];
                
                if (![SVTool isBlankString:self.sv_without_list_id]) {
                    if (self.numBlock) {
                        self.numBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    //用延迟来移除提示框
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    //隐藏提示
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    
                                    [self removeGoodsModelArr];
                                    
                                });
                }
            
            } else {
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:@"数据出错，挂单失败"];
            }
            
            //让按钮可点
            [self.waresFooterButton.orderButton setEnabled:YES];
            //可交互
            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            
            //让按钮可点
            [self.waresFooterButton.orderButton setEnabled:YES];
            //可交互
            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
            
        }];
        
    }
}

-(void)setUpOperatorPrivilege:(NSInteger)number withUIViewController:(UIViewController *)VC{
    
    [SVUserManager loadUserInfo];
    NSLog(@"[SVUserManager shareInstance].sv_app_config]= %@",[SVUserManager shareInstance].sv_app_config);
    if (number == 100) {
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]){
        NSString *nums = [SVUserManager shareInstance].sv_app_config;
        NSLog(@"nums.length = %ld",nums.length);
        
        if (number + 1 > nums.length) {
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            NSString *num_two = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(number,1)];
            NSLog(@"num_two %@",num_two);
            
            if ([num_two isEqualToString:@"0"]) {
                [SVTool TextButtonAction:self.view withSing:@"亲,你还没有该权限"];
                return;
            }
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }
    
}



#pragma mark - 结算按钮响应方法
-(void)settlementButtonResponseEvent{
    
    
    // self.modelArray
    [SVUserManager loadUserInfo];
        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        //判断是否
        if (self.goodsArr.count == 0) {
            [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
            
        }else{
            SVNewSettlementVC *tableVC = [[SVNewSettlementVC alloc]init];
            tableVC.resultArr = self.goodsArr;
            NSLog(@"self.goodsArr = %@",self.goodsArr);

            tableVC.interface = self.interface;
            tableVC.name = self.name;
            tableVC.phone = self.phone;
            tableVC.discount = self.discount;
            tableVC.member_id = self.member_id;
            tableVC.stored = self.storedValue;
            tableVC.headimg = self.headimg;
            tableVC.sv_mr_cardno = self.sv_mr_cardno;
            tableVC.member_Cumulative = self.member_Cumulative;
            tableVC.sv_mr_pwd = self.sv_mr_pwd;
            tableVC.grade = self.grade;
            tableVC.sv_discount_configArray = self.sv_discount_configArray;
            tableVC.getUserLevelArray = self.getUserLevelArray;
            
            tableVC.sv_mw_availablepoint = self.sv_mw_availablepoint;
            tableVC.sv_mw_sumpoint = self.sv_mw_sumpoint;
            tableVC.sv_mr_birthday = self.sv_mr_birthday;
            tableVC.level = self.level;
            
            if (!kStringIsEmpty(self.sv_without_list_id)) {
                tableVC.sv_without_list_id = self.sv_without_list_id;
            }
            if (!kStringIsEmpty(self.order_running_id)) {
                tableVC.order_running_id = self.order_running_id;
            }
            tableVC.grade = self.grade;
            if (self.interface == 1 || self.interface == 3) {
                tableVC.vipBool = NO;
            } else {
                //会员销售的走这
                tableVC.vipBool = YES;
            }
            
            //结算成功后清除
            __weak typeof(self) weakSelf = self;
            tableVC.selectWaresBlock = ^(){
                //清空会员
                if (self.interface == 1) {
                    weakSelf.name = nil;
                    weakSelf.phone = nil;
                    weakSelf.discount = nil;
                    weakSelf.member_id = nil;
                    weakSelf.storedValue = nil;
                    weakSelf.headimg = nil;
                    weakSelf.sv_mr_cardno = nil;
                    weakSelf.member_Cumulative = nil;
                    weakSelf.grade = nil;
                    weakSelf.sv_without_list_id = nil;
                    weakSelf.order_running_id = nil;
                    weakSelf.sv_discount_configArray = nil;
                    //                     self.cleanBnt.hidden = YES;
                    //                    [weakSelf.button setTitle:@"选择会员" forState:UIControlStateNormal];
                    
                    [self.button setTitle:@"选择会员" forState:UIControlStateNormal];
                    self.cleanBnt.hidden = YES;
                    self.button.frame = CGRectMake(45, 10, 50, 25);
                    
                    //                    [weakSelf.button setTitle:nil forState:UIControlStateNormal];
                    //                    [weakSelf.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
                    
                }else if (self.interface == 2){ // 从会员快捷销售过来的
                    [weakSelf loadMemberStoreValue];
                }
                
                [weakSelf removeGoodsModelArr];
            };
            
            // 删除会员的清除
            tableVC.deleteMemberBlock = ^{
                weakSelf.name = nil;
                weakSelf.phone = nil;
                weakSelf.discount = nil;
                weakSelf.member_id = nil;
                weakSelf.storedValue = nil;
                weakSelf.headimg = nil;
                weakSelf.sv_mr_cardno = nil;
                weakSelf.member_Cumulative = nil;
                weakSelf.grade = nil;
                weakSelf.sv_discount_configArray = nil;
                //                self.cleanBnt.hidden = YES;
                //                [weakSelf.button setTitle:@"选择会员" forState:UIControlStateNormal];
                
                [self.button setTitle:@"选择会员" forState:UIControlStateNormal];
                self.cleanBnt.hidden = YES;
                self.button.frame = CGRectMake(45, 10, 50, 25);
                
                //                [weakSelf.button setTitle:nil forState:UIControlStateNormal];
                //                [weakSelf.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
                
                [self optimizeSettlement];
            };
            
            #pragma mark - 选择会员的block
                tableVC.chooseMemberBlock = ^(NSString * _Nonnull name, NSString * _Nonnull phone, NSString * _Nonnull level, NSString * _Nonnull discount, NSString * _Nonnull member_id, NSString * _Nonnull storedValue, NSString * _Nonnull headimg, NSString * _Nonnull sv_mr_cardno, NSString * _Nonnull member_Cumulative, NSString * _Nonnull grade, NSArray * _Nonnull ClassifiedBookArray, NSString * _Nonnull memberlevel_id, NSString * _Nonnull sv_mw_sumpoint, NSString * _Nonnull sv_mr_birthday) {
          
                for (NSDictionary *dict in self.getUserLevelArray) {
                    NSString *memberlevel_id_getUserLevel = [NSString stringWithFormat:@"%@",dict[@"memberlevel_id"]];
                    if ([memberlevel_id_getUserLevel isEqualToString:memberlevel_id]) {
                        NSString *sv_discount_config_json = dict[@"sv_discount_config"];
                        NSData *data = [sv_discount_config_json dataUsingEncoding:NSUTF8StringEncoding];
                        if (data != NULL) {
                            self.sv_discount_configArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                            NSLog(@"self.sv_discount_configArray = %@",self.sv_discount_configArray);
                        }
                        
                        break;
                    }
                }
                
                if (![SVTool isBlankString:name]) {
                    [weakSelf.button setTitle:[name substringToIndex:1] forState:UIControlStateNormal];
                }else{
                    [weakSelf.button setTitle:name forState:UIControlStateNormal];
                }
                
             
                weakSelf.button.frame = CGRectMake(20, 10, 50, 25);
                [weakSelf.button setTitle:name forState:UIControlStateNormal];
                self.cleanBnt.hidden = NO;
                self.cleanBnt.frame = CGRectMake(75, 12, 20, 20);
                
              
                weakSelf.name = name;
                weakSelf.phone = phone;
                if ([SVTool isBlankString:discount]) {
                    discount = @"0";
                    weakSelf.discount = discount;
                }else{
                    weakSelf.discount = discount;
                }
                
                NSLog(@"weakSelf.discount = %@",weakSelf.discount);
             //   没处理
                weakSelf.member_id = member_id;
                weakSelf.storedValue = storedValue;
                weakSelf.headimg = headimg;
                weakSelf.sv_mr_cardno = sv_mr_cardno;
                weakSelf.member_Cumulative = member_Cumulative;
                
                weakSelf.sv_mw_availablepoint = member_Cumulative;
                weakSelf.sv_mw_sumpoint = sv_mw_sumpoint;
                weakSelf.sv_mr_birthday = sv_mr_birthday;
                weakSelf.level = level;
                //  SVSelectedGoodsModel *Secmodel in self.shopArray
              //  weakSelf.grade = grade;
//                if ([SVUserManager shareInstance].rankPromotion_sv_detail_is_enable.doubleValue == 1) { // 开关开了
                    weakSelf.grade = grade;
//                }else{
//                    weakSelf.grade = nil;
//                }
                [self optimizeSettlement];
            };
            
            
#pragma mark - 退出蒙版的操作
            tableVC.tuichuMengbanBlock = ^{
                [self optimizeSettlement];
                [self.twoTableView reloadData];
            };
            
            //跳转界面有导航栏的
            [self.navigationController pushViewController:tableVC animated:YES];
        }
        
    }else{
        
//        SVNewSettlementVC *tableVC = [[SVNewSettlementVC alloc] init];
//        [self.navigationController pushViewController:tableVC animated:YES];
        
        
        
        //判断是否
        if (self.goodsArr.count == 0) {
            [SVTool TextButtonAction:self.view withSing:@"请选择商品"];

        } else {

            SVNewSettlementVC *tableVC = [[SVNewSettlementVC alloc]init];
            tableVC.resultArr = self.goodsArr;
            NSLog(@"self.goodsArr = %@",self.goodsArr);

            tableVC.interface = self.interface;
            tableVC.name = self.name;
            tableVC.phone = self.phone;
            tableVC.discount = self.discount;
            tableVC.member_id = self.member_id;
            tableVC.stored = self.storedValue;
            tableVC.headimg = self.headimg;
            tableVC.sv_mr_cardno = self.sv_mr_cardno;
            tableVC.member_Cumulative = self.member_Cumulative;
            tableVC.sv_mr_pwd = self.sv_mr_pwd;
            tableVC.grade = self.grade;
            tableVC.sv_discount_configArray = self.sv_discount_configArray;
            tableVC.getUserLevelArray = self.getUserLevelArray;
            
            tableVC.sv_mw_availablepoint = self.sv_mw_availablepoint;
            tableVC.sv_mw_sumpoint = self.sv_mw_sumpoint;
            tableVC.sv_mr_birthday = self.sv_mr_birthday;
            tableVC.level = self.level;
            
            if (!kStringIsEmpty(self.sv_without_list_id)) {
                tableVC.sv_without_list_id = self.sv_without_list_id;
            }

            if (!kStringIsEmpty(self.order_running_id)) {
                tableVC.order_running_id = self.order_running_id;
            }

            if (self.interface == 1 || self.interface == 3) {
                tableVC.vipBool = NO;
            } else {
                //会员销售的走这
                tableVC.vipBool = YES;
            }

            //结算成功后清除
            __weak typeof(self) weakSelf = self;
            tableVC.selectWaresBlock = ^(){
                //清空会员
                if (self.interface == 1) {
                    weakSelf.name = nil;
                    weakSelf.phone = nil;
                    weakSelf.discount = nil;
                    weakSelf.member_id = nil;
                    weakSelf.storedValue = nil;
                    weakSelf.headimg = nil;
                    weakSelf.sv_mr_cardno = nil;
                    weakSelf.member_Cumulative = nil;
                    weakSelf.sv_mr_pwd = nil;
                    weakSelf.grade = nil;
                    weakSelf.sv_without_list_id = nil;
                    weakSelf.order_running_id = nil;
                    weakSelf.sv_discount_configArray = nil;
                    //                    self.cleanBnt.hidden = YES;
                    //                    [weakSelf.button setTitle:@"选择会员" forState:UIControlStateNormal];

                    [self.button setTitle:@"选择会员" forState:UIControlStateNormal];
                    self.cleanBnt.hidden = YES;
                    self.button.frame = CGRectMake(45, 10, 50, 25);

                    //                    [weakSelf.button setTitle:nil forState:UIControlStateNormal];
                    //                    [weakSelf.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];

                }else if (self.interface == 2){ // 从会员快捷销售过来的
                    [weakSelf loadMemberStoreValue];
                }

                [weakSelf removeGoodsModelArr];
            };

          #pragma mark -  删除会员的清除
            tableVC.deleteMemberBlock = ^{
                weakSelf.name = nil;
                weakSelf.phone = nil;
                weakSelf.discount = nil;
                weakSelf.member_id = nil;
                weakSelf.storedValue = nil;
                weakSelf.headimg = nil;
                weakSelf.sv_mr_cardno = nil;
                weakSelf.member_Cumulative = nil;
                weakSelf.sv_mr_pwd = nil;
                weakSelf.grade = nil;
                weakSelf.sv_discount_configArray = nil;
                //                self.cleanBnt.hidden = YES;
                //                [weakSelf.button setTitle:@"选择会员" forState:UIControlStateNormal];
                [weakSelf.button setTitle:@"选择会员" forState:UIControlStateNormal];
                weakSelf.cleanBnt.hidden = YES;
                weakSelf.button.frame = CGRectMake(45, 10, 50, 25);
                //                [weakSelf.button setTitle:nil forState:UIControlStateNormal];
                //                [weakSelf.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];

                [weakSelf optimizeSettlement];
            };



            // 选择会员的block
            #pragma mark - 选择会员的block
//            tableVC.chooseMemberBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *member_Cumulative, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id) {
            tableVC.chooseMemberBlock = ^(NSString * _Nonnull name, NSString * _Nonnull phone, NSString * _Nonnull level, NSString * _Nonnull discount, NSString * _Nonnull member_id, NSString * _Nonnull storedValue, NSString * _Nonnull headimg, NSString * _Nonnull sv_mr_cardno, NSString * _Nonnull member_Cumulative, NSString * _Nonnull grade, NSArray * _Nonnull ClassifiedBookArray, NSString * _Nonnull memberlevel_id, NSString * _Nonnull sv_mw_sumpoint, NSString * _Nonnull sv_mr_birthday) {
                for (NSDictionary *dict in weakSelf.getUserLevelArray) {
                    NSString *memberlevel_id_getUserLevel = [NSString stringWithFormat:@"%@",dict[@"memberlevel_id"]];
                    if ([memberlevel_id_getUserLevel isEqualToString:memberlevel_id]) {
                        NSString *sv_discount_config_json = dict[@"sv_discount_config"];
                        NSData *data = [sv_discount_config_json dataUsingEncoding:NSUTF8StringEncoding];
                        if (data != NULL) {
                            weakSelf.sv_discount_configArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                            NSLog(@"self.sv_discount_configArray = %@",weakSelf.sv_discount_configArray);
                        }

                        break;
                    }
                }
              //  NSArray *ClassifiedBookArray, NSString *memberlevel_id
                if (![SVTool isBlankString:name]) {
                    [weakSelf.button setTitle:[name substringToIndex:1] forState:UIControlStateNormal];
                }else{
                    [weakSelf.button setTitle:name forState:UIControlStateNormal];
                }

                weakSelf.button.frame = CGRectMake(20, 10, 50, 25);
                [weakSelf.button setTitle:name forState:UIControlStateNormal];
                weakSelf.cleanBnt.hidden = NO;
                weakSelf.cleanBnt.frame = CGRectMake(75, 12, 20, 20);

                weakSelf.name = name;
                weakSelf.phone = phone;
                if ([SVTool isBlankString:discount]) {
                    discount = @"0";
                    weakSelf.discount = discount;
                }else{
                    weakSelf.discount = discount;
                }
                
                NSLog(@"weakSelf.discount = %@",weakSelf.discount);
                weakSelf.member_id = member_id;
                weakSelf.storedValue = storedValue;
                weakSelf.headimg = headimg;
                weakSelf.sv_mr_cardno = sv_mr_cardno;
                weakSelf.member_Cumulative = member_Cumulative;

                
                weakSelf.sv_mw_availablepoint = member_Cumulative;
                weakSelf.sv_mw_sumpoint = sv_mw_sumpoint;
                weakSelf.sv_mr_birthday = sv_mr_birthday;
                weakSelf.level = level;
                
                weakSelf.grade = grade;

                weakSelf.cleanBnt.hidden = NO;
                [weakSelf.button setTitle:name forState:UIControlStateNormal];

                [weakSelf optimizeSettlement];
            };


#pragma mark - 退出蒙版的操作
            tableVC.tuichuMengbanBlock = ^{
                [weakSelf optimizeSettlement];
                [weakSelf.twoTableView reloadData];
            };



            //跳转界面有导航栏的
            [self.navigationController pushViewController:tableVC animated:YES];

        }
        
    }
    
    
}

#pragma mark - 加载会员储值金额
- (void)loadMemberStoreValue{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *setURL = [URLhead stringByAppendingFormat:@"/api/user/%@?key=%@",self.member_id,token];
    
    [[SVSaviTool sharedSaviTool] GET:setURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic = %@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
            NSDictionary *values = dic[@"values"];
            if (![SVTool isBlankDictionary:values]) {
                        //积分
        NSString *sv_mw_availablepoint = [NSString stringWithFormat:@"%.2f",[values[@"sv_mw_availablepoint"] doubleValue]];
        self.member_Cumulative = sv_mw_availablepoint;
        
        //储值余额
        NSString *sv_mw_availableamount = [NSString stringWithFormat:@"%@",values[@"sv_mw_availableamount"]];
        self.storedValue = [NSString stringWithFormat:@"%.2f",[sv_mw_availableamount doubleValue]];
                if (self.memberDetail) {
                    self.memberDetail();
                }
                
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
    }];
}


#pragma mark - 数据请求
/**
 获取产品列表
 
 @param pageIndex 第几页
 @param pageSize 每页有几个
 @param category 只限大分类
 @param name 搜索关键字
 */
- (void)getDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize category:(NSString *)category producttype_id:(NSString *)producttype_id name:(NSString *)name isn:(NSString *)isn read_morespec:(NSString *)read_morespec{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetProductPcCashierList?key=%@&pageIndex=%li&pageSize=%li&category=%@&producttype_id=%@&name=%@&isn=%@&read_morespec=%@",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,category,producttype_id,name,isn,read_morespec];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic收银记账 = %@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
           
             NSDictionary *valuesDic = dic[@"values"];
                   
             NSArray *listArr = valuesDic[@"list"];
                   //1判断页数，第一次加载先移除数组元素 在将请求返回的数据添加进去，刷新页数改变直接添加数据到数组中
                   if (pageIndex == 1) {
                       //[self.goodsModelArr removeAllObjects];
                       //删除对应索引下的数据
                       [self.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:@[]];
                   }
                   
                   NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
                   
            if (![SVTool isEmpty:listArr]) {
            for (NSMutableDictionary *goodsDic in listArr) {
            //赋值给模型
            SVSelectedGoodsModel *goodsModel = [SVSelectedGoodsModel mj_objectWithKeyValues:goodsDic];
                           
           if (self.isScanButtonResponseEvent == YES && listArr.count == 1 &&goodsModel.sv_is_newspec !=1 ) {
              
               self.isScanButtonResponseEvent = NO;
                   [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
                   // for (SVduoguigeModel *model in selectModelArray) {
                   NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                   
                   //头像
                   if (![SVTool isBlankString:goodsModel.sv_p_images2]) {
                       [dic setObject:goodsModel.sv_p_images2 forKey:@"sv_p_images2"];
                   }
                   [dic setObject:goodsModel.sv_pricing_method forKey:@"sv_pricing_method"];
                   //套餐类型
                   [dic setObject:goodsModel.sv_product_type forKey:@"sv_product_type"];
                   //商品名
                   [dic setObject:goodsModel.sv_p_name forKey:@"sv_p_name"];
                   //单价
                   [dic setObject:goodsModel.sv_p_unitprice forKey:@"sv_p_unitprice"];
                   
                   [dic setObject:goodsModel.sv_p_unitprice forKey:@"product_unitprice"];
                   //会员售价
                   [dic setObject:goodsModel.sv_p_memberprice forKey:@"sv_p_memberprice"];
                   //库存
                   [dic setObject:goodsModel.sv_p_storage forKey:@"sv_p_storage"];
                   //单位
                   [dic setObject:goodsModel.sv_p_unit forKey:@"sv_p_unit"];
                   //商品ID
                   [dic setObject:goodsModel.product_id forKey:@"product_id"];
                   // 商品款号
                   [dic setObject:goodsModel.sv_p_barcode forKey:@"sv_p_barcode"];
                   //记录点击后的件数
                   [dic setObject:@"1" forKey:@"product_num"];
                   [dic setObject:@"0" forKey:@"ImageHidden"];
                   // 规格
                   [dic setObject:goodsModel.sv_p_specs forKey:@"sv_p_specs"];
                   // 是否是多规格
                   [dic setObject:@(goodsModel.sv_is_newspec) forKey:@"sv_is_newspec"];
                   // 会员ID
                   if (![SVTool isBlankString:self.member_id]) {
                       [dic setObject:self.member_id forKey:@"member_id"];
                   }
                   // 会员折
                   if (![SVTool isBlankString:self.discount]) {
                       [dic setObject:self.discount forKey:@"discount"];
                   }
                   
                   // 大分类ID
                   [dic setObject:goodsModel.productcategory_id forKey:@"productcategory_id"];
                   // 小分类ID
                   [dic setObject:goodsModel.productsubcategory_id forKey:@"productsubcategory_id"];
                   
                   // 进货价
                   [dic setObject:goodsModel.sv_purchaseprice forKey:@"sv_purchaseprice"];
                   
               if (goodsModel.sv_pricing_method.integerValue == 1){// 这是称重的
                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                   ZYInputAlertView *alertView = [ZYInputAlertView alertView];
                   alertView.confirmBgColor = navigationBackgroundColor;
                   alertView.colorLabel.text = @"输入重量";
                   alertView.placeholder = @"输入重量";
                   alertView.inputTextView.keyboardType = UIKeyboardTypeDecimalPad;
                   [alertView show];
                   alertView.textfieldStrBlock = ^(NSString *str) {
                       double product_num = str.doubleValue;
                       
                      // model.product_num += product_num;
                       
                       //记录点击后的件数
                       [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                       // 进货价
                       [dic setObject:goodsModel.sv_purchaseprice forKey:@"sv_purchaseprice"];
                       
                       [dic setObject:goodsModel.sv_purchaseprice forKey:@"sv_purchaseprice"];
                       NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable]; //
                       
                       if (self.goodsArr.count == 0) {
                           //第一个选中时添加
                           if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                               if (goodsModel.sv_p_storage.doubleValue < 1) {
                                   [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                   return;
                               }
                           }
                           self.isScanButtonResponseEvent = NO;
                           [self.goodsArr addObject:dic];
                           
                                    [SVUserManager loadUserInfo];
                                       if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                                           SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                           [cell.addNumberBtn setTitle:[NSString stringWithFormat:@"%.2f",product_num] forState:UIControlStateNormal];
                                           cell.reduceButton.hidden = NO;
                                           cell.addNumberBtn.hidden = NO;
                                         //  cell.icon_addImage.hidden = YES;
                                       }else{
                                           SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                           cell.countText.text = [NSString stringWithFormat:@"%.2f",product_num];
                                        //       cell.icon_addImage.hidden = YES;
                                           cell.reduceButton.hidden = NO;
                                         //  cell.addNumberBtn.hidden = YES;
                           //                cell.addNumberBtn.hidden = YES;
                           //                cell.countText.hidden = NO;
                                         //  self.rightDistance.constant = 0;
                                       }
                          
                           
                       } else {
                           //判断相同时，先删掉，再添加到数组中
                           for (NSMutableDictionary *dict in self.goodsArr) {
                               SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                               if (modell.product_id == goodsModel.product_id) {
                                   double product_num = [dict[@"product_num"] doubleValue];
                                   product_num = str.doubleValue;
                                   [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                                   // 这里判断是否允许0库存销售
                                   if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                                       if (goodsModel.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                                          [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                       
                                           return;
                                       }
                                   }
                                   [self.goodsArr removeObject:dict];
                                   break;
                               }
                               
                           }
                           // 这里判断是否允许0库存销售
                           if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                               if (goodsModel.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                                   [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                   return;
                               }
                           }
                           
                           
                           [SVUserManager loadUserInfo];
                           if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                               SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                              [cell.addNumberBtn setTitle:[NSString stringWithFormat:@"%.2f",product_num] forState:UIControlStateNormal];
                               cell.reduceButton.hidden = NO;
                               cell.addNumberBtn.hidden = NO;
                             //  cell.icon_addImage.hidden = YES;
                           }else{
                               SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
       //                        cell.countText.text = [NSString stringWithFormat:@"%.2f",product_num];
       //                        cell.icon_addImage.hidden = YES;
       //                        cell.reduceButton.hidden = NO;
       //                        cell.addNumberBtn.hidden = NO;
                               cell.countText.text = dic[@"product_num"];
                              // cell.icon_addImage.hidden = YES;
                               cell.reduceButton.hidden = NO;
                           }
       //                    cell.countText.text = dic[@"product_num"];
       //                    cell.icon_addImage.hidden = YES;
       //                    cell.reduceButton.hidden = NO;
                           [self.goodsArr addObject:dic];
                           
                       }
                       self.isScanButtonResponseEvent = NO;
                       // 优化代码的部分
                       [self optimizeSettlement];
                       
                       if (kArrayIsEmpty(self.goodsArr)) {
                           // 改名称
                           [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
                       }else{
                           // 改名称
                           [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
                       }
                      // SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                       //  动效block
                       //   cell.shopCartBlock = ^(UIImageView *imageView){
                       CGRect rect = [self.twoTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                       rect.origin.y = rect.origin.y - [self.twoTableView contentOffset].y;
                       SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                       UIImageView *imageView = cell.icon_addImage;
                       CGRect headRect = imageView.frame;
                       headRect.origin.y = rect.origin.y+headRect.origin.y;
                       
                       __weak typeof(self) weakSelf = self;
                       [self startAnimationWithRect:headRect ImageView:imageView completion:^(BOOL compleBool) {
                           if (compleBool == YES) {
                               //抖动的动效
                               CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                               shakeAnimation.duration = 0.1f;
                               shakeAnimation.fromValue = [NSNumber numberWithDouble:-5];
                               shakeAnimation.toValue = [NSNumber numberWithDouble:5];
                               shakeAnimation.autoreverses = YES;
                               
                               [weakSelf.waresFooterButton.sumCountlbl.layer addAnimation:shakeAnimation forKey:nil];
                               [weakSelf.waresFooterButton.icon.layer addAnimation:shakeAnimation forKey:nil];
                               
                           }
                       }];

                   };
                 
               }else{
                   NSLog(@"model.product_num9999 = %ld",goodsModel.product_num);
                   
                   if (self.goodsArr.count == 0) {
                       //第一个选中时添加
                       // if (model.product_num != 0) {
                       [self.goodsArr addObject:dic];
                       // }
                       self.isScanButtonResponseEvent = NO;
                       [self optimizeSettlement];
                   } else {
                       NSInteger totleNum = 0.0;
                       for (NSDictionary *dict in self.goodsArr) {
                           SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                           NSLog(@"modell.product_num = %f",modell.product_num);
                           if (modell.product_id == goodsModel.product_id) {
                               //  model.product_num += modell.product_num;
                               totleNum = modell.product_num + goodsModel.product_num;
                               NSLog(@"model.product_num8888 = %ld",goodsModel.product_num);
                               [dic setObject:[NSString stringWithFormat:@"%ld",(long)totleNum] forKey:@"product_num"];
                               [self.goodsArr removeObject:dict];
                               break;
                           }
                       }
                       
                       [self.goodsArr addObject:dic];
                       //   }
                       NSLog(@"self.goodsArr = %@",self.goodsArr);
                       self.isScanButtonResponseEvent = NO;
                       [self optimizeSettlement];
                                   
                   }
                   NSInteger selectedIndex = 0;
                   NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                   CGRect rect = [self.twoTableView rectForRowAtIndexPath:selectedIndexPath];
                   rect.origin.y = rect.origin.y - [self.twoTableView contentOffset].y;
                   SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:selectedIndexPath];
                   UIImageView *imageView = cell.icon_addImage;
                   CGRect headRect = imageView.frame;
                   headRect.origin.y = rect.origin.y+headRect.origin.y;
                 
                   __weak typeof(self) weakSelf = self;
                   [self startAnimationWithRect:headRect ImageView:imageView completion:^(BOOL compleBool) {
                       if (compleBool == YES) {
                           //抖动的动效
                           CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                           shakeAnimation.duration = 0.1f;
                           shakeAnimation.fromValue = [NSNumber numberWithDouble:-5];
                           shakeAnimation.toValue = [NSNumber numberWithDouble:5];
                           shakeAnimation.autoreverses = YES;
                           
                           [weakSelf.waresFooterButton.sumCountlbl.layer addAnimation:shakeAnimation forKey:nil];
                           [weakSelf.waresFooterButton.icon.layer addAnimation:shakeAnimation forKey:nil];
                           
                       }
                   }];
             
               }

           }else if (goodsModel.sv_is_newspec == 1 && self.isScanButtonResponseEvent == YES){ // 这里就是输入款号的 push出控制器选择多规格商品
               if ([goodsModel.sv_p_artno isEqualToString:name]) { // 扫条码加入购物车
                   
                   self.isScanButtonResponseEvent = NO;
                       [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
                       // for (SVduoguigeModel *model in selectModelArray) {
                       NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                       
                       //头像
                       if (![SVTool isBlankString:goodsModel.sv_p_images2]) {
                           [dic setObject:goodsModel.sv_p_images2 forKey:@"sv_p_images2"];
                       }
                       [dic setObject:goodsModel.sv_pricing_method forKey:@"sv_pricing_method"];
                       //套餐类型
                       [dic setObject:goodsModel.sv_product_type forKey:@"sv_product_type"];
                       //商品名
                       [dic setObject:goodsModel.sv_p_name forKey:@"sv_p_name"];
                       //单价
                       [dic setObject:goodsModel.sv_p_unitprice forKey:@"sv_p_unitprice"];
                       
                       [dic setObject:goodsModel.sv_p_unitprice forKey:@"product_unitprice"];
                       //会员售价
                       [dic setObject:goodsModel.sv_p_memberprice forKey:@"sv_p_memberprice"];
                       //库存
                       [dic setObject:goodsModel.sv_p_storage forKey:@"sv_p_storage"];
                       //单位
                       [dic setObject:goodsModel.sv_p_unit forKey:@"sv_p_unit"];
                       //商品ID
                       [dic setObject:goodsModel.product_id forKey:@"product_id"];
                       // 商品款号
                       [dic setObject:goodsModel.sv_p_barcode forKey:@"sv_p_barcode"];
                       //记录点击后的件数
                       [dic setObject:@"1" forKey:@"product_num"];
                       [dic setObject:@"0" forKey:@"ImageHidden"];
                       // 规格
                       [dic setObject:goodsModel.sv_p_specs forKey:@"sv_p_specs"];
                       // 是否是多规格
                       [dic setObject:@(goodsModel.sv_is_newspec) forKey:@"sv_is_newspec"];
                       // 会员ID
                       if (![SVTool isBlankString:self.member_id]) {
                           [dic setObject:self.member_id forKey:@"member_id"];
                       }
                       // 会员折
                       if (![SVTool isBlankString:self.discount]) {
                           [dic setObject:self.discount forKey:@"discount"];
                       }
                       
                       // 大分类ID
                       [dic setObject:goodsModel.productcategory_id forKey:@"productcategory_id"];
                       // 小分类ID
                       [dic setObject:goodsModel.productsubcategory_id forKey:@"productsubcategory_id"];
                       
                       // 进货价
                       [dic setObject:goodsModel.sv_purchaseprice forKey:@"sv_purchaseprice"];
                       
                   if (goodsModel.sv_pricing_method.integerValue == 1){// 这是称重的
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       ZYInputAlertView *alertView = [ZYInputAlertView alertView];
                       alertView.confirmBgColor = navigationBackgroundColor;
                       alertView.colorLabel.text = @"输入重量";
                       alertView.placeholder = @"输入重量";
                       alertView.inputTextView.keyboardType = UIKeyboardTypeDecimalPad;
                       [alertView show];
                       alertView.textfieldStrBlock = ^(NSString *str) {
                           double product_num = str.doubleValue;
                           
                          // model.product_num += product_num;
                           
                           //记录点击后的件数
                           [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                           // 进货价
                           [dic setObject:goodsModel.sv_purchaseprice forKey:@"sv_purchaseprice"];
                           
                           [dic setObject:goodsModel.sv_purchaseprice forKey:@"sv_purchaseprice"];
                           NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable]; //
                           
                           if (self.goodsArr.count == 0) {
                               //第一个选中时添加
                               if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                                   if (goodsModel.sv_p_storage.doubleValue < 1) {
                                       [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                       return;
                                   }
                               }
                               self.isScanButtonResponseEvent = NO;
                               [self.goodsArr addObject:dic];
                               
                                        [SVUserManager loadUserInfo];
                                           if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                                               SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                               [cell.addNumberBtn setTitle:[NSString stringWithFormat:@"%.2f",product_num] forState:UIControlStateNormal];
                                               cell.reduceButton.hidden = NO;
                                               cell.addNumberBtn.hidden = NO;
                                             //  cell.icon_addImage.hidden = YES;
                                           }else{
                                               SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                               cell.countText.text = [NSString stringWithFormat:@"%.2f",product_num];
                                            //       cell.icon_addImage.hidden = YES;
                                               cell.reduceButton.hidden = NO;
                                             //  cell.addNumberBtn.hidden = YES;
                               //                cell.addNumberBtn.hidden = YES;
                               //                cell.countText.hidden = NO;
                                             //  self.rightDistance.constant = 0;
                                           }
                              
                               
                           } else {
                               //判断相同时，先删掉，再添加到数组中
                               for (NSMutableDictionary *dict in self.goodsArr) {
                                   SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                                   if (modell.product_id == goodsModel.product_id) {
                                       double product_num = [dict[@"product_num"] doubleValue];
                                       product_num = str.doubleValue;
                                       [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                                       // 这里判断是否允许0库存销售
                                       if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                                           if (goodsModel.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                                              [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                           
                                               return;
                                           }
                                       }
                                       [self.goodsArr removeObject:dict];
                                       break;
                                   }
                                   
                               }
                               // 这里判断是否允许0库存销售
                               if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                                   if (goodsModel.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                                       [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                       return;
                                   }
                               }
                               
                               
                               [SVUserManager loadUserInfo];
                               if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                                   SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                                  [cell.addNumberBtn setTitle:[NSString stringWithFormat:@"%.2f",product_num] forState:UIControlStateNormal];
                                   cell.reduceButton.hidden = NO;
                                   cell.addNumberBtn.hidden = NO;
                                 //  cell.icon_addImage.hidden = YES;
                               }else{
                                   SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
           //                        cell.countText.text = [NSString stringWithFormat:@"%.2f",product_num];
           //                        cell.icon_addImage.hidden = YES;
           //                        cell.reduceButton.hidden = NO;
           //                        cell.addNumberBtn.hidden = NO;
                                   cell.countText.text = dic[@"product_num"];
                                  // cell.icon_addImage.hidden = YES;
                                   cell.reduceButton.hidden = NO;
                               }
           //                    cell.countText.text = dic[@"product_num"];
           //                    cell.icon_addImage.hidden = YES;
           //                    cell.reduceButton.hidden = NO;
                               [self.goodsArr addObject:dic];
                               
                           }
                           self.isScanButtonResponseEvent = NO;
                           // 优化代码的部分
                           [self optimizeSettlement];
                           
                           if (kArrayIsEmpty(self.goodsArr)) {
                               // 改名称
                               [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
                           }else{
                               // 改名称
                               [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
                           }
                          // SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                           //  动效block
                           //   cell.shopCartBlock = ^(UIImageView *imageView){
                           CGRect rect = [self.twoTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                           rect.origin.y = rect.origin.y - [self.twoTableView contentOffset].y;
                           SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                           UIImageView *imageView = cell.icon_addImage;
                           CGRect headRect = imageView.frame;
                           headRect.origin.y = rect.origin.y+headRect.origin.y;
                           
                           __weak typeof(self) weakSelf = self;
                           [self startAnimationWithRect:headRect ImageView:imageView completion:^(BOOL compleBool) {
                               if (compleBool == YES) {
                                   //抖动的动效
                                   CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                                   shakeAnimation.duration = 0.1f;
                                   shakeAnimation.fromValue = [NSNumber numberWithDouble:-5];
                                   shakeAnimation.toValue = [NSNumber numberWithDouble:5];
                                   shakeAnimation.autoreverses = YES;
                                   
                                   [weakSelf.waresFooterButton.sumCountlbl.layer addAnimation:shakeAnimation forKey:nil];
                                   [weakSelf.waresFooterButton.icon.layer addAnimation:shakeAnimation forKey:nil];
                                   
                               }
                           }];

                       };
                     
                   }else{
                       NSLog(@"model.product_num9999 = %ld",goodsModel.product_num);
                       
                       if (self.goodsArr.count == 0) {
                           //第一个选中时添加
                           // if (model.product_num != 0) {
                           [self.goodsArr addObject:dic];
                           // }
                           self.isScanButtonResponseEvent = NO;
                           [self optimizeSettlement];
                       } else {
                           NSInteger totleNum = 0.0;
                           for (NSDictionary *dict in self.goodsArr) {
                               SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                               NSLog(@"modell.product_num = %f",modell.product_num);
                               if (modell.product_id == goodsModel.product_id) {
                                   //  model.product_num += modell.product_num;
                                   totleNum = modell.product_num + goodsModel.product_num;
                                   NSLog(@"model.product_num8888 = %ld",goodsModel.product_num);
                                   [dic setObject:[NSString stringWithFormat:@"%ld",(long)totleNum] forKey:@"product_num"];
                                   [self.goodsArr removeObject:dict];
                                   break;
                               }
                           }
                           
                           [self.goodsArr addObject:dic];
                           //   }
                           NSLog(@"self.goodsArr = %@",self.goodsArr);
                           self.isScanButtonResponseEvent = NO;
                           [self optimizeSettlement];
                                       
                       }
                       NSInteger selectedIndex = 0;
                       NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                       CGRect rect = [self.twoTableView rectForRowAtIndexPath:selectedIndexPath];
                       rect.origin.y = rect.origin.y - [self.twoTableView contentOffset].y;
                       SVSelectGoodsViewCell *cell = [self.twoTableView cellForRowAtIndexPath:selectedIndexPath];
                       UIImageView *imageView = cell.icon_addImage;
                       CGRect headRect = imageView.frame;
                       headRect.origin.y = rect.origin.y+headRect.origin.y;
                     
                       __weak typeof(self) weakSelf = self;
                       [self startAnimationWithRect:headRect ImageView:imageView completion:^(BOOL compleBool) {
                           if (compleBool == YES) {
                               //抖动的动效
                               CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                               shakeAnimation.duration = 0.1f;
                               shakeAnimation.fromValue = [NSNumber numberWithDouble:-5];
                               shakeAnimation.toValue = [NSNumber numberWithDouble:5];
                               shakeAnimation.autoreverses = YES;
                               
                               [weakSelf.waresFooterButton.sumCountlbl.layer addAnimation:shakeAnimation forKey:nil];
                               [weakSelf.waresFooterButton.icon.layer addAnimation:shakeAnimation forKey:nil];
                               
                           }
                       }];
                 
                   }

               }else{ // 扫码款号push
                   SVShopSingleTemplateVC *shopSingleTemplateVC = [[SVShopSingleTemplateVC alloc] init];
                  // self.indexPath = indexPath;
                   // shopSingleTemplateVC.delegate = self.stockCheckVC;
                   shopSingleTemplateVC.selectNumber = 1;
                   shopSingleTemplateVC.productID = goodsModel.product_id;
                   shopSingleTemplateVC.sv_p_name = goodsModel.sv_p_name;
                   shopSingleTemplateVC.sv_p_images2 = goodsModel.sv_p_images2;
                   shopSingleTemplateVC.sv_p_images = goodsModel.sv_p_images;
                   shopSingleTemplateVC.sv_p_unitprice = goodsModel.sv_p_unitprice;
                   shopSingleTemplateVC.sv_p_barcode = goodsModel.sv_p_barcode;
                   shopSingleTemplateVC.delegate = self;
                   self.isScanButtonResponseEvent = NO;
                   [self.navigationController pushViewController:shopSingleTemplateVC animated:YES];
               }
              
           }
                         //  self.goodsModel = goodsModel;
                           //模型给数组
                           [ary_1 addObject:goodsModel];
                       }
                       //数组给模型数组
                       [self.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:ary_1];
                       
                       if (ary_1.count >= 20) {
                           if (self.twoTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                               /** 普通闲置状态 */
                               self.twoTableView.mj_footer.state = MJRefreshStateIdle;
                           }
                       }
                       
                       self.img.hidden = YES;
                       self.noWares.hidden = YES;
                       self.addButton.hidden = YES;
                       
                   }else {
                       /** 所有数据加载完毕，没有更多的数据了 */
                       self.twoTableView.mj_footer.state = MJRefreshStateNoMoreData;
                       
                       if ([SVTool isEmpty:ary_1]) {
                           //用判断来显示不同的提示
                           if (self.sao == NO) {
                               self.noWares.hidden = NO;
                               self.addButton.hidden = NO;
                               self.img.hidden = YES;
                           } else {
                               self.img.hidden = NO;
                               self.addButton.hidden = NO;
                               self.noWares.hidden = YES;
                           }
                       }
                   }
           
            [self.twoTableView reloadData];
            if (self.GuidedGraph == 1) {
                 if (![NSUserDefaults.standardUserDefaults boolForKey:@"skipTutorial"]) {
                     [IIGuideViewController showsInViewController:self];
                }
                
                self.GuidedGraph = 2;// 即使刷新也不要在进来
            }
                 
                   //是否正在刷新
                   if ([self.twoTableView.mj_header isRefreshing]) {
                       //结束刷新状态
                       [self.twoTableView.mj_header endRefreshing];
                   }
                   
                   //是否正在刷新
                   if ([self.twoTableView.mj_footer isRefreshing]) {
                       //结束刷新状态
                       [self.twoTableView.mj_footer endRefreshing];
                   }
        }else{
             [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        
       
        self.isScanButtonResponseEvent = NO;
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        
    }];
}



#pragma mark - tablevewiDegelate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.oneTableView) {
        return 55;
    }else{
        return 80;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.oneTableView) {
        return self.bigNameArr.count;
    }else{
        
        NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        
        return ary_1.count;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.oneTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectWaresOneID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectWaresOneID];
        }
        //赋值
        cell.textLabel.text = self.bigNameArr[indexPath.row];
        //设置字体大小
        cell.textLabel.font = [UIFont systemFontOfSize: 13];
        //设置label的行数
        cell.textLabel.numberOfLines = 0;
        //字体中
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //字体颜色
        cell.textLabel.textColor = GlobalFontColor;
        //背景色
        cell.backgroundColor = BackgroundColor;
        //选中后显示的效果
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:nil highlightedImage:[UIImage imageNamed:@"leftbackgroup_red"]];
        //选中后字体颜色
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        
        //默认显示第一个子分类商品
        //if (indexPath.row == 0) {
        //self.productcategory_id = [self.bigIDArr objectAtIndex:indexPath.row];
        //[self getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
        //}
        
        return cell;
    } else {
        
            SVSelectGoodsViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:selectWaresTwoID];
            NSLog(@"[SVUserManager shareInstance].sv_uit_cache_name = %@",[SVUserManager shareInstance].sv_uit_cache_name);
            if (!cell) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"SVSelectedGoodsCell" owner:nil options:nil].lastObject;
            }
       
            //取消高亮
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            cell.addAndReduceView.hidden = NO;
            //            cell.goumaibtn.hidden = YES;
        cell.addNumberBtn.tag = indexPath.row;
        [cell.addNumberBtn addTarget:self action:@selector(addNumberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
            if (ary_1.count > indexPath.row) {
                SVSelectedGoodsModel *model = [ary_1 objectAtIndex:indexPath.row];
              //  NSLog(@"88883333model.product_num === %f",model.product_num);
                //            model.indexPath = indexPath;
                if (self.goodsArr.count == 0) {
                    model.indexPath = indexPath;
                    cell.goodsModel = model;
                    cell.indexPatch = indexPath;
                } else {
                    
                    for (NSDictionary *dict in self.goodsArr) {
                        SVSelectedGoodsModel *equalModel = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                        
                        if ([equalModel.product_id isEqualToString:model.product_id]) {
                            model.indexPath = indexPath;
                            cell.goodsModel = equalModel;
                            cell.indexPatch = indexPath;
                            return cell;
                        }
                        model.indexPath = indexPath;
                        cell.goodsModel = model;
                        cell.indexPatch = indexPath;
                      // NSLog(@"9999model.product_num === %f",model.product_num);
                    }
                }
                
            }
         //   这里？更改的地方 SVSelectedGoodsModel
            __weak typeof(self) weakSelf = self;
            [cell setCountChangeBlock:^(SVSelectedGoodsModel *model,NSIndexPath *indexPatch){
                 SVSelectGoodsViewCell *cell = [tableView cellForRowAtIndexPath:indexPatch];
                
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    
                    //头像
                    if (![SVTool isBlankString:model.sv_p_images]) {
                        [dic setObject:model.sv_p_images forKey:@"sv_p_images"];
                    }
                    
                    [dic setObject:model.sv_pricing_method forKey:@"sv_pricing_method"];
                    //套餐类型
                    [dic setObject:model.sv_product_type forKey:@"sv_product_type"];
                    
                    //商品名
                    [dic setObject:model.sv_p_name forKey:@"sv_p_name"];
                    //单价
                    [dic setObject:model.sv_p_unitprice forKey:@"sv_p_unitprice"];
                    [dic setObject:model.sv_p_unitprice forKey:@"product_unitprice"];
                    //会员售价
                    [dic setObject:model.sv_p_memberprice forKey:@"sv_p_memberprice"];
                    //库存
                    [dic setObject:model.sv_p_storage forKey:@"sv_p_storage"];
                    //单位
                
                if (!kStringIsEmpty(model.sv_p_unit)) {
                    [dic setObject:model.sv_p_unit forKey:@"sv_p_unit"];
                }
                   
                    //商品ID
                    [dic setObject:model.product_id forKey:@"product_id"];
                    // 商品款号
                    [dic setObject:model.sv_p_barcode forKey:@"sv_p_barcode"];
                    // 是否显示加号
                    [dic setObject:model.ImageHidden forKey:@"ImageHidden"];
                    //记录点击后的件数
                    [dic setObject:[NSString stringWithFormat:@"%.2f",model.product_num] forKey:@"product_num"];
                    // 进货价
                    [dic setObject:model.sv_purchaseprice forKey:@"sv_purchaseprice"];
                    // 大分类ID
                    [dic setObject:model.productcategory_id forKey:@"productcategory_id"];
                    // 小分类ID
                    [dic setObject:model.productsubcategory_id forKey:@"productsubcategory_id"];
                if (!kStringIsEmpty(model.isPriceChange)) {
                     [dic setObject:model.isPriceChange forKey:@"isPriceChange"];
                }
                  
                
                if (model.sv_pricing_method.integerValue == 1) { // 是计重的
                    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
                    alertView.confirmBgColor = navigationBackgroundColor;
                    alertView.colorLabel.text = @"输入重量";
                    alertView.placeholder = @"输入重量";
                    alertView.inputTextView.keyboardType = UIKeyboardTypeDecimalPad;
                    [alertView show];
                    alertView.textfieldStrBlock = ^(NSString *str) {
                        double product_num = str.doubleValue;
//                        if (product_num > model.product_num) {
//                            [SVTool TextButtonActionWithSing:@"请输入正确数据"];
//                        }else{

                            if (weakSelf.goodsArr.count == 0) {
                                //第一个选中时添加
                                // if (model.product_num != 0) {
                                dic[@"product_num"] = [NSString stringWithFormat:@"%.2f",[dic[@"product_num"] doubleValue]-product_num];
                                [weakSelf.goodsArr addObject:dic];
                                // }
                                
                                [SVUserManager loadUserInfo];
                                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                                   NSString *text = dic[@"product_num"];
                                   // cell.countText.text = [NSString stringWithFormat:@"%.2f",text.doubleValue - 1];
                                    [cell.addNumberBtn setTitle:text forState:UIControlStateNormal];
                                  //  cell.icon_addImage.hidden = NO;
                                    cell.reduceButton.hidden = YES;
                                }else{
                                  NSString *text = dic[@"product_num"];
                                    cell.countText.text = text;

                                    cell.reduceButton.hidden = YES;
                                    //                cell.addNumberBtn.hidden = YES;
                                    //                cell.countText.hidden = NO;
                                    //  self.rightDistance.constant = 0;
                                }
                                
                               
                                
                            } else {
                                for (NSDictionary *dict in weakSelf.goodsArr) {
                                    SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                                    if (modell.product_id == model.product_id) {
                                        
                                        double product_numTwo = [dict[@"product_num"] doubleValue];
                                        if (product_numTwo < product_num) {
                                            return ;
                                        }else{
                                            product_numTwo -= product_num;
                                            [dic setObject:[NSString stringWithFormat:@"%.2f",product_numTwo] forKey:@"product_num"];
                                            
                                            [weakSelf.goodsArr removeObject:dict];
                                            break;

                                        }
                                    }
                                }
                                
                                NSString *text = dic[@"product_num"];
                                [SVUserManager loadUserInfo];
                                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                                    if (text.doubleValue == 0) {
                                                                  // [self.twoTableView reloadData];
                                       // cell.countText.text = text;
                                        [cell.addNumberBtn setTitle:text forState:UIControlStateNormal];

                                        cell.reduceButton.hidden = YES;
                                    }else{
                                      //  cell.countText.text = text;
                                         [cell.addNumberBtn setTitle:text forState:UIControlStateNormal];
                                      //  cell.icon_addImage.hidden = YES;
                                        cell.reduceButton.hidden = NO;
                                    }
                                                                  
                                }else{
                                    if (text.doubleValue == 0) {
                                                                  // [self.twoTableView reloadData];
                                        cell.countText.text = text;
                                      //  cell.icon_addImage.hidden = NO;
                                        cell.reduceButton.hidden = YES;
                                    }else{
                                        cell.countText.text = text;

                                        cell.reduceButton.hidden = NO;
                                    }
                                                                  
                                }

                                //为0时，不添加
                                 if ([dic[@"product_num"] doubleValue] != 0) {
                                [weakSelf.goodsArr addObject:dic];
                                 }
                            }
                            
                        //}
                        
                    };
                }else{
                    if (weakSelf.goodsArr.count == 0) {
                        //第一个选中时添加
                        // if (model.product_num != 0) {
                        dic[@"product_num"] = [NSString stringWithFormat:@"%.2f",[dic[@"product_num"] doubleValue]-1];
                        [weakSelf.goodsArr addObject:dic];
                        // }
                        [SVUserManager loadUserInfo];
                        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                            NSString *text = dic[@"product_num"];
                           // cell.countText.text = [NSString stringWithFormat:@"%.2f",text.doubleValue - 1];
                            [cell.addNumberBtn setTitle:[NSString stringWithFormat:@"%.2f",text.doubleValue - 1] forState:UIControlStateNormal];
                           // cell.icon_addImage.hidden = NO;
                            cell.reduceButton.hidden = YES;
                        }else{
                            NSString *text = dic[@"product_num"];
                            cell.countText.text = [NSString stringWithFormat:@"%.2f",text.doubleValue - 1];

                            cell.reduceButton.hidden = YES;
                        }
                       
                        
                    } else {
                        //判断相同时，先删掉，再添加到数组中
                        for (NSDictionary *dict in weakSelf.goodsArr) {
                            SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                            if (modell.product_id == model.product_id) {
                                
                                double product_num = [dict[@"product_num"] doubleValue];
                                product_num -= 1;
                                [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                                
                                [weakSelf.goodsArr removeObject:dict];
                                break;
                            }
                        }
                        
                        NSString *text = dic[@"product_num"];
                        [SVUserManager loadUserInfo];
                        if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                            if (text.doubleValue == 0) {
                               // cell.countText.text = text;
                                [cell.addNumberBtn setTitle:text forState:UIControlStateNormal];

                                cell.reduceButton.hidden = YES;
                            }else{
                               // cell.countText.text = text;
                                [cell.addNumberBtn setTitle:text forState:UIControlStateNormal];

                                cell.reduceButton.hidden = NO;
                            }
                                                                                 // [self.twoTableView reloadData];
                        }else{
                            if (text.doubleValue == 0) {
                                                      // [self.twoTableView reloadData];
                            cell.countText.text = text;

                         //   cell.icon_addImage.hidden = NO;
                            cell.reduceButton.hidden = YES;
                            }else{
                            cell.countText.text = text;

                            cell.reduceButton.hidden = NO;
                            }
                        }
                      
                        
                        //为0时，不添加
                         if ([dic[@"product_num"] doubleValue] != 0) {
                        [weakSelf.goodsArr addObject:dic];
                          }
                        
                    }
                }
              
              
                    
                [weakSelf optimizeSettlement];
                    
                    if (kArrayIsEmpty(weakSelf.goodsArr)) {
                        // 改名称
                        [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
                    }else{
                        // 改名称
                        [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
                    }
                    
            }];
        
        
            return cell;
        
    }
    
}

#pragma mark - 点击数量文字
- (void)addNumberBtnClick:(UIButton *)btn{
    
    NSLog(@"btn.titleLabel.text = %@",btn.titleLabel.text);
    
    // SVSelectGoodsViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  // NSDictionary *dict =self.goodsArr[btn.tag];
     NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
  //  NSArray *ary_2 = [ary_1 copy];
    SVSelectedGoodsModel *model2 = [ary_1 objectAtIndex:btn.tag];
   // SVSelectedGoodsModel *model3 = [model2 mutableCopy];
   // SVSelectedGoodsModel *model2 = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
    NSString *numberText = [NSString stringWithFormat:@"%@",btn.titleLabel.text];
   // model2.product_num = [numberText doubleValue];
    SVMultiPriceVC *multiPriceVC = [[SVMultiPriceVC alloc] init];
    multiPriceVC.product_num = [numberText doubleValue];
    multiPriceVC.model = model2;
    [self.navigationController pushViewController:multiPriceVC animated:YES];
    
    multiPriceVC.multiModelBlock = ^(SVSelectedGoodsModel * _Nonnull model, NSIndexPath * _Nonnull indexPath, double product_num) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [ary_1 replaceObjectAtIndex:indexPath.row withObject:model];//替换，就是为了证明这个是改价后的模型
        
        NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable]; //
        //头像
        if (![SVTool isBlankString:model.sv_p_images]) {
            [dic setObject:model.sv_p_images forKey:@"sv_p_images"];
        }
        
        [dic setObject:model.sv_pricing_method forKey:@"sv_pricing_method"];
        //套餐类型
        [dic setObject:model.sv_product_type forKey:@"sv_product_type"];
        
        //商品名
        [dic setObject:model.sv_p_name forKey:@"sv_p_name"];
        //单价
        [dic setObject:model.sv_p_unitprice forKey:@"sv_p_unitprice"];
        [dic setObject:model.sv_p_unitprice forKey:@"product_unitprice"];
        
         if (!kStringIsEmpty(model.isPriceChange)) {
             [dic setObject:model.isPriceChange forKey:@"isPriceChange"];
             [dic setObject:model.priceChange forKey:@"priceChange"];
         }
                       
        
        //会员售价
        [dic setObject:model.sv_p_memberprice forKey:@"sv_p_memberprice"];
        //库存
        [dic setObject:model.sv_p_storage forKey:@"sv_p_storage"];
        //单位
        if (!kStringIsEmpty(model.sv_p_unit)) {
            [dic setObject:model.sv_p_unit forKey:@"sv_p_unit"];
        }
        //商品ID
        [dic setObject:model.product_id forKey:@"product_id"];
        // 商品款号
        [dic setObject:model.sv_p_barcode forKey:@"sv_p_barcode"];
        // 是否显示加号
        [dic setObject:model.ImageHidden forKey:@"ImageHidden"];
        //记录点击后的件数
        [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
        // 进货价
        [dic setObject:model.sv_purchaseprice forKey:@"sv_purchaseprice"];
        // 大分类ID
        [dic setObject:model.productcategory_id forKey:@"productcategory_id"];
        // 小分类ID
        [dic setObject:model.productsubcategory_id forKey:@"productsubcategory_id"];
        // (价格类型，0-不可以改价  1-可以改价)
        [dic setObject:@"0" forKey:@"sv_unitprice_type"];
        
        if (self.goodsArr.count == 0) {
            
            if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                if (model.sv_p_storage.doubleValue < 1) {
                    [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                    return;
                }
            }
            [self.goodsArr addObject:dic];
            
        } else {
            //判断相同时，先删掉，再添加到数组中
            for (NSMutableDictionary *dict in self.goodsArr) {
                SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                if (modell.product_id == model.product_id) {
                    //  double product_num = product_num;
                    // product_num += 1;
                    [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                    // 这里判断是否允许0库存销售
                    if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                        if (model.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                            [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                            return;
                        }
                    }
                    [self.goodsArr removeObject:dict];
                    break;
                }
                
            }
            // 这里判断是否允许0库存销售
            if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                if (model.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                    [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                    return;
                }
            }
            //为0时，不添加
            // if (model.product_num != 0) {
            [self.goodsArr addObject:dic];
            
        }

        [self optimizeSettlement];
        
        if (kArrayIsEmpty(self.goodsArr)) {
            // 改名称
            [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
        }else{
            // 改名称
            [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
        }
        
        [self.twoTableView reloadData];

    };
    

}

#pragma mark - 多规格商品的代理回调
- (void)selectMoreModelClick:(NSMutableArray *)selectModelArray
{
    [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
    for (SVduoguigeModel *model in selectModelArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        //头像
        if (![SVTool isBlankString:model.sv_p_images2]) {
            [dic setObject:model.sv_p_images2 forKey:@"sv_p_images"];
        }
        [dic setObject:model.sv_pricing_method forKey:@"sv_pricing_method"];
        //套餐类型
        [dic setObject:model.sv_product_type forKey:@"sv_product_type"];
        //商品名
        [dic setObject:model.sv_p_name forKey:@"sv_p_name"];
        //单价
        [dic setObject:model.sv_p_unitprice forKey:@"sv_p_unitprice"];
        [dic setObject:model.sv_p_unitprice forKey:@"product_unitprice"];
        //会员售价
        [dic setObject:model.sv_p_memberprice forKey:@"sv_p_memberprice"];
        //库存
        [dic setObject:model.sv_p_storage forKey:@"sv_p_storage"];
        //单位
        if (!kStringIsEmpty(model.sv_p_unit)) {
            [dic setObject:model.sv_p_unit forKey:@"sv_p_unit"];
        }
        
        //商品ID
        [dic setObject:model.product_id forKey:@"product_id"];
        // 商品款号
        [dic setObject:model.sv_p_barcode forKey:@"sv_p_barcode"];
        //记录点击后的件数
        [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"product_num"];
        
        // 规格
        [dic setObject:model.sv_p_specs forKey:@"sv_p_specs"];
        // 是否是多规格
        [dic setObject:@(model.sv_is_newspec) forKey:@"sv_is_newspec"];
        // 会员ID
        if (![SVTool isBlankString:self.member_id]) {
            [dic setObject:self.member_id forKey:@"member_id"];
        }
        // 会员折
        if (![SVTool isBlankString:self.discount]) {
            [dic setObject:self.discount forKey:@"discount"];
        }
        
        // 大分类ID
        [dic setObject:model.productcategory_id forKey:@"productcategory_id"];
        // 小分类ID
        [dic setObject:model.productsubcategory_id forKey:@"productsubcategory_id"];
        
        // 进货价
        [dic setObject:model.sv_purchaseprice forKey:@"sv_purchaseprice"];
        
        // 最低折
        [dic setObject:model.sv_p_mindiscount forKey:@"sv_p_mindiscount"];
         // 最低价
        [dic setObject:model.sv_p_minunitprice forKey:@"sv_p_minunitprice"];
        
        if (kStringIsEmpty(model.sv_p_memberprice1)) {
             [dic setObject:@"0" forKey:@"sv_p_memberprice1"];
        }else{
            [dic setObject:model.sv_p_memberprice1 forKey:@"sv_p_memberprice1"];
        }
        if (kStringIsEmpty(model.sv_p_memberprice2)) {
                  [dic setObject:@"0" forKey:@"sv_p_memberprice2"];
             }else{
                 [dic setObject:model.sv_p_memberprice2 forKey:@"sv_p_memberprice2"];
             }
        if (kStringIsEmpty(model.sv_p_memberprice3)) {
                  [dic setObject:@"0" forKey:@"sv_p_memberprice3"];
             }else{
                 [dic setObject:model.sv_p_memberprice3 forKey:@"sv_p_memberprice3"];
             }
        if (kStringIsEmpty(model.sv_p_memberprice4)) {
                  [dic setObject:@"0" forKey:@"sv_p_memberprice4"];
             }else{
                 [dic setObject:model.sv_p_memberprice4 forKey:@"sv_p_memberprice4"];
             }
        if (kStringIsEmpty(model.sv_p_memberprice5)) {
                  [dic setObject:@"0" forKey:@"sv_p_memberprice5"];
             }else{
                 [dic setObject:model.sv_p_memberprice5 forKey:@"sv_p_memberprice5"];
             }
        
        NSLog(@"model.product_num9999 = %ld",model.product_num);
        
        if (self.goodsArr.count == 0) {
            //第一个选中时添加
           // if (model.product_num != 0) {
                [self.goodsArr addObject:dic];
           // }
            
        } else {
            NSInteger totleNum = 0.0;
            for (NSDictionary *dict in self.goodsArr) {
                SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                NSLog(@"modell.product_num = %f",modell.product_num);
                if (modell.product_id == model.product_id) {
                    //  model.product_num += modell.product_num;
                    totleNum = modell.product_num + model.product_num;
                    NSLog(@"model.product_num8888 = %ld",model.product_num);
                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)totleNum] forKey:@"product_num"];
                    [self.goodsArr removeObject:dict];
                    break;
                }
            }
            
                [self.goodsArr addObject:dic];
        }
        NSLog(@"self.goodsArr = %@",self.goodsArr);
        
        [self optimizeSettlement];
    }
    

}


/**
 二级分类请求 / tabelView点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先判断点击的是不是大分类
    if (tableView == self.oneTableView) {
        
        self.sao = YES;
        
        self.tableviewIndex = indexPath.row;
        //取出对应二级分类的id
        NSString *productcategory_id = [self.bigIDArr objectAtIndex:indexPath.row];
        self.productcategory_id = productcategory_id;
        //根据id去请求二级分类的内容
        NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
        if (ary_1.count != 0) {
            //当ary_1数组大于等于20个时，重新设置一下状态
            if (ary_1.count >= 20) {
                if (self.twoTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.twoTableView.mj_footer.state = MJRefreshStateIdle;
                }
            }
            [self loadDataWithID:self.productcategory_id];
            [self.twoTableView reloadData];
            self.img.hidden = YES;
            self.noWares.hidden = YES;
            self.addButton.hidden = YES;
            return;
        }
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
       [self loadDataWithID:self.productcategory_id];
//        [self getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@"" isn:@"" read_morespec:@"true"];
        [self getDataPageIndex:1 pageSize:20 category:self.productcategory_id producttype_id:@"-1" name:@"" isn:@"" read_morespec:@"true"];
       // self.productcategory_id
    }else{
      
        NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        SVSelectGoodsViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        SVSelectedGoodsModel *model = [ary_1 objectAtIndex:indexPath.row];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //头像
        if (![SVTool isBlankString:model.sv_p_images]) {
            [dic setObject:model.sv_p_images forKey:@"sv_p_images"];
        }
        
        [dic setObject:model.sv_pricing_method forKey:@"sv_pricing_method"];
        //套餐类型
        [dic setObject:model.sv_product_type forKey:@"sv_product_type"];
        
        //商品名
        [dic setObject:model.sv_p_name forKey:@"sv_p_name"];
        
        // 最低折
        [dic setObject:model.sv_p_mindiscount forKey:@"sv_p_mindiscount"];
         // 最低价
        [dic setObject:model.sv_p_minunitprice forKey:@"sv_p_minunitprice"];
        //单价
        double grade = 0.0;
        if (!kStringIsEmpty(self.grade)) {
            if ([self.grade isEqualToString:@"1"]) {
                grade=[model.sv_p_memberprice1 doubleValue];
            }else if ([self.grade isEqualToString:@"2"]){
                grade=[model.sv_p_memberprice2 doubleValue];
            }else if ([self.grade isEqualToString:@"3"]){
                grade=[model.sv_p_memberprice3 doubleValue];
            }else if ([self.grade isEqualToString:@"4"]){
                grade=[model.sv_p_memberprice4 doubleValue];
            }else {
                grade=[model.sv_p_memberprice5 doubleValue];
            }
        }
//        if (grade > 0) {
//             [dic setObject:[NSNumber numberWithDouble:grade] forKey:@"sv_p_unitprice"];
//
//             [dic setObject:[NSNumber numberWithDouble:grade]forKey:@"product_unitprice"];
//        }else{
            [dic setObject:model.sv_p_unitprice forKey:@"sv_p_unitprice"];
                   
            [dic setObject:model.sv_p_unitprice forKey:@"product_unitprice"];
      //  }
       
        //会员售价
        [dic setObject:model.sv_p_memberprice forKey:@"sv_p_memberprice"];
        //库存
        [dic setObject:model.sv_p_storage forKey:@"sv_p_storage"];
        //单位
        if (!kStringIsEmpty(model.sv_p_unit)) {
            [dic setObject:model.sv_p_unit forKey:@"sv_p_unit"];
        }
        
        //商品ID
        [dic setObject:model.product_id forKey:@"product_id"];
        // 商品款号
        [dic setObject:model.sv_p_barcode forKey:@"sv_p_barcode"];
        
        if (kStringIsEmpty(model.sv_p_memberprice1)) {
            [dic setObject:@"0" forKey:@"sv_p_memberprice1"];
        }else{
            [dic setObject:model.sv_p_memberprice1 forKey:@"sv_p_memberprice1"];
        }
        
        if (kStringIsEmpty(model.sv_p_memberprice2)) {
                   [dic setObject:@"0" forKey:@"sv_p_memberprice2"];
               }else{
                  [dic setObject:model.sv_p_memberprice2 forKey:@"sv_p_memberprice2"];
               }
        
        if (kStringIsEmpty(model.sv_p_memberprice3)) {
                   [dic setObject:@"0" forKey:@"sv_p_memberprice3"];
               }else{
                   [dic setObject:model.sv_p_memberprice3 forKey:@"sv_p_memberprice3"];
               }
        
        if (kStringIsEmpty(model.sv_p_memberprice4)) {
                   [dic setObject:@"0" forKey:@"sv_p_memberprice4"];
               }else{
                   [dic setObject:model.sv_p_memberprice4 forKey:@"sv_p_memberprice4"];
               }
        
        if (kStringIsEmpty(model.sv_p_memberprice5)) {

                   [dic setObject:@"0" forKey:@"sv_p_memberprice5"];
               }else{
                   [dic setObject:model.sv_p_memberprice5 forKey:@"sv_p_memberprice5"];
               }
        
//        
//        [dic setObject:model.sv_p_memberprice3 forKey:@"sv_p_memberprice3"];
//        [dic setObject:model.sv_p_memberprice4 forKey:@"sv_p_memberprice4"];
//        [dic setObject:model.sv_p_memberprice5 forKey:@"sv_p_memberprice5"];

        // 是否是改价来的
        if (!kStringIsEmpty(model.isPriceChange)) {
            [dic setObject:model.isPriceChange forKey:@"isPriceChange"];
        }else{
            [dic setObject:@"0" forKey:@"isPriceChange"]; //证明不是改价来的
        }
        
        model.ImageHidden = @"1";
        [dic setObject:model.ImageHidden forKey:@"ImageHidden"];
        
        // 大分类ID
        [dic setObject:model.productcategory_id forKey:@"productcategory_id"];
        // 小分类ID
        [dic setObject:model.productsubcategory_id forKey:@"productsubcategory_id"];
        // 价格类型，0-不可以改价  1-可以改价
         [dic setObject:@"1" forKey:@"sv_unitprice_type"];

        if (model.sv_pricing_method.integerValue == 1){// 这是称重的
            ZYInputAlertView *alertView = [ZYInputAlertView alertView];
            alertView.confirmBgColor = navigationBackgroundColor;
            alertView.colorLabel.text = @"输入重量";
            alertView.placeholder = @"输入重量";
            alertView.inputTextView.keyboardType = UIKeyboardTypeDecimalPad;
            [alertView show];
            alertView.textfieldStrBlock = ^(NSString *str) {
                double product_num = str.doubleValue;
                
               // model.product_num += product_num;
                
                //记录点击后的件数
                [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                // 进货价
                [dic setObject:model.sv_purchaseprice forKey:@"sv_purchaseprice"];
                
                [dic setObject:model.sv_purchaseprice forKey:@"sv_purchaseprice"];
                NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable]; //
                
                if (self.goodsArr.count == 0) {
                    //第一个选中时添加
                    if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                        if (model.sv_p_storage.doubleValue < 1) {
                            [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                            return;
                        }
                    }
                    
                    [self.goodsArr addObject:dic];
                    
                             [SVUserManager loadUserInfo];
                                if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                                    [cell.addNumberBtn setTitle:[NSString stringWithFormat:@"%.2f",product_num] forState:UIControlStateNormal];
                                    cell.reduceButton.hidden = NO;
                                    cell.addNumberBtn.hidden = NO;
                                  //  cell.icon_addImage.hidden = YES;
                                }else{
                                    cell.countText.text = [NSString stringWithFormat:@"%.2f",product_num];

                                    cell.reduceButton.hidden = NO;
                                  //  cell.addNumberBtn.hidden = YES;
                    //                cell.addNumberBtn.hidden = YES;
                    //                cell.countText.hidden = NO;
                                  //  self.rightDistance.constant = 0;
                                }
                   
                    
                } else {
                    //判断相同时，先删掉，再添加到数组中
                    for (NSMutableDictionary *dict in self.goodsArr) {
                        SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                        if (modell.product_id == model.product_id) {
                            double product_num = [dict[@"product_num"] doubleValue];
                            product_num = str.doubleValue;
                            [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                            // 这里判断是否允许0库存销售
                            if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                                if (model.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                                   [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                
                                    return;
                                }
                            }
                            [self.goodsArr removeObject:dict];
                            break;
                        }
                        
                    }
                    // 这里判断是否允许0库存销售
                    if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                        if (model.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                            [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                            return;
                        }
                    }
                    
                    
                    [SVUserManager loadUserInfo];
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                       [cell.addNumberBtn setTitle:[NSString stringWithFormat:@"%.2f",product_num] forState:UIControlStateNormal];
                        cell.reduceButton.hidden = NO;
                        cell.addNumberBtn.hidden = NO;

                    }else{
//                        cell.countText.text = [NSString stringWithFormat:@"%.2f",product_num];
//                        cell.icon_addImage.hidden = YES;
//                        cell.reduceButton.hidden = NO;
//                        cell.addNumberBtn.hidden = NO;
                        cell.countText.text = dic[@"product_num"];

                        cell.reduceButton.hidden = NO;
                    }
//                    cell.countText.text = dic[@"product_num"];
//                    cell.icon_addImage.hidden = YES;
//                    cell.reduceButton.hidden = NO;
                    [self.goodsArr addObject:dic];
                    
                }
                // 优化代码的部分
                [self optimizeSettlement];
                
                if (kArrayIsEmpty(self.goodsArr)) {
                    // 改名称
                    [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
                }else{
                    // 改名称
                    [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
                }
                
                //  动效block
                //   cell.shopCartBlock = ^(UIImageView *imageView){
                CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
                rect.origin.y = rect.origin.y - [tableView contentOffset].y;
                SVSelectGoodsViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//               UIImageView *imageV = [[UIImageView alloc] init];
//                imageV.image = [UIImage imageNamed:@"icon_insert"];
                UIImageView *imageView = cell.icon_addImage;
                CGRect headRect = imageView.frame;
                headRect.origin.y = rect.origin.y+headRect.origin.y;
                
                __weak typeof(self) weakSelf = self;
                [self startAnimationWithRect:headRect ImageView:imageView completion:^(BOOL compleBool) {
                    if (compleBool == YES) {
                        //抖动的动效
                        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                        shakeAnimation.duration = 0.1f;
                        shakeAnimation.fromValue = [NSNumber numberWithDouble:-5];
                        shakeAnimation.toValue = [NSNumber numberWithDouble:5];
                        shakeAnimation.autoreverses = YES;
                        
                        [weakSelf.waresFooterButton.sumCountlbl.layer addAnimation:shakeAnimation forKey:nil];
                        [weakSelf.waresFooterButton.icon.layer addAnimation:shakeAnimation forKey:nil];
                        
                    }
                }];

            };
          
        }else{
            if (model.sv_is_newspec == 0) {// 不是多规格的产品
          
                 [dic setObject:@"1.00" forKey:@"product_num"];
                // 进货价
                [dic setObject:model.sv_purchaseprice forKey:@"sv_purchaseprice"];
                NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable]; // 0是不可以，1是可以
                       
                       NSLog(@"ZeroInventorySales_sv_detail_is_enable = %@",ZeroInventorySales_sv_detail_is_enable);
                
               
                if (self.goodsArr.count == 0) {
                    //第一个选中时添加
                    // 这里判断是否允许0库存销售
                    if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                        if (model.sv_p_storage.doubleValue < 1) {
                            [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                            return;
                        }
                    }

                    
                    [self.goodsArr addObject:dic];
                    
                    [SVUserManager loadUserInfo];
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
                     
                      //  cell.addNumberBtn.titleLabel.text = @"1.00";
                         [cell.addNumberBtn setTitle:@"1.00" forState:UIControlStateNormal];
                        cell.reduceButton.hidden = NO;
                        cell.addNumberBtn.hidden = NO;
                      //  cell.icon_addImage.hidden = YES;
                    }else{
                      cell.countText.text = @"1.00";


                        cell.reduceButton.hidden = NO;
                        //                cell.addNumberBtn.hidden = YES;
                        //                cell.countText.hidden = NO;
                        //  self.rightDistance.constant = 0
                    }

                } else {
                    //判断相同时，先删掉，再添加到数组中
                    for (NSMutableDictionary *dict in self.goodsArr) {
                        SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                        if (modell.product_id == model.product_id) {
                            double product_num = [dict[@"product_num"] doubleValue];
                            product_num += 1;
                            [dic setObject:[NSString stringWithFormat:@"%.2f",product_num] forKey:@"product_num"];
                            // 这里判断是否允许0库存销售
                            if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                                if (model.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                                    [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                    return;
                                }
                            }
                            [self.goodsArr removeObject:dict];
                            break;
                        }
                        
                    }
                    // 这里判断是否允许0库存销售
                    if ([ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                        if (model.sv_p_storage.doubleValue < [dic[@"product_num"]doubleValue]) {
                            [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                            return;
                        }
                    }
               
                    //为0时，不添加
                    // if (model.product_num != 0) {
                    [self.goodsArr addObject:dic];
 
                    [SVUserManager loadUserInfo];
                    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cachae_name_supermarket"]) {
           
                      [cell.addNumberBtn setTitle:dic[@"product_num"] forState:UIControlStateNormal];
                        cell.reduceButton.hidden = NO;
                        cell.addNumberBtn.hidden = NO;
                    }else{
                        cell.countText.text = dic[@"product_num"];
                        cell.reduceButton.hidden = NO;
                    }
                  
                }
                // 优化结算代码
                [self optimizeSettlement];
             
                
                if (kArrayIsEmpty(self.goodsArr)) {
                    // 改名称
                    [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
                }else{
                    // 改名称
                    [self.waresFooterButton.orderButton setTitle:@"挂单" forState:UIControlStateNormal];
                }
                
                //  动效block
                //   cell.shopCartBlock = ^(UIImageView *imageView){
                CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
                rect.origin.y = rect.origin.y - [tableView contentOffset].y;
               // SVSelectGoodsViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIImageView *imageView = cell.icon_addImage;
                CGRect headRect = imageView.frame;
                headRect.origin.y = rect.origin.y+headRect.origin.y;
                
                __weak typeof(self) weakSelf = self;
                [self startAnimationWithRect:headRect ImageView:imageView completion:^(BOOL compleBool) {
                    if (compleBool == YES) {
                        //抖动的动效
                        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                        shakeAnimation.duration = 0.1f;
                        shakeAnimation.fromValue = [NSNumber numberWithDouble:-5];
                        shakeAnimation.toValue = [NSNumber numberWithDouble:5];
                        shakeAnimation.autoreverses = YES;
                        
                        [weakSelf.waresFooterButton.sumCountlbl.layer addAnimation:shakeAnimation forKey:nil];
                        [weakSelf.waresFooterButton.icon.layer addAnimation:shakeAnimation forKey:nil];
                        
                    }
                }];
                
            }else{
                
                SVShopSingleTemplateVC *shopSingleTemplateVC = [[SVShopSingleTemplateVC alloc] init];
                self.indexPath = indexPath;
                // shopSingleTemplateVC.delegate = self.stockCheckVC;
                shopSingleTemplateVC.selectNumber = 1;
                shopSingleTemplateVC.productID = model.product_id;
                shopSingleTemplateVC.sv_p_name = model.sv_p_name;
                shopSingleTemplateVC.sv_p_images2 = model.sv_p_images2;
                shopSingleTemplateVC.sv_p_images = model.sv_p_images;
                shopSingleTemplateVC.sv_p_unitprice = model.sv_p_unitprice;
                shopSingleTemplateVC.sv_p_barcode = model.sv_p_barcode;
                shopSingleTemplateVC.delegate = self;
                
                [self.navigationController pushViewController:shopSingleTemplateVC animated:YES];
                
            }
        }
        
       
        
       
    }
    
}


#pragma mark - 优化结算代码的地方
- (void)optimizeSettlement{
    double sumCount = 0;
    double sumMoney = 0.00;
    double sumCount2 = 0.00;

    for (NSDictionary *dict in self.goodsArr) {
        NSLog(@"self.sv_discount_configArray = %@",self.sv_discount_configArray);
        // 设置分类折
        double Discountedvalue = 0.0;
        BOOL isCategoryDisCount = false;
        
        if(!kArrayIsEmpty(self.sv_discount_configArray)) {
            for (NSDictionary *dictClassifiedBook in self.sv_discount_configArray) {
                // 判断是否跳出循环的条件
                if (isCategoryDisCount == false) {
                    double typeflag = [dictClassifiedBook[@"typeflag"] doubleValue];
                    NSString *Discountedpar = [NSString stringWithFormat:@"%@",dictClassifiedBook[@"Discountedpar"]];// 分类ID
                    if (typeflag == 1) { // 是1的话就说明是一级分类
                        if ([dict[@"productcategory_id"] isEqualToString:Discountedpar]) {
                            isCategoryDisCount = true;//有分类折跳出循环
                            Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                            break;
                        }
                    }

                    if (typeflag == 2) { // 是2的话就说明是二级分类
                        NSArray *comdiscounted = dictClassifiedBook[@"comdiscounted"];
                        if(!kArrayIsEmpty(comdiscounted)) {
                            for (NSDictionary * dictComdiscounted in comdiscounted) {
                                NSString *comdiscounted2 = [NSString stringWithFormat:@"%@",dictComdiscounted[@"comdiscounted"]];
                                if ([dict[@"productsubcategory_id"] isEqualToString:comdiscounted2]) {
                                    isCategoryDisCount = true;//有分类折跳出循环
                                    Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                                 break;
                             }
                        }
   }
                    }
                }
            }
        }
        

        NSLog(@"Discountedvalue44448888 = %f",Discountedvalue);
        
        double money = 0.0;
        double grade = 0.0;
        double sv_p_minunitprice = 0.0;// 最低售价
        double sv_p_mindiscount = 0.0; // 最低折
        if (!kStringIsEmpty(self.grade)) { // 多会员价1-5
            if ([self.grade isEqualToString:@"1"]) {
                grade=[dict[@"sv_p_memberprice1"] doubleValue];
            }else if ([self.grade isEqualToString:@"2"]){
                grade=[dict[@"sv_p_memberprice2"] doubleValue];
            }else if ([self.grade isEqualToString:@"3"]){
                grade=[dict[@"sv_p_memberprice3"] doubleValue];
            }else if ([self.grade isEqualToString:@"4"]){
                grade=[dict[@"sv_p_memberprice4"] doubleValue];
            }else {
                grade=[dict[@"sv_p_memberprice5"] doubleValue];
            }
        }
        // 最低价
        sv_p_minunitprice = [dict[@"sv_p_minunitprice"] doubleValue];
        // 最低折
        sv_p_mindiscount = [dict[@"sv_p_mindiscount"] doubleValue];
        
        NSString *priceChangeNum = [NSString stringWithFormat:@"%@",dict[@"isPriceChange"]];
        if ([priceChangeNum isEqualToString:@"1"]) { // 是改价
            money = [dict[@"priceChange"] doubleValue];
            
            NSLog(@"money = %.f",money);
            /**
             计件是0,计重是1。
             */
        }else if (grade > 0){
            sumCount += [dict[@"product_num"] doubleValue];
            money = grade;
        }else if (sv_p_minunitprice > 0 || sv_p_mindiscount > 0 || [dict[@"sv_p_memberprice"] doubleValue] > 0){
            NSLog(@"sv_p_minunitprice = %f",sv_p_minunitprice);
            NSLog(@"sv_p_mindiscount = %f",sv_p_mindiscount);
            NSLog(@"sv_p_memberprice = %f",[dict[@"sv_p_memberprice"] doubleValue]);
            /**
             场景一：会员价配置【会员价1-5】 ＞ 会员价/最低折/最低价【三选一】＞ 分类折
             注：有以上这三种情况下，就没有会员折一说，会员折无效
             */
            if ([SVTool isBlankString:self.discount]) {
                money = [dict[@"sv_p_unitprice"] doubleValue];
            }else{
                if ([dict[@"sv_p_memberprice"] doubleValue] > 0) {
                    money = [dict[@"sv_p_memberprice"] doubleValue];
                }else if (sv_p_mindiscount > 0 && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                     //场景二：最低折【8折】、会员折【9折】同时存在，按折比，取数字大的算【按9折算】
                    if (self.discount.doubleValue >= 10 || self.discount.doubleValue <= 0) {
                        money = [dict[@"sv_p_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                    }else{
                        if (sv_p_mindiscount > self.discount.doubleValue && self.discount.doubleValue > 0 && self.discount.doubleValue < 10) {
                            money = [dict[@"sv_p_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                        }else if (self.discount.doubleValue > sv_p_mindiscount && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                            money = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
                        }else{
                            money = [dict[@"sv_p_unitprice"] doubleValue];
                        }
                    }
                       
                }else if (sv_p_minunitprice > 0 && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){// 场景三：最低价、会员折同时存在，要拿单价来对比， 哪个大取哪个，不能低于最低价  会员折单价=会员折×单品合计金额
                    if (self.discount.doubleValue >= 10 || self.discount.doubleValue <= 0) {
                        money = sv_p_minunitprice;
                    }else{
                        double memberPrice = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
                        if (memberPrice > sv_p_minunitprice  && self.discount.doubleValue > 0 && self.discount.doubleValue < 10) {
                            money = memberPrice;
                        }else if (sv_p_minunitprice > memberPrice && self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
                            money = sv_p_minunitprice;
                        }else{
                            money = [dict[@"sv_p_unitprice"] doubleValue];
                        }
                    }

                    }else{
                           money = [dict[@"sv_p_unitprice"] doubleValue];
                    }
                }

        }else if (Discountedvalue > 0){
            money = [dict[@"sv_p_unitprice"] doubleValue]*Discountedvalue*0.1;
            
        }else if (self.discount.doubleValue > 0 && self.discount.doubleValue < 10){
            money = [dict[@"sv_p_unitprice"] doubleValue]*[self.discount doubleValue]*0.1;
        }
        
        else{
            money = [dict[@"sv_p_unitprice"] doubleValue];
        }
            
            sumCount += [dict[@"product_num"] doubleValue];
        /**
         计件是0,计重是1。
         */
            if ([dict[@"sv_pricing_method"] integerValue] == 1) {
                sumCount2 += 1;
            }else{
                sumCount2 += [dict[@"product_num"] doubleValue];
            }
            sumMoney += [dict[@"product_num"] doubleValue] * money;
        NSLog(@"product_num = %.f",[dict[@"product_num"] doubleValue]);
        NSLog(@"money2222 = %.f",money);
        NSLog(@"sumMoney = %.f",sumMoney);
        }
    
    self.waresFooterButton.sumCount = sumCount2;
    self.waresFooterButton.money = sumMoney;
}

#pragma mark - 动效方法
//方案一
-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView completion:(void (^)(BOOL))completion {
    //控制点击次数
    //_twoTableView.userInteractionEnabled = NO;
    //创建
    CALayer *layer = [CALayer layer];
    layer.contents = (id)imageView.layer.contents;
    
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.bounds = rect;
    //[layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];//切圆的
    //layer.masksToBounds = YES;
    // 原View中心点
    //layer.position = CGPointMake(imageView.center.x + ScreenW/6*2, CGRectGetMidY(rect) + 40);
    layer.position = CGPointMake(ScreenW - 27, CGRectGetMidY(rect) + 90);
    [self.view.layer addSublayer:layer];
    //------- 创建移动轨迹 -------//
    self.path = [UIBezierPath bezierPath];
    // 起点
    [_path moveToPoint:layer.position];
    // 终点
    //[_path addLineToPoint:CGPointMake( 37, ScreenH - 27 - 64)];//直线
    [_path addQuadCurveToPoint:CGPointMake( 35, ScreenH - 25 - TopHeight-BottomHeight) controlPoint:CGPointMake(SCREEN_WIDTH/4,rect.origin.y-80)];//抛物线
    
    
    //------- 创建移动轨迹 -------//
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    
    //------- 旋转动画 -------//
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //这个是可以调图片旋转速度
    rotationAnimation.duration= 0.4f;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.toValue = [NSNumber numberWithDouble:M_PI * 2.0];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //------- 创建缩小动画 -------//
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.fromValue = [NSNumber numberWithDouble:1.0];
    narrowAnimation.toValue = [NSNumber numberWithDouble:0.5];
    narrowAnimation.duration = 0.8;
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    narrowAnimation.removedOnCompletion = NO;
    narrowAnimation.fillMode = kCAFillModeForwards;
    
    //动画组合
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,rotationAnimation,narrowAnimation];
    //动图时间,只有设置为0.1秒，才可以完全释放_layer
    groups.duration = 0.8f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    
    [layer addAnimation:groups forKey:@"group"];
    
    
    //------- 动画结束后执行 -------//
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
        completion(YES);
    });
    
    
}

#pragma mark - 懒加载
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

//商品的底部按钮
-(SVwaresFooterButton *)waresFooterButton{
    if (!_waresFooterButton) {
        _waresFooterButton = [[NSBundle mainBundle] loadNibNamed:@"SVwaresFooterButton" owner:nil options:nil].lastObject;
        //_waresFooterButton.frame = CGRectMake(0, ScreenH-50, ScreenW, 50);
        [self.view addSubview:_waresFooterButton];
        
        [_waresFooterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
            make.bottom.mas_equalTo(self.view).offset(-BottomHeight);
        }];
        
        //初始化一个手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(waresViewResponse)];
        //给ImageView添加手势
        [_waresFooterButton.waresView addGestureRecognizer:singleTap];
    }
    return _waresFooterButton;
}

- (NSMutableArray *)goodsModelArr {
    
    if (!_goodsModelArr) {
        
        _goodsModelArr = [NSMutableArray array];
        NSInteger ins = self.bigNameArr.count;
        //if (self.bigNameArr.count == 0) {
        //ins = 20;
        //ins = 200;
        //}
        for (NSInteger inx = 0; inx <ins; inx++) {
            [_goodsModelArr addObject:@[]];
        }
    }
    return _goodsModelArr;
}

- (NSMutableArray *)categoryIdArr {
    
    if (!_categoryIdArr) {
        
        _categoryIdArr = [NSMutableArray array];
        NSInteger ins = self.bigNameArr.count;
        //if (self.bigNameArr.count == 0) {
        //ins = 20;
        //ins = 200;
        //}
        for (NSInteger inx = 0; inx <ins; inx++) {
            [_categoryIdArr addObject:@[]];
        }
    }
    return _categoryIdArr;
}

-(NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

-(NSMutableArray *)priceChangeArray {
    if (!_priceChangeArray) {
        _priceChangeArray = [NSMutableArray array];
    }
    return _priceChangeArray;
}

- (NSMutableArray *)shopArray{
    if (!_shopArray) {
        _shopArray = [NSMutableArray array];
    }
    return _shopArray;
}

- (SVSeeWaresView *)seeWaresView {
    if (!_seeWaresView) {
        _seeWaresView = [[[NSBundle mainBundle]loadNibNamed:@"SVSeeWaresView" owner:nil options:nil] lastObject];
        _seeWaresView.frame = CGRectMake(0, ScreenH, ScreenW, num);
        _seeWaresView.backgroundColor = RGBA(239, 239, 239, 1);
        
        [_seeWaresView.cancelB addTarget:self action:@selector(handlePan) forControlEvents:UIControlEventTouchUpInside];
        [_seeWaresView.removeB addTarget:self action:@selector(removeResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeWaresView;
}

//清除数据
- (void)removeGoodsModelArr{
    
    //清空数据
    self.goodsArr = nil;
    [self.goodsModelArr removeAllObjects];
    // 改名称
    [self.waresFooterButton.orderButton setTitle:@"取单" forState:UIControlStateNormal];
    //重设数组
    NSInteger ins = self.bigNameArr.count;
    for (NSInteger inx = 0; inx <ins; inx++) {
        [_goodsModelArr addObject:@[]];
    }
    
    self.waresFooterButton.sumCountlbl.text = @"0";
    self.waresFooterButton.moneylbl.text = @"0";
    
    //调用数据
  //  [self getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@"" isn:@"" read_morespec:@"true"];
    [self getDataPageIndex:1 pageSize:20 category:self.productcategory_id producttype_id:@"-1" name:@"" isn:@"" read_morespec:@"true"];
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

- (void)removeResponseEvent {
    [self removeGoodsModelArr];
    [self handlePan];
}

//移除
- (void)handlePan{
    [self.maskTheView removeFromSuperview];
    [UIView animateWithDuration:.5 animations:^{
        self.seeWaresView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-num);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.seeWaresView removeFromSuperview];
        });
    }];
    
}

//#pragma mark - 导航栏
//- (SVSelectNavView *)selectNavView{
//    if (_selectNavView) {
//        _selectNavView = [[NSBundle mainBundle] loadNibNamed:@"SVSelectNavView" owner:nil options:nil].lastObject;
//        _selectNavView.frame = CGRectMake(0, 0, ScreenW, TopHeight);
//    }
//
//    return _selectNavView;
//}



@end
