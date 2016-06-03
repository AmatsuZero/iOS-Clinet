//
//  DJRootViewController.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJRootViewController.h"
#import "Masonry.h"
#import "DJNewsDetailView.h"
#import <SafariServices/SafariServices.h>
#import "DJCommentToolBar.h"
#import "DJContentEditor.h"

@interface DJRootViewController ()<DJNewsContentMgrDelegate>

@end

@implementation DJRootViewController

static DJRootViewController* this;

+(instancetype)getStandardRootVC
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc]init];
    });
    return this;
}

-(void)viewDidLoad
{

    DJNewsDetailView* textDis = [[DJNewsDetailView alloc]init];
    textDis.mgr.delegate = self;//成为内容事件的代理
    textDis.backgroundColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textDis];
    
    [textDis makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textDis.superview).with.offset(0);
        make.left.equalTo(textDis.superview).with.offset(0);
        make.right.equalTo(textDis.superview).with.offset(0);
        make.bottom.equalTo(textDis.superview).with.offset(0);
    }];
    
    DJCommentToolBar* toolBar = [[DJCommentToolBar alloc]init];
    [self.view addSubview:toolBar];
    [toolBar makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toolBar.superview).with.offset(0);
        make.left.equalTo(toolBar.superview).with.offset(0);
        make.bottom.equalTo(toolBar.superview).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNews:)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark -- 新闻内容事件代理
-(void)contentMgr:(DJNewsContentMgr *)mgr openLink:(NSURL *)link
{
    debugLog(@"点击了超链 %@",link);
    SFSafariViewController* sfvc = [[SFSafariViewController alloc]initWithURL:link];
    [self presentViewController:sfvc animated:YES completion:^{
        
    }];
}

-(void)contentMgr:(DJNewsContentMgr *)mgr ViewImg:(UIImage *)img
{
    debugLog(@"点击了图片 %@",img);
}

#pragma mark -- 跳转至创建内容
-(void)createNews:(UIBarButtonItem*)sender
{
    DJContentEditor* vc = [DJContentEditor new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
