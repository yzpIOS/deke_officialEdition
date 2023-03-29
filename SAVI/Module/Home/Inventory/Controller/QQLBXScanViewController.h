//
//  SubLBXScanViewController.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXAlertAction.h"
#import <LBXScanViewController.h>

@class SVNewStockCheckVC;
@class SVduoguigeModel;
@class SVPurchaseManagementVC;
#pragma mark -模仿qq界面
//继承LBXScanViewController,在界面上绘制想要的按钮，提示语等
@interface QQLBXScanViewController : LBXScanViewController

@property (nonatomic,assign) NSInteger selectNumber;
@property (nonatomic,weak) SVNewStockCheckVC *stockCheckVC;
@property (nonatomic,weak) SVPurchaseManagementVC *purchaseManagementVC;
@property (nonatomic,copy) void(^selectDuoguigeModel)(SVduoguigeModel *model);
@property (nonatomic,strong) NSMutableArray *sameModelArray;
@property (nonatomic,strong) UIView *detailView;

@property (nonatomic,assign) NSInteger isStockPurchase; // 0是盘点    1是进货的  2是收款流水的 3是订单核销的  4是扫码登录 

@property (nonatomic, copy)void(^scanBlock)(NSString *resultStr);

/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

#pragma mark --增加拉近/远视频界面
@property (nonatomic, assign) BOOL isVideoZoom;

#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;
//相册
@property (nonatomic, strong) UIButton *btnPhoto;
//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;
//我的二维码
@property (nonatomic, strong) UIButton *btnMyQR;


/// 新增商品的回调
@property (nonatomic, copy)void(^addShopScanBlock)(NSString *resultStr);



@end
