//
//  ViewController.m
//  ESCMp3EncoderDemo
//
//  Created by xiang on 2018/7/12.
//  Copyright © 2018年 xiang. All rights reserved.
//

#import "ViewController.h"
#import "ESCMp3Encoder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)didClickEncode:(id)sender {
    NSString *pcmPath = [[NSBundle mainBundle] pathForResource:@"vocal.pcm" ofType:nil];
    const char *pcmPathChar = [pcmPath cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSString *mp3Path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    mp3Path = [NSString stringWithFormat:@"%@/vocal.mp3",mp3Path];
    const char *mp3PathChar = [mp3Path cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"pcmPath = %@\n mp3Path = %@",pcmPath,mp3Path);
    ESCMp3Encoder *mp3Encoder = new ESCMp3Encoder();
    
    int sampleRate = 44100;
    int channels = 2;
    int bitRate = 128 * 1024;
    
    int result = mp3Encoder->Init(pcmPathChar, mp3PathChar, sampleRate, channels, bitRate);
    if (result != 0) {
        NSLog(@"init encoder failed!");
        delete mp3Encoder;
        return;
    }
    
    mp3Encoder->Encode();
    
    mp3Encoder->Destory();
    
    delete mp3Encoder;
   
}



@end
