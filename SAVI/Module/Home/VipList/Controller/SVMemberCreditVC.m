//
//  SVMemberCreditVC.m
//  SAVI
//
//  Created by houming Wang on 2020/11/24.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVMemberCreditVC.h"
#import "SVMembercreditCell.h"
#import "SVMemberCreditModel.h"
#import "YCMenuView.h"

static NSString *const ID = @"SVMembercreditCell";
@interface SVMemberCreditVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * valuesArray;
@property (nonatomic,strong) NSMutableArray * selectArr;

@property (weak, nonatomic) IBOutlet UILabel *RepaymentAmount;


@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *yinhangkaBtn;
@property (weak, nonatomic) IBOutlet UIButton *xianjinBtn;
@property (nonatomic,strong) UIButton * rightBtn;

@property (weak, nonatomic) IBOutlet UITableView *twoTableView;
@property (nonatomic,strong) NSMutableArray * actionArray;
@property (nonatomic ,assign) BOOL selected;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (nonatomic,strong) NSMutableArray * repayment;
@end

@implementation SVMemberCreditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员赊账";
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVMembercreditCell" bundle:nil] forCellReuseIdentifier:ID];
    
    self.twoTableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.twoTableView setSeparatorColor:cellSeparatorColor];
    [self.twoTableView registerNib:[UINib nibWithNibName:@"SVMembercreditCell" bundle:nil] forCellReuseIdentifier:ID];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"待还款" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];

    rightBtn.frame = CGRectMake(0, 0, 80, 30);
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rightBtn addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
 
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn setTitleColor:GlobalFontColor forState:UIControlStateNormal];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -rightBtn.imageView.frame.size.width - rightBtn.frame.size.width + rightBtn.titleLabel.frame.size.width, 0, 0);
      
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -rightBtn.titleLabel.frame.size.width - rightBtn.frame.size.width + rightBtn.imageView.frame.size.width);
        self.navigationItem.rightBarButtonItem = rightBarItem;
    self.rightBtn = rightBtn;
  //  SVMembercreditCell
    [self loadUser_SiblingsGetArrearsList];
    
    [self loadUser_SiblingsGetRepaymentList];
   
}
- (void)collection:(UIButton *)btn{
    [UIView animateWithDuration:.3 animations:^{
        //旋转
        self.rightBtn.imageView.transform = CGAffineTransformRotate(self.rightBtn.imageView.transform, M_PI);
    }];
    

    if ([self.rightBtn.titleLabel.text isEqualToString:@"待还款"]) {
      
        [self.actionArray removeAllObjects];
         //  for (NSDictionary *dic in self.listArray) {
                     YCMenuAction *action = [YCMenuAction actionWithTitle:@"已还款" image:nil handler:^(YCMenuAction *action) {
    //                     self.user_id = dict[@"user_id"];
    //                     self.navigationItem.rightBarButtonItem.title = dict[@"sv_us_name"];
    //                      self.navTitleView.nameText.text = dic[@"sv_us_name"];
    //                     [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyNameAllStore" object:nil userInfo:dic];
    //                     调用请求
    //                     [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
                         [self.rightBtn setTitle:@"已还款" forState:UIControlStateNormal];
                         self.twoView.hidden = NO;
                     }];
                     [self.actionArray addObject:action];
    }else{
      
        [self.actionArray removeAllObjects];
         //  for (NSDictionary *dic in self.listArray) {
                     YCMenuAction *action = [YCMenuAction actionWithTitle:@"待还款" image:nil handler:^(YCMenuAction *action) {
    //                     self.user_id = dict[@"user_id"];
    //                     self.navigationItem.rightBarButtonItem.title = dict[@"sv_us_name"];
    //                      self.navTitleView.nameText.text = dic[@"sv_us_name"];
    //                     [[NSNotificationCenter defaultCenter] postNotificationName:@"nitifyNameAllStore" object:nil userInfo:dic];
    //                     调用请求
    //                     [self getDataPage:self.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" user_id:self.user_id];
                         [self.rightBtn setTitle:@"待还款" forState:UIControlStateNormal];
                         self.twoView.hidden = YES;
                     }];
                     [self.actionArray addObject:action];
    }
    
    YCMenuView *view = [YCMenuView menuWithActions:self.actionArray width:100 atPoint:CGPointMake(ScreenW - 30,TopHeight)];
         [view show];
}
///api/User_Siblings/GetRepaymentList
#pragma mark - 已还款
- (void)loadUser_SiblingsGetRepaymentList{
    [SVUserManager loadUserInfo];
    NSString *url = [URLhead stringByAppendingFormat:@"/api/User_Siblings/GetRepaymentList?key=%@&memberid=%@",[SVUserManager shareInstance].access_token,self.member_id];
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"已还款dic ===%@",dic);
        NSString *msg=[NSString stringWithFormat:@"%@",dic[@"errmsg"]];
        if ([dic[@"succeed"] intValue] == 1) {
            [self.repayment removeAllObjects];
            NSArray *valuesArray = dic[@"values"];
            for (NSDictionary*dict in valuesArray) {
                SVMemberCreditModel *model = [SVMemberCreditModel mj_objectWithKeyValues:dict];
              //  model.isSelected = NO;
                [self.repayment addObject:model];
            }
        }else{
            [SVTool TextButtonAction:self.view withSing:msg?:@"请求失败"];
        }
        [self.twoTableView reloadData];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}

