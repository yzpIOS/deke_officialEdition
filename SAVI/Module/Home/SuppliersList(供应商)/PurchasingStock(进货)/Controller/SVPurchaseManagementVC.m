//
//  SVPurchaseManagementVC.m
//  SAVI
//
//  Created by houming Wang on 2019/8/2.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVPurchaseManagementVC.h"
#import "SVWaresListVC.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
#import "SVduoguigeModel.h"
#import "SVselectShopListVC.h"
@interface SVPurchaseManagementVC ()
@property (nonatomic,strong) SVWaresListVC *listVC;
@property (nonatomic,strong) QQLBXScanViewController *lbxScanVC;
@property (nonatomic,strong) UILabel *addShopLabel;
//@property (nonatomic,strong) NSMutableArray *selectModelArray;
@property (nonatomic,assign) NSInteger addShopTotleNum;
@property (nonatomic,assign) NSInteger selectNum;
@end

@implementation SVPurchaseManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
  //  NSArray *arr = [NSArray array];
   // NSArray *arr = [[NSArray alloc]initWithObjects:@"选商品",@"扫款号", nil];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        NSArray *arr = [[NSArray alloc]initWithObjects:@"选商品",@"扫款号", nil];
        self.view.backgroundColor = [UIColor whiteColor];
        //初始化UISegmentedControl
        //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
        segment.selectedSegmentIndex = 0;
        [self segmentClick:segment];
        
        //设置frame
        segment.frame = CGRectMake(0, 0, 150, 30);
        
        [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segment;
    }else{
        
        NSArray *arr = [[NSArray alloc]initWithObjects:@"选商品",@"扫条码", nil];
        self.view.backgroundColor = [UIColor whiteColor];
        //初始化UISegmentedControl
        //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
        segment.selectedSegmentIndex = 0;
        [self segmentClick:segment];
        
        //设置frame
        segment.frame = CGRectMake(0, 0, 150, 30);
        
        [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segment;
    }
    
    
   // self.controllerNum = 1;
    // 创建两个控制器
    self.listVC = [[SVWaresListVC alloc] init];
    self.listVC.controllerNum = self.controllerNum;
   // self.listVC.selectModelArray = self.selectModelArray;
    [self addChildViewController:self.listVC];
    

    self.listVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH-BottomHeight-60);
//=======
//    self.listVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH-BottomHeight-50);
//>>>>>>> origin/oem_deduction
    self.listVC.purchaseManagementVC = self;
    [self.view addSubview:self.listVC.view];
    
    __weak typeof(self) weakSelf = self;

    #pragma mark - 返回数组
    self.listVC.selectModelBlock = ^(SVduoguigeModel *model) {
//         for (SVduoguigeModel *model in selectArray) {
                    if (weakSelf.selectModelArray.count == 0) {
                        //第一个选中时添加
                        
                        [weakSelf.selectModelArray addObject:model];
                        
                        
                    } else {
                        
                        for (SVduoguigeModel *modell in weakSelf.selectModelArray) {
                            // SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                            if (modell.product_id == model.product_id) {
                                // model.product_num += modell.product_num;

                                //                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"product_num"];
                                [weakSelf.selectModelArray removeObject:modell];
                                break;
                            }
                        }
                        
                        
                        
                        if (model.isSelect.intValue == 1) {
                             [weakSelf.selectModelArray addObject:model];
                        }
                       
                        
                        
                    }
              //  }
                
                weakSelf.addShopTotleNum = weakSelf.selectModelArray.count;
                weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
        //        weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",selectArray.count];
        //         weakSelf.selectModelArray = selectArray;
    };
    
    self.lbxScanVC = [[QQLBXScanViewController alloc] init];
    self.lbxScanVC.libraryType = [Global sharedManager].libraryType;
    self.lbxScanVC.scanCodeType = [Global sharedManager].scanCodeType;
    self.lbxScanVC.isStockPurchase = 1;
    self.lbxScanVC.purchaseManagementVC = self;
    self.lbxScanVC.selectDuoguigeModel = ^(SVduoguigeModel *model) {
        weakSelf.selectNum = 1;
        if (self.selectModelArray.count == 0) {
            weakSelf.selectNum = 0;
            weakSelf.addShopTotleNum += 1;
            weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
            [weakSelf.selectModelArray addObject:model];
        }else{
            for (SVduoguigeModel *modell in weakSelf.selectModelArray) {
                if (model.product_id == modell.product_id) {
                    [weakSelf.selectModelArray removeObject:modell];
                    weakSelf.addShopTotleNum -= 1;
                    //  [SVTool TextButtonAction:self.view withSing:@"已经添加过了"];
                    break;
                }else{
                    
                }
            }
        }
        
        if (weakSelf.selectNum == 1) {
            weakSelf.addShopTotleNum += 1;
            weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
            [weakSelf.selectModelArray addObject:model];
        }
    };
    // self.lbxScanVC.stockCheckVC = self;
    self.lbxScanVC.style = [StyleDIY weixinStyle];
    [self addChildViewController:self.lbxScanVC];
    
    
    [self setupBottomView];
}



