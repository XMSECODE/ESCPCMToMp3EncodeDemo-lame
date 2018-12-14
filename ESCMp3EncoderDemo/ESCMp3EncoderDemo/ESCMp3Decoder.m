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
