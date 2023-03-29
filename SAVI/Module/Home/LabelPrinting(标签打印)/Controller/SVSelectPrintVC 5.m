//
//  SVBluetoothVC.m
//  SAVI
//
//  Created by houming Wang on 2018/5/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVSelectPrintVC.h"
#import "JWBluetoothManage.h"

#import "SVPrinterSizeCell.h"
#import "SVSeveralCopiesCell.h"
#import "SVNumberOfCopiesCell.h"
#import "SVPrintFlowLayout.h"
#import "SVPrintCollectionViewCell.h"
#import "TscCommand.h"
#import "SVWaresListModel.h"
#import "BluetoothListViewController.h"
#import "SVSearchBluetoothCell.h"
#import "SVBluetoothListVC.h"
#define WeakSelf __block __weak typeof(self)weakSelf = self;

static NSString *BluetoothID = @"BluetoothColl";
static NSString *BluetoothXIBID = @"BluetoothXIBColl";
static NSString *BluetoothNumXIBID = @"BluetoothNumXIBColl";
static NSString *PrintBluetoothID = @"PrintBluetoothColl";
static NSString *const collectionViewCellID = @"SVPrintCollectionViewCell";
static NSString *const searchBluetoothCellID = @"SVSearchBluetoothCell";
static NSString *tableViewCellID = @"tableViewCell";
@interface SVSelectPrintVC () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    JWBluetoothManage * manage;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,assign) NSInteger three;

@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property(strong,nonatomic)CBPeripheral *currPeripheral;//要连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用
@property (nonatomic,strong) UICollectionView *PrintingCollectionView;

@property (nonatomic,strong) NSArray *sizeArray;

@property (nonatomic,strong) NSArray *sizeImageArray;


@property(nonatomic,strong)NSMutableArray *devices;
@property(nonatomic,strong)NSMutableDictionary *dicts;

@property (nonatomic,strong) UILabel *connState;
@property (nonatomic,strong) NSString *sv_p_memberprice;
@property (nonatomic,strong) NSString *nameState;
@property (nonatomic,strong) NSString *bluetoothName;
/*
 事情不是想着怎么去抱怨，而是想着怎么去解决。
 */

@end

@implementation SVSelectPrintVC
- (NSMutableArray *)labelPrintArray
{
    if (_labelPrintArray == nil) {
        _labelPrintArray = [NSMutableArray array];
    }
    return _labelPrintArray;
}


-(NSMutableArray *)devices {
    if (!_devices) {
        _devices = [[NSMutableArray alloc]init];
    }
    return _devices;
}

-(NSMutableDictionary *)dicts {
    if (!_dicts) {
        _dicts = [[NSMutableDictionary alloc]init];
    }
    return _dicts;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (Manager.bleConnecter == nil) {
        [Manager didUpdateState:^(NSInteger state) {
            // NSLog(@"state = %ld",state);
            switch (state) {
                case CBCentralManagerStateUnsupported:
                    //  NSLog(@"The platform/hardware doesn't support Bluetooth Low Energy.");
                    break;
                case CBCentralManagerStateUnauthorized:
                    //  NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
                    break;
                case CBCentralManagerStatePoweredOff:
                    //  NSLog(@"Bluetooth is currently powered off.");
                    break;
                case CBCentralManagerStatePoweredOn:
                    [self startScane];
                    //  NSLog(@"Bluetooth power on");
                    break;
                case CBCentralManagerStateUnknown:
                default:
                    break;
            }
        }];
    } else {
        [self startScane];
    }
}

-(void)updateConnectState:(ConnectState)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case CONNECT_STATE_CONNECTING:
            {
                self.connState.text = @"连接中";
                self.nameState = @"连接中";
                self.three = 1;
                [self.tableView reloadData];
            }
                
                break;
            case CONNECT_STATE_CONNECTED:
            {
                [SVProgressHUD showSuccessWithStatus:@"连接成功"];
                self.connState.text = @"已连接";
                self.nameState = @"已连接";
                self.three = 1;
                [self.tableView reloadData];
            }
                break;
            case CONNECT_STATE_FAILT:
            {
                [SVProgressHUD showErrorWithStatus:@"连接失败"];
                self.connState.text = @"连接失败";
                self.nameState = @"连接失败";
                self.three = 1;
                [self.tableView reloadData];
            }
                break;
            case CONNECT_STATE_DISCONNECT:
            {
                [SVProgressHUD showInfoWithStatus:@"断开连接"];
                self.connState.text = @"断开连接";
                self.nameState = @"断开连接";
                self.three = 1;
                [self.tableView reloadData];
            }
                break;
            default:
                self.connState.text = @"连接超时";
                self.nameState = @"连接超时";
                self.three = 1;
                [self.tableView reloadData];
                break;
        }
    });
}


