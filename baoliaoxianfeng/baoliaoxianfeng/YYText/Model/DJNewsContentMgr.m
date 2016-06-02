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

@interface DJNewsContentMgr ()<DJTextImgDelegate>

@property(nonatomic,strong)NSMutableDictionary* replaceRef;
@property(nonatomic,strong)NSMutableArray<DJNewsDetailModel*>* dataArr;
@property(nonatomic,strong)UIFont* lastFont;

-(NSMutableArray<DJNewsDetailModel*>*)getNewsContentByJSONPath:(NSString*)path;
//将内容数组进行转换两种内容：1.字符串内容；2.图片数组
-(NSAttributedString*)contentStr:(NSArray<DJNewsDetailModel*>*)modelArray;


@end

@implementation DJNewsContentMgr

static DJNewsContentMgr* this;

-(NSAttributedString *)textContent
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"dummyJSON" ofType:@"json"];
    self.dataArr = [self getNewsContentByJSONPath:path];
    return [self contentStr:self.dataArr];
}

-(instancetype)init{
    if (self = [super init]) {
        _replaceRef = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSMutableArray<DJNewsDetailModel *> *)getNewsContentByJSONPath:(NSString *)path
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
    return tmp;
}

-(NSAttributedString*)contentStr:(NSArray<DJNewsDetailModel *> *)modelArray
{
    NSMutableAttributedString* content = [[NSMutableAttributedString alloc]init];
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
                self.lastFont = [UIFont systemFontOfSize:model.size];
            }
                break;
            case DJNewsModelTypeImg:{//图片内容
                DJTextImg* img = [[DJTextImg alloc]init];
                img.delegate = self;
                [self.replaceRef setObject:@([modelArray indexOfObject:model]) forKey:model.url];
                UIImage* tmp = [img getWebPicFrom:model.url withPlaceHolder:@"NoImage.png" andFailPic:nil];
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:tmp contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(model.width, model.height) alignToFont:self.lastFont alignment:YYTextVerticalAlignmentCenter];
                [content appendAttributedString:attachText];
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
                self.lastFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            }
                break;
            }
    }
    return content;
}

#pragma mark -- 图片模型类代理方法
-(void)textImgModel:(DJTextImg *)imgModel replaceImg:(UIImage *)img imgPath:(NSString *)path
{
    debugLog(@"下载图片完毕，刷新页面");
    debugLog(@"%@",imgModel.url);
    NSInteger index= [[self.replaceRef objectForKey:imgModel.url] integerValue];
    DJNewsDetailModel* model = self.dataArr[index];
    if (path) {
         model.url = [NSURL fileURLWithPath:path].absoluteString;
        [self.delegate contentMgr:self refreshWithNewContent:[self contentStr:self.dataArr]];
    }
}

@end
