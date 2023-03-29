//
//  SVClassificationView.m
//  SAVI
//
//  Created by houming Wang on 2021/1/20.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVClassificationView.h"
#import "SVClassficationViewCell.h"
#import "SVClassficationModel.h"
// 定义唯一标识
static NSString *oneWaresListVCellID = @"SVClassficationViewCell";
@interface SVClassificationView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UITableView *oneTableView;
@property (weak, nonatomic) IBOutlet UITableView *twoTableView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,strong) NSMutableArray * oneDataArray;
@property (nonatomic,strong) NSMutableArray * twoDataArray;
@property (nonatomic,strong) NSMutableArray * oneSelectModelArray;
@property (nonatomic,strong) NSMutableArray * twoSelectModelArray;
@end
@implementation SVClassificationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.ClassifiedManagement.layer.cornerRadius = 19;
    self.ClassifiedManagement.layer.masksToBounds = YES;
    self.ClassifiedManagement.layer.borderWidth = 0.5;
    self.ClassifiedManagement.layer.borderColor = [UIColor orangeColor].CGColor;
    self.ClassifiedManagement.titleLabel.textColor = [UIColor orangeColor];
    
    self.bottomView.backgroundColor = BackgroundColor;
    
    self.confirmBtn.layer.cornerRadius = 19;
    self.confirmBtn.layer.masksToBounds = YES;
    
    self.oneTableView.delegate = self;
    self.oneTableView.dataSource = self;
    
    self.twoTableView.delegate = self;
    self.twoTableView.dataSource = self;
    
    //设置样式
    self.oneTableView.tableFooterView = [[UIView alloc]init];
    self.oneTableView.showsVerticalScrollIndicator = NO;
    self.oneTableView.backgroundColor = BackgroundColor;
    //改变cell分割线的颜色
   // [self.oneTableView setSeparatorColor:[UIColor whiteColor]];
    self.oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置距离左右各10的距离
    [self.oneTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //设置样式
    self.twoTableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
   // [self.twoTableView setSeparatorColor:cellSeparatorColor];
    self.twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.twoTableView.backgroundColor = [UIColor whiteColor];
    // 设置距离左右各10的距离
    [self.twoTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    //从偏好设置里拿到大分类数组
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    self.bigNameArr = [defaults objectForKey:@"bigName_Arr"];
//    self.bigIDArr = [defaults objectForKey:@"bigID_Arr"];
  

    [self.oneTableView registerNib:[UINib nibWithNibName:@"SVClassficationViewCell" bundle:nil] forCellReuseIdentifier:oneWaresListVCellID];
    [self.twoTableView registerNib:[UINib nibWithNibName:@"SVClassficationViewCell" bundle:nil] forCellReuseIdentifier:oneWaresListVCellID];
    NSLog(@"self.bigNameArr = %@",self.bigNameArr);
    NSLog(@"self.bigIDArr = %@",self.bigIDArr);
    NSLog(@"self.oneSelectModelArray = %@",self.oneSelectModelArray);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetFirstCategory) name:@"GetFirstCategoryPost" object:nil];
}

- (void)setCategaryArray:(NSMutableArray *)categaryArray
{
    _categaryArray = categaryArray;
    if (kArrayIsEmpty(self.oneSelectModelArray)) {
        [self.oneDataArray removeAllObjects];
        for (int i = 0; i < self.categaryArray.count;i++) {
            if (i == 0) {
    //            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    //            dictM[@"sv_psc_parentid"] = [NSString stringWithFormat:@"%@",self.bigIDArr[i]];
    //            dictM[@"sv_psc_name"] = self.bigNameArr[i];
                NSDictionary *dictM = self.categaryArray[i];
                SVClassficationModel *model = [SVClassficationModel mj_objectWithKeyValues:dictM];
                model.isSelect = @"1";
                [self.oneDataArray addObject:model];
                [self.oneSelectModelArray addObject:model];
                
                NSMutableDictionary *twoDictM = [NSMutableDictionary dictionary];
                twoDictM[@"productsubcategory_id"] = @"";
                twoDictM[@"sv_psc_name"] = @"全部";
                SVClassficationModel *twoModel = [SVClassficationModel mj_objectWithKeyValues:twoDictM];
                twoModel.isSelect = @"1";
                [self.twoSelectModelArray addObject:twoModel];
                [self.twoDataArray addObject:twoModel];
            }else{
    //            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    //            dictM[@"sv_psc_parentid"] = [NSString stringWithFormat:@"%@",self.bigIDArr[i]];
    //            dictM[@"sv_psc_name"] = self.bigNameArr[i];
                NSDictionary *dict = self.categaryArray[i];
                SVClassficationModel *model = [SVClassficationModel mj_objectWithKeyValues:dict];
                [self.oneDataArray addObject:model];
            }
        }
        
        [self.oneTableView reloadData];
    }
   
}

