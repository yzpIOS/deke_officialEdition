//
//  SVCouponVC.m
//  SAVI
//
//  Created by houming Wang on 2018/7/9.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVCouponVC.h"
#import "SVaddCouponVC.h"
#import "SVCouponDetailsVC.h"
#import "SVHairCouponVC.h"

#import "SVCouponListCell.h"
#import "SVCouponListModel.h"


static NSString *CouponListCellID = @"CouponListCell";
@interface SVCouponVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;
//记录刷新次数
@property (nonatomic,assign) NSInteger page;

@end

@implementation SVCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
    self.hidesBottomBarWhenPushed = YES;
    
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"发券" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"SVCouponListCell" bundle:nil] forCellReuseIdentifier:CouponListCellID];
    
    self.page = 1;
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    [self getDataPage:@"1" top:@"20" seachStr:@"" couponState:@"-1"];
    
    /**
     下拉刷新
     */
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.page = 1;
        //调用请求
        [self getDataPage:@"1" top:@"20" seachStr:@"" couponState:@"-1"];
        
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
    // 设置颜色
    header.stateLabel.textColor = [UIColor grayColor];
    // 设置正在刷新状态的动画图片
    [header setImages:[SVTool MJRefreshAnimateArray] forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
    
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
    SVHairCouponVC *VC = [[SVHairCouponVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 请求列表数据
- (void)getDataPage:(NSString *)page top:(NSString *)top seachStr:(NSString *)seachStr couponState:(NSString *)couponState {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/GetCouponPageList?key=%@&pageIndex=%@&pageSize=%@&seachStr=%@&couponState=%@",[SVUserManager shareInstance].access_token,page,top,seachStr,couponState];
    
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
            if ([self.tableView.mj_header isRefreshing]) {
                //结束刷新状态
                [self.tableView.mj_header endRefreshing];
            }
            
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
    return 70;
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *oneHeaderView = [[UIView alloc]init];
    oneHeaderView.backgroundColor = BlueBackgroundColor;
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, ScreenW-20, 50)];
    [addButton setBackgroundColor:[UIColor whiteColor]];
    [addButton setTitle:@"添加优惠券" forState:UIControlStateNormal];
    [addButton setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    [addButton setTitleColor:BlueBackgroundColor forState:UIControlStateHighlighted];
//    [addButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [addButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    //添加边框
    addButton.layer.cornerRadius = 6;
    CALayer * layer = [addButton layer];
    layer.borderColor = [navigationBackgroundColor CGColor];
    layer.borderWidth = 0.5f;
    [addButton addTarget:self action:@selector(jumpSmallClass) forControlEvents:UIControlEventTouchUpInside];
    [oneHeaderView addSubview:addButton];
    return oneHeaderView;
}

-(void)jumpSmallClass {
    SVaddCouponVC *VC = [[SVaddCouponVC alloc]init];
    __weak typeof(self) weakSelf = self;
    VC.addCouponBlock = ^{
        weakSelf.page = 1;
        [weakSelf getDataPage:@"1" top:@"20" seachStr:@"" couponState:@"-1"];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVCouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponListCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVTimesCountCell" owner:nil options:nil].lastObject;
        
    }
    cell.selectIcon.hidden = YES;
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.userInteractionEnabled = NO;
    
    cell.model = self.modelArr[indexPath.row];
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
    
}

/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SVCouponListModel *model = self.modelArr[indexPath.row];
    SVCouponDetailsVC *VC = [[SVCouponDetailsVC alloc]init];
    VC.couponId = model.sv_coupon_id;
    __weak typeof(self) weakSelf = self;
    VC.couponDetailsBlock = ^{
        weakSelf.page = 1;
        [weakSelf getDataPage:@"1" top:@"20" seachStr:@"" couponState:@"-1"];
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 滑动删除 Cell
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
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
    
    //如果编辑样式为删除样式
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row<[self.modelArr count]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVUserManager loadUserInfo];
                SVCouponListModel *model = self.modelArr[indexPath.row];
                NSString *strURL = [URLhead stringByAppendingFormat:@"/System/DeleteCoupon?key=%@&couponId=%@",[SVUserManager shareInstance].access_token,model.sv_coupon_id];
                
                [[SVSaviTool sharedSaviTool] POST:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    
                    if ([dic[@"succeed"] integerValue] == 1) {
                        
                        //移除数据源的数据
                        [self.modelArr removeObjectAtIndex:indexPath.row];
                        
                        //移除tableView中的数据
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        
                        [self.tableView reloadData];
                        
                    } else {
                        [SVTool TextButtonAction:self.view withSing:@"删除失败"];
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
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
