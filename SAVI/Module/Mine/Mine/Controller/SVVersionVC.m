//
//  SVVersionVC.m
//  SAVI
//
//  Created by Sorgle on 2017/10/24.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVVersionVC.h"

#define OLDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface SVVersionVC ()
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SVVersionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"版本信息";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"版本信息";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    [SVUserManager loadUserInfo];
    self.oneLabel.text = [NSString stringWithFormat:@"德客-%@",[SVUserManager shareInstance].sv_versionname];
    //App内info.plist文件里面版本号
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = infoDict[@"CFBundleShortVersionString"];
    self.twoLabel.text = [NSString stringWithFormat:@"App版本v%@",appVersion];
    
    //更新提示
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/CN/lookup?id=%@",APPID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( [data length] > 0 && !error ) {
            // Success
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                /**
                 *  以上网络请求可以改成自己封装的类
                 */
                if(![versionsInAppStore count]) {
                    //请求到的版本数据不对就走这里
                    return;
                }
                else {
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    
                    if ([self versionlessthan:OLDVERSION Newer:currentAppStoreVersion])//[GetUserDefaut isKindOfClass:[NSString class]] && GetUserDefaut ? GetUserDefaut :
                    {
                        //版本号相同就走这里
                        self.label.text = @"当前已是最新版本";
                        
                        
                    }
                    else{
                        //提示更新的走这里
                        
                        self.label.text = [NSString stringWithFormat:@"可更新%@版本",currentAppStoreVersion];
                        
                        UIButton *button = [[UIButton alloc]init];
                        [button setTitle:@"更新" forState:UIControlStateNormal];
                        [button setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                        button.layer.cornerRadius = 6;
                        button.layer.borderColor = navigationBackgroundColor.CGColor;
                        button.layer.borderWidth = 0.5f;
                        button.layer.masksToBounds = YES;
                        [button addTarget:self action:@selector(goToAppStore) forControlEvents:UIControlEventTouchUpInside];
                        [self.view addSubview:button];
                        [button mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(75, 30));
                            make.centerX.mas_equalTo(self.label.mas_centerX);
                            make.top.mas_equalTo(self.label.mas_bottom).offset(10);
                        }];

//                        UILabel *label = [[UILabel alloc]init];
//                        label.text = @"企业爱心公厕";
//                        label.textColor = navigationBackgroundColor;
//                        label.textAlignment = NSTextAlignmentCenter;
//                        label.font = [UIFont systemFontOfSize:13];
//                        label.layer.cornerRadius = 15;
//                        label.layer.borderColor = navigationBackgroundColor.CGColor;
//                        label.layer.borderWidth = 0.5f;
//                        label.layer.masksToBounds = YES;
//                        [self.view addSubview:label];
//                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                            make.size.mas_equalTo(CGSizeMake(110, 30));
//                            make.centerX.mas_equalTo(self.label.mas_centerX);
//                            make.top.mas_equalTo(self.label.mas_bottom).offset(10);
//                        }];
                        
                        
                    }
                }
                
            });
        }
        
    }];
    
}

- (BOOL)versionlessthan:(NSString *)oldOne Newer:(NSString *)newver
{
    if ([oldOne isEqualToString:newver]) {
        return YES;
    }else{
        if ([oldOne compare:newver options:NSNumericSearch] == NSOrderedDescending)
        {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

-(void)goToAppStore {
    
    NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/de-ke/id%@?mt=8",APPID];
    //跳转到AppStore，该App下载界面
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    
}

@end
