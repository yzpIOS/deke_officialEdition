//
//  SVModifyInformationVC.m
//  SAVI
//
//  Created by Sorgle on 17/5/5.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVModifyInformationVC.h"
#import "SVModifyOneVeiw.h"
#import "SVModifyThreeView.h"
#import "SVModifyTwoView.h"
#import "SVInformationVC.h"


@interface SVModifyInformationVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
//头像view
@property (nonatomic,strong) SVModifyThreeView *threeView;
@property (nonatomic,strong) SVModifyOneVeiw *OneVeiw;
@property (nonatomic,strong) SVModifyTwoView *TwoView;
//全局图片
@property (nonatomic,strong) UIImage *iconImage;
//全局
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation SVModifyInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//    title.text = @"修改信息";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"修改信息";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.view.backgroundColor = BackgroundColor;
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight-BottomHeight)];
    self.scrollView.contentSize = CGSizeMake(0, 550);
    self.scrollView.backgroundColor = BackgroundColor;
    // 隐藏滑动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    //关掉弹簧效果
    self.scrollView.bounces = NO;
    //指定代理
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.threeView = [[NSBundle mainBundle]loadNibNamed:@"SVModifyThreeView" owner:nil options:nil].lastObject;
    //self.threeView.frame = CGRectMake(0, 74, ScreenW, 75);
    
    //头像
    [SVUserManager loadUserInfo];
//    if ([SVUserManager shareInstance].sv_us_logo) {
//        if (![[SVUserManager shareInstance].sv_us_logo isKindOfClass:[NSNull class]]) {
//            [self.threeView.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].sv_us_logo]] placeholderImage:[UIImage imageNamed:@"iconView"]];
//        }
//    }
    //头像
    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_logo]) {
        
        
        [self.threeView.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].sv_us_logo]] placeholderImage:[UIImage imageNamed:@"iconView"]];
    }
    
    [self.scrollView addSubview:self.threeView];
    
    [self.threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 85));
        make.top.mas_equalTo(self.scrollView).offset(20);
        make.left.mas_equalTo(self.scrollView);
    }];
    
    
    self.OneVeiw = [[NSBundle mainBundle]loadNibNamed:@"SVModifyOneVeiw" owner:nil options:nil].lastObject;
    //self.OneVeiw.frame = CGRectMake(0, 159, ScreenW, 122);
    
    //店铺名称
    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_name]) {
        self.OneVeiw.shopName.text = [SVUserManager shareInstance].sv_us_name;
    }
    
    //店铺简称
    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_shortname]) {
//    NSString *shortname = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_shortname];
        self.OneVeiw.shopReferred.text = [SVUserManager shareInstance].sv_us_shortname;
    }
    
    //店铺手机
    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_phone]) {
//    NSString *phone = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_phone];
        self.OneVeiw.shopNumber.text = [SVUserManager shareInstance].sv_us_phone;
    }
    
    [self.scrollView addSubview:self.OneVeiw];
    
    [self.OneVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 168));
        make.top.mas_equalTo(self.threeView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.scrollView);
    }];
    
    
    self.TwoView = [[NSBundle mainBundle]loadNibNamed:@"SVModifyTwoView" owner:nil options:nil].lastObject;
    //self.TwoView.frame = CGRectMake(0, 291, ScreenW, 122);
    
    //店主名称
    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_ul_name]) {
        self.TwoView.Name.text = [SVUserManager shareInstance].sv_ul_name;
    }
    
    //email
    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_ul_email]) {
//    NSString *email = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_ul_email];
        self.TwoView.Email.text = [SVUserManager shareInstance].sv_ul_email;
    }
    
    //行业
    self.TwoView.IndustryTypes.text = [SVUserManager shareInstance].sv_us_address;
    [self.scrollView addSubview:self.TwoView];
    [self.TwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, 168));
        make.top.mas_equalTo(self.OneVeiw.mas_bottom).offset(20);
        make.left.mas_equalTo(self.scrollView);
    }];
    
    //footerButton
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, ScreenH - TopHeight - 50, ScreenW, 50);
    //设置背景色
    button.backgroundColor = navigationBackgroundColor;
    [button addTarget:self action:@selector(buttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    //上传头像
    //  把头像设置成圆形
    self.threeView.iconImg.layer.cornerRadius=self.threeView.iconImg.frame.size.width/2;
    self.threeView.iconImg.layer.masksToBounds=YES;
    //  给头像加一个圆形边框
    self.threeView.iconImg.layer.borderWidth = 1.5f;
    self.threeView.iconImg.layer.borderColor = [UIColor whiteColor].CGColor;
    /**
     *  添加手势：也就是当用户点击头像了之后，对这个操作进行反应
     */
    //允许用户交互
    self.threeView.iconImg.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterHeadPortrait:)];
    //给ImageView添加手势
    [self.threeView.iconImg addGestureRecognizer:singleTap];
    
    //    if (headImg != nil) {
    //        self.threeView.iconImg.image = headImg;
    //    }
}

#pragma mark - 修改头像的响应方法
//  方法：alterHeadPortrait
-(void)alterHeadPortrait:(UITapGestureRecognizer *)gesture{
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
    self.iconImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    self.threeView.iconImg.image = self.iconImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(saveImage:) withObject:self.iconImage afterDelay:0.5];

}

