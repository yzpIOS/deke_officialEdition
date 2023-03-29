//
//  SVDateAnalysisVC.m
//  SAVI
//
//  Created by Sorgle on 2017/8/21.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVDateAnalysisVC.h"
//Xib
#import "SVDateSelectionXib.h"
//日期Xib
#import "SVDatePickerView.h"
//自定义view
#import "SVPayView.h"
#import "SVRankingsView.h"
#import "SVCustormPaymentModel.h"
#import "SVTableViewCell_5.h"
#import "SVReturnGoodsCell.h"
//#import "SVQuerySalesVC.h"
//距离右边的间隔
#define ViewRightInterval   16

//字体大小
#define TextFont    14
#define BigFont    15
#define CentreFont  12
#define SmallFont   11
//字体颜色
#define GreyFont    RGBA(182, 182, 182, 1)
#define RedFont    RGBA(253, 100, 103, 1)

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

static NSString *const ID = @"SVTableViewCell_5";
static NSString *const secID = @"SVTableViewCell_5";
static NSString *const threeID = @"SVReturnGoodsCell";
@interface SVDateAnalysisVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

//全局
@property (nonatomic,strong) UIScrollView *todyScrollView;

//饼图属性
@property (nonatomic, strong) PNPieChart *pieChart;

/*
 V1
 */
@property (nonatomic, strong) UILabel *V1labelA3;
@property (nonatomic, strong) UILabel *V1labelB3;
@property (nonatomic, strong) UILabel *V1labelC3;
@property (nonatomic, strong) UILabel *V1labelD3;

#pragma mark - 会员退货
@property (nonatomic,strong) UITableView *tableView_member_1;
@property (nonatomic,strong) NSMutableArray *member_1_array;
#pragma mark - 散客退货
@property (nonatomic,strong) UITableView *tableView_bulkguest_1;
@property (nonatomic,strong) NSMutableArray *bulkguest_1_array;
/*
 V2
 */
@property (nonatomic, strong) UIView *V2;
@property (nonatomic, strong) UILabel *V2sumlabel;

@property (nonatomic, strong) SVPayView *onePayView;
@property (nonatomic, strong) SVPayView *twoPayView;
@property (nonatomic, strong) SVPayView *threePayView;
@property (nonatomic, strong) SVPayView *fourPayView;
@property (nonatomic, strong) SVPayView *fivePayView;
@property (nonatomic, strong) SVPayView *sixPayView;
@property (nonatomic, strong) SVPayView *sevenPayView;
@property (nonatomic, strong) SVPayView *eightPayView;

/*
 V3
 */
@property (nonatomic, strong) UIView *V3;
//@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *V3sumlabel;
@property (nonatomic, strong) NSArray *items3;

@property (nonatomic, strong) SVPayView *onePayView_3;
@property (nonatomic, strong) SVPayView *twoPayView_3;
@property (nonatomic, strong) SVPayView *threePayView_3;
@property (nonatomic, strong) SVPayView *fourPayView_3;
@property (nonatomic, strong) SVPayView *fivePayView_3;
@property (nonatomic, strong) SVPayView *sixPayView_3;
@property (nonatomic, strong) SVPayView *sevenPayView_3;
@property (nonatomic, strong) SVPayView *eightPayView_3;
@property (nonatomic, strong) SVPayView *ninePayView_3;
@property (nonatomic, strong) SVPayView *tenPayView_3;
@property (nonatomic,strong) UITableView *tableView_3;
@property (nonatomic,strong) NSMutableArray *titleArrM_3;
@property (nonatomic,strong) NSMutableArray *colorArrM_3;
@property (nonatomic,strong) NSMutableArray *moneyArrM_3;
@property (nonatomic,strong) NSMutableArray *item3_array;
/*
 V4
 */
@property (nonatomic, strong) UIView *V4;
@property (nonatomic, strong) UILabel *V4sumlabel;

@property (nonatomic, strong) SVPayView *onePayView_4;
@property (nonatomic, strong) SVPayView *twoPayView_4;
@property (nonatomic, strong) SVPayView *threePayView_4;
@property (nonatomic, strong) SVPayView *fourPayView_4;
@property (nonatomic,strong) SVPayView *fivePayView_4;
@property (nonatomic,strong) SVPayView *sixPayView_4;
@property (nonatomic,strong) UITableView *tableView_4;
@property (nonatomic,strong) NSMutableArray *titleArrM_4;
@property (nonatomic,strong) NSMutableArray *colorArrM_4;
@property (nonatomic,strong) NSMutableArray *moneyArrM_4;
@property (nonatomic,strong) NSMutableArray *item4_array;

/*
 V5  记得5是添加在3后面的，因为后面添加的，我不想改动太大
 */
@property (nonatomic, strong) UIView *V5;
//@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *V5sumlabel;
@property (nonatomic, strong) NSArray *items5;

@property (nonatomic, strong) SVPayView *onePayView_5;
@property (nonatomic, strong) SVPayView *twoPayView_5;
@property (nonatomic, strong) SVPayView *threePayView_5;
@property (nonatomic, strong) SVPayView *fourPayView_5;
@property (nonatomic, strong) SVPayView *fivePayView_5;
@property (nonatomic, strong) SVPayView *sixPayView_5;
@property (nonatomic, strong) SVPayView *sevenPayView_5;
@property (nonatomic, strong) SVPayView *eightPayView_5;
@property (nonatomic, strong) SVPayView *ninePayView_5;
@property (nonatomic, strong) SVPayView *tenPayView_5;
@property (nonatomic,strong) UIScrollView *scrollView_5;
@property (nonatomic,strong) UITableView *tableView_5;
@property (nonatomic,strong) NSMutableArray *titleArrM_5;
@property (nonatomic,strong) NSMutableArray *colorArrM_5;
@property (nonatomic,strong) NSMutableArray *moneyArrM_5;
@property (nonatomic,strong) NSMutableArray *item5_array;
///*
// V6
// */
@property (nonatomic, strong) UIView *V6;
//@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *V6sumlabel;
@property (nonatomic, strong) NSArray *items6;

@property (nonatomic,strong) UITableView *tableView_6;
@property (nonatomic,strong) NSMutableArray *titleArrM_6;
@property (nonatomic,strong) NSMutableArray *colorArrM_6;
@property (nonatomic,strong) NSMutableArray *moneyArrM_6;
@property (nonatomic,strong) NSMutableArray *item6_array;

#pragma mark - 会员销售排行
@property (nonatomic,strong) UIView *member_sale;

#pragma mark - 散客销售排行
@property (nonatomic,strong) UIView *BulkGuest_sale;

//日期选择的Xib
@property (nonatomic,strong) SVDateSelectionXib *dateView;
@property (nonatomic,strong) UIView *backView;

//日期选择
@property (nonatomic, strong) SVDatePickerView *myDatePicker;
@property (nonatomic, strong) SVDatePickerView *twoDatePicker;

//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) UIView *maskTwoView;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation SVDateAnalysisVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    //scrollView    1542
    self.todyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64)];
    self.todyScrollView.contentSize = CGSizeMake(0, 2013);
    self.todyScrollView.backgroundColor = RGBA(244, 244, 244, 1);
    // 隐藏滑动条
    self.todyScrollView.showsVerticalScrollIndicator = NO;
    //关掉弹簧效果
    self.todyScrollView.bounces = NO;
    //指定代理
    self.todyScrollView.delegate = self;
    [self.view addSubview:self.todyScrollView];
    
    //取得当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    self.dateView.oneDaylbl.text = DateTime;
    self.dateView.twoDaylbl.text = DateTime;
    if (self.infoInquirySaleBlock) {
        self.infoInquirySaleBlock(self.dateView.oneDaylbl.text, self.dateView.twoDaylbl.text);
    }
    
//    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
//    dicM[@"oneDaylbl"] = self.dateView.oneDaylbl.text;
//    dicM[@"twoDaylbl"] = self.dateView.twoDaylbl.text;

   // [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoInquirySale" object:dicM];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoInquirySale" object:dicM userInfo:nil];
    NSLog(@"self.dateView.oneDaylbl.text = %@,self.dateView.twoDaylbl.text = %@",self.dateView.oneDaylbl.text,self.dateView.twoDaylbl.text);
    
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    
    //UI布局
    [self setUpOneView];
    //会员散客消费统计    type:1今天，2昨天，3本月，4日期筛选 开始日期和结束日期
   // [self setUpTwoViewWithType:4 Date:DateTime Date2:DateTime];
    [self setUpThreeView];
    // 散客消费
    [self setUpFiveView];
    [self setUpTwoView];
    
    [self setUpFourView];
   
    // 会员充次
    [self setUpSixView];
