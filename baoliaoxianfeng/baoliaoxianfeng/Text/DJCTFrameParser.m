//
//  DJCTFrameParser.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJCTFrameParser.h"
#import <CoreText/CoreText.h>

@implementation DJCTFrameParser

+ (NSDictionary *)attributesWithConfig:(DJCTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    UIColor * textColor = config.textColor;
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (DJCoreTextData *)parseContent:(NSString *)content config:(DJCTFrameParserConfig*)config {
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    // 创建 CTFramesetterRef 实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    // 生成 CTFrameRef 实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    // 将生成好的 CTFrameRef 实例和计算好的绘制高度保存到 CoreTextData 实例中，最后返回 CoreTextData 实例
    DJCoreTextData *data = [[DJCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    // 释放内存 CFRelease(frame);
    CFRelease(framesetter);
    return data;
}


+ (DJCoreTextData *)parseTemplateFile:(NSString *)path config:(DJCTFrameParserConfig*)config {
    NSAttributedString *content = [self loadTemplateFile:path config:config];
    return [self parseAttributedContent:content config:config];
}

//JSON解析，将JSON保存的文本格式转换成NSAttributedString
+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(DJCTFrameParserConfig*)config {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) { NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                }
            }
        }
    }
    return result;
}

// 将NSDictionary内容转换为NSAttributedString
+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict config:(DJCTFrameParserConfig*)config { NSMutableDictionary *attributes = [[self attributesWithConfig:config] mutableCopy];
    // set color
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // set font size
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

// 将NSString转为UIColor的功能
+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else {
        return nil;
    }
}
// 接受一个NSAttributedString和一个config参数，将NSAttributedString转换成CoreTextData返回
+ (DJCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(DJCTFrameParserConfig*)config { // 创建 CTFramesetterRef 实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    // 生成 CTFrameRef 实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    // 将生成好的 CTFrameRef 实例和计算好的缓制高度保存到 CoreTextData 实例中，最后返回 CoreTextData 实例
    DJCoreTextData *data = [[DJCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    // 释放内存 CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

// 计算frame
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(DJCTFrameParserConfig *)config height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

@end
