//
//  SVBigClassView.h
//  SAVI
//
//  Created by Sorgle on 17/5/11.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVBigClassView : UIView

@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;


@property (weak, nonatomic) IBOutlet UIButton *bigCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *bigDetermineButton;

@property (weak, nonatomic) IBOutlet UITextField *bigClassName;

@end
