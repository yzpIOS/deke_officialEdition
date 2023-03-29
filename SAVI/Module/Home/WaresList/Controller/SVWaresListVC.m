//
//  SVWaresListVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVWaresListVC.h"
//自定义cell
#import "SVWaresListVCell.h"
//商品详情
#import "SVWaresDetailsVC.h"
//#import "SVPurchaseManagementVC.h"
//筛选商品
//#import "SVWaresScreeningVC.h"
//分类管理
#import "SVWaresOneClassVC.h"
#import "SVAddMoreSpecificationsVC.h"
#import "SVExpandBtn.h"
#import "SVduoguigeModel.h"
#import "SVShopSingleTemplateVC.h"
#import "SVAddShopFlowLayout.h"
#import "SVDetaildraftFirmOfferCell.h"
//模型
#import "SVduoguigeModel.h"
#import "SVLabelPrintingCell.h"
#import "SVselectShopListVC.h"
#import "NSString+Extension.h"
#import "SVProductScreeningView.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#define num  (ScreenH / 2)
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]
//#import "SVMultiSpecificationVC.h"
// 定义唯一标识
static NSString *oneWaresListVCellID = @"oneWaresListVCell";
static NSString *const WaresListVCellID = @"WaresListVCell";
static NSString *const LabelPrintingCellID = @"SVLabelPrintingCell";
static NSString *const collectionViewCellID = @"SVDetaildraftFirmOfferCell";
@interface SVWaresListVC () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,selectMoreModelDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

//@property (nonatomic,strong) UITableView *tableView;
//
////搜索栏
//@property (strong, nonatomic) UISearchBar *searchBar;
//@property (strong, nonatomic) UIButton *qrcode;
//
///**
// 模型数组
// */
//@property (nonatomic,strong) NSMutableArray *modelArr;
//
//@property (nonatomic,assign)  NSInteger productsubcategory_id;
//
////记录刷新次数
//@property (nonatomic,assign) NSInteger page;
//
//@property (nonatomic,assign) BOOL sao;
//
//
//@property (nonatomic,strong) UIImageView *img;

//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SVExpandBtn *qrcode;

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
@property (nonatomic,strong) NSString *productcategory_id;
//标记 从属于第几个一级分类
@property (nonatomic, assign) NSInteger tableviewIndex;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *PrintingCollectionView;
@property (nonatomic,strong) UIButton *icon_button;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) SVduoguigeModel *model;
@property (nonatomic,assign) NSInteger selectCellIndex;

@property (nonatomic,assign) NSInteger addShopTotleNum;
@property (nonatomic,assign)  NSInteger aa;
@property (nonatomic,strong) UILabel *addShopLabel;
//@property (nonatomic,strong) NSMutableArray *purchaseArr;
@property (nonatomic,assign)  BOOL isClean;
@property (nonatomic,assign) BOOL isDetail;

@property (nonatomic,strong) NSString *keyStr;

@property (nonatomic,strong) UIView *categoryView;// 小分类的view
@property (nonatomic,strong) NSArray *categoryArray;// 选择商品会员价
@property (nonatomic,strong) NSMutableArray *categoryIdArr;
@property (nonatomic,strong) UIButton * tagBtn;
@property (nonatomic,strong) NSString *productsubcategory_id;// 小分类的ID
@property (nonatomic,strong) SVProductScreeningView * productScreeningView;
@property (nonatomic,assign) BOOL isScanButtonResponseEvent;
@end

@implementation SVWaresListVC
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyStr = @"";
    self.navigationItem.title = @"商品管理";
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVDetaildraftFirmOfferCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
    self.PrintingCollectionView.delegate = self;
    self.PrintingCollectionView.dataSource = self;
    
    
    self.productsubcategory_id = @"-1"; // 默认是-1全部
    //添加搜索栏
    [self addSearchBar];
    self.view.backgroundColor = [UIColor whiteColor];
    //从偏好设置里拿到大分类数组
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
    self.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
    
   
    //  [self setupBottomView];
    self.tableviewIndex = 0;
#pragma mark - 添加右侧按钮
    if (self.controllerNum == 1 || self.controllerNum == 2) {
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        // 添加一个view用来存放小分类
//        UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 1)];
        UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 1)];
        categoryView.backgroundColor = BackgroundColor;
        self.categoryView = categoryView;
        [self.view addSubview:categoryView];
#pragma mark - 添加tableView
        //tabeleView
        self.oneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW/8*2, ScreenH-50-BottomHeight-50-TopHeight)];
        self.twoTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenW/8*2, CGRectGetMaxY(categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-50-BottomHeight-categoryView.height)];
        
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
        [self.view addSubview:self.twoTableView];
        //注册cell
        [self.oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:oneWaresListVCellID];
        [self.twoTableView registerNib:[UINib nibWithNibName:@"SVWaresListVCell" bundle:nil] forCellReuseIdentifier:WaresListVCellID];
        
        [self.twoTableView registerNib:[UINib nibWithNibName:@"SVLabelPrintingCell" bundle:nil] forCellReuseIdentifier:LabelPrintingCellID];
        
        //调用刷新
        [self setupRefresh];
        
