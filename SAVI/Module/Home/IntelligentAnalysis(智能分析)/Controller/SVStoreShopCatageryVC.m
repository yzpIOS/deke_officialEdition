//
//  SVStoreShopCatageryVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVStoreShopCatageryVC.h"
#import "SVOneStoreCell.h"
#import "SVShopOverviewModel.h"
#import "SVTwoDoBusinessCell.h"
#import "SVStoreLineView.h"
#import "SVIntelligentDetailCell.h"
#import "SVStoreTopView.h"
#import "SVStoreCategaryModel.h"
#import "SVProportionCell.h"
static NSString *const ID = @"UITableViewCell";
static NSString *const OneStoreCellID = @"SVOneStoreCell";
static NSString *const TwoDoBusinessCellID = @"SVTwoDoBusinessCell";
static NSString *const IntelligentDetailCellID = @"SVIntelligentDetailCell";
static NSString *const ProportionCellID = @"SVProportionCell";

//字体大小
#define TextFont    14
#define BigFont    15
#define CentreFont  12
#define SmallFont   11

//现金
#define colorA  RGBA(226, 134, 207, 1)
//微信
#define colorB  RGBA(130, 131, 214, 1)
//银行卡
#define colorC  RGBA(250, 193, 103, 1)
//储值卡
#define colorD  RGBA(129, 211, 38, 1)

@interface SVStoreShopCatageryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *valuesArr;
@property (nonatomic,assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,strong) NSMutableArray *dataList;
//@property (nonatomic,strong) SVFourLabelView *fourLabelView;
@property (nonatomic,strong) SVStoreTopView *storeTopView;
@property (nonatomic,strong) NSMutableArray *GreaterThanArray;
@property (nonatomic,assign) double order_receivable;
@property (nonatomic,strong) NSMutableArray *colorArrM_3;
@property (nonatomic,strong) NSMutableArray *moneyArrM_3;
@property (nonatomic,strong) NSMutableArray *item3_array;
@property (weak, nonatomic) IBOutlet UILabel *fatherTotleMoney;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourHeight;
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeHeight;
@property (weak, nonatomic) IBOutlet UILabel *fatherNumber;

@property (weak, nonatomic) IBOutlet UIView *categaryView;

//饼图属性
@property (nonatomic, strong) PNPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;

@property (nonatomic,strong) NSString *oneDate;
@property (nonatomic,strong) NSString *twoDate;

@property (nonatomic,strong) NSMutableArray *colorArray;


@end

@implementation SVStoreShopCatageryVC

- (SVStoreTopView *)storeTopView
{
    if (!_storeTopView) {
        _storeTopView = [[NSBundle mainBundle]loadNibNamed:@"SVStoreTopView" owner:nil options:nil].lastObject;
        _storeTopView.frame = CGRectMake(0, 0, ScreenW, 50);
        _storeTopView.storeName.text = @"商品分类";
        _storeTopView.storeNum.text = @"消费数量";
        _storeTopView.storeTotleMoney.text = @"销售金额";
        _storeTopView.storeGite.text = @"占比";
        _storeTopView.chongzhiView.hidden = YES;
        _storeTopView.fatherView.hidden = YES;
    }
    
    return _storeTopView;
}

- (NSMutableArray *)GreaterThanArray
{
    if (!_GreaterThanArray) {
        _GreaterThanArray = [NSMutableArray array];
    }
    return _GreaterThanArray;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)item3_array{
    if (_item3_array == nil) {
        _item3_array = [NSMutableArray array];
    }
    return _item3_array;
}

- (NSMutableArray *)colorArrM_3
{
    if (!_colorArrM_3) {
        _colorArrM_3 = [NSMutableArray array];
    }
    
    return _colorArrM_3;
}