//    [self setUpSixView];
    //会员销售排行type      1 今天，2 昨天，3本月 4 日期筛选（ 填写开始日期和结束日期），5本周，6上周
    [self setUpFiveViewWithType:4 Date:DateTime Date2:DateTime];
    //商品销售排行type      1 今天，2 昨天，3本月 4 日期筛选（ 填写开始日期和结束日期），5本周，6上周
    [self setUpSixViewWithType:4 Date:DateTime Date2:DateTime];
    
    //数据请求      //每日帐单      day:0=今天 -1昨天 7本周 -2=自定义
    //    [self getSmartAnalysetWithID:2 date:@"2017-08-19" date2:@"2017-08-19" type:0];
    [self getSmartAnalysetWithType:-2 Date:DateTime Date2:[NSString stringWithFormat:@"%@ 23:59:59",DateTime]];
    
   [self GrossProfitWithType:-2 Date:DateTime Date2:[NSString stringWithFormat:@"%@ 23:59:59",DateTime]];
    
//    [self setUpAnalysetWithType:-2 Date:DateTime Date2:[NSString stringWithFormat:@"%@ 23:59:59",DateTime]];
    
//     [self setUpFiveView];
}

-(void)setUIWithView{
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.dateView.oneDaylbl.text format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.dateView.twoDaylbl.text format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
//        [SVProgressHUD showErrorWithStatus:@"输入时间有误"];
//        //用延迟来移除提示框
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        
    
       
        //移除所有子控件
//        for(UIView *view in [self.todyScrollView subviews])
//        {
//            [view removeFromSuperview];
//        }
        
//        //UI布局
//        [self setUpOneView];
//        //会员散客消费统计    type:1今天，2昨天，3本月，4日期筛选 开始日期和结束日期
//        // [self setUpTwoViewWithType:4 Date:DateTime Date2:DateTime];
//        [self setUpThreeView];
//        // 散客消费
//        [self setUpFiveView];
//        [self setUpTwoView];
//        
//        [self setUpFourView];
//        
//        // 会员充次
//        [self setUpSixView];
        
//        [self setUpSixView];
        //会员销售排行type      1 今天，2 昨天，3本月 4 日期筛选（ 填写开始日期和结束日期），5本周，6上周
        [self setUpFiveViewWithType:4 Date:self.dateView.oneDaylbl.text Date2:self.dateView.twoDaylbl.text];
        //商品销售排行type      1 今天，2 昨天，3本月 4 日期筛选（ 填写开始日期和结束日期），5本周，6上周
        [self setUpSixViewWithType:4 Date:self.dateView.oneDaylbl.text Date2:self.dateView.twoDaylbl.text];

        //数据请求      //每日帐单      day:0=今天 -1昨天 7本周 -2=自定义
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        //    [self getSmartAnalysetWithID:2 date:@"2017-08-19" date2:@"2017-08-19" type:0];
        [self.moneyArrM_5 removeAllObjects];
        [self.titleArrM_5 removeAllObjects];
        [self.colorArrM_5 removeAllObjects];
        [self.item5_array removeAllObjects];
        
        [self.moneyArrM_3 removeAllObjects];
        [self.titleArrM_3 removeAllObjects];
        [self.colorArrM_3 removeAllObjects];
        [self.item3_array removeAllObjects];
        
        [self.moneyArrM_4 removeAllObjects];
        [self.titleArrM_4 removeAllObjects];
        [self.colorArrM_4 removeAllObjects];
        [self.item4_array removeAllObjects];
        
        [self.moneyArrM_6 removeAllObjects];
        [self.titleArrM_6 removeAllObjects];
        [self.colorArrM_6 removeAllObjects];
        [self.item6_array removeAllObjects];
        
        
          [self getSmartAnalysetWithType:-2 Date:self.dateView.oneDaylbl.text Date2:[NSString stringWithFormat:@"%@ 23:59:59",self.dateView.twoDaylbl.text]];
        
          [self GrossProfitWithType:-2 Date:self.dateView.oneDaylbl.text Date2:[NSString stringWithFormat:@"%@ 23:59:59",self.dateView.twoDaylbl.text]];
        if (self.infoInquirySaleBlock) {
            self.infoInquirySaleBlock(self.dateView.oneDaylbl.text, self.dateView.twoDaylbl.text);
        }
     
//        NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
//        dicM[@"oneDaylbl"] = self.dateView.oneDaylbl.text;
//        dicM[@"twoDaylbl"] = self.dateView.twoDaylbl.text;
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"InfoInquirySale" object:dicM];
        
        
        
       //  [self setUpTwoViewWithType:4 Date:self.dateView.oneDaylbl.text Date2:self.dateView.twoDaylbl.text];
//        [self setUpAnalysetWithType:-2 Date:self.dateView.oneDaylbl.text Date2:[NSString stringWithFormat:@"%@ 23:59:59",self.dateView.twoDaylbl.text]];
        
    }
    
}

-(void)oneResponseEvent{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
    
    
}

-(void)twoResponseEvent{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.twoDatePicker];
    
}

-(void)GrossProfitWithType:(NSInteger)type Date:(NSString *)date Date2:(NSString *)date2{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //每日帐单      day:0=今天 -1昨天 7本周 -2=自定义
    NSString *bURL=[URLhead stringByAppendingFormat:@"/intelligent/GetProductAnalysis_new?key=%@&day=%li&date=%@&date2=%@",token,(long)type,date,date2];
    NSLog(@"4444bURL= %@",bURL);
    //当URL拼接里有中文时，需要进行编码一下
    bURL = [bURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //   bURL = [bURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:bURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
          NSLog(@"其他dic= %@",dic);
        
        NSDictionary *valuesDic = dic[@"values"];
        self.V1labelD3.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"sv_p_originalprice"] doubleValue]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}
    

