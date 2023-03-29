//
//  SVRepaymentVC.m
//  SAVI
//
//  Created by houming Wang on 2018/6/26.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVRepaymentVC.h"

#import "SVRepaymentListCell.h"

#import "SVRepaymentModel.h"

static NSString *RepaymentCellID = @"RepaymentCell";
@interface SVRepaymentVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UIButton *oneButton;
@property (nonatomic,strong) UIButton *twoButton;
@property (nonatomic,strong) UIView *oneView;
@property (nonatomic,strong) UIView *twoView;

@property (nonatomic,strong) UIButton *footerButton;
@property (nonatomic,strong) UITextField *textFieldMoney;
@property (nonatomic,strong) UIView *whiteView;

//tableView
@property (nonatomic,strong) UITableView *tableView;
//模型数组
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray *twoModelArr;
@property (nonatomic,strong) NSArray *dataAry;

@property (nonatomic,assign) float sumMoney;
@property (nonatomic,assign) float textValue;
@property (nonatomic,assign) int buttonNumber;

@end

@implementation SVRepaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"会员账单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.oneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW/2, 45)];
    self.oneButton.backgroundColor = [UIColor whiteColor];
    [self.oneButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.oneButton setTitle:@"待收款" forState:UIControlStateNormal];
    [self.oneButton setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    [self.oneButton addTarget:self action:@selector(oneButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.oneButton];

    self.oneView = [[UIView alloc] init];
    self.oneView.backgroundColor = navigationBackgroundColor;
    [self.oneButton addSubview:self.oneView];
    [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW/4, 2));
        make.centerX.mas_equalTo(self.oneButton.mas_centerX);
        make.bottom.equalTo(self.oneButton.mas_bottom);
    }];

    self.twoButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW/2, 0, ScreenW/2, 45)];
    self.twoButton.backgroundColor = [UIColor whiteColor];
    [self.twoButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [self.twoButton setTitle:@"已收款" forState:UIControlStateNormal];
    [self.twoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.twoButton addTarget:self action:@selector(twoButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.twoButton];

    self.twoView = [[UIView alloc] init];
//    self.twoView.backgroundColor = BackgroundColor;
    [self.twoButton addSubview:self.twoView];
    [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW/4, 2));
        make.centerX.mas_equalTo(self.twoButton.mas_centerX);
        make.bottom.equalTo(self.twoButton.mas_bottom);
    }];
    
    //线
    UIView *oneThreadView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, ScreenW, 0.5)];
    oneThreadView.backgroundColor = threadColor;
    [self.view addSubview:oneThreadView];
    UIView *twoThreadView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH - TopHeight - 70, ScreenW, 0.5)];
    twoThreadView.backgroundColor = threadColor;
    [self.view addSubview:twoThreadView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45.5, ScreenW, ScreenH-TopHeight-45.5-70)];
    self.tableView.backgroundColor = BlueBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //完全没有线   这样就不会显示自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVRepaymentListCell" bundle:nil] forCellReuseIdentifier:RepaymentCellID];
    
    //footerButton
    self.footerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.footerButton.frame = CGRectMake(10, ScreenH - TopHeight - 60, ScreenW-20, 50);
    self.footerButton.layer.cornerRadius = 10;
    [self.footerButton setTitle:@"还款" forState:UIControlStateNormal];
    self.footerButton.backgroundColor = NOEnabledButtonColor;
    [self.footerButton setTitleColor:NOEnabledButtonTextColor forState:UIControlStateNormal];
    [self.footerButton setEnabled:NO];
    [self.footerButton addTarget:self action:@selector(footerButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footerButton];
    
    self.sumMoney = 0;
    self.textValue = 0;
    self.buttonNumber = 1;
    [SVTool IndeterminateButtonAction:self.view withSing:@""];
    [self GetArrearsList];
    [self GetRepaymentList];
    
}

