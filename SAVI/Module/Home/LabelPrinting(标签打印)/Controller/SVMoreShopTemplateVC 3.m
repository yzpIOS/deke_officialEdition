//
//  SVMoreShopTemplateVC.m
//  SAVI
//
//  Created by houming Wang on 2019/4/13.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVMoreShopTemplateVC.h"
#import "SVWaresListModel.h"
#import "SVduoguigeModel.h"
#import "SVMoreSpecificationsCell.h"
#import "SVproductCustomModel.h"
#import "SVSelectPrintVC.h"
static NSString *tableViewCellID = @"SVMoreSpecificationsCell";
@interface SVMoreShopTemplateVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *moreSpecifications;
@property (nonatomic,strong) NSMutableArray *duoguigeArray;
@property (nonatomic,strong) NSMutableArray *sessionModelArray;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *totleNumber;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (nonatomic,assign) ConnectState state;


@end

@implementation SVMoreShopTemplateVC

- (void)viewDidLoad {
    [super viewDidLoad];
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self.moreSpecifications removeAllObjects];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//
    [self.tableView registerNib:[UINib nibWithNibName:@"SVMoreSpecificationsCell" bundle:nil] forCellReuseIdentifier:tableViewCellID];
//
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
    
    [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    
    self.navigationItem.title = @"商品";
    self.textField.delegate = self;
    NSMutableArray *idArray = [NSMutableArray array];
        [self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SVWaresListModel *model = obj;
            [idArray addObject:model.product_id];
        }];
    
     [self loadDataProduceID:idArray];

}
- (void)loadDataProduceID:(NSMutableArray *)productID{
    [SVUserManager loadUserInfo];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/PostBatchMorespecSubProductList?key=%@",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:productID progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic多规格打印多商品 = %@",dic);

        NSMutableArray *bigArray = dic[@"values"];
       self.sessionModelArray = [SVproductCustomModel mj_objectArrayWithKeyValuesArray:bigArray];
        for (NSDictionary *dic in bigArray) {
           
            NSArray *array = dic[@"productCustomdDetailList"];
            if (kArrayIsEmpty(array)) {// 不是多规格
                NSMutableArray *singArray = [NSMutableArray array];
                SVWaresListModel *model = [SVWaresListModel mj_objectWithKeyValues:dic];
                [singArray addObject:model];
                [self.moreSpecifications addObject:singArray];
            }else{
                NSMutableArray *array2 = [SVWaresListModel mj_objectArrayWithKeyValuesArray:array];
                [self.moreSpecifications addObject:array2];
            }
        }
        
        [self.tableView reloadData];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     NSInteger count = [self.textField.text integerValue];
   
        self.textField.text = [NSString stringWithFormat:@"%ld",count];
        NSInteger totle = 0;
        for (NSMutableArray *array in self.moreSpecifications) {
            for (SVWaresListModel *model in array) {
                if ([model.isSelect isEqualToString:@"1"]) {
                    model.sv_p_storage = self.textField.text;
                    NSInteger toCount = [model.sv_p_storage integerValue];
                    
                    totle += toCount;
                }
               
            }
        }
    
    self.totleNumber.text = [NSString stringWithFormat:@"%ld",totle];
    
        [self.tableView reloadData];
 
}

#pragma mark - 确认打印按钮
- (IBAction)sureClick:(id)sender {
    if ([self.totleNumber.text integerValue] <= 0) {
        [SVTool TextButtonAction:self.view withSing:@"数量不能为0"];
    }else{
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSMutableArray *array in self.moreSpecifications) {
            for (SVWaresListModel *model in array) {
                if ([model.isSelect isEqualToString:@"1"]) {
                    [modelArray insertObject:model atIndex:0];
                  //  [modelArray addObject:model];
                }
            }
        }
        SVSelectPrintVC *selectPrintVC = [[SVSelectPrintVC alloc] init];
        
        selectPrintVC.interface = 2;
        selectPrintVC.choiceNum = 1;
        selectPrintVC.state = ^(ConnectState state) {
            NSLog(@"state = %ld",state);
            self.state = state;
            [self updateConnectState:state];
        };
        
        [SVUserManager shareInstance].indexpath = self.state;
        
        if ([SVUserManager shareInstance].indexpath == 3) {
            
            selectPrintVC.labelPrintArray = modelArray;
            [self.navigationController pushViewController:selectPrintVC animated:YES];
            
            
        }else {
            
             selectPrintVC.labelPrintArray = modelArray;
            
            [self.navigationController pushViewController:selectPrintVC animated:YES];
        }
        
      //  [self.navigationController pushViewController:selectPrintVC animated:YES];
    }
}


