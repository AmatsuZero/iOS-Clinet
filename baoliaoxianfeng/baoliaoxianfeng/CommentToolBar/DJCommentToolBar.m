//
//  DJCommentToolBar.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/3.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJCommentToolBar.h"
#import "Masonry.h"
#import "YYText.h"

@interface DJCommentToolBar ()<YYTextViewDelegate>

@property(nonatomic,strong)YYTextView* commentArea;//评论编辑
@property(nonatomic,strong)UIButton* sendButton;//发送按钮

@end

@implementation DJCommentToolBar

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        
        _commentArea = [[YYTextView alloc]init];
        _commentArea.placeholderText = @"Tap to Edit";
        _commentArea.placeholderTextColor = [UIColor orangeColor];
        _commentArea.backgroundColor = [UIColor whiteColor];
        _commentArea.delegate = self;
        _commentArea.layer.cornerRadius = 10;
        _commentArea.clipsToBounds = YES;
        [self addSubview:_commentArea];
        
        _sendButton = [[UIButton alloc]init];
        [_sendButton setBackgroundColor:[UIColor blueColor]];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.clipsToBounds = YES;
        [self addSubview:_sendButton];
        
        CGFloat padding = 8;//边距
        CGFloat gapping = 6;//文本框与按钮之间的间距
        CGFloat height = 60-2*padding;//按钮高度
        
        [_commentArea makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(padding);
            make.right.equalTo(_sendButton.mas_left).with.offset(-gapping);
            make.height.equalTo(_sendButton);
        }];
        
        CGFloat buttonWidth = [_sendButton.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_sendButton.titleLabel.font,NSForegroundColorAttributeName:_sendButton.titleLabel.textColor} context:nil].size.width+ 5*2;
        
        [_sendButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.equalTo(_commentArea.mas_right).with.offset(gapping);
            make.right.equalTo(self.mas_right).with.offset(-padding);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(buttonWidth);
        }];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboarWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
#pragma mark -- 发送事件
-(void)sendComment:(UIButton*)sender
{
    [self.commentArea resignFirstResponder];
}
#pragma mark -- 键盘弹出与隐藏事件处理
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