-(void)getSmartAnalysetWithType:(NSInteger)type Date:(NSString *)date Date2:(NSString *)date2{
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //每日帐单      day:0=今天 -1昨天 7本周 -2=自定义
    NSString *bURL=[URLhead stringByAppendingFormat:@"/intelligent/mrdzd?key=%@&day=%li&date=%@&date2=%@",token,(long)type,date,date2];
    NSLog(@"其他bURL= %@",bURL);
    //当URL拼接里有中文时，需要进行编码一下
    bURL = [bURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool] GET:bURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
       NSLog(@"其他dic= %@",dic);
        
        NSDictionary *valuesDic = dic[@"values"];
        
        //营业额
//        self.V1labelA3.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"hy_receivable"] floatValue] + [valuesDic[@"xk_receivable"] floatValue] + [valuesDic[@"viptotal"] floatValue] - [valuesDic[@"creceivable"] floatValue]];
        
       // self.V1labelA3.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"generalIncome"]floatValue]];
          self.V1labelA3.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"generalIncome"] doubleValue]];
        
       
        //用累加法去拿到新增会员位数
        NSArray *liveArr = valuesDic[@"live"];
        int sum = 0;
        for (NSDictionary *diction in liveArr) {
            sum = [diction[@"count"] intValue] + sum;
        }
        self.V1labelB3.text = [NSString stringWithFormat:@"%d",sum];
        // 订单笔数
        self.V1labelC3.text = [NSString stringWithFormat:@"%@",valuesDic[@"orderNumber"]];
        
      //  self.V1labelD3.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"profit"] doubleValue]];
        
        
        if ([valuesDic[@"xreceivable"] floatValue] != 0) {
            [self.moneyArrM_3 addObject: valuesDic[@"xreceivable"]];
            [self.titleArrM_3 addObject:@"现金"];
            [self.colorArrM_3 addObject:colorA];
        }
        if ([valuesDic[@"wreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"wreceivable"]];
            [self.titleArrM_3 addObject:@"微信"];
            [self.colorArrM_3 addObject:colorB];
        }
        if ([valuesDic[@"yreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"yreceivable"]];
            [self.titleArrM_3 addObject:@"银行卡"];
            [self.colorArrM_3 addObject:colorC];
        }
        if ([valuesDic[@"creceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"creceivable"]];
            [self.titleArrM_3 addObject:@"储值卡"];
            [self.colorArrM_3 addObject:colorD];
        }
        if ([valuesDic[@"zreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"zreceivable"]];
            [self.titleArrM_3 addObject:@"支付宝"];
            [self.colorArrM_3 addObject:colorE];
        }
        if ([valuesDic[@"wjzreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"wjzreceivable"]];
            [self.titleArrM_3 addObject:@"微信记账"];
            [self.colorArrM_3 addObject:colorF];
        }
        if ([valuesDic[@"zjzreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"zjzreceivable"]];
            [self.titleArrM_3 addObject:@"支付宝记账"];
            [self.colorArrM_3 addObject:colorG];
        }
        
        if ([valuesDic[@"mreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"mreceivable"]];
            [self.titleArrM_3 addObject:@"美团"];
            [self.colorArrM_3 addObject:colorH];
        }
        
        // 口碑
        if ([valuesDic[@"kreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"kreceivable"]];
            [self.titleArrM_3 addObject:@"口碑"];
            [self.colorArrM_3 addObject:colorK];
        }
        
        if ([valuesDic[@"sreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"sreceivable"]];
            [self.titleArrM_3 addObject:@"闪惠"];
            [self.colorArrM_3 addObject:colorH];
        }
        
        if ([valuesDic[@"sszreceivable"] floatValue] != 0){
            [self.moneyArrM_3 addObject: valuesDic[@"sszreceivable"]];
            [self.titleArrM_3 addObject:@"赊账"];
            [self.colorArrM_3 addObject:colorI];
        }
        
        // 处理会员数据
//<<<<<<< HEAD
//         NSArray *membercustormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"memberSalesCustormPayment"]];
//
//=======
        NSArray *membercustormArr = valuesDic[@"memberSalesCustormPayment"];
        if (kArrayIsEmpty(membercustormArr)) {
            membercustormArr = nil;
        }else{
            membercustormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"memberSalesCustormPayment"]];
        }
        
        // 处理会员数据
      //  NSArray *membercustormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"memberSalesCustormPayment"]];
        
//>>>>>>> 5e68b3e... oem适配iOS13
        for (SVCustormPaymentModel *model in membercustormArr) {
            [self.titleArrM_3 addObject:model.payment];
            [self.moneyArrM_3 addObject:model.amount];
            [self.colorArrM_3 addObject:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]];
        }
        
        
        #pragma mark - 会员消费统计
        UITableView *tableView_3 = [[UITableView alloc] init];
        self.tableView_3 = tableView_3;
        [self.V3 addSubview:tableView_3];
        [tableView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW / 2, 223 - 50));
            make.top.mas_equalTo(self.V3).offset(50);
            make.right.mas_equalTo(self.V3);
        }];
        self.tableView_3.delegate = self;
        self.tableView_3.dataSource = self;
        [self.tableView_3 registerNib:[UINib nibWithNibName:@"SVTableViewCell_5" bundle:nil] forCellReuseIdentifier:ID];
        /** 去除tableview 右侧滚动条 */
        self.tableView_3.showsVerticalScrollIndicator = NO;
        /** 去掉分割线 */
        self.tableView_3.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self.tableView_5 reloadData];
        
        if (self.moneyArrM_3.count > 0) {
            for (NSInteger i = 0; i < self.colorArrM_3.count; i++) {
                
                [self.item3_array addObject:[PNPieChartDataItem dataItemWithValue:[self.moneyArrM_3[i] floatValue] color:self.colorArrM_3[i]]];
            }
        }else{
            [self.item3_array addObject:[PNPieChartDataItem dataItemWithValue:0 color:colorA]];
        }
       
        
//        float num_3 = 0;
//        for (NSString *numStr in self.moneyArrM_3) {
//            num_3 = [numStr floatValue] + num_3;
//        }
        
      //  self.V3sumlabel.text = [NSString stringWithFormat:@"%.2f",num_3];
      self.V3sumlabel.text = [NSString stringWithFormat:@"%.2f", [valuesDic[@"hy_receivable"] doubleValue]];
        
        
        // 初始化
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(10, 60, 130, 130) items:self.item3_array];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
        self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
        self.pieChart.showOnlyValues = YES; // 只显示数值不显示内容描述
        self.pieChart.innerCircleRadius = 0;
        //        self.pieChart.outerCircleRadius = 0;
        [self.pieChart strokeChart];
        self.pieChart.legendStyle = PNLegendItemStyleStacked; // 标注排放样式
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        [self.V3 addSubview:self.pieChart];
        
        // 散客消费统计数据
        // 加个X的是会员，加s是散客     散客没有储值卡
      
        if ([valuesDic[@"sxreceivable"] floatValue] != 0) {
            [self.moneyArrM_5 addObject: valuesDic[@"sxreceivable"]];
            [self.titleArrM_5 addObject:@"现金"];
            [self.colorArrM_5 addObject:colorA];
        }
        if ([valuesDic[@"swreceivable"] floatValue] != 0){
            [self.moneyArrM_5 addObject: valuesDic[@"swreceivable"]];
            [self.titleArrM_5 addObject:@"微信"];
            [self.colorArrM_5 addObject:colorB];
        }
        if ([valuesDic[@"syreceivable"] floatValue] != 0){
            [self.moneyArrM_5 addObject: valuesDic[@"syreceivable"]];
            [self.titleArrM_5 addObject:@"银行卡"];
            [self.colorArrM_5 addObject:colorC];
        }
        if ([valuesDic[@"szreceivable"] floatValue] != 0){
            [self.moneyArrM_5 addObject: valuesDic[@"szreceivable"]];
            [self.titleArrM_5 addObject:@"支付宝"];
            [self.colorArrM_5 addObject:colorD];
        }
        if ([valuesDic[@"swjzreceivable"] floatValue] != 0){
            [self.moneyArrM_5 addObject: valuesDic[@"swjzreceivable"]];
            [self.titleArrM_5 addObject:@"微信记账"];
            [self.colorArrM_5 addObject:colorE];
        }
        if ([valuesDic[@"szjzreceivable"] floatValue] != 0){
            [self.moneyArrM_5 addObject: valuesDic[@"szjzreceivable"]];
            [self.titleArrM_5 addObject:@"支付宝记账"];
            [self.colorArrM_5 addObject:colorF];
        }
        if ([valuesDic[@"ssreceivable"] floatValue] != 0){
            [self.moneyArrM_5 addObject: valuesDic[@"ssreceivable"]];
            [self.titleArrM_5 addObject:@"闪惠"];
            [self.colorArrM_5 addObject:colorG];
        }
        //        if ([valuesDic[@"sszreceivable"] floatValue] != 0){
        //            [self.moneyArrM_5 addObject: valuesDic[@"sszreceivable"]];
        //            [self.titleArrM_5 addObject:@"赊账"];
        //            [self.colorArrM_5 addObject:colorH];
        //        }
        // 美团
        if ([valuesDic[@"smreceivable"] floatValue] != 0){
            [self.moneyArrM_5 addObject: valuesDic[@"smreceivable"]];
            [self.titleArrM_5 addObject:@"美团"];
            [self.colorArrM_5 addObject:colorJ];
        }
        
        // 口碑
        if ([valuesDic[@"skreceivable"] floatValue] != 0){
            [self.moneyArrM_5 addObject: valuesDic[@"skreceivable"]];
            [self.titleArrM_5 addObject:@"口碑"];
            [self.colorArrM_5 addObject:colorK];
        }
        
        NSArray *custormArr = valuesDic[@"freeSalesCustormPayment"];
        if (kArrayIsEmpty(custormArr)) {
            custormArr = nil;
        }else{
            custormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"freeSalesCustormPayment"]];
        }
        
      //  NSArray *custormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"freeSalesCustormPayment"]];
        
        for (SVCustormPaymentModel *model in custormArr) {
            [self.titleArrM_5 addObject:model.payment];
            [self.moneyArrM_5 addObject:model.amount];
            [self.colorArrM_5 addObject:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]];
        }
        
//        float num_5 = 0;
//        for (NSString *numStr in self.moneyArrM_5) {
//            num_5 = [numStr floatValue] + num_5;
//        }
        
        //self.V5sumlabel.text = [NSString stringWithFormat:@"%.2f",num_5];
         self.V5sumlabel.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"xk_receivable"] doubleValue]];
        
        
#pragma mark - 散客消费统计数据
        UITableView *tableView_5 = [[UITableView alloc] init];
        self.tableView_5 = tableView_5;
        [self.V5 addSubview:tableView_5];
        [tableView_5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW / 2, 223 - 50));
            make.top.mas_equalTo(self.V5).offset(50);
            make.right.mas_equalTo(self.V5);
        }];
        self.tableView_5.delegate = self;
        self.tableView_5.dataSource = self;
        [self.tableView_5 registerNib:[UINib nibWithNibName:@"SVTableViewCell_5" bundle:nil] forCellReuseIdentifier:secID];
        /** 去除tableview 右侧滚动条 */
        self.tableView_5.showsVerticalScrollIndicator = NO;
        /** 去掉分割线 */
        self.tableView_5.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self.tableView_5 reloadData];
        
        if (self.moneyArrM_5.count > 0) {
            for (NSInteger i = 0; i < self.colorArrM_5.count; i++) {
                
                [self.item5_array addObject:[PNPieChartDataItem dataItemWithValue:[self.moneyArrM_5[i] floatValue] color:self.colorArrM_5[i]]];
            }
        }else{
            [self.item5_array addObject:[PNPieChartDataItem dataItemWithValue:0 color:colorA]];
        }
        
        // 初始化
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(10, 60, 130, 130) items:self.item5_array];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
        self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
        self.pieChart.showOnlyValues = YES; // 只显示数值不显示内容描述
        self.pieChart.innerCircleRadius = 0;
        //        self.pieChart.outerCircleRadius = 0;
        [self.pieChart strokeChart];
        self.pieChart.legendStyle = PNLegendItemStyleStacked; // 标注排放样式
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        [self.V5 addSubview:self.pieChart];
        
        
        
        
        // 退货数据统计(会员和散客)
       
        self.onePayView.moneylabel.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"memberrefund_Total"] floatValue]];// 会员退货总额
        
        NSArray *memberfundArr = valuesDic[@"memberfund"];
        if (kArrayIsEmpty(memberfundArr)) {
            self.member_1_array = nil;
        }else{
            self.member_1_array = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"memberfund"]];
        }
        
      //  self.member_1_array = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"memberfund"]];
        NSLog(@"self.member_1_array.count = %d",self.member_1_array.count);
        
        self.fivePayView.moneylabel.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"bulkguestrefund_Total"] floatValue]];
        
        self.bulkguest_1_array = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"bulkguestRefund_list"]];
        
        //  NSLog(@"self.bulkguest_1 = %@",valuesDic[@"bulkguestRefund"]);
        
        
        self.V2sumlabel.text = [NSString stringWithFormat:@"%.2f",[self.onePayView.moneylabel.text floatValue]+[self.fivePayView.moneylabel.text floatValue]];

