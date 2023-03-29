//
//  ViewController.m
//  GSDK
//
//  Created by 猿史森林 on 2018/6/15.
//  Copyright © 2018年 Smarnet. All rights reserved.
//

#import "SVBluetoothListVC.h"

@interface SVBluetoothListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *devices;
@property(nonatomic,strong)NSMutableDictionary *dicts;
@property (nonatomic,strong) UITableView *deviceList;
@end

@implementation SVBluetoothListVC

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择蓝牙";
    self.deviceList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStylePlain];
    self.deviceList.delegate = self;
    self.deviceList.dataSource = self;
    [self.view addSubview:self.deviceList];
   // self.deviceList.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
    self.deviceList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"Manager.bleConnecter = %@",Manager.bleConnecter);
    if (Manager.bleConnecter == nil) {
        
        [Manager didUpdateState:^(NSInteger state) {
            switch (state) {
                case CBCentralManagerStateUnsupported:
                    NSLog(@"The platform/hardware doesn't support Bluetooth Low Energy.");
                    break;
                case CBCentralManagerStateUnauthorized:
                    NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
                    break;
                case CBCentralManagerStatePoweredOff:
                    NSLog(@"Bluetooth is currently powered off.");
                    break;
                case CBCentralManagerStatePoweredOn:
                    [self startScane];
                    NSLog(@"Bluetooth power on");
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

-(void)startScane {
    [Manager scanForPeripheralsWithServices:nil options:nil discover:^(CBPeripheral * _Nullable peripheral, NSDictionary<NSString *,id> * _Nullable advertisementData, NSNumber * _Nullable RSSI) {
        if (peripheral.name != nil) {
            NSLog(@"name -> %@",peripheral.name);
            NSUInteger oldCounts = [self.dicts count];
            [self.dicts setObject:peripheral forKey:peripheral.identifier.UUIDString];
            if (oldCounts < [self.dicts count]) {
                [_deviceList reloadData];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [_devices count];
    return [[self.dicts allKeys]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBPeripheral *peripheral = [self.dicts objectForKey:[self.dicts allKeys][indexPath.row]];
 
    [self connectDevice:peripheral];
}

-(void)connectDevice:(CBPeripheral *)peripheral {
    // NSLog(@"---%@",[NSString stringWithFormat:@"%@",self.state]);
    if (self.nameBlock) {
        self.nameBlock(peripheral.name);
    }
    [Manager connectPeripheral:peripheral options:nil timeout:2 connectBlack:self.state];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)viewDidDisappear:(BOOL)animated{
//    [Manager stopScan];
//}

@end
