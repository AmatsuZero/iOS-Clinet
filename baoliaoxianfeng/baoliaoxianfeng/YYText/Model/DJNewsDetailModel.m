//
//  DJNewsDetailModel.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJNewsDetailModel.h"
#import "DJAPPUtility.h"

@implementation DJNewsDetailModel

-(instancetype)initWithDict:(NSDictionary*)dic
{
    if (self = [super init]) {
        _size = [dic[@"type"] integerValue];
        _url = dic[@"url"];
        _size = [dic[@"size"] floatValue];
        _width = [dic[@"width"] floatValue];
        _height = [dic[@"height"] floatValue];
        _color = [DJAPPUtility convertToColorType:dic[@"color"]];
        _content = dic[@"content"];
        _type = [dic[@"type"] integerValue];
    }
    return self;
}

#pragma mark -- 重写图片宽度和高度的getter方法，防止没有值不显示
-(CGFloat)width{
    if (_width==0) {
        _width = [UIScreen mainScreen].bounds.size.width - 20.0*2;
    }
    return _width;
}

-(CGFloat)height
{
    if (_height == 0) {
        _height = 100;
    }
    return _height;
}

@end
