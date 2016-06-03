//
//  SHNewsContentMgr.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJNewsContentMgr.h"
#import "DJNewsDetailModel.h"
#import "NSAttributedString+YYText.h"
#import "UIImageView+WebCache.h"

@interface DJNewsContentMgr ()

@property(nonatomic,strong)NSMutableArray<DJNewsDetailModel*>* dataArr;
@property(nonatomic,strong)UIFont* lastFont;

-(NSMutableArray<DJNewsDetailModel*>*)getNewsContentByJSONPath:(NSString*)path;

-(NSMutableAttributedString*)contentStr:(NSArray<DJNewsDetailModel*>*)modelArray;

@end

@implementation DJNewsContentMgr

-(NSMutableAttributedString*)textContent
{
    if (!_textContent) {
        _textContent = [self contentStr:self.dataArr];
    }
    return _textContent;
}

-(NSMutableArray<DJNewsDetailModel *> *)dataArr
{
    if (!_dataArr) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"dummyJSON" ofType:@"json"];
       _dataArr = [self getNewsContentByJSONPath:path];
    }
    return _dataArr;
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

-(NSMutableAttributedString*)contentStr:(NSArray<DJNewsDetailModel *> *)modelArray
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
                UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, model.width, model.height)];
                [imgView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"NoImage"]];
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.clipsToBounds = YES;
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imgView contentMode:UIViewContentModeCenter attachmentSize:imgView.frame.size alignToFont:self.lastFont alignment:YYTextVerticalAlignmentCenter];
                [attachText yy_setTextHighlightRange:attachText.yy_rangeOfAll
                                               color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                                     backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                           tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                               [self.delegate contentMgr:self ViewImg:imgView.image];
                                           }];
                [content appendAttributedString:attachText];
            }
                break;
            case DJNewsModelTypeLink:{//超链内容
                NSMutableAttributedString* txt = [[NSMutableAttributedString alloc]initWithString:model.content];
                txt.yy_underlineStyle = NSUnderlineStyleSingle;
                txt.yy_font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
                txt.yy_color = [UIColor blueColor];
                [txt yy_setTextHighlightRange:txt.yy_rangeOfAll
                                        color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                              backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                    tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                        [self.delegate contentMgr:self openLink:[NSURL URLWithString:model.url]];
                                    }];
                [content appendAttributedString:txt];
                self.lastFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            }
                break;
            }
    }
    
    return content;
}

@end
