//
//  SVShopSingleTemplateVC.m
//  SAVI
//
//  Created by houming Wang on 2019/4/8.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVShopSingleTemplateVC.h"
#import "SVduoguigeModel.h"
#import "SVAtteilistModel.h"
#import "SVSpecModel.h"
#import "SizeAttributeModel.h"
#import "NSString+Extension.h"
#import "SVSelectPrintVC.h"
#import "SVInventoryShopVC.h"
#import "SVExpandBtn.h"
//#import "PurchaseCarAnimationTool.h"
#import "SVDetaildraftFirmOfferCell.h"

#import "JJPhotoManeger.h"
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]
static NSString *const collectionViewCellID = @"SVDetaildraftFirmOfferCell";
@interface SVShopSingleTemplateVC ()<UITextFieldDelegate,CAAnimationDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,JJPhotoDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switch0;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (nonatomic,strong) NSMutableArray *duoguigeArray;
@property (nonatomic,strong) NSMutableArray *duoguigeArray2;
@property (nonatomic,strong) NSMutableArray *listAry1;
@property (nonatomic,strong) NSMutableArray *listAry2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreColorViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeViewHeight;
@property (weak, nonatomic) IBOutlet UIView *sizeView;
@property (nonatomic,strong) NSMutableArray *selectColorArray;
@property (weak, nonatomic) IBOutlet UIView *colorAndSizeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorAndSizeHeight;
@property (nonatomic,strong) NSMutableArray *sizeAttributeArray;
@property (nonatomic,strong) NSMutableArray *colors;
@property (nonatomic,strong) NSMutableArray *sizes;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,strong) NSMutableArray *splitArray;
@property (nonatomic,strong) NSMutableArray *selectSplitArray;
@property (nonatomic,strong) NSMutableArray *selectSplitArray2;
@property (nonatomic,strong) NSMutableArray *selectSplitArray3;
@property (nonatomic,strong) NSMutableArray *selectSplitArray4;
@property (nonatomic,strong) NSMutableArray *selectSplitArray5;
@property (nonatomic,strong) UIButton * tagBtn;
@property (nonatomic,strong) NSMutableArray *moreTextArray;
@property (nonatomic,strong) NSMutableArray *moreBtnArray;
@property (weak, nonatomic) IBOutlet UITextField *topTextfield;
@property (nonatomic,strong) UIButton *circle_btn;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (nonatomic,strong) NSMutableArray *circle_btnArray;
@property (weak, nonatomic) IBOutlet UILabel *totleNum;
@property (nonatomic,strong) UITextField *textFieldTwo;
@property (nonatomic,strong) NSMutableArray *singleTextArray;

@property (nonatomic,strong) NSMutableArray *singleCircle_btnArray;
@property (nonatomic,strong) NSMutableArray *singleBtnArray;
@property (nonatomic,assign) ConnectState state;
//[dateMutablearray2 addObject:tempArray2];
//[dateMutablearray3 addObject:tempArray3];
//[dateMutablearray4 addObject:tempArray4];
//NSMutableArray *array2 = self.selectSplitArray2[j];
//NSMutableArray *array3 = self.selectSplitArray3[j];
//NSMutableArray *array4
@property (nonatomic,strong) NSMutableArray *dateMutablearray;
@property (nonatomic,strong) NSMutableArray *dateMutablearray2;
@property (nonatomic,strong) NSMutableArray *dateMutablearray3;
@property (nonatomic,strong) NSMutableArray *dateMutablearray4;
@property (nonatomic,strong) NSMutableArray *dateMutablearray5;
@property (nonatomic,strong) NSMutableArray *bigArray;
@property (nonatomic,assign) NSInteger shopNum;

@property (nonatomic,strong) NSMutableArray *array2;
@property (nonatomic,strong) NSMutableArray *array3;
@property (nonatomic,strong) NSMutableArray *array4;
@property (nonatomic,strong) NSMutableArray *array5;

@property (weak, nonatomic) IBOutlet UILabel *shopTypeNum;

@property (nonatomic,strong) NSMutableArray *selectModelArray;
@property (nonatomic,strong) UIButton *reduce_btn;
@property (nonatomic,strong) UIButton *insert_btn;
@property (nonatomic,strong) UITextField *count_text;
@property (nonatomic,strong) NSMutableArray *insert_btnArray;
@property (nonatomic,strong) NSMutableArray *count_textArray;
@property (nonatomic,strong) NSMutableArray *reduce_btnArray;
@property (nonatomic,strong) NSMutableArray *viewArray;
//@property (nonatomic,assign) BOOL isOn;
@property (nonatomic,strong) UIBezierPath *path;

@property (weak, nonatomic) IBOutlet UILabel *sumCountL;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *kucun1;
@property (weak, nonatomic) IBOutlet UILabel *yuanjia1;
@property (weak, nonatomic) IBOutlet UILabel *kucun2;

@property (nonatomic,strong) UICollectionView *PrintingCollectionView;
@property (nonatomic,strong) UIButton *icon_button;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
@property (weak, nonatomic) IBOutlet UIImageView *header_icon;

@property (nonatomic,strong) SVduoguigeModel *model;
@property (nonatomic,strong) NSString *ZeroInventorySales_sv_detail_is_enable;

@property(nonatomic,strong)NSMutableArray *picUrlArr;
@property(nonatomic,strong)NSMutableArray *imageArr;

@end

@implementation SVShopSingleTemplateVC



- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.icon.layer.cornerRadius = 5;
    self.icon.layer.masksToBounds = YES;
    self.header_icon.layer.cornerRadius = 5;
    self.header_icon.layer.masksToBounds = YES;
    
//    if ([self.sv_p_images containsString:@"UploadImg"]) {
//
//        NSData *data = [self.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];

//        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary *dic = arr[0];
//        NSString *sv_p_images_two = dic[@"code"];
//       // sv_p_images = sv_p_images_two;
//        [self.header_icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//
//        for (int i = 0; i < arr.count; i++) {
//            NSDictionary *dic = arr[i];
//            NSString *sv_p_images_two = dic[@"code"];
//           // sv_p_images = sv_p_images_two;

//        if (data != NULL) {
//            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary *dic = arr[0];
//            NSString *sv_p_images_two = dic[@"code"];
//           // sv_p_images = sv_p_images_two;
//            [self.header_icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//
//            for (int i = 0; i < arr.count; i++) {
//                NSDictionary *dic = arr[i];
//                NSString *sv_p_images_two = dic[@"code"];
//               // sv_p_images = sv_p_images_two;
//
//                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two];
//               // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
//                NSLog(@"sv_p_images_two----%@",[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]);
//
//                 [self.picUrlArr addObject:imageUrl];
//                NSLog(@"self.picUrlArr = %@",self.picUrlArr);
//                  //添加点击操作
//                  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//                  [tap addTarget:self action:@selector(tap:)];
//                  [self.header_icon addGestureRecognizer:tap];
//                //        _picUrlArr = [NSMutableArray array];
//                [self.imageArr addObject:self.header_icon];
//                self.header_icon.userInteractionEnabled = YES;
//            }
//        }else{
//            self.header_icon.image = [UIImage imageNamed:@"foodimg"];
//        }
//
//    }else{
//        self.header_icon.image = [UIImage imageNamed:@"foodimg"];
//    }
    
    
    
//    if (![SVTool isBlankString:self.sv_p_images]) {
//        [self.header_icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//    } else {
//
//        self.header_icon.image = [UIImage imageNamed:@"foodimg"];
//    }