-(void)startScane {
    [Manager scanForPeripheralsWithServices:nil options:nil discover:^(CBPeripheral * _Nullable peripheral, NSDictionary<NSString *,id> * _Nullable advertisementData, NSNumber * _Nullable RSSI) {
        if (peripheral.name != nil) {
            //  NSLog(@"name -> %@",peripheral.name);
            NSUInteger oldCounts = [self.dicts count];
            [self.dicts setObject:peripheral forKey:peripheral.identifier.UUIDString];
            if (oldCounts < [self.dicts count]) {
                [self.tableView reloadData];
                
            }
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVUserManager shareInstance].labelPrinterSize = @"0";
    //self.navigationItem.title = @"打印小票";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"搜索蓝牙" style:UIBarButtonItemStylePlain target:self action:@selector(searchBluetooth)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.dataSource = @[].mutableCopy;
    self.rssisArray = @[].mutableCopy;
    // 标签打印和打印份数
    //    [SVUserManager loadUserInfo];
    if ([SVTool isBlankString:[SVUserManager shareInstance].labelPrinterSize]) {
        [SVUserManager shareInstance].labelPrinterSize = [NSString stringWithFormat:@"%d",0];
    }
    if ([SVTool isBlankString:[SVUserManager shareInstance].labelPrinterNumber]) {
        [SVUserManager shareInstance].labelPrinterNumber = @"1";
        //        [SVUserManager saveUserInfo];
    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight-BottomViewHeight-BottomHeight) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //RGBA(241, 241, 241, 1)
    self.tableView.backgroundColor = BackgroundColor;
    // UITableViewStyleGrouped样式时，隐藏上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    // 设置距离左右距离
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 44, 0, 0)];
    /** 去除tableview 右侧滚动条 */
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //添加到View上
    [self.view addSubview:self.tableView];
    
    //普通cell的注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BluetoothID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PrintBluetoothID];
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVPrinterSizeCell" bundle:nil] forCellReuseIdentifier:BluetoothXIBID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVNumberOfCopiesCell" bundle:nil] forCellReuseIdentifier:BluetoothNumXIBID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellID];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"SVSearchBluetoothCell" bundle:nil] forCellReuseIdentifier:searchBluetoothCellID];
    // UICollectionView注册
    [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVPrintCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
    self.PrintingCollectionView.delegate = self;
    self.PrintingCollectionView.dataSource = self;
    
    
    if (self.interface == 1) {
        self.title = @"打印设置";
        [UIView animateWithDuration:.1 animations:^{
            self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-TopHeight-BottomHeight);
        }];
    } else {
        self.title = @"选择打印";
        //底部按钮
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-BottomViewHeight-TopHeight-BottomHeight, ScreenW, BottomViewHeight)];
        [self.view addSubview:bottomView];
        
        UIView *threadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
        threadView.backgroundColor = threadColor;
        [bottomView addSubview:threadView];
        
        UIButton *bottomButton = [[UIButton alloc]init];
        bottomButton.layer.cornerRadius = ButtonCorner;
        bottomButton.backgroundColor = navigationBackgroundColor;
        [bottomButton setTitle:@"打印" forState:UIControlStateNormal];
        [bottomButton setTintColor:[UIColor whiteColor]];
        [bottomButton addTarget:self action:@selector(printe) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomButton];
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView);
            make.left.mas_equalTo(bottomView).offset(20);
            make.size.mas_equalTo(CGSizeMake(ScreenW-40, BottomButtonHeight));
        }];
    }
   
    [self.PrintingCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    // [self.PrintingCollectionView didsele]
    
    
    
}

