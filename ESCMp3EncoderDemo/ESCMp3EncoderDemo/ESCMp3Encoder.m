//
//  ESCMp3Encoder.cpp
//  ESCMp3EncoderDemo
//
//  Created by xiang on 2018/7/12.
//  Copyright © 2018年 xiang. All rights reserved.
//

#include "ESCMp3Encoder.h"
#include "lame.h"

@interface ESCMp3Encoder ()

@property(nonatomic,assign)FILE *pcmFile;

@property(nonatomic,assign)FILE *mp3File;

@property(nonatomic,assign)lame_t lameClient;

@end

@implementation ESCMp3Encoder

- (int)setupWithPcmFilePath:(NSString *)pcmFilePath mp3FilePath:(NSString *)mp3FilePath sampleRate:(int)sampleRate channels:(int)channels bitRate:(int)bitRate {
    int result = -1;
    char *cPcmFilePath = [pcmFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    char *cMp3FilePath = [mp3FilePath cStringUsingEncoding:NSUTF8StringEncoding];
    self.pcmFile = fopen(cPcmFilePath, "rb");
    if (self.pcmFile) {
        self.mp3File = fopen(cMp3FilePath, "wb");
        if (self.mp3File) {
            self.lameClient = lame_init();
            lame_set_in_samplerate(self.lameClient, sampleRate);
            lame_set_out_samplerate(self.lameClient, sampleRate);
            lame_set_num_channels(self.lameClient, channels);
            lame_set_brate(self.lameClient, bitRate / 1000);
            lame_init_params(self.lameClient);
            result = 0;
        }
    }
    return result;
}

-(void)encode {
    int bufferSize = 1024 * 256;
    short *buffer = malloc(bufferSize );
    short *leftBuffer = malloc(bufferSize / 2);
    short *rightBuffer = malloc(bufferSize / 2);
    unsigned char *mp3_buffer = malloc(bufferSize);
    size_t readBufferSize = 0;
    while ((readBufferSize = fread(buffer, 2, bufferSize / 2, self.pcmFile)) > 0) {
        for (int i = 0; i < readBufferSize; i++) {
            if (i % 2 == 0) {
                leftBuffer[i / 2] = buffer[i];
            }else {
                rightBuffer[i / 2] = buffer[i];
            }
        }
        printf("read file size == %zu\n",readBufferSize);
        size_t wroteSize = lame_encode_buffer(self.lameClient, (short int *)leftBuffer, (short int *)rightBuffer, (int)(readBufferSize / 2), mp3_buffer, bufferSize);
        fwrite(mp3_buffer, 1, wroteSize, self.mp3File);
    }
    free(buffer);
    free(leftBuffer);
    free(rightBuffer);
    free(mp3_buffer);    
}

-(void)destory {
    if (self.pcmFile) {
        fclose(self.pcmFile);
    }
    if (self.mp3File) {
        fclose(self.mp3File);
        lame_close(self.lameClient);
    }
}

@end

