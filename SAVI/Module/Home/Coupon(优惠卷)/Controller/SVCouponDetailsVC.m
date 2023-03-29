//
//  SVCouponDetailsVC.m
//  SAVI
//
//  Created by houming Wang on 2018/7/11.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVCouponDetailsVC.h"
#import "SVMultiSelectVC.h"
#import "SVCouponDetailsCell.h"
#import "SVCouponDetailsModel.h"


static NSString *CouponDetailsCellID = @"CouponDetailsCell";
@interface SVCouponDetailsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray *twoModelArr;

//记录刷新次数
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger twoPage;

@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_name;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_use_conditions;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_money;
@property (weak, nonatomic) IBOutlet UILabel *Symbol;
@property (weak, nonatomic) IBOutlet UILabel *twoSymbol;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_toal_num;
@property (weak, nonatomic) IBOutlet UILabel *sv_coupon_surplus_num;
@property (weak, nonatomic) IBOutlet UILabel *alreadyUseCount;


@property (weak, nonatomic) IBOutlet UIButton *nucleusButton;


@end

@implementation SVCouponDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券详情";
    self.view.backgroundColor = BlueBackgroundColor;
    
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 257, ScreenW, ScreenH-TopHeight-257)];
//    self.tableView.backgroundColor = BlueBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVCouponDetailsCell" bundle:nil] forCellReuseIdentifier:CouponDetailsCellID];
    
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    [self getData];
    
    self.page = 1;
    self.twoPage = 1;
    [self getDataUsingState:@"0" page:1 pagesize:20];
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        //调用请求
        if (self.nucleusButton.selected == NO) {
            self.page ++;
            [self getDataUsingState:@"0" page:self.page pagesize:20];
        } else {
            self.twoPage ++;
            [self getDataUsingState:@"1" page:self.twoPage pagesize:20];
        }
        
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"发送优惠券" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self.sv_coupon_surplus_num.text isEqualToString:@"0"]) {
            [SVTool TextButtonAction:self.view withSing:@"已发放完毕"];
        } else {
            SVMultiSelectVC *VC = [[SVMultiSelectVC alloc]init];
            VC.sv_coupon_id = self.couponId;
            VC.sv_coupon_surplus_num = self.sv_coupon_surplus_num.text;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"删除优惠券" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //显示提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
        }];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [SVTool IndeterminateButtonAction:self.view withSing:nil];            
            [SVUserManager loadUserInfo];
            NSString *strURL = [URLhead stringByAppendingFormat:@"/System/DeleteCoupon?key=%@&couponId=%@",[SVUserManager shareInstance].access_token,self.couponId];
            
            [[SVSaviTool sharedSaviTool] POST:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"succeed"] integerValue] == 1) {
                    if (self.couponDetailsBlock) {
                        self.couponDetailsBlock();
                    }
                    [SVTool TextButtonAction:self.view withSing:@"删除成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
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

    }];
    // KVC 改变颜色
    [photoAction setValue:RedFontColor forKey:@"_titleTextColor"];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:videoAction];
    [alert addAction:photoAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (IBAction)nucleusBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        //待核销
        if ([SVTool isEmpty:self.twoModelArr]) {
            [SVTool IndeterminateButtonAction:self.view withSing:nil];
            [self getDataUsingState:@"1" page:1 pagesize:20];
        } else {
            [self.tableView reloadData];
        }
    } else {
        //已核销
        if ([SVTool isEmpty:self.modelArr]) {
            [SVTool IndeterminateButtonAction:self.view withSing:nil];
            [self getDataUsingState:@"0" page:1 pagesize:20];
        } else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 请求列表数据
- (void)getDataUsingState:(NSString *)usingState page:(NSInteger)page pagesize:(NSInteger)pagesize {
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/GetQueryCouponRecordInfo?key=%@&sv_coupon_id=%@&usingState=%@&queryDayType=%@&beginDate=%@&endDate=%@&page=%ld&pagesize=%ld",[SVUserManager shareInstance].access_token,self.couponId,usingState,@"-1",@"",@"",(long)page,(long)pagesize];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] intValue] == 1) {
            NSDictionary *dict = dic[@"values"];
            if (![SVTool isBlankDictionary:dict]) {
                if ([usingState isEqualToString:@"0"]) {
                    NSDictionary *countInfo = dict[@"countInfo"];
                    self.alreadyUseCount.text = [NSString stringWithFormat:@"%@",countInfo[@"alreadyUseCount"]];
                }
                
                NSArray *arr = dict[@"recordList"];
                if (![SVTool isEmpty:arr]) {
                    
                    for (NSDictionary *dicti in arr) {
                        SVCouponDetailsModel *model = [SVCouponDetailsModel mj_objectWithKeyValues:dicti];
                        if (self.nucleusButton.selected == NO) {
                            model.isdate = 0;
                            [self.modelArr addObject:model];
                        } else {
                            model.isdate = 1;
                            [self.twoModelArr addObject:model];
                        }
                    }
                    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData) {
                        /** 普通闲置状态 */
                        self.tableView.mj_footer.state = MJRefreshStateIdle;
                    }
                } else {
                    /** 所有数据加载完毕，没有更多的数据了 */
                    self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                [self.tableView reloadData];
                //是否正在刷新
                if ([self.tableView.mj_footer isRefreshing]) {
                    //结束刷新状态
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)getData {
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/GetCouponDetail?key=%@&couponId=%@",[SVUserManager shareInstance].access_token,self.couponId];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] intValue] == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSDictionary *dict = dic[@"values"];
            
            if ([dict[@"sv_coupon_type"] intValue] == 0) {
                self.type.text = @"代金券";
                self.Symbol.hidden = NO;
                self.twoSymbol.hidden = YES;
                self.icon.image = [UIImage imageNamed:@"couponD_blue"];
                 self.sv_coupon_money.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_coupon_money"]doubleValue]];
            } else {
                self.type.text = @"折扣券";
                self.Symbol.hidden = YES;
                self.twoSymbol.hidden = NO;
                self.icon.image = [UIImage imageNamed:@"couponD_violet"];
                 self.sv_coupon_money.text = [NSString stringWithFormat:@"%.2f",[dict[@"sv_coupon_money"]doubleValue] *0.1];
            }

           
            self.sv_coupon_name.text = [NSString stringWithFormat:@"%@",dict[@"sv_coupon_name"]];
            self.sv_coupon_use_conditions.text = [NSString stringWithFormat:@"满%@元可用",dict[@"sv_coupon_use_conditions"]];
            self.date.text = [NSString stringWithFormat:@"%@一%@",[dict[@"sv_coupon_bendate"] substringToIndex:10],[dict[@"sv_coupon_enddate"] substringToIndex:10]];
            
            self.sv_coupon_toal_num.text = [NSString stringWithFormat:@"%@",dict[@"sv_coupon_toal_num"]];
            self.sv_coupon_surplus_num.text = [NSString stringWithFormat:@"%@",dict[@"sv_coupon_surplus_num"]];
            
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据请求失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nucleusButton.selected == NO) {
        return self.modelArr.count;
    } else {
        return self.twoModelArr.count;
    }
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVCouponDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponDetailsCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVCouponDetailsCell" owner:nil options:nil].lastObject;
        
    }
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.nucleusButton.selected == NO) {
        cell.model = self.modelArr[indexPath.row];
    } else {
        cell.model = self.twoModelArr[indexPath.row];
    }
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableArray *)twoModelArr {
    if (!_twoModelArr) {
        _twoModelArr = [NSMutableArray array];
    }
    return _twoModelArr;
}

@end
