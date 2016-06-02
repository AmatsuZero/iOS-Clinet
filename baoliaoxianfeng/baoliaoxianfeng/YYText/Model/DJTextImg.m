//
//  DJTextImg.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJTextImg.h"
#import "AFURLSessionManager.h"
#import "NSString+DJMD5String.h"

@interface DJTextImg ()

@property(nonatomic,copy)NSString* sandBoxPath;

@end

@implementation DJTextImg

-(NSString *)sandBoxPath{
    if (!_sandBoxPath) {
        _sandBoxPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"NewsDetailCahe"];
        NSFileManager* mgr = [NSFileManager defaultManager];
        NSError* error;
        if (![mgr fileExistsAtPath:_sandBoxPath]) {
            if (![mgr createDirectoryAtPath:_sandBoxPath withIntermediateDirectories:NO attributes:nil error:&error]) {
                debugLog(@"创建新闻内容图片沙盒文件失败，原因:%@",error.localizedDescription);
            }
        }
    }
    return _sandBoxPath;
}

-(UIImage*)getWebPicFrom:(NSString*)url withPlaceHolder:(NSString*)placeHolder andFailPic:(NSString*)failPic
{
    self.url = url;
    NSURL* reqURL = [NSURL URLWithString:url];
    NSString* fileName = [url MD5Hash];
    NSString* filePath = [self.sandBoxPath stringByAppendingPathComponent:fileName];
    NSFileManager* mgr = [NSFileManager defaultManager];
    __block NSError* erro;
    //1. 先检查沙河里面有没有，有就返回沙盒图片
    if ([mgr fileExistsAtPath:filePath]) {
        return [UIImage imageWithContentsOfFile:filePath];
    }
    //2. 如果URL协议为file，说明下载完毕，返回沙盒下文件
    if ([reqURL.scheme isEqualToString:@"file"]) {
       return [UIImage imageWithContentsOfFile:reqURL.path];
    }
    
    //3. 开启下载任务
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//必须设置ReponseSerializer检测，不然会报unacceptable type
    NSURLRequest* req = [NSURLRequest requestWithURL:reqURL];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, NSData* responseObject, NSError * _Nullable error) {
        if (!error&&responseObject.length>0) {
            if (![responseObject writeToFile:filePath options:NSDataWritingAtomic error:&erro]) {
                debugLog(@"新闻详情图片写入沙盒失败！ 原因:%@",error.localizedDescription);
            }
            [self.delegate textImgModel:self replaceImg:[UIImage imageWithData:responseObject] imgPath:filePath];
        } else {
            debugLog(@"图片下载失败！%@",error.localizedDescription);
            UIImage* fP = [UIImage imageNamed:failPic?:placeHolder];
            [self.delegate textImgModel:self replaceImg:fP imgPath:nil];
        }
    }] resume];
    
    return [UIImage imageNamed:placeHolder];
}

@end