-(void)updateConnectState:(ConnectState)state {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case CONNECT_STATE_CONNECTING:
          
                break;
            case CONNECT_STATE_CONNECTED:
               // [SVTool TextButtonAction:self.view withSing:@"连接成功"];
                //                [Manager close];
                //                [SVProgressHUD showSuccessWithStatus:@"连接成功"];
                // self.ConnState.text = @"连接状态：已连接";
                 [SVProgressHUD showSuccessWithStatus:@"连接成功"];
                break;
            case CONNECT_STATE_FAILT:
//            {
//                SVSelectPrintVC *selectPrintVC = [[SVSelectPrintVC alloc] init];
//                
//                selectPrintVC.interface = 2;
//                selectPrintVC.choiceNum = 1;
//                
//                [SVUserManager shareInstance].indexpath = self.state;
//                
//                if ([SVUserManager shareInstance].indexpath == 3) {
//                    
//                    //  selectPrintVC.labelPrintArray = modelArray;
//                    [self.navigationController pushViewController:selectPrintVC animated:YES];
//                    
//                    
//                }else {
//                    
//                    // selectPrintVC.labelPrintArray = modelArray;
//                    
//                    [self.navigationController pushViewController:selectPrintVC animated:YES];
//                }
//                
//                  [SVProgressHUD showErrorWithStatus:@"连接失败，请重连其他蓝牙"];
//            }
         
//                [self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>]
             
                [SVProgressHUD showErrorWithStatus:@"连接失败"];
                //  self.ConnState.text = @"连接状态：连接失败";
                break;
            case CONNECT_STATE_DISCONNECT:
                  [SVProgressHUD showInfoWithStatus:@"断开连接"];
                // [SVProgressHUD showInfoWithStatus:@"断开连接"];
                // self.ConnState.text = @"连接状态：断开连接";
                break;
            default:
                // self.ConnState.text = @"连接状态：连接超时";
                break;
        }
        
    });
    
}


//展示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.sessionModelArray.count;


}

//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 80;

}

- (IBAction)reduceClick:(id)sender {
    NSInteger count = [self.textField.text integerValue];
    if (count <= 0) {
        self.textField.hidden = YES;
    }else{
        count -= 1;
        self.textField.text = [NSString stringWithFormat:@"%ld",count];
        NSInteger totle = 0;
        for (NSMutableArray *array in self.moreSpecifications) {
            for (SVWaresListModel *model in array) {
                if ([model.isSelect isEqualToString:@"1"]) {
                    model.sv_p_storage = self.textField.text;
                    NSInteger toCount = [model.sv_p_storage integerValue];
                    totle += toCount;
                }
              
            }
        }
        self.totleNumber.text = [NSString stringWithFormat:@"%ld",totle];
        [self.tableView reloadData];
    }

}

- (IBAction)addClick:(id)sender {
    self.textField.hidden = NO;
    NSInteger count = [self.textField.text integerValue];
    count += 1;
    self.textField.text = [NSString stringWithFormat:@"%ld",count];
    NSInteger totle = 0;
    for (NSMutableArray *array in self.moreSpecifications) {
        for (SVWaresListModel *model in array) {
            if ([model.isSelect isEqualToString:@"1"]) {
                model.sv_p_storage = self.textField.text;
                NSInteger toCount = [model.sv_p_storage integerValue];
                totle += toCount;
            }
        }
    }
    self.totleNumber.text = [NSString stringWithFormat:@"%ld",totle];
    [self.tableView reloadData];
}

