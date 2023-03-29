//
//  SVAddShopDetailView.m
//  SAVI
//
//  Created by houming Wang on 2021/2/20.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVAddShopDetailView.h"
#import "SVAddInfoDetailCell.h"
#import "ZYInputAlertView.h"

static NSString *const ID = @"SVAddInfoDetailCell";
@interface SVAddShopDetailView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SVAddShopDetailView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.addBtn.layer.cornerRadius = 19;
    self.addBtn.layer.masksToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SVAddInfoDetailCell" bundle:nil] forCellReuseIdentifier:ID];
    //去分割线
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setListArray:(NSArray *)listArray{
    _listArray = listArray;
    [self.tableView reloadData];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVAddInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVAddInfoDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.deleteBtn.tag = indexPath.row;
    cell.choiceBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.choiceBtn addTarget:self action:@selector(choiceClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.titleDetail.text containsString:@"年份"]) {
        cell.sv_foundation_name.text = self.listArray[indexPath.row];
        cell.deleteBtn.hidden = YES;
        cell.rightContont.constant = 10;
    }else if ([self.titleDetail.text containsString:@"单位"]){
        NSDictionary *dict = self.listArray[indexPath.row];
        cell.sv_foundation_name.text = dict[@"sv_unit_name"];
        cell.deleteBtn.hidden = NO;
        cell.rightContont.constant = 60;
        cell.sv_foundation_name.textColor = GlobalFontColor;
    }else if ([self.titleDetail.text containsString:@"品牌"]){
        cell.dict = self.listArray[indexPath.row];
        cell.deleteBtn.hidden = YES;
        cell.rightContont.constant = 10;
    }else if ([self.titleDetail.text containsString:@"执行标准"]){
        NSDictionary *dict = self.listArray[indexPath.row];
        cell.sv_foundation_name.text = dict[@"sv_foundation_name"];
        cell.deleteBtn.hidden = NO;
        cell.rightContont.constant = 60;
        cell.sv_foundation_name.textColor = GlobalFontColor;
    }else{
        cell.dict = self.listArray[indexPath.row];
        cell.deleteBtn.hidden = NO;
        cell.rightContont.constant = 60;
    }
    
    return cell;
}
#pragma mark - 删除按钮
- (void)deleteClick:(UIButton *)btn{
    if ([self.titleDetail.text containsString:@"面料"]) {
        NSDictionary *dict = self.listArray[btn.tag];
        [self deleteUrlName:@"ProductApiConfig/DeleteFabric" sv_foundation_id:[NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]]];
    }else if ([self.titleDetail.text containsString:@"性别"]){
        NSDictionary *dict = self.listArray[btn.tag];
        [self deleteUrlName:@"ProductApiConfig/DeleteGender" sv_foundation_id:[NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]]];
    }else if ([self.titleDetail.text containsString:@"季节"]){
        NSDictionary *dict = self.listArray[btn.tag];
        [self deleteUrlName:@"ProductApiConfig/DeleteSeason" sv_foundation_id:[NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]]];
    }else if ([self.titleDetail.text containsString:@"款式"]){
        NSDictionary *dict = self.listArray[btn.tag];
        [self deleteUrlName:@"ProductApiConfig/DeleteStyle" sv_foundation_id:[NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]]];
    }else if ([self.titleDetail.text containsString:@"安全"]){
        NSDictionary *dict = self.listArray[btn.tag];
        [self deleteUrlName:@"ProductApiConfig/DeleteStandard" sv_foundation_id:[NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]]];
    }else if ([self.titleDetail.text containsString:@"单位"]){
        NSDictionary *dict = self.listArray[btn.tag];
        [self ProductApiConfigUpdate_Unit:[NSString stringWithFormat:@"%@",dict[@"id"]]];
    }else if ([self.titleDetail.text containsString:@"执行标准"]){
        NSDictionary *dict = self.listArray[btn.tag];
        [self deleteUrlName:@"ProductApiConfig/DeleteExecutivestandard" sv_foundation_id:[NSString stringWithFormat:@"%@",dict[@"sv_foundation_id"]]];
    }
}

