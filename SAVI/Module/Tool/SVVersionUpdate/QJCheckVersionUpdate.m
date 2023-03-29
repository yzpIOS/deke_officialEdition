//
//  QJCheckVersionUpdate.m
//  QJVersionUpdateView
//
//  Created by Justin on 16/3/8.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "QJCheckVersionUpdate.h"
#import "QJVersionUpdateVIew.h"
#import "NSObject+wxh.h"

#define GetUserDefaut [[NSUserDefaults standardUserDefaults] objectForKey:@"VersionUpdateNotice"]
#define OLDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//#define APPID  @"1128257396"


@implementation QJCheckVersionUpdate{
    
    QJVersionUpdateVIew *versionUpdateView;
}

/**
 *  demo
 */
//+ (void)CheckVerion:(UpdateBlock)updateblock
//{
//    NSString *currentAppStoreVersion = @"5.0.0";
//    if ([QJCheckVersionUpdate versionlessthan:[GetUserDefaut isKindOfClass:[NSString class]] && GetUserDefaut ? GetUserDefaut : OLDVERSION Newer:currentAppStoreVersion])
//    {
//        NSLog(@"暂不更新");
//    }else{
//        NSLog(@"请到appstore更新%@版本",currentAppStoreVersion);
//         NSString *describeStr = @"1.修正了部分单词页面空白的问题修正了部分单词页面空白的问题\n2.修正了部分单词页面空白的问题去够呛够呛\n3.修正了部分单词页面空白的问题";
//        NSLog(@"修复问题描述:%@",describeStr);
//        NSArray *dataArr = [QJCheckVersionUpdate separateToRow:describeStr];
//        if (updateblock) {
//            updateblock(currentAppStoreVersion,dataArr);
//        }
//    }
//}

/**
 *  正式
 */

+ (void)CheckVerion:(UpdateBlock)updateblock
{
    //http://itunes.apple.com/CN/lookup?id=1128257396
    //http://itunes.apple.com/lookup?id=1234441733
    
    NSString *storeString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",APPID];
//    storeString = [storeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ( [data length] > 0 && !error ) {
            // Success
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"appData = %@",appData);
            dispatch_async(dispatch_get_main_queue(), ^{
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                NSLog(@"versionsInAppStore = %@",versionsInAppStore);
                /**
                 *  以上网络请求可以改成自己封装的类
                 */
                if(![versionsInAppStore count]) {
                    //请求到的版本数据不对就走这里
                    //NSLog(@"No versions of app in AppStore -- 在AppStore中没有应用程序版本");
                    return;
                }else {
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];

                    [SVUserManager loadUserInfo];
                    //旧版本
                    [SVUserManager shareInstance].sv_oldVersion = OLDVERSION;
                    //新版本
                    [SVUserManager shareInstance].sv_newVersion = currentAppStoreVersion;
                    [SVUserManager saveUserInfo];
                    
                    if ([QJCheckVersionUpdate versionlessthan:OLDVERSION Newer:currentAppStoreVersion])//[GetUserDefaut isKindOfClass:[NSString class]] && GetUserDefaut ? GetUserDefaut :
                    {
                        //版本号相同就走这里
                        //NSLog(@"暂不更新");
                    }else{
                        //提示更新的走这里
                      //  NSLog(@"请到appstore更新%@版本",currentAppStoreVersion);
                        /**
                         *  修复问题描述
                         */
                        [NSObject saveObj:@"YES" withKey:@"isNotFirstIn"];
                        NSString *describeStr = [[[appData valueForKey:@"results"] valueForKey:@"releaseNotes"] objectAtIndex:0];
                        NSArray *dataArr = [QJCheckVersionUpdate separateToRow:describeStr];
                        if (updateblock) {
                            updateblock(currentAppStoreVersion,dataArr);
                        }
                    }
                }
                
            });
        }
        
    }];
}


+ (BOOL)versionlessthan:(NSString *)oldOne Newer:(NSString *)newver
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


+ (NSArray *)separateToRow:(NSString *)describe
{
    NSArray *array= [describe componentsSeparatedByString:@"\n"];
    return array;
}

- (void)showAlertView
{
    __weak typeof(self) weakself = self;
    [QJCheckVersionUpdate CheckVerion:^(NSString *str, NSArray *DataArr) {
        if (!versionUpdateView) {
            __strong typeof(self) strongself = weakself;
            versionUpdateView = [[QJVersionUpdateVIew alloc] initWith:[NSString stringWithFormat:@"版本:%@",str] Describe:DataArr];
            versionUpdateView.GoTOAppstoreBlock = ^{
                [strongself goToAppStore];
            };
            versionUpdateView.removeUpdateViewBlock = ^{
                [strongself removeVersionUpdateView];
            };
//            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"VersionUpdateNotice"];
        }
    }];
}

- (void)removeVersionUpdateView
{
    [versionUpdateView removeFromSuperview];
    versionUpdateView = nil;
}

- (void)goToAppStore
{
    NSString *urlStr = [self getAppStroeUrlForiPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
- (NSString *)getAppStroeUrlForiPhone{
    //https://itunes.apple.com/cn/app/kai-qi-cai-fu/id1234441733?l=zh&ls=1&mt=8
    //https://itunes.apple.com/cn/app/%E5%BE%B7%E5%AE%A2/id1128257396?mt=8
    //https://itunes.apple.com/cn/app/de-ke/id1450906704?mt=8
    //这个链接是在电脑的iTunes Store搜索到的。要将 %E5%BE%B7%E5%AE%A2 改变为 de-ke（即App的拼音）
    return [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/de-ke/id%@?mt=8",APPID];
}

@end
