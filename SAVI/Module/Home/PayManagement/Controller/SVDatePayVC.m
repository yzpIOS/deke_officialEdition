//
//  SVDatePayVC.m
//  SAVI
//
//  Created by Sorgle on 2017/10/17.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVDatePayVC.h"
//自定义view
#import "SVSpendingDetailView.h"
//日期XIB
#import "SVDatePickerView.h"

//1
#define colorA  RGBA(226, 134, 207, 1)
//2
#define colorB  RGBA(130, 131, 214, 1)
//3
#define colorC  RGBA(250, 193, 103, 1)
//4
#define colorD  RGBA(135, 135, 135, 1)
//5
#define colorE  RGBA(142, 205, 55, 1)
//6
#define colorF  RGBA(226, 197, 31, 1)
//7
#define colorG  RGBA(253, 139, 39, 1)
//8
#define colorH  RGBA(109, 167, 252, 1)
//9
#define colorI  RGBA(168, 145, 163, 1)
//10
#define colorJ  RGBA(248, 107, 80, 1)

@interface SVDatePayVC ()<UIScrollViewDelegate>

//全局
@property (nonatomic,strong) UIScrollView *todyScrollView;

@property (weak, nonatomic) IBOutlet UIButton *oneDayButton;
@property (weak, nonatomic) IBOutlet UIButton *toDayButton;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;

//制作圆的数组
@property (nonatomic, strong) NSArray *items;
//总额
@property (nonatomic, strong) NSString *sumMoney;

//排行view
@property (nonatomic, strong) SVSpendingDetailView *oneView;
@property (nonatomic, strong) SVSpendingDetailView *twoView;
@property (nonatomic, strong) SVSpendingDetailView *threeView;
@property (nonatomic, strong) SVSpendingDetailView *fourView;
@property (nonatomic, strong) SVSpendingDetailView *fiveView;
@property (nonatomic, strong) SVSpendingDetailView *sixView;
@property (nonatomic, strong) SVSpendingDetailView *sevenView;
@property (nonatomic, strong) SVSpendingDetailView *eightView;
@property (nonatomic, strong) SVSpendingDetailView *nineView;
@property (nonatomic, strong) SVSpendingDetailView *tenView;

//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *oneDatePicker;

//遮盖view
@property (nonatomic,strong) UIView *maskTwoView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *twoDatePicker;


@end

@implementation SVDatePayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //scrollView    1542
    self.todyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, ScreenW, ScreenH-64-50)];
    self.todyScrollView.contentSize = CGSizeMake(0, 870);
    //self.todyScrollView.backgroundColor = RGBA(244, 244, 244, 1);
    //关掉弹簧效果
    self.todyScrollView.bounces = NO;
    //指定代理
    self.todyScrollView.delegate = self;
    [self.view addSubview:self.todyScrollView];
    
    NSString *date = [SVTool timeAcquireCurrentDate];
    [self.oneDayButton setTitle:date forState:UIControlStateNormal];
    [self.toDayButton setTitle:date forState:UIControlStateNormal];
    self.lookButton.layer.cornerRadius = 4;
    
    
}

//选择第一个时间
- (IBAction)oneDayButtonResponseEvent {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.oneDatePicker];
    
}

//选择第二个时间
- (IBAction)toDayButtonResponseEvent {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.twoDatePicker];
    
}

//查询响应事件
- (IBAction)queryButtonResponseEvent {
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDayButton.titleLabel.text format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.toDayButton.titleLabel.text format:@"yyyy-MM-dd"];
    
//    NSLog(@"temp = %li",temp);
//    
//    NSLog(@"tempi = %li",tempi);
    
    
    if (temp > tempi) {
        
        //[SVProgressHUD showErrorWithStatus:@"输入时间有误"];
        // 只显示文字
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];

        
    } else {
        
        //移除所有子控件
        for(UIView *view in [self.todyScrollView subviews]){
            [view removeFromSuperview];
        }
        
        [self layoutOfTheInterface];
        
        [self getThreeSourcesWithBeginDate:self.oneDayButton.titleLabel.text endDate:[NSString stringWithFormat:@"%@ 23:59:59",self.toDayButton.titleLabel.text] page:1 pagesize:10 day:5];

    }
    
}