- (void)ProductApiConfigUpdate_Unit:(NSString *)idStr{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"id"] = idStr;
    parames[@"type"] = @"1";
    parames[@"value"] = @"true";
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/Update_Unit?key=%@",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] POST:url parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            [self ProductApiConfigGetunitModelList];
            if (self.companyBlock) {
                self.companyBlock();
            }
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}
#pragma mark - 点击选择按钮
- (void)choiceClick:(UIButton *)btn{
    
    if ([self.titleDetail.text containsString:@"面料"]) {
        NSDictionary *dict = self.listArray[btn.tag];
        if (self.mianliaoBlock2) {
            self.mianliaoBlock2(dict);
        }
    }else if ([self.titleDetail.text containsString:@"性别"]){
        NSDictionary *dict = self.listArray[btn.tag];
        if (self.GenderListBlock2) {
            self.GenderListBlock2(dict);
        }
    }else if ([self.titleDetail.text containsString:@"季节"]){
        NSDictionary *dict = self.listArray[btn.tag];
        if (self.SeasonlListBlock2) {
            self.SeasonlListBlock2(dict);
        }
    }else if ([self.titleDetail.text containsString:@"款式"]){
        NSDictionary *dict = self.listArray[btn.tag];
        if (self.StyleListBlock2) {
            self.StyleListBlock2(dict);
        }
    }else if ([self.titleDetail.text containsString:@"安全"]){
        NSDictionary *dict = self.listArray[btn.tag];
        if (self.StandardListBlock2) {
            self.StandardListBlock2(dict);
        }
    }else if ([self.titleDetail.text containsString:@"品牌"]){
        NSDictionary *dict = self.listArray[btn.tag];
        if (self.Sv_Brand_LibBlock2) {
            self.Sv_Brand_LibBlock2(dict);
        }
    }else if ([self.titleDetail.text containsString:@"年份"]){
        NSString *year = self.listArray[btn.tag];
        if (self.CommodityYearBlock2) {
            self.CommodityYearBlock2(year);
        }
    }else if ([self.titleDetail.text containsString:@"单位"]){
        NSDictionary *dict = self.listArray[btn.tag];
        if (self.companyBlock2) {
            self.companyBlock2(dict);
        }
    }else if ([self.titleDetail.text containsString:@"执行标准"]){
        NSDictionary *dict = self.listArray[btn.tag];
        if (self.ExecutiveStandardBlock2) {
            self.ExecutiveStandardBlock2(dict);
        }
    }
}

#pragma mark - 删除按钮的接口
- (void)deleteUrlName:(NSString *)urlName sv_foundation_id:(NSString *)sv_foundation_id{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/%@?key=%@&id=%@",urlName,[SVUserManager shareInstance].access_token,sv_foundation_id];
    
    [[SVSaviTool sharedSaviTool]DELETE:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __weak typeof(self) weakSelf = self;
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            [SVTool TextButtonAction:self withSing:@"删除成功"];
            if ([self.titleDetail.text containsString:@"面料"]) {
                [weakSelf ProductApiConfigGetFabricList];
                if (self.mianliaoBlock) {
                    self.mianliaoBlock();
                }
            }else if ([self.titleDetail.text containsString:@"性别"]){
                [weakSelf ProductApiConfigGetGenderList];
                if (self.GenderListBlock) {
                    self.GenderListBlock();
                }
            }else if ([self.titleDetail.text containsString:@"季节"]){
                [weakSelf ProductApiConfigGetSeasonlList];
                if (self.SeasonlListBlock) {
                    self.SeasonlListBlock();
                }
            }else if ([self.titleDetail.text containsString:@"款式"]){
                [weakSelf ProductApiConfigGetStyleList];
                if (self.StyleListBlock) {
                    self.StyleListBlock();
                }
            }else if ([self.titleDetail.text containsString:@"安全"]){
                [weakSelf ProductApiConfigGetStandardList];
                if (self.StandardListBlock) {
                    self.StandardListBlock();
                }
            }else if ([self.titleDetail.text containsString:@"单位"]){
                [weakSelf ProductApiConfigGetStandardList];
                if (self.StandardListBlock) {
                    self.StandardListBlock();
                }
            }else if ([self.titleDetail.text containsString:@"执行标准"]){
                [weakSelf GetExecutivestandardList];
                if (self.ExecutiveStandardBlock) {
                    self.ExecutiveStandardBlock();
                }
            }

            
        }else{
            [SVTool TextButtonAction:weakSelf withSing:@"网络开小差了"];
        }
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];

}

#pragma mark - 面料
- (void)ProductApiConfigDeleteFabricId:(NSString *)idStr{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/DeleteFabric?key=%@&id=%@",[SVUserManager shareInstance].access_token,idStr];
    [[SVSaviTool sharedSaviTool]DELETE:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dic11= %@",dic);
                if ([dic[@"code"] intValue] == 1) {
                    [self ProductApiConfigGetFabricList];
                }else{
                    [SVTool TextButtonAction:self withSing:@"网络开小差了"];
                }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];

}

#pragma mark - 加载数据接口
// 商品品牌接口
- (void)ProductApiConfigGetSv_Brand_Lib{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetSv_Brand_Lib?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.listArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

// 面料接口
- (void)ProductApiConfigGetFabricList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetFabricList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.listArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}
// 性别
- (void)ProductApiConfigGetGenderList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetGenderList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.listArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

// 季节
- (void)ProductApiConfigGetSeasonlList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetSeasonlList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.listArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

// 款式
- (void)ProductApiConfigGetStyleList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetStyleList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.listArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

// 安全标准
- (void)ProductApiConfigGetStandardList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetStandardList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.listArray = data[@"list"];
            
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

#pragma mark - 执行标准
- (void)GetExecutivestandardList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetExecutivestandardList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            self.listArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}