//
    [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVDetaildraftFirmOfferCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
    self.PrintingCollectionView.delegate = self;
    self.PrintingCollectionView.dataSource = self;
    self.bottomDistance.constant = BottomHeight;

    
    if ([self.sv_p_images containsString:@"UploadImg"]) {
        
        NSData *data = [self.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = arr[0];
        NSString *sv_p_images_two = dic[@"code"];
        [self.header_icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
      //  _imageArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary *dic = arr[i];
            NSString *sv_p_images_two = dic[@"code"];
           // sv_p_images = sv_p_images_two;
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two];
           // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
            NSLog(@"sv_p_images_two----%@",[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]);
           
             [self.picUrlArr addObject:imageUrl];
            NSLog(@"self.picUrlArr = %@",self.picUrlArr);
              //添加点击操作
              UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
              [tap addTarget:self action:@selector(tap:)];
              [self.header_icon addGestureRecognizer:tap];
            //        _picUrlArr = [NSMutableArray array];
            [self.imageArr addObject:self.header_icon];
            self.header_icon.userInteractionEnabled = YES;
        }

    }else{
        self.header_icon.image = [UIImage imageNamed:@"foodimg"];
    }

    
    
    
//    if (![SVTool isBlankString:self.sv_p_images]) {
//        [self.header_icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.sv_p_images]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//    } else {
//
//        self.header_icon.image = [UIImage imageNamed:@"foodimg"];
//    }
    
    
    
//    [self.PrintingCollectionView registerNib:[UINib nibWithNibName:@"SVDetaildraftFirmOfferCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellID];
//    self.PrintingCollectionView.delegate = self;
//    self.PrintingCollectionView.dataSource = self;
//    self.bottomDistance.constant = BottomHeight;
//    if (![SVTool isBlankString:self.sv_p_images2]) {
//        [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.sv_p_images2]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//        
//    } else {
//        
//        self.icon.image = [UIImage imageNamed:@"foodimg"];
//    }
    
    
    
    if (self.selectNumber == 1) {
        self.kucun2.hidden = YES;
        self.shopTypeNum.hidden = YES;
        self.iconImage.hidden = NO;
        self.sumCountL.hidden = NO;
        
    }else{
        self.kucun2.hidden = NO;
        self.kucun1.hidden = YES;
        self.yuanjia1.hidden = YES;
        self.iconImage.hidden = YES;
        self.sumCountL.hidden = YES;
    }
    
    self.topTextfield.delegate = self;
    
    [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    
    
    self.nameLabel.text = self.sv_p_name;
    
    self.partLabel.text = self.sv_p_barcode;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_sv_p_unitprice.doubleValue];
    
    self.switch0.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    self.navigationItem.title = @"商品";
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    
    [self loadduoguigeProduct];
    
    NSLog(@"self.purchaseArr = %@",self.purchaseArr);
    self.scrollView.delegate = self;
    [self.switch0 addTarget:self action:@selector(oneSwiClick:) forControlEvents:UIControlEventTouchUpInside];
    [SVUserManager loadUserInfo];
     NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable]; //
    self.ZeroInventorySales_sv_detail_is_enable = ZeroInventorySales_sv_detail_is_enable;
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    [SVUserManager shareInstance].picUrlArr = _picUrlArr;
    [SVUserManager saveUserInfo];
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    //  NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

- (IBAction)addShopButtonClick:(id)sender {
    //    SVInventoryShopVC *inventoryShopVC = [[SVInventoryShopVC alloc] init];
    //
    //    [self.navigationController pushViewController:inventoryShopVC animated:YES];
}

- (void)oneSwiClick:(UISwitch *)swi{
    if (swi.isOn) {// 开着
        self.topTextfield.text = 0;
        self.topTextfield.hidden = YES;
        [self.singleCircle_btnArray removeAllObjects];
        [self.circle_btnArray removeAllObjects];
        self.totleNum.text = @"0";
        [self loadduoguigeProduct];
        
    }else{// 关闭
        self.topTextfield.text = 0;
        self.topTextfield.hidden = YES;
        self.totleNum.text = @"0";
        [self.singleCircle_btnArray removeAllObjects];
        [self.circle_btnArray removeAllObjects];
        [self.selectColorArray removeAllObjects];
        [self.selectSplitArray removeAllObjects];
        [self loadduoguigeProductClose];
    }
}

