//
//  CityPickerViewController.h
//  CityPicker
//
//  Created by odier on 2016/10/28.
//  Copyright © 2016年 Skyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityPickerViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

typedef void (^getSelectCity) (NSMutableDictionary *dicSelectCity);
@property (nonatomic,weak) getSelectCity getSelectCity;



/*设置显示半透明状态
 //设置模式展示风格
 [CityPicker setModalPresentationStyle:UIModalPresentationOverCurrentContext];
 //必要配置
 self.modalPresentationStyle = UIModalPresentationCurrentContext;
 self.providesPresentationContextTransitionStyle = YES;
 self.definesPresentationContext = YES;
 */
@property NSArray *arrProvince;
@property NSArray *arrCity;
@property NSArray *arrDistrict;
@property NSMutableDictionary *dicSelectCityAndCityCode;

@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSelectShow;

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSure:(id)sender;
/*block获取选择的城市的信息
 */
- (void)cityPikerGetSelectCity:(getSelectCity)getSelectCity;

@end
