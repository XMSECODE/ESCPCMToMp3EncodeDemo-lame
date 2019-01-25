//
//  ESCMp3Decoder.m
//  ESCMp3EncoderDemo
//
//  Created by xiang on 2018/12/14.
//  Copyright © 2018 xiang. All rights reserved.
//

#import "ESCMp3Decoder.h"
#include "lame.h"

@interface ESCMp3Decoder ()

@property(nonatomic,assign)FILE *pcmFile;

@property(nonatomic,assign)FILE *mp3File;

@property(nonatomic,assign)hip_t decodeClient;

@end

@implementation ESCMp3Decoder

void lame_report_functions(const char *format, va_list ap) {
    printf("format==== %s===\n",format);
}

- (int)setupWithMp3FilePath:(NSString *)mp3FilePath
                pcmFilePath:(NSString *)pcmFilePath
                 sampleRate:(int)sampleRate
                   channels:(int)channels
                    bitRate:(int)bitRate {
    int result = -1;
    char *cPcmFilePath = [pcmFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    char *cMp3FilePath = [mp3FilePath cStringUsingEncoding:NSUTF8StringEncoding];
    self.mp3File =fopen(cMp3FilePath, "rb");
    if (self.mp3File) {
        self.pcmFile = fopen(cPcmFilePath, "wb");
        if (self.pcmFile) {
            hip_t decodeClient = hip_decode_init();
            self.decodeClient = decodeClient;
            hip_set_debugf(self.decodeClient, lame_report_functions);
            hip_set_msgf(self.decodeClient, lame_report_functions);
            result = 0;
        }

    }
    return result;
}
-(void)decode {
    int samples;
    int mp3_bytes;
    int write_bytes;
    int bufferSize = 1024 * 100;
    short pcm_l[bufferSize];
    short pcm_r[bufferSize];
    unsigned char mp3_buf[bufferSize];
    //https://blog.csdn.net/u010650845/article/details/53520426
    //读取标签头ID3
    /*
     位于文件开始处，长度为10字节，结构如下：
     char Header[3];    必须为“ID3”否则认为标签不存在
    char Ver;         版本号ID3V2.3 就记录
    char Revision;     副版本号此版本记录为0
    char Flag;        标志字节，只使用高三位，其它位为0
    char Size[4];      标签大小
    注：标签大小，不能确定具体包括哪些内容，解析歌曲文件后，发现没有哪些字节之和会等于该值，详见下面的实例分析
    标志字节一般为0，定义如下(abc000000B)
    a：表示是否使用Unsynchronisation
    b：表示是否有扩展头部，一般没有，所以一般也不设置
    c：表示是否为测试标签，99.99%的标签都不是测试标签，不设置
    标签大小共四个字节，每个字节只使用低7位，最高位不使用恒为0，计算时将最高位去掉，得到28bit的数据，计算公式如下：
     */
    mp3_bytes = fread(mp3_buf, 1, 10, self.mp3File);
    if (mp3_bytes != 10) {
        NSLog(@"未读取到ID3头");
        return;
    }
    NSData *testData = [NSData dataWithBytes:mp3_buf length:mp3_bytes];
    NSLog(@"%@",testData);
    
    //计算标签大小
    int size0 = ((int)(mp3_buf[6]) & 0x0000007f) <<21;
    int size1 = ((int)(mp3_buf[7]) & 0x0000007f) <<14;
    int size2 = ((int)(mp3_buf[8]) & 0x0000007f) <<7;
    int size3 = ((int)(mp3_buf[9]) & 0x0000007f);
    int size = size0 + size1 + size2 + size3;
    NSLog(@"标签大小=%d",size);
    
    //读取标签帧
    mp3_bytes = fread(mp3_buf, 1, size - 10, self.mp3File);
    if (mp3_bytes != size - 10) {
        NSLog(@"读取标签帧内容失败");
        return;
    }
    
    int currentIndex = 0;
    while (1) {
        //循环读取标签内容
        //1、读取头
        //获取帧内容大小
        unsigned char *framePoint = &mp3_buf[currentIndex];
        int frameSize = (int)(framePoint[4]*0x100000000) + (int)(framePoint[5]*0x10000) + (int)(framePoint[6]*0x100 +framePoint[7]);
        NSData *temData = [NSData dataWithBytes:mp3_buf + currentIndex length:8];
        NSLog(@"读取到帧头=%@大小=%d==%d",temData,frameSize,currentIndex);
        if (frameSize < 1) {
            break;
        }
        currentIndex += 10 + frameSize;
        if (currentIndex >= size - 10) {
            break;
        }
    }
    //读取音频数据
    while (1) {
        @autoreleasepool {
            //读取数据头4字节
            mp3_bytes = fread(mp3_buf, 1, 2, self.mp3File);
            if (mp3_bytes < 0) {
                NSLog(@"数据读取完毕");
                return;
            }
            NSData *temData = [NSData dataWithBytes:mp3_buf length:2];
            NSLog(@"%@==%d",temData,mp3_bytes);
            //获取相关信息
            if ((mp3_buf[0] & 0xff) == 0xff && ((mp3_buf[1] & 0xff) == 0xe0)) {
                NSLog(@"校验成功");
            }else {
                //            NSLog(@"音频数据头校验失败");
                //            break;
            }
        }
       
    }
    return;
    while ((mp3_bytes = fread(mp3_buf, 1, 1024, self.mp3File)) > 0) {
        
        samples = hip_decode(self.decodeClient, mp3_buf, mp3_bytes, pcm_l, pcm_r);
        NSLog(@"mp3bytes == %d== samples === %d",mp3_bytes,samples);
        if (samples > 0) {
            write_bytes = fwrite(pcm_l, sizeof(short), samples, self.pcmFile);
        }
    }
}

-(void)destory {
    hip_decode_exit(self.decodeClient);
    fclose(self.pcmFile);
}

@end
