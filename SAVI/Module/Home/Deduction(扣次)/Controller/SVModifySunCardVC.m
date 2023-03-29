//
//  SVModifySunCardVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/29.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVModifySunCardVC.h"
#import "SVCardRechargeInfoModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SVSelectTwoDatesView.h"
@interface SVModifySunCardVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *serviceObject;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextField *Remarks;
//图片路径
@property (nonatomic,copy) NSString *imgURL;
@property (weak, nonatomic) IBOutlet UIView *timeView;
//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
//遮盖view
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
@end

@implementation SVModifySunCardVC
- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改次卡";
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.name.text = self.model.sv_p_name;
    
   // NSString *sv_p_images = dict[@"sv_p_images2"];
    
    if (![SVTool isBlankString:self.model.sv_p_images2]) {

        [self.btnImage sd_setBackgroundImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.model.sv_p_images2]] forState:UIControlStateNormal];
    } else {
        
        // self.icon.image = [UIImage imageNamed:@"foodimg"];
    }
    
    self.price.text = [NSString stringWithFormat:@"%@",self.model.sv_p_unitprice];
    
//    NSString *result = self.model.combination_new;
//    NSMutableArray *arr = [NSMutableArray array];
//    if (!kStringIsEmpty(result)) {
//        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
//        arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"arr = %@",arr);
//        // self.infoDataArray = arr;
//    }
//    self.arr = arr;
    
    // self.iconImage.image = [UIImage imageNamed:@"%@",];
    NSString *nameStr;
    //        for (NSDictionary *arrDic in arr) {
    //            nameStr = [nameStr stringByAppendingFormat:@"%@,",arrDic[@"sv_p_name"]];
    //        }
    for (int i = 0 ; i < self.arr.count; i++) {
        if (i == 0) {
            NSDictionary *arrDic = self.arr[i];
            nameStr = [NSString stringWithFormat:@"%@,",arrDic[@"sv_p_name"]];
        }else{
            NSDictionary *arrDic = self.arr[i];
            nameStr = [nameStr stringByAppendingFormat:@"%@,",arrDic[@"sv_p_name"]];
        }
    }
    
    NSString *str3 = [nameStr substringToIndex:nameStr.length-1];//str3 = "this"
    self.serviceObject.text = str3;
    
    NSString *startTime = [self.model.sv_dis_startdate substringToIndex:10];
    NSString *endTime = [self.model.sv_dis_startdate substringToIndex:10];
//    self.oneDate = startTime;
//    self.twoDate = endTime;
    self.time.text = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];
    
    self.Remarks.text = self.model.sv_p_remark;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.timeView addGestureRecognizer:tap];
    
}

