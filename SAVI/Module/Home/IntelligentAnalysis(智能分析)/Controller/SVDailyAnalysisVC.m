//
//  SVDailyAnalysisVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/27.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVDailyAnalysisVC.h"
#import "SVOneStoreCell.h"
#import "SVShopOverviewModel.h"
#import "SVTwoDoBusinessCell.h"
#import "SVStoreLineView.h"
#import "SVIntelligentDetailCell.h"
#import "SVStoreTopView.h"
#import "SVProportionCell.h"
#import "SVColorCell.h"
#import "SVShopSalesRankingCell.h"
#import "SVNewlyAddedCell.h"
#import "SVMemberNumberCell.h"
#import "SVPayConstituteCell.h"

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

static NSString *const ID = @"UITableViewCell";
static NSString *const OneStoreCellID = @"SVOneStoreCell";
static NSString *const TwoDoBusinessCellID = @"SVTwoDoBusinessCell";
static NSString *const IntelligentDetailCellID = @"SVIntelligentDetailCell";
static NSString *const ProportionCellID = @"SVProportionCell";
static NSString *const ColorCellID = @"SVColorCell";
static NSString *const ShopSalesRankingCellID = @"SVShopSalesRankingCell";
static NSString *const NewlyAddedCellID = @"SVNewlyAddedCell";
static NSString *const MemberNumberCellID = @"SVMemberNumberCell";
static NSString *const PayConstituteCellID = @"SVPayConstituteCell";
@interface SVDailyAnalysisVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *valuesArr;
@property (nonatomic,assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic,strong) NSMutableArray *dataList;
//@property (nonatomic,strong) SVFourLabelView *fourLabelView;
@property (nonatomic,strong) SVStoreTopView *storeTopView;
@property (nonatomic,strong) NSMutableArray *GreaterThanArray;
@property (nonatomic,assign) float order_receivable;
//NSString *oneDate = [dic objectForKey:@"oneDate"];
@property (nonatomic,assign) float memberOrder_receivable;
@property (nonatomic,strong) NSString *oneDate;
@property (nonatomic,strong) NSString *twoDate;

@property (nonatomic,strong) NSMutableArray *colorArrM_3;
@property (nonatomic,strong) NSMutableArray *moneyArrM_3;
@property (nonatomic,strong) NSMutableArray *item3_array;

@property (nonatomic,strong) NSMutableArray *colorArrM_4;
@property (nonatomic,strong) NSMutableArray *moneyArrM_4;
@property (nonatomic,strong) NSMutableArray *item4_array;
@property (nonatomic,strong) NSMutableArray *colorAndMoneyArray4;
//饼图属性
@property (nonatomic, strong) PNPieChart *pieChart;
@property (nonatomic,assign) float money;
@property (nonatomic,assign) float money4;
@property (nonatomic,strong) UITableView *twoTableView;

@property (nonatomic,strong) NSMutableArray *colorAndMoneyArray;
@property (nonatomic,strong) NSMutableArray *memberCountArray;

@property (nonatomic,strong) NSMutableArray *shopArray;
@property (nonatomic,strong) NSMutableArray *memberActiveArray;

// 新的架构
@property (weak, nonatomic) IBOutlet UILabel *businessSalesLabel;
@property (weak, nonatomic) IBOutlet UILabel *youzhezengLabel;
@property (weak, nonatomic) IBOutlet UILabel *StrokeNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *memdianyingyeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memdianyingyeHeight;
@property (weak, nonatomic) IBOutlet UIView *payView;

@property (weak, nonatomic) IBOutlet UITableView *tableViewNew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeHeight;


@property (weak, nonatomic) IBOutlet UIView *allstoreMemberNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allStoreNUmberHieght;
@property (weak, nonatomic) IBOutlet UIView *allmemberSmallView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewNewTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sevenViewHeight;
@property (weak, nonatomic) IBOutlet UIView *activeView;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *fouView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (weak, nonatomic) IBOutlet UIView *lastView;

@property (weak, nonatomic) IBOutlet UILabel *newmember_count;
@property (weak, nonatomic) IBOutlet UILabel *addNewMember_redio;

@property (weak, nonatomic) IBOutlet UILabel *allTotalMemberCount;
@property (weak, nonatomic) IBOutlet UILabel *allxiaofei_redio;