#pragma mark - 上传图片的方法
- (void)saveImage:(UIImage *)image {
    
    [SVUserManager loadUserInfo];
    
//    NSString *host_url = @"http://api.decerp.cc";
    
    NSString *loadImage_path = @"/system/UploadImg";

//    NSString *urlStr= [host_url stringByAppendingFormat:@"%@?key=%@",loadImage_path,[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    NSString *urlStr= [URLHeadPicture stringByAppendingFormat:@"%@?key=%@",loadImage_path,[SVUserManager shareInstance].access_token];
    
    UIImage *newImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(200.0f, 200.0f)];
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = UIImagePNGRepresentation(newImage);
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:data
         
                                    name:@"icon"
         
                                fileName:@"icon.jpg"
         
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
//            [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
            
            [SVUserManager loadUserInfo];
            
            [SVUserManager shareInstance].sv_us_logo = [self changeImagePath: dic[@"values"]];
            
            [SVUserManager saveUserInfo];
            
        } else {
//            [SVProgressHUD showErrorWithStatus:@"图片保存失败"];
//            //用延迟来移除提示框
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
            [SVTool TextButtonAction:self.view withSing:@"图片保存失败"];
            
        }
        
        
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}
//截掉图片拼接路径
-(NSString*)changeImagePath:(NSString*)path{
    return  [path stringByReplacingOccurrencesOfString:URLHeadPortrait withString:@""];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - 保存按钮
-(void)buttonResponseEvent{
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].user_id integerValue] == 73199835) {
        [SVTool TextButtonAction:self.view withSing:@"亲,体验帐号是不可以修改的"];
        return;
    }
    
    if (![SVTool isBlankString:self.TwoView.Email.text]) {
        if ([SVTool isValidateEmail:self.TwoView.Email.text] == NO) {
            [SVTool TextButtonAction:self.view withSing:@"邮箱格式错误"];
            return;
        }
    }
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.label.text = @"等待用户支付中...";
//    hud.label.textColor = [UIColor whiteColor];//字体颜色
//    hud.bezelView.color = [UIColor blackColor];//背景颜色
//    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
//    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
//    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
//    hud.yOffset = -35.0f;
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    
    [SVUserManager loadUserInfo];
    
    NSString *shopName = [NSString  stringWithFormat:@"%@",self.OneVeiw.shopName.text];
    NSString *shopReferred = [NSString stringWithFormat:@"%@",self.OneVeiw.shopReferred.text];
    NSString *shopNumber = [NSString stringWithFormat:@"%@",self.OneVeiw.shopNumber.text];
    NSString *Name = [NSString stringWithFormat:@"%@",self.TwoView.Name.text];
    NSString *Email = [NSString stringWithFormat:@"%@",self.TwoView.Email.text];
    NSString *IndustryTypes = [NSString stringWithFormat:@"%@",self.TwoView.IndustryTypes.text];
//    将参数拼接到URL后面
//    NSString *sURL=[urlStr  stringByAppendingFormat:@"?&sv_us_name=%@&sv_us_shortname=%@&sv_us_phone=%@&sv_ul_name=%@&sv_ul_email=%@&sv_uit_name=%@",shopName,shopReferred,shopNumber,Name,Email,IndustryTypes];
    NSMutableDictionary *patameters = [NSMutableDictionary dictionary];
    //头像
    [patameters setObject:[SVUserManager shareInstance].sv_us_logo forKey:@"sv_us_logo"];
    //注册时间
    //[patameters setObject:[SVUserManager shareInstance].sv_ul_regdate forKey:@"sv_ul_regdate"];
    //店铺名称
    [patameters setObject:shopName forKey:@"sv_us_name"];
    //店铺简称
    [patameters setObject:shopReferred forKey:@"sv_us_shortname"];
    //座机
    [patameters setObject:shopNumber forKey:@"sv_us_phone"];
    //店主名称
    [patameters setObject:Name forKey:@"sv_ul_name"];
    //电子邮件
    [patameters setObject:Email forKey:@"sv_ul_email"];
    //手机号码
    //[patameters setObject:[SVUserManager shareInstance].sv_ul_mobile forKey:@"sv_ul_mobile"];
    //地址
    [patameters setObject:IndustryTypes forKey:@"sv_us_address"];
    

    
    //头像
//    [SVUserManager shareInstance].sv_us_logo = dic[@"sv_us_logo"];
    //店铺名称
    [SVUserManager shareInstance].sv_us_name = shopName;
    //店铺简称
    [SVUserManager shareInstance].sv_us_shortname = shopReferred;
    //注册时间
//    [SVUserManager shareInstance].sv_ul_regdate = dic[@"sv_ul_regdate"];
    //店铺电话
    [SVUserManager shareInstance].sv_us_phone = shopNumber;
    //店主名称
    [SVUserManager shareInstance].sv_ul_name = Name;
    //手机号码
//    [SVUserManager shareInstance].sv_ul_mobile = dic[@"sv_ul_mobile"];
    //电子邮件
    [SVUserManager shareInstance].sv_ul_email = Email;
    //地址
    [SVUserManager shareInstance].sv_us_address = self.TwoView.IndustryTypes.text;
    //修改后，要同步这一句
    [SVUserManager saveUserInfo];
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System?key=%@",[SVUserManager shareInstance].access_token];
//    [patameters setObject:IndustryTypes forKey:@"sv_uit_name"];
    [[SVSaviTool sharedSaviTool] PUT:urlStr parameters:patameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        //NSString *values = dic[@"values"];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [SVTool TextButtonAction:self.view withSing:@"修改成功"];
            
            if (self.ModifyInformationBlock) {
                self.ModifyInformationBlock();
            }
            
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

@end