- (void)tapClick{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
    
    [UIView animateWithDuration:.3 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
    }];
}
- (IBAction)baocunClick:(id)sender {
    [SVUserManager loadUserInfo];
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/CardSetmeal/AddOrUpdateCardSetmealProduct?key=%@",[SVUserManager shareInstance].access_token];
    
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    NSMutableArray *combination_new = [NSMutableArray array];
   // float sv_p_unitprice = 0.0;
    for (NSDictionary *dic in self.arr) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"product_id"] = self.model.product_id;
        
        dict[@"sv_acc_performance"] = @(0);
        dict[@"sv_is_life"] = @(0);
        dict[@"sv_mcc_leftcount"] = @(0);
        dict[@"sv_mcc_sumcount"] = @(0);
        
        dict[@"sv_p_totaloriginalprice"] = @(0);
        // model.give;  model.purchase; @([model.purchase integerValue]);
        dict[@"product_list_id"] = @([dic[@"product_list_id"] integerValue]);
        NSString *give = [NSString stringWithFormat:@"%@",dic[@"sv_give_count"]];
        if (kStringIsEmpty(give)) {
            dict[@"sv_give_count"] = @(0);
        }else{
            dict[@"sv_give_count"] = @([give integerValue]);
        }
        dict[@"sv_p_name"] = dic[@"sv_p_name"];
        dict[@"product_number"] = @([dic[@"product_number"] integerValue]);
        dict[@"sv_dis_price"] = @([dic[@"sv_dis_price"] integerValue]);
        dict[@"sv_price"] = @([dic[@"sv_price"] integerValue]);
  
        NSString *sv_per_price = [NSString stringWithFormat:@"%.2f",[dic[@"sv_p_unitprice"] floatValue] - [dic[@"sv_price"] floatValue]];
        dict[@"sv_per_price"] = @([sv_per_price floatValue]);
      //  if ([model.time isEqualToString:@"日"]) {
            
            dict[@"sv_eff_rangetype"] = @([dic[@"sv_eff_rangetype"] integerValue]);
            dict[@"sv_eff_range"] = @([dic[@"sv_eff_range"] integerValue]);

        [combination_new addObject:dict];
    }
    
    NSString *combination_newTwo = [self arrayToJSONString:combination_new];
    parame[@"combination_new"] = combination_newTwo;
    //  [SVUserManager shareInstance].user_id
    parame[@"product_id"] = self.model.product_id;
    if (kStringIsEmpty(self.oneDate)) {
        parame[@"sv_dis_startdate"] = self.model.sv_dis_startdate;
    }else{
        parame[@"sv_dis_startdate"] = [NSString stringWithFormat:@"%@ 00:00:00",self.oneDate];;
    }
    
    if (kStringIsEmpty(self.twoDate)) {
        parame[@"sv_dis_enddate"] = self.model.sv_dis_enddate;
    }else{
        parame[@"sv_dis_enddate"] = [NSString stringWithFormat:@"%@ 23:59:59",self.twoDate];
    }
    
    
    parame[@"sv_p_remark"] = self.Remarks.text;
    parame[@"sv_p_unitprice"] = [NSString stringWithFormat:@"%@",self.model.sv_p_unitprice];
    parame[@"sv_product_type"] = @(4);
    parame[@"sv_p_images"] = self.imgURL;
    parame[@"sv_p_name"] = self.name.text;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *sv_syn_userids = [NSMutableDictionary dictionary];
    sv_syn_userids[@"sv_us_name"] = self.name.text;
    sv_syn_userids[@"user_id"] = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].user_id];
    [array addObject:sv_syn_userids];
    NSString *reslt = [self arrayToJSONString:array];
    parame[@"sv_syn_userids"] = reslt;
    parame[@"user_id"] = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].user_id];
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic444---%@",dic);
        if ([dic[@"succeed"] intValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

//数组转为json字符串
- (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *jsonResult2 = [jsonResult stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    return jsonResult2;
}

- (IBAction)sureClick:(id)sender {
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.btnImage setBackgroundImage:newPhoto forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //    //给服务器上传图片
    //    UIImage *newImage = [self imageWithImageSimple:newPhoto scaledToSize:CGSizeMake(200.0f, 200.0f)];
    
    [self performSelector:@selector(saveImage:)  withObject:newPhoto afterDelay:0.5];
}

#pragma mark - 上传图片的方法
- (void)saveImage:(UIImage *)image {
    
    [SVUserManager loadUserInfo];
    
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在压缩图片"];
    NSString *loadImage_path = @"/system/UploadImg";
    
    NSString *urlStr= [URLHeadPicture stringByAppendingFormat:@"%@?key=%@",loadImage_path,[SVUserManager shareInstance].access_token];
    
    //  NSData *newIMGData = [self resetSizeOfImageData:image maxSize:30];
    
  //  NSData *newIMGData = [image bb_compressWithMaxLength:50 sizeMultiple:0];
    NSData *newIMGData = [image bb_compressWithMaxLength:50 size:CGSizeMake(750, 1334)];
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //                NSData *data = [NSUtil dataWithOriginalImage:newImage];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:newIMGData
         
                                    name:@"icon"
         
                                fileName:@"icon.jpg"
         
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            //                    [SVTool ];
            if ([self changeImagePath:dic[@"values"]].length <= 0) {
                [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
            }else{
                self.btnImage.imageView.hidden = YES;
                self.btnImage.titleLabel.hidden = YES;
                self.imgURL = [self changeImagePath:dic[@"values"]];
                NSLog(@"self.imgURL = %@",self.imgURL);
            }
            
        } else {
            
            [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

//截掉图片拼接路径
-(NSString*)changeImagePath:(NSString*)path{
    return  [path stringByReplacingOccurrencesOfString:URLHeadPortrait withString:@""];
}

#pragma mark - 懒加载

-(SVSelectTwoDatesView *)DateView {
    
    if (!_DateView) {
        _DateView = [[[NSBundle mainBundle] loadNibNamed:@"SVSelectTwoDatesView" owner:nil options:nil] lastObject];
        _DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
        
        [_DateView.cancelButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_DateView.determineButton addTarget:self action:@selector(twoCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        NSDate *minDate = [NSDate date];
        //设置显示模式
        [_DateView.oneDatePicker setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
//        _DateView.oneDatePicker.maximumDate = maxDate;
//        _DateView.oneDatePicker.maximumDate = minDate;
        
        //设置显示模式
        [_DateView.twoDatePicker setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
//        _DateView.twoDatePicker.maximumDate = maxDate;
//        _DateView.twoDatePicker.maximumDate = minDate;
        
    }
    
    return _DateView;
}


- (void)twoCancelResponseEvent{
    [self oneCancelResponseEvent];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDate format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
    
//        NSString *startTime = [self.model.sv_dis_startdate substringToIndex:10];
//        NSString *endTime = [self.model.sv_dis_startdate substringToIndex:10];
        self.time.text = [NSString stringWithFormat:@"%@ 至 %@",self.oneDate,self.twoDate];
    }
}


//遮盖View
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskView addGestureRecognizer:tap];
        
        [_maskView addSubview:_DateView];
    }
    return _maskView;
}

- (void)oneCancelResponseEvent{
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
}

@end
