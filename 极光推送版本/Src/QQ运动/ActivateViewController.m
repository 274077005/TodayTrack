//
//  ActivateViewController.m
//  极光推送版本
//
//  Created by SoKing on 2017/12/9.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import "ActivateViewController.h"

@interface ActivateViewController ()
- (IBAction)btnImageSave:(id)sender;

@end

@implementation ActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnImageSave:(id)sender {
    UIButton *btn=sender;
    NSInteger tag=btn.tag;
    switch (tag) {
        case 1:
            {
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"是否保存图片到相册" message:nil preferredStyle:1];
                UIAlertAction *cancal=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self loadImageFinished:[UIImage imageNamed:@"weixin"]];
                }];
                
                [alert addAction:cancal];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }
            break;
        case 2:
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"是否保存图片到相册" message:nil preferredStyle:1];
            UIAlertAction *cancal=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self loadImageFinished:[UIImage imageNamed:@"zhifubao"]];
            }];
            
            [alert addAction:cancal];
            [alert addAction:sure];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

@end
