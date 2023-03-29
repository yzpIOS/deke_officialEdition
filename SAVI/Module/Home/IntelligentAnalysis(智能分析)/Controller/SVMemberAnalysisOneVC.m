//
//  SVMemberAnalysisOneVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVMemberAnalysisOneVC.h"
#import "SVOneStoreCell.h"
#import "SVShopOverviewModel.h"
#import "SVTwoDoBusinessCell.h"
#import "SVStoreLineView.h"
#import "SVIntelligentDetailCell.h"
#import "SVStoreTopView.h"
#import "SVMemberConsumptionCell.h"
#import "SVErectLineView.h"
#import "SVConsumptionFrequencyView.h"

static NSString *const ID = @"UITableViewCell";
static NSString *const OneStoreCellID = @"SVOneStoreCell";
static NSString *const TwoDoBusinessCellID = @"SVTwoDoBusinessCell";
static NSString *const IntelligentDetailCellID = @"SVIntelligentDetailCell";
static NSString *const MemberConsumptionCellID = @"SVMemberConsumptionCell";

//现金
#define colorA  RGBA(226, 134, 207, 1)
//微信
#define colorB  RGBA(130, 131, 214, 1)
//银行卡
#define colorC  RGBA(250, 193, 103, 1)
//储值卡
#define colorD  RGBA(129, 211, 38, 1)
//支付宝
#define colorE  RGBA(141, 228, 51, 1)
//美团
#define colorF  RGBA(182, 232, 241, 1)
//口碑
#define colorG  RGBA(215, 210, 190, 1)
//闪惠
#define colorH  RGBA(178, 178, 170, 1)
//赊账
#define colorI  RGBA(168, 145, 163, 1)

// 美团
#define colorJ  RGBA(34, 195, 188, 1)
// 口碑
#define colorK  RGBA(228, 69, 30, 1)

//字体大小
#define TextFont    14
#define BigFont    15
#define CentreFont  12
#define SmallFont   11

@interface SVMemberAnalysisOneVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
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
@property (nonatomic,assign) float memberRechargeOrder_receivable;
@property (nonatomic,strong) NSString *oneDate;
@property (nonatomic,strong) NSString *twoDate;
@property (nonatomic,strong) NSString *lastdaycount;
@property (nonatomic,strong) NSString *membercount;
@property (nonatomic,strong) NSString *sv_mw_availableamount;
@property (nonatomic,strong) NSDictionary *memberAnalysis;
//lastdaycount = 0;
//membercount = 3968;
//"sv_mw_availableamount" = "23707081.63";

@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UIView *memberConsumptionNumView;


@property (nonatomic,strong) NSMutableArray *colorArrM_3;
@property (nonatomic,strong) NSMutableArray *moneyArrM_3;
@property (nonatomic,strong) NSMutableArray *item3_array;

// 会员消费底部线
@property (weak, nonatomic) IBOutlet UIView *memberBottonView;
@property (weak, nonatomic) IBOutlet UIView *memberSingularBottomView;

@property (weak, nonatomic) IBOutlet UIView *memberMoneyView;
@property (weak, nonatomic) IBOutlet UIView *memberSingularView;
@property (weak, nonatomic) IBOutlet UIView *memberMoneyBigView;
@property (weak, nonatomic) IBOutlet UIView *singularBigView;
//饼图属性
@property (nonatomic, strong) PNPieChart *pieChart;
// 等级
@property (weak, nonatomic) IBOutlet UIView *memberRechargeGradeView;
@property (weak, nonatomic) IBOutlet UIView *memberRechargeNewAndOldView;

@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (weak, nonatomic) IBOutlet UIView *oldAndNewView;
@property (weak, nonatomic) IBOutlet UIView *gradeBottomView;
@property (weak, nonatomic) IBOutlet UIView *oldAndNewBottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberRechargeHeight;

@property (nonatomic,assign) float maxHeight;
@property (nonatomic,assign) float oldAndNewMaxHeight;

// 会员消费的颜色块
@property (weak, nonatomic) IBOutlet UIView *memberMoneycolorView;
@property (weak, nonatomic) IBOutlet UIView *memberMoneyColorViewTwo;
// 单数
@property (weak, nonatomic) IBOutlet UIView *memberSingularColor;
@property (weak, nonatomic) IBOutlet UIView *memberSingularColorTwo;
@property (weak, nonatomic) IBOutlet UILabel *memberMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberMoneyLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *singularLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *singularLabelTwo;

// 会员等级
@property (weak, nonatomic) IBOutlet UIView *historymemberBottomView;
@property (weak, nonatomic) IBOutlet UIView *newaddMemberBottomView;
@property (weak, nonatomic) IBOutlet UIView *historymemberView;

@property (weak, nonatomic) IBOutlet UIView *addNewMemberView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memeberGradeHeight;
@property (weak, nonatomic) IBOutlet UIView *peopleNumView;
@property (weak, nonatomic) IBOutlet UIView *sexMoneyView;
@property (weak, nonatomic) IBOutlet UIView *peopleNumBottomView;
@property (weak, nonatomic) IBOutlet UIView *sexMoneyBottomView;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (weak, nonatomic) IBOutlet UIView *sixView;
@property (weak, nonatomic) IBOutlet UIView *sevenView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *storeMoney;
@property (weak, nonatomic) IBOutlet UILabel *allMember;
@property (weak, nonatomic) IBOutlet UILabel *addMember;
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSDictionary *timeDict;
@property (nonatomic,strong) NSMutableArray *historyMemberArray;
@property (nonatomic,strong) NSMutableArray *addNewMemberArray;
@property (nonatomic,assign) NSInteger selectMemberGlade;
@property (nonatomic,assign) NSInteger selectMemberchongzhi;
@end

@implementation SVMemberAnalysisOneVC