-(void)searchBluetooth {
    SVBluetoothListVC *bluetooListVC = [[SVBluetoothListVC alloc] init];
    bluetooListVC.state = ^(ConnectState state) {
        
        [self updateConnectState:state];
    };
    
    bluetooListVC.nameBlock = ^(NSString * _Nonnull name) {
        self.bluetoothName = name;
    };
    [self.navigationController pushViewController:bluetooListVC animated:YES];
    

}




- (void)printe{
    if (self.choiceNum == 1) {
        if ([[SVUserManager shareInstance].labelPrinterSize isEqualToString:@"0"]) {
            for (SVWaresListModel *model in self.labelPrintArray) {
                // NSLog(@"model.sv_p_name = %@",model.sv_p_name);
                NSInteger storageNumber = [model.sv_p_storage integerValue];
                for (NSInteger i = 0; i < storageNumber; i++) {
                    [Manager write:[self tscCommandModel:model]];
                }
                
            }
        }else if ([[SVUserManager shareInstance].labelPrinterSize isEqualToString:@"1"]){
            for (SVWaresListModel *model in self.labelPrintArray) {
                NSInteger storageNumber = [model.sv_p_storage integerValue];
                for (NSInteger i = 0; i < storageNumber; i++) {
                     [Manager write:[self firstTscCommandModel:model]];
                }
               
            }
        }else if ([[SVUserManager shareInstance].labelPrinterSize isEqualToString:@"2"]){
            for (SVWaresListModel *model in self.labelPrintArray) {
               
                NSInteger storageNumber = [model.sv_p_storage integerValue];
                for (NSInteger i = 0; i < storageNumber; i++) {
                   [Manager write:[self secondTscCommandModel:model]];
                }
                
                
            }
        }else if ([[SVUserManager shareInstance].labelPrinterSize isEqualToString:@"3"]){
            for (SVWaresListModel *model in self.labelPrintArray) {
                NSInteger storageNumber = [model.sv_p_storage integerValue];
                for (NSInteger i = 0; i < storageNumber; i++) {
                    [Manager write:[self threeTscCommandModel:model]];
                }
                
            }
        }else{
            
            for (SVWaresListModel *model in self.labelPrintArray) {
                NSInteger storageNumber = [model.sv_p_storage integerValue];
                for (NSInteger i = 0; i < storageNumber; i++) {
                     [Manager write:[self fourTscCommandModel:model]];
                }
                
            }
        }
    }else{
        [SVUserManager loadUserInfo];
        for (NSInteger i = 0; i < [[SVUserManager shareInstance].labelPrinterNumber intValue]; i++) {
            
            if ([[SVUserManager shareInstance].labelPrinterSize isEqualToString:@"0"]) {
                for (SVWaresListModel *model in self.labelPrintArray) {
                    // NSLog(@"model.sv_p_name = %@",model.sv_p_name);
                    [Manager write:[self tscCommandModel:model]];
                }
            }else if ([[SVUserManager shareInstance].labelPrinterSize isEqualToString:@"1"]){
                for (SVWaresListModel *model in self.labelPrintArray) {
                    //   NSLog(@"model.sv_p_name = %@",model.sv_p_name);
                    
                    [Manager write:[self firstTscCommandModel:model]];
                }
            }else if ([[SVUserManager shareInstance].labelPrinterSize isEqualToString:@"2"]){
                for (SVWaresListModel *model in self.labelPrintArray) {
                    //   NSLog(@"model.sv_p_name = %@",model.sv_p_name);
                    
                    [Manager write:[self secondTscCommandModel:model]];
                }
            }else{
                for (SVWaresListModel *model in self.labelPrintArray) {
                    //   NSLog(@"model.sv_p_name = %@",model.sv_p_name);
                    
                    [Manager write:[self threeTscCommandModel:model]];
                }
            }
            
        }
    }

    
}



