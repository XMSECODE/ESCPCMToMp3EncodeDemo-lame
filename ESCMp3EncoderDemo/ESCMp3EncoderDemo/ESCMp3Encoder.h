//
//  ESCMp3Encoder.hpp
//  ESCMp3EncoderDemo
//
//  Created by xiang on 2018/7/12.
//  Copyright © 2018年 xiang. All rights reserved.
//

#ifndef ESCMp3Encoder_hpp
#define ESCMp3Encoder_hpp

#import <Foundation/Foundation.h>




@interface ESCMp3Encoder : NSObject

- (int)setupWithPcmFilePath:(NSString *)pcmFilePath mp3FilePath:(NSString *)mp3FilePath sampleRate:(int)sampleRate channels:(int)channels bitRate:(int)bitRate;
-(void)encode;
-(void)destory;

@end



//class ESCMp3Encoder {
//private:
//    FILE *pcmFile;
//    FILE *mp3File;
//    lame_t lameClient;
//public:
//    ESCMp3Encoder();
//    ~ESCMp3Encoder();
//    int Init(const char *pcmFilePath, const char *mp3FilePath, int sampleRate, int channels, int bitRate);
//    void Encode();
//    void Destory();
//};

#endif /* ESCMp3Encoder_hpp */