@property (weak, nonatomic) IBOutlet UILabel *activeNumber;
@property (weak, nonatomic) IBOutlet UILabel *active_redio;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSDictionary *timeDict;




@end

@implementation SVDailyAnalysisVC
- (NSMutableArray *)memberActiveArray
{
    if (!_memberActiveArray) {
        _memberActiveArray = [NSMutableArray array];
    }
    
    return _shopArray;
}
- (NSMutableArray *)shopArray
{
    if (!_shopArray) {
        _shopArray = [NSMutableArray array];
    }
    
    return _shopArray;
}

//- (NSMutableArray *)colorArray
//{
//    if (!_colorArray) {
//        _colorArray = [NSMutableArray array];
//    }
//
//    return _colorArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewNew.delegate = self;
    self.tableViewNew.dataSource = self;
    self.tableViewNew.scrollEnabled =NO; //设置tableview 不能滚动
    self.tableViewNew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableViewNew registerNib:[UINib nibWithNibName:@"SVPayConstituteCell" bundle:nil] forCellReuseIdentifier:PayConstituteCellID];
    
    self.tableViewNewTwo.delegate = self;
    self.tableViewNewTwo.dataSource = self;
    self.tableViewNewTwo.scrollEnabled =NO; //设置tableview 不能滚动
    self.tableViewNewTwo.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableViewNewTwo registerNib:[UINib nibWithNibName:@"SVShopSalesRankingCell" bundle:nil] forCellReuseIdentifier:ShopSalesRankingCellID];
    self.user_id = @"";// user_id为空就是默认是全部的店铺
   // [self allStoreData];
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    
    self.payView.layer.cornerRadius = 10;
    self.payView.layer.masksToBounds = YES;
    
    self.fouView.layer.cornerRadius = 10;
    self.fouView.layer.masksToBounds = YES;
    
    self.fiveView.layer.cornerRadius = 10;
    self.fiveView.layer.masksToBounds = YES;
    
    self.activeView.layer.cornerRadius = 10;
    self.activeView.layer.masksToBounds = YES;
    
    self.allstoreMemberNumber.layer.cornerRadius = 10;
    self.allstoreMemberNumber.layer.masksToBounds = YES;
    
    self.lastView.layer.cornerRadius = 10;
    self.lastView.layer.masksToBounds = YES;
    self.colorArray = [NSMutableArray arrayWithObjects:@"f79c2c",@"3992f9",@"54e58b",@"fcd866",@"f16093",@"60d1f1",@"d1f160",@"f17460", nil];
       //注册通知(接收,监听,一个通知)
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"nitifyName1" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyNameAllStore:) name:@"nitifyNameAllStore" object:nil];
    
    self.oneDate = @"";
    self.twoDate = @"";
    self.page = 1;
    self.type = 1;// 默认是今天
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];

    [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
}