#pragma mark - 单位数据
- (void)ProductApiConfigGetunitModelList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApiConfig/GetunitModelList?key=%@&page=1&pagesize=99",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic11= %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            [SVTool TextButtonAction:self withSing:@"删除成功"];
            NSDictionary *data = dic[@"data"];
            self.listArray = data[@"list"];
        }else{
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}


- (IBAction)addShopClick:(id)sender {
    
    if ([self.titleDetail.text containsString:@"面料"]) {
        [self newlyAdded:@"ProductApiConfig/Fabric_Edit"];
    }else if ([self.titleDetail.text containsString:@"性别"]){
        [self newlyAdded:@"ProductApiConfig/Gender_Edit"];
    }else if ([self.titleDetail.text containsString:@"季节"]){
        [self newlyAdded:@"ProductApiConfig/Season_Edit"];
    }else if ([self.titleDetail.text containsString:@"款式"]){
        [self newlyAdded:@"ProductApiConfig/Style_Edit"];
    }else if ([self.titleDetail.text containsString:@"安全"]){
        [self newlyAdded:@"ProductApiConfig/Standard_Edit"];
    }else if ([self.titleDetail.text containsString:@"品牌"]){
        [self newlyAdded:@"ProductApiConfig/Brand_Edit"];
    }else if ([self.titleDetail.text containsString:@"单位"]){
        [self newlyAdded:@"ProductApiConfig/Unit_Edit"];
    }else if ([self.titleDetail.text containsString:@"执行标准"]){
        [self newlyAdded:@"ProductApiConfig/Executivestandard_Edit"];
    }
    
   
}

#pragma mark - 新增的接口
- (void)newlyAdded:(NSString *)urlName{
    __weak typeof(self) weakSelf = self;
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    alertView.confirmBgColor = navigationBackgroundColor;
    // alertView.inputTextView.text = @"输入开心的事儿···";
    alertView.colorLabel.text = @"新增";
    alertView.placeholder = @"输入名称";
    alertView.inputTextView.keyboardType = UIKeyboardTypeDefault;
    alertView.textfieldStrBlock = ^(NSString *str) {
        
        [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/%@?key=%@",urlName,[SVUserManager shareInstance].access_token];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        if ([self.titleDetail.text containsString:@"品牌"]) {
            parame[@"sv_brand_name"] = str;
            parame[@"sv_enabled"] = @"true";
        }else if ([self.titleDetail.text containsString:@"单位"]){
            parame[@"sv_unit_name"] = str;
            parame[@"sv_unit_type"] = @"0";
            parame[@"sv_p_source"] = @"300";
        }else{
            parame[@"sv_foundation_name"] = str;
            parame[@"sv_p_source"] = @"300";
        }
        
        
        [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //解释数据
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"dic11= %@",dic);
            if ([dic[@"code"] intValue] == 1) {
                [SVTool TextButtonAction:self withSing:@"新增成功"];
                if ([self.titleDetail.text containsString:@"面料"]) {
                    [weakSelf ProductApiConfigGetFabricList];
                    if (self.mianliaoBlock) {
                        self.mianliaoBlock();
                    }
                }else if ([self.titleDetail.text containsString:@"性别"]){
                    [weakSelf ProductApiConfigGetGenderList];
                    if (self.GenderListBlock) {
                        self.GenderListBlock();
                    }
                }else if ([self.titleDetail.text containsString:@"季节"]){
                    [weakSelf ProductApiConfigGetSeasonlList];
                    if (self.SeasonlListBlock) {
                        self.SeasonlListBlock();
                    }
                }else if ([self.titleDetail.text containsString:@"款式"]){
                    [weakSelf ProductApiConfigGetStyleList];
                    if (self.StyleListBlock) {
                        self.StyleListBlock();
                    }
                }else if ([self.titleDetail.text containsString:@"安全"]){
                    [weakSelf ProductApiConfigGetStandardList];
                    if (self.StandardListBlock) {
                        self.StandardListBlock();
                    }
                }else if ([self.titleDetail.text containsString:@"品牌"]){
                    [weakSelf ProductApiConfigGetSv_Brand_Lib];
                    if (self.Sv_Brand_LibBlock) {
                        self.Sv_Brand_LibBlock();
                    }
                }else if ([self.titleDetail.text containsString:@"单位"]){
                    [weakSelf ProductApiConfigGetunitModelList];
                    if (self.companyBlock) {
                        self.companyBlock();
                    }
                }else if ([self.titleDetail.text containsString:@"执行标准"]){
                    [weakSelf GetExecutivestandardList];
                    if (self.ExecutiveStandardBlock) {
                        self.ExecutiveStandardBlock();
                    }
                }
                
            }else{
                [SVTool TextButtonAction:weakSelf withSing:@"网络开小差了"];
            }
            
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //隐藏提示框
                    [MBProgressHUD hideHUDForView:self animated:YES];
                    //        [SVTool requestFailed];
                    [SVTool TextButtonAction:self withSing:@"网络开小差了"];
                }];

    };
    
    [alertView show];
}


@end
