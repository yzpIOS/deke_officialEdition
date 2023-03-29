//
//  SVIntelligentAnalysisVC.m
//  SAVI
//
//  Created by houming Wang on 2019/9/11.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVIntelligentAnalysisVC.h"
#import "SVIntelligentAnalysisDetailVC.h"
#import "SVSmartAnalyseVC.h"
@interface SVIntelligentAnalysisVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SVIntelligentAnalysisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.navigationItem.title = @"特步广州店";
//    self.navigationItem.title = @"选择打印商品";
   // [self setUpUI];
    self.bigView.layer.cornerRadius = 10;
    self.bigView.layer.masksToBounds = YES;
    self.scrollView.delegate = self;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = scrollView.contentOffset;
    
    if (point.y <= -0) {
        
        self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
        
    }
    
}


- (void)setUpUI{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 150, ScreenW - 40, 1150)];
    scrollView.layer.cornerRadius = 10;
    scrollView.layer.masksToBounds = YES;
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    
    
    scrollView.contentSize = CGSizeMake(0, 1150);
    
 
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 100)];
    oneView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:oneView];
    
    // 日常分析
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 2, 13)];
    lineView.backgroundColor = navigationBackgroundColor;
    [oneView addSubview:lineView];
    
    UILabel *dailyAnalysisLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame) + 10, 8, scrollView.width, 3)];
    dailyAnalysisLabel.text = @"日常分析";
   dailyAnalysisLabel.font = [UIFont systemFontOfSize:14];
    [dailyAnalysisLabel setTextColor:GlobalFontColor];
   // dailyAnalysisLabel.centerY = lineView.centerY;
    [dailyAnalysisLabel sizeToFit];
    [oneView addSubview:dailyAnalysisLabel];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [btn1 setTitleColor:GreyFontColor forState:UIControlStateNormal];
    btn1.centerY = oneView.centerY;
    [btn1 setTitle:@"按钮" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:btn1];
    
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(oneView.frame) + 10, scrollView.width, 200)];
    twoView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:twoView];
    
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(twoView.frame) + 10, scrollView.width, 300)];
    threeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:threeView];
    
    
    UIView *fourView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(threeView.frame) + 10, scrollView.width, 300)];
    fourView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:fourView];
    
    UIView *fiveView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(fourView.frame) + 10, scrollView.width, 100)];
    fiveView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:fiveView];
    
    UIView *sixView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(fiveView.frame) + 10, scrollView.width, 100)];
    sixView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:sixView];
}


- (void)selectClick{
    
}

#pragma mark - 连线按钮

- (IBAction)mendianClick:(id)sender {//  门店概况
    //隐藏TabBar
    self.hidesBottomBarWhenPushed=YES;
    SVIntelligentAnalysisDetailVC *VC = [[SVIntelligentAnalysisDetailVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    //显示tabBar
    self.hidesBottomBarWhenPushed=YES;
  
}

- (IBAction)DailyStatementClick:(id)sender {// 每日对账单
    // 给100，如果长度不够时，也可以点击
    //隐藏TabBar
    self.hidesBottomBarWhenPushed=YES;
    SVSmartAnalyseVC *tableVC = [[SVSmartAnalyseVC alloc]init];
    [self.navigationController pushViewController:tableVC animated:YES];
    //显示tabBar
    self.hidesBottomBarWhenPushed=YES;
    
}

- (IBAction)SalesFlowMeterClick:(id)sender {// 销售流水表
    
}

- (IBAction)CategoryAnalysisofClick:(id)sender {// 商品类别分析
    
}
- (IBAction)AnalysisofCommodityClick:(id)sender {// 商品销售分析
    //隐藏TabBar
    self.hidesBottomBarWhenPushed=YES;
    SVIntelligentAnalysisDetailVC *VC = [[SVIntelligentAnalysisDetailVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    //显示tabBar
    self.hidesBottomBarWhenPushed=YES;
}

- (IBAction)ReturnReportClick:(id)sender {// 退货报表
    
}

- (IBAction)RechargeReportClick:(id)sender {// 充值报表
    
}

- (IBAction)FullreportClick:(id)sender {// 充次报表
    
}

- (IBAction)MemberAnalysisClick:(id)sender {// 会员分析
    
}

- (IBAction)StatementofAccountsClick:(id)sender {// 计次报表
    
}

- (IBAction)ArrearsManagementClick:(id)sender {// 欠款管理
    
}



@end
