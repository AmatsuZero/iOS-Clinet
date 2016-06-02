//
//  SHNewsContentMgr.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJNewsContentMgr.h"
#import "DJNewsDetailModel.h"
#import "DJTextImg.h"
#import "NSAttributedString+YYText.h"

@interface DJNewsContentMgr ()

-(NSArray<DJNewsDetailModel*>*)getNewsContentByJSONPath:(NSString*)path;
//将内容数组进行转换两种内容：1.字符串内容；2.图片数组
-(NSAttributedString*)contentStr:(NSArray<DJNewsDetailModel*>*)modelArray;

@end

@implementation DJNewsContentMgr

static DJNewsContentMgr* this;

-(NSAttributedString *)textContent
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"dummyJSON" ofType:@"json"];
    NSArray* arr = [self getNewsContentByJSONPath:path];
    return [self contentStr:arr];
}

+(instancetype)getStandardContentMgr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc]init];
    });
    return this;
}

-(NSArray<DJNewsDetailModel *> *)getNewsContentByJSONPath:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableArray* tmp = [NSMutableArray array];
    NSError* error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        debugLog(@"取出持久化JSON出错！%@",error.localizedDescription);
        return nil;
    }
    for (NSDictionary* dic in array) {
        DJNewsDetailModel* model = [[DJNewsDetailModel alloc]initWithDict:dic];
        [tmp addObject:model];
    }
    return [tmp copy];
}

-(NSAttributedString*)contentStr:(NSArray<DJNewsDetailModel *> *)modelArray
{
    NSMutableAttributedString* content = [[NSMutableAttributedString alloc]init];
    NSAttributedString* br = [[NSAttributedString alloc] initWithString:@"\n" attributes:nil];
    NSDictionary* attributes = nil;
    for (DJNewsDetailModel* model in modelArray) {
        switch (model.type) {
            case DJNewsModelTypeText:{//文本内容
                attributes = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:model.size],
                    NSForegroundColorAttributeName:model.color
                               };
                NSAttributedString* txt = [[NSAttributedString alloc]initWithString:model.content attributes:attributes];
                [content appendAttributedString:txt];
            }
                break;
            case DJNewsModelTypeImg:{//图片内容
                UIImage* img1 = [UIImage imageNamed:@"NoImage"];
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:img1 contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(model.width, model.height) alignToFont:[UIFont systemFontOfSize:[UIFont systemFontSize]] alignment:YYTextVerticalAlignmentCenter];
                [content appendAttributedString:attachText];
                [content appendAttributedString:br];
            }
                break;
            case DJNewsModelTypeLink:{
                attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]],
                               NSLinkAttributeName:[NSURL URLWithString:model.url],
                     NSUnderlineStyleAttributeName:@(1),
                    NSForegroundColorAttributeName:model.color
                               };
                NSAttributedString* txt = [[NSAttributedString alloc]initWithString:model.content attributes:attributes];
                [content appendAttributedString:txt];
            }
                break;
            }
    }
    return content;
}



@end
