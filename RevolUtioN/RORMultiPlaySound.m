//
//  RORMultiPlaySound.m
//  Cyberace
//
//  Created by leon on 13-12-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMultiPlaySound.h"

@implementation RORMultiPlaySound

- (void)addFileNametoQueue:(NSString*)fileName {
    if(fileNameQueue == nil){
        fileNameQueue = [[NSMutableArray alloc] init];
    }
    [fileNameQueue addObject:fileName];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (index < fileNameQueue.count) {
        [self play:index];
    } else {
        fileNameQueue = nil;
        index = 0;
    }
}
- (void)play{
    if (!player.playing){
        [self play:0];
    }
}

- (void)play:(int)i {
    if(fileNameQueue != nil){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[fileNameQueue objectAtIndex:i] ofType:nil]] error:nil];
        player.delegate = self;
        [player prepareToPlay];
        [player play];
        index++;
    }
}

- (void)stop {
    if (player.playing) [player stop];
}

- (void)dealloc {
    fileNameQueue = nil;
    player = nil;
}
@end