- (void)loadUser_SiblingsGetArrearsList{
    [SVUserManager loadUserInfo];
    NSString *url = [URLhead stringByAppendingFormat:@"/api/User_Siblings/GetArrearsList?key=%@&memberid=%@",[SVUserManager shareInstance].access_token,self.member_id];
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic ===%@",dic);
        NSString *msg=[NSString stringWithFormat:@"%@",dic[@"errmsg"]];
        if ([dic[@"succeed"] intValue] == 1) {
            [self.valuesArray removeAllObjects];
            NSArray *valuesArray = dic[@"values"];
            for (NSDictionary*dict in valuesArray) {
                SVMemberCreditModel *model = [SVMemberCreditModel mj_objectWithKeyValues:dict];
                model.isSelected = NO;
                [self.valuesArray addObject:model];
            }
        }else{
            [SVTool TextButtonAction:self.view withSing:msg?:@"请求失败"];
        }
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}
#pragma mark - 现金
- (IBAction)xianjinClick:(id)sender {
 
    [self loadjiesuanMethodName:@"现金支付"];
}
#pragma mark - 银行卡
- (IBAction)yinhangkaClick:(id)sender {
    [self loadjiesuanMethodName:@"银行卡支付"];
}
#pragma mark - 微信
- (IBAction)weixinClickj:(id)sender {
    [self loadjiesuanMethodName:@"微信支付"];
}
#pragma mark - 支付宝
- (IBAction)zhifubaoClick:(id)sender {
    [self loadjiesuanMethodName:@"支付宝支付"];
}