//        
//        //订单总数
//        self.V1labelC3.text = [NSString stringWithFormat:@"%.f",[self.twoPayView.moneylabel.text floatValue]+[self.sixPayView.moneylabel.text floatValue]];
        
        
        
        //饼图 数据
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:[self.onePayView.moneylabel.text floatValue] color:colorA],
                           [PNPieChartDataItem dataItemWithValue:[self.fivePayView.moneylabel.text floatValue] color:colorC],
                           ];
        // 初始化
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(10, 50, 130, 130) items:items];
        //标记百分数值
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
        self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
        self.pieChart.showOnlyValues = YES; // 只显示数值不显示内容描述
        
        self.pieChart.innerCircleRadius = 0;
        //        self.pieChart.outerCircleRadius = 0;
        
        [self.pieChart strokeChart];
        
        
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked; // 标注排放样式
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        
        
        [self.V2 addSubview:self.pieChart];
        
        
        
        UITableView *tableView_member_1 = [[UITableView alloc] init];
        self.tableView_member_1 = tableView_member_1;
        [self.V2 addSubview:tableView_member_1];
        [tableView_member_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW / 2, 50));
            make.top.mas_equalTo(self.onePayView.mas_bottom).offset(5);
            make.right.mas_equalTo(self.V2);
        }];
        self.tableView_member_1.delegate = self;
        self.tableView_member_1.dataSource = self;
        [self.tableView_member_1 registerNib:[UINib nibWithNibName:@"SVReturnGoodsCell" bundle:nil] forCellReuseIdentifier:threeID];
        /** 去除tableview 右侧滚动条 */
        self.tableView_member_1.showsVerticalScrollIndicator = NO;
        /** 去掉分割线 */
        self.tableView_member_1.separatorStyle = UITableViewCellSeparatorStyleNone;
     
        
        UITableView *tableView_bulkguest_1 = [[UITableView alloc] init];
        self.tableView_bulkguest_1 = tableView_bulkguest_1;
        [self.V2 addSubview:tableView_bulkguest_1];
        [tableView_bulkguest_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW / 2, 50));
            make.top.mas_equalTo(self.fivePayView.mas_bottom).offset(5);
            make.right.mas_equalTo(self.V2);
        }];
        self.tableView_bulkguest_1.delegate = self;
        self.tableView_bulkguest_1.dataSource = self;
        [self.tableView_bulkguest_1 registerNib:[UINib nibWithNibName:@"SVReturnGoodsCell" bundle:nil] forCellReuseIdentifier:threeID];
        /** 去除tableview 右侧滚动条 */
        self.tableView_bulkguest_1.showsVerticalScrollIndicator = NO;
        /** 去掉分割线 */
        self.tableView_bulkguest_1.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        // 会员的充值
       self.V4sumlabel.text = [NSString stringWithFormat:@"%@",valuesDic[@"deposit"]];
        

        
        if ([valuesDic[@"zmoney"] floatValue] != 0) {
            [self.moneyArrM_4 addObject: valuesDic[@"zmoney"]];
            [self.titleArrM_4 addObject:@"支付宝"];
            [self.colorArrM_4 addObject:colorA];
        }
        if ([valuesDic[@"wmoney"] floatValue] != 0){
            [self.moneyArrM_4 addObject: valuesDic[@"wmoney"]];
            [self.titleArrM_4 addObject:@"微信"];
            [self.colorArrM_4 addObject:colorB];
        }
        if ([valuesDic[@"ymoney"] floatValue] != 0){
            [self.moneyArrM_4 addObject: valuesDic[@"ymoney"]];
            [self.titleArrM_4 addObject:@"银联"];
            [self.colorArrM_4 addObject:colorC];
        }
        if ([valuesDic[@"xmoney"] floatValue] != 0){
            [self.moneyArrM_4 addObject: valuesDic[@"xmoney"]];
            [self.titleArrM_4 addObject:@"现金"];
            [self.colorArrM_4 addObject:colorD];
        }
        if ([valuesDic[@"wxjzmoney"] floatValue] != 0){
            [self.moneyArrM_4 addObject: valuesDic[@"wxjzmoney"]];
            [self.titleArrM_4 addObject:@"微信记账"];
            [self.colorArrM_4 addObject:colorE];
        }
        if ([valuesDic[@"zjzmoney"] floatValue] != 0){
            [self.moneyArrM_4 addObject: valuesDic[@"zjzmoney"]];
            [self.titleArrM_4 addObject:@"支付宝记账"];
            [self.colorArrM_4 addObject:colorF];
        }
//<<<<<<< HEAD
//
//        NSArray *topUpCustormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"topUpCustormPayment"]];
//=======
        
        NSArray *topUpCustormArr = valuesDic[@"topUpCustormPayment"];
        if (kArrayIsEmpty(topUpCustormArr)) {
            topUpCustormArr = nil;
        }else{
            topUpCustormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"topUpCustormPayment"]];
        }
        
      //  NSArray *topUpCustormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"topUpCustormPayment"]];
//>>>>>>> 5e68b3e... oem适配iOS13
        
        for (SVCustormPaymentModel *model in topUpCustormArr) {
            [self.titleArrM_4 addObject:model.payment];
            [self.moneyArrM_4 addObject:model.amount];
            [self.colorArrM_4 addObject:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]];
        }
        

        
//        float num_4 = 0;
//        for (NSString *numStr in self.moneyArrM_4) {
//            num_4 = [numStr floatValue] + num_4;
//        }
        
      //  self.V4sumlabel.text = [NSString stringWithFormat:@"%.2f",num_4];
        self.V4sumlabel.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"viptotal"] doubleValue]];
//        NSLog(@"self.V4sumlabel.text = %@",self.V4sumlabel.text);
//        NSLog(@"self.V4sumlabel.text = %@",self.V4sumlabel.text);
        
