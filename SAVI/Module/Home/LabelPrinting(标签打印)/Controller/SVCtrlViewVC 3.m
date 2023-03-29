//
//  SVCtrlViewVC.m
//  SAVI
//
//  Created by houming Wang on 2018/10/11.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVCtrlViewVC.h"
#import "BluetoothListViewController.h"
#import "TscCommand.h"
@interface SVCtrlViewVC ()
@property (weak, nonatomic) IBOutlet UILabel *ConnState;

@end

@implementation SVCtrlViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)bluetoothClick:(id)sender {
    BluetoothListViewController *vc = [[BluetoothListViewController alloc] init];
    vc.state = ^(ConnectState state) {
        [self updateConnectState:state];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)labelClick:(id)sender {
    
    [Manager write:[self tscCommand]];
}

// 我看这里是标签打印的方法了
-(NSData *)tscCommand{
    TscCommand *command = [[TscCommand alloc]init];
    [command addSize:40 :30];
    [command addGapWithM:2 withN:0];
    [command addReference:0 :0];
    [command addTear:@"ON"];
    [command addQueryPrinterStatus:ON];
    [command addCls];
    [command addTextwithX:30 withY:10 withFont:@"TSS24.BF2" withRotation:0 withXscal:1.3 withYscal:1 withText:@"kaks"];
    [command addTextwithX:30 withY:40 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:@"货号：45645646"];
    [command add1DBarcode:30 :70 :@"CODE128" :80 :1 :0 :2 :2 :@"12345657"];
    [command addTextwithX:30 withY:190 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:@"XXXL,蓝色"];
    [command addTextwithX:150 withY:190 withFont:@"TSS24.BF2" withRotation:0 withXscal:1 withYscal:1 withText:[NSString stringWithFormat:@"￥%@",@"54345"]];
    // [command addQRCode:20 :160 :@"L" :5 :@"A" :0 :@"www.smarnet.cc"];
    // UIImage *image = [UIImage imageNamed:@"gprinter.png"];
    //[command addBitmapwithX:0 withY:260 withMode:0 withWidth:400 withImage:image];
    [command addPrint:1 :1];
    return [command getCommand];
}


-(void)updateConnectState:(ConnectState)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case CONNECT_STATE_CONNECTING:
                self.ConnState.text = @"连接状态：连接中....";
                break;
            case CONNECT_STATE_CONNECTED:
//                [SVProgressHUD showSuccessWithStatus:@"连接成功"];
                self.ConnState.text = @"连接状态：已连接";
                break;
            case CONNECT_STATE_FAILT:
                //[SVProgressHUD showErrorWithStatus:@"连接失败"];
                self.ConnState.text = @"连接状态：连接失败";
                break;
            case CONNECT_STATE_DISCONNECT:
               // [SVProgressHUD showInfoWithStatus:@"断开连接"];
                self.ConnState.text = @"连接状态：断开连接";
                break;
            default:
                self.ConnState.text = @"连接状态：连接超时";
                break;
        }
    });
}
- (IBAction)duankaiClick:(id)sender {
    [Manager close];
}
@end
