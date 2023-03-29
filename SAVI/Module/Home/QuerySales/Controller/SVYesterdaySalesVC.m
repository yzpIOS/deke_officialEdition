//
//  SVYesterdaySalesVC.m
//  SAVI
//
//  Created by Sorgle on 2017/6/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVYesterdaySalesVC.h"
#import "SVHistoryCell.h"
//模型
#import "SVHistoryModel.h"
//销售详情
#import "SVSellOrderVC.h"

@interface SVYesterdaySalesVC ()<UITableViewDelegate,UITableViewDataSource>

//tableView
@property (nonatomic,strong) UITableView *tableView;


/**
 模型数组
 */
@property (nonatomic,strong) NSMutableArray *modelArr;

@property (nonatomic,strong) NSMutableArray *valuesArr;
//累加的dic
@property (nonatomic,strong) NSMutableArray *orderArr;

@property (nonatomic,strong) NSMutableArray *prlistArr;

@property (nonatomic,strong) NSMutableArray *payNameArr;

//判断是否有退货
@property (nonatomic,strong) NSMutableArray *order_stutiaArr;
//判断是否有会员
@property (nonatomic,strong) NSMutableArray *user_cardnoArr;


//件数总数
@property (nonatomic,assign) float sum;
@property (nonatomic,strong) NSMutableArray *numArr;

//销售金额
@property (nonatomic,strong) NSMutableArray *order_moneyArr;


@property (weak, nonatomic) IBOutlet UILabel *sumMoney;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *num;

/**
 记录刷新次数
 */
@property (nonatomic,assign) NSInteger page;

@end

@implementation SVYesterdaySalesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    [self getThreeSourcesWithPage:1 top:1 day:-1];
    
    self.page = 1;
    //提示加载中
    [SVTool IndeterminateButtonAction:self.tableView withSing:@"加载中…"];
    [self getOrderListWithPage:1 top:20 day:-1];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVHistoryCell" bundle:nil] forCellReuseIdentifier:@"HistoryCell"];
    
    /**
     上拉刷新
     */
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        //调用请求
        [self getOrderListWithPage:self.page top:20 day:-1];
        
        
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
    
    self.tableView.mj_footer = footer;
    
    
}