#pragma mark - 散客消费统计数据
        UITableView *tableView_4 = [[UITableView alloc] init];
        self.tableView_4 = tableView_4;
        [self.V4 addSubview:tableView_4];
        [tableView_4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW / 2, 200 - 50));
            make.top.mas_equalTo(self.V4).offset(50);
            make.right.mas_equalTo(self.V4);
        }];
        self.tableView_4.delegate = self;
        self.tableView_4.dataSource = self;
        [self.tableView_4 registerNib:[UINib nibWithNibName:@"SVTableViewCell_5" bundle:nil] forCellReuseIdentifier:secID];
        /** 去除tableview 右侧滚动条 */
        self.tableView_4.showsVerticalScrollIndicator = NO;
        /** 去掉分割线 */
        self.tableView_4.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self.tableView_5 reloadData];
        
        if (self.moneyArrM_4.count > 0) {
            for (NSInteger i = 0; i < self.moneyArrM_4.count; i++) {
                
                [self.item4_array addObject:[PNPieChartDataItem dataItemWithValue:[self.moneyArrM_4[i] floatValue] color:self.colorArrM_4[i]]];
            }
        }else{
            [self.item4_array addObject:[PNPieChartDataItem dataItemWithValue:0 color:colorA]];
        }
        
        // 初始化
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(10, 50, 130, 130) items:self.item4_array];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
        self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
        self.pieChart.showOnlyValues = YES; // 只显示数值不显示内容描述
        
        self.pieChart.innerCircleRadius = 0;
        //        self.pieChart.outerCircleRadius = 0;
        
        [self.pieChart strokeChart];
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked; // 标注排放样式
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        
        [self.V4 addSubview:self.pieChart];
        
        
        
    // 会员充次
//        self.V6sumlabel.text = [NSString stringWithFormat:@"%@",valuesDic[@"deposit"]];
        
        if ([valuesDic[@"qzmoney"] floatValue] != 0) {
            [self.moneyArrM_6 addObject: valuesDic[@"qzmoney"]];
            [self.titleArrM_6 addObject:@"支付宝"];
            [self.colorArrM_6 addObject:colorA];
        }
        if ([valuesDic[@"qwxmoney"] floatValue] != 0){
            [self.moneyArrM_6 addObject: valuesDic[@"qwxmoney"]];
            [self.titleArrM_6 addObject:@"微信"];
            [self.colorArrM_6 addObject:colorB];
        }
        if ([valuesDic[@"qymoney"] floatValue] != 0){
            [self.moneyArrM_6 addObject: valuesDic[@"qymoney"]];
            [self.titleArrM_6 addObject:@"银联"];
            [self.colorArrM_6 addObject:colorC];
        }
        if ([valuesDic[@"qxmoney"] floatValue] != 0){
            [self.moneyArrM_6 addObject: valuesDic[@"qxmoney"]];
            [self.titleArrM_6 addObject:@"现金"];
            [self.colorArrM_6 addObject:colorD];
        }
        if ([valuesDic[@"qwxjzmoney"] floatValue] != 0){
            [self.moneyArrM_6 addObject: valuesDic[@"qwxjzmoney"]];
            [self.titleArrM_6 addObject:@"微信记账"];
            [self.colorArrM_6 addObject:colorE];
        }
        if ([valuesDic[@"qzjzmoney"] floatValue] != 0){
            [self.moneyArrM_6 addObject: valuesDic[@"qzjzmoney"]];
            [self.titleArrM_6 addObject:@"支付宝记账"];
            [self.colorArrM_6 addObject:colorF];
        }
        
        NSArray *chargeCustormArr = valuesDic[@"chargeCustormPayment"];
        if (kArrayIsEmpty(chargeCustormArr)) {
            chargeCustormArr = nil;
        }else{
            chargeCustormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"chargeCustormPayment"]];
        }
        
      //  NSArray *chargeCustormArr = [SVCustormPaymentModel mj_objectArrayWithKeyValuesArray:valuesDic[@"chargeCustormPayment"]];
        
        for (SVCustormPaymentModel *model in chargeCustormArr) {
            [self.titleArrM_6 addObject:model.payment];
            [self.moneyArrM_6 addObject:model.amount];
            [self.colorArrM_6 addObject:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]];
        }
        
//        float num_6 = 0;
//        for (NSString *numStr in self.moneyArrM_6) {
//            num_6 = [numStr floatValue] + num_6;
//        }
//        
       // self.V6sumlabel.text = [NSString stringWithFormat:@"%.2f",num_6];
        self.V6sumlabel.text = [NSString stringWithFormat:@"%.2f",[valuesDic[@"qtotal"]doubleValue]];
        
        UITableView *tableView_6 = [[UITableView alloc] init];
        self.tableView_6 = tableView_6;
        [self.V6 addSubview:tableView_6];
        [tableView_6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW / 2, 200 - 50));
            make.top.mas_equalTo(self.V6).offset(50);
            make.right.mas_equalTo(self.V6);
        }];
        self.tableView_6.delegate = self;
        self.tableView_6.dataSource = self;
        [self.tableView_6 registerNib:[UINib nibWithNibName:@"SVTableViewCell_5" bundle:nil] forCellReuseIdentifier:secID];
        /** 去除tableview 右侧滚动条 */
        self.tableView_6.showsVerticalScrollIndicator = NO;
        /** 去掉分割线 */
        self.tableView_6.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self.tableView_5 reloadData];
        
        if (self.moneyArrM_6.count > 0) {
            for (NSInteger i = 0; i < self.colorArrM_6.count; i++) {
                
                [self.item6_array addObject:[PNPieChartDataItem dataItemWithValue:[self.moneyArrM_6[i] floatValue] color:self.colorArrM_6[i]]];
            }
        }else{
            [self.item6_array addObject:[PNPieChartDataItem dataItemWithValue:0 color:colorA]];
        }
       
        
        // 初始化
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(10, 50, 130, 130) items:self.item6_array];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
        self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
        self.pieChart.showOnlyValues = YES; // 只显示数值不显示内容描述
        
        self.pieChart.innerCircleRadius = 0;
        //        self.pieChart.outerCircleRadius = 0;
        
        [self.pieChart strokeChart];
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked; // 标注排放样式
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        
        [self.V6 addSubview:self.pieChart];
        
         [MBProgressHUD hideHUDForView:self.view animated:YES];
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark -- V1
-(void)setUpOneView{
    UIView *V1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 278)];
    V1.backgroundColor = navigationBackgroundColor;
    [self.todyScrollView addSubview:V1];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, ScreenW, 218)];
    image.image = [UIImage imageNamed:@"AnalysisBackground"];
    [V1 addSubview:image];
    
    [V1 addSubview:self.backView];
    
    self.V1labelA3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, ScreenW, 30)];
    //    label1.text = @"10300";
    self.V1labelA3.textAlignment = NSTextAlignmentCenter;
    [self.V1labelA3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:33]];
    self.V1labelA3.textColor = [UIColor whiteColor];
    [V1 addSubview:self.V1labelA3];
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, ScreenW, 20)];
    label2.text = @"综合总收入(元)";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor whiteColor];
    [V1 addSubview:label2];
    
    self.V1labelB3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, ScreenW/3, 20)];
    //    self.V1labelB3.text = @"9";
    self.V1labelB3.textAlignment = NSTextAlignmentCenter;
    self.V1labelB3.textColor = [UIColor whiteColor];
    [self.V1labelB3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [V1 addSubview:self.V1labelB3];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 190, ScreenW/3, 20)];
    label4.text = @"新增会员(位)";
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:12];
    label4.textColor = [UIColor whiteColor];
    [V1 addSubview:label4];
    
    self.V1labelC3 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/3*1, 170, ScreenW/3, 20)];
    //    label5.text = @"35";
    self.V1labelC3.textAlignment = NSTextAlignmentCenter;
    self.V1labelC3.textColor = [UIColor whiteColor];
    [self.V1labelC3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [V1 addSubview:self.V1labelC3];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/3*1, 190, ScreenW/3, 20)];
    label6.text = @"订单数(笔)";
    label6.textAlignment = NSTextAlignmentCenter;
    label6.font = [UIFont systemFontOfSize:12];
    label6.textColor = [UIColor whiteColor];
    [V1 addSubview:label6];
    
    self.V1labelD3 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/3*2, 170, ScreenW/3, 20)];
    //    label7.text = @"15.06";
    self.V1labelD3.textAlignment = NSTextAlignmentCenter;
    self.V1labelD3.textColor = [UIColor whiteColor];
    [self.V1labelD3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [V1 addSubview:self.V1labelD3];
    
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/3*2, 190, ScreenW/3, 20)];
    label8.text = @"毛利润(元)";
    label8.textAlignment = NSTextAlignmentCenter;
    label8.font = [UIFont systemFontOfSize:12];
    label8.textColor = [UIColor whiteColor];
    [V1 addSubview:label8];
}