- (void)segmentClick:(UISegmentedControl *)segment{
    // 切换视图
    if (segment.selectedSegmentIndex == 0) {
        //  [self.lbxScanVC removeFromParentViewController];
        self.listVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH - BottomHeight - 50-TopHeight);
        [self.lbxScanVC stopScan];
        [self.view addSubview:self.listVC.view];
        
        
    } else if (segment.selectedSegmentIndex == 1) {
        self.lbxScanVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH - BottomHeight - 50-TopHeight);
        [self.lbxScanVC reStartDevice];
        [self.view addSubview:self.lbxScanVC.view];
        
    }
}

#pragma mark - 多规格代理方法
- (void)selectMoreModelClick:(NSMutableArray *)selectModelArray{
    
    if (!kArrayIsEmpty(selectModelArray)) {
        for (SVduoguigeModel *model in selectModelArray) {
            if (self.selectModelArray.count == 0) {
                //第一个选中时添加
                
                [self.selectModelArray addObject:model];
                
                
            } else {
                
                for (SVduoguigeModel *modell in self.self.selectModelArray) {
                    // SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                    if (modell.product_id == model.product_id) {
                        // model.product_num += modell.product_num;
                        
                        //                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"product_num"];
                        [self.selectModelArray removeObject:modell];
                        break;
                    }
                }
                
                
                [self.selectModelArray addObject:model];
                
                
            }
        }
        
        self.addShopTotleNum = self.selectModelArray.count;
        self.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",self.addShopTotleNum];
        
        //        NSArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
        //
        //        SVduoguigeModel *model = [ary_1 objectAtIndex:self.selectCellIndex];//这里有一个报错
        //        //  model.isSelect = @"1";
        //        // self.model.isSelect = @"1";
        //        if ([model.isSelect isEqualToString:@"1"]) {
        //            if (self.purchaseArr.count == 0) {
        //                //第一个选中时添加
        //                [self.purchaseArr addObject:model];
        //            } else {
        //
        //                //判断相同时，先删掉，再添加到数组中
        //                for (NSDictionary *dict in self.purchaseArr) {
        //                    SVduoguigeModel *modell = [SVduoguigeModel mj_objectWithKeyValues:dict];
        //                    if (modell.product_id == model.product_id) {
        //                        [self.purchaseArr removeObject:dict];
        //                        break;
        //                    }
        //                }
        //
        //                //当为选中1状态时，添加
        //                if ([model.isSelect isEqualToString:@"1"]) {
        //                    [self.purchaseArr addObject:model];
        //                }
        //
        //            }
        //        }
        
        
        //  [self.twoTableView reloadData];
    }
}

#pragma mark - 底部view的创建
- (void)setupBottomView{
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-BottomHeight);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:navigationBackgroundColor];
    [btn addTarget:self action:@selector(selectArrBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [bottomView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomView.mas_right);
        make.bottom.mas_equalTo(bottomView.mas_bottom);
        make.width.mas_equalTo(ScreenW / 3);
        make.height.mas_equalTo(50);
    }];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *leftView = [[UIView alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [leftView addGestureRecognizer:tap];
    [bottomView addSubview:leftView];
    leftView.backgroundColor = [UIColor whiteColor];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(ScreenW/3*2);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-BottomHeight);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    self.addShopLabel = label;
    [leftView addSubview:label];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = GlobalFontColor;
    label.text = @"未选择";
    UIImageView *icon = [[UIImageView alloc] init];
    [leftView addSubview:icon];
    icon.image = [UIImage imageNamed:@"brithdaySmall"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(leftView.mas_right).offset(-10);
        make.centerY.mas_equalTo(leftView.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    //    rightImage.image = [UIImage imageNamed:@""];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.right.mas_equalTo(self.view.mas_right);
        //  make.width.mas_equalTo(ScreenW/3*2);
        make.left.mas_equalTo(leftView.mas_left).offset(10);
        // make.height.mas_equalTo(50);
        make.centerY.mas_equalTo(leftView.mas_centerY);
    }];
    
}

#pragma mark - 左边view点击
- (void)selectArrBtnClick{
    if (kArrayIsEmpty(self.selectModelArray)) {
        [SVTool TextButtonActionWithSing:@"未选择"];
    }else{
        if (self.addWarehouseWares) {
            self.addWarehouseWares(self.selectModelArray);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

#pragma mark - 确定按钮
- (void)tapClick{
    SVselectShopListVC *vc = [[SVselectShopListVC alloc] init];
    vc.selectArray = self.selectModelArray;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSMutableArray *)selectModelArray
{
    if (!_selectModelArray) {
        _selectModelArray = [NSMutableArray array];
    }
    
    return _selectModelArray;
}
@end
