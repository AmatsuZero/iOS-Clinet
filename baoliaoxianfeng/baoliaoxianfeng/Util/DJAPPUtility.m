//
//  DJAPPUtility.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJAPPUtility.h"
#import "UIColor+YYAdd.h"

@implementation DJAPPUtility

+(UIColor*)convertToColorType:(NSString*)color
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
    } else if ([color isEqualToString:@"white"]){
        return [UIColor whiteColor];
    } else if ([color isEqualToString:@"brown"]){
        return [UIColor brownColor];
    } else if ([color isEqualToString:@"lightText"]){
        return [UIColor lightTextColor];
    } else if ([color isEqualToString:@"lightGray"]){
        return [UIColor lightGrayColor];
    } else if ([color isEqualToString:@"cyan"]){
        return [UIColor cyanColor];
    } else if ([color isEqualToString:@"magenta"]){
        return [UIColor magentaColor];
    }
    else {//传入为16进制颜色
        return [UIColor colorWithHexString:color];
    }
}

+(NSString *)convertToDescriptionStr:(NSString *)rgbColorSapce
{
    //字符串大致都是这种类型的：“UIDeviceRGBColorSpace 0 0 1 1”
    NSNumber* zero = [NSNumber numberWithFloat:0.0];
    NSNumber* one = [NSNumber numberWithFloat:1.0];
    NSArray* colorDes = [rgbColorSapce componentsSeparatedByString:@" "];
    NSNumber* red,*green,*blue,*alpha;
    if (colorDes.count<5) {//black，darkGray，lightGray，white，gray
        red = [NSNumber numberWithFloat:[colorDes[1] floatValue]];
        if ([red isEqualToNumber:zero]) {
            return @"black";
        } else if ([red isEqualToNumber:[NSNumber numberWithFloat:0.333333]]){
            return @"darkGray";
        } else if ([red isEqualToNumber:[NSNumber numberWithFloat:0.666667]]){
            return @"lightGray";
        } else if ([red isEqualToNumber:one]){
            return @"white";
        } else if ([red isEqualToNumber:[NSNumber numberWithFloat:0.5]]){
            return @"gray";
        }
    } else {//red,green,blue,cyan,yellow,orange,purple,brown,magenta
        red = @([colorDes[1] floatValue]);
        green = @([colorDes[2] floatValue]);
        blue = @([colorDes[3] floatValue]);
        alpha = @([colorDes[4] floatValue]);
        if ([red isEqualToNumber:one]&&[green isEqualToNumber:zero]&&[blue isEqualToNumber:zero]&&[alpha isEqualToNumber:one]) {
            return @"red";
        } else if ([red isEqualToNumber:one]&&[green isEqualToNumber:zero]&&[blue isEqualToNumber:zero]&&[alpha isEqualToNumber:one]){
            return @"green";
        } else if ([red isEqualToNumber:zero]&&[green isEqualToNumber:zero]&&[blue isEqualToNumber:one]&&[alpha isEqualToNumber:one]){
            return @"blue";
        } else if ([red isEqualToNumber:zero]&&[green isEqualToNumber:one]&&[blue isEqualToNumber:zero]&&[alpha isEqualToNumber:one]){
            return @"cyan";
        } else if ([red isEqualToNumber:one]&&[green isEqualToNumber:one]&&[blue isEqualToNumber:zero]&&[alpha isEqualToNumber:one]){
            return @"yellow";
        } else if ([red isEqualToNumber:one]&&[green isEqualToNumber:zero]&&[blue isEqualToNumber:one]&&[alpha isEqualToNumber:one]){
            return @"magenta";
        } else if ([red isEqualToNumber:one]&&[green isEqualToNumber:[NSNumber numberWithFloat:0.5]]&&[blue isEqualToNumber:zero]&&[alpha isEqualToNumber:one]){
            return @"orange";
        } else if ([red isEqualToNumber:[NSNumber numberWithFloat:0.5]]&&[green isEqualToNumber:zero]&&[blue isEqualToNumber:[NSNumber numberWithFloat:0.5]]&&[alpha isEqualToNumber:one]){
            return @"purple";
        } else if ([red isEqualToNumber:[NSNumber numberWithFloat:0.6]]&&[green isEqualToNumber:[NSNumber numberWithFloat:0.4]]&&[blue isEqualToNumber:[NSNumber numberWithFloat:0.2]]&&[alpha isEqualToNumber:one]){
            return @"brown";
        }
    }
    
    uint32_t hexColor = [[UIColor colorWithRed:red.floatValue green:green.floatValue blue:blue.floatValue alpha:alpha.floatValue] rgbValue];
    
    return [NSString stringWithFormat:@"%@",@(hexColor)];
}

@end