#pragma mark -- 会员消费统计（按支付方式） V3
-(void)setUpThreeView{
    self.V3 = [[UIView alloc]initWithFrame:CGRectMake(0, 278, ScreenW, 223)];
    self.V3.backgroundColor = [UIColor whiteColor];
    [self.todyScrollView addSubview:self.V3];
    
    
    //总消费额
    self.V3sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 110, 70, 15)];
    self.V3sumlabel.textAlignment = NSTextAlignmentCenter;
    self.V3sumlabel.font = [UIFont systemFontOfSize:TextFont];
    self.V3sumlabel.adjustsFontSizeToFitWidth = YES;
    self.V3sumlabel.minimumScaleFactor = 0.5;
    [self.V3 addSubview:self.V3sumlabel];
    
    UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 127, 130, 12)];
    sumtextlabel.text = @"总消费额";
    sumtextlabel.textAlignment = NSTextAlignmentCenter;
    sumtextlabel.font = [UIFont systemFontOfSize:CentreFont];
    sumtextlabel.textColor = RGBA(248, 107, 80, 1);
    [self.V3 addSubview:sumtextlabel];
    
    //标题
    [self setUpTitleView:self.V3 Sring:@"会员消费统计" Sring:@"(按支付方式)" Number:2];
    
}

#pragma mark - 散客的消费统计 V5
- (void)setUpFiveView{
    self.V5 = [[UIView alloc]initWithFrame:CGRectMake(0, 501, ScreenW, 223)];
    //  self.V5 = [[UIView alloc]init];
    self.V5.backgroundColor = [UIColor whiteColor];
    [self.todyScrollView addSubview:self.V5];
  
    //总消费额
    self.V5sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 110, 70, 15)];
    self.V5sumlabel.textAlignment = NSTextAlignmentCenter;
    self.V5sumlabel.font = [UIFont systemFontOfSize:TextFont];
    self.V5sumlabel.adjustsFontSizeToFitWidth = YES;
    self.V5sumlabel.minimumScaleFactor = 0.5;
    [self.V5 addSubview:self.V5sumlabel];
    
    UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 127, 130, 12)];
    sumtextlabel.text = @"总消费额";
    sumtextlabel.textAlignment = NSTextAlignmentCenter;
    sumtextlabel.font = [UIFont systemFontOfSize:CentreFont];
    sumtextlabel.textColor = RGBA(248, 107, 80, 1);
    [self.V5 addSubview:sumtextlabel];
    
    //标题
    [self setUpTitleView:self.V5 Sring:@"散客消费统计" Sring:@"(按支付方式)" Number:0];
    
}

#pragma mark -- V2退货数据统计
- (void)setUpTwoView{
    self.V2 = [[UIView alloc]initWithFrame:CGRectMake(0, 724, ScreenW, 223)];
    self.V2.backgroundColor = [UIColor whiteColor];
    [self.todyScrollView addSubview:self.V2];
    
    //总消费额 / 圆心标题
    self.V2sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 70, 15)];
    self.V2sumlabel.textAlignment = NSTextAlignmentCenter;
    self.V2sumlabel.font = [UIFont systemFontOfSize:TextFont];
    self.V2sumlabel.adjustsFontSizeToFitWidth = YES;
    self.V2sumlabel.minimumScaleFactor = 0.5;
    [self.V2 addSubview:self.V2sumlabel];
    
    UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 117, 130, 12)];
    sumtextlabel.text = @"总消费额";
    sumtextlabel.textAlignment = NSTextAlignmentCenter;
    sumtextlabel.font = [UIFont systemFontOfSize:CentreFont];
    sumtextlabel.textColor = RGBA(248, 107, 80, 1);
    [self.V2 addSubview:sumtextlabel];
    
    //标题
    [self setUpTitleView:self.V2 Sring:@"退货数据统计" Sring:@"(会员/散客)" Number:0];
    
    //会员消费
    self.onePayView = [[SVPayView alloc]init];
    self.onePayView.colorView.backgroundColor = colorA;
    self.onePayView.paylabel.text = @"会员退货总额:";
    self.onePayView.paylabel.textAlignment = NSTextAlignmentLeft;
    [self.V2 addSubview:self.onePayView];
    [self.onePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW / 2, 15));
        make.top.mas_equalTo(self.V2).offset(40);
        make.right.mas_equalTo(self.V2);
    }];
    
    //散客消费
    self.fivePayView = [[SVPayView alloc]init];
    self.fivePayView.colorView.backgroundColor = colorC;
    self.fivePayView.paylabel.text = @"散客退货金额:";
    self.fivePayView.paylabel.textAlignment = NSTextAlignmentLeft;
    [self.V2 addSubview:self.fivePayView];
    [self.fivePayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW / 2, 15));
        make.top.mas_equalTo(self.onePayView.mas_bottom).offset(70);
        make.right.mas_equalTo(self.V2);
    }];
    
}

#pragma mark -- 会员储值（按支付方式） V4
-(void)setUpFourView{
    self.V4 = [[UIView alloc]initWithFrame:CGRectMake(0, 957, ScreenW, 200)];
    self.V4.backgroundColor = [UIColor whiteColor];
    [self.todyScrollView addSubview:self.V4];
    
    //总消费额
    self.V4sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 70, 15)];
    //    self.V4sumlabel.text = @"9999999";
    self.V4sumlabel.textAlignment = NSTextAlignmentCenter;
    self.V4sumlabel.font = [UIFont systemFontOfSize:TextFont];
    self.V4sumlabel.adjustsFontSizeToFitWidth = YES;
    self.V4sumlabel.minimumScaleFactor = 0.5;
    [self.V4 addSubview:self.V4sumlabel];
    
    UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 117, 130, 12)];
    sumtextlabel.text = @"总储值额";
    sumtextlabel.textAlignment = NSTextAlignmentCenter;
    sumtextlabel.font = [UIFont systemFontOfSize:CentreFont];
    sumtextlabel.textColor = RGBA(248, 107, 80, 1);
    [self.V4 addSubview:sumtextlabel];
    
    [self setUpTitleView:self.V4 Sring:@"会员充值统计" Sring:@"(按支付方式)" Number:0];
}


