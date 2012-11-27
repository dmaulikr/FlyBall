//
//  ActorCircle.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ActorCircleTimeBomb.h"
#import "Utils.h"
#import "Defs.h"
#import "globalParam.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation ActorCircleTimeBomb

-(id) init:(CCNode*)_parent
 _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
	
        [self loadCostume];
        
        costume.position = _location;
        timeBomb = 0;
        delayBomb = 2;
        currSpriteFrame = 0;
	}
	return self;
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"player_armor_2.png"];
	[costume retain];
}

- (void) activate {
    timeBomb = 0;
    [super activate];
}

- (void) setSpriteFrame:(int)_spriteFrame {
    if ((currSpriteFrame == _spriteFrame)||(currSpriteFrame == int(delayBomb))) return;
    currSpriteFrame = _spriteFrame;
    
    CCSpriteFrame* frame;
    switch (currSpriteFrame) {
        case 0:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_armor_2.png"];
            break;
        case 1:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_armor_1.png"];
            break;
        case 2:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_armor_0.png"];
            break;
            
        default:
            break;
    }
    [costume setDisplayFrame:frame];
}

- (void) update {
    if (!isActive) return;
    
    [costume setRotation:costume.rotation + rotationSpeed];
    if (costume.rotation > 360) costume.rotation -= 360; else
        if (costume.rotation < 0) costume.rotation += 360;
    
    timeBomb += TIME_STEP;
    if (timeBomb >= delayBomb) {
        [self touch];
        timeBomb = 0;
    }
    [self setSpriteFrame:(int)timeBomb];
    
    [super update];
}

- (void) addVelocity:(CGPoint)_value {
    if (_value.x > 0) rotationSpeed = CCRANDOM_0_1()*3;
    else rotationSpeed = -CCRANDOM_0_1()*3;
    [super addVelocity:_value];
}

@end