-(void)oneButtonResponseEvent {
    self.oneView.backgroundColor = navigationBackgroundColor;
    [self.oneButton setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    self.twoView.backgroundColor = [UIColor whiteColor];
    [self.twoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.buttonNumber = 1;
    self.whiteView.hidden = NO;
    [self.tableView reloadData];
    
    [UIView animateWithDuration:.2 animations:^{
        self.tableView.frame = CGRectMake(0, 45.5, ScreenW, ScreenH-TopHeight-45.5-70);
        self.footerButton.frame = CGRectMake(10, ScreenH - TopHeight - 60, ScreenW-20, 50);
    }];
}

-(void)twoButtonResponseEvent {
    self.twoView.backgroundColor = navigationBackgroundColor;
    [self.twoButton setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    self.oneView.backgroundColor = [UIColor whiteColor];
    [self.oneButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.buttonNumber = 2;
    [self.textFieldMoney resignFirstResponder];//移除第一响应者
    self.whiteView.hidden = YES;
    [self.tableView reloadData];
    
    [UIView animateWithDuration:.2 animations:^{
        self.tableView.frame = CGRectMake(0, 45.5, ScreenW, ScreenH-TopHeight-45.5);
        self.footerButton.frame = CGRectMake(10, ScreenH, ScreenW-20, 50);
    }];
}

#pragma mark - 还款
-(void)footerButtonResponseEvent {
    
    if ([SVTool isBlankString:self.textFieldMoney.text] || [self.textFieldMoney.text floatValue] == 0) {
        [SVTool TextButtonAction:self.view withSing:@"还款金额不能为0"];
        return;
    }
    
    [self.footerButton setEnabled:NO];
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    
    float money = [self.textFieldMoney.text floatValue];
    NSMutableArray *arr = [NSMutableArray array];
    for (SVRepaymentModel *model in self.dataAry) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (money == 0) {
            [dic setObject:@"0" forKey:@"money"];
            [dic setObject:@"0" forKey:@"sv_money"];
        } else if ([model.sv_credit_money floatValue] > money) {
            [dic setObject:[NSString stringWithFormat:@"%f",money] forKey:@"money"];
            [dic setObject:[NSString stringWithFormat:@"%f",money] forKey:@"sv_money"];
            money = money - money;
        } else if ([model.sv_credit_money floatValue] <= money) {
            [dic setObject:model.sv_credit_money forKey:@"money"];
            [dic setObject:model.sv_credit_money forKey:@"sv_money"];
            money = money - [model.sv_credit_money floatValue];
        }
        [dic setObject:model.order_id forKey:@"orderId"];
        [dic setObject:self.member_id forKey:@"memberid"];
        [dic setObject:@"现金" forKey:@"sv_payment_method_name"];
        [dic setObject:@"" forKey:@"sv_note"];
        [dic setObject:@"" forKey:@"sv_operator"];
        [dic setObject:model.sv_credit_money forKey:@"maximum"];
        
        [arr addObject:dic];
    }
    
    [SVUserManager loadUserInfo];
    NSString *sURL=[URLhead stringByAppendingFormat:@"/api/User_Siblings/Repayment?key=%@",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:arr progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] intValue] == 1) {
            self.sumMoney = 0;
            self.textValue = 0;
            [self.modelArr removeAllObjects];
            [self.twoModelArr removeAllObjects];
            [self GetArrearsList];
            [self GetRepaymentList];
            self.footerButton.backgroundColor = NOEnabledButtonColor;
            [self.footerButton setTitleColor:NOEnabledButtonTextColor forState:UIControlStateNormal];
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVTool TextButtonAction:self.view withSing:@"还款成功"];
            });
        } else {
            [self.footerButton setEnabled:YES];
            [SVTool TextButtonAction:self.view withSing:@"数据错误,还款失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.footerButton setEnabled:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

-(void)GetArrearsList{
    [SVUserManager loadUserInfo];
    NSString *sURL=[URLhead stringByAppendingFormat:@"/api/User_Siblings/GetArrearsList?key=%@&memberid=%@",[SVUserManager shareInstance].access_token,self.member_id];

    [[SVSaviTool sharedSaviTool] GET:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] intValue] == 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSDictionary *dict in dic[@"values"]) {
                SVRepaymentModel *model = [SVRepaymentModel mj_objectWithKeyValues:dict];
                [self.modelArr addObject:model];
            }
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据错误,请求失败"];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

-(void)GetRepaymentList{
    
    [SVUserManager loadUserInfo];
    NSString *sURL=[URLhead stringByAppendingFormat:@"/api/User_Siblings/GetRepaymentList?key=%@&memberid=%@",[SVUserManager shareInstance].access_token,self.member_id];
    
    [[SVSaviTool sharedSaviTool] GET:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] intValue] == 1) {
            if (![SVTool isEmpty:dic[@"values"]]) {
                for (NSDictionary *dict in dic[@"values"]) {
                    SVRepaymentModel *model = [SVRepaymentModel mj_objectWithKeyValues:dict];
                    [self.twoModelArr addObject:model];
                }
            }
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据错误,请求失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - tableVeiw
//让section头部不停留在顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.buttonNumber == 1) {
        CGFloat sectionHeaderHeight = 140;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    } else {
        CGFloat sectionHeaderHeight = 5;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.buttonNumber == 1) {
        return 140;
    } else {
        return 5;
    }
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *oneHeaderView = [[UIView alloc]init];
    if (self.buttonNumber == 1) {
        self.whiteView = [[UIView alloc]init];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.layer.cornerRadius = 10;
        [oneHeaderView addSubview:self.whiteView];
        [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(oneHeaderView).offset(-10);
            make.top.mas_equalTo(oneHeaderView).offset(10);
            make.left.mas_equalTo(oneHeaderView).offset(10);
            make.bottom.mas_equalTo(oneHeaderView).offset(-5);
        }];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = GlobalFontColor;
        title.text = @"还款金额";
        [self.whiteView addSubview:title];
        
        self.textFieldMoney = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, ScreenW-60, 50)];
        self.textFieldMoney.keyboardType = UIKeyboardTypeDecimalPad;
        self.textFieldMoney.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textFieldMoney.font = [UIFont systemFontOfSize:25];
        self.textFieldMoney.textColor = [UIColor redColor];
        if (!(self.textValue == 0)) {
            self.textFieldMoney.text = [NSString stringWithFormat:@"%.2f",self.textValue];
        } else {
            self.textFieldMoney.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
        }
        self.textFieldMoney.delegate = self;
        [self.whiteView addSubview:self.textFieldMoney];
    } else {
        
    }

    
    return oneHeaderView;
    
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.buttonNumber == 1) {
        return self.modelArr.count;
    } else {
        return self.twoModelArr.count;
    }
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVRepaymentListCell *cell = [tableView dequeueReusableCellWithIdentifier:RepaymentCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVRepaymentListCell" owner:nil options:nil].lastObject;
        
    }
    
    //用模型数组给cell赋值
    if (self.buttonNumber == 1) {
        cell.model = self.modelArr[indexPath.row];
        cell.userInteractionEnabled = YES;
    } else {
        cell.model = self.twoModelArr[indexPath.row];
        cell.userInteractionEnabled = NO;
    }
    
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVRepaymentModel *model = self.modelArr[indexPath.row];
    if ([model.isSelect isEqualToString:@"1"]) {
        model.isSelect = @"0";
        self.sumMoney = self.sumMoney - [model.sv_credit_money floatValue];
    } else {
        model.isSelect = @"1";
        self.sumMoney += [model.sv_credit_money floatValue];
        
        [self.footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //设置背景色
        self.footerButton.backgroundColor = navigationBackgroundColor;
        [self.footerButton setEnabled:YES];
    }
    
    self.textValue = self.sumMoney;
    
    [self.modelArr replaceObjectAtIndex:indexPath.row withObject:model];//替换数据源，好了可以去刷新了
    // 这个有点类似sql语句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelect CONTAINS %@",@"1"]; // name\pinYin\pinYinHead不是随便写的, 是模型中的属性; contains是包含后面%@这个字符串
    self.dataAry = [self.modelArr filteredArrayUsingPredicate:predicate];
    
    if (self.dataAry.count == 0) {
        self.sumMoney = 0;
        self.textValue = 0;
        [self.footerButton setTitleColor:NOEnabledButtonTextColor forState:UIControlStateNormal];
        //设置背景色
        self.footerButton.backgroundColor = NOEnabledButtonColor;
        [self.footerButton setEnabled:NO];
    }

    [self.tableView reloadData];
}

