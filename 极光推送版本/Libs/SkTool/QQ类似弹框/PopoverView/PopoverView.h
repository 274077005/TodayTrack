//
//  PopoverView.h
//  Popover
//
//  Created by lifution on 16/1/5.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverAction.h"

@interface PopoverView : UIView

@property (nonatomic, assign) BOOL hideAfterTouchOutside; ///< 是否开启点击外部隐藏弹窗, 默认为YES.
@property (nonatomic, assign) BOOL showShade; ///< 是否显示阴影, 如果为YES则弹窗背景为半透明的阴影层, 否则为透明, 默认为NO.
@property (nonatomic, assign) PopoverViewStyle style; ///< 弹出窗风格, 默认为 PopoverViewStyleDefault(白色).

+ (instancetype)popoverView;

/*! @brief 指向指定的View来显示弹窗
 *  @param pointView 箭头指向的View
 *  @param actions   动作对象集合<PopoverAction>
 */
- (void)showToView:(UIView *)pointView withActions:(NSArray<PopoverAction *> *)actions;

/*! @brief 指向指定的点来显示弹窗
 *  @param toPoint 箭头指向的点(这个点的坐标需按照keyWindow的坐标为参照)
 *  @param actions 动作对象集合<PopoverAction>
 */
- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<PopoverAction *> *)actions;


/*
 - (NSArray<PopoverAction *> *)QQActions {
 // 发起多人聊天 action
 PopoverAction *multichatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_multichat"] title:@"发起多人聊天" handler:^(PopoverAction *action) {
 #pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
 _noticeLabel.text = action.title;
 }];
 // 加好友 action
 PopoverAction *addFriAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_addFri"] title:@"加好友" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 // 扫一扫 action
 PopoverAction *QRAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_QR"] title:@"扫一扫" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 // 面对面快传 action
 PopoverAction *facetofaceAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_facetoface"] title:@"面对面快传" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 // 付款 action
 PopoverAction *payMoneyAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"right_menu_payMoney"] title:@"付款" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 
 return @[multichatAction, addFriAction, QRAction, facetofaceAction, payMoneyAction];
 }
 
 - (IBAction)buttonAction:(UIButton *)sender {
 PopoverView *popoverView = [PopoverView popoverView];
 [popoverView showToView:sender withActions:[self QQActions]];
 }
 
 - (IBAction)leftBarItemAction:(UIBarButtonItem *)sender {
 PopoverAction *action1 = [PopoverAction actionWithImage:[UIImage imageNamed:@"contacts_add_newmessage"] title:@"发起群聊" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 PopoverAction *action2 = [PopoverAction actionWithImage:[UIImage imageNamed:@"contacts_add_friend"] title:@"添加朋友" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 PopoverAction *action3 = [PopoverAction actionWithImage:[UIImage imageNamed:@"contacts_add_scan"] title:@"扫一扫" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 PopoverAction *action4 = [PopoverAction actionWithImage:[UIImage imageNamed:@"contacts_add_money"] title:@"收付款" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 
 PopoverView *popoverView = [PopoverView popoverView];
 popoverView.style = PopoverViewStyleDark;
 // 在没有系统控件的情况下调用可以使用显示在指定的点坐标的方法弹出菜单控件.
 [popoverView showToPoint:CGPointMake(20, 64) withActions:@[action1, action2, action3, action4]];
 }
 
 - (IBAction)rightButtonAction:(UIButton *)sender {
 PopoverView *popoverView = [PopoverView popoverView];
 popoverView.showShade = YES; // 显示阴影背景
 [popoverView showToView:sender withActions:[self QQActions]];
 }
 
 - (IBAction)showWithoutImage:(UIButton *)sender {
 // 不带图片
 PopoverAction *action1 = [PopoverAction actionWithTitle:@"加好友" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 PopoverAction *action2 = [PopoverAction actionWithTitle:@"扫一扫" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 PopoverAction *action3 = [PopoverAction actionWithTitle:@"发起聊天" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 PopoverAction *action4 = [PopoverAction actionWithTitle:@"发起群聊" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 PopoverAction *action5 = [PopoverAction actionWithTitle:@"查找群聊" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 PopoverAction *action6 = [PopoverAction actionWithTitle:@"我的群聊" handler:^(PopoverAction *action) {
 _noticeLabel.text = action.title;
 }];
 
 PopoverView *popoverView = [PopoverView popoverView];
 popoverView.style = PopoverViewStyleDark;
 popoverView.hideAfterTouchOutside = NO; // 点击外部时不允许隐藏
 [popoverView showToView:sender withActions:@[action1, action2, action3, action4, action5, action6]];
 }
 */
@end