- (void)loadjiesuanMethodName:(NSString *)methodName{
    if (kArrayIsEmpty(self.selectArr)) {
        [SVTool TextButtonAction:self.view withSing:@"请先选择账单"];
    }else{
        [SVTool IndeterminateButtonAction:self.view withSing:@"支付中…"];
        self.yinhangkaBtn.userInteractionEnabled = NO;
        self.xianjinBtn.userInteractionEnabled = NO;
        self.zhifubaoBtn.userInteractionEnabled = NO;
        self.zhifubaoBtn.userInteractionEnabled = NO;
        NSMutableArray *array = [NSMutableArray array];
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
        
        for (NSMutableDictionary *dictM in self.selectArr) {
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            parame[@"maximum"] = dictM[@"maximum"];
            parame[@"memberid"] = dictM[@"memberid"];
            parame[@"money"] = dictM[@"order_money"];
            parame[@"orderId"] = dictM[@"orderId"];
            parame[@"sv_date"] = [NSString stringWithFormat:@"%@",dateString];
            parame[@"sv_money"] = dictM[@"order_money"];
            parame[@"sv_payment_method_name"] = methodName;
            [array addObject:parame];
        }
        [SVUserManager loadUserInfo];
        
        NSString *url = [URLhead stringByAppendingFormat:@"/api/User_Siblings/Repayment?key=%@",[SVUserManager shareInstance].access_token];
        [[SVSaviTool sharedSaviTool] POST:url parameters:array progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"总店dic = %@",dic);
            NSString *errmsg = dic[@"errmsg"];
            if ([dic[@"succeed"] integerValue] == 1) {
                [SVTool TextButtonAction:self.view withSing:@"还款成功"];
                [self.selectArr removeAllObjects];
                [self loadUser_SiblingsGetArrearsList];
                [self loadUser_SiblingsGetRepaymentList];
                self.RepaymentAmount.text = @"0.00";
                if (self.successBlock) {
                    self.successBlock();
                }
                
            }else{
                [SVTool TextButtonAction:self.view withSing:errmsg?:@"支付失败"];
            }
            
            self.yinhangkaBtn.userInteractionEnabled = YES;
            self.xianjinBtn.userInteractionEnabled = YES;
            self.zhifubaoBtn.userInteractionEnabled = YES;
            self.zhifubaoBtn.userInteractionEnabled = YES;
//            //隐藏提示框
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                self.yinhangkaBtn.userInteractionEnabled = YES;
                self.xianjinBtn.userInteractionEnabled = YES;
                self.zhifubaoBtn.userInteractionEnabled = YES;
                self.zhifubaoBtn.userInteractionEnabled = YES;
                //隐藏提示框
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.valuesArray.count;
    }else{
        return self.repayment.count;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        SVMembercreditCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[SVMembercreditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        SVMemberCreditModel *model = self.valuesArray[indexPath.row];
        cell.valuesArray = self.valuesArray;
        cell.indexRow = indexPath.row;
        cell.order_money2.tag = indexPath.row;
        cell.model = model;
        __weak typeof(self) weakSelf = self;
       
        cell.order_moneyAndBlock = ^(NSInteger indexRow, NSString * _Nonnull order_money) {
            SVMemberCreditModel *model = weakSelf.valuesArray[indexRow];
            model.sv_credit_money = order_money;

            for (NSMutableDictionary *dict in weakSelf.selectArr) {
                if ([dict[@"indexRow"] integerValue] == indexRow) {
                    dict[@"order_money"] = order_money;
                }

            }
            NSLog(@"4444weakSelf.selectArr:%@",weakSelf.selectArr);
           // NSInteger selectedIndex = 0;
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:indexRow inSection:0];
            [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
            [weakSelf.tableView reloadData];
        };
        
        float order_money = 0.00;
        for (NSMutableDictionary *dictM in self.selectArr) {
            order_money +=[dictM[@"order_money"] doubleValue];
        }
        
        self.RepaymentAmount.text = [NSString stringWithFormat:@"%.2f",order_money];
        return cell;
    }else{
        SVMembercreditCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[SVMembercreditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        SVMemberCreditModel *model = self.repayment[indexPath.row];
        cell.model2 = model;
        return cell;
    }
  
    
    
    
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{

    if (tableView == self.tableView) {
        SVMemberCreditModel *model = self.valuesArray[indexPath.row];
       // SVMembercreditCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        model.isSelected = !model.isSelected;
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        dictM[@"indexRow"] = [NSString stringWithFormat:@"%ld",indexPath.row];
        dictM[@"maximum"] = [NSString stringWithFormat:@"%@",model.order_money2];
        dictM[@"memberid"] = [NSString stringWithFormat:@"%@",model.sv_member_id];
        dictM[@"money"] = [NSString stringWithFormat:@"%@",model.order_money];
        dictM[@"orderId"] = [NSString stringWithFormat:@"%@",model.sv_mw_order_id];
       // dictM[@"sv_date"] = [NSString stringWithFormat:@"%@",model.sv_date];
        dictM[@"sv_money"] = [NSString stringWithFormat:@"%@",model.order_money];
        dictM[@"order_money"] = [NSString stringWithFormat:@"%@",model.sv_credit_money];
  
        if (model.isSelected == YES) {
            [self.selectArr addObject:dictM];
            NSLog(@"add money:%@",model.order_money);
            NSLog(@"add arr:%@",self.selectArr);
        }else{
            [self.selectArr removeObject:dictM];
            NSLog(@"reduce money:%@",model.order_money);
            NSLog(@"reduce arr:%@",self.selectArr);
        }
        
        double order_money = 0.00;
        for (NSMutableDictionary *dictM in self.selectArr) {
            order_money +=[dictM[@"order_money"] doubleValue];
        }
        
        self.RepaymentAmount.text = [NSString stringWithFormat:@"%.2f",order_money];
        [self.tableView reloadData];
    }

}


- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)valuesArray
{
    if (!_valuesArray) {
        _valuesArray = [NSMutableArray array];
    }
    return _valuesArray;
}

- (NSMutableArray *)actionArray
{
    if (!_actionArray) {
        _actionArray = [NSMutableArray array];
    }
    return _actionArray;
}

- (NSMutableArray *)repayment
{
    if (!_repayment) {
        _repayment = [NSMutableArray array];
    }
    return _repayment;
}

@end
