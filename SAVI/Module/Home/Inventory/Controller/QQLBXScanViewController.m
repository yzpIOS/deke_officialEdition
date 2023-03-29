//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "QQLBXScanViewController.h"
#import "CreateBarCodeViewController.h"
//#import "ScanResultViewController.h"
#import "LBXScanVideoZoomView.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
//#import "LBXScanViewController.h"
//#import "LBXScan-prefix.pch"
#import "SVduoguigeModel.h"
#import "SVSelectedGoodsModel.h"
#import "SVShopSingleTemplateVC.h"
#import "SVDetaildraftFirmOfferCell.h"
#import "SVPurchaseManagementVC.h"
#import "SVNewStockCheckVC.h"
#import "SVWriteOffCodeQueryVC.h"
#import "SVScanCodeLoginVC.h"



static NSString *const collectionViewCellID = @"SVDetaildraftFirmOfferCell";
@interface QQLBXScanViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,selectMoreModelDelegate,UITextFieldDelegate>
@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;
@property (nonatomic,strong) UICollectionView *PrintingCollectionView;
@property (nonatomic,strong) UIButton *icon_button;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@property (nonatomic,strong) SVduoguigeModel *model;

@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;

@end

@implementation QQLBXScanViewController
- (NSMutableArray *)sameModelArray
{
    if (_sameModelArray == nil) {
        _sameModelArray = [NSMutableArray array];
    }
    
    return _sameModelArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    if (self.isStockPurchase == 3) {
       self.title = @"订单核销";
    }else if(self.isStockPurchase == 4){
        self.title = @"账号登录";
    }else if(self.isStockPurchase == 6){
        self.title = @"扫一扫";
    }
    else{
       self.title = @"收款流水";
    }
   
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
    
    [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVDetaildraftFirmOfferCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
    self.PrintingCollectionView.delegate = self;
    self.PrintingCollectionView.dataSource = self;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //适配ios11偏移问题
          UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
          self.navigationItem.backBarButtonItem = backltem;
    [self drawBottomItems];
    [self drawTitle];
    [self.view bringSubviewToFront:_topTitle];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
//    //    如果不想让其他页面的导航栏变为透明 需要重置
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        _topTitle.font = [UIFont systemFontOfSize:15];
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}



- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        [self zoomView];
    }
}