//布局界面
- (void)layoutOfTheInterface{
    
    //线view
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenW/5*4, ScreenW, 1)];
    lineView.backgroundColor = RGBA(223, 223, 223, 1);
    [self.todyScrollView addSubview:lineView];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"支出排名TOP10";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    [self.todyScrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.todyScrollView.mas_centerX);
        make.bottom.mas_equalTo(lineView.mas_top).offset(-10);
    }];
    
    self.oneView = [[SVSpendingDetailView alloc]initWithFrame:(CGRectMake(0, ScreenW/5*4, ScreenW, 50))];
    self.oneView.colorView.backgroundColor = colorA;
    self.oneView.payClasslabel.textColor = colorA;
    self.oneView.ratiolabel.textColor = colorA;
    self.oneView.moneylabel.textColor = colorA;
    [self.todyScrollView addSubview:self.oneView];
    
    self.twoView = [[SVSpendingDetailView alloc]init];
    self.twoView.colorView.backgroundColor = colorB;
    self.twoView.payClasslabel.textColor = colorB;
    self.twoView.ratiolabel.textColor = colorB;
    self.twoView.moneylabel.textColor = colorB;
    [self.todyScrollView addSubview:self.twoView];
    [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.oneView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
    self.threeView = [[SVSpendingDetailView alloc]init];
    self.threeView.colorView.backgroundColor = colorC;
    self.threeView.payClasslabel.textColor = colorC;
    self.threeView.ratiolabel.textColor = colorC;
    self.threeView.moneylabel.textColor = colorC;
    [self.todyScrollView addSubview:self.threeView];
    [self.threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.twoView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
    self.fourView = [[SVSpendingDetailView alloc]init];
    self.fourView.colorView.backgroundColor = colorD;
    self.fourView.payClasslabel.textColor = colorD;
    self.fourView.ratiolabel.textColor = colorD;
    self.fourView.moneylabel.textColor = colorD;
    [self.todyScrollView addSubview:self.fourView];
    [self.fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.threeView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
    self.fiveView = [[SVSpendingDetailView alloc]init];
    self.fiveView.colorView.backgroundColor = colorE;
    self.fiveView.payClasslabel.textColor = colorE;
    self.fiveView.ratiolabel.textColor = colorE;
    self.fiveView.moneylabel.textColor = colorE;
    [self.todyScrollView addSubview:self.fiveView];
    [self.fiveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.fourView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
    self.sixView = [[SVSpendingDetailView alloc]init];
    self.sixView.colorView.backgroundColor = colorF;
    self.sixView.payClasslabel.textColor = colorF;
    self.sixView.ratiolabel.textColor = colorF;
    self.sixView.moneylabel.textColor = colorF;
    [self.todyScrollView addSubview:self.sixView];
    [self.sixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.fiveView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
    self.sevenView = [[SVSpendingDetailView alloc]init];
    self.sevenView.colorView.backgroundColor = colorG;
    self.sevenView.payClasslabel.textColor = colorG;
    self.sevenView.ratiolabel.textColor = colorG;
    self.sevenView.moneylabel.textColor = colorG;
    [self.todyScrollView addSubview:self.sevenView];
    [self.sevenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.sixView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
    self.eightView = [[SVSpendingDetailView alloc]init];
    self.eightView.colorView.backgroundColor = colorH;
    self.eightView.payClasslabel.textColor = colorH;
    self.eightView.ratiolabel.textColor = colorH;
    self.eightView.moneylabel.textColor = colorH;
    [self.todyScrollView addSubview:self.eightView];
    [self.eightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.sevenView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
    self.nineView = [[SVSpendingDetailView alloc]init];
    self.nineView.colorView.backgroundColor = colorI;
    self.nineView.payClasslabel.textColor = colorI;
    self.nineView.ratiolabel.textColor = colorI;
    self.nineView.moneylabel.textColor = colorI;
    [self.todyScrollView addSubview:self.nineView];
    [self.nineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.eightView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
    self.tenView = [[SVSpendingDetailView alloc]init];
    self.tenView.colorView.backgroundColor = colorJ;
    self.tenView.payClasslabel.textColor = colorJ;
    self.tenView.ratiolabel.textColor = colorJ;
    self.tenView.moneylabel.textColor = colorJ;
    [self.todyScrollView addSubview:self.tenView];
    [self.tenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
        make.top.mas_equalTo(self.nineView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view);
    }];
    
}

-(void)getThreeSourcesWithBeginDate:(NSString *)beginDate endDate:(NSString *)endDate page:(NSInteger)page pagesize:(NSInteger)pagesize day:(NSInteger)day{
    
    [SVUserManager loadUserInfo];
    
    NSString *sURL=[URLhead stringByAppendingFormat:@"/api/Payment/GetPaymentInfosByType?key=%@&beginDate=%@&endDate=%@&page=%li&pagesize=%li&day=%li",[SVUserManager shareInstance].access_token,beginDate,endDate,(long)page,(long)pagesize,(long)day];
    
     sURL = [sURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[SVSaviTool sharedSaviTool] GET:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
    //     NSLog(@"dic = %@",dic);
        
        NSArray *dataListArr = dic[@"dataList"];
        if (![SVTool isEmpty:dataListArr]) {
            
            NSMutableArray *itemsMoneyArr = [NSMutableArray array];
            NSMutableArray *itmesNameArr = [NSMutableArray array];
            
            for (NSDictionary *dict in dataListArr) {
                
                [itemsMoneyArr addObject:dict[@"e_expenditure_money"]];
                [itmesNameArr addObject:dict[@"e_expenditureclassname"]];
            }
            
            float sum = 0;
            for (int i = 0; itemsMoneyArr.count > i; i++) {
                sum = [itemsMoneyArr[i] floatValue] + sum;
            }
            self.sumMoney = [NSString stringWithFormat:@"%.2f",sum];
            
            if (dataListArr.count == 1) {
                
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               ];
                
                //付值
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                
                //隐藏
                self.twoView.hidden = YES;
                self.threeView.hidden = YES;
                self.fourView.hidden = YES;
                self.fiveView.hidden = YES;
                self.sixView.hidden = YES;
                self.sevenView.hidden = YES;
                self.eightView.hidden = YES;
                self.nineView.hidden = YES;
                self.tenView.hidden = YES;
                
            }
            
            if (dataListArr.count == 2) {
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               ];
                
                self.threeView.hidden = YES;
                self.fourView.hidden = YES;
                self.fiveView.hidden = YES;
                self.sixView.hidden = YES;
                self.sevenView.hidden = YES;
                self.eightView.hidden = YES;
                self.nineView.hidden = YES;
                self.tenView.hidden = YES;
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                
            }
            
            if (dataListArr.count == 3) {
                
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[2] floatValue] color:colorC],
                               ];
                
                self.fourView.hidden = YES;
                self.fiveView.hidden = YES;
                self.sixView.hidden = YES;
                self.sevenView.hidden = YES;
                self.eightView.hidden = YES;
                self.nineView.hidden = YES;
                self.tenView.hidden = YES;
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                self.threeView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[2]];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                self.threeView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[2] floatValue]/sum*100];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                self.threeView.payClasslabel.text = itmesNameArr[2];
                
            }
            
            if (dataListArr.count == 4) {
                
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[2] floatValue] color:colorC],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[3] floatValue] color:colorD],
                               ];
                
                self.fiveView.hidden = YES;
                self.sixView.hidden = YES;
                self.sevenView.hidden = YES;
                self.eightView.hidden = YES;
                self.nineView.hidden = YES;
                self.tenView.hidden = YES;
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                self.threeView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[2]];
                self.fourView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[3]];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                self.threeView.payClasslabel.text = itmesNameArr[2];
                self.fourView.payClasslabel.text = itmesNameArr[3];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                self.threeView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[2] floatValue]/sum*100];
                self.fourView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[3] floatValue]/sum*100];
                
            }
            
            if (dataListArr.count == 5) {
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[2] floatValue] color:colorC],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[3] floatValue] color:colorD],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[4] floatValue] color:colorE],
                               ];
                
                self.sixView.hidden = YES;
                self.sevenView.hidden = YES;
                self.eightView.hidden = YES;
                self.nineView.hidden = YES;
                self.tenView.hidden = YES;
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                self.threeView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[2]];
                self.fourView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[3]];
                self.fiveView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[4]];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                self.threeView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[2] floatValue]/sum*100];
                self.fourView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[3] floatValue]/sum*100];
                self.fiveView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[4] floatValue]/sum*100];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                self.threeView.payClasslabel.text = itmesNameArr[2];
                self.fourView.payClasslabel.text = itmesNameArr[3];
                self.fiveView.payClasslabel.text = itmesNameArr[4];
                
            }
            
            if (dataListArr.count == 6) {
                
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[2] floatValue] color:colorC],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[3] floatValue] color:colorD],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[4] floatValue] color:colorE],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[5] floatValue] color:colorF],
                               ];
                
                self.sevenView.hidden = YES;
                self.eightView.hidden = YES;
                self.nineView.hidden = YES;
                self.tenView.hidden = YES;
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                self.threeView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[2]];
                self.fourView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[3]];
                self.fiveView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[4]];
                self.sixView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[5]];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                self.threeView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[2] floatValue]/sum*100];
                self.fourView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[3] floatValue]/sum*100];
                self.fiveView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[4] floatValue]/sum*100];
                self.sixView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[5] floatValue]/sum*100];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                self.threeView.payClasslabel.text = itmesNameArr[2];
                self.fourView.payClasslabel.text = itmesNameArr[3];
                self.fiveView.payClasslabel.text = itmesNameArr[4];
                self.sixView.payClasslabel.text = itmesNameArr[5];
                
            }
            
            if (dataListArr.count == 7) {
                
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[2] floatValue] color:colorC],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[3] floatValue] color:colorD],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[4] floatValue] color:colorE],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[5] floatValue] color:colorF],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[6] floatValue] color:colorG],
                               ];
                
                self.eightView.hidden = YES;
                self.nineView.hidden = YES;
                self.tenView.hidden = YES;
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                self.threeView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[2]];
                self.fourView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[3]];
                self.fiveView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[4]];
                self.sixView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[5]];
                self.sevenView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[6]];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                self.threeView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[2] floatValue]/sum*100];
                self.fourView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[3] floatValue]/sum*100];
                self.fiveView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[4] floatValue]/sum*100];
                self.sixView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[5] floatValue]/sum*100];
                self.sevenView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[6] floatValue]/sum*100];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                self.threeView.payClasslabel.text = itmesNameArr[2];
                self.fourView.payClasslabel.text = itmesNameArr[3];
                self.fiveView.payClasslabel.text = itmesNameArr[4];
                self.sixView.payClasslabel.text = itmesNameArr[5];
                self.sevenView.payClasslabel.text = itmesNameArr[6];
                
            }
            
            if (dataListArr.count == 8) {
                
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[2] floatValue] color:colorC],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[3] floatValue] color:colorD],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[4] floatValue] color:colorE],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[5] floatValue] color:colorF],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[6] floatValue] color:colorG],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[7] floatValue] color:colorH],
                               ];
                
                self.nineView.hidden = YES;
                self.tenView.hidden = YES;
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                self.threeView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[2]];
                self.fourView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[3]];
                self.fiveView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[4]];
                self.sixView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[5]];
                self.sevenView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[6]];
                self.eightView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[7]];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                self.threeView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[2] floatValue]/sum*100];
                self.fourView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[3] floatValue]/sum*100];
                self.fiveView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[4] floatValue]/sum*100];
                self.sixView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[5] floatValue]/sum*100];
                self.sevenView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[6] floatValue]/sum*100];
                self.eightView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[7] floatValue]/sum*100];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                self.threeView.payClasslabel.text = itmesNameArr[2];
                self.fourView.payClasslabel.text = itmesNameArr[3];
                self.fiveView.payClasslabel.text = itmesNameArr[4];
                self.sixView.payClasslabel.text = itmesNameArr[5];
                self.sevenView.payClasslabel.text = itmesNameArr[6];
                self.eightView.payClasslabel.text = itmesNameArr[7];
                
            }
            
            if (dataListArr.count == 9) {
                
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[2] floatValue] color:colorC],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[3] floatValue] color:colorD],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[4] floatValue] color:colorE],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[5] floatValue] color:colorF],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[6] floatValue] color:colorG],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[7] floatValue] color:colorH],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[8] floatValue] color:colorI],
                               ];
                
                self.tenView.hidden = YES;
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                self.threeView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[2]];
                self.fourView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[3]];
                self.fiveView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[4]];
                self.sixView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[5]];
                self.sevenView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[6]];
                self.eightView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[7]];
                self.nineView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[8]];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                self.threeView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[2] floatValue]/sum*100];
                self.fourView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[3] floatValue]/sum*100];
                self.fiveView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[4] floatValue]/sum*100];
                self.sixView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[5] floatValue]/sum*100];
                self.sevenView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[6] floatValue]/sum*100];
                self.eightView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[7] floatValue]/sum*100];
                self.nineView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[8] floatValue]/sum*100];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                self.threeView.payClasslabel.text = itmesNameArr[2];
                self.fourView.payClasslabel.text = itmesNameArr[3];
                self.fiveView.payClasslabel.text = itmesNameArr[4];
                self.sixView.payClasslabel.text = itmesNameArr[5];
                self.sevenView.payClasslabel.text = itmesNameArr[6];
                self.eightView.payClasslabel.text = itmesNameArr[7];
                self.nineView.payClasslabel.text = itmesNameArr[8];
                
            }
            
            if (dataListArr.count >= 10) {
                
                //饼图 数据
                self.items = @[[PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[0] floatValue] color:colorA],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[1] floatValue] color:colorB],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[2] floatValue] color:colorC],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[3] floatValue] color:colorD],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[4] floatValue] color:colorE],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[5] floatValue] color:colorF],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[6] floatValue] color:colorG],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[7] floatValue] color:colorH],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[8] floatValue] color:colorI],
                               [PNPieChartDataItem dataItemWithValue:[itemsMoneyArr[9] floatValue] color:colorJ],
                               ];
                
                self.oneView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[0]];
                self.twoView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[1]];
                self.threeView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[2]];
                self.fourView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[3]];
                self.fiveView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[4]];
                self.sixView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[5]];
                self.sevenView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[6]];
                self.eightView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[7]];
                self.nineView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[8]];
                self.tenView.moneylabel.text = [NSString stringWithFormat:@"￥%@",itemsMoneyArr[9]];
                
                self.oneView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[0] floatValue]/sum*100];
                self.twoView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[1] floatValue]/sum*100];
                self.threeView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[2] floatValue]/sum*100];
                self.fourView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[3] floatValue]/sum*100];
                self.fiveView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[4] floatValue]/sum*100];
                self.sixView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[5] floatValue]/sum*100];
                self.sevenView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[6] floatValue]/sum*100];
                self.eightView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[7] floatValue]/sum*100];
                self.nineView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[8] floatValue]/sum*100];
                self.tenView.ratiolabel.text = [NSString stringWithFormat:@"%.f%%",[itemsMoneyArr[9] floatValue]/sum*100];
                
                self.oneView.payClasslabel.text = itmesNameArr[0];
                self.twoView.payClasslabel.text = itmesNameArr[1];
                self.threeView.payClasslabel.text = itmesNameArr[2];
                self.fourView.payClasslabel.text = itmesNameArr[3];
                self.fiveView.payClasslabel.text = itmesNameArr[4];
                self.sixView.payClasslabel.text = itmesNameArr[5];
                self.sevenView.payClasslabel.text = itmesNameArr[6];
                self.eightView.payClasslabel.text = itmesNameArr[7];
                self.nineView.payClasslabel.text = itmesNameArr[8];
                self.tenView.payClasslabel.text = itmesNameArr[9];
                
                
            }
            
        } else {
            
            self.sumMoney = @"0.00";
            
            //饼图 数据
            self.items = @[[PNPieChartDataItem dataItemWithValue:0 color:RGBA(238, 238, 238, 1)],
                           ];
            
            //隐藏
            self.oneView.hidden = YES;
            self.twoView.hidden = YES;
            self.threeView.hidden = YES;
            self.fourView.hidden = YES;
            self.fiveView.hidden = YES;
            self.sixView.hidden = YES;
            self.sevenView.hidden = YES;
            self.eightView.hidden = YES;
            self.nineView.hidden = YES;
            self.tenView.hidden = YES;
            
        }
        
        //PNPieChart初始化
        
        PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(ScreenW / 5, 20, ScreenW / 5 * 3, ScreenW / 5 * 3) items:self.items];
        
        //pieChart.backgroundColor = [UIColor yellowColor];
        
        //扇形上字体颜色
        
        pieChart.descriptionTextColor = [UIColor whiteColor];
        
        pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        
        // 阴影颜色
        
        pieChart.descriptionTextShadowColor = [UIColor clearColor];
        
        //显示实际数值(不显示比例数字)
        
        pieChart.showAbsoluteValues = NO;
        
        // 只显示数值不显示内容描述
        
        pieChart.showOnlyValues = YES;
        
        //开始绘图
        
        [pieChart strokeChart];
        
        //Add
        
        [self.todyScrollView addSubview:pieChart];
        
        //总额
        UILabel *sumNumber = [[UILabel alloc]init];
        sumNumber.textAlignment = NSTextAlignmentCenter;
        sumNumber.text = self.sumMoney;
        [pieChart addSubview:sumNumber];
        [sumNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(pieChart.bounds.size.width, 20));
            make.left.mas_equalTo(pieChart);
            make.top.mas_equalTo(pieChart).offset(pieChart.bounds.size.height / 2 - 20);
        }];
        
        UILabel *sumLabel = [[UILabel alloc]init];
        sumLabel.textAlignment = NSTextAlignmentCenter;
        sumLabel.font = [UIFont systemFontOfSize:12];
        sumLabel.textColor = RGBA(253, 100, 103, 1);
        sumLabel.text = @"总支出";
        [pieChart addSubview:sumLabel];
        [sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(pieChart.bounds.size.width, 20));
            make.left.mas_equalTo(pieChart);
            make.top.mas_equalTo(sumNumber.mas_bottom);
        }];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //[SVTool requestFailed];
        // 只显示文字
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        
    }];
    
    
}

