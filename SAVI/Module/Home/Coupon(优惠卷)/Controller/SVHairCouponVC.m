//
//  SVHairCouponVC.m
//  SAVI
//
//  Created by houming Wang on 2018/7/12.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVHairCouponVC.h"
#import "SVHairCouponCell.h"
#import "SVCouponListModel.h"
#import "SVMultiSelectVC.h"

static NSString *HairCouponCellID = @"HairCouponCell";
@interface SVHairCouponVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,copy) NSString *couponId;
@property (nonatomic,copy) NSString *sv_coupon_surplus_num;

@end

@implementation SVHairCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发券";
    
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight)];
    self.tableView.backgroundColor = BlueBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //完全没有线   这样就不会显示自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVHairCouponCell" bundle:nil] forCellReuseIdentifier:HairCouponCellID];
    
    self.page = 1;
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    [self getDataPage:@"1" top:@"20" seachStr:@"" couponState:@"-1"];
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        self.page ++;
        //调用请求
        [self getDataPage:[NSString stringWithFormat:@"%ld",(long)self.page] top:@"20" seachStr:@"" couponState:@"-1"];
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
    
    self.tableView.mj_footer.hidden = YES;
    
    self.tableView.mj_footer = footer;
}

-(void)rightbuttonResponseEvent {
    
    if ([SVTool isBlankString:self.couponId]) {
        [SVTool TextButtonAction:self.view withSing:@"请选择优惠券"];
        return;
    }
    
    SVMultiSelectVC *VC = [[SVMultiSelectVC alloc]init];
    VC.sv_coupon_id = self.couponId;
    VC.sv_coupon_surplus_num = self.sv_coupon_surplus_num;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 请求列表数据
- (void)getDataPage:(NSString *)page top:(NSString *)top seachStr:(NSString *)seachStr couponState:(NSString *)couponState {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/GetCouponPageList?key=%@&pageIndex=%@&pageSize=%@&seachStr=%@&couponState=%@",[SVUserManager shareInstance].access_token,page,top,seachStr,couponState];
  //  NSLog(@"url---%@",urlStr);
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if (self.page == 1) {
            [self.modelArr removeAllObjects];
        }
        if ([dic[@"succeed"] intValue] == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![SVTool isEmpty:dic[@"values"]]) {
                for (NSDictionary *dict in dic[@"values"]) {
                    SVCouponListModel *model = [SVCouponListModel mj_objectWithKeyValues:dict];
                    [self.modelArr addObject:model];
                }
                if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                    /** 普通闲置状态 */
                    self.tableView.mj_footer.state = MJRefreshStateIdle;
                }
            } else {
                
                /** 所有数据加载完毕，没有更多的数据了 */
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                //                //提示没有供应商
                //                if (self.modelArr.count == 0) {
                //                    self.noLabel.hidden = NO;
                //                }
                
            }
            
            [self.tableView reloadData];
            
            //是否正在刷新
            if ([self.tableView.mj_footer isRefreshing]) {
                //结束刷新状态
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}
#pragma mark - tableVeiw
//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *oneHeaderView = [[UIView alloc]init];
    return oneHeaderView;
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVHairCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:HairCouponCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVHairCouponCell" owner:nil options:nil].lastObject;
        
    }
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // [cell.selectedBtn setEnabled:NO];
    
    cell.model = self.modelArr[indexPath.row];
    if ([cell.model.sv_coupon_surplus_num isEqualToString:@"0"]) {
        //设置cell不能点击
        cell.userInteractionEnabled = NO;
    } else {
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}

/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SVHairCouponCell *cell = (SVHairCouponCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectIcon.image = [UIImage imageNamed:@"ic_yixuan.png"];
    
    SVCouponListModel *model = self.modelArr[indexPath.row];
    self.couponId = model.sv_coupon_id;
    self.sv_coupon_surplus_num = model.sv_coupon_surplus_num;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    SVHairCouponCell *cell = (SVHairCouponCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectIcon.image = [UIImage imageNamed:@"ic_mo-ren"];
}


#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}


@end
