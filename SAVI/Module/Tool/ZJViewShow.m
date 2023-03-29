//
//  ZJViewShow.m
//  test1222
//
//  Created by mac on 16/12/23.
//  Copyright © 2016年 zhangjian. All rights reserved.
//

#import "ZJViewShow.h"
@interface ZJViewShow (){
    BOOL animating;
    UIView *bgView;
    UIView *bg1;
    UIImageView *bgImageView1;
    UIImageView *bgImageView2;
}

@property (nonatomic, strong) UIView  *contentView;

@end

@implementation ZJViewShow


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutAllSubviews];
    }
    return self;
}

- (void)layoutAllSubviews{
    
  //  self.backgroundColor = [UIColor lightGrayColor];
//    self.alpha = 0.6;
    /*创建灰色背景*/
    UIView *bgViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    bgViews.alpha = 0.6;
    bgViews.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgViews];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake((ScreenW - 100- 61 - 10 * 3) / 2, ScreenH / 2 -80, 191, 81)];
    [self addSubview:bgView];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:bgView.frame];
    bgImageView.image = [UIImage imageNamed:@"d.png"];
    [self addSubview:bgImageView];
    
   
    
    bg1 = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 61, 61)];
    [bgImageView addSubview:bg1];
    
    bgImageView1 = [[UIImageView alloc] initWithFrame:bg1.frame];
    bgImageView1.image = [UIImage imageNamed:@"c1.png"];
    [bgImageView addSubview:bgImageView1];
    
    bgImageView2 = [[UIImageView alloc] initWithFrame:bg1.frame];
    bgImageView2.image = [UIImage imageNamed:@"c.png"];
    [bgImageView addSubview:bgImageView2];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(bgImageView1.frame.origin.x + 61 +20 , 10, 100, 61)];
    [label setFont:[UIFont systemFontOfSize:17]];
    [SVUserManager loadUserInfo];
    NSString *tips = [SVUserManager shareInstance].Tips;
    if ([tips containsString:@"退款中"]) {
        label.text = @"退款中。。。";
    }else{
        label.text = @"支付中。。。";
    }
   
    [bgImageView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       [btn setImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissContactView:) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview:btn];
       
       [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.width.mas_equalTo(30);
           make.height.mas_equalTo(30);
           make.top.mas_equalTo(bgImageView.mas_top);
           make.right.mas_equalTo(bgImageView.mas_right);
       }];

    [self startRotate];
   // [[UIApplication sharedApplication].keyWindow addSubview:self];
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(200, 100, 60, 30)];
//    button.backgroundColor = [UIColor redColor];
//    [button setTitle:@"开始" forState:UIControlStateNormal];
//    [self addSubview:button];
//    [button addTarget:self action:@selector(startRotate) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 60, 30)];
//    button1.backgroundColor = [UIColor redColor];
//    [self addSubview:button1];
//    [button1 setTitle:@"停止" forState:UIControlStateNormal];
//    [button1 addTarget:self action:@selector(dismissContactView:) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void) rotateWithOptions: (UIViewAnimationOptions) options {
    
    [UIView animateWithDuration: 0.125f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         bgImageView2.transform = CGAffineTransformRotate(bgImageView2.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 
                                 [self rotateWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 
                                 [self rotateWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startRotate {
    if (!animating) {
        animating = YES;
        [self rotateWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopRotate{
    
    animating = NO;
}

#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UIButton *)tapGesture{
    if (self.selectCancleBlock) {
            self.selectCancleBlock();
        }
//    if ([self.delegate respondsToSelector:@selector(selectCancleBtnClick)]) {
//        [self.delegate selectCancleBtnClick];
//    }
    [self dismissContactView];
}
-(void)dismissContactView
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
       
        [weakSelf stopRotate];
        [weakSelf removeFromSuperview];
      
    }];
    
}

// 这里加载在了window上
-(void)showView
{
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(ZJProgressHUDCompletionBlock)completion{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    [self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
    
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
     completionBlock:(ZJProgressHUDCompletionBlock)completion {
    self.taskInProgress = YES;
    self.completionBlock = completion;
    dispatch_async(queue, ^(void) {
        block();
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self cleanUp];
        });
    });
//    [self show:animated];
    [self startRotate];
}

- (void)cleanUp {
    self.taskInProgress = NO;
    [self dismissContactView];
}











@end
