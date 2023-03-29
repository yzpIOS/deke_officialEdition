//
//  SVBaseVC.h
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVBaseVC : UIViewController
/**
 *  根据storyboardName和storyboardID获取相应的视图控制器
 *
 *  @param sbName storyboardName
 *  @param sbId   storyboardID
 *
 *  @return 相应的视图控制器
 */-(UIViewController *)getViewControllerWithStoryboardName:(NSString *)sbName withStoryboardID:(NSString *)sbId;

@end