- (IBAction)allSelelctClick:(UIButton *)btn {
    if (btn.selected == YES) {// 取消全选
        [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
        NSInteger totle = 0;
        for (NSMutableArray *array in self.moreSpecifications) {
            for (SVWaresListModel *model in array) {
                model.isSelect = @"0";
////                    model.sv_p_storage = self.textField.text;
//                NSInteger toCount = [model.sv_p_storage integerValue];
//                totle += toCount;
              
            }
        }
        self.totleNumber.text = [NSString stringWithFormat:@"%ld",totle];
        [self.tableView reloadData];
        self.allSelectBtn.selected = NO;
        
    }else{// 全选
        [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
        
        NSInteger totle = 0;
        for (NSMutableArray *array in self.moreSpecifications) {
            for (SVWaresListModel *model in array) {
                model.isSelect = @"1";
               // model.sv_p_storage = self.textField.text;
                
                NSInteger toCount = [model.sv_p_storage integerValue];
                totle += toCount;
                
            }
        }
        self.totleNumber.text = [NSString stringWithFormat:@"%ld",totle];
        [self.tableView reloadData];
         self.allSelectBtn.selected = YES;
    }
    
}


//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SVproductCustomModel *model = self.sessionModelArray[section];
     UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    if (![SVTool isBlankString:model.sv_p_images2]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:model.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];

    } else {

        imageView.image = [UIImage imageNamed:@"foodimg"];
    }

    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
        make.centerY.mas_equalTo(headerView.mas_centerY);
    }];

    UILabel *nameL = [[UILabel alloc] init];
    nameL.font = [UIFont systemFontOfSize:14];
    nameL.text = model.sv_p_name;
    nameL.textColor = GlobalFontColor;
    [headerView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.top.mas_equalTo(imageView.mas_top).offset(5);
    }];

    UILabel *moneyL = [[UILabel alloc] init];
    moneyL.font = [UIFont systemFontOfSize:14];
    moneyL.text = [NSString stringWithFormat:@"￥%@",model.sv_p_unitprice];
    moneyL.textColor = [UIColor orangeColor];
    [headerView addSubview:moneyL];
    [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.bottom.mas_equalTo(imageView.mas_bottom).offset(-5);
    }];


    return headerView;

}


//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


  //  NSMutableArray *moreArray = self.moreSpecifications[section] == nil ? ;
    if (kArrayIsEmpty(self.moreSpecifications)) {
         return 0;
    }else{
        NSLog(@"self.moreSpecifications = %@",self.moreSpecifications);
        NSMutableArray *moreArray = self.moreSpecifications[section];
        return moreArray.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVMoreSpecificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        cell = [[SVMoreSpecificationsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
    }
    if (!kArrayIsEmpty(self.moreSpecifications)) {
        NSMutableArray *moreArray = self.moreSpecifications[indexPath.section];
        cell.model = moreArray[indexPath.row];
        cell.index = indexPath;
    }
    
    __weak typeof(self) weakSelf = self;
    cell.model_block = ^(SVWaresListModel * _Nonnull model, NSIndexPath * _Nonnull index) {
        NSMutableArray *moreArray = weakSelf.moreSpecifications[index.section];
         [moreArray replaceObjectAtIndex:index.row withObject:model];//替换数据源，好了可以去刷新了
        NSInteger totle = 0;
//        NSInteger allTotleNumber = 0;
        for (NSMutableArray *moreArray2 in weakSelf.moreSpecifications) {
            for (SVWaresListModel *model in moreArray2) {
                if ([model.isSelect isEqualToString:@"1"]) {
                    NSInteger toCount = [model.sv_p_storage integerValue];
                    totle += toCount;
                    
                    
                }else{
                    [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
                    self.allSelectBtn.selected = NO;
                }
                
            }
          
           
            
           
        }
        
        
        
         weakSelf.totleNumber.text = [NSString stringWithFormat:@"%ld",totle];
    };
    


    return cell;
}

- (NSMutableArray *)moreSpecifications{
    if (!_moreSpecifications) {
        _moreSpecifications = [NSMutableArray array];
    }
    
    return _moreSpecifications;
}

- (NSMutableArray *)duoguigeArray
{
    if (_duoguigeArray == nil) {
        _duoguigeArray = [NSMutableArray array];
    }
    return _duoguigeArray;
}

- (NSMutableArray *)sessionModelArray
{
    if (_sessionModelArray == nil) {
        _sessionModelArray = [NSMutableArray array];
    }
    return _sessionModelArray;
}

@end
