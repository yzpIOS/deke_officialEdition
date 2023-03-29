//
//  SVOrderDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 17/5/17.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVOrderDetailsVC.h"
#import "SVDetailsCell.h"
#import "SVOrderFooterButton.h"
//添加商品
#import "SVSelectWaresVC.h"
//结算
#import "SVCheckoutV.h"
//添加商品
#import "SVAddWaresVC.h"
//模型
#import "SVOrderDetailsModel.h"
// 会员模型
#import "SVVipSelectModdl.h"
#import "SVNewSettlementVC.h"
//#import "SVSelectWaresVC.h"
@interface SVOrderDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) SVOrderFooterButton *footerView;

//模型
@property (nonatomic,strong) NSMutableArray *modelArr;
//传给一下界面的
@property (nonatomic,strong) NSMutableArray *orderArr;

//总和
@property (nonatomic,assign) float sum;
//件数
@property (nonatomic,assign) float number;
@property (nonatomic,strong) SVVipSelectModdl *model;
@property (nonatomic,strong) NSMutableArray *goodsArr;
@property (nonatomic,strong) NSString *grade;
/**
 分类折数组
 */
@property (nonatomic,strong) NSArray *getUserLevelArray;

/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;

@property (nonatomic,strong) NSString * sv_mw_availablepoint;
@property (nonatomic,strong) NSString * sv_mw_sumpoint;
@property (nonatomic,strong) NSString * sv_mr_birthday;
@property (nonatomic,strong) NSString * level;
@end

@implementation SVOrderDetailsVC

-(NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray array];
    }
    return _goodsArr;
}

- (NSArray *)getUserLevelArray{
    if (!_getUserLevelArray) {
        _getUserLevelArray = [NSArray array];
    }
    
    return _getUserLevelArray;
}

