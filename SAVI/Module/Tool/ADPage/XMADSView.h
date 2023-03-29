//
//  XMADSView.h
//  XMFilmTelevision
//
//  Created by sfk-ios on 2018/10/8.
//  Copyright © 2018年 aiq西米. All rights reserved.
//
//  广告View
//

#import <UIKit/UIKit.h>

@interface XMADSView : UIView
@property (strong, nonatomic) UIWindow *window;
+ (instancetype)adsView;
/// img
@property (copy, nonatomic) NSString *imgUrl;
/// 跳转的链接
@property (copy, nonatomic) NSString *url;
@property (nonatomic,strong) NSString *kGetAuthCodeMaxTimeInterval;

- (void)dismiss;
@end
