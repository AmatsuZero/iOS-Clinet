//
//  DJAPPUtility.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/27.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJAPPUtility.h"

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
        return [DJAPPUtility colorWithHexString:color];
    }
}

//+(UIColor *) getColor:(NSString *)hexColor
//{
//    unsigned int red, green, blue,alpha;
//    NSRange range;
//    range.length =2;
//    range.location =0;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
//    range.location =2;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
//    range.location =4;
//    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
//    if (hexColor.length>6) {//长度大于6，说明有Alpha值
//        range.location = 6;
//        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&alpha];
//    } else {
//        alpha = 1;
//    }
//    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f) alpha:(float)(alpha/255.0f)];
//}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHexString:color alpha:1.0f];
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
    
    NSString* hexColor = [NSString stringWithFormat:@"%d",rgb([red intValue], [green intValue], [blue intValue])];//十六进制颜色，没有alpha
    
    return hexColor;
}

int rgb(int r,int g,int b)
{
    return r << 16 | g << 8 | b;
}

@end
