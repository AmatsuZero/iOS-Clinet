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

@interface DJRootViewController ()

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
    textDis.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:textDis];
    self.view.backgroundColor = [UIColor whiteColor];
    [textDis makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textDis.superview).with.offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(textDis.superview).with.offset(0);
        make.right.equalTo(textDis.superview).with.offset(0);
        make.bottom.equalTo(textDis.superview).with.offset(0);
    }];
    
}

@end