- (SVStoreTopView *)storeTopView
{
    if (!_storeTopView) {
        _storeTopView = [[NSBundle mainBundle]loadNibNamed:@"SVStoreTopView" owner:nil options:nil].lastObject;
        _storeTopView.frame = CGRectMake(0, 0, ScreenW, 50);
        _storeTopView.fatherView.hidden = NO;
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

- (NSMutableArray *)historyMemberArray
{
    if (!_historyMemberArray) {
        _historyMemberArray = [NSMutableArray array];
    }
    return _historyMemberArray;
}

- (NSMutableArray *)addNewMemberArray
{
    if (!_addNewMemberArray) {
        _addNewMemberArray = [NSMutableArray array];
    }
    return _addNewMemberArray;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.memberSingularBottomView.hidden = YES;
    self.selectMemberGlade = 1;// 默认是点击历史会员
    self.selectMemberchongzhi = 1;//默认是等级
    self.moneyArrM_3 = [NSMutableArray arrayWithObjects:@"44",@"323",@"545",@"223", nil];
    self.colorArrM_3 = [NSMutableArray arrayWithObjects:colorA,colorB,colorC,colorD, nil];
    
    self.colorArray = [NSMutableArray arrayWithObjects:@"f79c2c",@"3992f9",@"54e58b",@"fcd866",@"f16093",@"60d1f1",@"d1f160",@"f17460", nil];

    self.user_id = @"";
    self.memberSingularView.hidden = YES;
    // 会员充值
    self.oldAndNewBottomView.hidden = YES;
    self.memberRechargeNewAndOldView.hidden = YES;
    // 新增会员
    self.addNewMemberView.hidden = YES;
    self.newaddMemberBottomView.hidden = YES;
    
    self.sexMoneyView.hidden = YES;
    self.sexMoneyBottomView.hidden = YES;
    
    self.oneView.layer.cornerRadius = 10;
    self.oneView.layer.masksToBounds = YES;
    
    self.twoView.layer.cornerRadius = 10;
    self.twoView.layer.masksToBounds = YES;
    
    self.threeView.layer.cornerRadius = 10;
    self.threeView.layer.masksToBounds = YES;
    
    self.fourView.layer.cornerRadius = 10;
    self.fourView.layer.masksToBounds = YES;
    
    self.fiveView.layer.cornerRadius = 10;
    self.fiveView.layer.masksToBounds = YES;
    
    self.sixView.layer.cornerRadius = 10;
    self.sixView.layer.masksToBounds = YES;
    
    self.sevenView.layer.cornerRadius = 10;
    self.sevenView.layer.masksToBounds = YES;

//    CGFloat maxY = 0;
//    //    if (self.fatherView.subviews.count > 0) {
//    //        [self.fatherView removeFromSuperview];
//    //    }
//    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    for (int i = 0; i < self.dataList.count ; i++) {
//
//        SVShopOverviewModel *model = self.dataList[i];
//
//        if ([model.order_receivable doubleValue] == 0) {//数据为0时
//
//        }else{
//
//            SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
//            rankingsV.namelabel.text = model.sv_us_name;
//            rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",model.order_receivable.doubleValue];
//            if (self.order_receivable != 0) {
//                float twoWide = 210 * [model.order_receivable doubleValue] / self.order_receivable;
//
//                [UIView animateWithDuration:1 animations:^{
//                    rankingsV.colorView.width = twoWide;
//                }];
//                rankingsV.colorView.height = 15;
//                rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
//                rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
//                //  maxY = maxY;
//                maxY = CGRectGetMaxY(rankingsV.frame);
//                [self.fatherView addSubview:rankingsV];
//            }
//        }
//    }
//
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    // 默认是今天
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];// 默认是今天
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification2:) name:@"nitifyName2" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nitifyMemberNameAllStore:) name:@"nitifyMemberNameAllStore" object:nil];
   
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyName2" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nitifyMemberNameAllStore" object:nil];
}
#pragma mark - 店铺筛选
- (void)nitifyMemberNameAllStore:(NSNotification *)noti{
    
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
        }else{
//            self.oneDate = [self.timeDict objectForKey:@"oneDate"];
//            self.twoDate = [self.timeDict objectForKey:@"twoDate"];
            self.oneDate = @"";
            self.twoDate = @"";
            self.page = 1;
            self.type = 3;
            
            [self setUpDataStart:self.oneDate end:self.twoDate user_id:self.user_id];
        }
        
    }
}


