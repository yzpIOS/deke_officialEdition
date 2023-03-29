//
//  SVFeedbackVC.m
//  SAVI
//
//  Created by Sorgle on 2017/7/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVFeedbackVC.h"

@interface SVFeedbackVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    UILabel *_placeHolderLabel;
    UILabel *_numberLabel;
}

@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
//全局图片
@property (nonatomic,strong) UIImage *iconImage;
//图片路径
@property (nonatomic,copy) NSString *imgURL;

@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation SVFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"反馈问题";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"反馈问题";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //允许用户交互
    self.iconImg.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alterHeadPortrait:)];
    //给ImageView添加手势
    [self.iconImg addGestureRecognizer:singleTap];
    
    //指定UITextView
    self.content.delegate = self;
    //创建Label
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, ScreenW - 10, 20)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.text = @"亲,把您的宝贵建议写在这里…";
    _placeHolderLabel.textColor = [UIColor grayColor];
    [self.content addSubview:_placeHolderLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, ScreenW-10, 15)];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.font = [UIFont systemFontOfSize:14];
    _numberLabel.hidden = YES;
    _numberLabel.textColor = placeholderFontColor;
    [self.content addSubview:_numberLabel];
    
    //设置按钮圆角
    self.button.layer.cornerRadius = 6;
    
}

//设置textView的placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""])
    {
        _placeHolderLabel.hidden = YES;
        _numberLabel.hidden = NO;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        _placeHolderLabel.hidden = NO;
        _numberLabel.hidden = YES;
    }
    
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    _numberLabel.text = [NSString stringWithFormat:@"%ld",pointLength];
    
    return YES;
    
}

//打电话
-(IBAction)cellResponseEvent{
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000521131"];
    //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {
        
    }];//此方法有一个报错
}

/**
 提交按钮
 */
- (IBAction)SubmitButton {
    
    if ([SVTool isBlankString:self.content.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请输入您的反馈内容"];
        return;
    }
    
    if (self.content.text.length <= 10) {
        [SVTool TextButtonAction:self.view withSing:@"亲,您描述的内容过于简单"];
        return;
    }
    
    [self.button setEnabled:NO];
    //不用交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
//    [SVProgressHUD showWithStatus:@"正在提交中"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在提交中...";
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    
    [SVUserManager loadUserInfo];
    NSString *strURL = [URLhead stringByAppendingFormat:@"/UserFeedback?key=%@",[SVUserManager shareInstance].access_token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.content.text forKey:@"userfeedback_content"];
    
    [parameters setObject:[SVUserManager shareInstance].user_id forKey:@"user_id"];
    if ([SVTool isBlankString:self.imgURL]) {
        [parameters setObject:@"" forKey:@"picture"];
    } else {
        [parameters setObject:self.imgURL forKey:@"picture"];
    }
    
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
//        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//        [SVProgressHUD setBackgroundColor:BackgroundColor]; //背景颜色
//        [SVProgressHUD setForegroundColor:GlobalFontColor]; //字体颜色
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            //返回到根视图
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        });
        
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"提交成功";
        hud.label.textColor = [UIColor whiteColor];//字体颜色

        //用延迟来移除提示框
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //返回到根视图
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
        //开始交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //开始交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    }];
    
    
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
    
    self.iconImg.image = self.iconImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self performSelector:@selector(saveImage:) withObject:self.iconImage afterDelay:0.5];
    
}

#pragma mark - 上传图片的方法
- (void)saveImage:(UIImage *)image {
    
    [SVUserManager loadUserInfo];
    
    //    NSString *host_url = @"http://api.decerp.cc";
    
    NSString *loadImage_path = @"/system/UploadImg";
    
    //    NSString *urlStr= [host_url stringByAppendingFormat:@"%@?key=%@",loadImage_path,[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在压缩图片"];
    
    NSString *urlStr= [URLHeadPicture stringByAppendingFormat:@"%@?key=%@",loadImage_path,[SVUserManager shareInstance].access_token];
    
    //  NSData *newIMGData = [self resetSizeOfImageData:image maxSize:30];
    
  //NSData *newIMGData = [image bb_compressWithMaxLength:50 sizeMultiple:0];
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
                self.imgURL = [self changeImagePath:dic[@"values"]];
                NSLog(@"self.imgURL = %@",self.imgURL);
            }
            
            
        } else {
            
            //            [SVProgressHUD showErrorWithStatus:@"图片保存失败"];
            //            //用延迟来移除提示框
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [SVProgressHUD dismiss];
            //            });
            
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


@end