- (NSArray *)sv_discount_configArray{
    if (!_sv_discount_configArray) {
        _sv_discount_configArray = [NSArray array];
    }
    
    return _sv_discount_configArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航标题

//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"订单详情";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"订单详情";

    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight - 50-BottomHeight)];
    //去分割线
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //取消选中
    self.tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVDetailsCell" bundle:nil] forCellReuseIdentifier:@"SVDetailsCell"];
    
        [self.footerView.addWaresButton addTarget:self action:@selector(addWaresButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
   // self.footerView.addWaresButton.hidden = YES;
    [self.footerView.checkoutButton addTarget:self action:@selector(checkoutButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    
    // 右上角按钮
  
    
    
    
    //赋0
    //    self.sum = 0;
    //    self.number = 0;
    
    // 根据会员id求具体的会员
    //  [self requestMember];
    //      [self getDataPage:weakSelf.page top:20 dengji:0 fenzhu:0 liusi:0 sectkey:name biaoqian:@""];
    if (![SVTool isBlankString:self.member_id]) {
        [self getDataPage:1 top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" memberid:self.member_id];
    }else{
        //请求数据
        [self requesdata];
    }

    self.view.backgroundColor = BackgroundColor;

    self.view.backgroundColor = [UIColor whiteColor];

//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(removebuttonResponseEvent)];
//      [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];

     [SVUserManager loadUserInfo];
    // 获取分类折
       self.getUserLevelArray = [SVUserManager shareInstance].getUserLevel;
        NSLog(@"getUserLevelArray = %@",self.getUserLevelArray);

    
}

- (void)getDataPage:(NSInteger)page top:(NSInteger)top dengji:(NSInteger)dengji fenzhu:(NSInteger)fenzhu liusi:(NSInteger)liusi sectkey:(NSString *)sectkey biaoqian:(NSString *)biaoqian memberid:(NSString *)memberid{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/user?key=%@&page=%li&top=%li&dengji=%li&fenzhu=%li&liusi=%li&sectkey=%@&biaoqian=%@&id=%@",[SVUserManager shareInstance].access_token,(long)page,(long)top,(long)dengji,(long)fenzhu,(long)liusi,sectkey,biaoqian,memberid];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray *arr = [SVVipSelectModdl mj_objectArrayWithKeyValuesArray:dic[@"values"]];
        if (!kArrayIsEmpty(arr)) {
             self.model = arr[0];
            
            NSString *memberlevel_id = [NSString stringWithFormat:@"%@",self.model.memberlevel_id];
            
            for (NSDictionary *dict in self.getUserLevelArray) {
                NSString *memberlevel_id_getUserLevel = [NSString stringWithFormat:@"%@",dict[@"memberlevel_id"]];
                if ([memberlevel_id_getUserLevel isEqualToString:memberlevel_id]) {
                    NSString *sv_discount_config_json = dict[@"sv_discount_config"];
                    NSData *data = [sv_discount_config_json dataUsingEncoding:NSUTF8StringEncoding];
                    if (data != NULL) {
                         self.sv_discount_configArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                         NSLog(@"self.sv_discount_configArray = %@",self.sv_discount_configArray);
                    }
                   
                    
                    break;
                }
            }
        }
       
        NSLog(@"memberdic = %@",dic);
        if (kStringIsEmpty(self.model.sv_grade_price)) {
            self.grade = nil;
        }else{
            NSData *data = [self.model.sv_grade_price dataUsingEncoding:NSUTF8StringEncoding];
                   NSDictionary *sv_grade_price = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                   NSLog(@"sv_grade_price = %@",sv_grade_price);
                  NSString *grade = [NSString stringWithFormat:@"%@",sv_grade_price[@"v"]];
                  self.grade = grade;
                  NSLog(@"grade = %@",grade);
        }
        
      
        //请求数据
        [self requesdata];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 数据请求
-(void)requesdata{
    //拼接URL
    NSString *urlString = [URLhead stringByAppendingString:@"/order/GetGuandanmModelByTableId"];
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *token = [defaults objectForKey:@"access_token"];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //创建可变数组
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //将key放到字典里
   // [parameters setObject:token forKey:@"key"];
    [parameters setObject:self.sv_without_list_id forKey:@"withoutListId"];
    [parameters setObject:token forKey:@"key"];
    [parameters setObject:@"0" forKey:@"queryType"];
    [parameters setObject:@"false" forKey:@"is_mp"];
    [parameters setObject:@"0" forKey:@"tableId"];
    //    if (![SVTool isBlankString:self.member_id]) {
    //         [parameters setObject:self.member_id forKey:@"member_id"];
    //    }
    
    [[SVSaviTool sharedSaviTool] GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"665656dic = %@",dic);
        [self.modelArr removeAllObjects];
        [self.goodsArr removeAllObjects];
        //将数组里边的字典遍历一次,就可以拿到每个字典里的东西了
        if (![SVTool isEmpty:dic[@"values"]]) {
            NSInteger sumCount = 0;
            double sumMoney = 0.00;
            NSDictionary *values = dic[@"values"];
            NSArray *prlist = values[@"prlist"];
            for (NSMutableDictionary *dict in prlist) {
                NSMutableDictionary *dicTwo = [NSMutableDictionary dictionary];
                      //头像
                      if (![SVTool isBlankString:dict[@"sv_p_images"]]) {
                          [dicTwo setObject:dict[@"sv_p_images"] forKey:@"sv_p_images"];
                      }
                      
                      [dicTwo setObject:dict[@"sv_pricing_method"] forKey:@"sv_pricing_method"];
                      //套餐类型
                      [dicTwo setObject:dict[@"sv_product_type"] forKey:@"sv_product_type"];
                      
                   //  [dicTwo setObject:@"2" forKey:@"isPriceChange"];
                      //商品名
                      [dicTwo setObject:dict[@"product_name"] forKey:@"sv_p_name"];
                     [dicTwo setObject:dict[@"product_name"] forKey:@"product_name"];
                      //单价product_name
                      [dicTwo setObject:dict[@"product_unitprice"]  forKey:@"sv_p_unitprice"];
                        [dicTwo setObject:dict[@"product_unitprice"]  forKey:@"product_unitprice"];
                
                NSString *sv_p_barcode = [NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]];
                if (kStringIsEmpty(sv_p_barcode)) {
                  //  [dicTwo setObject:@"0" forKey:@"sv_p_memberprice"];
                    return [SVTool TextButtonActionWithSing:@"订单有误"];
                }else{
                    // 商品款号 sv_p_barcode
                    [dicTwo setObject:dict[@"sv_p_barcode"] forKey:@"sv_p_barcode"];
                }
                      //会员售价
                NSString *sv_p_memberprice = [NSString stringWithFormat:@"%@",dict[@"sv_p_memberprice"]];
                if (kStringIsEmpty(sv_p_memberprice) || [sv_p_memberprice containsString:@"null"]) {
                  //  [dicTwo setObject:@"0" forKey:@"sv_p_memberprice"];
                    return [SVTool TextButtonActionWithSing:@"订单有误"];
                }else{
                    [dicTwo setObject:dict[@"sv_p_memberprice"]  forKey:@"sv_p_memberprice"];
                }
                     
                      //库存
                      [dicTwo setObject:dict[@"sv_p_storage"] forKey:@"sv_p_storage"];
                      //单位
                      [dicTwo setObject:dict[@"sv_p_unit"] forKey:@"sv_p_unit"];
                      //商品ID
                      [dicTwo setObject:dict[@"product_id"] forKey:@"product_id"];
                    
               
                
                     // model.ImageHidden = @"1";
                      [dicTwo setObject:@"1" forKey:@"ImageHidden"];
                      [dicTwo setObject:dict[@"product_num"] forKey:@"product_num"];
                
                // 最低折
                [dicTwo setObject:dict[@"sv_p_mindiscount"] forKey:@"sv_p_mindiscount"];
                 // 最低价
                [dicTwo setObject:dict[@"sv_p_minunitprice"] forKey:@"sv_p_minunitprice"];
                                    // 进货价
                      [dicTwo setObject:dict[@"sv_purchaseprice"] forKey:@"sv_purchaseprice"];
                
                    [dicTwo setObject:dict[@"sv_p_memberprice1"] forKey:@"sv_p_memberprice1"];
                
                [dicTwo setObject:dict[@"sv_p_memberprice2"] forKey:@"sv_p_memberprice2"];
                
                [dicTwo setObject:dict[@"sv_p_memberprice3"] forKey:@"sv_p_memberprice3"];
                
                [dicTwo setObject:dict[@"sv_p_memberprice4"] forKey:@"sv_p_memberprice4"];
                
                [dicTwo setObject:dict[@"sv_p_memberprice5"] forKey:@"sv_p_memberprice5"];
                [dicTwo setObject:[NSString stringWithFormat:@"%@",dict[@"productcategory_id"]] forKey:@"productcategory_id"];
                [dicTwo setObject:[NSString stringWithFormat:@"%@",dict[@"productsubcategory_id"]] forKey:@"productsubcategory_id"];
                [self.goodsArr addObject:dicTwo];
                
                SVOrderDetailsModel *model = [SVOrderDetailsModel mj_objectWithKeyValues:dicTwo];
                
                if (![SVTool isBlankString:self.member_id]) {
                    model.member_id = self.member_id;
                    model.discount = self.model.sv_ml_commondiscount;
                    UIButton *informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    informationCardBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                    informationCardBtn.frame =CGRectMake(0, 0, 50, 50);
//                                self.button.layer.borderColor = [UIColor blackColor].CGColor;
//                                self.button.layer.borderWidth = 1;
//                                self.button.layer.cornerRadius = 10;
//                                self.button.layer.masksToBounds = YES;
                    [informationCardBtn setTitleColor:GlobalFontColor forState:UIControlStateNormal];
                  //    [informationCardBtn addTarget:self action:@selector(sousuoRightBtnCLick) forControlEvents:UIControlEventTouchUpInside];
                    
                    [informationCardBtn setTitle:self.model.sv_mr_name forState:UIControlStateNormal];
              
                       
                    //   [informationCardBtn sizeToFit];
                       UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:informationCardBtn];
                       
                       
                       UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                       fixedSpaceBarButtonItem.width = 15;
                       
                       
                       UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                      settingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                    [settingBtn setTitleColor:GlobalFontColor forState:UIControlStateNormal];
               
                       [settingBtn addTarget:self action:@selector(removebuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
                       [settingBtn setTitle:@"删除" forState:UIControlStateNormal];
                       [settingBtn sizeToFit];
                       UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
                    
                      self.navigationItem.rightBarButtonItems  = @[settingBtnItem,fixedSpaceBarButtonItem,informationCardItem];
                }else{
                    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(removebuttonResponseEvent)];
                         [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:GlobalFontColor} forState:UIControlStateNormal];
                }
                [self.modelArr addObject:model];
                
                //   self.number += [dict[@"product_num"] floatValue];

              //  if ([dict[@"sv_pricing_method"] integerValue] == 0) {
                
                
                // 设置分类折
                double Discountedvalue = 0.0;
                BOOL isCategoryDisCount = false;
                for (NSDictionary *dictClassifiedBook in self.sv_discount_configArray) {
                    if (isCategoryDisCount == false) {
                    double typeflag = [dictClassifiedBook[@"typeflag"] doubleValue];
                    NSString *Discountedpar = [NSString stringWithFormat:@"%@",dictClassifiedBook[@"Discountedpar"]];// 分类ID
                    if (typeflag == 1) { // 是1的话就说明是一级分类
                        if ([[NSString stringWithFormat:@"%@",dict[@"productcategory_id"]] isEqualToString:Discountedpar]) {
                            isCategoryDisCount = true;//有分类折跳出循环
                            Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                            break;
                        }
                    }
                    
                    if (typeflag == 2) { // 是2的话就说明是二级分类
                        NSArray *comdiscounted = dictClassifiedBook[@"comdiscounted"];
                        if (!kArrayIsEmpty(comdiscounted)) {
                            for (NSDictionary * dictComdiscounted in comdiscounted) {
                            NSString *comdiscounted2 = [NSString stringWithFormat:@"%@",dictComdiscounted[@"comdiscounted"]];
                            if ([[NSString stringWithFormat:@"%@",dict[@"productsubcategory_id"]] isEqualToString:comdiscounted2]) {
                                isCategoryDisCount = true;//有分类折跳出循环
                                Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                                break;
                            }
                            }
                        }
                        }
                        
                    }
                }
                
                NSLog(@"Discountedvalue4444 = %f",Discountedvalue);
                

                sumCount += [dict[@"product_num"] floatValue] + [dict[@"sv_p_weight"] floatValue];
                
                double sv_p_minunitprice = 0.0;// 最低售价
                double sv_p_mindiscount = 0.0; // 最低折
                // 最低价
                sv_p_minunitprice = [dict[@"sv_p_minunitprice"] doubleValue];
                // 最低折
                sv_p_mindiscount = [dict[@"sv_p_mindiscount"] doubleValue];
                double money;
                double grade = 0.0;
                if (!kStringIsEmpty(self.grade)) {
                    if ([self.grade isEqualToString:@"1"]) {
                        grade=[dict[@"sv_p_memberprice1"] doubleValue];
                    }else if ([self.grade isEqualToString:@"2"]){
                        grade=[dict[@"sv_p_memberprice2"] doubleValue];
                    }else if ([self.grade isEqualToString:@"3"]){
                        grade=[dict[@"sv_p_memberprice3"] doubleValue];
                    }else if ([self.grade isEqualToString:@"4"]){
                        grade=[dict[@"sv_p_memberprice4"] doubleValue];
                    }else {
                        grade=[dict[@"sv_p_memberprice5"] doubleValue];
                    }
                }
                
                if (grade > 0) {
                    money = grade;
                }else if (sv_p_minunitprice > 0 || sv_p_mindiscount > 0 || [dict[@"sv_p_memberprice"] doubleValue] > 0){
                    NSLog(@"sv_p_minunitprice = %f",sv_p_minunitprice);
                    NSLog(@"sv_p_mindiscount = %f",sv_p_mindiscount);
                    NSLog(@"sv_p_memberprice = %f",[dict[@"sv_p_memberprice"] doubleValue]);
                    /**
                     场景一：会员价配置【会员价1-5】 ＞ 会员价/最低折/最低价【三选一】＞ 分类折
                     注：有以上这三种情况下，就没有会员折一说，会员折无效
                     */
                    if ([SVTool isBlankString:self.member_id]) {
                        money = [dict[@"product_unitprice"] doubleValue];
                    }else{
                        if ([dict[@"sv_p_memberprice"] doubleValue] > 0) {
                            money = [dict[@"sv_p_memberprice"] doubleValue];
                        }else if (sv_p_mindiscount > 0 && self.model.sv_ml_commondiscount.doubleValue > 0 && self.model.sv_ml_commondiscount.doubleValue < 10){
                             //场景二：最低折【8折】、会员折【9折】同时存在，按折比，取数字大的算【按9折算】
                            if (self.model.sv_ml_commondiscount.doubleValue >= 10 || self.model.sv_ml_commondiscount.doubleValue <= 0) {
                                money = [dict[@"product_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                            }else{
                                if (sv_p_mindiscount > self.model.sv_ml_commondiscount.doubleValue && self.model.sv_ml_commondiscount.doubleValue > 0 && self.model.sv_ml_commondiscount.doubleValue < 10) {
                                    money = [dict[@"product_unitprice"] doubleValue] * sv_p_mindiscount *0.1;
                                }else if ( self.model.sv_ml_commondiscount.doubleValue > sv_p_mindiscount && self.model.sv_ml_commondiscount.doubleValue > 0 && self.model.sv_ml_commondiscount.doubleValue < 10){
                                    money = [dict[@"product_unitprice"] doubleValue]*[self.model.sv_ml_commondiscount doubleValue]*0.1;
                                }else{
                                    money = [dict[@"product_unitprice"] doubleValue];
                                }
                            }
                               
                        }else if (sv_p_minunitprice > 0 && self.model.sv_ml_commondiscount.doubleValue > 0 && self.model.sv_ml_commondiscount.doubleValue < 10){// 场景三：最低价、会员折同时存在，要拿单价来对比， 哪个大取哪个，不能低于最低价  会员折单价=会员折×单品合计金额
                            if (self.model.sv_ml_commondiscount.doubleValue >= 10 || self.model.sv_ml_commondiscount.doubleValue <= 0) {
                                money = sv_p_minunitprice;
                            }else{
                                double memberPrice = [dict[@"product_unitprice"] doubleValue]*[self.model.sv_ml_commondiscount doubleValue]*0.1;
                                if (memberPrice > sv_p_minunitprice && self.model.sv_ml_commondiscount.doubleValue > 0 && self.model.sv_ml_commondiscount.doubleValue < 10) {
                                    money = memberPrice;
                                }else if ( sv_p_minunitprice> memberPrice && self.model.sv_ml_commondiscount.doubleValue > 0 && self.model.sv_ml_commondiscount.doubleValue < 10){
                                    money = sv_p_minunitprice;
                                }else{
                                    money = [dict[@"product_unitprice"] doubleValue];
                                }
                            }

                            }else{
                                   money = [dict[@"product_unitprice"] doubleValue];
                            }
                        }

                }else if (Discountedvalue > 0){
                    money = [dict[@"product_unitprice"] doubleValue]*Discountedvalue*0.1;
                }else if (self.model.sv_ml_commondiscount.doubleValue > 0 && self.model.sv_ml_commondiscount.doubleValue < 10){
                    double memberPrice = [dict[@"product_unitprice"] doubleValue]*[self.model.sv_ml_commondiscount doubleValue]*0.1;
                    money = memberPrice;
                }else{
                    money = [dict[@"product_unitprice"] doubleValue];
                }

                sumMoney += [dict[@"product_num"] floatValue] * money + [dict[@"sv_p_weight"] floatValue] * money;
                NSLog(@"sumMoney = %.2f", sumMoney);

            }
            self.footerView.moneyLabel.text = [NSString stringWithFormat:@"%.2f",sumMoney];
            
            
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 按钮响应方法
//添加按钮
-(void)addWaresButtonResponseEvent{
        SVSelectWaresVC *tableVC = [[SVSelectWaresVC alloc]init];
        tableVC.goodsArr = self.goodsArr;
        tableVC.member_id = self.member_id;
        tableVC.name = self.model.sv_mr_name;
        tableVC.discount = self.model.sv_ml_commondiscount;
        tableVC.orderID = self.orderID;
        tableVC.interface = 3;
        tableVC.sv_without_list_id = self.sv_without_list_id;
    tableVC.order_running_id = self.orderID;
    tableVC.storedValue = self.model.sv_mw_availableamount;
    tableVC.headimg = self.model.sv_mr_headimg;
    tableVC.sv_mr_cardno = self.model.sv_mr_cardno;
    tableVC.member_Cumulative = self.model.sv_mw_availablepoint;
    tableVC.sv_mr_pwd = self.model.sv_mr_pwd;
    tableVC.grade = self.grade;
     tableVC.sv_discount_configArray = self.sv_discount_configArray;
    

//    tableVC.interface = self.interface;
//              tableVC.name = self.name;
//              tableVC.phone = self.phone;
//              tableVC.discount = self.discount;
//              tableVC.member_id = self.member_id;
//              tableVC.stored = self.storedValue;
//              tableVC.headimg = self.headimg;
//              tableVC.sv_mr_cardno = self.sv_mr_cardno;
//              tableVC.member_Cumulative = self.member_Cumulative;
//              tableVC.sv_mr_pwd = self.sv_mr_pwd;
//              tableVC.grade = self.grade;
    
    __weak typeof(self) weakSelf = self;
    tableVC.numBlock = ^{
        if (![SVTool isBlankString:weakSelf.member_id]) {
            [weakSelf getDataPage:1 top:20 dengji:0 fenzhu:0 liusi:0 sectkey:@"" biaoqian:@"" memberid:weakSelf.member_id];
        }else{
            //请求数据
            [weakSelf requesdata];
        }
    };
        //跳转界面有导航栏的
        [self.navigationController pushViewController:tableVC animated:YES];
    
}

#pragma mark - 结算按钮
-(void)checkoutButtonResponseEvent{
    
    if ([SVTool isEmpty:self.modelArr]) {
        [SVTool TextButtonAction:self.view withSing:@"抱歉!此单不能结算"];
        return;
    }
    
    [self.orderArr removeAllObjects];
    for (SVOrderDetailsModel *dict in self.modelArr) {
        
        if ([SVTool isBlankString:dict.product_name]) {
            [SVTool TextButtonAction:self.view withSing:@"商品数据有误,结算失败"];
            return;
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        //商品ID
        [dic setObject:dict.product_id forKey:@"product_id"];
        //商品名
        [dic setObject:dict.product_name forKey:@"sv_p_name"];
        [dic setObject:dict.sv_pricing_method forKey:@"sv_pricing_method"];
        //数量

        //  [dic setObject:dict.product_num forKey:@"product_num"];
        //  if ([dict.sv_pricing_method integerValue] == 0) {
        // sumCount += [dict[@"product_num"] integerValue];
        // sumMoney += [dict[@"product_num"] floatValue] * money;
        float product_weight_num = dict.product_num.floatValue + dict.sv_p_weight.floatValue;
        [dic setObject:[NSString stringWithFormat:@"%.2f",product_weight_num]forKey:@"product_num"];
        //        }else{
        //            // sumCount += [dict[@"sv_p_weight"] integerValue];
        //           // sumMoney += [dict[@"sv_p_weight"] floatValue] * money;
        //             [dic setObject:dict.sv_p_weight forKey:@"product_num"];
        //        }

  
//        float product_weight_num = dict.product_num.floatValue + dict.sv_p_weight.floatValue;
//            [dic setObject:[NSString stringWithFormat:@"%.2f",product_weight_num]forKey:@"product_num"];

        //单价
        [dic setObject:dict.product_unitprice forKey:@"sv_p_unitprice"];
        [dic setObject:dict.product_unitprice forKey:@"product_unitprice"];
        //会员价
        [dic setObject:dict.sv_p_memberprice forKey:@"sv_p_memberprice"];
        //折扣
        [dic setObject:[NSNumber numberWithFloat:1.0] forKey:@"product_discount"];
        
        [dic setObject:dict.sv_product_type forKey:@"sv_product_type"];
        
        [dic setObject:dict.sv_p_barcode forKey:@"sv_p_barcode"];
        // 进货价
        [dic setObject:dict.sv_purchaseprice forKey:@"sv_purchaseprice"];
        
        // 最低价
      //  sv_p_minunitprice = [dict[@"sv_p_minunitprice"] doubleValue];
        [dic setObject:dict.sv_p_minunitprice forKey:@"sv_p_minunitprice"];
        // 最低折
      //  sv_p_mindiscount = dict.sv_p_mindiscount"] doubleValue];
        [dic setObject:dict.sv_p_mindiscount forKey:@"sv_p_mindiscount"];
        
        [dic setObject:dict.sv_p_memberprice1 forKey:@"sv_p_memberprice1"];
        [dic setObject:dict.sv_p_memberprice2 forKey:@"sv_p_memberprice2"];
        
        [dic setObject:dict.sv_p_memberprice3 forKey:@"sv_p_memberprice3"];
        
        [dic setObject:dict.sv_p_memberprice4 forKey:@"sv_p_memberprice4"];
        
        [dic setObject:dict.sv_p_memberprice5 forKey:@"sv_p_memberprice5"];
        [dic setObject:[NSString stringWithFormat:@"%@",dict.productcategory_id] forKey:@"productcategory_id"];
        [dic setObject:[NSString stringWithFormat:@"%@",dict.productsubcategory_id] forKey:@"productsubcategory_id"];
        
        [self.orderArr addObject:dic];
    }
    
    SVNewSettlementVC *tableVC = [[SVNewSettlementVC alloc]init];
    //    tableVC.money = self.sum;
    //    tableVC.number = self.number;
    tableVC.order_running_id = self.orderID;
    tableVC.sv_without_list_id = self.sv_without_list_id;
    tableVC.resultArr = self.orderArr;
    tableVC.interface = 3;
    tableVC.vipBool = NO;
    tableVC.grade = self.grade;
    tableVC.name = self.model.sv_mr_name;
    tableVC.phone = self.model.sv_mr_mobile;
    tableVC.discount = self.model.sv_ml_commondiscount;
    tableVC.member_id = self.member_id;
    tableVC.stored = self.model.sv_mw_availableamount;
    tableVC.headimg = self.model.sv_mr_headimg;
    tableVC.sv_mr_cardno = self.model.sv_mr_cardno;
    tableVC.sv_discount_configArray = self.sv_discount_configArray;
    
    tableVC.sv_mw_availablepoint = self.model.sv_mw_availablepoint;
    tableVC.sv_mw_sumpoint = self.model.sv_mw_sumpoint;
    tableVC.sv_mr_birthday = self.model.sv_mr_birthday;
    tableVC.level = self.model.level;
    //跳转界面有导航栏的
    [self.navigationController pushViewController:tableVC animated:YES];
}

-(void)removebuttonResponseEvent{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        NSString *token = [defaults objectForKey:@"access_token"];
        
        [SVUserManager loadUserInfo];
        
        NSString *strURL = [URLhead stringByAppendingFormat:@"/order?key=%@&order_id=%@",[SVUserManager shareInstance].access_token,self.orderID];
        
        
        [[SVSaviTool sharedSaviTool] DELETE:strURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"succeed"] integerValue] == 1) {
                if (self.orderBlock) {
                    self.orderBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
    [derAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定要删除吗？"];
    //设置文本颜色
    [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 7)];
    //设置文本字体大小
    [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
    [alertController setValue:hogan forKey:@"attributedTitle"];
    
    [alertController addAction:derAction];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SVDetailsCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVDetailsCell" owner:nil options:nil].lastObject;
    }
    cell.chahaoBtn.hidden = YES;
    cell.grade = self.grade;
    cell.sv_discount_configArray = self.sv_discount_configArray;
    cell.orderDetailsModel = self.modelArr[indexPath.row];
   // cell.model = self.model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

//footerView
-(SVOrderFooterButton *)footerView{
    if (!_footerView) {
        _footerView = [[NSBundle mainBundle] loadNibNamed:@"SVOrderFooterButton" owner:nil options:nil].lastObject;
        //_footerView.frame = CGRectMake(0, ScreenH-50, ScreenW, 50);
        
        [self.view addSubview:_footerView];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
            make.bottom.mas_equalTo(self.view).offset(-BottomHeight);
            make.left.mas_equalTo(self.view);
        }];
    }
    return _footerView;
}

-(NSMutableArray *)orderArr{
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];

    }
    return _orderArr;
}


@end