#pragma mark - 确认按钮的点击
- (IBAction)sureClick:(id)sender {
    
    NSLog(@"self.selectModelArray = %@",self.selectModelArray);
    //    for (SVduoguigeModel *model in self.selectModelArray) {
    //        NSLog(@"model.product_num333333 = %ld",model.product_num);
    //    }
    
    if ([self.delegate respondsToSelector:@selector(selectMoreModelClick:)]) {
        [self.delegate selectMoreModelClick:self.selectModelArray];
    }
    
    if ([self.delegateTwo respondsToSelector:@selector(selectMoreModelClick:)]) {
        [self.delegateTwo selectMoreModelClick:self.selectModelArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




#pragma mark - 多选数据源
- (void)loadduoguigeProduct{
    [[self.btnView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetMorespecSubProductList?id=%@&key=%@",self.productID,[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic多规格打印 = %@",dic);
        
        self.duoguigeArray = [SVduoguigeModel mj_objectArrayWithKeyValuesArray:dic[@"values"][@"productCustomdDetailList"]];
        self.duoguigeArray2 = [SVduoguigeModel mj_objectArrayWithKeyValuesArray:dic[@"values"][@"productCustomdDetailList"]];
        //        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *moreBtnArray = [NSMutableArray array];
        NSMutableArray *sizeAttributeArray = [NSMutableArray array];
        [self.duoguigeArray enumerateObjectsUsingBlock:^(SVduoguigeModel *duoguigeModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            duoguigeModel.indexNum = idx;
            duoguigeModel.product_num = 1;
            // 颜色
            NSString *colorStr = @"";
            SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
            SVAtteilistModel *atteilistModel = specModel.attrilist.firstObject;
            colorStr = atteilistModel.attri_name;
            [self.colors addObject:colorStr];
            // 尺码
            NSString *sizeStr = @"";
            SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
            SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
            sizeStr = atteilistModel2.attri_name;
            [self.sizes addObject:sizeStr];
            
            UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            reduceBtn.tag = idx;
            [self.reduce_btnArray addObject:reduceBtn];
            
            UIButton *insetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            insetBtn.tag = idx;
            [self.insert_btnArray addObject:insetBtn];
            
            UITextField *count_text = [[UITextField alloc] init];
            count_text.tag = idx;
            [self.count_textArray addObject:count_text];
            
            UIView *view = [[UIView alloc] init];
            view.tag = idx;
            [self.viewArray addObject:view];
            
            
            
            // 颜色去重
            for (NSString *str in self.colors) {
                if (![self.listAry1 containsObject:str]) {
                    [self.listAry1 addObject:str];
                }
            }
            // 尺码去重
            for (NSString *str in self.sizes) {
                if (![self.listAry2 containsObject:str]) {
                    [self.listAry2 addObject:str];
                }
            }
            
            // 商品可选规格属性（就是返回的数据的模型的各个字段）
            if (duoguigeModel.sv_p_specs.length) {
                
                SizeAttributeModel *sizeAttModel = [[SizeAttributeModel alloc]init];
                sizeAttModel.sizeid = duoguigeModel.product_id; // 商品ID
                sizeAttModel.value = duoguigeModel.sv_p_specs; // 可选属性组合
                sizeAttModel.price = duoguigeModel.sv_p_memberprice; // 会员价
                sizeAttModel.originalPrice = duoguigeModel.sv_p_unitprice; // 原价
                sizeAttModel.stock = duoguigeModel.sv_p_storage;//库存
                sizeAttModel.imageId = duoguigeModel.sv_p_images2;// 图片
                sizeAttModel.sv_p_unit = duoguigeModel.sv_p_unit;// 单位
                sizeAttModel.sv_p_barcode = duoguigeModel.sv_p_barcode; // 款号
                sizeAttModel.sv_purchaseprice = duoguigeModel.sv_purchaseprice; // 进货价
                [sizeAttributeArray addObject:duoguigeModel.sv_p_storage];
                [moreBtnArray addObject:[NSString stringWithFormat:@"%ld",idx]];
                
                [self.sizeAttributeArray addObject:duoguigeModel.sv_p_storage];
            }
        }];
        
        NSMutableArray *dateMutablearray = [@[] mutableCopy];
        NSMutableArray *dateMutablearray2 = [@[] mutableCopy];
        NSMutableArray *dateMutablearray3 = [@[] mutableCopy];
        NSMutableArray *dateMutablearray4 = [@[] mutableCopy];
        NSMutableArray *dateMutablearray5 = [@[] mutableCopy];
        for (NSInteger i = 0; i < self.duoguigeArray.count; i++) {
            SVduoguigeModel *model=self.duoguigeArray[i];
            UIButton *btn = self.insert_btnArray[i];
            UIButton *btn3 = self.reduce_btnArray[i];
            UITextField *textF = self.count_textArray[i];
            UIView *view2 = self.viewArray[i];
            SVSpecModel *specModel = model.sv_cur_spec.firstObject;
            SVAtteilistModel *atteilistModel = specModel.attrilist.firstObject;
            NSString *colorStr = atteilistModel.attri_name;
            
            NSMutableArray *tempArray = [@[] mutableCopy];
            NSMutableArray *tempArray2 = [@[] mutableCopy];
            NSMutableArray *tempArray3 = [@[] mutableCopy];
            NSMutableArray *tempArray4 = [@[] mutableCopy];
            NSMutableArray *tempArray5 = [@[] mutableCopy];
            // model.indexNum = i;   self.insert_btnArray
            [tempArray addObject:model];
            [tempArray2 addObject:btn];
            [tempArray3 addObject:btn3];
            [tempArray4 addObject:textF];
            [tempArray5 addObject:view2];
            for (NSInteger j = i+1; j < self.duoguigeArray.count; j++) {
                SVduoguigeModel *jmodel=self.duoguigeArray[j];
                UIButton *btn2 = self.insert_btnArray[j];
                UIButton *btn4 = self.reduce_btnArray[j];
                UIButton *textF2 = self.count_textArray[j];
                UIView *view3 = self.viewArray[j];
                //  jmodel.indexNum = j;
                SVSpecModel *jspecModel = jmodel.sv_cur_spec.firstObject;
                SVAtteilistModel *jatteilistModel = jspecModel.attrilist.firstObject;
                NSString *jcolorStr = jatteilistModel.attri_name;
                
                if ([colorStr isEqualToString:jcolorStr]) {
                    [tempArray addObject:jmodel];
                    [tempArray2 addObject:btn2];
                    [tempArray3 addObject:btn4];
                    [tempArray4 addObject:textF2];
                    [tempArray5 addObject:view3];
                    [self.duoguigeArray removeObjectAtIndex:j];
                    [self.insert_btnArray removeObjectAtIndex:j];
                    [self.reduce_btnArray removeObjectAtIndex:j];
                    [self.count_textArray removeObjectAtIndex:j];
                    [self.viewArray removeObjectAtIndex:j];
                    j -= 1;
                }
            }
            
            [dateMutablearray addObject:tempArray];
            [dateMutablearray2 addObject:tempArray2];
            [dateMutablearray3 addObject:tempArray3];
            [dateMutablearray4 addObject:tempArray4];
            [dateMutablearray5 addObject:tempArray5];
        }
        
        self.dateMutablearray = dateMutablearray;
        self.dateMutablearray2 = dateMutablearray2;
        self.dateMutablearray3 = dateMutablearray3;
        self.dateMutablearray4 = dateMutablearray4;
        self.dateMutablearray5 = dateMutablearray5;
        
        NSLog(@"self.dateMutablearray:%@",self.dateMutablearray);
        NSLog(@"dateMutablearray2:%@",dateMutablearray2);
        NSLog(@"dateMutablearray3:%@",dateMutablearray3);
        NSLog(@"dateMutablearray4:%@",dateMutablearray4);
        NSLog(@"dateMutable:%@",dateMutablearray);
        NSLog(@"dateMutablearray5:%@",dateMutablearray5);
        
        NSLog(@"sizeAttributeArray = %@",sizeAttributeArray);
        NSLog(@"moreBtnArray = %@",moreBtnArray);
        // self.splitArray = sizeAttributeArray;
        
        _splitArray = [self splitArray:sizeAttributeArray withSubSize:self.listAry2.count];
        NSLog(@"_splitArray = %@",_splitArray);
        self.moreBtnArray = [self splitArray:moreBtnArray withSubSize:self.listAry2.count];
        
        CGFloat tagBtnX = 16;
        CGFloat tagBtnY = 0;
#pragma mark - 颜色展示
        for (int i= 0; i<self.listAry1.count; i++) {
            
            CGSize tagTextSize = [self.listAry1[i] sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(self.btnView.width-32-32, 30)];
            if (tagBtnX+tagTextSize.width+30 > self.btnView.width-32) {
                
                tagBtnX = 16;
                tagBtnY += 30+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
            [tagBtn setTitle:self.listAry1[i] forState:UIControlStateNormal];
            [tagBtn setTitleColor: GlobalFontColor forState:UIControlStateNormal];
            [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.layer.cornerRadius = 5;
            tagBtn.layer.masksToBounds = YES;
            tagBtn.layer.borderWidth = 1;
            tagBtn.layer.borderColor = GreyFontColor.CGColor;
            if (self.selectNumber == 1) {
                [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [tagBtn addTarget:self action:@selector(tagBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self.btnView addSubview:tagBtn];
            
            if (i == 0) {
                if (self.selectNumber == 1) {
                    [self tagBtnClick:tagBtn];
                }else{
                    [self tagBtnClick2:tagBtn];
                }
                
            }
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.btnViewHeight.constant = tagBtnY + 30;
            self.moreColorViewHeight.constant = 65+self.btnViewHeight.constant;
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}



#pragma mark - 多选按钮
- (void)tagBtnClick2:(UIButton *)btn{
    self.shopNum = 0;
    self.shopTypeNum.text = [NSString stringWithFormat:@"已加商品：%ld种",self.shopNum];
    [self.bigArray removeAllObjects];
    [self.moreTextArray removeAllObjects];
    [self.circle_btnArray removeAllObjects];
    self.totleNum.text = @"0";
    [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    self.allSelectBtn.selected = NO;
    [self.selectModelArray removeAllObjects];
    
    [[self.colorAndSizeView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    btn.selected = !btn.selected;
    //    NSMutableArray *color = []
    if (btn.selected){
        [btn setBackgroundColor:[UIColor orangeColor]];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.selectColorArray addObject:self.listAry1[btn.tag]];
        [self.selectSplitArray addObject:self.dateMutablearray[btn.tag]];
    }
    if (!btn.selected){
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        [btn setBackgroundColor:[UIColor clearColor]];
        [self.selectColorArray removeObject:self.listAry1[btn.tag]];
        // [self.selectSplitArray removeObject:self.splitArray[btn.tag]];
        [self.selectSplitArray removeObject:self.dateMutablearray[btn.tag]];
    }
    
    NSLog(@"self.selectColorArray = %@",self.selectColorArray);
    NSLog(@"self.selectSplitArray = %@",self.selectSplitArray);
    
    if (!kArrayIsEmpty(self.selectColorArray)) {
        CGFloat maxY = 0;
        // NSMutableArray *circle_btnArray = [NSMutableArray array];
        for (NSInteger j = 0; j < self.selectColorArray.count; j++) {
            NSMutableArray *array = self.selectSplitArray[j];
            [self.bigArray addObjectsFromArray:array];
            
            NSLog(@"bigArray = %@",self.bigArray);
            
            for (NSInteger i = 0; i < array.count; i++) {// 这里的问题
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
                view.backgroundColor = [UIColor whiteColor];
                [self.colorAndSizeView addSubview:view];
                
                UILabel *leftLabel = [[UILabel alloc] init];
                [view addSubview:leftLabel];
                leftLabel.backgroundColor = [UIColor whiteColor];
                leftLabel.textColor = [UIColor colorWithHexString:@"555555"];
                leftLabel.font = [UIFont systemFontOfSize:14];
                SVduoguigeModel *model = array[i];
                NSLog(@"model.indexNum = %ld",model.indexNum);
                
                leftLabel.text = model.sv_p_specs;
                [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(view.mas_left).offset(10);
                    make.centerY.mas_equalTo(view.mas_centerY);
                }];
                
                UILabel *middleLabel = [[UILabel alloc] init];
                [view addSubview:middleLabel];
                middleLabel.backgroundColor = [UIColor whiteColor];
                middleLabel.textColor = [UIColor colorWithHexString:@"555555"];
                middleLabel.font = [UIFont systemFontOfSize:14];
                middleLabel.text = model.sv_p_storage;
                [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.centerX.mas_equalTo(view.mas_centerX);
                }];
                
                
                SVExpandBtn *circle_btn = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
                circle_btn.tag = model.indexNum;
                [view addSubview:circle_btn];
                [circle_btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
                [circle_btn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
                [circle_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.right.mas_equalTo(view.mas_right).offset(-10);
                }];
                
                
                [self.circle_btnArray addObject:circle_btn];
                
                [circle_btn addTarget:self action:@selector(circle_btnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                maxY = CGRectGetMaxY(view.frame) + 1 ;
                
            }
            
        }
        
        self.colorAndSizeHeight.constant = self.bigArray.count* 50 + self.bigArray.count -1;
        self.sizeViewHeight.constant = self.colorAndSizeHeight.constant + 50 + 1;
    }
    
}


#pragma mark - 单选数据源
- (void)loadduoguigeProductClose{
    [[self.btnView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetMorespecSubProductList?id=%@&key=%@",self.productID,[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic多规格打印 = %@",dic);
        
        self.duoguigeArray = [SVduoguigeModel mj_objectArrayWithKeyValuesArray:dic[@"values"][@"productCustomdDetailList"]];
        
        //        NSMutableArray *colors = [NSMutableArray array];
        //        NSMutableArray *sizes = [NSMutableArray array];
        NSMutableArray *sizeAttributeArray = [NSMutableArray array];
        NSMutableArray *singleBtnArray = [NSMutableArray array];
        [self.duoguigeArray enumerateObjectsUsingBlock:^(SVduoguigeModel *duoguigeModel, NSUInteger idx, BOOL * _Nonnull stop) {
            // 颜色
            NSString *colorStr = @"";
            SVSpecModel *specModel = duoguigeModel.sv_cur_spec.firstObject;
            SVAtteilistModel *atteilistModel = specModel.attrilist.firstObject;
            colorStr = atteilistModel.attri_name;
            [self.colors addObject:colorStr];
            // 尺码
            NSString *sizeStr = @"";
            SVSpecModel *specModel2 = duoguigeModel.sv_cur_spec.lastObject;
            SVAtteilistModel *atteilistModel2 = specModel2.attrilist.firstObject;
            sizeStr = atteilistModel2.attri_name;
            [self.sizes addObject:sizeStr];
            
            
            
            // 颜色去重
            for (NSString *str in self.colors) {
                if (![self.listAry1 containsObject:str]) {
                    [self.listAry1 addObject:str];
                }
            }
            // 尺码去重
            for (NSString *str in self.sizes) {
                if (![self.listAry2 containsObject:str]) {
                    [self.listAry2 addObject:str];
                }
            }
            
            
            // 商品可选规格属性（就是返回的数据的模型的各个字段）
            if (duoguigeModel.sv_p_specs.length) {
                
                SizeAttributeModel *sizeAttModel = [[SizeAttributeModel alloc]init];
                sizeAttModel.sizeid = duoguigeModel.product_id; // 商品ID
                sizeAttModel.value = duoguigeModel.sv_p_specs; // 可选属性组合
                sizeAttModel.price = duoguigeModel.sv_p_memberprice; // 会员价
                sizeAttModel.originalPrice = duoguigeModel.sv_p_unitprice; // 原价
                sizeAttModel.stock = duoguigeModel.sv_p_storage;//库存
                sizeAttModel.imageId = duoguigeModel.sv_p_images2;// 图片
                sizeAttModel.sv_p_unit = duoguigeModel.sv_p_unit;// 单位
                sizeAttModel.sv_p_barcode = duoguigeModel.sv_p_barcode; // 款号
                sizeAttModel.sv_purchaseprice = duoguigeModel.sv_purchaseprice; // 进货价
                [sizeAttributeArray addObject:duoguigeModel.sv_p_storage];
                [self.sizeAttributeArray addObject:duoguigeModel.sv_p_storage];
                [singleBtnArray addObject:[NSString stringWithFormat:@"%ld",idx]];
            }
        }];
        NSLog(@"sizeAttributeArray = %@",sizeAttributeArray);
        
        _splitArray = [self splitArray:sizeAttributeArray withSubSize:self.listAry2.count];
        NSLog(@"_splitArray = %@",_splitArray);
        self.singleBtnArray = [self splitArray:singleBtnArray withSubSize:self.listAry2.count];
        
        CGFloat tagBtnX = 16;
        CGFloat tagBtnY = 0;
        
        for (int i= 0; i<self.listAry1.count; i++) {
            
            CGSize tagTextSize = [self.listAry1[i] sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(self.btnView.width-32-32, 30)];
            if (tagBtnX+tagTextSize.width+30 > self.btnView.width-32) {
                
                tagBtnX = 16;
                tagBtnY += 30+15;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.tag = i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+25, 30);
            [tagBtn setTitle:self.listAry1[i] forState:UIControlStateNormal];
            [tagBtn setTitleColor: GlobalFontColor forState:UIControlStateNormal];
            [tagBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            tagBtn.layer.cornerRadius = 5;
            tagBtn.layer.masksToBounds = YES;
            tagBtn.layer.borderWidth = 1;
            tagBtn.layer.borderColor = GreyFontColor.CGColor;
            [tagBtn addTarget:self action:@selector(tagBtnClickClose:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnView addSubview:tagBtn];
            
            if (i == 0) {
                [self tagBtnClickClose:tagBtn];
            }
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
            
            self.btnViewHeight.constant = tagBtnY + 30;
            self.moreColorViewHeight.constant = 65+self.btnViewHeight.constant;
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark -- 将数组拆分成固定长度

/**
 *  将数组拆分成固定长度的子数组
 *
 *  @param array 需要拆分的数组
 *
 *  @param subSize 指定长度
 *
 */
- (NSMutableArray *)splitArray: (NSMutableArray *)array withSubSize : (NSInteger)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (NSInteger i = 0; i < count; i ++) {
        //数组下标
        NSInteger index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        NSInteger j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
    
}

#pragma mark - 多选按钮
- (void)tagBtnClick:(UIButton *)btn{
    self.sumCountL.text = @"0";
    self.shopNum = 0;
    self.shopTypeNum.text = [NSString stringWithFormat:@"已加商品：%ld种",self.shopNum];
    [self.bigArray removeAllObjects];
    [self.array2 removeAllObjects];
    [self.array3 removeAllObjects];
    [self.array4 removeAllObjects];
    [self.array5 removeAllObjects];
    [self.moreTextArray removeAllObjects];
    [self.circle_btnArray removeAllObjects];
    self.totleNum.text = @"0";
    [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    self.allSelectBtn.selected = NO;
    [self.selectModelArray removeAllObjects];
    //    [self.reduce_btnArray removeAllObjects];
    //    [self.insert_btnArray removeAllObjects];
    //    [self.count_textArray removeAllObjects];
    
    [[self.colorAndSizeView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    btn.selected = !btn.selected;
    //    NSMutableArray *color = []
    if (btn.selected){
        [btn setBackgroundColor:[UIColor orangeColor]];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        [self.selectColorArray addObject:self.listAry1[btn.tag]];
        [self.selectSplitArray addObject:self.dateMutablearray[btn.tag]];
        [self.selectSplitArray2 addObject:self.dateMutablearray2[btn.tag]];
        [self.selectSplitArray3 addObject:self.dateMutablearray3[btn.tag]];
        [self.selectSplitArray4 addObject:self.dateMutablearray4[btn.tag]];
        [self.selectSplitArray5 addObject:self.dateMutablearray5[btn.tag]];
    }
    if (!btn.selected){
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        [btn setBackgroundColor:[UIColor clearColor]];
        [self.selectColorArray removeObject:self.listAry1[btn.tag]];
        // [self.selectSplitArray removeObject:self.splitArray[btn.tag]];
        
        [self.selectSplitArray removeObject:self.dateMutablearray[btn.tag]];
        [self.selectSplitArray2 removeObject:self.dateMutablearray2[btn.tag]];
        [self.selectSplitArray3 removeObject:self.dateMutablearray3[btn.tag]];
        [self.selectSplitArray4 removeObject:self.dateMutablearray4[btn.tag]];
        [self.selectSplitArray5 removeObject:self.dateMutablearray5[btn.tag]];
    }
    
    NSLog(@"self.selectColorArray = %@",self.selectColorArray);
    NSLog(@"self.selectSplitArray = %@",self.selectSplitArray);
    NSLog(@"self.selectSplitArray5 = %@",self.selectSplitArray5);
    
    if (!kArrayIsEmpty(self.selectColorArray)) {
        CGFloat maxY = 0;
        // NSMutableArray *circle_btnArray = [NSMutableArray array];
        for (NSInteger j = 0; j < self.selectColorArray.count; j++) {
            NSMutableArray *array = self.selectSplitArray[j];
            NSMutableArray *array2 = self.selectSplitArray2[j];
            NSMutableArray *array3 = self.selectSplitArray3[j];
            NSMutableArray *array4 = self.selectSplitArray4[j];
            NSMutableArray *array5 = self.selectSplitArray5[j];
            
            [self.array2 addObjectsFromArray: array2];
            [self.array3 addObjectsFromArray: array3];
            [self.array4 addObjectsFromArray: array4];
            [self.array5 addObjectsFromArray: array5];
            //self.array3 = array3;
            //self.array4 = array4;
            
            [self.bigArray addObjectsFromArray:array];
            
            NSLog(@"bigArray = %@",self.bigArray);
            
            for (NSInteger i = 0; i < array.count; i++) {// 这里的问题
                //  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
                UIView *view = array5[i];
                view.frame = CGRectMake(0, maxY, ScreenW, 50);
                view.backgroundColor = [UIColor whiteColor];
                [self.colorAndSizeView addSubview:view];
                
                UILabel *leftLabel = [[UILabel alloc] init];
                [view addSubview:leftLabel];
                leftLabel.backgroundColor = [UIColor whiteColor];
                leftLabel.textColor = [UIColor colorWithHexString:@"555555"];
                leftLabel.font = [UIFont systemFontOfSize:14];
                SVduoguigeModel *model = array[i];
                NSLog(@"model.indexNum = %ld",model.indexNum);
                
                leftLabel.text = model.sv_p_specs;
                [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(view.mas_left).offset(10);
                    make.centerY.mas_equalTo(view.mas_centerY);
                }];
                
                
                
                
                UILabel *middleLabel = [[UILabel alloc] init];
                [view addSubview:middleLabel];
                middleLabel.backgroundColor = [UIColor whiteColor];
                middleLabel.textColor = [UIColor colorWithHexString:@"555555"];
                middleLabel.font = [UIFont systemFontOfSize:14];
                middleLabel.text = model.sv_p_storage;
                [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.centerX.mas_equalTo(view.mas_centerX).offset(-30);
                }];
                
                UILabel *rightLabel = [[UILabel alloc] init];
                [view addSubview:rightLabel];
                rightLabel.backgroundColor = [UIColor whiteColor];
                rightLabel.textColor = [UIColor colorWithHexString:@"555555"];
                rightLabel.font = [UIFont systemFontOfSize:14];
                rightLabel.text = model.sv_p_unitprice;
                [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view.mas_centerY);
                    // make.right.mas_equalTo(view.mas_right).offset(-120);
                    make.centerX.mas_equalTo(view.mas_centerX).offset(50);
                    
                }];
                
                
                UIButton *insert_btn = array2[i];
                [view addSubview:insert_btn];
                // [self.insert_btnArray addObject:insert_btn];
                //  [circle_btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
                [insert_btn addTarget:self action:@selector(insert_btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [insert_btn setImage:[UIImage imageNamed:@"icon_greyAddButton"] forState:UIControlStateNormal];
                [insert_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.right.mas_equalTo(view.mas_right).offset(-10);
                }];
                
                //                    UITextField *count_text = [[UITextField alloc] init];
                //                    count_text.tag = model.indexNum;
                //                   // self.count_text = count_text;
                //                    [self.count_textArray addObject:count_text];
                //                    count_text.text = @"0";
                UITextField *count_text = array4[i];
                count_text.delegate = self;
                count_text.text = @"0";
                count_text.textColor = [UIColor grayColor];
                count_text.keyboardType = UIKeyboardTypeNumberPad;
                count_text.font = [UIFont systemFontOfSize:14];
                //  count_text.textColor = GlobalFontColor;
                count_text.textAlignment = NSTextAlignmentCenter;
                [view addSubview:count_text];
                [count_text mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(insert_btn.mas_left);
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.width.mas_equalTo(40);
                    make.height.mas_equalTo(40);
                }];
                
                
                //                    UIButton *reduce_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                    reduce_btn.tag = model.indexNum;
                //                  //  self.reduce_btn = reduce_btn;
                //                    [self.reduce_btnArray addObject:reduce_btn];
                UIButton *reduce_btn = array3[i];
                reduce_btn.hidden = YES;
                //  circle_btn.tag = model.indexNum;
                [view addSubview:reduce_btn];
                [reduce_btn addTarget:self action:@selector(reduce_btnClick:) forControlEvents:UIControlEventTouchUpInside];
                //  [circle_btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
                [reduce_btn setImage:[UIImage imageNamed:@"icon_reduce"] forState:UIControlStateNormal];
                [reduce_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.right.mas_equalTo(count_text.mas_left);
                }];
                
                //                    SVExpandBtn *circle_btn = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
                //                    circle_btn.tag = model.indexNum;
                //                    [view addSubview:circle_btn];
                //                    [circle_btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
                //                    [circle_btn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
                //                    [circle_btn mas_makeConstraints:^(MASConstraintMaker *make) {
                //                        make.centerY.mas_equalTo(view.mas_centerY);
                //                        make.right.mas_equalTo(view.mas_right).offset(-10);
                //                    }];
                //
                //
                //                    [self.circle_btnArray addObject:circle_btn];
                //
                //                    [circle_btn addTarget:self action:@selector(circle_btnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //                    UIButton *insert_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                    insert_btn.tag = model.indexNum;
                //   self.insert_btn = insert_btn;
                //  circle_btn.tag = model.indexNum;
                
                
                
                maxY = CGRectGetMaxY(view.frame) + 1 ;
                
            }
            
        }
        
        self.colorAndSizeHeight.constant = self.bigArray.count* 50 + self.bigArray.count -1;
        self.sizeViewHeight.constant = self.colorAndSizeHeight.constant + 50 + 1;
    }
    
}

#pragma mark - 点击输入框
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text floatValue] == 0) {
        for (UIButton *reduce in self.array3) {
            if (reduce.tag == textField.tag) {
                reduce.hidden = YES;
                
                for (UIButton *insert_btn in self.array2) {
                    if (textField.tag == insert_btn.tag) {
                        
                       
                        
                        [insert_btn setImage:[UIImage imageNamed:@"icon_greyAddButton"] forState:UIControlStateNormal];
                        textField.textColor = [UIColor colorWithHexString:@"555555"];
                        NSInteger count = [textField.text integerValue];
                        count = 0;
                        textField.text = [NSString stringWithFormat:@"%ld",count];
                        
                        
                        //让图变大变小的
                        textField.transform = CGAffineTransformMakeScale(1, 1);
                        [UIView animateWithDuration:0.1   animations:^{
                            textField.transform = CGAffineTransformMakeScale(1.5, 1.5);
                        }completion:^(BOOL finish){
                            [UIView animateWithDuration:0.1      animations:^{
                                textField.transform = CGAffineTransformMakeScale(0.9, 0.9);
                            }completion:^(BOOL finish){
                                [UIView animateWithDuration:0.1   animations:^{
                                    textField.transform = CGAffineTransformMakeScale(1, 1);
                                }completion:^(BOOL finish){
                                }];
                            }];
                        }];
                        
                        break;
                    }
                }
                
                break;
            }
        }
    }else{
        for (UIButton *reduce in self.array3) {
            if (reduce.tag == textField.tag) {
                reduce.hidden = NO;
                
                for (UIButton *insert_btn in self.array2) {
                    if (textField.tag == insert_btn.tag) {
                        
                        if (self.ZeroInventorySales_sv_detail_is_enable ) {
                            if ([self.ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                                
                                for (SVduoguigeModel *model in self.bigArray) {
                                    if (model.indexNum == insert_btn.tag) {
                                        if (model.sv_p_storage.doubleValue <= textField.text.doubleValue) {
                                            [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                            [insert_btn setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
                                            textField.textColor = [UIColor colorWithHexString:@"555555"];
                                            textField.text = [NSString stringWithFormat:@"%.0f",model.sv_p_storage.doubleValue];
                                            return;
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        [insert_btn setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
                        textField.textColor = [UIColor colorWithHexString:@"555555"];
                        NSInteger count = [textField.text integerValue];
                        //count = 0;
                        textField.text = [NSString stringWithFormat:@"%ld",count];
                        
                        //让图变大变小的
                        textField.transform = CGAffineTransformMakeScale(1, 1);
                        [UIView animateWithDuration:0.1   animations:^{
                            textField.transform = CGAffineTransformMakeScale(1.5, 1.5);
                        }completion:^(BOOL finish){
                            [UIView animateWithDuration:0.1      animations:^{
                                textField.transform = CGAffineTransformMakeScale(0.9, 0.9);
                            }completion:^(BOOL finish){
                                [UIView animateWithDuration:0.1   animations:^{
                                    textField.transform = CGAffineTransformMakeScale(1, 1);
                                }completion:^(BOOL finish){
                                }];
                            }];
                        }];
                        break;
                    }
                }
                
                break;
            }
        }
    }
    
    self.sumCountL.text = @"0";
    [self.selectModelArray removeAllObjects];
    for (UITextField *textF in self.array4) {
        if (textF.text.integerValue == 0) {
            continue;
        }else{
            NSInteger count2 = [self.sumCountL.text integerValue];
            NSInteger text_count = textF.text.integerValue;
            for (SVduoguigeModel *model in self.bigArray) {
                if (model.indexNum == textF.tag) {
                    for (NSInteger i = 0; i < text_count; i++) {
                        [self.selectModelArray addObject:model];
                    }
                    // [self.selectModelArray addObject:model];
                    //  break;
                }
            }
            
            count2 += text_count;
            self.sumCountL.text = [NSString stringWithFormat:@"%ld",count2];
        }
    }
    

    
}

#pragma mark - 点击加号
- (void)insert_btnClick:(UIButton *)insert_btn{
    
    for (UIButton *reduce in self.array3) {
        if (reduce.tag == insert_btn.tag) {
            reduce.hidden = NO;
            
            for (UITextField *textF in self.array4) {
                if (textF.tag == insert_btn.tag) {
                    
                    if (self.ZeroInventorySales_sv_detail_is_enable ) {
                        if ([self.ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                            
                            for (SVduoguigeModel *model in self.bigArray) {
                                if (model.indexNum == insert_btn.tag) {
                                    if (model.sv_p_storage.doubleValue <= textF.text.doubleValue) {
                                        if (model.sv_p_storage.doubleValue <= 0) {
                                            reduce.hidden = YES;
                                        }
                                        [SVTool TextButtonAction:self.view withSing:@"库存不足"];
                                         return;
                                    }
                                }
                            }

                        }
                    }
                    textF.textColor = [UIColor colorWithHexString:@"555555"];
                    NSInteger count = [textF.text integerValue];
                    count += 1;
                    textF.text = [NSString stringWithFormat:@"%ld",count];
                    for (UIView *view in self.array5) {
                        if (view.tag == insert_btn.tag) {
                            
                            NSInteger sum = self.sumCountL.text.integerValue;
                           
                            
                                 sum += 1;
                            self.sumCountL.text = [NSString stringWithFormat:@"%ld",sum];
                            
                            [insert_btn setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
                            CGRect rect = view.frame;
                            rect.origin.y = rect.origin.y - [self.scrollView contentOffset].y + self.moreColorViewHeight.constant + 50;
                            UIImageView *imageView = (UIImageView *)insert_btn.imageView;
                            CGRect headRect = imageView.frame;
                            headRect.origin.y = rect.origin.y+headRect.origin.y;
                            //调用动效方法
                            //方法一
                            //[weakSelf startAnimationWithRect:headRect ImageView:imageView];
                            //方法二
                            // insert_btn.
                            [self startAnimationWithRect:headRect ImageView:imageView completion:^(BOOL compleBool) {
                                if (compleBool == YES) {
                                    //抖动的动效
                                    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
                                    shakeAnimation.duration = 0.25f;
                                    shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
                                    shakeAnimation.toValue = [NSNumber numberWithFloat:5];
                                    shakeAnimation.autoreverses = YES;
                                    
                                    [self.sumCountL.layer addAnimation:shakeAnimation forKey:nil];
                                    [self.iconImage.layer addAnimation:shakeAnimation forKey:nil];
                                    
                                }
                            }];
                            //让图变大变小的
                            textF.transform = CGAffineTransformMakeScale(1, 1);
                            [UIView animateWithDuration:0.1   animations:^{
                                textF.transform = CGAffineTransformMakeScale(1.5, 1.5);
                            }completion:^(BOOL finish){
                                [UIView animateWithDuration:0.1      animations:^{
                                    textF.transform = CGAffineTransformMakeScale(0.9, 0.9);
                                }completion:^(BOOL finish){
                                    [UIView animateWithDuration:0.1   animations:^{
                                        textF.transform = CGAffineTransformMakeScale(1, 1);
                                    }completion:^(BOOL finish){
                                    }];
                                }];
                            }];
                            
                            for (SVduoguigeModel *model in self.bigArray) {
                                if (model.indexNum == insert_btn.tag) {
                                    [self.selectModelArray addObject:model];
                                    // break;
                                }
                            }
                            
                            
                            break;
                        }
                    }
                    
                    
                    
                    // break;
                }
                //                NSInteger totle_count = textF.text.integerValue;
                //                if (totle_count > 0) {
                //                   NSInteger sum = self.sumCountL.text.integerValue;
                //                    sum += totle_count;
                //                    self.sumCountL.text = [NSString stringWithFormat:@"%ld",sum];
                //                }else{
                //                    continue;
                //                }
                
            }
            
            break;
        }
    }
    
    
    [insert_btn setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
    
}

#pragma mark - 动效方法
//方案一
-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView completion:(void (^)(BOOL))completion {
    //控制点击次数
    //_twoTableView.userInteractionEnabled = NO;
    //创建
    CALayer *layer = [CALayer layer];
    layer.contents = (id)imageView.layer.contents;
    
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.bounds = rect;
    //[layer setCornerRadius:CGRectGetHeight([layer bounds]) / 2];//切圆的
    //layer.masksToBounds = YES;
    // 原View中心点
    //layer.position = CGPointMake(imageView.center.x + ScreenW/6*2, CGRectGetMidY(rect) + 40);
    layer.position = CGPointMake(ScreenW - 27, CGRectGetMidY(rect) + 90);
    [self.view.layer addSublayer:layer];
    //------- 创建移动轨迹 -------//
    self.path = [UIBezierPath bezierPath];
    // 起点
    [_path moveToPoint:layer.position];
    // 终点
    //[_path addLineToPoint:CGPointMake( 37, ScreenH - 27 - 64)];//直线
    [_path addQuadCurveToPoint:CGPointMake( 35, ScreenH - 25 - TopHeight - BottomHeight) controlPoint:CGPointMake(SCREEN_WIDTH/4,rect.origin.y-80)];//抛物线
    
    
    //------- 创建移动轨迹 -------//
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    
    //------- 旋转动画 -------//
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //这个是可以调图片旋转速度
    rotationAnimation.duration= 0.4f;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //------- 创建缩小动画 -------//
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5];
    narrowAnimation.duration = 0.8;
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    narrowAnimation.removedOnCompletion = NO;
    narrowAnimation.fillMode = kCAFillModeForwards;
    
    //动画组合
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,rotationAnimation,narrowAnimation];
    //动图时间,只有设置为0.1秒，才可以完全释放_layer
    groups.duration = 0.8f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    
    [layer addAnimation:groups forKey:@"group"];
    
    
    //------- 动画结束后执行 -------//
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [layer removeFromSuperlayer];
        completion(YES);
    });
    
    
}

#pragma mark - 点击减号
- (void)reduce_btnClick:(UIButton *)reduce_btn{
    
    for (UITextField *textF in self.array4) {
        if (textF.tag == reduce_btn.tag) {
            textF.textColor = [UIColor colorWithHexString:@"555555"];
            NSInteger count = [textF.text integerValue];
            if (count == 1) {
                for (UIButton *insert_btn in self.array2) {
                    if (textF.tag == insert_btn.tag) {
                        textF.textColor = [UIColor grayColor];
                        count -= 1;
                        textF.text = [NSString stringWithFormat:@"%ld",count];
                        [insert_btn setImage:[UIImage imageNamed:@"icon_greyAddButton"] forState:UIControlStateNormal];
                        
                        NSInteger count2 = [self.sumCountL.text integerValue];
                        count2 -= 1;
                        self.sumCountL.text = [NSString stringWithFormat:@"%ld",count2];
                        //  self.sumCountL.text = [NSString stringWithFormat:@"%ld",count];
                        reduce_btn.hidden = YES;
                        break;
                    }
                }
                
                //                        return;
            }else{
                // textF.textColor = [UIColor grayColor];
                if (count > 0) {
                    NSInteger count = [textF.text integerValue];
                    count -= 1;
                    textF.text = [NSString stringWithFormat:@"%ld",count];
                    
                    NSInteger count2 = [self.sumCountL.text integerValue];
                    count2 -= 1;
                    self.sumCountL.text = [NSString stringWithFormat:@"%ld",count2];
                }
                
            }
            
            //                    for (SVduoguigeModel *model in self.bigArray) {
            //                        if (model.indexNum == reduce_btn.tag) {
            //
            //                            [self.selectModelArray removeObject:model];
            //                            NSLog(@"self.selectModelArray8888 = %@",self.selectModelArray);
            //                            break;
            //                        }
            //                    }
            
            // NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5"]];
            //                    [self.selectModelArray enumerateObjectsUsingBlock:^(SVduoguigeModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            ////                        if (model.indexNum == reduce_btn.tag) {
            ////                            [self.selectModelArray removeObject:model];
            ////                            *(stop) = YES;
            ////
            ////                        }
            //
            //                         NSLog(@"model.indexNum====%ld",model.indexNum);
            //                    }];
            //  NSLog(@"self.selectModelArray====%@",self.selectModelArray);
            
            
            //   break;
            
            
            // self.sumCountL.text = @"0";
            [self.selectModelArray removeAllObjects];
            for (UITextField *textF in self.array4) {
                if (textF.text.integerValue == 0) {
                    continue;
                }else{
                    //  NSInteger count2 = [self.sumCountL.text integerValue];
                    NSInteger text_count = textF.text.integerValue;
                    for (SVduoguigeModel *model in self.bigArray) {
                        if (model.indexNum == textF.tag) {
                            for (NSInteger i = 0; i < text_count; i++) {
                                [self.selectModelArray addObject:model];
                            }
                            // [self.selectModelArray addObject:model];
                            //  break;
                        }
                    }
                    
                    //                            count2 += text_count;
                    //                            self.sumCountL.text = [NSString stringWithFormat:@"%ld",count2];
                }
            }
            
        }
        
        
        NSLog(@"self.selectModelArray====%@",self.selectModelArray);
        
        //                NSInteger totle_count = textF.text.integerValue;
        //                if (totle_count > 0) {
        //                    NSInteger sum = self.sumCountL.text.integerValue;
        //                    sum += totle_count;
        //                    self.sumCountL.text = [NSString stringWithFormat:@"%ld",sum];
        //
        //                }else{
        //                    continue;
        //                }
    }
    
}




-(void)hiddenNO{
    self.reduce_btn.hidden = NO;
    self.count_text.textColor = [UIColor blackColor];
    [self.insert_btn setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
}

#pragma mark - 圈圈按钮
- (void)circle_btnClick:(UIButton *)btn{
    if (btn.selected == YES) {
        //        UITextField *textField = self.moreTextArray[btn.tag];
        //        NSInteger count = [textField.text integerValue];
        //        NSString *countStr = self.totleNum.text;
        //        NSInteger num = [countStr integerValue];
        //        num -= count;
        //        self.totleNum.text = [NSString stringWithFormat:@"%ld",num];
        [self.selectModelArray removeObject:self.duoguigeArray2[btn.tag]];
        self.shopNum -= 1;
        self.shopTypeNum.text = [NSString stringWithFormat:@"已加商品：%ld种",self.shopNum];
        
        [btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
        btn.selected = NO;
        
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
        [self.PrintingCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [[UIApplication sharedApplication].keyWindow addSubview:self.PrintingCollectionView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.icon_button];
        
        // [self.selectModelArray addObject:self.duoguigeArray2[btn.tag]];
        SVduoguigeModel *model = self.duoguigeArray2[btn.tag];
        if (self.isStockPurchase == 0) {
            model.isStockPurchase = @"0";
        }else if (self.isStockPurchase == 1){
            model.isStockPurchase = @"1";
        }
        else{
            model.isStockPurchase = @"2";
        }
        
        self.model = model;
        [self.selectModelArray addObject:model];
        self.shopNum += 1;
        self.shopTypeNum.text = [NSString stringWithFormat:@"已加商品：%ld种",self.shopNum];
        [btn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
        btn.selected = YES;
        [self.PrintingCollectionView reloadData];
        
        
        //        NSInteger totleNum = 0;
        //        for (UITextField *textF in self.moreTextArray) {
        //            NSInteger textNum = [textF.text integerValue];
        //            totleNum += textNum;
        //        }
        //
        //        if (num == totleNum) {
        //             [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
        //            self.allSelectBtn.selected = YES;
        //        }else{
        //            [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
        //            self.allSelectBtn.selected = NO;
        //        }
    }
    
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
    [cell.string setString:@""];
    cell.model = self.model;
    __weak typeof(self) weakSelf = self;
    cell.sureBtnClickBlock = ^(NSInteger selctCount, SVduoguigeModel * _Nonnull model_two) {
        for (SVduoguigeModel *model in weakSelf.selectModelArray) {
            if ([model.product_id isEqualToString:model_two.product_id]) {
                [weakSelf.selectModelArray removeObject:model];
                break;
            }
            
        }
        
        [weakSelf.selectModelArray addObject:model_two];
        
        [weakSelf handlePan];
    };
    
    return cell;
    
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
    
}

#pragma mark - 单选圈圈
- (void)SingCircle_btnClick:(UIButton *)btn{
    if (btn.selected == YES) {
        UITextField *textField = self.singleTextArray[btn.tag];
        NSInteger count = [textField.text integerValue];
        NSString *countStr = self.totleNum.text;
        NSInteger num = [countStr integerValue];
        num -= count;
        self.totleNum.text = [NSString stringWithFormat:@"%ld",num];
        
        
        [btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
        btn.selected = NO;
        
        [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
        self.allSelectBtn.selected = NO;
        //        }
        
        //        [circle_btn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    }else{
        
        UITextField *textField = self.singleTextArray[btn.tag];
        NSInteger count = [textField.text integerValue];
        NSString *countStr = self.totleNum.text;
        NSInteger num = [countStr integerValue];
        num += count;
        self.totleNum.text = [NSString stringWithFormat:@"%ld",num];
        
        [btn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
        btn.selected = YES;
        
        NSInteger totleNum = 0;
        for (UITextField *textF in self.singleTextArray) {
            NSInteger textNum = [textF.text integerValue];
            totleNum += textNum;
        }
        
        if (num == totleNum) {
            [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
            self.allSelectBtn.selected = YES;
        }else{
            [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
            self.allSelectBtn.selected = NO;
        }
    }
}


#pragma mark - 单选按钮
- (void)tagBtnClickClose:(UIButton *)btn{
    [self.singleTextArray removeAllObjects];
    [self.singleCircle_btnArray removeAllObjects];
    self.totleNum.text = @"0";
    [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    self.allSelectBtn.selected = NO;
    [[self.colorAndSizeView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.tagBtn.selected = NO;
    self.tagBtn.layer.borderColor =[UIColor grayColor].CGColor;
    self.tagBtn.backgroundColor = [UIColor whiteColor];
    btn.selected = YES;
    //    btn.layer.borderColor = ZZ_RGB(250, 80, 20).CGColor;
    btn.layer.borderColor = [[UIColor clearColor] CGColor];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setBackgroundColor:[UIColor orangeColor]];
    self.tagBtn = btn;
    
    NSLog(@"self.selectSplitArray = %@",self.selectSplitArray);
    CGFloat maxY = 0;
    for (NSInteger i = 0; i < self.listAry2.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.colorAndSizeView addSubview:view];
        
        UIButton *circle_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        // NSMutableArray *circle_btnArr = self.singleBtnArray[btn.tag];
        circle_btn.tag = i;
        [view addSubview:circle_btn];
        [circle_btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
        [circle_btn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
        
        [circle_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.left.mas_equalTo(view.mas_left).offset(10);
        }];
        
        [circle_btn addTarget:self action:@selector(SingCircle_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.singleCircle_btnArray addObject:circle_btn];
        
        
        UILabel *leftLabel = [[UILabel alloc] init];
        [view addSubview:leftLabel];
        leftLabel.backgroundColor = [UIColor whiteColor];
        leftLabel.textColor = [UIColor colorWithHexString:@"555555"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.text = self.listAry1[btn.tag];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(circle_btn.mas_right).offset(5);
            make.centerY.mas_equalTo(view.mas_centerY);
        }];
        
        
        UILabel *leftLabel2 = [[UILabel alloc] init];
        [view addSubview:leftLabel2];
        leftLabel2.backgroundColor = [UIColor whiteColor];
        leftLabel2.textColor = [UIColor colorWithHexString:@"555555"];
        leftLabel2.font = [UIFont systemFontOfSize:14];
        // NSMutableArray *arr = self.selectSplitArray[j];
        leftLabel2.text = self.listAry2[i];
        
        [leftLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(view.mas_centerY);
        }];
        
        
        UILabel *middleLabel = [[UILabel alloc] init];
        [view addSubview:middleLabel];
        middleLabel.backgroundColor = [UIColor whiteColor];
        middleLabel.textColor = [UIColor colorWithHexString:@"555555"];
        middleLabel.font = [UIFont systemFontOfSize:14];
        NSMutableArray *arr = self.splitArray[btn.tag];
        middleLabel.text = arr[i];
        [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.tag = i;
        [view addSubview:addBtn];
        [addBtn setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.right.mas_equalTo(view.mas_right).offset(-10);
        }];
        [addBtn addTarget:self action:@selector(singleAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UITextField *textField = [[UITextField alloc] init];
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.textColor = [UIColor colorWithHexString:@"555555"];
        textField.font = [UIFont systemFontOfSize:14];
        NSMutableArray *arr2 = self.splitArray[btn.tag];
        textField.text = arr2[i];
        [view addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.width.mas_equalTo(40);
            make.right.mas_equalTo(addBtn.mas_left).offset(-5);
        }];
        [self.singleTextArray addObject:textField];
        
        
        UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reduceBtn.tag = i;
        [view addSubview:reduceBtn];
        [reduceBtn setImage:[UIImage imageNamed:@"icon_reduce"] forState:UIControlStateNormal];
        [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.right.mas_equalTo(textField.mas_left).offset(-5);
        }];
        
        [reduceBtn addTarget:self action:@selector(singleReduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        maxY = CGRectGetMaxY(view.frame) + 1 ;
        
    }
    
    self.colorAndSizeHeight.constant =  self.listAry2.count* 50 + self.listAry2.count -1;
    self.sizeViewHeight.constant = self.colorAndSizeHeight.constant + 50 + 1;
    
}

#pragma mark - 懒加载

- (NSMutableArray *)picUrlArr
{
    if (_picUrlArr == nil) {
        _picUrlArr = [NSMutableArray array];
    }
    return _picUrlArr;
}

- (NSMutableArray *)imageArr
{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray *)duoguigeArray
{
    if (_duoguigeArray == nil) {
        _duoguigeArray = [NSMutableArray array];
    }
    return _duoguigeArray;
}

- (NSMutableArray *)duoguigeArray2
{
    if (_duoguigeArray2 == nil) {
        _duoguigeArray2 = [NSMutableArray array];
    }
    return _duoguigeArray2;
}


- (NSMutableArray *)listAry1
{
    if (_listAry1 == nil) {
        _listAry1 = [NSMutableArray array];
    }
    return _listAry1;
}

- (NSMutableArray *)listAry2
{
    if (_listAry2 == nil) {
        _listAry2 = [NSMutableArray array];
    }
    return _listAry2;
}

- (NSMutableArray *)selectColorArray{
    if (_selectColorArray == nil) {
        _selectColorArray = [NSMutableArray array];
    }
    
    return _selectColorArray;
}

- (NSMutableArray *)sizeAttributeArray{
    if (!_sizeAttributeArray) {
        _sizeAttributeArray = [NSMutableArray array];
    }
    
    return _sizeAttributeArray;
}

- (NSMutableArray *)colors{
    if (!_colors) {
        _colors = [NSMutableArray array];
    }
    
    return _colors;
}

- (NSMutableArray *)sizes{
    if (!_sizes) {
        _sizes = [NSMutableArray array];
    }
    
    return _sizes;
}

- (NSMutableArray *)splitArray{
    if (!_splitArray) {
        _splitArray = [NSMutableArray array];
    }
    
    return _splitArray;
}

- (NSMutableArray *)selectSplitArray{
    if (!_selectSplitArray) {
        _selectSplitArray = [NSMutableArray array];
    }
    
    return _selectSplitArray;
}

- (NSMutableArray *)selectSplitArray2{
    if (!_selectSplitArray2) {
        _selectSplitArray2 = [NSMutableArray array];
    }
    
    return _selectSplitArray2;
}

- (NSMutableArray *)selectSplitArray3{
    if (!_selectSplitArray3) {
        _selectSplitArray3 = [NSMutableArray array];
    }
    
    return _selectSplitArray3;
}

- (NSMutableArray *)selectSplitArray4{
    if (!_selectSplitArray4) {
        _selectSplitArray4 = [NSMutableArray array];
    }
    
    return _selectSplitArray4;
}

- (NSMutableArray *)selectSplitArray5{
    if (!_selectSplitArray5) {
        _selectSplitArray5 = [NSMutableArray array];
    }
    
    return _selectSplitArray5;
}


- (NSMutableArray *)moreTextArray{
    if (!_moreTextArray) {
        _moreTextArray = [NSMutableArray array];
    }
    
    return _moreTextArray;
}


- (NSMutableArray *)moreBtnArray{
    if (!_moreBtnArray) {
        _moreBtnArray = [NSMutableArray array];
    }
    
    return _moreBtnArray;
}



- (NSMutableArray *)circle_btnArray{
    if (!_circle_btnArray) {
        _circle_btnArray = [NSMutableArray array];
    }
    
    return _circle_btnArray;
}

- (NSMutableArray *)singleTextArray{
    if (!_singleTextArray) {
        _singleTextArray = [NSMutableArray array];
    }
    
    return _singleTextArray;
}
//singleCircle_btnArray

- (NSMutableArray *)singleCircle_btnArray{
    if (!_singleCircle_btnArray) {
        _singleCircle_btnArray = [NSMutableArray array];
    }
    
    return _singleCircle_btnArray;
}
//singleTextArray   singleBtnArray
- (NSMutableArray *)singleBtnArray{
    if (!_singleBtnArray) {
        _singleBtnArray = [NSMutableArray array];
    }
    
    return _singleBtnArray;
}
//NSMutableArray *bigArray
- (NSMutableArray *)dateMutablearray{
    if (!_dateMutablearray) {
        _dateMutablearray = [NSMutableArray array];
    }
    
    return _dateMutablearray;
}

- (NSMutableArray *)dateMutablearray2{
    if (!_dateMutablearray2) {
        _dateMutablearray2 = [NSMutableArray array];
    }
    
    return _dateMutablearray2;
}

- (NSMutableArray *)dateMutablearray3{
    if (!_dateMutablearray3) {
        _dateMutablearray3 = [NSMutableArray array];
    }
    
    return _dateMutablearray3;
}

- (NSMutableArray *)array2{
    if (!_array2) {
        _array2 = [NSMutableArray array];
    }
    
    return _array2;
}

- (NSMutableArray *)array3{
    if (!_array3) {
        _array3 = [NSMutableArray array];
    }
    
    return _array3;
}

- (NSMutableArray *)array4{
    if (!_array4) {
        _array4 = [NSMutableArray array];
    }
    
    return _array4;
}

- (NSMutableArray *)array5{
    if (!_array5) {
        _array5 = [NSMutableArray array];
    }
    
    return _array5;
}

- (NSMutableArray *)dateMutablearray4{
    if (!_dateMutablearray4) {
        _dateMutablearray4 = [NSMutableArray array];
    }
    
    return _dateMutablearray4;
}
- (NSMutableArray *)dateMutablearray5{
    if (!_dateMutablearray5) {
        _dateMutablearray5 = [NSMutableArray array];
    }
    
    return _dateMutablearray5;
}


- (NSMutableArray *)bigArray{
    if (!_bigArray) {
        _bigArray = [NSMutableArray array];
    }
    
    return _bigArray;
}

- (NSMutableArray *)selectModelArray{
    if (!_selectModelArray) {
        _selectModelArray = [NSMutableArray array];
    }
    
    return _selectModelArray;
}

- (NSMutableArray *)insert_btnArray{
    if (_insert_btnArray == nil) {
        _insert_btnArray = [NSMutableArray array];
    }
    
    return _insert_btnArray;
}

- (NSMutableArray *)count_textArray{
    if (_count_textArray == nil) {
        _count_textArray = [NSMutableArray array];
    }
    
    return _count_textArray;
}

- (NSMutableArray *)viewArray{
    if (_viewArray == nil) {
        _viewArray = [NSMutableArray array];
    }
    
    return _viewArray;
}



- (NSMutableArray *)reduce_btnArray{
    if (_reduce_btnArray == nil) {
        _reduce_btnArray = [NSMutableArray array];
    }
    
    return _reduce_btnArray;
}

//- (NSMutableArray *)picUrlArr
//{
//    if (_picUrlArr == nil) {
//        _picUrlArr = [NSMutableArray array];
//    }
//    return _picUrlArr;
//}
//
//- (NSMutableArray *)imageArr
//{
//    if (_imageArr == nil) {
//        _imageArr = [NSMutableArray array];
//    }
//    return _imageArr;
//}

@end
