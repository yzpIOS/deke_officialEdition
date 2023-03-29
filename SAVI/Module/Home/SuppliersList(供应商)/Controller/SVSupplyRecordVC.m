//
//  SVSupplyRecordVC.m
//  SAVI
//
//  Created by Sorgle on 2017/12/26.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSupplyRecordVC.h"
//cell
#import "SVSupplyRecordCell.h"

static NSString *SupplyRecordCellID = @"SupplyRecordCell";

@interface SVSupplyRecordVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *total;

@property (nonatomic,strong) NSMutableArray *modelArr;

//记录刷新次数
@property (nonatomic,assign) NSInteger page;

@end

@implementation SVSupplyRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"供应记录";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, ScreenW, ScreenH-64-45)];
    //取消tableView的选中
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVSupplyRecordCell" bundle:nil] forCellReuseIdentifier:SupplyRecordCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    self.page = 1;
    [self requestDataID:self.sv_suid Index:1 pageSize:20 date:nil day:nil];
    
    
    
    /**
     上拉刷新
     */
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        
        self.page ++;
        //调用请求
        [self requestDataID:self.sv_suid Index:self.page pageSize:20 date:nil day:nil];
        
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

# pragma mark - 请求数据
-(void)requestDataID:(NSString *)ID Index:(NSInteger)pageIndex pageSize:(NSInteger)pageSize date:(NSString *)date day:(NSString *)day{
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/GetSupplierHistoryList?key=%@&sv_suid=%@&page=%ld&top=%ld",token,ID,(long)pageIndex,(long)pageSize];
    
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        NSDictionary *dict = dic[@"values"];
        NSMutableArray *Arr = dict[@"dataList"];
        //NSDictionary *diction = [Arr firstObject];
        //供应次数
        self.total.text = [NSString stringWithFormat:@"%@",dict[@"total"]];
        
        if (![SVTool isEmpty:Arr]) {
            
            for (NSDictionary *diction in Arr) {
                
                NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
                [dataDict setObject:diction[@"sv_pc_cdate"] forKey:@"sv_pc_cdate"];
                [dataDict setObject:diction[@"sv_pc_noid"] forKey:@"sv_pc_noid"];
                [dataDict setObject:diction[@"sv_pc_total"] forKey:@"sv_pc_total"];
                [dataDict setObject:diction[@"sv_pr_totalnum"] forKey:@"sv_pr_totalnum"];
                [dataDict setObject:diction[@"prlist"] forKey:@"prlist"];
                
                [self.modelArr addObject:dataDict];
            }
            
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
}

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVSupplyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:SupplyRecordCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVSupplyRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SupplyRecordCellID];
    }
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = self.modelArr[indexPath.row];
    
    cell.sv_pc_noid.text = dic[@"sv_pc_noid"];
    cell.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[dic[@"sv_pc_total"] floatValue]];
    cell.sv_pr_totalnum.text = [NSString stringWithFormat:@"%@",dic[@"sv_pr_totalnum"]];
    //显示时间
    NSString *timeString = dic[@"sv_pc_cdate"];
    cell.date.text = [timeString substringToIndex:10];
    cell.time.text = [timeString substringWithRange:NSMakeRange(11, 8)];
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    SVSupplierDetailsVC *VC = [[SVSupplierDetailsVC alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];

    
    
}


#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
