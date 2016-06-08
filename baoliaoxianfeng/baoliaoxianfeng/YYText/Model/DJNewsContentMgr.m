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
#import "AFURLSessionManager.h"
#import "MBProgressHUD.h"
#import "DJAPPUtility.h"

@interface DJNewsContentMgr ()

@property(nonatomic,strong)NSMutableArray<DJNewsDetailModel*>* dataArr;
@property(nonatomic,strong)UIFont* lastFont;
@property(nonatomic,strong)NSMutableArray* attrStrArr;
@property(nonatomic,strong)NSMutableDictionary* photoURL;

-(NSMutableArray<DJNewsDetailModel*>*)getNewsContentByJSONPath:(NSString*)path;

-(NSMutableAttributedString*)contentStr:(NSArray<DJNewsDetailModel*>*)modelArray;

@end

@implementation DJNewsContentMgr

@synthesize textContent = _textContent;

-(NSMutableAttributedString*)textContent
{
    if (!_textContent) {
        _textContent = [self contentStr:self.dataArr];
    }
    return _textContent;
}

-(void)setTextContent:(NSMutableAttributedString *)textContent
{
    _textContent = textContent;
    
}

-(NSMutableArray *)attrStrArr
{
    if (!_attrStrArr) {
        _attrStrArr = [NSMutableArray array];
    }
    return _attrStrArr;
}

-(NSMutableDictionary *)photoURL
{
    if (!_photoURL) {
        _photoURL = [NSMutableDictionary dictionary];
    }
    return _photoURL;
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

-(void)insertImgintoCurrentTextView:(YYTextView*)textView generalFont:(UIFont*)font image:(UIImage*)img
{
    NSMutableAttributedString* tmp = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    NSAttributedString* br = [[NSAttributedString alloc]initWithString:@"\n" attributes:@{NSFontAttributeName:font}];//插入换行
    [tmp appendAttributedString:br];
    UIImageView* imgView = [[UIImageView alloc]initWithImage:img];
    imgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    //上传进度遮罩
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:imgView animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Uploading...";
    hud.color = [UIColor clearColor];
    [self.photoURL setObject:@"aaaa" forKey:[NSString stringWithFormat:@"%@",img]];
    [self uploadPic:img progressView:hud];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imgView contentMode:UIViewContentModeCenter attachmentSize:imgView.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [tmp appendAttributedString:attachText];
    [tmp appendAttributedString:br];
    textView.attributedText = [tmp copy];
    self.textContent = tmp;
}

-(void)uploadPic:(UIImage*)img progressView:(UIView*)progressView
{
    //模拟上传事件
//    NSProgress* dummyProgress = [NSProgress progressWithTotalUnitCount:100000];
//    [[NSOperationQueue new]addOperationWithBlock:^{
//        while (dummyProgress.completedUnitCount<dummyProgress.totalUnitCount) {
//            dummyProgress.completedUnitCount += 1;
//            if ([progressView isKindOfClass:[MBProgressHUD class]]) {
//                    MBProgressHUD* progressHUD = (MBProgressHUD*)progressView;
//                    progressHUD.progress = dummyProgress.fractionCompleted;
//                if (dummyProgress.fractionCompleted==1) {
//                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//                        [progressHUD hide:YES];//隐藏竟然不是线程安全的
//                    }];
//                }
//            }
//        }
//    }];
//    
//    return;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:@"http://example.com/upload"
                                                                                             parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        // 在此位置生成一个要上传的数据体
        // form对应的是html文件中的表单
        NSData* imgData = UIImagePNGRepresentation(img);
        NSString* fileName = [NSString stringWithFormat:@"%@",[NSDate date]];//时间戳为文件名
        [formData appendPartWithFormData:imgData name:fileName];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      if ([progressView isKindOfClass:[MBProgressHUD class]]) {
                            MBProgressHUD* progressHUD = (MBProgressHUD*)progressView;
                            progressHUD.progress = uploadProgress.fractionCompleted;
                        if (uploadProgress.fractionCompleted==1) {//完成就隐藏掉...
                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                [progressHUD hide:YES];//隐藏竟然不是线程安全的
                            }];
                        }
                      }
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
#warning TODO -- 添加错误提示HUD！！！
                          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                              [(MBProgressHUD*)progressView hide:YES];//隐藏竟然不是线程安全的
                          }];
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          [self.photoURL setObject:responseObject forKey:[NSString stringWithFormat:@"%@",img]];
                      }
                  }];
    
    [uploadTask resume];
}

#warning TODO -- 所有上传任务结束以前是不允许保存的！！！
-(void)saveContent:(NSAttributedString *)content
{
    [content enumerateAttributesInRange:content.yy_rangeOfAll options: NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSLog(@"Attrs: %@,Range:%@, Content:%@",attrs,NSStringFromRange(range), [content attributedSubstringFromRange:range]);
        NSString* fontColor = [NSString stringWithFormat:@"%@",attrs[@"NSColor"]];//对应值的类型为UICachedDeviceRGBColor，而这种类型是UIKit不认识的（大概在NSKit里），需要以这种形式转换成我们认识的字符串，比如：“UIDeviceRGBColorSpace 0 0 1 1”，
        NSLog(@"%@",[DJAPPUtility convertToDescriptionStr:fontColor]);
//        NSDictionary* textContent = @{
//                                      @"type":@(0),
//                                      @"content":[content attributedSubstringFromRange:range],
//                                      @"size":@([attrs[@"NSFont"] fontSize]),
//                                      @"color":[attrs[@"NSFont"] fontDescriptor]
//                                      };
        
        
        if ([attrs.allKeys containsObject:@"YYTextAttachment"]) {//说明这是图片
            YYTextAttachment* attachment = attrs[@"YYTextAttachment"];
            if([attachment.content isKindOfClass:[UIImageView class]]){
                NSString* key = [NSString stringWithFormat:@"%@",[attachment.content image]];
                NSLog(@"🐒%@",self.photoURL[key]);
            }
        }
    }];
}

#pragma mark YYTextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    
}

#pragma mark -- ToolBarDelegate
-(void)toolBar:(DJEditorToolBar *)toolBar img:(UIImage *)img
{
    YYTextView* textView = (YYTextView*)self.contentKeeper;
    [self insertImgintoCurrentTextView:textView generalFont:textView.font image:img];
}

@end
