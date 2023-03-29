//
//  SVInfoNotice.m
//  SAVI
//
//  Created by F on 2020/11/6.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVInfoNotice.h"
#import "DWSegmentedControl.h"

@interface SVInfoNotice ()<DWSegmentedControlDelegate>

@end

@implementation SVInfoNotice

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    DWSegmentedControl *test = [[DWSegmentedControl alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-60, 40)];
    test.backgroundColor = [UIColor whiteColor];
    test.selectedViewColor = navigationBackgroundColor;
    test.normalLabelColor = navigationBackgroundColor;
    test.delegate = self;
    test.titles = @[@"系统通知",@"更新日志"];
    [self.view  addSubview:test];
}

-(void)dw_segmentedControl:(DWSegmentedControl *)control didSeletRow:(NSInteger)row{
    
    NSLog(@"你选择了第%ld个",row);
//    self.OriginalpriceLabel.hidden = YES;
//    self.disCountLabel.hidden = NO;
//    self.selectNumber = row;
    
}

- (void)loadData{
    
}



@end
