//
//  DJEditorToolBar.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/3.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJEditorToolBar.h"
#import "Masonry.h"

@implementation DJEditorToolBar

-(instancetype)init
{
    if (self = [super init]) {
        UIBarButtonItem* itme1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(testAction1:)];
        UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(testAction2:)];
        UIBarButtonItem* item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(testAction3:)];
        UIBarButtonItem* item4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(testAction4:)];
        UIBarButtonItem* stick = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.items = @[stick,itme1,stick,item2,stick,item3,stick,item4,stick];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark -- 测试事件
-(void)testAction1:(UIBarButtonItem*)sender
{

}
-(void)testAction2:(UIBarButtonItem*)sender
{

}
-(void)testAction3:(UIBarButtonItem*)sender
{

}
-(void)testAction4:(UIBarButtonItem*)sender
{

}

#pragma mark -- 键盘弹出与隐藏
-(void)keyboarWillShow:(NSNotification*)notification
{
    //获取键盘弹起后的frame
    CGRect keyboardFrame=[notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //获取键盘弹起时的动画选项
    UIViewAnimationOptions option=[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    //获取键盘弹起时的动画时长
    NSTimeInterval duration=[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardFrame.size.height);
    }];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    //获取键盘弹起时的动画选项
    UIViewAnimationOptions option=[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]intValue];
    //获取键盘弹起时的动画时长
    NSTimeInterval duration=[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

@end