#pragma mark - 时间晒选
-(void)notification2:(NSNotification *)noti{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    // 默认是今天
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSDictionary  *dic = [noti userInfo];
    //    // NSString *type = [dic objectForKey:@"type"];
    //    // self.type = type;
    //    self.dic = dic;
    self.timeDict = dic;
    NSString *type = [dic objectForKey:@"type"];
    
    if ([type isEqualToString:@"2"]) {// 本周
        self.type = type.integerValue;
        self.page = 1;
        self.oneDate = @"";
        self.twoDate = @"";
        NSString *weekData = [self currentScopeWeek];
        // [self setUpDataType:1];
        [self setUpDataStart:weekData end:currentTimeString user_id:self.user_id];
        //           [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"1"]){// 是今天
        self.type = type.integerValue;
        
        self.page = 1;
        
        // [self setUpDataType:1];
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }else if ([type isEqualToString:@"-1"]){// 昨天
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        //现在时间,你可以输出来看下是什么格式
        
        // NSDate *datenow = [NSDate date];
        
        NSDate *date = [NSDate date];//当前时间
        
        NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
        
        NSString *currentTimeString = [formatter stringFromDate:lastDay];
        
       self.type = type.integerValue;
        self.page = 1;
        // self.timeLabel.text = @"昨天";
        self.oneDate = @"";
        self.twoDate = @"";
        // self.page = 1;
        //  self.page = 1;
        
        //  [self setUpDataType:1];
        [self setUpDataStart:currentTimeString end:currentTimeString user_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
        
    }else{
        self.type = type.integerValue;
        self.page = 1;
        self.oneDate = [dic objectForKey:@"oneDate"];
        self.twoDate = [dic objectForKey:@"twoDate"];
        // self.page = 1;
        
        // [self setUpDataType:1];
        [self setUpDataStart:self.oneDate end:self.twoDate user_id:self.user_id];
        //            [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
        
    }
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
  //  NSString *lastDay = [formatter stringFromDate:lastDate];
    
    return firstDay;
}


- (void)setUpDataStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    
    //提示加载中
  [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    self.page = 1;

    [self GetMemberAnalysisStart:start end:end user_id:user_id];
    
    [self GetMemberTopUpAnalysisStart:start end:end user_id:user_id];
    [self GetMemberSalesAnalysisStart:start end:end user_id:user_id];
    
    [self MemberLevelAnalysisStart:start end:end user_id:user_id];
    
    [self memberSaleCountInfoStart:start end:end user_id:user_id];// 会员消费次数分布
    
    [self GetMemberSalesAnalysisByNickStart:start end:end user_id:user_id];
    
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        [self GetMemberAnalysisStart:start end:end user_id:user_id];
        
        [self GetMemberTopUpAnalysisStart:start end:end user_id:user_id];
        [self GetMemberSalesAnalysisStart:start end:end user_id:user_id];
        
        [self MemberLevelAnalysisStart:start end:end user_id:user_id];
        
        [self memberSaleCountInfoStart:start end:end user_id:user_id];// 会员消费次数分布
        
        [self GetMemberSalesAnalysisByNickStart:start end:end user_id:user_id];
        
        //隐藏提示框
       // [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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


- (IBAction)peoplenumClick:(id)sender {
    self.sexMoneyBottomView.hidden = YES;
    self.sexMoneyView.hidden = YES;
    
    self.peopleNumView.hidden = NO;
    self.peopleNumBottomView.hidden = NO;
}

- (IBAction)sexmoneyClick:(id)sender {
    
    self.sexMoneyBottomView.hidden = NO;
    self.sexMoneyView.hidden = NO;
    
    self.peopleNumView.hidden = YES;
    self.peopleNumBottomView.hidden = YES;
}

#pragma mark - 会员消费金额点击
- (IBAction)memberConsumptionMoneyClick:(id)sender {
    self.memberSingularView.hidden = YES;
    // self.consumeBigView.hidden = YES;
    self.memberSingularBottomView.hidden = YES;
    
    self.memberBottonView.hidden = NO;
    self.memberMoneyBigView.hidden = NO;
    self.memberMoneyView.hidden = NO;
}
#pragma mark - 会员单数消费
- (IBAction)memberSingularClick:(id)sender {
    self.memberSingularView.hidden = NO;
   // self.consumeBigView.hidden = NO;
    self.memberSingularBottomView.hidden = NO;
    
    self.memberBottonView.hidden = YES;
    //self.memberBigView.hidden = YES;
    self.memberMoneyView.hidden = YES;
}
// 等级
- (IBAction)gradeBtnClick:(id)sender {
    self.selectMemberchongzhi = 1;
    self.memberRechargeNewAndOldView.hidden = YES;
    // self.consumeBigView.hidden = YES;
    self.oldAndNewBottomView.hidden = YES;
    
    self.memberRechargeGradeView.hidden = NO;
    self.gradeBottomView.hidden = NO;
    self.gradeView.hidden = NO;
    
    self.memberRechargeHeight.constant = 88 + self.maxHeight + 20;
}
// 新旧会员
- (IBAction)oldAndNewClick:(id)sender {
    self.selectMemberchongzhi = 2;
    self.oldAndNewBottomView.hidden = NO;
    // self.consumeBigView.hidden = NO;
    self.memberRechargeNewAndOldView.hidden = NO;
    
    self.gradeBottomView.hidden = YES;
    //self.memberBigView.hidden = YES;
    self.memberRechargeGradeView.hidden = YES;
    
    self.memberRechargeHeight.constant = 88 + 48*2 + 20;
}

#pragma mark - 会员等级两个按钮
// 历史会员
- (IBAction)historyBtnClick:(id)sender {
    self.selectMemberGlade = 1;
    self.addNewMemberView.hidden = YES;
    self.newaddMemberBottomView.hidden = YES;
    
    self.historymemberView.hidden = NO;
    self.historymemberBottomView.hidden = NO;
    
    self.memeberGradeHeight.constant = 290 + self.historyMemberArray.count * 60;
}
// 新增会员
- (IBAction)addNewMemberClick:(id)sender {
    self.selectMemberGlade = 2;
    self.addNewMemberView.hidden = NO;
    self.newaddMemberBottomView.hidden = NO;
    
    self.historymemberView.hidden = YES;
    self.historymemberBottomView.hidden = YES;
    
    self.memeberGradeHeight.constant = 290 + self.addNewMemberArray.count * 60;
}
#pragma mark - 性别比例
- (void)GetMemberSalesAnalysisByNickStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetMemberSalesAnalysisByNick?key=%@&start=%@&end=%@&user_id=%@",token,start,end,user_id];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic性别比例 = %@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
            
             [self.peopleNumView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
             [self.sexMoneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            NSDictionary *dicValues = dic[@"values"];
            
            NSMutableArray *item_Array  = [NSMutableArray array];
            NSMutableArray *item_ArrayTwo  = [NSMutableArray array];
            NSArray *bynicklist=dicValues[@"bynicklist"];
            if (kArrayIsEmpty(bynicklist)) {
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
//                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.peopleNumView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.peopleNumView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];

            }else{
                float Count = 0.0;
                
                // 添加UIsrollView
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
                [self.peopleNumView addSubview:scrollView];
                scrollView.delegate = self;
                scrollView.contentSize = CGSizeMake(0, bynicklist.count *30);
                CGFloat maxY = 0;
                for (int i = 0; i < bynicklist.count; i++) {
                    NSDictionary *dict = bynicklist[i];
                    // }
                  //  if ([dict[@"count"]doubleValue] > 0) {
                    UIColor * randomColor;
                    if (i > self.colorArray.count - 1) {
                        randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                    }else{
                        randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                    }
                    [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"count"]doubleValue] color:randomColor]];
                    Count += [dict[@"count"]doubleValue];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW - 20 -170 - 20, 30)];
                    // view.backgroundColor = [UIColor yellowColor];
                    
                    UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                    cicleView.backgroundColor = randomColor;
                    [view addSubview:cicleView];
                    UILabel *memLabel = [[UILabel alloc] init];
                    [view addSubview:memLabel];
                    memLabel.text = [NSString stringWithFormat:@"%@   %.f个",dict[@"sv_mr_nick"],[dict[@"count"]doubleValue]];
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
                
              //  }
                
                // 历史会员圈圈
                PNPieChart *chart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_Array];
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
                [self.peopleNumView addSubview:chart];
                
                //总消费额
                UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                V3sumlabel.text = @"会员人数";
                V3sumlabel.textAlignment = NSTextAlignmentCenter;
                V3sumlabel.font = [UIFont systemFontOfSize:12];
                V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
                V3sumlabel.adjustsFontSizeToFitWidth = YES;
                V3sumlabel.minimumScaleFactor = 0.5;
                [self.peopleNumView  addSubview:V3sumlabel];
                
                
                UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
                sumtextlabel.text = [NSString stringWithFormat:@"%.0f",Count];
                sumtextlabel.textAlignment = NSTextAlignmentCenter;
                sumtextlabel.font = [UIFont systemFontOfSize:14];
                sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
                [self.peopleNumView  addSubview:sumtextlabel];
            }
                
                
            NSArray *bymoneylist = dicValues[@"bymoneylist"];
            
            if (kArrayIsEmpty(bymoneylist)) {
                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.sexMoneyView addSubview:img_two];
                [img_two mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.sexMoneyView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
            }else{
                
                // 第二个
                
                UIScrollView *scrollViewTwo = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
                [self.sexMoneyView addSubview:scrollViewTwo];
                scrollViewTwo.delegate = self;
                scrollViewTwo.contentSize = CGSizeMake(0, bymoneylist.count *30);
                CGFloat maxYTwo = 0;
                double sexMoneyCount = 0;

                for (int i = 0; i < bymoneylist.count; i++) {
                    NSDictionary *dict = bymoneylist[i];
                    // }
                    //  if (!([dict[@"count"]doubleValue] <= 0)) {
                    UIColor * randomColor;
                    if (i > self.colorArray.count - 1) {
                        randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                    }else{
                        randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                    }
                    
                    [item_ArrayTwo addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"order_receivable"]doubleValue] color:randomColor]];
                    sexMoneyCount += [dict[@"order_receivable"]doubleValue];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxYTwo, ScreenW - 20 -170 - 20, 30)];
                    // view.backgroundColor = [UIColor yellowColor];
                    
                    UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                    cicleView.backgroundColor = randomColor;
                    [view addSubview:cicleView];
                    UILabel *memLabel = [[UILabel alloc] init];
                    [view addSubview:memLabel];
                    memLabel.text = [NSString stringWithFormat:@"%@   ￥%.2f",dict[@"sv_mr_nick"],[dict[@"order_receivable"]doubleValue]];
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
                    
                    
                    maxYTwo = CGRectGetMaxY(view.frame);
                    // cicleView.centerY = view.centerY;
                    [scrollViewTwo addSubview:view];
                    
                }
                
                
                // 第二个圈圈
                PNPieChart *addChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_ArrayTwo];
                addChart.descriptionTextColor = [UIColor whiteColor];
                addChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                addChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
                addChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
                addChart.showOnlyValues = YES; // 只显示数值不显示内容描述
                
                addChart.innerCircleRadius = 0;
                
                
                [addChart strokeChart];
                
                //设置标注
                addChart.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
                addChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
                [self.sexMoneyView addSubview:addChart];
                
                //总消费额
                //总消费额
                UILabel*V3sumlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                V3sumlabelTwo.text = @"会员金额";
                V3sumlabelTwo.textAlignment = NSTextAlignmentCenter;
                V3sumlabelTwo.font = [UIFont systemFontOfSize:12];
                V3sumlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
                V3sumlabelTwo.adjustsFontSizeToFitWidth = YES;
                V3sumlabelTwo.minimumScaleFactor = 0.5;
                [self.sexMoneyView addSubview:V3sumlabelTwo];
                
                UILabel *sumtextlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
                sumtextlabelTwo.text = [NSString stringWithFormat:@"%.2f",sexMoneyCount];
                sumtextlabelTwo.textAlignment = NSTextAlignmentCenter;
                sumtextlabelTwo.font = [UIFont systemFontOfSize:14];
                sumtextlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
                [self.sexMoneyView addSubview:sumtextlabelTwo];
            }
         
         
            
            
        }
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
//        // 添加UIsrollView
//        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
//        [self.historymemberView addSubview:scrollView];
//        scrollView.delegate = self;
//        scrollView.contentSize = CGSizeMake(0, byoldmemberlist.count *30);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 会员等级分析
- (void)MemberLevelAnalysisStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetMemberRegLevelAnalysis?key=%@&start=%@&end=%@&user_id=%@",token,start,end,user_id];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic会员等级分析 = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
             [self.historymemberView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
           // [self.historymemberView.subviews mas]
             [self.addNewMemberView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.historyMemberArray removeAllObjects];
            [self.addNewMemberArray removeAllObjects];
            NSDictionary *dicValues = dic[@"values"];
            NSMutableArray *item_Array  = [NSMutableArray array];
            NSMutableArray *item_ArrayTwo  = [NSMutableArray array];
            NSArray *bynewmemberlist=dicValues[@"bynewmemberlist"];
            NSArray *byoldmemberlist = dicValues[@"byoldmemberlist"];
            
            if (kArrayIsEmpty(byoldmemberlist)) {
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.historymemberView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.historymemberView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
            }else{
                // 添加UIsrollView
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
                [self.historymemberView addSubview:scrollView];
                scrollView.delegate = self;
               
                double oldCount = 0.0;
                CGFloat maxY = 0;
                CGFloat maxViewY = 190;
               // for (NSDictionary *dict in byoldmemberlist) {
                NSMutableArray *dictArray = [NSMutableArray array];
                    for (int i = 0; i < byoldmemberlist.count; i++) {
                        NSDictionary *dict = byoldmemberlist[i];
                        if ([dict[@"count"]doubleValue] > 0) {
                            UIColor * randomColor;
                            if (i > self.colorArray.count - 1) {
                                randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                            }else{
                                randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                            }
                            
                            
                            [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"count"]doubleValue] color:randomColor]];
                            
                            [self.historyMemberArray addObject:dict];
                            oldCount += [dict[@"count"]doubleValue];
                            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW - 20 -170 - 20, 30)];
                            // view.backgroundColor = [UIColor yellowColor];
                            
                            UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                            cicleView.backgroundColor = randomColor;
                            [view addSubview:cicleView];
                            UILabel *memLabel = [[UILabel alloc] init];
                            [view addSubview:memLabel];
                            memLabel.text = [NSString stringWithFormat:@"%@   %.f人",dict[@"sv_ml_name"],[dict[@"count"]doubleValue]];
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
                            
                            UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, maxViewY, self.historymemberView.width -10, 60)];
                            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, detailView.width, 1)];
                            lineView.backgroundColor = BackgroundColor;
                            [detailView addSubview:lineView];
                            [self.historymemberView addSubview:detailView];
                            
                            //文字
                            UILabel *nameLabel = [[UILabel alloc] init];
                            nameLabel.text = dict[@"sv_ml_name"];
                            nameLabel.textColor= [UIColor colorWithHexString:@"666666"];
                            nameLabel.font = fnt;
                            // 根据字体得到NSString的尺寸
                            CGSize nameSize = [nameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                            // 名字的H
                            CGFloat nameHT = nameSize.height;
                            // 名字的W
                            CGFloat nameWT = nameSize.width;
                            nameLabel.frame = CGRectMake(0,10, nameWT,nameHT);
                            [detailView addSubview:nameLabel];
                            
                            // 折扣等详情
                            UILabel *detalnameLabel = [[UILabel alloc] init];
                            detalnameLabel.text = [NSString stringWithFormat:@"折扣：%.2f折  积分：%@-%@",[dict[@"sv_ml_commondiscount"] doubleValue],dict[@"sv_ml_initpoint"],dict[@"sv_ml_endpoint"]];
                            detalnameLabel.textColor= [UIColor colorWithHexString:@"666666"];
                            detalnameLabel.font = fnt;
                            // 根据字体得到NSString的尺寸
                            CGSize detalnameSize = [detalnameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                            // 名字的H
                            CGFloat detalnameHT = detalnameSize.height;
                            // 名字的W
                            CGFloat detalnameWT = detalnameSize.width;
                            detalnameLabel.frame = CGRectMake(0,CGRectGetMaxY(nameLabel.frame) + 10, detalnameWT,detalnameHT);
                            [detailView addSubview:detalnameLabel];
                            
                            
                            // 右边活跃度
                            UILabel *activenameLabel = [[UILabel alloc] init];
                            activenameLabel.text = [NSString stringWithFormat:@"%@人    %.2f 活跃度",dict[@"count"], [dict[@"ratio"]doubleValue]];
                            activenameLabel.textColor= [UIColor colorWithHexString:@"666666"];
                            activenameLabel.font = fnt;
                            // 根据字体得到NSString的尺寸
                            CGSize activenameSize = [activenameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                            // 名字的H
                            CGFloat activedetalnameHT = activenameSize.height;
                            // 名字的W
                            CGFloat activedetalnameWT = activenameSize.width;
                            activenameLabel.frame = CGRectMake(detailView.width -10 - activedetalnameWT,20, activedetalnameWT,activedetalnameHT);
                            
                            [detailView addSubview:activenameLabel];
                            
                            maxViewY = CGRectGetMaxY(detailView.frame);
                            
                            // activenameLabel.centerY = detailView.centerY;
                        }
                        
                    }
                
                self.memeberGradeHeight.constant = 290 + self.historyMemberArray.count * 60;
                 scrollView.contentSize = CGSizeMake(0, self.historyMemberArray.count *30);
                // 历史会员圈圈
                PNPieChart *chart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_Array];
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
                [self.historymemberView addSubview:chart];
                
                
                
                
                //总消费额
                UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                V3sumlabel.text = @"会员人数";
                V3sumlabel.textAlignment = NSTextAlignmentCenter;
                V3sumlabel.font = [UIFont systemFontOfSize:12];
                V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
                V3sumlabel.adjustsFontSizeToFitWidth = YES;
                V3sumlabel.minimumScaleFactor = 0.5;
                [self.historymemberView  addSubview:V3sumlabel];
                
                
                UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
                sumtextlabel.text = [NSString stringWithFormat:@"%.0f",oldCount];
                sumtextlabel.textAlignment = NSTextAlignmentCenter;
                sumtextlabel.font = [UIFont systemFontOfSize:14];
                sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
                [self.historymemberView  addSubview:sumtextlabel];
                
                }
                        
            
            
            if (kArrayIsEmpty(bynewmemberlist)) {
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.addNewMemberView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.addNewMemberView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
            }else{
                
                // 添加UIsrollView
                UIScrollView *scrollViewTwo = [[UIScrollView alloc] initWithFrame:CGRectMake(170, 10, ScreenW - 20 -170, 140)];
                [self.addNewMemberView addSubview:scrollViewTwo];
                scrollViewTwo.delegate = self;
              //  scrollViewTwo.contentSize = CGSizeMake(0, bynewmemberlist.count *30);
                float newCount = 0.0;
                float maYTwo = 0.0;
                CGFloat newMaxViewY = 190;
//                for (NSDictionary *dict in bynewmemberlist) {
//                    UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                
                for (int i = 0; i < bynewmemberlist.count; i++) {
                    NSDictionary *dict = bynewmemberlist[i];
                    // }
                    if ([dict[@"count"]doubleValue] > 0) {
                    UIColor * randomColor;
                    if (i > self.colorArray.count - 1) {
                        randomColor = [UIColor colorWithRed:((float)arc4random_uniform(100) / 150.0) green:((float)arc4random_uniform(100) / 150.0) blue:((float)arc4random_uniform(100) / 150.0) alpha:1.0];
                    }else{
                        randomColor = [UIColor colorWithHexString:self.colorArray[i]];
                    }
                    
                    [item_ArrayTwo addObject:[PNPieChartDataItem dataItemWithValue:[dict[@"count"]doubleValue] color:randomColor]];
                    newCount += [dict[@"count"]doubleValue];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maYTwo, ScreenW - 20 -170 - 20, 30)];
                    // view.backgroundColor = [UIColor yellowColor];
                        [self.addNewMemberArray addObject:dict];
                    UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 10)];
                    cicleView.backgroundColor = randomColor;
                    [view addSubview:cicleView];
                    UILabel *memLabel = [[UILabel alloc] init];
                    [view addSubview:memLabel];
                    memLabel.text = [NSString stringWithFormat:@"%@   %.f人",dict[@"sv_ml_name"],[dict[@"count"]doubleValue]];
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
                    
                    
                    maYTwo = CGRectGetMaxY(view.frame);
                    // cicleView.centerY = view.centerY;
                    [scrollViewTwo addSubview:view];
                    
                    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, newMaxViewY, self.addNewMemberView.width -10, 60)];
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, detailView.width, 1)];
                    lineView.backgroundColor = BackgroundColor;
                    [detailView addSubview:lineView];
                    [self.addNewMemberView addSubview:detailView];
                    
                    //文字
                    UILabel *nameLabel = [[UILabel alloc] init];
                    nameLabel.text = dict[@"sv_ml_name"];
                    nameLabel.textColor= [UIColor colorWithHexString:@"666666"];
                    nameLabel.font = fnt;
                    // 根据字体得到NSString的尺寸
                    CGSize nameSize = [nameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                    // 名字的H
                    CGFloat nameHT = nameSize.height;
                    // 名字的W
                    CGFloat nameWT = nameSize.width;
                    nameLabel.frame = CGRectMake(0,10, nameWT,nameHT);
                    [detailView addSubview:nameLabel];
                    
                    // 折扣等详情
                    UILabel *detalnameLabel = [[UILabel alloc] init];
                    detalnameLabel.text = [NSString stringWithFormat:@"折扣：%.2f折  积分：%@-%@",[dict[@"sv_ml_commondiscount"]doubleValue],dict[@"sv_ml_initpoint"],dict[@"sv_ml_endpoint"]];
                    detalnameLabel.textColor= [UIColor colorWithHexString:@"666666"];
                    detalnameLabel.font = fnt;
                    // 根据字体得到NSString的尺寸
                    CGSize detalnameSize = [detalnameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                    // 名字的H
                    CGFloat detalnameHT = detalnameSize.height;
                    // 名字的W
                    CGFloat detalnameWT = detalnameSize.width;
                    detalnameLabel.frame = CGRectMake(0,CGRectGetMaxY(nameLabel.frame) + 10, detalnameWT,detalnameHT);
                    [detailView addSubview:detalnameLabel];
                    
                    
                    // 右边活跃度
                    UILabel *activenameLabel = [[UILabel alloc] init];
                    activenameLabel.text = [NSString stringWithFormat:@"%@人    %.2f 活跃度",dict[@"count"], [dict[@"ratio"]doubleValue]];
                    activenameLabel.textColor= [UIColor colorWithHexString:@"666666"];
                    activenameLabel.font = fnt;
                    // 根据字体得到NSString的尺寸
                    CGSize activenameSize = [activenameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                    // 名字的H
                    CGFloat activedetalnameHT = activenameSize.height;
                    // 名字的W
                    CGFloat activedetalnameWT = activenameSize.width;
                    activenameLabel.frame = CGRectMake(detailView.width -10 - activedetalnameWT,20, activedetalnameWT,activedetalnameHT);
                    
                    [detailView addSubview:activenameLabel];
                    
                    newMaxViewY = CGRectGetMaxY(detailView.frame);
                }
 
            }
              // self.memeberGradeHeight.constant = 290 + self.addNewMemberArray.count * 60;
                 scrollViewTwo.contentSize = CGSizeMake(0, self.addNewMemberArray.count *30);
                if (kArrayIsEmpty(self.addNewMemberArray)) {
                    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    
                    //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                    
                    [self.addNewMemberView addSubview:img];
                    [img mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(self.historymemberView);
                        make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                    }];
                }else{
                    // 新增会员圈圈
                    PNPieChart *addChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_ArrayTwo];
                    addChart.descriptionTextColor = [UIColor whiteColor];
                    addChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                    addChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
                    addChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
                    addChart.showOnlyValues = YES; // 只显示数值不显示内容描述
                    
                    addChart.innerCircleRadius = 0;
                    
                    
                    [addChart strokeChart];
                    
                    //设置标注
                    addChart.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
                    addChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
                    [self.addNewMemberView addSubview:addChart];
                    
                    //总消费额
                    //总消费额
                    UILabel*V3sumlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                    V3sumlabelTwo.text = @"会员人数";
                    V3sumlabelTwo.textAlignment = NSTextAlignmentCenter;
                    V3sumlabelTwo.font = [UIFont systemFontOfSize:12];
                    V3sumlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
                    V3sumlabelTwo.adjustsFontSizeToFitWidth = YES;
                    V3sumlabelTwo.minimumScaleFactor = 0.5;
                    [self.addNewMemberView addSubview:V3sumlabelTwo];
                    
                    UILabel *sumtextlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
                    sumtextlabelTwo.text = [NSString stringWithFormat:@"%.0f",newCount];
                    sumtextlabelTwo.textAlignment = NSTextAlignmentCenter;
                    sumtextlabelTwo.font = [UIFont systemFontOfSize:14];
                    sumtextlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
                    [self.addNewMemberView addSubview:sumtextlabelTwo];
                    
                }
               
            }
     
         
            if (self.selectMemberGlade == 1) {
                 self.memeberGradeHeight.constant = 290 + self.historyMemberArray.count * 60;
            }else{
                 self.memeberGradeHeight.constant = 290 + self.addNewMemberArray.count * 60;
            }
            

        }
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
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
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic会员消费 = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            [self.memberMoneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            // [self.historymemberView.subviews mas]
            [self.memberSingularView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            //        [self.peopleNumView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //        [self.sexMoneyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            NSDictionary *dicValue = [NSDictionary dictionary];
            dicValue = dic[@"values"];
            NSMutableArray *item_Array  = [NSMutableArray array];
            if (!([dicValue[@"newmember_count"]doubleValue] <= 0)) {
                [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[dicValue[@"newmember_count"]doubleValue] color:[UIColor colorWithHexString:@"f79c2c"]]];
            }
            
            if (!([dicValue[@"oldmember_count"]doubleValue] <= 0)) {
                 [item_Array addObject:[PNPieChartDataItem dataItemWithValue:[dicValue[@"oldmember_count"]doubleValue] color:[UIColor colorWithHexString:@"3992f9"]]];
            }
            
            if (kArrayIsEmpty(item_Array)) {
                
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.memberMoneyView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.memberMoneyView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
                
            }else{
                self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_Array];
                self.pieChart.descriptionTextColor = [UIColor whiteColor];
                self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
                self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
                self.pieChart.showOnlyValues = YES; // 只显示数值不显示内容描述
                
                self.pieChart.innerCircleRadius = 0;
                
                
                [self.pieChart strokeChart];
                
                //设置标注
                self.pieChart.legendStyle = PNLegendItemStyleStacked;//标注摆放样式
                self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
                
                [self.memberMoneyView addSubview:self.pieChart];
                
                self.memberMoneycolorView.backgroundColor = [UIColor colorWithHexString:@"f79c2c"];
                self.memberMoneyColorViewTwo.backgroundColor = [UIColor colorWithHexString:@"3992f9"];
                
                UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(170, 10, 10, 10)];
                cicleView.backgroundColor = [UIColor colorWithHexString:@"f79c2c"];
                [self.memberMoneyView addSubview:cicleView];
                UILabel *memLabel = [[UILabel alloc] init];
                [self.memberMoneyView addSubview:memLabel];
                memLabel.text = [NSString stringWithFormat:@"新增会员 %@人 %.2f元",dicValue[@"newmember_count"],[dicValue[@"newmember_order_receivable"]doubleValue]];
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
                
                UIView *cicleView2 = [[UIView alloc] initWithFrame:CGRectMake(170, CGRectGetMaxY(memLabel.frame) + 5, 10, 10)];
                cicleView2.backgroundColor = [UIColor colorWithHexString:@"3992f9"];
                [self.memberMoneyView addSubview:cicleView2];
                UILabel *memLabel2 = [[UILabel alloc] init];
                [self.memberMoneyView addSubview:memLabel2];
                memLabel2.text = [NSString stringWithFormat:@"历史会员 %@人 %.2f元",dicValue[@"oldmember_count"],[dicValue[@"oldmember_order_receivable"]doubleValue]];
                
                memLabel2.textColor= [UIColor colorWithHexString:@"666666"];
                memLabel2.font = fnt;
                // 根据字体得到NSString的尺寸
                CGSize size2 = [memLabel2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                // 名字的H
                CGFloat nameH2 = size2.height;
                // 名字的W
                CGFloat nameW2 = size2.width;
                memLabel2.frame = CGRectMake(CGRectGetMaxX(cicleView2.frame) + 5,0, nameW2,nameH2);
                memLabel2.centerY = cicleView2.centerY;
                
//                maxY = CGRectGetMaxY(view.frame);
//                // cicleView.centerY = view.centerY;
//                [scrollView addSubview:view];
                
                
//                self.memberMoneyLabel.text = [NSString stringWithFormat:@"新增会员 %@人  %.2f%@  %@元",dicValue[@"newmember_count"],[dicValue[@"newmember_order_receivable_ratio"] doubleValue] *100,@"%",dicValue[@"newmember_order_receivable"]];
//                //  @property (weak, nonatomic) IBOutlet UILabel *memberMoneyLabelTwo;
//                self.memberMoneyLabelTwo.text = [NSString stringWithFormat:@"历史会员 %@人  %.2f%@  %@元",dicValue[@"oldmember_count"],[dicValue[@"oldmember_order_receivable_ratio"] doubleValue] *100,@"%",dicValue[@"oldmember_order_receivable"]];
                
                memLabel.adjustsFontSizeToFitWidth = YES;
                memLabel.minimumScaleFactor = 0.5;
                
                memLabel2.adjustsFontSizeToFitWidth = YES;
                memLabel2.minimumScaleFactor = 0.5;
                
                //总消费额
                UILabel*V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                V3sumlabel.text = @"会员人数";
                V3sumlabel.textAlignment = NSTextAlignmentCenter;
                V3sumlabel.font = [UIFont systemFontOfSize:12];
                V3sumlabel.textColor = [UIColor colorWithHexString:@"666666"];
                V3sumlabel.adjustsFontSizeToFitWidth = YES;
                V3sumlabel.minimumScaleFactor = 0.5;
                [self.memberMoneyView  addSubview:V3sumlabel];
                
                
                UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
                sumtextlabel.text = [NSString stringWithFormat:@"%.0f",[dicValue[@"member_count"] doubleValue]];
                sumtextlabel.textAlignment = NSTextAlignmentCenter;
                sumtextlabel.font = [UIFont systemFontOfSize:14];
                sumtextlabel.textColor = [UIColor colorWithHexString:@"666666"];
                [self.memberMoneyView  addSubview:sumtextlabel];
            }
            
        
            
            // 单数
            //        NSDictionary *dicValue = [NSDictionary dictionary];
            //        dicValue = dic[@"values"];
             NSMutableArray *item_ArrayTwo  = [NSMutableArray array];
            if (!([dicValue[@"newmember_ordercount"]doubleValue] <= 0)) {
                [item_ArrayTwo addObject:[PNPieChartDataItem dataItemWithValue:[dicValue[@"newmember_ordercount"]doubleValue] color:colorC]];
            }
            
            if (!([dicValue[@"oldmember_ordercount"]doubleValue] <= 0)) {
                [item_ArrayTwo addObject:[PNPieChartDataItem dataItemWithValue:[dicValue[@"oldmember_ordercount"]doubleValue] color:colorD]];
            }
            
            if (kArrayIsEmpty(item_ArrayTwo)) {
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
                
                [self.memberSingularView addSubview:img];
                [img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(self.memberSingularView);
                    make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
                }];
            }else{
                // 会员消费第二个圈圈
                PNPieChart *chart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 10, 150, 150) items:item_ArrayTwo];
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
                [self.memberSingularView addSubview:chart];
                
