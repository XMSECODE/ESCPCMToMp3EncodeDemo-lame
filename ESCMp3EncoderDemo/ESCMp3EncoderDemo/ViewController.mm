//
//  ViewController.m
//  ESCMp3EncoderDemo
//
//  Created by xiang on 2018/7/12.
//  Copyright © 2018年 xiang. All rights reserved.
//

#import "ViewController.h"
#import "ESCMp3Encoder.h"
#import "ESCMp3Decoder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)didClickEncode:(id)sender {
    NSString *pcmPath = [[NSBundle mainBundle] pathForResource:@"vocal.pcm" ofType:nil];
    
    NSString *mp3Path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    mp3Path = [NSString stringWithFormat:@"%@/vocal.mp3",mp3Path];
    
    NSLog(@"pcmPath = %@\n mp3Path = %@",pcmPath,mp3Path);
    ESCMp3Encoder *mp3Encoder = [[ESCMp3Encoder alloc] init];
    
    int sampleRate = 44100;
    int channels = 1;
    int bitRate = 128 * 1024;
    
    int result = [mp3Encoder setupWithPcmFilePath:pcmPath mp3FilePath:mp3Path sampleRate:sampleRate channels:channels bitRate:bitRate];
    if (result != 0) {
        NSLog(@"init encoder failed!");
        return;
    }
    
    [mp3Encoder encode];
    
    [mp3Encoder destory];
    
   
}

- (IBAction)didClickDecodeButton:(id)sender {
    
    
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"G.E.M.邓紫棋 - 喜欢你.mp3" ofType:nil];
    
    NSString *pcmPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    pcmPath = [NSString stringWithFormat:@"%@/G.E.M.邓紫棋 - 喜欢你.pcm",pcmPath];
    
    NSLog(@"pcmPath = %@\n mp3Path = %@",pcmPath,mp3Path);
    ESCMp3Decoder *decoder = [[ESCMp3Decoder alloc] init];
    
    int sampleRate = 44100;
    int channels = 1;
    int bitRate = 128 * 1024;
    
    int  result = [decoder setupWithMp3FilePath:mp3Path pcmFilePath:pcmPath sampleRate:sampleRate channels:channels bitRate:bitRate];
    
    if (result != 0) {
        NSLog(@"init decoder failed!");
        return;
    }
    
    [decoder decode];
    
    [decoder destory];
}


@end