- (NSMutableArray *)moneyArrM_3
{
    if (!_moneyArrM_3) {
        _moneyArrM_3 = [NSMutableArray array];
    }
    return _moneyArrM_3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorArray = [NSMutableArray arrayWithObjects:@"f79c2c",@"3992f9",@"54e58b",@"fcd866",@"f16093",@"60d1f1",@"d1f160",@"f17460", nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification3:) name:@"nitifyName3" object:nil];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyShopNameAllStore:) name:@"nitifyShopNameAllStore" object:nil];
    
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    
    self.categaryView.layer.cornerRadius = 10;
    self.categaryView.layer.masksToBounds = YES;
    
    self.threeView.layer.cornerRadius = 10;
    self.threeView.layer.masksToBounds = YES;
    
    self.fourView.layer.cornerRadius = 10;
    self.fourView.layer.masksToBounds = YES;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:@"SVIntelligentDetailCell" bundle:nil] forCellReuseIdentifier:IntelligentDetailCellID];
  //  [self setUpData];
    
    if (kDictIsEmpty(self.dic)) {
        
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        // self.page = 1;
        self.type = 1; // 默认是今天
        self.oneDate = @"";
        self.twoDate = @"";
        // [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //        [self setShopOverviewType:self.type Page:self.page top:10 date:@"" date2:@""];
    }else{
        NSString *type = [self.dic objectForKey:@"type"];

        if ([type isEqualToString:@"3"]) {// 本月
            self.type = type.integerValue;
            
            self.oneDate = @"";
            self.twoDate = @"";
            
            //  [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
            //           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
            
        }else if ([type isEqualToString:@"1"]){// 是今天
            self.type = type.integerValue;
            self.oneDate = @"";
            self.twoDate = @"";
            //  self.page = 1;
            
            // [self setUpDataType:1];
           [self setUpDataUser_id:self.user_id];
            //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
            
        }else if ([type isEqualToString:@"2"]){// 昨天
            self.type = type.integerValue;
            // self.timeLabel.text = @"昨天";
            self.oneDate = @"";
            self.twoDate = @"";
            // self.page = 1;
            //  self.page = 1;
            
            //  [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
            //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
            
            
        }else{
            self.type = type.integerValue;
            self.oneDate = [self.dic objectForKey:@"oneDate"];
            self.twoDate = [self.dic objectForKey:@"twoDate"];
            // self.page = 1;
            
            //  [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
            //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
            
        }
    }
    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName3" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyShopNameAllStore" object:nil];
}

- (void)nitifyShopNameAllStore:(NSNotification *)noti{
    
    NSString *type = [NSString stringWithFormat:@"%ld",self.type];
    NSDictionary  *dic = [noti userInfo];
    self.user_id = dic[@"user_id"];
    if ([type isEqualToString:@"3"]) {// 本周
        self.type = type.integerValue;
        self.page = 1;
        self.oneDate = @"";
        self.twoDate = @"";
        
        // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"1"]){// 是今天
        self.type = type.integerValue;
        
        self.page = 1;
        
        // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"2"]){// 昨天
        self.type = type.integerValue;
        self.page = 1;
        // self.timeLabel.text = @"昨天";
        self.oneDate = @"";
        self.twoDate = @"";
        // self.page = 1;
        //  self.page = 1;
        
        //  [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
        
    }else{
        if (kDictIsEmpty(self.dic)) {
            self.type = type.integerValue;
            self.page = 1;
            self.oneDate = @"";
            self.twoDate = @"";
            // self.page = 1;
            
            // [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
        }else{
            self.type = type.integerValue;
            self.page = 1;
            self.oneDate = [self.dic objectForKey:@"oneDate"];
            self.twoDate = [self.dic objectForKey:@"twoDate"];
            // self.page = 1;
            
            // [self setUpDataType:1];
            [self setUpDataUser_id:self.user_id];
        }
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }
}