//                self.memberSingularColor.backgroundColor = colorC;
//                self.memberSingularColorTwo.backgroundColor = colorD;
//                self.singularLabelOne.text = [NSString stringWithFormat:@"新增笔数 %@笔  %.2f%@  ",dicValue[@"newmember_ordercount"],[dicValue[@"newmember_ordercount_ratio"] doubleValue] *100,@"%"];
//                //  @property (weak, nonatomic) IBOutlet UILabel *memberMoneyLabelTwo;
//                self.singularLabelTwo.text = [NSString stringWithFormat:@"历史笔数 %@笔  %.2f%@  ",dicValue[@"oldmember_ordercount"],[dicValue[@"oldmember_ordercount_ratio"] doubleValue] *100,@"%"];
                
                UIView *cicleView = [[UIView alloc] initWithFrame:CGRectMake(170, 10, 10, 10)];
                cicleView.backgroundColor = colorC;
                [self.memberSingularView addSubview:cicleView];
                UILabel *memLabel = [[UILabel alloc] init];
                [self.memberSingularView addSubview:memLabel];
                memLabel.text = [NSString stringWithFormat:@"新增笔数 %@笔 %.0f%@  ",dicValue[@"newmember_ordercount"],[dicValue[@"newmember_ordercount_ratio"] doubleValue] *100,@"%"];
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
                
                UIView *cicleView2 = [[UIView alloc] initWithFrame:CGRectMake(170, CGRectGetMaxY(memLabel.frame) + 5, 10, 10)];
                cicleView2.backgroundColor = colorD;
                [self.memberSingularView addSubview:cicleView2];
                UILabel *memLabel2 = [[UILabel alloc] init];
                [self.memberSingularView addSubview:memLabel2];
                memLabel2.text = [NSString stringWithFormat:@"历史笔数 %@笔 %.0f%@  ",dicValue[@"oldmember_ordercount"],[dicValue[@"oldmember_ordercount_ratio"] doubleValue] *100,@"%"];
                
                memLabel2.textColor= [UIColor colorWithHexString:@"666666"];
                memLabel2.font = fnt;
                // 根据字体得到NSString的尺寸
                CGSize size2 = [memLabel2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                // 名字的H
                CGFloat nameH2 = size2.height;
                // 名字的W
                CGFloat nameW2 = size2.width;
                memLabel2.frame = CGRectMake(CGRectGetMaxX(cicleView2.frame) + 5,0, nameW2,nameH2);
                memLabel2.centerY = cicleView2.centerY;
                
                memLabel.adjustsFontSizeToFitWidth = YES;
               memLabel.minimumScaleFactor = 0.5;
                
                memLabel2.adjustsFontSizeToFitWidth = YES;
                memLabel2.minimumScaleFactor = 0.5;
                
                // 第二个圈圈   newmember_ordercount
                //总消费额
                UILabel*V3sumlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(40, 70, 70, 15)];
                V3sumlabelTwo.text = @"消费单数";
                V3sumlabelTwo.textAlignment = NSTextAlignmentCenter;
                V3sumlabelTwo.font = [UIFont systemFontOfSize:12];
                V3sumlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
                V3sumlabelTwo.adjustsFontSizeToFitWidth = YES;
                V3sumlabelTwo.minimumScaleFactor = 0.5;
                [self.memberSingularView addSubview:V3sumlabelTwo];
                
                UILabel *sumtextlabelTwo = [[UILabel alloc]initWithFrame:CGRectMake(10, 87, 130, 12)];
                sumtextlabelTwo.text = [NSString stringWithFormat:@"%.0f",[dicValue[@"newmember_ordercount"]doubleValue] + [dicValue[@"oldmember_ordercount"]doubleValue]];
                sumtextlabelTwo.textAlignment = NSTextAlignmentCenter;
                sumtextlabelTwo.font = [UIFont systemFontOfSize:14];
                sumtextlabelTwo.textColor = [UIColor colorWithHexString:@"666666"];
                [self.memberSingularView addSubview:sumtextlabelTwo];
            }
           
            
         

        }
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 会员充值
- (void)GetMemberTopUpAnalysisStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetMemberTopUpAnalysis?key=%@&start=%@&end=%@&user_id=%@",token,start,end,user_id];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic会员充值 = %@",dic);
        NSDictionary *dict = dic[@"values"];
        NSArray *bylevellist = dict[@"bylevellist"];
        NSMutableArray *newAndOldArray = [NSMutableArray array];
        [newAndOldArray addObject:dict[@"bynewreg"]];
        [newAndOldArray addObject:[NSString stringWithFormat:@"%.2f",[dict[@"byoldreg"] doubleValue]]];
        
        float allOldNewStr = [dict[@"bynewreg"]doubleValue] + [dict[@"byoldreg"] doubleValue];
        float order_receivable= 0.0;
        for (NSDictionary *dict in bylevellist) {
            order_receivable += [dict[@"money"] doubleValue];
        }
        //self.order_receivable = order_receivable;
        
        CGFloat maxY = 0;
       
        CGFloat maxHeight = 0;
        [self.memberRechargeGradeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i = 0; i < bylevellist.count ; i++) {
            
            NSDictionary *dictLeval = bylevellist[i];
            
            if ([dictLeval[@"money"] doubleValue] == 0) {//数据为0时
                
            }else{
                
                SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
                maxHeight += 48;
                rankingsV.namelabel.text = dictLeval[@"sv_ml_name"];
                rankingsV.moneylabel.text = [NSString stringWithFormat:@"￥%.2f",[dictLeval[@"money"]doubleValue]];
                if (order_receivable != 0) {
                    float twoWide = 210 * [dictLeval[@"money"]doubleValue] / order_receivable;
                    
                    [UIView animateWithDuration:1 animations:^{
                        rankingsV.colorView.width = twoWide;
                    }];
                    rankingsV.colorView.height = 15;
                    rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                    rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                    //  maxY = maxY;
                    maxY = CGRectGetMaxY(rankingsV.frame);
                    [self.memberRechargeGradeView addSubview:rankingsV];
                }
            }
        }
        self.maxHeight = maxHeight;
         self.memberRechargeHeight.constant = 88 + self.maxHeight + 20;
        float newAndOld = 0;
        // 新旧会员
        [self.memberRechargeNewAndOldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i = 0; i < newAndOldArray.count ; i++) {
            
            NSString *newOldStr = newAndOldArray[i];
            
//            if ([dictLeval[@"money"] doubleValue] == 0) {//数据为0时
//
//            }else{
            
                SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, newAndOld, ScreenW - 20, 48)];
               // maxHeight += 48;
            if (i == 0) {
                rankingsV.namelabel.text = @"新会员";
            }else{
                rankingsV.namelabel.text = @"旧会员";
            }
            
                rankingsV.moneylabel.text = [NSString stringWithFormat:@"￥%.2f",[newOldStr doubleValue]];
                if (order_receivable != 0) {
                    float twoWide = 210 * [newOldStr doubleValue] / allOldNewStr;
                    
                    [UIView animateWithDuration:1 animations:^{
                        rankingsV.colorView.width = twoWide;
                    }];
                    rankingsV.colorView.height = 15;
                    rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                    rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                    //  maxY = maxY;
                    newAndOld = CGRectGetMaxY(rankingsV.frame);
                    [self.memberRechargeNewAndOldView addSubview:rankingsV];
              //  }
            }
        }
        
        if (self.selectMemberchongzhi == 1) {
            self.memberRechargeHeight.constant = 88 + self.maxHeight + 20;
        }else{
             self.memberRechargeHeight.constant = 88 + 48*2 + 20;
        }
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - 新增会员趋势
- (void)GetMemberAnalysisStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
      NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetMemberAnalysis?key=%@&start=%@&end=%@&user_id=%@",token,start,end,user_id];
    NSLog(@"新增会员趋势durl = %@",dURL);
    
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic会员分析 = %@",dic);
        self.memberAnalysis = dic[@"values"];
       self.storeMoney.text = [NSString stringWithFormat:@"%.2f",[self.memberAnalysis[@"sv_mw_availableamount"] doubleValue]];;
        self.allMember.text = [NSString stringWithFormat:@"%.0f",[self.memberAnalysis[@"membercount"] doubleValue]];;
      self.addMember.text = [NSString stringWithFormat:@"%.0f",[self.memberAnalysis[@"lastdaycount"] doubleValue]]; ;
        NSArray *addlist = self.memberAnalysis[@"addlist"];
        float order_receivable= 0.0;
        for (NSDictionary *dict in addlist) {
            order_receivable += [dict[@"addnum"] doubleValue];
        }
          self.order_receivable = order_receivable;
        if (order_receivable <= 0) {
            [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
            
            //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
            
            [self.fatherView addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.fatherView);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
        }else{
            CGFloat maxX = 0;
            //    if (self.fatherView.subviews.count > 0) {
            //        [self.fatherView removeFromSuperview];
            //    }
            [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.fatherView.width, self.fatherView.height)];
            [self.fatherView addSubview:scrollView];
            for (int i = 0; i < addlist.count ; i++) {
                NSDictionary *dict = addlist[i];
                if ([dict[@"addnum"] doubleValue] == 0) {//数据为0时
                    
                }else{
                    SVErectLineView *rankingsV = [[SVErectLineView alloc]initWithFrame:CGRectMake(maxX, 0, 80, self.fatherView.height)];
                    rankingsV.namelabel.text = dict[@"adddate"];
                    
                    rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.0f人",[dict[@"addnum"]doubleValue]];
                    rankingsV.moneylabel.textColor = navigationBackgroundColor;
                    
                    if (self.order_receivable != 0) {
                        float twoWide = 130 * [dict[@"addnum"] doubleValue] / self.order_receivable;
                        
                        
                        rankingsV.namelabel.frame = CGRectMake(0, self.fatherView.height - 30 -20, 80, 30);
                        
                        
                        rankingsV.colorView.frame = CGRectMake(30, self.fatherView.height - 30 -20, 15, 0);
                        
                        [UIView animateWithDuration:1 animations:^{
                            rankingsV.colorView.height = -twoWide;
                        }];
                        //                rankingsV.colorView.width = 15;
                        rankingsV.moneylabel.frame = CGRectMake(0, self.fatherView.height - 30 -twoWide -20, 80, -30);
                        // rankingsV.moneylabel.centerX = rankingsV.colorView.centerX;
                        
                        
                        //  maxY = maxY;
                        maxX = CGRectGetMaxX(rankingsV.frame);
                        //  [self.memberConsumptionNumView addSubview:rankingsV];
                        
                        
                        
                        [scrollView addSubview:rankingsV];
                    }
                }
            }
            scrollView.showsHorizontalScrollIndicator = FALSE;
            scrollView.contentSize = CGSizeMake(maxX, 0);
        }
       
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       // [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 会员消费次数分布
- (void)memberSaleCountInfoStart:(NSString *)start end:(NSString *)end user_id:(NSString *)user_id{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/GetStoreMemberSaleCountInfo?key=%@&start=%@&end=%@&user_id=%@",token,start,end,user_id];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic会员消费次数分布 = %@",dic);
        NSMutableArray *array = dic[@"values"];
        
            CGFloat maxX = 0;
            double order_receivable= 0.0;
            double count = 0.0;
            for (int i = 0; i < array.count ; i++) {
                NSDictionary *dict = array[i];
                order_receivable += [dict[@"order_receivable"] doubleValue];
                count += [dict[@"count"] doubleValue];
            }
        
        if (count <= 0) {
            [self.memberConsumptionNumView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
            
            //                UIImageView *img_two = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Bitmap"]];
            
            [self.memberConsumptionNumView addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.memberConsumptionNumView);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
        }else{
            [self.memberConsumptionNumView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.memberConsumptionNumView.width, self.memberConsumptionNumView.height)];
            [self.memberConsumptionNumView addSubview:scrollView];
            for (int i = 0; i < array.count ; i++) {
                NSDictionary *dict = array[i];
                SVConsumptionFrequencyView *memberRankingsV = [[SVConsumptionFrequencyView alloc]initWithFrame:CGRectMake(maxX, 0, 80, self.memberConsumptionNumView.height)];
                if ([dict[@"count"]doubleValue] <= 0) {
                    
                }else{
                    double twoWide;
                    if (order_receivable <= 0) {
                        twoWide = 1;
                    }else{
                       twoWide = 130 * [dict[@"order_receivable"] doubleValue] / order_receivable;
                    }
                   
                    
                    
                    memberRankingsV.namelabel.text = dict[@"remark"];
                    memberRankingsV.moneylabel.text = [NSString stringWithFormat:@"%.0f人",[dict[@"count"]doubleValue]];
                    
                    memberRankingsV.taglabel.text = [NSString stringWithFormat:@"￥%.1f",[dict[@"order_receivable"] doubleValue]];
                    memberRankingsV.colorView.backgroundColor = [UIColor colorWithHexString:@"EAAF3D"];
                    
                    // 会员消费次数分布
                    memberRankingsV.namelabel.frame = CGRectMake(0, self.memberConsumptionNumView.height-30 -20, 80, 30);
                    
                    
                    memberRankingsV.colorView.frame = CGRectMake(30, self.memberConsumptionNumView.height - 30 -20, 15, 0);
                    
                    [UIView animateWithDuration:1 animations:^{
                        memberRankingsV.colorView.height = -twoWide;
                    }];
                    //                rankingsV.colorView.width = 15;
                    memberRankingsV.moneylabel.frame = CGRectMake(0, self.memberConsumptionNumView.height - 30 -twoWide-3 -20, 80, -30);
                    memberRankingsV.moneylabel.textColor = [UIColor colorWithHexString:@"EAAF3D"];
                    memberRankingsV.taglabel.frame = CGRectMake(0, self.memberConsumptionNumView.height - 30 -twoWide -30 -20, 80, -30);
                    // rankingsV.moneylabel.centerX = rankingsV.colorView.centerX;
                    
                    
                    //  maxY = maxY;
                    maxX = CGRectGetMaxX(memberRankingsV.frame);
                    [scrollView addSubview:memberRankingsV];
                    // }
                    
                    
                }
                scrollView.showsHorizontalScrollIndicator = FALSE;
                scrollView.contentSize = CGSizeMake(maxX, 0);
            }
        }
        
       
        
        if ([self.scrollView.mj_header isRefreshing]) {
            
            [self.scrollView.mj_header endRefreshing];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

////实现方法
//-(void)notification2:(NSNotification *)noti{
//    
//    //使用userInfo处理消息
//    NSDictionary  *dic = [noti userInfo];
//    NSString *type = [dic objectForKey:@"type"];
//    self.type = type.integerValue;
//    if ([type isEqualToString:@"4"]) {
//        //        dic[@"oneDate"] = self.oneDate;
//        //        dic[@"twoDate"] = self.twoDate;
//        self.oneDate = [dic objectForKey:@"oneDate"];
//        self.twoDate = [dic objectForKey:@"twoDate"];
//        self.page = 1;
//        
//        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
//    }else{
//        self.page = 1;
//        self.oneDate = @"";
//        self.twoDate = @"";
//        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
//    }
//    NSLog(@"接收 userInfo传递的消息：%@",type);
//    
//}

//-(void)dealloc{
//
//    //移除观察者
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

//- (void)setUpData{
//
//    //提示加载中
//    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
//    self.page = 1;
//    self.type = 1; // 默认是今天
//    [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
//
//    /**
//     下拉刷新
//     */
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//
//        self.page = 1;
//
//        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
//
//    }];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//
//    // 设置文字
//    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
//    [header setTitle:@"正在努力刷新中ing ..." forState:MJRefreshStateRefreshing];
//    [header setTitle:@"最近刷新时间" forState:MJRefreshStateNoMoreData];
//
//    // 设置字体
//    header.stateLabel.font = [UIFont systemFontOfSize:12];
//    //    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
//
//    // 设置颜色
//    header.stateLabel.textColor = [UIColor grayColor];
//
//    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
//
//    self.tableView.mj_header = header;
//
//
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
//
//        self.page ++;
//        //  self.isSelect = YES;
//        //调用请求
//        //        [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:self.listView.searchWares.text biaoqian:@""];
//        [self setShopOverviewType:self.type Page:self.page top:10 date:self.oneDate date2:self.twoDate];
//
//    }];
//    // 设置文字
//    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
//    [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
//    [footer setTitle:@"正在拼命加载中ing ..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"没有更多的数据了" forState:MJRefreshStateNoMoreData];
//
//    // 设置字体
//    footer.stateLabel.font = [UIFont systemFontOfSize:12];
//
//    // 设置颜色
//    footer.stateLabel.textColor = [UIColor grayColor];
//    // 设置正在刷新状态的动画图片
//    [footer setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
//
//    self.tableView.mj_footer.hidden = YES;
//
//    self.tableView.mj_footer = footer;
//}

// 会员分析
- (void)setShopOverviewType:(NSInteger)type Page:(NSInteger)page top:(NSInteger)top date:(NSString *)date date2:(NSString *)date2{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/getMemberPagelist?key=%@&id=0&type=%li&page=%ld&top=%ld&date=%@&date2=%@",token,(long)type,(long)page,(long)top,date,date2];
    NSLog(@"dURL = %@",dURL);
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic444 = %@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            
            if (self.page == 1) {
                [self.dataList removeAllObjects];
                [self.GreaterThanArray removeAllObjects];
            }
            
            
            NSMutableArray *listArr = dic[@"values"];
            NSLog(@"listArr = %@",listArr);
            if (![SVTool isEmpty:listArr]) {
                
                
                for (NSDictionary *values in listArr) {
                    //字典转模型
                    SVShopOverviewModel *model = [SVShopOverviewModel mj_objectWithKeyValues:values];
                    model.selectVC = 2;// 会员分析

                        [self.dataList addObject:model];

                    
                    if ([model.order_receivable doubleValue] != 0) {

                            [self.GreaterThanArray addObject:model];

                        
                    }
                    
                }
                
                double order_receivable = 0.0;
                for (SVShopOverviewModel *model in self.GreaterThanArray) {
                     order_receivable += [model.order_receivable doubleValue];
                }
                
            //    self.order_receivable = order_receivable;
                
                [self.tableView reloadData];
                
            }else{
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            
            
            
        }else{
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
            
            
        }
        
     
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //   // if (!kArrayIsEmpty(self.dataList)) {
    //         return self.dataList.count + 2;
    ////    }else{
    ////        return self.dataList.count;
    ////    }
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }
    else{
        return self.dataList.count;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section == 0) {
        SVOneStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:OneStoreCellID];
        if (!cell) {
            cell = [[SVOneStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneStoreCellID];
        }
         cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.memberAnalysis = self.memberAnalysis;
        
        return cell;
    }else if (indexPath.section == 1){
        SVTwoDoBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:TwoDoBusinessCellID];
        if (!cell) {
            cell = [[SVTwoDoBusinessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TwoDoBusinessCellID];
        }
        
        cell.order_receivable = self.order_receivable;
        cell.memberAnalysisArray = self.memberAnalysis[@"addlist"];
         cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 2){
        SVMemberConsumptionCell *cell = [tableView dequeueReusableCellWithIdentifier:MemberConsumptionCellID];
        if (!cell) {
            cell = [[SVMemberConsumptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MemberConsumptionCellID];
        }
        
       // cell.memberModel = self.dataList[indexPath.row];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        SVIntelligentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:IntelligentDetailCellID];
        if (!cell) {
            cell = [[SVIntelligentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IntelligentDetailCellID];
        }
        
        cell.memberModel = self.dataList[indexPath.row];
         cell.selectionStyle =UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 50;
    }else{
        return 10;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        
        return self.storeTopView;
    }else{
        return nil;
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
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1){
//        return self.GreaterThanArray.count *48 + 40;
        return 150;
    }else if (indexPath.section == 2){
        return 200;
    }else{
        return 50;
    }
    
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

@end