- (void)GetFirstCategory{
    [self ProductApiGetProductcategoryProducttype_id];
}

- (void)ProductApiGetProductcategoryProducttype_id{
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApi/GetProductcategory?key=%@&page=1&pagesize=100&producttype_id=-1",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic ==== %@",dic);
        if ([dic[@"code"] intValue] == 1) {
            [self.categaryArray removeAllObjects];
            [self.oneDataArray removeAllObjects];
            [self.oneSelectModelArray removeAllObjects];
            [self.twoDataArray removeAllObjects];
            [self.twoSelectModelArray removeAllObjects];
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"id"] = @"";
            dictM[@"sv_pc_name"] = @"全部";
            [self.categaryArray addObject:dictM];
            NSDictionary *data = dic[@"data"];
            NSArray *listArray = data[@"list"];
            [self.categaryArray addObjectsFromArray:listArray];
            
           // if (kArrayIsEmpty(self.oneSelectModelArray)) {
                [self.oneDataArray removeAllObjects];
                for (int i = 0; i < self.categaryArray.count;i++) {
                    if (i == 0) {
            //            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            //            dictM[@"sv_psc_parentid"] = [NSString stringWithFormat:@"%@",self.bigIDArr[i]];
            //            dictM[@"sv_psc_name"] = self.bigNameArr[i];
                        NSDictionary *dictM = self.categaryArray[i];
                        SVClassficationModel *model = [SVClassficationModel mj_objectWithKeyValues:dictM];
                        model.isSelect = @"1";
                        [self.oneDataArray addObject:model];
                        [self.oneSelectModelArray addObject:model];
                        
                        NSMutableDictionary *twoDictM = [NSMutableDictionary dictionary];
                        twoDictM[@"productsubcategory_id"] = @"";
                        twoDictM[@"sv_psc_name"] = @"全部";
                        SVClassficationModel *twoModel = [SVClassficationModel mj_objectWithKeyValues:twoDictM];
                        twoModel.isSelect = @"1";
                        [self.twoSelectModelArray addObject:twoModel];
                        [self.twoDataArray addObject:twoModel];
                    }else{
            //            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            //            dictM[@"sv_psc_parentid"] = [NSString stringWithFormat:@"%@",self.bigIDArr[i]];
            //            dictM[@"sv_psc_name"] = self.bigNameArr[i];
                        NSDictionary *dict = self.categaryArray[i];
                        SVClassficationModel *model = [SVClassficationModel mj_objectWithKeyValues:dict];
                        [self.oneDataArray addObject:model];
                    }
             //   }
                
                [self.oneTableView reloadData];
            }
            
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
           // dic[@"msg"];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
    
}