// 我看这里是标签打印的方法了
-(NSData *)tscCommandModel:(SVWaresListModel *)model{
    if (model.sv_p_artno.length >= 17 || model.sv_p_barcode.length >= 17) {
        TscCommand *command = [[TscCommand alloc]init];
        [command addSize:40 :30];
        [command addGapWithM:2 withN:0];
        [command addReference:0 :0];
        [command addTear:@"ON"];
        [command addQueryPrinterStatus:ON];
        [command addCls];
        [command addTextwithX:0 withY:20 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1 withText:model.sv_p_name];
        [command addTextwithX:0 withY:50 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"条码:%@",model.sv_p_barcode]];
        if (kStringIsEmpty(model.sv_p_artno)) {
             [command add1DBarcode:0 :80 :@"CODE128" :80 :1 :0 :2 :6 :model.sv_p_barcode];
        }else{
            [command add1DBarcode:0 :80 :@"CODE128" :80 :1 :0 :2 :6 :model.sv_p_artno];
        }
       
        [command addTextwithX:0 withY:200 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:model.sv_p_specs];
        [command addTextwithX:170 withY:200 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"￥%@",model.sv_p_unitprice]];
        
        [command addPrint:1 :1];
        return [command getCommand];
    }else{
        TscCommand *command = [[TscCommand alloc]init];
        [command addSize:40 :30];
        [command addGapWithM:2 withN:0];
        [command addReference:0 :0];
        [command addTear:@"ON"];
        [command addQueryPrinterStatus:ON];
        [command addCls];
        [command addTextwithX:30 withY:20 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1 withText:model.sv_p_name];
        [command addTextwithX:30 withY:50 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"条码:%@",model.sv_p_barcode]];
      //  [command add1DBarcode:30 :70 :@"CODE128" :80 :1 :0 :2 :6 :model.sv_p_barcode];
        if (kStringIsEmpty(model.sv_p_artno)) {
            [command add1DBarcode:30 :80 :@"CODE128" :80 :1 :0 :2 :6 :model.sv_p_barcode];
        }else{
            [command add1DBarcode:30 :80 :@"CODE128" :80 :1 :0 :2 :6 :model.sv_p_artno];
        }
        
        [command addTextwithX:30 withY:200 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:model.sv_p_specs];
        [command addTextwithX:200 withY:200 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"￥%@",model.sv_p_unitprice]];
        
        [command addPrint:1 :1];
        return [command getCommand];
    }
    
}

// 零售标签
- (NSData *)firstTscCommandModel:(SVWaresListModel *)model{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:50 :30];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addTear:@"ON"];
    [command addQueryPrinterStatus:ON];
    [command addCls];
    
    [command addTextwithX:176 withY:20 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1 withText:[SVUserManager shareInstance].sv_us_name];
    [command addTextwithX:80 withY:56 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:model.sv_p_name];
    [command addTextwithX:64 withY:93 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:@""];
    [command addTextwithX:64 withY:128 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:model.sv_p_unit];
    [command addTextwithX:64 withY:165 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:model.sv_p_specs];
    [command addTextwithX:64 withY:203 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:@""];
    [command addTextwithX:280 withY:136 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"%@元",model.sv_p_unitprice]];
    
    if ([model.sv_p_memberprice intValue] <= 0) {
        self.sv_p_memberprice = @"";
    }else{
        self.sv_p_memberprice = model.sv_p_memberprice;
    }
    [command addTextwithX:314 withY:200 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:self.sv_p_memberprice];
    
    [command addPrint:1 :1];
    return [command getCommand];
}

-(NSData *)secondTscCommandModel:(SVWaresListModel *)model{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:30 :20];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addTear:@"ON"];
    [command addQueryPrinterStatus:ON];
    [command addCls];
    [command addTextwithX:0 withY:10 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1 withText:model.sv_p_name];
    //    [command addTextwithX:30 withY:40 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"货号:%@",model.sv_p_artno]];
    if (kStringIsEmpty(model.sv_p_artno)) {
        [command add1DBarcode:0 :40 :@"CODE128" :55 :0 :0 :2 :6 :model.sv_p_barcode];
    }else{
        [command add1DBarcode:0 :40 :@"CODE128" :55 :0 :0 :2 :6 :model.sv_p_artno];
    }
    
    [command addTextwithX:0 withY:100 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:model.sv_p_specs];
    [command addTextwithX:0 withY:130 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:model.sv_p_barcode];
    if (model.sv_p_barcode.length <= 14) {
        [command addTextwithX:170 withY:130 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"￥%@",model.sv_p_unitprice]];
    }else{
        [command addTextwithX:170 withY:130 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"￥%@",model.sv_p_unitprice]];
    }
    
    
    [command addPrint:1 :1];
    return [command getCommand];
    
}