#pragma mark - 全部商店的id
- (void)nitifyNameAllStore:(NSNotification *)noti{
    
    NSDictionary  *dic = [noti userInfo];
    NSString *user_id = dic[@"user_id"];
    NSLog(@"user_id = %@",user_id);
    self.user_id = user_id;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    if (self.type == 2) {
        self.oneDate = @"";
        self.twoDate = @"";
        self.page = 1;
        NSString *week = [self currentScopeWeek];
        [self setUpDataStart:week end:currentTimeString user_id:self.user_id];
    }else if (self.type == 1){
        self.oneDate = @"";
        self.twoDate = @"";
        self.page = 1;
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else if (self.type == -1){// 昨天
        self.oneDate = @"";
        self.twoDate = @"";
        self.page = 1;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
    }else{
        if (!kDictIsEmpty(self.timeDict)) {
            self.oneDate = [self.timeDict objectForKey:@"oneDate"];
            self.twoDate = [self.timeDict objectForKey:@"twoDate"];
            self.page = 1;
            self.type = 3;
            
            [self setUpDataStart:self.oneDate end:self.twoDate user_id:self.user_id];
        }
       
    }
    
}



#pragma mark - 时间晒选
-(void)notification1:(NSNotification *)noti{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    //使用userInfo处理消息  type 1是今天 -1是昨天 2是本月  其他是其他
    NSDictionary  *dic = [noti userInfo];
    self.timeDict = dic;
    NSString *type = [dic objectForKey:@"type"];
    self.type = type.integerValue;
    if ([type isEqualToString:@"2"]) {// 本周
        
        self.oneDate = @"";
        self.twoDate = @"";
        self.page = 1;
        NSString *week = [self currentScopeWeek];
        [self setUpDataStart:week end:currentTimeString user_id:self.user_id];
        
    }else if ([type isEqualToString:@"1"]){// 是今天
        self.oneDate = @"";
        self.twoDate = @"";
        self.page = 1;
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
        
    }else if ([type isEqualToString:@"-1"]){// 昨天
        self.oneDate = @"";
        self.twoDate = @"";
        self.page = 1;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
        
        
    }else{
        self.oneDate = [self.timeDict objectForKey:@"oneDate"];
        self.twoDate = [self.timeDict objectForKey:@"twoDate"];
        self.page = 1;
        self.type = 3;
        
        [self setUpDataStart:self.oneDate end:self.twoDate user_id:self.user_id];
    }
    NSLog(@"接收 userInfo传递的消息：%@",type);
    
}

/**
 当前周的日期范围
 
 @return 结果字符串
 */
- (NSString *)currentScopeWeek {
    // 默认周一为第一天，1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    return [self currentScopeWeek:2 dateFormat:@"yyyy-MM-dd"];
}

- (NSString *)currentScopeWeek:(NSUInteger)firstWeekday dateFormat:(NSString *)dateFormat
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    // 1.周日 2.周一 3.周二 4.周三 5.周四 6.周五  7.周六
    calendar.firstWeekday = firstWeekday;
    
    // 日历单元
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    unsigned unitNewFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowComponents = [calendar components:unitFlag fromDate:nowDate];
    // 获取今天是周几，需要用来计算
    NSInteger weekDay = [nowComponents weekday];
    // 获取今天是几号，需要用来计算
    NSInteger day = [nowComponents day];
    // 计算今天与本周第一天的间隔天数
    NSInteger countDays = 0;
    // 特殊情况，本周第一天firstWeekday比当前星期weekDay小的，要回退7天
    if (calendar.firstWeekday > weekDay) {
        countDays = 7 + (weekDay - calendar.firstWeekday);
    } else {
        countDays = weekDay - calendar.firstWeekday;
    }
    // 获取这周的第一天日期
    NSDateComponents *firstComponents = [calendar components:unitNewFlag fromDate:nowDate];
    [firstComponents setDay:day - countDays];
    NSDate *firstDate = [calendar dateFromComponents:firstComponents];
    
    // 获取这周的最后一天日期
    NSDateComponents *lastComponents = firstComponents;
    [lastComponents setDay:firstComponents.day + 6];
    NSDate *lastDate = [calendar dateFromComponents:lastComponents];
    
    // 输出
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *firstDay = [formatter stringFromDate:firstDate];
    NSString *lastDay = [formatter stringFromDate:lastDate];
    
    return [NSString stringWithFormat:@"%@",firstDay];
}



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName1" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyNameAllStore" object:nil];
}

- (void)setUpDataStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    

    [self PaymentStructureSType:self.type date:start date2:end user_id:user_id];
    [self storeMemberNumberUser_id:user_id];
    
    [self shopSalesTopStart:start end:end user_id:user_id];
    [self memberSaleCountInfoStart:start end:end user_id:user_id];
    
    [self GetMemberSalesAnalysisStart:start end:end user_id:user_id];
    [self setShopOverviewType:self.type Page:1 top:500 date:start date2:end user_id:user_id];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        
        [self PaymentStructureSType:self.type date:start date2:end user_id:user_id];
        [self storeMemberNumberUser_id:user_id];
        
        [self shopSalesTopStart:start end:end user_id:user_id];
        [self memberSaleCountInfoStart:start end:end user_id:user_id];
        
        [self GetMemberSalesAnalysisStart:start end:end user_id:user_id];
        [self setShopOverviewType:self.type Page:1 top:500 date:start date2:end user_id:user_id];
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
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        //  self.isSelect = YES;
        //调用请求
        //        [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.listView.searchWares.text biaoqian:@""];
        
        
//        [self PaymentStructureSType:self.type date:start date2:end];
//        [self storeMemberNumber];
//
//        [self shopSalesTopStart:start end:end];
//        [self memberSaleCountInfoStart:start end:end];
//
//        [self GetMemberSalesAnalysisStart:start end:end];
        [self setShopOverviewType:self.type Page:1 top:500 date:start date2:end user_id:user_id];
        
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
    
    self.scrollView.mj_footer.hidden = YES;
    
    self.scrollView.mj_footer = footer;
}