#pragma mark - 请求数据
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        //在没有点击的情况下，设置数组索引为0
        self.tableviewIndex = 0;
        //调用数据
       // [self getDataPageIndex:1 pageSize:20 category:0 name:@"" isn:@"" read_morespec:@"true"];
        [self getDataPageIndex:1 pageSize:20 category:0 producttype_id:self.productsubcategory_id name:@"" isn:@"" read_morespec:@"true"];
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
        // [self setupBottomView];
        
    } else {
        // 添加一个view用来存放小分类
        UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 1)];
        categoryView.backgroundColor = BackgroundColor;
        self.categoryView = categoryView;
        [self.view addSubview:categoryView];
        self.oneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenW/8*2, ScreenH-114)];
        self.twoTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenW/8*2, CGRectGetMaxY(categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-BottomHeight-categoryView.height)];
        
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
        [self.view addSubview:self.twoTableView];
        //注册cell
        [self.oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:oneWaresListVCellID];
        [self.twoTableView registerNib:[UINib nibWithNibName:@"SVWaresListVCell" bundle:nil] forCellReuseIdentifier:WaresListVCellID];
        
        [self.twoTableView registerNib:[UINib nibWithNibName:@"SVLabelPrintingCell" bundle:nil] forCellReuseIdentifier:LabelPrintingCellID];
        
        //调用刷新
        [self setupRefresh];
        
#pragma mark - 请求数据
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        //在没有点击的情况下，设置数组索引为0
        self.tableviewIndex = 0;
        //调用数据
      //  [self getDataPageIndex:1 pageSize:20 category:0 name:@"" isn:@"" read_morespec:@"true"];
        [self getDataPageIndex:1 pageSize:20 category:0 producttype_id:self.productsubcategory_id name:@"" isn:@"" read_morespec:@"true"];
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
        
        //正确创建方式，这样显示的图片就没有问题了
        UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"classManagement_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(buttonResponseEvent)];
        self.navigationItem.rightBarButtonItem = rightButon;
        
//        UIButton *informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [informationCardBtn addTarget:self action:@selector(buttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
//        
//        [informationCardBtn setImage:[UIImage imageNamed:@"classManagement_icon"] forState:UIControlStateNormal];
//        
//        [informationCardBtn sizeToFit];
//        UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:informationCardBtn];
//        
//        
//        UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        fixedSpaceBarButtonItem.width = 15;
//        
//        
//        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [settingBtn addTarget:self action:@selector(ProductScreeningClick) forControlEvents:UIControlEventTouchUpInside];
//        [settingBtn setImage:[UIImage imageNamed:@"sousuo_black"] forState:UIControlStateNormal];
//        [settingBtn sizeToFit];
//        UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
//
//        self.navigationItem.rightBarButtonItems  = @[settingBtnItem,fixedSpaceBarButtonItem,informationCardItem];
        
        
        
        
        [SVUserManager loadUserInfo];
        NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
        NSDictionary *CommodityManageDic = sv_versionpowersDict[@"CommodityManage"];
        if (kDictIsEmpty(CommodityManageDic)) {
            [self setUpBottomBtn];
            self.isClean = YES;// 可以删除
            self.isDetail = YES; // 可以看详情
        }else{
             NSString *AddCommodity = [NSString stringWithFormat:@"%@",CommodityManageDic[@"AddCommodity"]];
            if (kStringIsEmpty(AddCommodity)) {
                 [self setUpBottomBtn];
            }else{
                if ([AddCommodity isEqualToString:@"1"]) {
                [self setUpBottomBtn];
                           }else{
                               
                           }
            }
            
            // 这里判断是否可以看详情
             NSString *CommodityDetails = [NSString stringWithFormat:@"%@",CommodityManageDic[@"CommodityDetails"]];
            if (kStringIsEmpty(CommodityDetails)) {
                self.isDetail = YES; // 可以看详情
            }else{
                if ([CommodityDetails isEqualToString:@"1"]) {
               self.isDetail = YES; // 可以看详情
                           }else{
               self.isDetail = NO; // 不可以看详情
                           }
            }
            
            // 这里是判断商品是否可以删除
            NSString *DeleteCommodity = [NSString stringWithFormat:@"%@",CommodityManageDic[@"DeleteCommodity"]];
                      if (kStringIsEmpty(DeleteCommodity)) {
                         self.isClean = YES;// 可以删除
                      }else{
                          if ([DeleteCommodity isEqualToString:@"1"]) {
                         self.isClean = YES;// 可以删除
                                     }else{
                         self.isClean = NO;// 不可以删除
                                     }
                      }
           
        }

    }
    
    NSString *catetoryId =(NSString *)self.bigIDArr[0];
     [self loadDataWithID:catetoryId];

}

#pragma mark - 商品筛选
- (void)ProductScreeningClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.productScreeningView];
    
    //实现弹出方法
    [UIView animateWithDuration:.5 animations:^{
        self.productScreeningView.frame = CGRectMake(ScreenW /6 *1, 0, ScreenW /6 *5, ScreenH);
    }];
}

- (SVProductScreeningView *)productScreeningView{
    if (!_productScreeningView) {
        _productScreeningView = [[NSBundle mainBundle]loadNibNamed:@"SVProductScreeningView" owner:nil options:nil].lastObject;
        _productScreeningView.frame = CGRectMake(ScreenW, 0, ScreenW /6 *5, ScreenH);
        
    }
    return _productScreeningView;
}

