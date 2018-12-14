//
//  ESCMp3Decoder.h
//  ESCMp3EncoderDemo
//
//  Created by xiang on 2018/12/14.
//  Copyright © 2018 xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ESCMp3Decoder : NSObject

- (int)setupWithMp3FilePath:(NSString *)mp3FilePath
                pcmFilePath:(NSString *)pcmFilePath
                 sampleRate:(int)sampleRate
                   channels:(int)channels
                    bitRate:(int)bitRate;
-(void)decode;
-(void)destory;

@end

NS_ASSUME_NONNULL_END