#pragma mark - 门店概况中会员活跃分布
- (void)memberSaleCountInfoStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetStoreMemberSaleCountInfo?key=%@&start=%@&end=%@&user_id=%@",token,start,end,user_id];
    NSLog(@"活跃DURL=%@",dURL);
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic门店概况中会员活跃分布 = %@",dic);
        NSMutableArray *array = dic[@"values"];
        if (!kArrayIsEmpty(array)) {
            self.memberActiveArray = array;
        }
        [self.activeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self.moneyArrM_4 removeAllObjects];
        [self.colorArrM_4 removeAllObjects];
        [self.colorAndMoneyArray4 removeAllObjects];
        float money = 0.0;

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 3, 13)];
        lineView.backgroundColor = navigationBackgroundColor;
        [self.activeView addSubview:lineView];
        
        UILabel *textL = [[UILabel alloc] init];
        [self.activeView addSubview:textL];
        UIFont *fnt = [UIFont systemFontOfSize:15];
        textL.textColor= [UIColor colorWithHexString:@"666666"];
        textL.text = @"会员活跃分布";
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
       // for (NSDictionary *dict in array) {
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dict = array[i];
           // }
            if (!([dict[@"count"]floatValue] <= 0)) {
                UIColor * randomColor;
                if (i > self.colorArray.count - 1) {
                    randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                }else{
                    randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                }
                
                [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"count"]floatValue] color:randomColor]];
                Count += [dict[@"count"]floatValue];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW - 20 -170 - 20, 30)];
                // view.backgroundColor = [UIColor yellowColor];
                
                UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                cicleView.backgroundColor = randomColor;
                [view addSubview:cicleView];
                UILabel *memLabel = [[UILabel alloc] init];
                [view addSubview:memLabel];
                memLabel.text = [NSString stringWithFormat:@"%@   %.2f%@",dict[@"remark"],[dict[@"ratio"]floatValue] *100,@"%"];
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
            [self.activeView addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.activeView);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
        }else{
            [self.activeView addSubview:scrollView];
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
            [self.activeView addSubview:chart];
            
            
            
            
            //总消费额
            UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 113, 70, 15)];
            V3sumlabel.text = @"活跃人数";
            V3sumlabel.textAlignment = NSTextAlignmentCenter;
            V3sumlabel.font = [UIFont systemFontOfSize:12];
            V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
            V3sumlabel.adjustsFontSizeToFitWidth = YES;
            V3sumlabel.minimumScaleFactor = 0.5;
            [self.activeView  addSubview:V3sumlabel];
            
            
            UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 132, 130, 12)];
            sumtextlabel.text = [NSString stringWithFormat:@"%.0f人",Count];
            sumtextlabel.textAlignment = NSTextAlignmentCenter;
            sumtextlabel.font = [UIFont systemFontOfSize:14];
            sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
            [self.activeView  addSubview:sumtextlabel];
        }
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        if ([self.scrollView.mj_footer isRefreshing]) {
            
            [self.scrollView.mj_footer endRefreshing];
        }
        
        
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 会员消费
- (void)GetMemberSalesAnalysisStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetMemberSalesAnalysis?key=%@&start=%@&end=%@&user_id=%@",token,start,end,user_id];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic会员消费 = %@",dic);
    NSDictionary *dicValue = [NSDictionary dictionary];
    dicValue = dic[@"values"];
                                 self.newmember_count.text = [NSString stringWithFormat:@"%@",dicValue[@"newmember_count"]];
                          self.addNewMember_redio.text = [NSString stringWithFormat:@"消费占比%.2f%@",[dicValue[@"newmember_order_receivable_ratio"] floatValue] *100,@"%"];
                       //   [dicValue[@"newmember_ordercount_ratio"] floatValue] *10,@"%"
                       self.allTotalMemberCount.text = [NSString stringWithFormat:@"%@",dicValue[@"member_count"]];
                                 self.allxiaofei_redio.text = @"消费占比100%";
                                 
                                self.activeNumber.text = [NSString stringWithFormat:@"%@",dicValue[@"oldmember_count"]];
                                 self.active_redio.text = [NSString stringWithFormat:@"消费占比%.2f%@",[dicValue[@"oldmember_order_receivable_ratio"] floatValue] *100,@"%"];
                                 
                                 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //隐藏提示框
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 商品销售排行
- (void)shopSalesTopStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetProductSalesTop10?key=%@&start=%@&end=%@&user_id=%@",token,start,end,user_id];
    NSLog(@"商品销售排行durl=%@",dURL);
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
      //  扫描中
        NSLog(@"dic商品销售排行 = %@",dic);
        [self.shopArray removeAllObjects];
        NSMutableArray *array = dic[@"values"];
        if (!kArrayIsEmpty(array)) {
            for (int i = 0; i < array.count; i++) {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                NSDictionary *dict = array[i];
                int a = i + 1;
                dictM[@"number"] = [NSString stringWithFormat:@"%d",a];
                dictM[@"product_name"] = dict[@"product_name"];
                
                dictM[@"sv_p_unitprice"] = [NSString stringWithFormat:@"%@",dict[@"sv_p_unitprice"]];
                dictM[@"sv_p_storage"] = [NSString stringWithFormat:@"%@",dict[@"sv_p_storage"]];
                

//                self.allMoney.text = [NSString stringWithFormat:@"%.2f",[dict[@"product_num"] floatValue] * [dict[@"sv_p_unitprice"]floatValue]];

                dictM[@"product_total"] = [NSString stringWithFormat:@"%@",dict[@"product_total"]];
                dictM[@"product_num"] = [NSString stringWithFormat:@"%@",dict[@"product_num"]];
                dictM[@"sv_p_unitprice"] = [NSString stringWithFormat:@"%@",dict[@"sv_p_unitprice"]];
                
                [self.shopArray addObject:dictM];
            }
           
        }
        
        NSLog(@"array = %@",array);
        self.sevenViewHeight.constant = 63 + self.shopArray.count * 50;
        [self.tableViewNewTwo reloadData];
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        if ([self.scrollView.mj_footer isRefreshing]) {
            
            [self.scrollView.mj_footer endRefreshing];
        }
        
        
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 各门店会员数
- (void)storeMemberNumberUser_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetStoreMemberCountInfo?key=%@&user_id=%@",token,user_id];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic各门店会员数 = %@",dic);
        self.memberCountArray = dic[@"values"];
        float num = 0.0;
        for (NSDictionary *dict in self.memberCountArray) {
           num +=[dict[@"count"] floatValue];
            
        }
        self.memberOrder_receivable = num;
       // [self.t reloadData];
        
        CGFloat maxY = 0;
        //    if (self.fatherView.subviews.count > 0) {
        //        [self.fatherView removeFromSuperview];
        //    }
        [self.allmemberSmallView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i = 0; i < self.memberCountArray.count ; i++) {
            
            NSDictionary *dict = self.memberCountArray[i];
            
            if ([dict[@"count"] floatValue] == 0) {//数据为0时
                
            }else{
                
                SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
                rankingsV.namelabel.text = dict[@"storename"];
                rankingsV.moneylabel.text = dict[@"ratiostring"];
                rankingsV.taglabel.text = [NSString stringWithFormat:@"%@人",dict[@"count"]];
                if (self.memberOrder_receivable != 0) {
                    float twoWide = 180 * [dict[@"count"] floatValue] / self.memberOrder_receivable;
                    NSLog(@"3333twoWide = %f",twoWide);
                    [UIView animateWithDuration:1 animations:^{
                        rankingsV.colorView.width = twoWide;
                    }];
                    rankingsV.colorView.height = 15;
                    
                    UIFont *fnt = [UIFont systemFontOfSize:12];
                    // self.moneylabel.textColor= [UIColor colorWithHexString:@"666666"];
                    rankingsV.moneylabel.font = fnt;
                    // 根据字体得到NSString的尺寸
                    CGSize sizeThree = [rankingsV.moneylabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                    // 名字的H
                    CGFloat nameHThree = sizeThree.height;
                    // 名字的W
                    CGFloat nameWThree = sizeThree.width;
                    rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, nameWThree, nameHThree);
//                    rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                    rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                    //  maxY = maxY;
                   // rankingsV.taglabel.frame
                   
                    
                    // tag
                    rankingsV.taglabel.font = fnt;
                    
                    CGSize sizeThree2 = [rankingsV.taglabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                    // 名字的H
                    CGFloat nameHThree2 = sizeThree2.height;
                    // 名字的W
                    CGFloat nameWThree2 = sizeThree2.width;
                    
                    rankingsV.taglabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.moneylabel.frame) + 10, 0, nameWThree2, nameHThree2);
                    //                    rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                    rankingsV.taglabel.centerY = rankingsV.moneylabel.centerY;
                     maxY = CGRectGetMaxY(rankingsV.frame);
                    //  maxY = maxY;
                    [self.allmemberSmallView addSubview:rankingsV];
                }
            }
            
            
            
        }
        
        if (kArrayIsEmpty(self.allmemberSmallView.subviews)) {
            self.allStoreNUmberHieght.constant = 230;
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
            [self.allstoreMemberNumber addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.allstoreMemberNumber);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
        }else{
            self.allStoreNUmberHieght.constant = maxY + 63;
        }
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        if ([self.scrollView.mj_footer isRefreshing]) {
            
            [self.scrollView.mj_footer endRefreshing];
        }
        
        
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}



