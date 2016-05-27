//
//  DJRootViewController.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJRootViewController.h"
#import "Masonry.h"

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
    self.view.backgroundColor = [UIColor greenColor];
    
}

@end
