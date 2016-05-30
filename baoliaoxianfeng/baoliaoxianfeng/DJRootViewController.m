//
//  DJRootViewController.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJRootViewController.h"
//#import "Masonry.h"
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
    DJTextDisplay* textDis = [[DJTextDisplay alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:textDis];
    self.view.backgroundColor = [UIColor redColor];
    
//    [textDis makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(textDis.superview).with.insets(UIEdgeInsetsZero);
//    }];
    
    DJCTFrameParserConfig* config = [DJCTFrameParserConfig new];
    config.textColor = [UIColor greenColor];
    config.width = textDis.frame.size.width;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dummyJSON" ofType:@""];
    DJCoreTextData *data = [DJCTFrameParser parseTemplateFile:path config:config];
    
    textDis.data = data;
    textDis.height = data.height;
    textDis.backgroundColor = [UIColor yellowColor];
    
    
}

@end