#pragma mark - 会员充次的统计 V6
- (void)setUpSixView{
    self.V6 = [[UIView alloc]initWithFrame:CGRectMake(0, 1157, ScreenW, 200)];
    self.V6.backgroundColor = [UIColor whiteColor];
    [self.todyScrollView addSubview:self.V6];
    
    
    //总消费额
    self.V6sumlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 70, 15)];
    self.V6sumlabel.textAlignment = NSTextAlignmentCenter;
    self.V6sumlabel.font = [UIFont systemFontOfSize:TextFont];
    self.V6sumlabel.adjustsFontSizeToFitWidth = YES;
    self.V6sumlabel.minimumScaleFactor = 0.5;
    [self.V6 addSubview:self.V6sumlabel];
    
    UILabel *sumtextlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 117, 130, 12)];
    sumtextlabel.text = @"总储次额";
    sumtextlabel.textAlignment = NSTextAlignmentCenter;
    sumtextlabel.font = [UIFont systemFontOfSize:CentreFont];
    sumtextlabel.textColor = RGBA(248, 107, 80, 1);
    [self.V6 addSubview:sumtextlabel];
    
    
    //标题
    [self setUpTitleView:self.V6 Sring:@"会员充次统计" Sring:@"(按支付方式)" Number:0];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView_3) {
        return self.titleArrM_3.count;
    }else if (tableView == self.tableView_4){
        return self.titleArrM_4.count;
    }else if (tableView == self.tableView_5){
         return self.titleArrM_5.count;
    }else if (tableView == self.tableView_member_1){
        return _member_1_array.count;
    }else if (tableView == self.tableView_bulkguest_1){
        return _bulkguest_1_array.count;
    }else{
        return self.titleArrM_6.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView_3) {
        SVTableViewCell_5 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[SVTableViewCell_5 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        cell.nameL.text = self.titleArrM_3[indexPath.row];
        cell.cocorView.backgroundColor = self.colorArrM_3[indexPath.row];
        cell.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyArrM_3[indexPath.row] doubleValue]];
        return cell;
    }else if (tableView == self.tableView_4){
        SVTableViewCell_5 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[SVTableViewCell_5 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        cell.nameL.text = self.titleArrM_4[indexPath.row];
        cell.cocorView.backgroundColor = self.colorArrM_4[indexPath.row];
       cell.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyArrM_4[indexPath.row] doubleValue]];
        return cell;
    }else if (tableView == self.tableView_5){
        SVTableViewCell_5 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[SVTableViewCell_5 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secID];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        cell.nameL.text = self.titleArrM_5[indexPath.row];
        cell.cocorView.backgroundColor = self.colorArrM_5[indexPath.row];
        cell.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyArrM_5[indexPath.row] doubleValue]];
        return cell;
    }else if (tableView == self.tableView_member_1){
        SVReturnGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:threeID];
        if (!cell) {
            cell = [[SVReturnGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:threeID];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        cell.model = self.member_1_array[indexPath.row];
//        cell.nameL.text = self.titleArrM_5[indexPath.row];
//    //    cell.cocorView.backgroundColor = self.colorArrM_5[indexPath.row];
//        cell.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyArrM_5[indexPath.row] floatValue]];
        return cell;
    }else if (tableView == self.tableView_bulkguest_1){
        SVReturnGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:threeID];
        if (!cell) {
            cell = [[SVReturnGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:threeID];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        cell.model = self.bulkguest_1_array[indexPath.row];
        //        cell.nameL.text = self.titleArrM_5[indexPath.row];
        //    //    cell.cocorView.backgroundColor = self.colorArrM_5[indexPath.row];
        //        cell.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyArrM_5[indexPath.row] floatValue]];
        return cell;
    }else{
        SVTableViewCell_5 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[SVTableViewCell_5 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secID];
        }
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        
        cell.nameL.text = self.titleArrM_6[indexPath.row];
        cell.cocorView.backgroundColor = self.colorArrM_6[indexPath.row];
        cell.moneyL.text = [NSString stringWithFormat:@"%.2f",[self.moneyArrM_6[indexPath.row] doubleValue]];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

#pragma mark -- 会员销售排行 （TOP6位） V5
-(void)setUpFiveViewWithType:(NSInteger)type Date:(NSString *)date Date2:(NSString *)date2{
    UIView *V5 = [[UIView alloc]initWithFrame:CGRectMake(0, 1357, ScreenW, 323)];
    self.member_sale = V5;
    V5.backgroundColor = [UIColor whiteColor];
    [self.todyScrollView addSubview:V5];
    
    UIView *threadV = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenW, 1)];
    threadV.backgroundColor = RGBA(244, 244, 244, 1);
    [V5 addSubview:threadV];
    
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, ScreenW, 282)];
    //scrollView.contentSize = CGSizeMake(0, 48 * arr.count + 10);
    // 隐藏滑动条
    scrollView.showsVerticalScrollIndicator = NO;
    //关掉弹簧效果
    //scrollView.bounces = NO;
    //指定代理
    scrollView.delegate = self;
    [V5 addSubview:scrollView];
    
    [self setUpTitleView:V5 Sring:@"会员销售排行" Sring:nil Number:0];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    //会员销售排行
    //id    0-散客销售统计，1-会员销售统计 2 全部统计
    //int id1 = 1;
    //page      1--会员销售柱状统计图 ， page>1 查询多个会员信息列表
    //int page = 2;
    //会员销售排行type      1 今天，2 昨天，3本月 4 日期筛选（ 填写开始日期和结束日期），5本周，6上周
    //    int type1 = 1;
    
    //    NSString *cURL=[URLhead stringByAppendingFormat:@"/intelligent/getMemberPagelist?key=%@&id=%i&page=%i&type=%li",token,id1,page,(long)type1];
    NSString *cURL=[URLhead stringByAppendingFormat:@"/intelligent/getMemberPagelist?key=%@&type=%li&date=%@&date2=%@",token,(long)type,date,date2];
    [[SVSaviTool sharedSaviTool] GET:cURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *valuesArr = [dic arrayForKeySafe:@"values"];
        
        if ([SVTool isEmpty:valuesArr]) {
            
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noVipRanking"]];
            [V5 addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(V5);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
            
        } else {
            
            scrollView.contentSize = CGSizeMake(0, 48 * valuesArr.count + 10);
            
            for (int i = 0; i<valuesArr.count; i++) {
                
                SVRankingsView *rankingsV = [[SVRankingsView alloc]init];
                rankingsV.tag = i+1;
                NSDictionary *dic1 = valuesArr[i];
                rankingsV.taglabel.text = [NSString stringWithFormat:@"%d",i+1];
                rankingsV.namelabel.text = [NSString stringWithFormat:@"%@",dic1[@"sv_mr_name"]];
                rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",[dic1[@"order_receivable"] floatValue]];
                
                [scrollView addSubview:rankingsV];
                
                if (i == 0){
                    [rankingsV mas_makeConstraints:^(MASConstraintMaker *make)
                     {
                         make.size.mas_equalTo(CGSizeMake(ScreenW, 38));
                         make.left.mas_equalTo(scrollView);
                         make.top.mas_equalTo(scrollView).offset(10);
                     }];
                } else {
                    
                    
                    SVRankingsView *rankingsT = (SVRankingsView *)[V5 viewWithTag:i];
                    [rankingsV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(ScreenW, 38));
                        make.left.mas_equalTo(scrollView);
                        make.top.mas_equalTo(rankingsT.mas_bottom).offset(10);
                    }];
                    
                    //计算长度
                    if ([dic1[@"order_receivable"] floatValue] == 0) {//数据为0时
                        //改变frame
                        rankingsV.colorView.backgroundColor = [UIColor whiteColor];
                        [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.with.mas_equalTo(0.5);
                        }];
                    } else {
                        SVRankingsView *rankingsOneV = (SVRankingsView *)[V5 viewWithTag:1];
                        float twoWide = 180 * [dic1[@"order_receivable"] floatValue] / [rankingsOneV.moneylabel.text floatValue];
                        //改变frame
                        [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) { //这里有一报错 2018.1.2
                            make.size.mas_equalTo(CGSizeMake(twoWide, 22));
                        }];
                        
                    }
                    
                }
                
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        
    }];
    
}

#pragma mark -- 商品销售排行 （TOP6位） V6
-(void)setUpSixViewWithType:(NSInteger)type Date:(NSString *)date Date2:(NSString *)date2{
    UIView *V6 = [[UIView alloc]initWithFrame:CGRectMake(0, 1690, ScreenW, 323)];
    V6.backgroundColor = [UIColor whiteColor];
    self.BulkGuest_sale = V6;
    [self.todyScrollView addSubview:V6];
    
    UIView *threadV = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenW, 1)];
    threadV.backgroundColor = RGBA(244, 244, 244, 1);
    [V6 addSubview:threadV];
    
    //scrollView
   // UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, ScreenW, 282)];
    //scrollView.contentSize = CGSizeMake(0, 48 * arr.count + 10);
    
    if (KIsiPhoneX) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, ScreenW, 250)];
    }else{
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 41, ScreenW, 282)];
    }
    // 隐藏滑动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    //关掉弹簧效果
    //scrollView.bounces = NO;
    //指定代理
    self.scrollView.delegate = self;
    [V6 addSubview:self.scrollView];
    
    [self setUpTitleView:V6 Sring:@"商品销售排行" Sring:nil Number:0];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    //会员销售排行
    //id    0-散客销售统计，1-会员销售统计 2 全部统计
    //int ID = 1;
    //page      1--会员销售柱状统计图 ， page>1 查询多个会员信息列表
    //int page = 1;
    //商品销售排行type      1 今天，2 昨天，3本月 4 日期筛选（ 填写开始日期和结束日期），5本周，6上周
    //    int type = 1;
    //商品销售排行
    //        NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/getprCoutlist?key=%@&id=%i&page=%i&type=%i",token,ID,page,type1];
    NSString *dURL=[URLhead stringByAppendingFormat:@"/intelligent/getprCoutlist?key=%@&type=%li&date=%@&date2=%@",token,(long)type,date,date2];
    [[SVSaviTool sharedSaviTool] GET:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *valuesArr = [dic arrayForKeySafe:@"values"];
        
        if ([valuesArr isEqual:@""]) {
            
            UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noWareRanking"]];
            [V6 addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(V6);
                make.size.mas_equalTo(CGSizeMake(122.5, 132.5));
            }];
            
        } else {
            
            self.scrollView.contentSize = CGSizeMake(0, 48 * valuesArr.count + 10);
            
            for (int i = 0; i<valuesArr.count; i++) {
                
                SVRankingsView *rankingsV = [[SVRankingsView alloc]init];
                rankingsV.tag = i+1;
                NSDictionary *dic1 = valuesArr[i];
                rankingsV.taglabel.text = [NSString stringWithFormat:@"%d",i+1];
                rankingsV.namelabel.text = [NSString stringWithFormat:@"%@",dic1[@"sv_mr_name"]];
                rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",[dic1[@"order_receivable"] floatValue]];
                
                [self.scrollView addSubview:rankingsV];
                
                if (i == 0) {
                    [rankingsV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(ScreenW, 38));
                        make.left.mas_equalTo(self.scrollView);
                        make.top.mas_equalTo(self.scrollView).offset(10);
                    }];
                } else {
                    
                    
                    SVRankingsView *rankingsT = (SVRankingsView *)[V6 viewWithTag:i];
                    [rankingsV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(ScreenW, 38));
                        make.left.mas_equalTo(self.scrollView);
                        make.top.mas_equalTo(rankingsT.mas_bottom).offset(10);
                    }];
                    
                    //计算长度
                    if ([dic1[@"order_receivable"] floatValue] == 0) {//数据为0时
                        //改变frame
                        rankingsV.colorView.backgroundColor = [UIColor whiteColor];
                        [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.size.with.mas_equalTo(0.5);
                        }];
                    } else {
                        
                        SVRankingsView *rankingsOneV = (SVRankingsView *)[V6 viewWithTag:1];
                        float twoWide = 180 * [dic1[@"order_receivable"] floatValue] / [rankingsOneV.moneylabel.text floatValue];
                        //改变frame
                        [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) { //这里有一报错 / 2017.12.29
                            make.size.mas_equalTo(CGSizeMake(twoWide, 22));
                        }];
                        
                    }
                    
                }
                
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

