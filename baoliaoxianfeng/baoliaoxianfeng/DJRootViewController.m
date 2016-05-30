//
//  DJRootViewController.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJRootViewController.h"
#import "Masonry.h"
#import "DJTextDisplay.h"
#import "DJCTFrameParserConfig.h"
#import "DJCTFrameParser.h"

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
    DJTextDisplay* textDis = [[DJTextDisplay alloc]init];
    [self.view addSubview:textDis];
    self.view.backgroundColor = [UIColor redColor];
    
    [textDis makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textDis.superview).with.offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(textDis.superview).with.offset(0);
        make.right.equalTo(textDis.superview).with.offset(0);
    }];
    
    DJCTFrameParserConfig* config = [[DJCTFrameParserConfig alloc]init];
    config.textColor = [UIColor greenColor];
    config.width = self.view.frame.size.width;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dummyJSON" ofType:@""];
    DJCoreTextData *data = [DJCTFrameParser parseTemplateFile:path config:config];
    textDis.data = data;

    textDis.backgroundColor = [UIColor yellowColor];
}

@end
