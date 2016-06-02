//
//  DJNewsDetailModel.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJNewsDetailModel.h"

@implementation DJNewsDetailModel

-(instancetype)initWithDict:(NSDictionary*)dic
{
    if (self = [super init]) {
        _size = [dic[@"type"] integerValue];
        _url = dic[@"url"];
        _size = [dic[@"size"] floatValue];
        _width = [dic[@"width"] floatValue];
        _height = [dic[@"height"] floatValue];
        _color = [self convertToColorType:dic[@"color"]];
        _content = dic[@"content"];
        _type = [dic[@"type"] integerValue];
    }
    return self;
}

-(UIColor*)convertToColorType:(NSString*)color
{
        if ([color isEqualToString:@"red"]) {
            return [UIColor redColor];
        } else if ([color isEqualToString:@"black"]){
            return [UIColor blackColor];
        } else if ([color isEqualToString:@"blue"]){
            return [UIColor blueColor];
        } else if ([color isEqualToString:@"green"]){
            return [UIColor greenColor];
        } else if ([color isEqualToString:@"yellow"]){
            return [UIColor yellowColor];
        } else if ([color isEqualToString:@"orange"]){
            return [UIColor orangeColor];
        } else if ([color isEqualToString:@"gray"]){
            return [UIColor grayColor];
        } else if ([color isEqualToString:@"darkGray"]){
            return [UIColor darkGrayColor];
        } else if ([color isEqualToString:@"darkText"]){
            return [UIColor darkTextColor];
        } else if ([color isEqualToString:@"purple"]){
            return [UIColor purpleColor];
        }  else if ([color isEqualToString:@"default"]){//默认颜色为黑色
            return [UIColor blackColor];
        } else if ([color isEqualToString:@"brown"]){
            return [UIColor brownColor];
        } else {//传入为16进制颜色
            return [self getColor:color];
        }
}

-(UIColor *) getColor:(NSString *)hexColor
{
    unsigned int red, green, blue,alpha;
    NSRange range;
    range.length =2;
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    if (hexColor.length>6) {//长度大于6，说明有Alpha值
        range.location = 6;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&alpha];
    } else {
        alpha = 1;
    }
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f) alpha:(float)(alpha/255.0f)];
}

@end