- (void)dealloc{
  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetFirstCategoryPost" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.oneTableView) {
        return self.oneDataArray.count;
    }else{
        return self.twoDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.oneTableView) {
        SVClassficationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oneWaresListVCellID];
        if (!cell) {
            cell = [[SVClassficationViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneWaresListVCellID];
        }
        cell.backgroundColor = BackgroundColor;

            SVClassficationModel *model = self.oneDataArray[indexPath.row];
       // model.isSelect = @"0";
        NSLog(@"self.oneDataArray = %@",self.oneDataArray);
             for (SVClassficationModel *selectModel in self.oneSelectModelArray) {
                 if (selectModel.id.integerValue == model.id.integerValue) {
                     cell.oneModel = selectModel;
                     return cell;
                 }
             }
             cell.oneModel = model;

             return cell;
     //   }
      
    } else {

        SVClassficationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oneWaresListVCellID];
        if (!cell) {
            cell = [[SVClassficationViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oneWaresListVCellID];
        }
//        cell.twoModel = self.twoDataArray[indexPath.row];
//        return cell;
        SVClassficationModel *model = self.twoDataArray[indexPath.row];
    
     NSLog(@"self.twoDataArray = %@",self.twoDataArray);
         for (SVClassficationModel *selectModel in self.twoSelectModelArray) {
             if (selectModel.productsubcategory_id.integerValue == model.productsubcategory_id.integerValue) {
                 cell.twoModel = selectModel;
                 return cell;
             }
         }
         cell.twoModel = model;

         return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.oneTableView) {
        SVClassficationModel *model = self.oneDataArray[indexPath.row];
      //  [self getProductGetCategoryByIdCid:model.sv_psc_parentid.integerValue];
        model.isSelect = @"1";
//        if (self.oneSelectModelArray.count == 0) {
//            [self.oneSelectModelArray addObject:model];
//        }else{
            //判断相同时，先删掉，再添加到数组中
            for (SVClassficationModel *selctModel in self.oneSelectModelArray) {
                
                if (selctModel.id.integerValue == model.id.integerValue) {
                    model.isSelect = @"0";
                    [self.oneSelectModelArray removeObject:selctModel];
                    
                    break;
                    
                }else{
                    if (selctModel.id.integerValue == 0) {
                        SVClassficationModel *model = self.oneDataArray[0];
                        model.isSelect = @"0";
                        [self.oneSelectModelArray removeObject:selctModel];
                    }
                }
            }
            
            //   当为选中1状态时，添加
            if ([model.isSelect isEqualToString:@"1"]) {
                if (model.id.integerValue == 0) {
                    [self.oneSelectModelArray removeAllObjects];
                    for (SVClassficationModel *onemodel in self.oneDataArray) {
                        onemodel.isSelect = @"0";
                    }
                    model.isSelect = @"1";
                }
              
                [self.oneSelectModelArray addObject:model];
                
            }

        if (kArrayIsEmpty(self.oneSelectModelArray)) {
          //  self.oneSelectModelArray
            SVClassficationModel *model = self.oneDataArray[0];
            model.isSelect = @"1";
            [self.oneSelectModelArray addObject:model];
        }
        
        if (self.oneSelectModelArray.count > 1) {
            [self getProductGetCategoryByIdCid:0];
        }else if (self.oneSelectModelArray.count == 1){
            SVClassficationModel *model = self.oneSelectModelArray[0];
            [self getProductGetCategoryByIdCid:model.id.integerValue];
        }
    
        
        NSLog(@"self.oneSelectModelArray = %@",self.oneSelectModelArray);
        
        [self.oneTableView reloadData];

    }else{
       
        SVClassficationModel *model = self.twoDataArray[indexPath.row];
      //  [self getProductGetCategoryByIdCid:model.sv_psc_parentid.integerValue];
        model.isSelect = @"1";
            //判断相同时，先删掉，再添加到数组中
            for (SVClassficationModel *selctModel in self.twoSelectModelArray) {
                
                if (selctModel.productsubcategory_id.integerValue == model.productsubcategory_id.integerValue) {
                    model.isSelect = @"0";
                    [self.twoSelectModelArray removeObject:selctModel];
                  
                    break;
                    
                }else{
                    if (selctModel.productsubcategory_id.integerValue == 0) {
                        SVClassficationModel *model = self.twoDataArray[0];
                        model.isSelect = @"0";
                        [self.twoSelectModelArray removeObject:selctModel];
                    }
                }
            }
            
            //   当为选中1状态时，添加
            if ([model.isSelect isEqualToString:@"1"]) {
                if (model.productsubcategory_id.integerValue == 0) {
                    [self.twoSelectModelArray removeAllObjects];
                    for (SVClassficationModel *onemodel in self.twoDataArray) {
                        onemodel.isSelect = @"0";
                    }
                    model.isSelect = @"1";
                }
              
                [self.twoSelectModelArray addObject:model];
                
            }

        if (kArrayIsEmpty(self.twoSelectModelArray)) {
            SVClassficationModel *model = self.twoDataArray[0];
            model.isSelect = @"1";
            [self.twoSelectModelArray addObject:model];
        }
        
        NSLog(@"self.twoSelectModelArray4444 = %@",self.twoSelectModelArray);
        
        [self.twoTableView reloadData];
    }
}
#pragma mark - 确认按钮的点击
- (IBAction)confirmClick:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock(self.oneSelectModelArray, self.twoSelectModelArray);
    }
}
#pragma mark - 清空按钮的点击
- (IBAction)cleanClick:(id)sender {
    [self.oneSelectModelArray removeAllObjects];
    [self.twoSelectModelArray removeAllObjects];
    [self tableView:self.oneTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    SVClassficationModel *model = self.oneDataArray[0];
//    model.isSelect = @"1";
//    [self.oneSelectModelArray addObject:model];
    
  //  [self getProductGetCategoryByIdCid:0]; //getProductGetCategoryByIdCid
  //  [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]animated:YES scrollPosition:UITableViewScrollPositionNone];//tableview设置默认行必须放在reloaddata后
  
}



#pragma mark - 二级分类
- (void)getProductGetCategoryByIdCid:(NSInteger)cid{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetCategoryById?key=%@&cid=%ld",[SVUserManager shareInstance].access_token,cid];
    NSLog(@"fff---%@",urlStr);
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic---%@",dic);
        NSArray *valuesArray = dic[@"values"];
        [self.twoDataArray removeAllObjects];
        [self.twoSelectModelArray removeAllObjects];
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        dictM[@"productsubcategory_id"] = @"";
        dictM[@"sv_psc_name"] = @"全部";
        SVClassficationModel *model = [SVClassficationModel mj_objectWithKeyValues:dictM];
        model.isSelect = @"1";
        [self.twoSelectModelArray addObject:model];
        [self.twoDataArray addObject:model];
        
        
        if (!kArrayIsEmpty(valuesArray)) {
            NSArray *modelArray=[SVClassficationModel mj_objectArrayWithKeyValuesArray:valuesArray];
            [self.twoDataArray addObjectsFromArray:modelArray];
        }
        
        if (self.oneSelectModelArray.count > 1) {
            [self.twoSelectModelArray removeAllObjects];
            [self.twoDataArray removeAllObjects];
            NSMutableDictionary *twoDictM = [NSMutableDictionary dictionary];
            twoDictM[@"productsubcategory_id"] = @"";
            twoDictM[@"sv_psc_name"] = @"全部";
            SVClassficationModel *twoModel = [SVClassficationModel mj_objectWithKeyValues:twoDictM];
            twoModel.isSelect = @"1";
            [self.twoSelectModelArray addObject:twoModel];
            [self.twoDataArray addObject:twoModel];
           // [self.twoTableView reloadData];
        }
        
        [self.twoTableView reloadData];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
}

#pragma mark - 懒加载
-(NSMutableArray *)bigNameArr{
    if (!_bigNameArr) {
        _bigNameArr = [NSMutableArray array];
    }
    return _bigNameArr;
}

-(NSMutableArray *)bigIDArr{
    if (!_bigIDArr) {
        _bigIDArr = [NSMutableArray array];
    }
    return _bigIDArr;
}

- (NSMutableArray *)twoDataArray{
    if (!_twoDataArray) {
        _twoDataArray = [NSMutableArray array];
    }
    return _twoDataArray;
}

- (NSMutableArray *)oneDataArray{
    if (!_oneDataArray) {
        _oneDataArray = [NSMutableArray array];
    }
    return _oneDataArray;
}

- (NSMutableArray *)oneSelectModelArray
{
    if (!_oneSelectModelArray) {
        _oneSelectModelArray = [NSMutableArray array];
    }
    
    return _oneSelectModelArray;
}

- (NSMutableArray *)twoSelectModelArray
{
    if (!_twoSelectModelArray) {
        _twoSelectModelArray = [NSMutableArray array];
    }
    
    return _twoSelectModelArray;
}

@end