-(NSData *)threeTscCommandModel:(SVWaresListModel *)model{
    //    if (model.sv_p_name.length >= 16 || model.sv_p_barcode.length >= 16) {
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:40 :60];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addTear:@"ON"];
    [command addQueryPrinterStatus:ON];
    [command addCls];
    [command addTextwithX:15 withY:10 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:@"零售价："];
    [command addTextwithX:100 withY:80 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:@"￥"];
    
    [command addTextwithX:120 withY:60 withFont:@"TSS24.BF2" withRotation:0 withXscal:2 withYscal:2 withText:model.sv_p_unitprice];
    [command addTextwithX:15 withY:140 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"品名：%@",model.sv_p_name]];
    
    [command addTextwithX:15 withY:190 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"条码：%@",model.sv_p_barcode]];
    [command addTextwithX:15 withY:240 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"规格：%@",model.sv_p_specs]];
    if (kStringIsEmpty(model.sv_p_artno)) {
         [command add1DBarcode:15 :290 :@"CODE128" :100 :1 :0 :2 :6 :model.sv_p_barcode];
    }else{
         [command add1DBarcode:15 :290 :@"CODE128" :100 :1 :0 :2 :6 :model.sv_p_artno];
    }
   
    
    [command addPrint:1 :1];
    return [command getCommand];
}

// 我看这里是标签打印的方法了
-(NSData *)fourTscCommandModel:(SVWaresListModel *)model{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:50 :40];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addTear:@"ON"];
    [command addQueryPrinterStatus:ON];
    [command addCls];
    [SVUserManager loadUserInfo];
    [command addTextwithX:15 withY:10 withFont:@"TSS24.BF2" withRotation:0 withXscal:2 withYscal:2 withText:[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name]];
  
//    [command addTextwithX:120 withY:60 withFont:@"TSS24.BF2" withRotation:0 withXscal:2 withYscal:2 withText:model.sv_p_unitprice];
    [command addTextwithX:15 withY:60 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"名称：%@",model.sv_p_name]];
    [command addTextwithX:15 withY:90 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"编码：%@",model.sv_p_barcode]];
    
     [command addTextwithX:15 withY:120 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"等级：合格品"]];
    if ([model.sv_p_specs containsString:@","]) {
        NSArray *array = [model.sv_p_specs componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        [command addTextwithX:15 withY:150 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"颜色：%@",array[0]]];
        
        [command addTextwithX:15 withY:180 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"尺码：%@",array[1]]];
        [command addTextwithX:190 withY:180 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"￥"]];
        [command addTextwithX:220 withY:160 withFont:@"TSS24.BF2" withRotation:0 withXscal:2 withYscal:2 withText:[NSString stringWithFormat:@"%@",model.sv_p_unitprice]];
    }else{
        [command addTextwithX:15 withY:150 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"颜色：%@",model.sv_p_specs]];
        
        [command addTextwithX:15 withY:180 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"尺码：%@",model.sv_p_specs]];
        [command addTextwithX:190 withY:180 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1.3 withText:[NSString stringWithFormat:@"￥"]];
        [command addTextwithX:220 withY:160 withFont:@"TSS24.BF2" withRotation:0 withXscal:2 withYscal:2 withText:[NSString stringWithFormat:@"%@",model.sv_p_unitprice]];
    }
   
    if (kStringIsEmpty(model.sv_p_artno)) {
        [command add1DBarcode:15 :210 :@"CODE128" :80 :1 :0 :2 :6 :model.sv_p_barcode];
    }else{
        [command add1DBarcode:15 :210 :@"CODE128" :80 :1 :0 :2 :6 :model.sv_p_artno];
    }
    
    
    
    [command addPrint:1 :1];
    return [command getCommand];
}

#pragma mark - tableVeiw
//让section头部不停留在顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

//展示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.choiceNum == 1) {
        return 3;
    }else{
         return 4;
    }
   
}