#pragma mark - 懒加载

-(SVDatePickerView *)oneDatePicker{
    if (!_oneDatePicker) {
        _oneDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _oneDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _oneDatePicker.center = CGPointMake(ScreenW/2, ScreenH/2);
        _oneDatePicker.backgroundColor = [UIColor whiteColor];
        _oneDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_oneDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _oneDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _oneDatePicker.datePickerView.maximumDate = minDate;
        
        [_oneDatePicker.dateCancel addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_oneDatePicker.dateDetermine addTarget:self action:@selector(dateDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneDatePicker;
}

/**
 日期遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

//点击手势的点击事件
- (void)dateDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.oneDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self.oneDayButton setTitle:[dateFormatter stringFromDate:self.oneDatePicker.datePickerView.date] forState:UIControlStateNormal];
    
}
//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.oneDatePicker removeFromSuperview];
}


/**
 第二个日期选择
 */
-(SVDatePickerView *)twoDatePicker{
    if (!_twoDatePicker) {
        _twoDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _twoDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _twoDatePicker.center = CGPointMake(ScreenW/2, ScreenH/2);
        _twoDatePicker.backgroundColor = [UIColor whiteColor];
        _twoDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_twoDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _twoDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _twoDatePicker.datePickerView.maximumDate = minDate;
        
        [_twoDatePicker.dateCancel addTarget:self action:@selector(twotwoDateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_twoDatePicker.dateDetermine addTarget:self action:@selector(twoDateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoDatePicker;
}

/**
 日期遮盖View
 */
-(UIView *)maskTwoView{
    if (!_maskTwoView) {
        _maskTwoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTwoView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twotwoDateCancelResponseEvent)];
        [_maskTwoView addGestureRecognizer:tap];
    }
    return _maskTwoView;
}

//点击手势的点击事件
- (void)twoDateCancelResponseEvent{
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self.toDayButton setTitle:[dateFormatter stringFromDate:self.twoDatePicker.datePickerView.date] forState:UIControlStateNormal];
    
}
//点击手势的点击事件
- (void)twotwoDateCancelResponseEvent{
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
}


@end