-(void)setUpTitleView:(UIView *)view Sring:(NSString *)sring Sring:(NSString *)srings Number:(NSInteger)num{
    //标题
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(9, 15, 5, 13)];
    titleView.backgroundColor = RGBA(252, 103, 1, 1);
    [view addSubview:titleView];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = sring;
    label1.font = [UIFont systemFontOfSize:TextFont];
    [view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView);
        make.left.mas_equalTo(titleView.mas_right).with.offset(8);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = srings;
    label2.font = [UIFont systemFontOfSize:TextFont];
    label2.textColor = GreyFont;
    [view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(label1);
        make.left.mas_equalTo(label1.mas_right).with.offset(8);
    }];
    
    if (num == 2) {
        
        self.button = [[UIButton alloc]init];
        self.button.titleLabel.font = [UIFont systemFontOfSize:TextFont];
        [self.button setTitle:@"更多.." forState:UIControlStateNormal];
        [self.button setTitleColor:GreyFont forState:UIControlStateNormal];
        [view addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(label1);
            make.right.equalTo(view).with.offset(-ViewRightInterval);
        }];
        
//          [self.button addTarget:self action:@selector(handlePan) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

//#pragma mark - 触发点击更多
//- (void)handlePan{
//    SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//    //    //跳转界面有导航栏的
//    [self.navigationController pushViewController:tableVC animated:YES];
//}


#pragma mark -- 懒加载
-(SVDateSelectionXib *)dateView{
    if (!_dateView) {
        _dateView = [[NSBundle mainBundle] loadNibNamed:@"SVDateSelectionXib" owner:nil options:nil].lastObject;
        _dateView.frame = CGRectMake(1, 1, ScreenW/8*6-2, 26);
        
        _dateView.layer.cornerRadius = 8;
        
        //创建手势
        UITapGestureRecognizer *oneGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneResponseEvent)];
        UITapGestureRecognizer *twoGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoResponseEvent)];
        //添加事件
        [_dateView.oneViewButton addGestureRecognizer:oneGestureRecognizer];
        [_dateView.twoViewButton addGestureRecognizer:twoGestureRecognizer];
        [_dateView.button addTarget:self action:@selector(setUIWithView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateView;
}

-(UIView *)backView{
    if (!_backView) {
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(ScreenW/8, 40, ScreenW/8*6, 28)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 8;
        
        [_backView addSubview:self.dateView];
    }
    return _backView;
}


#pragma mark - 散客的懒加载
- (NSMutableArray *)titleArrM_5
{
    if (!_titleArrM_5) {
        _titleArrM_5 = [NSMutableArray array];
    }
    return _titleArrM_5;
}

- (NSMutableArray *)colorArrM_5
{
    if (!_colorArrM_5) {
        _colorArrM_5 = [NSMutableArray array];
    }
    
    return _colorArrM_5;
}

- (NSMutableArray *)moneyArrM_5
{
    if (!_moneyArrM_5) {
        _moneyArrM_5 = [NSMutableArray array];
    }
    return _moneyArrM_5;
}

- (NSMutableArray *)item5_array{
    if (_item5_array == nil) {
        _item5_array = [NSMutableArray array];
    }
    return _item5_array;
}

// 会员消费统计
- (NSMutableArray *)titleArrM_3
{
    if (!_titleArrM_3) {
        _titleArrM_3 = [NSMutableArray array];
    }
    return _titleArrM_3;
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

- (NSMutableArray *)item3_array{
    if (_item3_array == nil) {
        _item3_array = [NSMutableArray array];
    }
    return _item3_array;
}

// 会员充值
- (NSMutableArray *)titleArrM_4
{
    if (!_titleArrM_4) {
        _titleArrM_4 = [NSMutableArray array];
    }
    return _titleArrM_4;
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

- (NSMutableArray *)item4_array{
    if (_item4_array == nil) {
        _item4_array = [NSMutableArray array];
    }
    return _item4_array;
}

// 会员充次
- (NSMutableArray *)titleArrM_6
{
    if (!_titleArrM_6) {
        _titleArrM_6 = [NSMutableArray array];
    }
    return _titleArrM_6;
}

- (NSMutableArray *)colorArrM_6
{
    if (!_colorArrM_6) {
        _colorArrM_6 = [NSMutableArray array];
    }
    
    return _colorArrM_6;
}

- (NSMutableArray *)moneyArrM_6
{
    if (!_moneyArrM_6) {
        _moneyArrM_6 = [NSMutableArray array];
    }
    return _moneyArrM_6;
}

- (NSMutableArray *)item6_array{
    if (_item6_array == nil) {
        _item6_array = [NSMutableArray array];
    }
    return _item6_array;
}

//会员退货的支付方式
- (NSMutableArray *)member_1_array{
    if (_member_1_array == nil) {
        _member_1_array = [NSMutableArray array];
    }
    return _member_1_array;
}

// 散客退货的支付方式
- (NSMutableArray *)bulkguest_1_array{
    if (_bulkguest_1_array == nil) {
        _bulkguest_1_array = [NSMutableArray array];
    }
    return _bulkguest_1_array;
}
#pragma mark -- 第一个日期
/**
 日期选择
 */
-(SVDatePickerView *)myDatePicker{
    if (!_myDatePicker) {
        _myDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        CGFloat a = 320;
        CGFloat b = 230;
        
        CGFloat x = (ScreenW - a) / 2;
        CGFloat y = (ScreenH - b) / 2;
        
        _myDatePicker.frame = CGRectMake(x, y, a, b);
        _myDatePicker.backgroundColor = [UIColor whiteColor];
        _myDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_myDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _myDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _myDatePicker.datePickerView.maximumDate = minDate;
        //
        [_myDatePicker.dateCancel addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_myDatePicker.dateDetermine addTarget:self action:@selector(oneDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _myDatePicker;
}

/**
 遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

//点击手势的点击事件
- (void)oneDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.dateView.oneDaylbl.text = [dateFormatter stringFromDate:self.myDatePicker.datePickerView.date];
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskOneView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    
}


#pragma mark -- 第二个日期
/**
 日期选择
 */
-(SVDatePickerView *)twoDatePicker{
    if (!_twoDatePicker) {
        _twoDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        CGFloat a = 320;
        CGFloat b = 230;
        
        CGFloat x = (ScreenW - a) / 2;
        CGFloat y = (ScreenH - b) / 2;
        
        _twoDatePicker.frame = CGRectMake(x, y, a, b);
        _twoDatePicker.backgroundColor = [UIColor whiteColor];
        _twoDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_twoDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _twoDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _twoDatePicker.datePickerView.maximumDate = minDate;
        //
        [_twoDatePicker.dateCancel addTarget:self action:@selector(twoCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_twoDatePicker.dateDetermine addTarget:self action:@selector(twoDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _twoDatePicker;
}

/**
 遮盖View
 */
-(UIView *)maskTwoView{
    if (!_maskTwoView) {
        _maskTwoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTwoView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoCancelResponseEvent)];
        [_maskTwoView addGestureRecognizer:tap];
    }
    return _maskTwoView;
}

//点击手势的点击事件
- (void)twoDetermineResponseEvent{
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.dateView.twoDaylbl.text = [dateFormatter stringFromDate:self.twoDatePicker.datePickerView.date];
}

//点击手势的点击事件
- (void)twoCancelResponseEvent{
    
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    
}


@end