//头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.choiceNum == 1) {
    
            return 35;
      
    }else{
        if (section == 1) {
            return 10;
        }else{
            return 35;
        }
    }
   
    
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.choiceNum == 1) {
     
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
            if (section == 0) {
                headerView.backgroundColor = [UIColor whiteColor];
            }
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textColor = GreyFontColor;
            titleLabel.text = self.titleArr[section];
            [headerView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(headerView);
                make.left.mas_equalTo(headerView).offset(20);
            }];
            
            return headerView;
        
    }else{
        if (section == 1) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
            return headerView;
        }else{
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
            if (section == 0) {
                headerView.backgroundColor = [UIColor whiteColor];
            }
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textColor = GreyFontColor;
            titleLabel.text = self.titleArr[section];
            [headerView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(headerView);
                make.left.mas_equalTo(headerView).offset(20);
            }];
            
            return headerView;
        }
    }
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 200;
    }
    return 50;
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.choiceNum == 1) {
        if (section == 1) {
            return self.three;
            //        return 1;
        }
        
        if (section == 2) {
             return 1;
        }
        return 1;
    }else{
        if (section == 2) {
            return self.three;
            //        return 1;
        }
        
        if (section == 3) {
            //        return self.dataSource.count;
            //  NSLog(@"[[self.dicts allKeys]count] = %ld",[[self.dicts allKeys]count]);
            
            return [[self.dicts allKeys]count];
        }
        return 1;
    }
    
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.choiceNum == 1) {
        [SVUserManager loadUserInfo];
        if (indexPath.section == 0) {
  
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
            //如果没有就重新建一个
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
            }
            
            [cell addSubview:self.PrintingCollectionView];
            
            
            return cell;
        } else if (indexPath.section == 1) {
            //普通cell的创建
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BluetoothID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BluetoothID];
            }
           // cell.imageView.image = [UIImage imageNamed:@"ic_yixuan.png"];
            if ([self.nameState isEqualToString:@"已连接"]) {
                cell.imageView.image = [UIImage imageNamed:@"ic_yixuan.png"];
                cell.textLabel.text = self.bluetoothName;
                cell.textLabel.textColor = GlobalFontColor;
                cell.detailTextLabel.text = self.nameState;
                cell.detailTextLabel.textColor = selectedColor;
            }else{
                cell.imageView.image = [UIImage imageNamed:@"cancel_red"];
                cell.textLabel.text = self.bluetoothName;
                cell.textLabel.textColor = GlobalFontColor;
                cell.detailTextLabel.text = self.nameState;
                cell.detailTextLabel.textColor = [UIColor redColor];
            }
           
            return cell;
        } else {
       
            SVSearchBluetoothCell *cell = [tableView dequeueReusableCellWithIdentifier:searchBluetoothCellID];
            if (!cell) {
                cell = [[SVSearchBluetoothCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:searchBluetoothCellID];
            }
            return cell;
        }
    }else{
        [SVUserManager loadUserInfo];
        if (indexPath.section == 0) {
   
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
            //如果没有就重新建一个
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
            }
            
            [cell addSubview:self.PrintingCollectionView];
            
            
            return cell;
        } else if (indexPath.section == 1) {
            SVNumberOfCopiesCell *cell = [tableView dequeueReusableCellWithIdentifier:BluetoothNumXIBID forIndexPath:indexPath];
            if (!cell) {
                cell = [[SVNumberOfCopiesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BluetoothNumXIBID];
            }
            
            
            //WeakSelf
            cell.severalCopiesCellBlock = ^(NSInteger num) {
                [SVUserManager shareInstance].labelPrinterNumber = [NSString stringWithFormat:@"%ld",(long)num];
                //            [SVUserManager saveUserInfo];
            };
            return cell;
        } else if (indexPath.section == 2) {
            //普通cell的创建
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BluetoothID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BluetoothID];
            }
            cell.imageView.image = [UIImage imageNamed:@"ic_yixuan.png"];
            cell.textLabel.text = [SVUserManager shareInstance].labelPrintName;
            cell.textLabel.textColor = GlobalFontColor;
            cell.detailTextLabel.text = @"已连接";
            cell.detailTextLabel.textColor = selectedColor;
            return cell;
        } else {
  
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

            cell.imageView.image = [UIImage imageNamed:@"ic_mo-ren"];
            CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",peripheral.name];
            // cell.detailTextLabel.text = peripheral.identifier.UUIDString;
            
            return cell;
        }
    }
    
}



