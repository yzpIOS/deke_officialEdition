//
//  SVBluetoothVC.h
//  SAVI
//
//  Created by houming Wang on 2018/5/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"
#import "DemoShowViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface SVBluetoothVC : DemoShowViewController<CBCentralManagerDelegate, CBPeripheralDelegate>

//全局属性
//图片路径
@property (nonatomic,copy) NSString *imgURL;
@property (nonatomic,strong) NSDictionary *prdata_dic;
//带过来的是字典
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSDictionary *dic;
//记录是那个界面跳转过来的，1是我的、2是查询销售
@property (nonatomic,assign) NSInteger interface;


@end