- (LBXScanVideoZoomView*)zoomView
{
    if (!_zoomView)
    {
        
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value)
        {
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
    
}

- (void)tap
{
    _zoomView.hidden = !_zoomView.hidden;
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    if (self.selectNumber == 1 || self.isStockPurchase == 6) {
        self.detailView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-BottomHeight-60-TopHeight-40 - 60,
                                                                  CGRectGetWidth(self.view.frame), 40)];
        self.detailView.backgroundColor = [UIColor whiteColor];
        UILabel *leftLabel = [[UILabel alloc] init];
        [leftLabel setFont:[UIFont systemFontOfSize:14]];
        [leftLabel setTextColor:GlobalFontColor];
        self.leftLabel = leftLabel;
        [self.detailView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.detailView).offset(10);
            make.centerY.mas_equalTo(self.detailView.mas_centerY);
        }];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        [rightLabel setFont:[UIFont systemFontOfSize:14]];
        [rightLabel setTextColor:GlobalFontColor];
        self.rightLabel = rightLabel;
        [self.detailView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.detailView).offset(-10);
            make.centerY.mas_equalTo(self.detailView.mas_centerY);
        }];
        
        [self.view addSubview:self.detailView];
        self.detailView.hidden = YES;
    }else{

     
        if (self.isStockPurchase == 3) {
            self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-TopHeight - 100,CGRectGetWidth(self.view.frame), 100)];
            
            _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
            
            [self.view addSubview:_bottomItemsView];
                    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(50, ScreenH-TopHeight - 100-BottomHeight - 20 -35, CGRectGetWidth(self.view.frame) -100, 50)];
                    textF.layer.borderWidth = 1;
                    textF.layer.borderColor = navigationBackgroundColor.CGColor;
                    textF.layer.cornerRadius = 25;
                    textF.layer.masksToBounds = YES;
            textF.textColor = [UIColor whiteColor];
            textF.returnKeyType = UIReturnKeyDone; //设置按键类型
           // textF.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
                    textF.delegate = self;
                    textF.font = [UIFont systemFontOfSize:15];
                 textF.textAlignment = NSTextAlignmentCenter;
                  //  textF.placeholder = @"请书入核销码";
                    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入核销码" attributes:
            
                            @{NSForegroundColorAttributeName:[UIColor whiteColor],
            
                        NSFontAttributeName:textF.font}];
            
                     textF.attributedPlaceholder = attrString;
                    [self.view addSubview:textF];
        }else{
            self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-TopHeight - 100-BottomHeight-60,CGRectGetWidth(self.view.frame), 100)];
            
            _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
            
            [self.view addSubview:_bottomItemsView];
        }

        CGSize size = CGSizeMake(65, 87);
        self.btnFlash = [[UIButton alloc]init];
        _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
        _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
        [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
        [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnPhoto = [[UIButton alloc]init];
        _btnPhoto.bounds = _btnFlash.bounds;
        _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
        [_btnPhoto setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
        [_btnPhoto setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
        [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnMyQR = [[UIButton alloc]init];
        _btnMyQR.bounds = _btnFlash.bounds;
        _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
        [_btnMyQR setImage:[UIImage imageNamed:@"qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
        [_btnMyQR setImage:[UIImage imageNamed:@"qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
        [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomItemsView addSubview:_btnFlash];
        [_bottomItemsView addSubview:_btnPhoto];
        [_bottomItemsView addSubview:_btnMyQR];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    SVWriteOffCodeQueryVC *VC = [[SVWriteOffCodeQueryVC alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    VC.code = textField.text;
    [self.navigationController pushViewController:VC animated:YES];
  
    return YES;
}

- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str buttonsStatement:@[@"知道了"] chooseBlock:nil];
}

#pragma mark - 扫码返回结果
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (self.isStockPurchase == 2) { // 是收款流水过来的
         if (array.count < 1)
           {
               [self popAlertMsgWithScanResult:nil];
               
               return;
           }
        
           
           LBXScanResult *scanResult = array[0];
           
           NSString*strResult = scanResult.strScanned;
        
           if (!strResult) {
               
               [self popAlertMsgWithScanResult:nil];
               
               return;
           }
           // 0、扫描成功之后的提示音
           [self SG_playSoundEffect:@"SGQRCode.bundle/sound.caf"];
          
        if (self.scanBlock) {
            self.scanBlock(strResult);
        }
          
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (self.isStockPurchase == 3){
        if (array.count < 1)
                 {
                     [self popAlertMsgWithScanResult:nil];
                     
                     return;
                 }
              
                 
                LBXScanResult *scanResult = array[0];
                 
                 NSString*strResult = scanResult.strScanned;
              
                 if (!strResult) {
                     
                     [self popAlertMsgWithScanResult:nil];
                     
                     return;
                 }
                 // 0、扫描成功之后的提示音
                 [self SG_playSoundEffect:@"SGQRCode.bundle/sound.caf"];
                
        SVWriteOffCodeQueryVC *VC = [[SVWriteOffCodeQueryVC alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        VC.code = strResult;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (self.isStockPurchase == 4){
        if (array.count < 1)
        {
            [self popAlertMsgWithScanResult:nil];
            
            return;
        }
        
        
        LBXScanResult *scanResult = array[0];
        
        NSString*strResult = scanResult.strScanned;
        
        if (!strResult) {
            
            [self popAlertMsgWithScanResult:nil];
            
            return;
        }
        // 0、扫描成功之后的提示音
        [self SG_playSoundEffect:@"SGQRCode.bundle/sound.caf"];
        
        SVScanCodeLoginVC *VC = [[SVScanCodeLoginVC alloc] init];
        self.hidesBottomBarWhenPushed=YES;
        NSData *jsonData = [strResult dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData != NULL) {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *data = dic[@"data"];
           NSString *idStr = data[@"id"];
            VC.code = idStr;
            [self.navigationController pushViewController:VC animated:YES];
        }
       
        
        
    }else if (self.isStockPurchase == 5){
        LBXScanResult *scanResult = array[0];
        
        NSString*strResult = scanResult.strScanned;
        
        if (!strResult) {
            
            [self popAlertMsgWithScanResult:nil];
            
            return;
        }
        if (self.addShopScanBlock) {
            self.addShopScanBlock(strResult);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.isStockPurchase == 6){
        LBXScanResult *scanResult = array[0];
        
        NSString*strResult = scanResult.strScanned;
        
        if (!strResult) {
            
            [self popAlertMsgWithScanResult:nil];
            
            return;
        }
        if (self.addShopScanBlock) {
            self.addShopScanBlock(strResult);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else{
        if (array.count < 1)
           {
               [self popAlertMsgWithScanResult:nil];
               
               return;
           }
           
           //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
           for (LBXScanResult *result in array) {
               NSLog(@"result.strScanned = %@",result.strScanned);
               [self getDataPageIndex:1 pageSize:1 category:0 name:result.strScanned isn:result.strScanned read_morespec:@"false"];
               
           }
           
           LBXScanResult *scanResult = array[0];
           
           NSString*strResult = scanResult.strScanned;
           
           self.scanImage = scanResult.imgScanned;
           
           if (!strResult) {
               
               [self popAlertMsgWithScanResult:nil];
               
               return;
           }
           // 0、扫描成功之后的提示音
           [self SG_playSoundEffect:@"SGQRCode.bundle/sound.caf"];
    }
}

///** 播放音效文件 */
- (void)SG_playSoundEffect:(NSString *)name {
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    // SystemSoundID soundID = 0;
    SystemSoundID soundID=8787;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    //  AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    AudioServicesPlayAlertSound(soundID);
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
//
///** 播放完成回调函数 */
//void soundCompleteCallback(SystemSoundID soundID, void *clientData){
//    //SGQRCodeLog(@"播放完成...");
//}

#pragma mark - 数据请求
/**
 获取产品列表
 
 @param pageIndex 第几页
 @param pageSize 每页有几个
 @param category 只限大分类
 @param name 搜索关键字
 */
- (void)getDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize category:(NSInteger)category name:(NSString *)name isn:(NSString *)isn read_morespec:(NSString *)read_morespec{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&pageIndex=%li&pageSize=%li&category=%li&name=%@&isn=%@&read_morespec=%@",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,(long)category,name,isn,read_morespec];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"urlStr = %@",urlStr);
        
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic收银记账 = %@",dic);
        
        NSDictionary *valuesDic = dic[@"values"];
        
        NSArray *listArr = valuesDic[@"list"];
        
        if (kArrayIsEmpty(listArr)) {
            [SVTool TextButtonActionWithSing:@"商品不存在"];
            [self reStartDevice];
        }else{
            
            SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:listArr[0]];
            
            model.isStockPurchase = @"1";
            self.model = model;
            
            if ([model.sv_product_type isEqualToString:@"2"]) {
                if (self.selectNumber == 1) {
                    [SVTool TextButtonActionWithSing:@"套餐商品不能盘点"];
                }else{
                    [SVTool TextButtonActionWithSing:@"套餐商品不能进货"];
                }
                
                
            }else if ([model.producttype_id isEqualToString:@"1"]){
                if (self.selectNumber == 1) {
                    [SVTool TextButtonActionWithSing:@"服务商品不能盘点"];
                }else{
                    [SVTool TextButtonActionWithSing:@"服务商品不能进货"];
                }
                
            }else{
                if (model.sv_is_newspec == 1 && ![name isEqualToString:model.sv_p_artno]) { // 是多规格的商品
                    SVShopSingleTemplateVC *shopSingleTemplateVC = [[SVShopSingleTemplateVC alloc] init];
                    shopSingleTemplateVC.delegateTwo = (id)self.stockCheckVC;
                    shopSingleTemplateVC.delegate = (id)self.purchaseManagementVC;
                    shopSingleTemplateVC.productID = model.product_id;
                    shopSingleTemplateVC.sv_p_name = model.sv_p_name;
                    shopSingleTemplateVC.isStockPurchase = self.isStockPurchase;
                    shopSingleTemplateVC.sv_p_images2 = model.sv_p_images2;
                    shopSingleTemplateVC.sv_p_unitprice = model.sv_p_unitprice;
                    shopSingleTemplateVC.sv_p_barcode = model.sv_p_barcode;
                    [self.navigationController pushViewController:shopSingleTemplateVC animated:YES];
                    
                    //                sv_p_name;
                    //                @property (nonatomic,strong) NSString *sv_p_images2;
                    //                @property (nonatomic,strong) NSString *sv_p_unitprice;
                    //                @property (nonatomic,strong) NSString *sv_p_barcode;
                }else{// 不是多规格的商品
                    [SVTool TextButtonActionWithSing:@"识别商品成功"];
                    
                    if (self.selectNumber == 1) {
                        if (self.sameModelArray.count == 0) {
                            NSInteger count = model.FirmOfferNum.integerValue;
                            count += 1;
                            model.FirmOfferNum= [NSString stringWithFormat:@"%ld",count];
                            ;
                            [self.sameModelArray addObject:model];
                        }else{
                            for (NSInteger i = 0; i < self.sameModelArray.count; i++) {
                                SVduoguigeModel *modell = self.sameModelArray[i];
                                if (model.product_id.integerValue == modell.product_id.integerValue) {
                                    NSInteger count = modell.FirmOfferNum.integerValue;
                                    count +=1;
                                    modell.FirmOfferNum = [NSString stringWithFormat:@"%ld",count];
                                    model.FirmOfferNum = modell.FirmOfferNum;
                                    [self.sameModelArray removeObject:modell];
                                    
                                }else{
                                    model.FirmOfferNum = @"1";
                                    
                                }
                                
                            }
                            
                            [self.sameModelArray addObject:model];
                            
                        }
                        
                        self.detailView.hidden = NO;
                        self.leftLabel.text = model.sv_p_name;
                        self.rightLabel.text = [NSString stringWithFormat:@"实盘：%@",model.FirmOfferNum];
                        
                        __weak __typeof(self) weakSelf = self;
                        if (weakSelf.selectDuoguigeModel) {
                            weakSelf.selectDuoguigeModel(model);
                        }
                    }else{
                        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
                        [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                        [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
                        //  [self.PrintingCollectionView reloadData];
                        [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
                    }

                }
            }
            
            [self reStartDevice];
            
            
        }
        
        
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        
    }];
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1 ;
    
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1 ;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (self.selectNum == 3) {
    SVDetaildraftFirmOfferCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    //    NSMutableArray *ary_1 = [self.goodsModelArr objectAtIndex:self.tableviewIndex];
    //    SVduoguigeModel *model = ary_1[self.selectCellIndex];
    cell.model = self.model;
    //    //        cell.model = self.selectModelArray[indexPath.row];
    //    cell.sureBtn.tag = self.selectCellIndex;
    __weak typeof(self) weakSelf = self;
    cell.sureBtnClickBlock = ^(NSInteger selctCount, SVduoguigeModel * _Nonnull model_two) {
        //            if (selctCount+ 1 == self.selectModelArray.count) {
        //                [weakSelf.selectModelArray replaceObjectAtIndex:selctCount withObject:model_two];
        
        //            weakSelf.aa = 1;
        //            if (weakSelf.selectModelArray.count == 0) {
        //                weakSelf.aa = 0;
        //                weakSelf.addShopTotleNum += 1;
        //                weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
        //                [weakSelf.selectModelArray addObject:model];
        //            }else{
        //                for (SVduoguigeModel *modell in weakSelf.selectModelArray) {
        //                    if (model.product_id == modell.product_id) {
        //                        [weakSelf.selectModelArray removeObject:modell];
        //                        weakSelf.addShopTotleNum -= 1;
        //                      //  [SVTool TextButtonAction:self.view withSing:@"已经添加过了"];
        //                        break;
        //                    }else{
        //
        //                    }
        //                }
        //            }
        //
        //            if (weakSelf.aa == 1) {
        //                weakSelf.addShopTotleNum += 1;
        //                weakSelf.addShopLabel.text = [NSString stringWithFormat:@"已添加商品：%ld种",weakSelf.addShopTotleNum];
        //                [weakSelf.selectModelArray addObject:model];
        //            }
        
        //            if (weakSelf.addWarehouseWares) {
        //                weakSelf.addWarehouseWares(weakSelf.selectModelArray);
        //            }
        
        
        
        //        if (weakSelf.selectModelBlock) {
        //            weakSelf.selectModelBlock(model_two);
        //        }
        //
        //
        //        [ary_1 replaceObjectAtIndex:selctCount withObject:model_two];
        //        //数组给模型数组
        //        [weakSelf.goodsModelArr replaceObjectAtIndex:self.tableviewIndex withObject:ary_1];
        //        [weakSelf.twoTableView reloadData];
        //        [weakSelf handlePan];
        
        if (weakSelf.selectDuoguigeModel) {
            weakSelf.selectDuoguigeModel(model_two);
        }
        [weakSelf handlePan];
        
        //   [weakSelf.PrintingCollectionView reloadData];
        //            }else{
        //                [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selctCount + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        //            }
    };
    
    return cell;
    //    }else{
    //        SVDetaildraftFirmOfferCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    //        cell.model_two = self.modelArr[indexPath.row];
    //        cell.sureBtn.tag = indexPath.row;
    //        __weak typeof(self) weakSelf = self;
    //        cell.sureBtnClickBlock_two = ^(NSInteger selctCount, SVPandianDetailModel * _Nonnull model_two) {
    //            if (selctCount+ 1 == self.modelArr.count) {
    //                [weakSelf.modelArr replaceObjectAtIndex:selctCount withObject:model_two];
    //
    //                [weakSelf handlePan];
    //
    //            }else{
    //                [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selctCount + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    //
    //            }
    //
    //        };
    //
    //        return cell;
    //    }
}



#pragma mark - 懒加载控件
- (UICollectionView *)PrintingCollectionView
{
    if (_PrintingCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(ScreenW / 5 *4, 470);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // layout.minimumLineSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(0, ScreenW / 5 *1 / 2, 0, ScreenW / 5 *1 / 2);
        
        _PrintingCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, TopHeight,ScreenW, 520) collectionViewLayout:layout];
        // _PrintingCollectionView.automaticallyAdjustsScrollViewInsets = false;
        _PrintingCollectionView.backgroundColor = [UIColor clearColor];
        // _PrintingCollectionView.showsVerticalScrollIndicator = NO;
        _PrintingCollectionView.showsHorizontalScrollIndicator = NO;
        
    }
    
    
    
    return _PrintingCollectionView;
}


- (UIButton *)icon_button
{
    if (_icon_button == nil) {
        _icon_button = [UIButton buttonWithType:UIButtonTypeCustom];
        _icon_button.frame = CGRectMake(ScreenW /2 - 20, CGRectGetMaxY(_PrintingCollectionView.frame) - 20, 40, 40);
        [_icon_button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_icon_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _icon_button;
}

- (void)btnClick{
    [self handlePan];
    
}

/**
 遮盖
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheView addGestureRecognizer:tap];
        
    }
    
    return _maskTheView;
    
}


//移除
- (void)handlePan{
    
    
    [self.maskTheView removeFromSuperview];
    [self.PrintingCollectionView removeFromSuperview];
    [self.icon_button removeFromSuperview];
    [self reStartDevice];
}


- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult buttonsStatement:@[@"知道了"] chooseBlock:^(NSInteger buttonIdx) {
        
        [weakSelf reStartDevice];
    }];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    //    ScanResultViewController *vc = [ScanResultViewController new];
    //    vc.imgScan = strResult.imgScanned;
    //
    //    vc.strScan = strResult.strScanned;
    //
    //    vc.strCodeType = strResult.strBarCodeType;
    //
    //    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark -底部功能项


- (void)myQRCode
{
    CreateBarCodeViewController *vc = [CreateBarCodeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