/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.choiceNum == 1) {
        //一句实现点击效果
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.section == 2) {
   
            SVBluetoothListVC *bluetooListVC = [[SVBluetoothListVC alloc] init];
            bluetooListVC.state = ^(ConnectState state) {
                
                [self updateConnectState:state];
            };
            
            bluetooListVC.nameBlock = ^(NSString * _Nonnull name) {
                self.bluetoothName = name;
            };
            [self.navigationController pushViewController:bluetooListVC animated:YES];
//            CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
//
//            //  NSLog(@"---%@",[NSString stringWithFormat:@"%@",peripheral.name]);
//            self.currPeripheral = peripheral;
//            //  NSLog(@"self.currPeripheral---%@",self.currPeripheral);
//
//            [self connectDevice:peripheral];
            
        } else if (indexPath.section == 1) {
     
        } else {
            
        }
    }else{
        //一句实现点击效果
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.section == 3) {
    
            CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
            
            //  NSLog(@"---%@",[NSString stringWithFormat:@"%@",peripheral.name]);
            self.currPeripheral = peripheral;
            //  NSLog(@"self.currPeripheral---%@",self.currPeripheral);
            
            [self connectDevice:peripheral];
            
        } else if (indexPath.section == 2) {
     
        } else {
            
        }
    }
    
}

- (BOOL)navigationShouldPopOnBackButton
{
    // [Manager close];
    [SVUserManager shareInstance].indexpath =8;
    
    [SVUserManager shareInstance].labelPrinterSize =@"0";
    return YES;
}




-(void)connectDevice:(CBPeripheral *)peripheral {
    [Manager connectPeripheral:peripheral options:nil timeout:2 connectBlack:self.state];
//    __weak typeof(self) weakSelf = self;
//    self.state = ^(ConnectState state) {
//
//        [weakSelf updateConnectState:state];
//    };
    
    self.printeName = [NSString stringWithFormat:@"%@",peripheral.name];
    [SVUserManager shareInstance].labelPrintName = self.printeName;
    self.three = 1;
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [Manager stopScan];
}



#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sizeImageArray.count;
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1 ;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SVPrintCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:_sizeImageArray[indexPath.row] ofType:@"png"];
    //    NSLog(@"imagePath = %@",imagePath);
    //  [cell.size setTitle:_sizeArray[indexPath.row] forState:UIControlStateNormal];
    _sizeArray = @[
                   @"40*30mm",
                   @"55*30mm",
                   @"30*20mm",
                   
                   @"40*60mm",
                   @"50*40mm",
                   ];
    //    [cell.size setTitle:_sizeArray[indexPath.row] forState:UIControlStateNormal];
    cell.titleL.text = _sizeArray[indexPath.row];
    
    cell.iconImage.image = [UIImage imageNamed:_sizeImageArray[indexPath.row]];
    
    
    
    //cell.iconImage.image = [UIImage imageNamed:_sizeImageArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [SVUserManager shareInstance].labelPrinterSize = [NSString stringWithFormat:@"%ld",indexPath.row];
    
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    SVPrintCollectionViewCell *cell = (SVPrintCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    [cell.size setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateSelected];
//}

#pragma mark - 懒加载
- (NSArray *)titleArr {
    if (self.choiceNum == 1) {
        if (!_titleArr) {
            _titleArr = @[@"打印样式",
                          @"已配对设备",
                          @"搜索到的设备",
                          ];
        }
    }else{
        if (!_titleArr) {
            _titleArr = @[@"打印样式",
                          @"打印份数",
                          @"已配对设备",
                          @"搜索到的设备",
                          ];
        }
    }
    return _titleArr;
    
}


- (NSArray *)sizeImageArray{
    if (!_sizeImageArray) {
        _sizeImageArray = @[@"pic_style_3",
                            @"pic_style_1",
                            
                            @"pic_style_2",
                            
                            @"pic_style_4",
                            @"pic_style_5",
                            ];
    }
    return _sizeImageArray;
}


- (UICollectionView *)PrintingCollectionView
{
    if (_PrintingCollectionView == nil) {
        SVPrintFlowLayout *layout = [[SVPrintFlowLayout alloc] init];
        _PrintingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,ScreenW, 200) collectionViewLayout:layout];
        _PrintingCollectionView.backgroundColor = [UIColor whiteColor];
        // _PrintingCollectionView.showsVerticalScrollIndicator = NO;
        _PrintingCollectionView.showsHorizontalScrollIndicator = NO;
    }
    
    return _PrintingCollectionView;
}


@end