#pragma mark - 请求小分类数据
- (void)loadDataWithID:(NSString *)catetoryId{

    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetCategoryById?key=%@&cid=%@",[SVUserManager shareInstance].access_token,catetoryId];

    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        NSArray *arr = dict[@"values"];
    
        self.categoryArray = arr;
        if (self.controllerNum == 1 || self.controllerNum == 2) { // 进货 退货
            [self setUpCategoryViewArr:arr bottomHeight:50];
        }else{
            [self setUpCategoryViewArr:arr bottomHeight:0];
        }
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)setUpCategoryViewArr:(NSArray *)arr bottomHeight:(CGFloat)bottomHeight{
    if (kArrayIsEmpty(arr)) {
        self.categoryView.frame = CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 0);
        self.twoTableView.frame = CGRectMake(ScreenW/8*2, CGRectGetMaxY(self.categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-BottomHeight-self.categoryView.height-bottomHeight);
    }else{
        [self.categoryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.categoryView.frame = CGRectMake(ScreenW/8*2, 50, ScreenW/8*6, 55);
        self.twoTableView.frame = CGRectMake(ScreenW/8*2, CGRectGetMaxY(self.categoryView.frame), ScreenW/8*6, ScreenH-TopHeight-50-BottomHeight-self.categoryView.height-bottomHeight);
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
                   
                   for (int i= 0; i<arr.count; i++) {
                       NSDictionary *dict = arr[i];
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
    NSLog(@"aar = %@",arr);
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
       // [self getDataPageIndex:1 pageSize:20 category:self.productcategory_id producttype_id:self.productsubcategory_id name:@"" isn:@"" read_morespec:@"true"];
        
   // [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
    
    [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] producttype_id:self.productsubcategory_id name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
}


- (void)setUpBottomBtn{
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 22.5;
    [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addWaresButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];

}

#pragma mark - 确定按钮的点击
- (void)selectArrBtnClick{
    if (kArrayIsEmpty(self.selectModelArray)) {
        [SVTool TextButtonActionWithSing:@"未选择"];
    }else{
        if (self.addWarehouseWares) {
            self.addWarehouseWares(self.selectModelArray);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - 左边view的手势触发
- (void)tapClick{
    SVselectShopListVC *vc = [[SVselectShopListVC alloc] init];
    vc.selectArray = self.selectModelArray;
    [self.navigationController pushViewController:vc animated:YES];
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
       // [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
        
        [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] producttype_id:self.productsubcategory_id name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
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
       // [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
        
        [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] producttype_id:self.productsubcategory_id name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
        
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
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    //指定代理
    self.searchBar.delegate = self;
    //为UISearchBar添加背景图片
    //searchbar.backgroundColor = [UIColor whiteColor];
    self.searchBar.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
    
    //一下代码为修改placeholder字体的颜色和大小
    // UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
 
   // UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
     
     UITextField * searchField;
       if (@available(iOS 13.0, *)) {
           searchField = _searchBar.searchTextField;
             // 输入文本颜色
               searchField.textColor = GlobalFontColor;
           //    searchField.font = [UIFont systemFontOfSize:15];
               
               // 默认文本大小
              // [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
           [SVUserManager loadUserInfo];
           if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入商品名称或款号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}];
           }else{
               searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入商品名称或条码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:GlobalFontColor}];
           }
               ///新的实现
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

#pragma mark - 输入完毕后，会调用这个方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //设置为NO则，当没有数据时，则提示没有找到此商品
    self.sao = NO;
    
    //设置为显示
    self.qrcode.hidden = NO;
    
    NSString *Str = searchBar.text;
    
    //解码方法，返回的是一致的字符串
    //    NSString *keyStr = [Str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *keyStr = [Str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    self.keyStr = keyStr;
    //提示查询
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在查询中…"];
    //设置数组索引为0
    self.tableviewIndex = 0;
    //默认选中第一行
    self.productcategory_id = 0;
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    //调用请求
    self.page = 1;
    //调用请求
   // [self getDataPageIndex:self.page pageSize:20 category:-1 name:Str isn:Str read_morespec:@"true"];
    
    [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] producttype_id:self.productsubcategory_id name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
    
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

#pragma mark - 完成选择按钮
- (void)selectbuttonResponseEvent {
    //当为空时，提示选择一下
    //    if ([SVTool isEmpty:self.purchaseArr]) {
    //        [SVTool TextButtonActionWithSing:@"请选择商品"];
    //        return;
    //    }
    //
    //    if (self.addWarehouseWares) {
    //        //        self.addWarehouseWares(model.sv_p_images2, model.sv_p_name, model.sv_p_unitprice, model.sv_p_storage, model.product_id,model.sv_pricing_method);
    //        self.addWarehouseWares(self.purchaseArr);
    //    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 跳转扫一扫响应方法
- (void)scanButtonResponseEvent{
    
    self.page = 1;
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
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
//        weakSelf.searchBar.text = name;
//        self.isScanButtonResponseEvent = YES;
//        //调用请求
//      //  [weakSelf getDataPageIndex:weakSelf.page pageSize:1 category:0 name:name isn:name read_morespec:@"false"];
//        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:[[NSString stringWithFormat:@"%@",weakSelf.productcategory_id] integerValue] producttype_id:weakSelf.productsubcategory_id name:weakSelf.searchBar.text isn:weakSelf.searchBar.text read_morespec:@"true"];
//    };
//
//    [self.navigationController pushViewController:VC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    self.hidesBottomBarWhenPushed = YES;
    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        
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
        
        weakSelf.searchBar.text = resultStr;
        self.isScanButtonResponseEvent = YES;
        //调用请求
      //  [weakSelf getDataPageIndex:weakSelf.page pageSize:1 category:0 name:name isn:name read_morespec:@"false"];
        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:[[NSString stringWithFormat:@"%@",weakSelf.productcategory_id] integerValue] producttype_id:weakSelf.productsubcategory_id name:weakSelf.searchBar.text isn:weakSelf.searchBar.text read_morespec:@"true"];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 新增商品跳转响应方法
-(void)addWaresButton{
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]) {
        // 给100，如果长度不够时，也可以点击
        SVAddMoreSpecificationsVC *addMoreSpecificationsVC = [[SVAddMoreSpecificationsVC alloc] init];
        [self.navigationController pushViewController:addMoreSpecificationsVC animated:YES];
    }else{
        //设置按钮点击时的背影色
        SVNewWaresVC *VC = [[SVNewWaresVC alloc]init];
        __weak typeof(self) weakSelf = self;
        VC.addWaresBlock = ^{
            //提示加载中
            [SVTool IndeterminateButtonAction:weakSelf.view withSing:@"加载中…"];
            //调用请求方法
           // [weakSelf getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",weakSelf.productcategory_id] integerValue] name:@"" isn:@"" read_morespec:@"true"];
            [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:[[NSString stringWithFormat:@"%@",weakSelf.productcategory_id] integerValue] producttype_id:weakSelf.productsubcategory_id name:weakSelf.searchBar.text isn:weakSelf.searchBar.text read_morespec:@"true"];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}

#pragma mark - 分类管理
-(void)buttonResponseEvent{
    //跳转会员详情界面
    //self.hidesBottomBarWhenPushed = YES;
    SVWaresOneClassVC *VC = [[SVWaresOneClassVC alloc]init];
    
    //对象有一个Block属性，然而这个Block属性中又引用了对象的其他成员变量，那么就会对这个变量本身产生强引用，那么变量本身和他自己的Block属性就形成了循环引用。因此我们需要对其进行处理进行弱引用。
    __weak typeof(self) weakSelf = self;
    
    VC.waresOneClassBlock = ^{
        
        //从偏好设置里拿到大分类数组
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        weakSelf.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
        weakSelf.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
        [weakSelf.oneTableView reloadData];
        
        [weakSelf.goodsModelArr removeAllObjects];
        for (NSInteger inx = 0; inx < weakSelf.bigNameArr.count; inx++) {
            [weakSelf.goodsModelArr addObject:@[]];
        }
        
        //设置数组索引为0
        weakSelf.tableviewIndex = 0;
        //默认选中第一行
        weakSelf.productcategory_id = 0;
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        //调用请求数据接口
        weakSelf.page = 1;
        weakSelf.sao = NO;
        weakSelf.searchBar.text = nil;
       // [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:0 name:@"" isn:@"" read_morespec:@"true"];
        [weakSelf getDataPageIndex:weakSelf.page pageSize:20 category:[[NSString stringWithFormat:@"%@",weakSelf.productcategory_id] integerValue] producttype_id:weakSelf.productsubcategory_id name:weakSelf.searchBar.text isn:weakSelf.searchBar.text read_morespec:@"true"];
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    //self.hidesBottomBarWhenPushed = YES;
}


#pragma mark - 数据请求
/**
 获取产品列表
 
 @param pageIndex 第几页
 @param pageSize 每页有几个
 @param category 只限大分类
 @param name 搜索关键字
 */
- (void)getDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize category:(NSInteger)category producttype_id:(NSString *)producttype_id name:(NSString *)name isn:(NSString *)isn read_morespec:(NSString *)read_morespec{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetProductPcCashierList?key=%@&pageIndex=%li&pageSize=%li&category=%li&producttype_id=%@&name=%@&isn=%@&read_morespec=%@",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,(long)category,producttype_id,name,isn,read_morespec];
    NSLog(@"fff---%@",urlStr);
    NSString *strURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic---%@",dic);
        
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
            //NSMutableArray *ary_1 = [[NSMutableArray alloc]initWithArray:[self.goodsModelArr objectAtIndex:self.tableviewIndex]];
            for (NSMutableDictionary *goodsDic in listArr) {
                
                NSString *sv_p_images = goodsDic[@"sv_p_images"];
//                if ([sv_p_images containsString:@"UploadImg"]) {
//                    
//                    NSData *data = [sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
//                    NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
//                    NSDictionary *dic = arr[0];
//                    NSString *sv_p_images_two = dic[@"code"];
//                    sv_p_images = sv_p_images_two;
//                }
                [goodsDic setValue:sv_p_images forKey:@"sv_p_images"];
                if (self.controllerNum == 1) {
                    [goodsDic setValue:@"1" forKey:@"isStockPurchase"];
                }else if (self.controllerNum == 2){
                    [goodsDic setValue:@"2" forKey:@"isStockPurchase"];
                }
                
                //赋值给模型
                SVduoguigeModel *goodsModel = [SVduoguigeModel mj_objectWithKeyValues:goodsDic];
                
                if (goodsModel.sv_is_newspec == 1 && self.isScanButtonResponseEvent == YES &&listArr.count > 1) {
                    self.isScanButtonResponseEvent = NO;
                  //  push出控制器选择多规格商品
                    SVShopSingleTemplateVC *shopSingleTemplateVC = [[SVShopSingleTemplateVC alloc] init];
                    shopSingleTemplateVC.delegate = self.purchaseManagementVC;
                    shopSingleTemplateVC.productID = goodsModel.product_id;
                    shopSingleTemplateVC.sv_p_name = goodsModel.sv_p_name;
                    shopSingleTemplateVC.sv_p_images2 = goodsModel.sv_p_images2;
                    shopSingleTemplateVC.sv_p_images = goodsModel.sv_p_images;
                    shopSingleTemplateVC.sv_p_unitprice = goodsModel.sv_p_unitprice;
                    shopSingleTemplateVC.sv_p_barcode = goodsModel.sv_p_barcode;
                    shopSingleTemplateVC.isStockPurchase = 1;
                    [self.navigationController pushViewController:shopSingleTemplateVC animated:YES];
                    // self.model = model;// 这里来
                   // self.selectCellIndex = indexPath.row;
                    NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
                    goodsModel.isSelect = @"1";
                  //  [ary_1 replaceObjectAtIndex:indexPath.row withObject:model];
                    //数组给模型数组
                    [self.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:ary_1];
                    [self.twoTableView reloadData];
                    self.isScanButtonResponseEvent = NO;
                }
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
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.isScanButtonResponseEvent = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        self.isScanButtonResponseEvent = NO;
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

#pragma mark - cell的展示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.oneTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneWaresListVCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneWaresListVCellID];
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
        
        if (self.controllerNum == 0) {// 商品列表
            SVWaresListVCell *cell = [tableView dequeueReusableCellWithIdentifier:WaresListVCellID forIndexPath:indexPath];
            //如果没有就重新建一个
            if (!cell) {
                
                cell = [[SVWaresListVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WaresListVCellID];
                
            }
            //取消高亮
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
            if (ary_1.count > indexPath.row) {
                SVduoguigeModel *model = [ary_1 objectAtIndex:indexPath.row];
                //            model.indexPath = indexPath;
                //            cell.model = model;
                //            cell.indexPatch = indexPath;
                
                if (self.purchaseArr.count == 0) {
                    model.indexPath = indexPath;
                    cell.model = model;
                } else {
                    
                    for (NSDictionary *dict in self.purchaseArr) {
                        SVduoguigeModel *equalModel = [SVduoguigeModel mj_objectWithKeyValues:dict];
                        
                        if ([equalModel.product_id isEqualToString:model.product_id]) {
                            model.indexPath = indexPath;
                            cell.model = equalModel;
                            return cell;
                        }
                        
                        model.indexPath = indexPath;
                        cell.model = model;
                        
                    }
                }
            }
            
            //
            if (self.controllerNum == 1) {
                cell.cellButton.hidden = NO;
            } else {
                cell.cellButton.hidden = YES;
            }
            
            __weak typeof(self) weakSelf = self;
            cell.waresListVCelllock = ^(SVduoguigeModel *model, NSIndexPath *index) {
                
                
                if (weakSelf.purchaseArr.count == 0) {
                    //第一个选中时添加
                    [weakSelf.purchaseArr addObject:model];
                } else {
                    //判断相同时，先删掉，再添加到数组中
                    for (NSDictionary *dict in weakSelf.purchaseArr) {
                        SVduoguigeModel *modell = [SVduoguigeModel mj_objectWithKeyValues:dict];
                        if (modell.product_id == model.product_id) {
                            [weakSelf.purchaseArr removeObject:dict];
                            break;
                        }
                    }
                    
                    //当为选中1状态时，添加
                    if ([model.isSelect isEqualToString:@"1"]) {
                        [weakSelf.purchaseArr addObject:model];
                    }
                    
                }
                
                
            };
            
            return cell;
        }else{
            SVLabelPrintingCell *cell = [tableView dequeueReusableCellWithIdentifier:LabelPrintingCellID];
            
            //如果没有就重新建一个
            if (!cell) {
                cell = [[SVLabelPrintingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LabelPrintingCellID];
            }
            

            NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
            if (ary_1.count > indexPath.row) {
                SVduoguigeModel *model = [ary_1 objectAtIndex:indexPath.row];
                
                if (self.selectModelArray.count == 0) {
                    cell.model = model;
                } else {
                    
                    for (SVduoguigeModel *equalModel in self.selectModelArray) {
                        
                        if ([equalModel.product_id isEqualToString:model.product_id]) {
                            cell.model = equalModel;
                            return cell;
                        }
                        cell.model = model;
                        
                    }
                }
            }
            
            
            return cell;
        }
        
        
        
        
        
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
        self.productcategory_id = [self.bigIDArr objectAtIndex:indexPath.row];
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
      //  [self getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@"" isn:@"" read_morespec:@"true"];
        self.page = 1;
        [self loadDataWithID:self.productcategory_id];
        [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] producttype_id:@"-1" name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
    }
    if (tableView == self.twoTableView) {
        
        NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        
        SVduoguigeModel *model = [ary_1 objectAtIndex:indexPath.row];//这里有一个报错
        
        if (self.controllerNum == 0) {// 默认为0是商品列表跳转
            if (self.isDetail == YES) {
                 //一句实现点击效果
                [self.twoTableView deselectRowAtIndexPath:indexPath animated:YES];
                
                NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
                
                SVduoguigeModel *model = [ary_1 objectAtIndex:indexPath.row];//这里有一个报错
                
                //            //跳转会员详情界面
                //        if (model.sv_is_newspec == 1) {
                //
                //            SVMultiSpecificationVC *multiSpecificationVC = [[SVMultiSpecificationVC alloc] init];
                //            multiSpecificationVC.product_id = model.product_id;
                //            [self.navigationController pushViewController:multiSpecificationVC animated:YES];
                //        }
                
                SVWaresDetailsVC *VC = [[SVWaresDetailsVC alloc]init];
                VC.productID = model.product_id;
                VC.sv_is_newspec = model.sv_is_newspec;
                
                __weak typeof(self) weakSelf = self;
                VC.WaresDetailsBlock = ^(){
                    weakSelf.page = 1;
                    //提示加载中
                    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
                    //调用请求方法
                 //   [self getDataPageIndex:1 pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@"" isn:@"" read_morespec:@"true"];
                    
                    [self getDataPageIndex:self.page pageSize:20 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] producttype_id:self.productsubcategory_id name:self.searchBar.text isn:self.searchBar.text read_morespec:@"true"];
                };
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                [SVTool TextButtonAction:self.view withSing:@"没有权限"];
            }
           
            
        }else if (self.controllerNum == 1){
            
            if ([model.sv_product_type isEqualToString:@"2"]) {
                [SVTool TextButtonAction:self.view withSing:@"套餐商品不能计算进货"];
                return;
            }
            
            if ([model.producttype_id isEqualToString:@"1"]) {
                [SVTool TextButtonAction:self.view withSing:@"服务商品不能计算进货"];
                return;
            }

          if (model.sv_is_newspec == 1) { // 是多规格的商品
                         //  model.isSelect = @"1";
                         SVShopSingleTemplateVC *shopSingleTemplateVC = [[SVShopSingleTemplateVC alloc] init];
                         shopSingleTemplateVC.delegate = self.purchaseManagementVC;
                         shopSingleTemplateVC.productID = model.product_id;
                         shopSingleTemplateVC.sv_p_name = model.sv_p_name;
                         shopSingleTemplateVC.sv_p_images2 = model.sv_p_images2;
                         shopSingleTemplateVC.sv_p_images = model.sv_p_images;
                         shopSingleTemplateVC.sv_p_unitprice = model.sv_p_unitprice;
                         shopSingleTemplateVC.sv_p_barcode = model.sv_p_barcode;
                         shopSingleTemplateVC.isStockPurchase = 1;
                         [self.navigationController pushViewController:shopSingleTemplateVC animated:YES];
                         // self.model = model;// 这里来
                         self.selectCellIndex = indexPath.row;
                         NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
                         model.isSelect = @"1";
                         [ary_1 replaceObjectAtIndex:indexPath.row withObject:model];
                         //数组给模型数组
                         [self.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:ary_1];
                         [self.twoTableView reloadData];
             

          }else{
              #pragma mark - 不是多规格商品
                for (SVduoguigeModel *selectModel in self.selectModelArray) {
                              if (selectModel.product_id == model.product_id) {
                                  [self.selectModelArray removeObject:selectModel];
         
                                  model.isSelect = @"0";
                                  if (self.selectModelBlock) {
                                  self.selectModelBlock(model);
                                  }
          
                                  [self.PrintingCollectionView reloadData];
                                  [self.twoTableView reloadData];
                                  return;
                              }
                          }
                          
                          if ([model.isSelect isEqualToString:@"1"]) {
                              for (SVduoguigeModel *selectModel in self.selectModelArray) {
                                  if (selectModel.product_id == model.product_id) {
                                      [self.selectModelArray removeObject:selectModel];
                                      break;
                                  }
                              }

                               model.isSelect = @"0";
                              if (self.selectModelBlock) {
                               self.selectModelBlock(model);
                              }
                             
                          }else{
                              
                              //  [self.serviceCollectionView removeFromSuperview];
                              NSInteger aa = 1;
                              [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
                              [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                              [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                              //  [self.PrintingCollectionView reloadData];
                              [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                              self.selectCellIndex = indexPath.row;
                              
                          }
                          [self.PrintingCollectionView reloadData];
                          [self.twoTableView reloadData];
          }
         
        }else{
            
            if ([model.sv_product_type isEqualToString:@"2"]) {
                         [SVTool TextButtonAction:self.view withSing:@"套餐商品不能计算退货"];
                         return;
                     }
                     
                     if ([model.producttype_id isEqualToString:@"1"]) {
                         [SVTool TextButtonAction:self.view withSing:@"服务商品不能计算退货"];
                         return;
                     }
                     
                     if (model.sv_is_newspec == 1) { // 是多规格的商品
                         //  model.isSelect = @"1";
                         SVShopSingleTemplateVC *shopSingleTemplateVC = [[SVShopSingleTemplateVC alloc] init];
                         shopSingleTemplateVC.delegate = self.purchaseManagementVC;
                         shopSingleTemplateVC.productID = model.product_id;
                         shopSingleTemplateVC.sv_p_name = model.sv_p_name;
                         shopSingleTemplateVC.sv_p_images2 = model.sv_p_images2;
                         shopSingleTemplateVC.sv_p_images = model.sv_p_images;
                         shopSingleTemplateVC.sv_p_unitprice = model.sv_p_unitprice;
                         shopSingleTemplateVC.sv_p_barcode = model.sv_p_barcode;
                         shopSingleTemplateVC.isStockPurchase = 2;// 显示退货
                         [self.navigationController pushViewController:shopSingleTemplateVC animated:YES];
                         // self.model = model;// 这里来
                         self.selectCellIndex = indexPath.row;
                         NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
                         model.isSelect = @"1";
                         [ary_1 replaceObjectAtIndex:indexPath.row withObject:model];
                         //数组给模型数组
                         [self.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:ary_1];
                         [self.twoTableView reloadData];
                  
                     }else{

//                    #pragma mark - 不是多规格商品
            for (SVduoguigeModel *selectModel in self.selectModelArray) {
                          if (selectModel.product_id == model.product_id) {
                              [self.selectModelArray removeObject:selectModel];
     
                              model.isSelect = @"0";
                              if (self.selectModelBlock) {
                              self.selectModelBlock(model);
                              }
          //                    [ary_1 replaceObjectAtIndex:selctCount withObject:model_two];
          //                           //数组给模型数组
          //                    [weakSelf.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:ary_1];
                              [self.PrintingCollectionView reloadData];
                              [self.twoTableView reloadData];
                              return;
                          }
                      }
                      
                      if ([model.isSelect isEqualToString:@"1"]) {
                          for (SVduoguigeModel *selectModel in self.selectModelArray) {
                              if (selectModel.product_id == model.product_id) {
                                  [self.selectModelArray removeObject:selectModel];
                                  break;
                              }
                          }
                          
          //                for (SVduoguigeModel *equalModel in self.selectModelArray) {
          //                    totle += equalModel.purchase.floatValue *equalModel.price.floatValue;
          //
          //                }
          //                self.totleMoneyLabel.text = [NSString stringWithFormat:@"%.2f",totle];
          //
          //                self.numLabel.text = [NSString stringWithFormat:@"%ld",self.selectModelArray.count];
                           model.isSelect = @"0";
                          if (self.selectModelBlock) {
                           self.selectModelBlock(model);
                          }
                         
                      }else{
                          
                          //  [self.serviceCollectionView removeFromSuperview];
                          NSInteger aa = 1;
                          [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
                          [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                          [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                          //  [self.PrintingCollectionView reloadData];
                          [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                          self.selectCellIndex = indexPath.row;
                          
                      }
                      [self.PrintingCollectionView reloadData];
                      [self.twoTableView reloadData];
//
                         
                     }
                     
//                     [self.twoTableView reloadData];
//
//                     [self.PrintingCollectionView reloadData];
        }
        
    }

}


#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1 ;
    
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1 ;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.selectNum == 3) {
    SVDetaildraftFirmOfferCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    [cell.string setString:@""];
    NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
    SVduoguigeModel *model = ary_1[self.selectCellIndex];
    cell.model = model;
    //        cell.model = self.selectModelArray[indexPath.row];
    cell.sureBtn.tag = self.selectCellIndex;
    __weak typeof(self) weakSelf = self;
    cell.sureBtnClickBlock = ^(NSInteger selctCount, SVduoguigeModel * _Nonnull model_two) {
     
        if (self.selectModelArray.count == 0) {
            [self.selectModelArray addObject:model];
            
        } else {
            
            //判断相同时，先删掉，再添加到数组中
            for (SVduoguigeModel *selctModel in self.selectModelArray) {
                
                if (selctModel.product_id == model.product_id) {
                    [self.selectModelArray removeObject:selctModel];
                    // aa = 0;
                    break;
                    
                }else{
                    
                }
            }
            
            //   当为选中1状态时，添加
            if ([model.isSelect isEqualToString:@"1"]) {
                [self.selectModelArray addObject:model];
                
            }
            
        }
                          //第一个选中时添加
                      
        
        if (weakSelf.selectModelBlock) {
            weakSelf.selectModelBlock(model_two);
        }
        
        
        [ary_1 replaceObjectAtIndex:selctCount withObject:model_two];
        //数组给模型数组
        [weakSelf.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:ary_1];
        [weakSelf.twoTableView reloadData];
        [weakSelf handlePan];
    
    };
    
    return cell;
 
}



#pragma mark - 懒加载控件
- (UICollectionView *)PrintingCollectionView
{
    if (_PrintingCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(ScreenW / 5 *4, 470);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // layout.minimumLineSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(0, ScreenW / 5 *1 / 2, 0, ScreenW / 5 *1 / 2);
        
        _PrintingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight,ScreenW, 520) collectionViewLayout:layout];
        // _PrintingCollectionView.automaticallyAdjustsScrollViewInsets = false;
        _PrintingCollectionView.backgroundColor = [UIColor clearColor];
        // _PrintingCollectionView.showsVerticalScrollIndicator = NO;
        _PrintingCollectionView.showsHorizontalScrollIndicator = NO;
        
    }
    
    
    
    return _PrintingCollectionView;
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

    [self.maskTheView removeFromSuperview];
    [self.PrintingCollectionView removeFromSuperview];
    [self.icon_button removeFromSuperview];
//    [UIView animateWithDuration:.5 animations:^{
//        self.productScreeningView.frame = CGRectMake(ScreenW, 0, ScreenW / 6 *5, ScreenH);
//    }];
    
}

#pragma mark - 代理方法
- (void)selectMoreModelClick:(NSMutableArray *)selectModelArray
{
    //    for (SVduoguigeModel *model in self.selectModelArray) {
    //        for (SVduoguigeModel *model2 in selectModelArray) {
    //            if ([model.product_id isEqualToString:model2.product_id]) {
    //                [self.selectModelArray removeObject:model];
    //                break;
    //            }
    //            [self.selectModelArray addObject:model2];
    //        }
    //    }
    
    //    NSMutableArray *arr1 = [NSMutableArray array];
    //    for (SVduoguigeModel *model in selectModelArray) {
    //        [arr1 addObject:model.product_id];
    //    }
    //
    //    NSMutableArray *arr2 = [NSMutableArray array];
    //    for (SVduoguigeModel *modell in self.selectModelArray) {
    //        [arr2 addObject:modell.product_id];
    //    }
    //    NSPredicate * filterPredicate_same = [NSPredicate predicateWithFormat:@"SELF IN %@",arr1];
    //    NSArray * filter_no = [arr2 filteredArrayUsingPredicate:filterPredicate_same];
    //    NSLog(@"-----%@",filter_no);
    //    if (kArrayIsEmpty(filter_no)) {
    //        self.addShopTotleNum += selectModelArray.count;
    //        self.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",self.addShopTotleNum];
    //        [self.selectModelArray addObjectsFromArray:selectModelArray];
    //    }else{
    //        //        [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"已添加过%ld个相同的商品"],filter_no.count];
    //        NSLog(@"%ld",filter_no.count);
    //        NSInteger count = filter_no.count;
    //        [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"已添加过%ld个相同的商品",count]];
    //    }
    
    if (!kArrayIsEmpty(selectModelArray)) {
        for (SVduoguigeModel *model in selectModelArray) {
            if (self.selectModelArray.count == 0) {
                //第一个选中时添加
                
                [self.selectModelArray addObject:model];
                
                
            } else {
                
                for (SVduoguigeModel *modell in self.self.selectModelArray) {
                    // SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                    if (modell.product_id == model.product_id) {
                        // model.product_num += modell.product_num;
                        
                        //                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"product_num"];
                        [self.selectModelArray removeObject:modell];
                        break;
                    }
                }
                
                
                [self.selectModelArray addObject:model];
                
                
            }
        }
        
        self.addShopTotleNum = self.selectModelArray.count;
        self.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",self.addShopTotleNum];
        
      //  NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        
        if (self.selectModelBlock) {
         self.selectModelBlock(self.selectModelArray);
        }
      //  SVduoguigeModel *model = [ary_1 objectAtIndex:self.selectCellIndex];//这里有一个报错
        //  model.isSelect = @"1";
        // self.model.isSelect = @"1";
//        if ([model.isSelect isEqualToString:@"1"]) {
//            if (self.purchaseArr.count == 0) {
//                //第一个选中时添加
//                [self.purchaseArr addObject:model];
//            } else {
//
//                //判断相同时，先删掉，再添加到数组中
//                for (NSDictionary *dict in self.purchaseArr) {
//                    SVduoguigeModel *modell = [SVduoguigeModel mj_objectWithKeyValues:dict];
//                    if (modell.product_id == model.product_id) {
//                        [self.purchaseArr removeObject:dict];
//                        break;
//                    }
//                }
//
//                //当为选中1状态时，添加
//                if ([model.isSelect isEqualToString:@"1"]) {
//                    [self.purchaseArr addObject:model];
//                }
//
//            }
//        }
        
        
        [self.twoTableView reloadData];
    }
    
}

#pragma mark - 滑动删除 Cell
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.twoTableView) {
        if (self.isClean == true) {
            return TRUE;
        }else{
            return FALSE;
        }
        
    }
    
    return FALSE;
    
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
    
    SVduoguigeModel *model = [ary_1 objectAtIndex:indexPath.row];
    //如果编辑样式为删除样式
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row<ary_1.count) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVUserManager loadUserInfo];
                NSString *token = [SVUserManager shareInstance].access_token;
                //url
                NSString *strURL = [URLhead stringByAppendingFormat:@"/product?key=%@&ids=%@",token,model.product_id];
                [[SVSaviTool sharedSaviTool] DELETE:strURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    if ([dic[@"succeed"] integerValue] == 1) {
                        //移除数据源的数据
                        [ary_1 removeObjectAtIndex:indexPath.row];
                        //移除tableView中的数据
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        [self.twoTableView reloadData];
                    } else {
                        NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                        [SVTool TextButtonAction:self.view withSing:errmsg];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    
                }];
            }];
            [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
            [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
            
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定要删除吗？"];
            //设置文本颜色
            [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 7)];
            //设置文本字体大小
            [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
            [alert setValue:hogan forKey:@"attributedTitle"];
            
            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
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

-(NSMutableArray *)purchaseArr {
    if (!_purchaseArr) {
        _purchaseArr = [NSMutableArray array];
    }
    return _purchaseArr;
}



- (NSMutableArray *)selectModelArray
{
    if (!_selectModelArray) {
        _selectModelArray = [NSMutableArray array];
    }
    
    return _selectModelArray;
}


@end