#pragma mark - 支付构成
- (void)PaymentStructureSType:(NSInteger)type date:(NSString *)date date2:(NSString *)date2 user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetPaymentAmountInfo?key=%@&days=%ld&date_start=%@&date_end=%@&user_id=%@",token,(long)type,date,date2,user_id];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic支付构成 = %@",dic);
        NSMutableArray *dataList = dic[@"values"][@"dataList"];
        
        NSLog(@"dataList = %@",dataList);
        [self.payView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.moneyArrM_3 removeAllObjects];
        [self.colorArrM_3 removeAllObjects];
        [self.colorAndMoneyArray removeAllObjects];
        float money = 0.0;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 3, 13)];
        lineView.backgroundColor = navigationBackgroundColor;
        [self.payView addSubview:lineView];
        
        UILabel *textL = [[UILabel alloc] init];
        [self.payView addSubview:textL];
        UIFont *fnt = [UIFont systemFontOfSize:15];
        textL.textColor= [UIColor colorWithHexString:@"666666"];
        textL.text = @"支付构成";
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
        double Count = 0.0;
        // 添加UIsrollView
       
         UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 53, ScreenW - 20 -170, 140)];
        CGFloat maxY = 0;
       // for (NSDictionary *dict in dataList) {
            for (int i = 0; i < dataList.count; i++) {
                NSDictionary *dict = dataList[i];
            //}
             if (!([dict[@"payment_amount"]doubleValue] <= 0)) {
                 UIColor * randomColor;
                 if (i > self.colorArray.count - 1) {
                    randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                 }else{
                     randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                 }
            
              //   UIColor *color = [UIColor colorWithHexString:@""];
            [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"payment_amount"]doubleValue] color:randomColor]];
            Count += [dict[@"payment_amount"]doubleValue];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW - 20 -170 - 20, 30)];
            // view.backgroundColor = [UIColor yellowColor];
            
            UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
            cicleView.backgroundColor = randomColor;
            [view addSubview:cicleView];
            UILabel *memLabel = [[UILabel alloc] init];
            [view addSubview:memLabel];
            memLabel.text = [NSString stringWithFormat:@"%@   ￥%.2f",dict[@"payment_method"],[dict[@"payment_amount"]doubleValue]];
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
            [self.payView addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.payView);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
        }else{
            [self.payView addSubview:scrollView];
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
            [self.payView addSubview:chart];
            
            
            
            
            //总消费额
            UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 113, 70, 15)];
            V3sumlabel.text = @"总金额";
            V3sumlabel.textAlignment = NSTextAlignmentCenter;
            V3sumlabel.font = [UIFont systemFontOfSize:12];
            V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
            V3sumlabel.adjustsFontSizeToFitWidth = YES;
            V3sumlabel.minimumScaleFactor = 0.5;
            [self.payView  addSubview:V3sumlabel];
            
            
            UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 132, 130, 12)];
            sumtextlabel.text = [NSString stringWithFormat:@"%.2f",[dic[@"values"][@"totalMoney"]doubleValue]];
            sumtextlabel.textAlignment = NSTextAlignmentCenter;
            sumtextlabel.font = [UIFont systemFontOfSize:14];
            sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
            [self.payView  addSubview:sumtextlabel];
        }
        
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        if ([self.scrollView.mj_footer isRefreshing]) {
            
            [self.scrollView.mj_footer endRefreshing];
        }
        
     
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
       // [self.twoTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