-(void)getThreeSourcesWithPage:(NSInteger)page top:(NSInteger)top day:(NSInteger)day{
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *token = [defaults objectForKey:@"access_token"];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/intelligent/GetSalesListCount?key=%@&page=%li&top=%li&day=%li",token,(long)page,(long)top,(long)day];
    
    [[SVSaviTool sharedSaviTool] GET:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        NSArray *valuArr = [dic objectForKey:@"values"];
        
        //销售额
        float a = [valuArr[2] floatValue];
        self.sumMoney.text = [NSString stringWithFormat:@"%0.2f",a];
        
        //        self.sumMoney.text = [NSString stringWithFormat:@"%@",valuesArr[2] ];
        //笔数
        self.number.text = [NSString stringWithFormat:@"%@",valuArr[0]];
        //数量
        self.num.text = [NSString stringWithFormat:@"%@",valuArr[1]];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

/**
 请求数据
 */
-(void)getOrderListWithPage:(NSInteger)page top:(NSInteger)top day:(NSInteger)day{
    
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *sURL=[URLhead stringByAppendingFormat:@"/intelligent?key=%@&page=%li&top=%li&day=%li",token,(long)page,(long)top,(long)day];
    
    [[SVSaviTool sharedSaviTool] GET:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if (page == 1) {
            [self.orderArr removeAllObjects];
        }
        
        
//        if ([[dic objectForKey:@"values"] isKindOfClass:[NSArray class]]) {
//            orderArr = [dic objectForKey:@"values"];
//        }
        if (![dic[@"values"] isEqual:[NSNull null]]) {
            
            NSMutableArray *arr = [dic objectForKey:@"values"];
            //数组累加
            [self.orderArr addObjectsFromArray:arr];
            self.valuesArr = [dic objectForKey:@"values"];
            
            
            
//            if (![SVTool isEmpty:self.valuesArr]) {
            
                for (NSDictionary *dict in self.valuesArr) {
                    
                    //                self.payNameArr = dict[@"order_payment"];
                    
                    //支付方式
                    [self.payNameArr addObject:[dict objectForKey:@"order_payment"]];
                    //判断是否有退货
                    [self.order_stutiaArr addObject:[dict objectForKey:@"order_state"]];
                    //判断是否有会员sv_mr_name
                    [self.user_cardnoArr addObject:[dict objectForKey:@"sv_mr_name"]];
                    
                    //显示的金额
                    [self.order_moneyArr addObject:[dict objectForKey:@"order_money"]];
                    
                    
                    //取到字典里的数组
                    self.prlistArr = [dict objectForKey:@"prlist"];
                    
                    
                    
                    self.sum = 0;
                    
                    for (NSDictionary *diction in self.prlistArr) {
                        
                        self.sum = [diction[@"product_num"] floatValue] + self.sum;
                        
                    }
                    
                    [self.numArr  addObject:[NSString stringWithFormat:@"%.f",self.sum]];
                    
                    //取到数组里的字典
                    NSDictionary *b = [self.prlistArr firstObject];
                    
                    
                    //给模型赋值
                    SVHistoryModel *model = [SVHistoryModel mj_objectWithKeyValues:b];
                    
                    //添加到模型数组中
                    [self.modelArr addObject:model];//这里有一个报错 2017.12.23 
                    
                }
                
                
//            }
            //一定要记得刷新tableView的数据
            [self.tableView reloadData];
            
        } else {
            /** 所有数据加载完毕，没有更多的数据了 */
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        
        //是否正在刷新
        if ([self.tableView.mj_footer isRefreshing]) {
            //结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }

        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        
    }];
    
    
}

#pragma mark - tableVeiw

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVHistoryCell" owner:nil options:nil].lastObject;
    }
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //用模型数组给cell赋值
    cell.historyModel = self.modelArr[indexPath.row];
    
    cell.unitprice.text = [NSString stringWithFormat:@"%.2f",[self.order_moneyArr[indexPath.row] floatValue]];
    
//    cell.pay.text = self.payNameArr[indexPath.row];
    
    cell.number.text = self.numArr[indexPath.row];
    
    if ([cell.number.text integerValue] > 1) {
        
        cell.more.layer.cornerRadius = 4;
        cell.more.layer.masksToBounds = YES;
        cell.more.hidden = NO;
        cell.more.backgroundColor = RGBA(188, 213, 249, 1);
        cell.more.text = [NSString stringWithFormat:@"%@",@"多笔"];
        
    } else {
        
        cell.more.hidden = YES;
        
    }
    
    NSString *state = [NSString stringWithFormat:@"%@",self.order_stutiaArr[indexPath.row]];
    float stateNum = [state floatValue];
    if (stateNum == 0) {
        cell.returnWares.hidden = YES;
    } else if (stateNum == 1){
        cell.returnWares.text = @"部分退货";
        cell.returnWares.hidden = NO;
    }else if (stateNum == 2){
        cell.returnWares.text = @"整单退货";
        cell.returnWares.hidden = NO;
    }
    
    cell.pay.layer.cornerRadius = 4;
    cell.pay.layer.masksToBounds = YES;
    if ([SVTool isBlankString:self.user_cardnoArr[indexPath.row]]) {
        cell.pay.text = [NSString stringWithFormat:@"%@",@"散客"];
        cell.pay.backgroundColor = RGBA(222, 208, 254, 1);
    } else {
        cell.pay.text = [NSString stringWithFormat:@"%@",self.user_cardnoArr[indexPath.row]];
        cell.pay.backgroundColor = RGBA(253, 212, 167, 1);
    }
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVSellOrderVC *VC = [[SVSellOrderVC alloc]init];
    
    //    VC.valuesArr = self.valuesArr[indexPath.row];
    
//    VC.dic = self.orderArr[indexPath.row];
    //跳转界面有导航栏的
    [self.navigationController pushViewController:VC animated:YES];
    
    
}


#pragma mark - 懒加载

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, ScreenW, ScreenH - 155)];
        _tableView.tableFooterView = [[UIView alloc]init];
        //指定代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableArray *)valuesArr{
    if (!_valuesArr) {
        _valuesArr = [NSMutableArray array];
    }
    return _valuesArr;
}

-(NSMutableArray *)prlistArr{
    if (!_prlistArr) {
        _prlistArr = [NSMutableArray array];
    }
    return _prlistArr;
}

-(NSMutableArray *)payNameArr{
    if (!_payNameArr) {
        _payNameArr = [NSMutableArray array];
    }
    return _payNameArr;
}

-(NSMutableArray *)numArr{
    if (!_numArr) {
        _numArr = [NSMutableArray array];
    }
    return _numArr;
}

-(NSMutableArray *)order_stutiaArr{
    if (!_order_stutiaArr) {
        _order_stutiaArr = [NSMutableArray array];
    }
    return _order_stutiaArr;
}

-(NSMutableArray *)user_cardnoArr{
    if (!_user_cardnoArr) {
        _user_cardnoArr = [NSMutableArray array];
    }
    return _user_cardnoArr;
}

-(NSMutableArray *)orderArr{
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}

-(NSMutableArray *)order_moneyArr{
    if (!_order_moneyArr) {
        _order_moneyArr = [NSMutableArray array];
    }
    return _order_moneyArr;
}

@end
