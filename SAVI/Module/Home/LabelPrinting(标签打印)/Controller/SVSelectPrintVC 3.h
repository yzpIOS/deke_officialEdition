//
//  SVBluetoothVC.h
//  SAVI
//
//  Created by houming Wang on 2018/5/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"
#import "ConnecterManager.h"
//#import "CtrlViewController.h"

@interface SVSelectPrintVC : SVBaseVC

//带过来的是字典
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,assign) NSInteger choiceNum;

//记录是那个界面跳转过来的，1是我的、2是查询销售
@property (nonatomic,assign) NSInteger interface;

@property(nonatomic,copy)ConnectDeviceState state;
// 打印商品数组
@property (nonatomic,strong) NSMutableArray *labelPrintArray;
@end