// 店铺概况
#pragma mark - 包括门店营业统计
- (void)setShopOverviewType:(NSInteger)type Page:(NSInteger)page top:(NSInteger)top date:(NSString *)date date2:(NSString *)date2 user_id:(NSString *)user_id{
     [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
//    if ([user_id isEqualToString:@"-1"]) {
//        user_id = @"";
//    }
    NSString *dURL=[URLhead stringByAppendingFormat:@"/api/IntelligentAnalysis/GetProductAnalysisByShop?key=%@&user_id=%@&page=%ld&pagesize=%ld&startdate=%@&enddate=%@",token,user_id,(long)page,(long)top,[NSString stringWithFormat:@"%@ 00:00:00",date],[NSString stringWithFormat:@"%@ 23:59:59",date2]];
    NSLog(@"dURL = %@",dURL);
      // NSString *utf = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encoded = [dURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
         [NSCharacterSet URLQueryAllowedCharacterSet];
    [[SVSaviTool sharedSaviTool] GET:encoded parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  Business Sales Label
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"门店营业额统计dic444 = %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            
            if (self.page == 1) {
                [self.dataList removeAllObjects];
                [self.GreaterThanArray removeAllObjects];
            }
            
            NSMutableArray *listArr = dic[@"data"][@"dataList"];
            NSLog(@"listArr = %@",listArr);
            if (![SVTool isEmpty:listArr]) {
                
                for (NSDictionary *values in listArr) {
                    //字典转模型
                    SVShopOverviewModel *model = [SVShopOverviewModel mj_objectWithKeyValues:values];
                    model.selectVC = 1;//是店铺概况
                 //   model.JurisdictionNum = self.JurisdictionNum;
                    //                    [self.modelArr addObject:model];
                    if (kArrayIsEmpty(self.dataList)) {
                        [self.dataList addObject:model];
                    }else{
                        for (SVShopOverviewModel *model2 in self.dataList) {
                            if ([model2.user_id isEqualToString:model.user_id]) {
                                [self.dataList removeObject:model2];
                                break;
                            }

                        }
                        [self.dataList addObject:model];
                    }
                
                    if ([model.order_receivable floatValue] != 0) {
                        if (kArrayIsEmpty(self.GreaterThanArray)) {
                            [self.GreaterThanArray addObject:model];
                        }else{
                            for (SVShopOverviewModel *model3 in self.GreaterThanArray) {
                                if ([model3.user_id isEqualToString:model.user_id]) {
                                    [self.GreaterThanArray removeObject:model3];
                                    break;
                                }
                            }
                            
                            [self.GreaterThanArray addObject:model];
                        }
                        
                    }
                    
                }
                
                float order_receivableOne = 0.0;
                for (SVShopOverviewModel *model in self.GreaterThanArray) {
                    order_receivableOne += [model.order_receivable doubleValue];
                }
                
                self.order_receivable = order_receivableOne;
                
                
                double order_receivable = 0.0;
                double order_pdgfee = 0.0;
                double maolili = 0.0;
                NSInteger count = 0;
                for (SVShopOverviewModel *model in self.dataList) {
                    order_receivable += [model.order_receivable doubleValue] +  [model.order_unreceivable doubleValue];
                    order_pdgfee += [model.order_pdgfee doubleValue];
                    count += [model.orderciunt integerValue];
                    maolili += model.maolili;
                }
                self.businessSalesLabel.text = [NSString stringWithFormat:@"%.2f",order_receivable];
                self.youzhezengLabel.text = [NSString stringWithFormat:@"%.2f",order_pdgfee];
                self.StrokeNumberLabel.text = [NSString stringWithFormat:@"%ld",count];
                
                CGFloat maxY = 0;

                [self.memdianyingyeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i = 0; i < self.dataList.count ; i++) {
                    
                    SVShopOverviewModel *model = self.dataList[i];
                    
                    if ([model.order_receivable floatValue] == 0) {//数据为0时
                        
                    }else{
                        
                        SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
                        rankingsV.namelabel.text = model.sv_us_name;
                        rankingsV.moneylabel.text = [NSString stringWithFormat:@"￥%.2f",model.order_receivable.doubleValue];
                        if (self.order_receivable != 0) {
                            double twoWide = 210 * [model.order_receivable doubleValue] / self.order_receivable;
                            
                            [UIView animateWithDuration:1 animations:^{
                                rankingsV.colorView.width = twoWide;
                            }];
                            rankingsV.colorView.height = 15;
                            rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                            rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                            //  maxY = maxY;
                            maxY = CGRectGetMaxY(rankingsV.frame);
                            [self.memdianyingyeView addSubview:rankingsV];
                        }
                    }
                }
                
                if (kArrayIsEmpty(self.memdianyingyeView.subviews)) {
                    self.memdianyingyeHeight.constant = 230;
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    [self.memdianyingyeView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.memdianyingyeView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                    
                }else{
                    self.memdianyingyeHeight.constant = maxY + 63;
                   
                }
                
                self.threeHeight.constant = 37+ self.dataList.count * 50;
                [self.tableViewNew reloadData];
                
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
              //  self.scrollView.mj_footer.state = MJRefreshStateNoMoreData;
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
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////    if (tableView == self.tableView) {
//////        if (kArrayIsEmpty(self.shopArray)) {
//////             return 7;
//////        }else{
////             return 8;
////       // }
////    }else{
////        return 1;
////    }
//
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.tableViewNew) {
         return self.dataList.count;
    }else{
        return self.shopArray.count;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewNew) {
        SVPayConstituteCell *cell = [tableView dequeueReusableCellWithIdentifier:PayConstituteCellID];
        if (!cell) {
            cell = [[SVPayConstituteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PayConstituteCellID];
        }
        
        cell.model = self.dataList[indexPath.row];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        SVShopSalesRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:ShopSalesRankingCellID];
                    if (!cell) {
                        cell = [[SVShopSalesRankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShopSalesRankingCellID];
                    }
        
                    cell.dict = self.shopArray[indexPath.row];
        //            cell.order_receivable = self.order_receivable;
        //            cell.memberCountArray = self.memberCountArray;
                    cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
                    return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1) {
//        return 300;
//    }else{
//      return 100;
//    }
    NSLog(@"来了%ld次",indexPath.row);
//    if (tableView == self.tableView) {
//        if (indexPath.section == 0) {
//            return 100;
//        }else if (indexPath.section == 1){
//            return self.GreaterThanArray.count *48 + 40;
//        }else if (indexPath.section == 2){
//            return 220;
//        }else if (indexPath.section == 3){
//
//            return 50;
//        }else if (indexPath.section == 4){
//            return 110;
//        }else if (indexPath.section == 5){
//            return 220;
//        }else if (indexPath.section == 6){
//            return self.memberCountArray.count *48 + 40;
//        }
//        else{
//            return 50;
//        }
//    }else{
//        return 30;
//    }
    
    return 50;
}




- (NSMutableArray *)item3_array{
    if (_item3_array == nil) {
        _item3_array = [NSMutableArray array];
    }
    return _item3_array;
}

- (NSMutableArray *)memberCountArray{
    if (_memberCountArray == nil) {
        _memberCountArray = [NSMutableArray array];
    }
    return _memberCountArray;
}



- (NSMutableArray *)colorAndMoneyArray{
    if (_colorAndMoneyArray == nil) {
        _colorAndMoneyArray = [NSMutableArray array];
    }
    return _colorAndMoneyArray;
}

- (NSMutableArray *)colorAndMoneyArray4{
    if (_colorAndMoneyArray4 == nil) {
        _colorAndMoneyArray4 = [NSMutableArray array];
    }
    return _colorAndMoneyArray4;
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


- (NSMutableArray *)colorArrM_4
{
    if (!_colorArrM_4) {
        _colorArrM_4 = [NSMutableArray array];
    }
    
    return _colorArrM_4;
}

- (NSMutableArray *)moneyArrM_4
{
    if (!_moneyArrM_4) {
        _moneyArrM_4 = [NSMutableArray array];
    }
    return _moneyArrM_4;
}


- (SVStoreTopView *)storeTopView
{
    if (!_storeTopView) {
        _storeTopView = [[NSBundle mainBundle]loadNibNamed:@"SVStoreTopView" owner:nil options:nil].lastObject;
        //  _storeTopView.backgroundColor = BackgroundColor;
        _storeTopView.frame = CGRectMake(0, 0, ScreenW, 50);
        _storeTopView.fatherView.hidden = YES;
        _storeTopView.chongzhiView.hidden = YES;
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
   
    



@end