#pragma mark - 时间晒选
-(void)notification3:(NSNotification *)noti{
    
    //    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    //    // NSString *type = [dic objectForKey:@"type"];
    //    // self.type = type;
        self.dic = dic;
    
    NSString *type = [dic objectForKey:@"type"];
    if ([type isEqualToString:@"3"]) {// 本周
        self.type = type.integerValue;
        self.page = 1;
        self.oneDate = @"";
        self.twoDate = @"";
        
        // [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"1"]){// 是今天
        self.type = type.integerValue;
        
        self.page = 1;
        
        // [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"2"]){// 昨天
        self.type = type.integerValue;
        self.page = 1;
        // self.timeLabel.text = @"昨天";
        self.oneDate = @"";
        self.twoDate = @"";
        // self.page = 1;
        //  self.page = 1;
        
        //  [self setUpDataType:1];
       [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
        
    }else{
        self.type = type.integerValue;
        self.page = 1;
        self.oneDate = [dic objectForKey:@"oneDate"];
        self.twoDate = [dic objectForKey:@"twoDate"];
        // self.page = 1;
        
        // [self setUpDataType:1];
        [self setUpDataUser_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }
    
}

- (void)setUpDataUser_id:(NSString *)user_id{
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    self.page = 1;
   // self.type = 1; // 默认是今天
    [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate user_id:user_id];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate user_id:user_id];
        
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置文字
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"最近刷新时间" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    //    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    
    self.scrollView.mj_header = header;

}

// 店铺概况
- (void)setShopOverviewType:(NSInteger)type Page:(NSInteger)page top:(NSInteger)top date:(NSString *)date date2:(NSString *)date2 user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetProductCategoryAnalysis?key=%@&type=%li&date_start=%@&date_end=%@&user_id=%@&operateId=&categoryids=",token,(long)type,date,[NSString stringWithFormat:@"%@ 23:59:59",date2],user_id];
    NSLog(@"dURL = %@",dURL);
      NSString *utf = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:utf parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic444pppppp = %@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
            
           // if (self.page == 1) {
                [self.dataList removeAllObjects];
                [self.GreaterThanArray removeAllObjects];
           // }
            
            NSMutableArray *listArr = dic[@"values"];
            //  [self.categaryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            NSLog(@"listArr = %@",listArr);
            
            NSMutableArray *dataList = [NSMutableArray array];
            NSMutableArray *GreaterThanArray = [NSMutableArray array];
            NSMutableArray *category_totalArray = [NSMutableArray array];
            for (NSDictionary *values in listArr) {
                //字典转模型
                SVStoreCategaryModel *model = [SVStoreCategaryModel mj_objectWithKeyValues:values];
                model.selectVC = 1;
                //   model.JurisdictionNum = self.JurisdictionNum;
                //                    [self.modelArr addObject:model];
                
                [dataList addObject:model];
                
                
                if ([model.category_num floatValue] > 0) {
                    
                    [GreaterThanArray addObject:model];
                    
                    
                }
                
                if ([model.category_total floatValue] > 0) {
                    [category_totalArray addObject:model];
                }
                
            }
            
            // 第一个view上的数据
            double order_receivable1 = 0.0;
            // float order_pdgfee = 0.0;
            double count = 0;
            for (SVStoreCategaryModel *model in dataList) {
                order_receivable1 = [model.total_amount doubleValue];
                // order_pdgfee += [model.order_pdgfee floatValue];
                count += [model.category_num doubleValue];
            }
            self.fatherTotleMoney.text = [NSString stringWithFormat:@"%.2f",order_receivable1];
            self.fatherNumber.text = [NSString stringWithFormat:@"%.2f",count];
            
            
            if (![SVTool isEmpty:listArr]) {
                [self.categaryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                NSMutableArray *category_totalArray = [NSMutableArray array];
                for (NSDictionary *values in listArr) {
                    //字典转模型
                    SVStoreCategaryModel *model = [SVStoreCategaryModel mj_objectWithKeyValues:values];
                    model.selectVC = 1;
                    //   model.JurisdictionNum = self.JurisdictionNum;
                    //                    [self.modelArr addObject:model];
             
                        [self.dataList addObject:model];
                
                    
                    if ([model.category_num floatValue] > 0) {
                        
                        [self.GreaterThanArray addObject:model];
                        
                        
                    }
                    
                    if ([model.category_total floatValue] > 0) {
                        [category_totalArray addObject:model];
                    }
                    
                }
                
                // 第一个view上的数据
                double order_receivable1 = 0.0;
                // float order_pdgfee = 0.0;
                double count = 0;
                for (SVStoreCategaryModel *model in self.dataList) {
                    order_receivable1 = [model.total_amount doubleValue];
                    // order_pdgfee += [model.order_pdgfee floatValue];
                    count += [model.category_num doubleValue];
                }
                self.fatherTotleMoney.text = [NSString stringWithFormat:@"%.2f",order_receivable1];
                self.fatherNumber.text = [NSString stringWithFormat:@"%.2f",count];
                
                
                double order_receivable = 0.0;
                for (SVStoreCategaryModel *model in category_totalArray) {
                    order_receivable += [model.category_total doubleValue];
                }
                
                
                
                self.order_receivable = order_receivable;
                
                // 商品类别
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 3, 13)];
                lineView.backgroundColor = navigationBackgroundColor;
                [self.categaryView addSubview:lineView];
                
                UILabel *textL = [[UILabel alloc] init];
                [self.categaryView addSubview:textL];
                UIFont *fnt = [UIFont systemFontOfSize:15];
                textL.textColor= [UIColor colorWithHexString:@"666666"];
                textL.text = @"商品类别";
                textL.font = fnt;
                // 根据字体得到NSString的尺寸
                CGSize size = [textL.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                // 名字的H
                CGFloat nameH = size.height;
                // 名字的W
                CGFloat nameW = size.width;
                textL.frame = CGRectMake(CGRectGetMaxX(lineView.frame) + 5,0, nameW,nameH);
                textL.centerY = lineView.centerY;
                
                
                NSMutableArray *item_Array  = [NSMutableArray array];
                //  NSMutableArray *item_ArrayTwo  = [NSMutableArray array];
                float Count = 0.0;
                // 添加UIsrollView
                
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 53, ScreenW - 20 -170, 140)];
                CGFloat maxY = 0;

                for (int i = 0; i < category_totalArray.count; i++) {
                    SVStoreCategaryModel *model = category_totalArray[i];
                    // }
                    if (!([model.category_total floatValue] <= 0)) {
                        UIColor * randomColor;
                        if (i > self.colorArray.count - 1) {
                            randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                        }else{
                            randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                        }
                        [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[model.category_total floatValue] color:randomColor]];
                       // Count += [dict[@"payment_amount"]floatValue];
                        
                        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW - 20 -170 - 20, 30)];
                        // view.backgroundColor = [UIColor yellowColor];
                        
                        UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                        cicleView.backgroundColor = randomColor;
                        [view addSubview:cicleView];
                        UILabel *memLabel = [[UILabel alloc] init];
                        [view addSubview:memLabel];
                        memLabel.text = [NSString stringWithFormat:@"%@   ￥%.2f",model.sv_pc_name,[model.category_total doubleValue]];
                        // 设置Label的字体 HelveticaNeue  Courier
                        UIFont *fnt = [UIFont systemFontOfSize:12];
                        memLabel.textColor= [UIColor colorWithHexString:@"666666"];
                        memLabel.font = fnt;
                        // 根据字体得到NSString的尺寸
                        CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                        // 名字的H
                        CGFloat nameH = size.height;
                        // 名字的W
                        CGFloat nameW = size.width;
                        memLabel.frame = CGRectMake(CGRectGetMaxX(cicleView.frame) + 5,0, nameW,nameH);
                        memLabel.centerY = cicleView.centerY;
                        
                        
                        maxY = CGRectGetMaxY(view.frame);
                        // cicleView.centerY = view.centerY;
                        [scrollView addSubview:view];
                        
                    }
                }
                
                
                if (kArrayIsEmpty(item_Array)) {
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    [self.categaryView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.categaryView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                }else{
                    [self.categaryView addSubview:scrollView];
                    scrollView.delegate = self;
                    
                    scrollView.contentSize = CGSizeMake(0, maxY);
                    
                    // 历史会员圈圈
                    PNPieChart *chart = [[PNPieChart alloc] initWithFrame:CGRectMake(10, 53, 150, 150) items:item_Array];
                    chart.descriptionTextColor = [UIColor whiteColor];
                    chart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                    chart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
                    chart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
                    chart.showOnlyValues = YES; // 只显示数值不显示内容描述
                    
                    chart.innerCircleRadius = 0;
                    
                    
                    [chart strokeChart];
                    
                    //设置标注
                    chart.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
                    chart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
                    [self.categaryView addSubview:chart];
                    
                    
                    
                    
                    //总消费额
                    UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 113, 70, 15)];
                    V3sumlabel.text = @"总消费";
                    V3sumlabel.textAlignment = NSTextAlignmentCenter;
                    V3sumlabel.font = [UIFont systemFontOfSize:12];
                    V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
                    V3sumlabel.adjustsFontSizeToFitWidth = YES;
                    V3sumlabel.minimumScaleFactor = 0.5;
                    [self.categaryView  addSubview:V3sumlabel];
                    
                    
                    UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 132, 130, 12)];
                    sumtextlabel.text = [NSString stringWithFormat:@"%.2f",self.order_receivable];
                    sumtextlabel.textAlignment = NSTextAlignmentCenter;
                    sumtextlabel.font = [UIFont systemFontOfSize:14];
                    sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
                    [self.categaryView  addSubview:sumtextlabel];
                }
                
                
                
                
                // 这是商品分类排行
                CGFloat maxY2 = 0;
                
                [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i = 0; i < category_totalArray.count ; i++) {
                    
                     SVStoreCategaryModel *model = category_totalArray[i];
                    
                    if ([model.category_total floatValue] <= 0) {//数据为0时
                    }else{
                        // maxY = 48*i + 1;
                        // maxY = 48*i + 1;
                        
                        //  [self.fatherView removeFromSuperview];
                        SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY2, ScreenW - 20, 48)];
                        rankingsV.namelabel.text = model.sv_pc_name;
                        rankingsV.moneylabel.text = [NSString stringWithFormat:@"￥%.2f",[model.category_total floatValue]];
                        float twoWide = 210 * [model.category_total floatValue] / self.order_receivable;
                        
                        [UIView animateWithDuration:1 animations:^{
                            rankingsV.colorView.width = twoWide;
                        }];
                        rankingsV.colorView.height = 15;
                        
                        rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                        rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                        //  maxY = maxY;
                        maxY2 = CGRectGetMaxY(rankingsV.frame);
                        
                         [self.fatherView addSubview:rankingsV];
                        
                    }
                    
                    
                    
                }
                
                
                if (kArrayIsEmpty(self.fatherView.subviews)) {
                    self.threeHeight.constant = 230;
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    [self.fatherView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.fatherView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                    
                }else{
                    self.threeHeight.constant = maxY2 + 63;
                    
                }
                
                [self.tableView reloadData];
                
            }else{
                
                if (kArrayIsEmpty(self.GreaterThanArray)) {
                    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    self.threeHeight.constant = 230;
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    [self.fatherView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.fatherView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                    
                    [self.categaryView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    UIImageView *img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    [self.categaryView addSubview:img2];
                    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.categaryView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                }
                
                
                /** 所有数据加载完毕，没有更多的数据了 */
               // self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            
            
            
        }else{
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
            
            
        }
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        if ([self.scrollView.mj_footer isRefreshing]) {
            
            [self.scrollView.mj_footer endRefreshing];
        }
        
          self.fourHeight.constant = 37+ self.dataList.count * 50;
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
  
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
//    if (indexPath.section == 0) {
//        SVOneStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:OneStoreCellID];
//        if (!cell) {
//            cell = [[SVOneStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneStoreCellID];
//        }
//         cell.selectionStyle =UITableViewCellSelectionStyleNone;
//        cell.catageryArray = self.dataList;
//
//        return cell;
//    }else if (indexPath.section == 1){
//        [self.item3_array removeAllObjects];
//        SVProportionCell *cell = [tableView dequeueReusableCellWithIdentifier:ProportionCellID];
//        if (!cell) {
//            cell = [[SVProportionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProportionCellID];
//        }
//          [cell.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        // 初始化
//        for (NSInteger i = 0; i < self.colorArrM_3.count; i++) {
//
//            [self.item3_array addObject:[PNPieChartDataItem dataItemWithValue:[self.moneyArrM_3[i] floatValue] color:self.colorArrM_3[i]]];
//        }
//
//        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:self.item3_array];
//        self.pieChart.descriptionTextColor = [UIColor whiteColor];
//        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
//        self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
//        self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
//        self.pieChart.showOnlyValues = YES; // 只显示数值不显示内容描述
//
//        self.pieChart.innerCircleRadius = 0;
//
//
//        [self.pieChart strokeChart];
//
//        //设置标注
//        self.pieChart.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
//        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
//
//        [cell.fatherView addSubview:self.pieChart];
//
//        //总消费额
//        UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
//        V3sumlabel.text = @"543534";
//         V3sumlabel.textAlignment = NSTextAlignmentCenter;
//        V3sumlabel.font = [UIFont systemFontOfSize:TextFont];
//        V3sumlabel.adjustsFontSizeToFitWidth = YES;
//        V3sumlabel.minimumScaleFactor = 0.5;
//        [cell.fatherView addSubview:V3sumlabel];
//
//        UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
//        sumtextlabel.text = @"总消费额";
//        sumtextlabel.textAlignment = NSTextAlignmentCenter;
//        sumtextlabel.font = [UIFont systemFontOfSize:CentreFont];
//        sumtextlabel.textColor = RGBA(248, 107, 80, 1);
//        [cell.fatherView addSubview:sumtextlabel];
//         cell.selectionStyle =UITableViewCellSelectionStyleNone;
//
//        return cell;
//
//    }else if (indexPath.section == 2){
//        SVTwoDoBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:TwoDoBusinessCellID];
//        if (!cell) {
//            cell = [[SVTwoDoBusinessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TwoDoBusinessCellID];
//        }
//        cell.order_receivable = self.order_receivable;
//        cell.catageryArray = self.GreaterThanArray;
//        cell.selectionStyle =UITableViewCellSelectionStyleNone;
//        return cell;
//
//    }else{
        SVIntelligentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligentDetailCellID];
        if (!cell) {
            cell = [[SVIntelligentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligentDetailCellID];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.categaryModel = self.dataList[indexPath.row];
        
        return cell;
   // }
    
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        return 50;
 
    
}

@end
