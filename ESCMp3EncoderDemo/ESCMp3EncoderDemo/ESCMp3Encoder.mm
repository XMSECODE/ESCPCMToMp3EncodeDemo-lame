//
//  ESCMp3Encoder.cpp
//  ESCMp3EncoderDemo
//
//  Created by xiang on 2018/7/12.
//  Copyright © 2018年 xiang. All rights reserved.
//

#include "ESCMp3Encoder.h"

@interface ESCMp3Encoder ()


@end

@implementation ESCMp3Encoder

- (int)setupWithPcmFilePath:(NSString *)pcmFilePath mp3FilePath:(NSString *)mp3FilePath sampleRate:(int)sampleRate channels:(int)channels bitRate:(int)bitRate {
    int result = -1;
    pcmFile = fopen(pcmFilePath, "rb");
    if (pcmFile) {
        mp3File = fopen(mp3FilePath, "wb");
        if (mp3File) {
            lameClient = lame_init();
            lame_set_in_samplerate(lameClient, sampleRate);
            lame_set_out_samplerate(lameClient, sampleRate);
            lame_set_num_channels(lameClient, channels);
            lame_set_brate(lameClient, bitRate / 1000);
            lame_init_params(lameClient);
            result = 0;
        }
    }
    return result;
}

-(void)encode {
    
}

-(void)destory {
    
}

@end
//
//ESCMp3Encoder::ESCMp3Encoder() {
//}
//
//ESCMp3Encoder::~ESCMp3Encoder() {
//}
//
//
//void ESCMp3Encoder::Encode() {
//    int bufferSize = 1024 * 256;
//    short *buffer = new short[bufferSize / 2];
//    short *leftBuffer = new short[bufferSize / 4];
//    short *rightBuffer = new short[bufferSize / 4];
//    unsigned char *mp3_buffer = new unsigned char[bufferSize];
//    size_t readBufferSize = 0;
//    while ((readBufferSize = fread(buffer, 2, bufferSize / 2, pcmFile)) > 0) {
//        for (int i = 0; i < readBufferSize; i++) {
//            if (i % 2 == 0) {
//                leftBuffer[i / 2] = buffer[i];
//            }else {
//                rightBuffer[i / 2] = buffer[i];
//            }
//        }
//        printf("read file size == %zu\n",readBufferSize);
//        size_t wroteSize = lame_encode_buffer(lameClient, (short int *)leftBuffer, (short int *)rightBuffer, (int)(readBufferSize / 2), mp3_buffer, bufferSize);
//        fwrite(mp3_buffer, 1, wroteSize, mp3File);
//    }
//    delete [] buffer;
//    delete [] leftBuffer;
//    delete [] rightBuffer;
//    delete [] mp3_buffer;
//}
//
//void ESCMp3Encoder::Destory() {
//    if (pcmFile) {
//        fclose(pcmFile);
//    }
//    if (mp3File) {
//        fclose(mp3File);
//        lame_close(lameClient);
//    }
//}
