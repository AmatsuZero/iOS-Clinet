//
//  DJContentEditor.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/3.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJContentEditor.h"
#import "DJEditorToolBar.h"
#import "Masonry.h"
#import "DJNewsEditor.h"

#define TOOLBAR_HEIGHT 60

@interface DJContentEditor ()

@property(nonatomic,strong)DJEditorToolBar* toolBar;
@property(nonatomic,strong)DJNewsEditor* textView;
@property(nonatomic,assign)BOOL isShowToolBar;

@end

@implementation DJContentEditor

-(DJEditorToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[DJEditorToolBar alloc]init];
        [self.view addSubview:_toolBar];
        _toolBar.barStyle = UIBarStyleBlackTranslucent;
        _toolBar.backgroundColor = [UIColor greenColor];
        [_toolBar makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.height.mas_equalTo(TOOLBAR_HEIGHT);
        }];
    }
    return _toolBar;
}

-(YYTextView *)textView
{
    if (!_textView) {
        _textView = [[DJNewsEditor alloc]init];
        _textView.font = [UIFont systemFontOfSize:30];
        [self.view addSubview:_textView];
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.bottom.equalTo(self.toolBar.top).with.offset(0);
        }];
    }
    return _textView;
}

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor brownColor];
    self.title = @"编辑新闻";
    self.isShowToolBar = YES;
    [self.textView becomeFirstResponder];
}


@end