#pragma mark - textField
//限制只能输入一定长度的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.dataAry.count == 0 && [SVTool isBlankString:self.textFieldMoney.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请选择还款单"];
        return NO;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    self.textValue = [toBeString floatValue];
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    if (![string isEqualToString:@""]) {
        
        NSCharacterSet *cs;
        if ([textField isEqual:self.textFieldMoney]) {//判断是否时我们想要限定的那个输入框
            
            if ([toBeString floatValue] > self.sumMoney) {
                [SVTool TextButtonAction:self.view withSing:@"已超出应还金额"];
                self.textFieldMoney.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
                self.textValue = self.sumMoney;
                return NO;
            }
            
            // 小数点在字符串中的位置 第一个数字从0位置开始
            NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
            
            // 判断字符串中是否有小数点，并且小数点不在第一位
            // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
            // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
            if (dotLocation == NSNotFound && range.location != 0) {
                
                // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
                /*
                 [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
                 
                 在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
                 */
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
                if (range.location >= 9) {
                    
                    if ([string isEqualToString:@"."] && range.location == 9) {
                        return YES;
                    }
                    
                    return NO;
                }
            }else {
                cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
            }
            
            // 按cs分离出数组,数组按@""分离出字符串
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [string isEqualToString:filtered];
            if (!basicTest) {
                return NO;
            }
            
            if (dotLocation != NSNotFound && range.location > dotLocation + 2) {                
                return NO;
            }
            
            if (textField.text.length > 11) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

-(NSMutableArray *)twoModelArr{
    if (!_twoModelArr) {
        _twoModelArr = [NSMutableArray array];
    }
    return _twoModelArr;
}


@end
