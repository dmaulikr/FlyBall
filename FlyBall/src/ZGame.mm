//
//  game.m
//  Beltality
//
//  Created by Mac Mini on 30.10.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import "cocos2d.h"
#import "MainScene.h"
#import "Defs.h"
#import "globalParam.h"
#import "Utils.h"
#import "SimpleAudioEngine.h"
#import "ActorPlayer.h"
#import "MKStoreManager.h"
#import "GUIPanelDef.h"
#import "GameStandartFunctions.h"
#import "GUILabelTTFDef.h"
#import "GUILabelTTFOutlinedDef.h"
#import "FlurryAnalytics.h"
#import "AnalyticsData.h"
#import "MyData.h"
#import "ActorCircleBomb.h"
#import "ActorCircleTimeBomb.h"
#import "ActorCircleMagnetBomb.h"
#import "ActorCircleBonus.h"
#import "CellsBackground.h"
#import "SpeedWall.h"
#import "ActorCircleLaunchBomb.h"
#import "BoomManager.h"

@implementation ZGame

@synthesize state;
@synthesize oldState;
@synthesize player;

- (void) levelFinishCloseAnimationStart {
    [[GameStandartFunctions instance] playCloseScreenAnimation:0];
}

- (void) buttonLevelRestartAction {
    [[MainScene instance].levelFinishScreen show:NO];
	[self levelRestart];
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_RESTART_LEVEL_CLICKED];
}

- (void) buttonPauseAction {
    [self setPause:!isPause];
    [[[CCDirector sharedDirector] scheduler] setTimeScale:1.0f];
}

-(void) retartGameProcess {
    [Defs instance].bestScore = 0;
    [Defs instance].gameSessionCounter = 0;
    [Defs instance].coinsCount = 0;
    
    [Defs instance].gameSessionCounter = 0;
    [Defs instance].rateMeWindowShowValue = 0;
    [Defs instance].totalTouchBloxCounter = 0;
    [Defs instance].totalDeadBloxCounter = 0;
    [Defs instance].totalBombCounter = 0;
    [Defs instance].hintCounter = 3;
    
    //--------------------------------------
    // То, что можно прокачать
    //--------------------------------------
    [Defs instance].bonusAccelerationPower = BONUS_ACCELERATION_POWER_DEFAULT;
    [Defs instance].bonusAccelerationPowerLevel = 0;
    [Defs instance].bonusAccelerationDelay = BONUS_ACCELERATION_DELAY_DEFAULT;
    [Defs instance].bonusAccelerationDelayLevel = 0;
    [Defs instance].bonusGetChance = BONUS_GET_CHANCE_DEFAULT;
    [Defs instance].bonusGetChanceLevel = 0;
    [Defs instance].coinsGetChance = COINS_GET_CHANCE_DEFAULT;
    [Defs instance].coinsGetChanceLevel = 0;
    [Defs instance].bonusGodModeTime = BONUS_GODMODE_TIME_DEFAULT;
    [Defs instance].bonusGodModeTimeLevel = 0;
    [Defs instance].gravitation = GRAVITATION_DEFAULT;
    [Defs instance].gravitationLevel = 0;
    [Defs instance].speedWallAccelerationCoeff = SPEEDWALL_ACCELERATION_DEFAULT;
    [Defs instance].speedWallAccelerationCoeffLevel = 0;
    [Defs instance].speedWallDeccelerationCoeff = SPEEDWALL_DECCELERARION_DEFAULT;
    [Defs instance].speedWallDeccelerationCoeffLevel = 0;
    [Defs instance].speedWallDelayShowingCoeff = SPEEDWALL_DELAYSHOWINGCOEFF_DEFAULT;
    [Defs instance].speedWallDelayShowingCoeffLevel = 0;
    [Defs instance].playerMagnetDistance = PLAYER_MAGNET_DISTANDE_DEFAULT;
    [Defs instance].playerMagnetDistanceLevel = 0;
    [Defs instance].playerMagnetPower = PLAYER_MAGNET_POWER_DEFAULT;
    [Defs instance].playerMagnetPowerLevel = 0;
    [Defs instance].playerSpeedLimit = PLAYER_SPEED_LIMIT_DEFAULT;
    [Defs instance].playerSpeedLimitLevel = 0;
    [Defs instance].playerBombSlow = PLAYER_BOMB_SLOW_DEFAULT;
    [Defs instance].playerBombSlowLevel = 0;
    [Defs instance].playerGodModeAfterCrashTime = GODMODE_AFTERCRASH_TIME_DEFAULT;
    [Defs instance].playerGodModeAfterCrashTimeLevel = 0;
    [Defs instance].playerArmorLevel = 0;
    [Defs instance].launchBombLevel = 0;
    
    
    [MyData setStoreValue:@"coinsCount" value:@"0"];
    [MyData setStoreValue:@"bestScore" value:@"0"];
    [MyData setStoreValue:@"hintCounter" value:@"3"];
    
    [MyData setStoreValue:@"bonusAccelerationPower" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusAccelerationPower]];
    [MyData setStoreValue:@"bonusAccelerationPowerLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusAccelerationPowerLevel]];
    [MyData setStoreValue:@"bonusAccelerationDelay" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusAccelerationDelay]];
    [MyData setStoreValue:@"bonusAccelerationDelayLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusAccelerationDelayLevel]];
    [MyData setStoreValue:@"bonusGetChance" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusGetChance]];
    [MyData setStoreValue:@"bonusGetChanceLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusGetChanceLevel]];
    [MyData setStoreValue:@"coinsGetChance" value:[NSString stringWithFormat:@"%f",[Defs instance].coinsGetChance]];
    [MyData setStoreValue:@"coinsGetChanceLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsGetChanceLevel]];
    [MyData setStoreValue:@"bonusGodModeTime" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusGodModeTime]];
    [MyData setStoreValue:@"bonusGodModeTimeLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusGodModeTimeLevel]];
    [MyData setStoreValue:@"gravitation" value:[NSString stringWithFormat:@"%f",[Defs instance].gravitation]];
    [MyData setStoreValue:@"gravitationLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].gravitationLevel]];
    [MyData setStoreValue:@"speedWallAccelerationCoeff" value:[NSString stringWithFormat:@"%f",[Defs instance].speedWallAccelerationCoeff]];
    [MyData setStoreValue:@"speedWallAccelerationCoeffLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].speedWallAccelerationCoeffLevel]];
    [MyData setStoreValue:@"speedWallDeccelerationCoeff" value:[NSString stringWithFormat:@"%f",[Defs instance].speedWallDeccelerationCoeff]];
    [MyData setStoreValue:@"speedWallDeccelerationCoeffLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].speedWallDeccelerationCoeffLevel]];
    [MyData setStoreValue:@"speedWallDelayShowingCoeff" value:[NSString stringWithFormat:@"%f",[Defs instance].speedWallDelayShowingCoeff]];
    [MyData setStoreValue:@"speedWallDelayShowingCoeffLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].speedWallDelayShowingCoeffLevel]];
    [MyData setStoreValue:@"playerMagnetDistance" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetDistance]];
    [MyData setStoreValue:@"playerMagnetDistanceLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetDistanceLevel]];
    [MyData setStoreValue:@"playerMagnetPower" value:[NSString stringWithFormat:@"%f",[Defs instance].playerMagnetPower]];
    [MyData setStoreValue:@"playerMagnetPowerLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetPowerLevel]];
    [MyData setStoreValue:@"playerSpeedLimit" value:[NSString stringWithFormat:@"%f",[Defs instance].playerSpeedLimit]];
    [MyData setStoreValue:@"playerSpeedLimitLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerSpeedLimitLevel]];
    [MyData setStoreValue:@"playerBombSlow" value:[NSString stringWithFormat:@"%f",[Defs instance].playerBombSlow]];
    [MyData setStoreValue:@"playerBombSlowLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerBombSlowLevel]];
    [MyData setStoreValue:@"playerGodModeAfterCrashTime" value:[NSString stringWithFormat:@"%f",[Defs instance].playerGodModeAfterCrashTime]];
    [MyData setStoreValue:@"playerGodModeAfterCrashTimeLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerGodModeAfterCrashTimeLevel]];
    [MyData setStoreValue:@"playerArmorLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerArmorLevel]];
    [MyData setStoreValue:@"launchBombLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].launchBombLevel]];
    
    [MyData encodeDict:[MyData getDictForSaveData]];
}

- (id) init{
	if ((self = [super init])) {
		isVisible = NO;
		
		isPause = NO;
        
        [Defs instance].prices = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
                                  [NSNumber numberWithInt:10],
                                  [NSNumber numberWithInt:20],
                                  [NSNumber numberWithInt:30],
                                  [NSNumber numberWithInt:40], nil];
        
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        //[Defs instance].startGameNotFirstTime = NO;
        
        if (![Defs instance].startGameNotFirstTime) {
            [self retartGameProcess];
        } else {
            [Defs instance].gameSessionCounter = [[MyData getStoreValue:@"gameSessionCounter"] intValue];
            [Defs instance].rateMeWindowShowValue = [[MyData getStoreValue:@"rateMeWindowShowValue"] intValue];
            [Defs instance].coinsCount = [[MyData getStoreValue:@"coinsCount"] intValue];
            [Defs instance].bestScore = [[MyData getStoreValue:@"bestScore"] intValue];
            [Defs instance].totalTouchBloxCounter = [[MyData getStoreValue:@"totalTouchBloxCounter"] intValue];
            [Defs instance].totalDeadBloxCounter = [[MyData getStoreValue:@"totalDeadBloxCounter"] intValue];
            [Defs instance].totalBombCounter = [[MyData getStoreValue:@"totalDeadBloxCounter"] intValue];
            [Defs instance].hintCounter = [[MyData getStoreValue:@"hintCounter"] intValue];
            
            [Defs instance].bonusAccelerationPower = [[MyData getStoreValue:@"bonusAccelerationPower"] floatValue];
            [Defs instance].bonusAccelerationPowerLevel  = [[MyData getStoreValue:@"bonusAccelerationPowerLevel"] intValue];
            [Defs instance].bonusAccelerationDelay = [[MyData getStoreValue:@"bonusAccelerationDelay"] floatValue];
            [Defs instance].bonusAccelerationDelayLevel  = [[MyData getStoreValue:@"bonusAccelerationDelayLevel"] intValue];
            [Defs instance].bonusGetChance = [[MyData getStoreValue:@"bonusGetChance"] floatValue];
            [Defs instance].bonusGetChanceLevel  = [[MyData getStoreValue:@"bonusGetChanceLevel"] intValue];
            [Defs instance].coinsGetChance = [[MyData getStoreValue:@"coinsGetChance"] floatValue];
            [Defs instance].coinsGetChanceLevel  = [[MyData getStoreValue:@"coinsGetChanceLevel"] intValue];
            [Defs instance].bonusGodModeTime = [[MyData getStoreValue:@"bonusGodModeTime"] floatValue];
            [Defs instance].bonusGodModeTimeLevel  = [[MyData getStoreValue:@"bonusGodModeTimeLevel"] intValue];
            [Defs instance].gravitation = [[MyData getStoreValue:@"gravitation"] floatValue];
            [Defs instance].gravitationLevel  = [[MyData getStoreValue:@"gravitationLevel"] intValue];
            [Defs instance].speedWallAccelerationCoeff = [[MyData getStoreValue:@"speedWallAccelerationCoeff"] floatValue];
            [Defs instance].speedWallAccelerationCoeffLevel  = [[MyData getStoreValue:@"speedWallAccelerationCoeffLevel"] intValue];
            [Defs instance].speedWallDeccelerationCoeff = [[MyData getStoreValue:@"speedWallDeccelerationCoeff"] floatValue];
            [Defs instance].speedWallDeccelerationCoeffLevel  = [[MyData getStoreValue:@"speedWallDeccelerationCoeffLevel"] intValue];
            [Defs instance].speedWallDelayShowingCoeff = [[MyData getStoreValue:@"speedWallDelayShowingCoeff"] floatValue];
            [Defs instance].speedWallDelayShowingCoeffLevel  = [[MyData getStoreValue:@"speedWallDelayShowingCoeffLevel"] intValue];
            [Defs instance].playerMagnetDistance = [[MyData getStoreValue:@"playerMagnetDistance"] intValue];
            [Defs instance].playerMagnetDistanceLevel  = [[MyData getStoreValue:@"playerMagnetDistanceLevel"] intValue];
            [Defs instance].playerMagnetPower = [[MyData getStoreValue:@"playerMagnetPower"] floatValue];
            [Defs instance].playerMagnetPowerLevel  = [[MyData getStoreValue:@"playerMagnetPowerLevel"] intValue];
            [Defs instance].playerSpeedLimit = [[MyData getStoreValue:@"playerSpeedLimit"] floatValue];
            [Defs instance].playerSpeedLimitLevel  = [[MyData getStoreValue:@"playerSpeedLimitLevel"] intValue];
            [Defs instance].playerBombSlow = [[MyData getStoreValue:@"playerBombSlow"] floatValue];
            [Defs instance].playerBombSlowLevel  = [[MyData getStoreValue:@"playerBombSlowLevel"] intValue];
            [Defs instance].playerGodModeAfterCrashTime = [[MyData getStoreValue:@"playerGodModeAfterCrashTime"] floatValue];
            [Defs instance].playerGodModeAfterCrashTimeLevel  = [[MyData getStoreValue:@"playerGodModeAfterCrashTimeLevel"] intValue];
            [Defs instance].playerArmorLevel  = [[MyData getStoreValue:@"playerArmorLevel"] intValue];
            [Defs instance].launchBombLevel  = [[MyData getStoreValue:@"launchBombLevel"] intValue];
            
        }
		
        if (![Defs instance].isSoundMute) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"game_complete_new.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"button_click.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"star.wav"]; 
        }
            
		GUIButtonDef *btnDef = [GUIButtonDef node];
		btnDef.sprName = @"btnPause.png";
		btnDef.sprDownName = @"btnPauseDown.png";
		btnDef.group = GAME_STATE_GAME|GAME_STATE_GAMEPREPARE;
		btnDef.objCreator = self;
		btnDef.func = @selector(buttonPauseAction);
		btnDef.sound = @"button_click.wav";
        btnDef.zIndex = 5;
		if ([Defs instance].iPhone5) {
            btnPause = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 30)];
            [btnPause.spr setScale:1.3f];
        } else
            btnPause = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 20,SCREEN_HEIGHT-20)];
		
		btnDef.sprName = @"btnRestart.png";
		btnDef.sprDownName = @"btnRestartDown.png";
		btnDef.group = GAME_STATE_GAMEPAUSE|GAME_STATE_LEVELFINISH;
		btnDef.func = @selector(buttonLevelRestartAction);
        btnDef.isManyTouches = YES;
		[[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH_HALF+40,40)];
        
        
        scoreStrPos = ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT - 20);
        scoreStr = [CCLabelBMFont labelWithString:@"0" fntFile:@"fntNumber.fnt"];
        scoreStr.position = scoreStrPos;
        [scoreStr retain];
        
        
        GUILabelTTFDef *_labelTTFDef = [GUILabelTTFDef node];
        _labelTTFDef.group = GAME_STATE_GAME|GAME_STATE_GAMEPREPARE;
        
        _labelTTFDef.alignement = kCCTextAlignmentLeft;
        _labelTTFDef.textColor = ccc3(255, 150, 0);
        _labelTTFDef.text = @"";
        labelScoreStr1 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(1, screenPlayerPositionY - screenPlayerPositionY/1.5f)];
        
        _labelTTFDef.text = @"0";
        labelScoreStr2 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(1, screenPlayerPositionY)];
        
        _labelTTFDef.text = @"160";
        labelScoreStr3 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(1,screenPlayerPositionY + screenPlayerPositionY/1.5f)];
        
        // hint for start game
        _labelTTFDef.group = GAME_STATE_GAMEPREPARE;
        _labelTTFDef.fontSize = 24;
        _labelTTFDef.alignement = kCCTextAlignmentCenter;
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        _labelTTFDef.text = NSLocalizedString(@"HINT:Tap to Bomb","");
        [[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(SCREEN_WIDTH_HALF, 150)];
        
        _labelTTFDef.group = GAME_STATE_NONE;
        _labelTTFDef.text = NSLocalizedString(@"HINT:Explode all bomb","");
        labelTouchAllBomb = [[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(SCREEN_WIDTH_HALF, 140)];
        
        GUIPanelDef *panelDef = [GUIPanelDef node];
        panelDef.parentFrame = [Defs instance].spriteSheetChars;
        panelDef.enabled = NO;
        panelDef.group = GAME_STATE_NONE;
        panelDef.sprName = @"time_screen1.png";
        panelDef.zIndex = 250;
        panelSlowMotionLeft = [[MainScene instance].gui addItem:panelDef _pos:ccp(0,0)];
        [panelSlowMotionLeft.spr setAnchorPoint:ccp(0, 0)];
        [panelSlowMotionLeft.spr setScale:2];
        
		/*panelDef.sprName = @"frame_time_vert.png";
		panelSlowMotionLeft = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(0, 0)];
        [panelSlowMotionLeft.spr setAnchorPoint:ccp(0,0)];
        [panelSlowMotionLeft.spr setFlipX:YES];
        
        panelDef.sprName = @"frame_time_vert.png";
		panelSlowMotionRight = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(320, 0)];
        [panelSlowMotionRight.spr setAnchorPoint:ccp(1,0)];
        
        panelDef.sprName = @"frame_time_horizont.png";
		panelSlowMotionBottom = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(0, 0)];
        [panelSlowMotionBottom.spr setAnchorPoint:ccp(0,0)];
        [panelSlowMotionBottom.spr setFlipY:YES];
        
        panelDef.sprName = @"frame_time_horizont.png";
		panelSlowMotionTop = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(0, 480)];
        [panelSlowMotionTop.spr setAnchorPoint:ccp(0,1)];*/
        
        panelDef.group = GAME_STATE_NONE;
        panelDef.parentFrame = [MainScene instance].gui;
        panelDef.sprName = @"finger_1.png";
        panelDef.enabled = NO;
        panelHelpFinger = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(190,240)];
        
        helpFingerAnimationDelay = 0.8f;
        
        //cells = [[CellsBackground alloc] init];
        //[cells retain];
        
        paralaxBackground = [[ParalaxBackground alloc] init];
        [paralaxBackground retain];
        
        heightLabels = [[HeightLabels alloc] init];
        [heightLabels retain];
        
        player = [[ActorPlayer alloc] init:[Defs instance].spriteSheetChars _location:ccp(screenPlayerPositionX, screenPlayerPositionY)];
        
        for (int i = 0; i < 10; i++)
        [[ActorCircleBomb alloc] init:[Defs instance].spriteSheetChars _location:CGPointZero];
        
        for (int i = 0; i < 5; i++)
            [[ActorCircleTimeBomb alloc] init:[Defs instance].spriteSheetChars _location:CGPointZero];
        
        for (int i = 0; i < 5; i++)
            [[ActorCircleMagnetBomb alloc] init:[Defs instance].spriteSheetChars _location:CGPointZero];
        
        for (int i = 0; i < 10; i++)
            [[ActorCircleBonus alloc] init:[Defs instance].spriteSheetChars _location:CGPointZero];
        
        speedWall = [[SpeedWall alloc] init:[Defs instance].spriteSheetCells];
        [speedWall retain];
        
        timerDelayAddBall = 0.50f;
        
        startPlatform = [CCSprite spriteWithSpriteFrameName:@"startPlatform.png"];
        [startPlatform setAnchorPoint:ccp(0.5f,0)];
        [startPlatform setPosition:ccp(SCREEN_WIDTH_HALF,0)];
        //[startPlatform setScale:2];
        [startPlatform retain];
        
        firstBomb = [[ActorCircleLaunchBomb alloc] init:[Defs instance].spriteSheetChars _location:ccp(screenPlayerPositionX, screenPlayerPositionY - 90)];
        
        [[BoomManager alloc] init];
    
    }
	return (self);
}

- (void) deactivateAllActors {
	Actor *_a;
    int _cnt = [Defs instance].actorManager.actorsAll.count;
    for (int i = 0; i < _cnt; i++) {
        _a = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
        [_a deactivate];
    }
}

- (void) setCenterOfTheScreen:(CGPoint)_pos {
    int x = MAX(_pos.x, -64);
    int y = MAX(_pos.y, screenPlayerPositionY);
    
    x = MIN(x, 384);
    y = MIN(y, INTMAX_MAX);
    
    [Defs instance].objectFrontLayer.position = ccpSub(ccp(SCREEN_WIDTH_HALF, screenPlayerPositionY), ccp(x,y));
    //[Defs instance].spriteSheetHeightLabels.position = ccp(0,[Defs instance].objectFrontLayer.position.y);
    [Defs instance].spriteSheetParalax_2.position = ccp([Defs instance].objectFrontLayer.position.x/8, [Defs instance].objectFrontLayer.position.y/8);
    [Defs instance].objectBackLayer.position = ccp(0, [Defs instance].objectFrontLayer.position.y/13);
}

- (void) prepareToHideGameScreen {
    [self setCenterOfTheScreen:ccp(SCREEN_WIDTH_HALF, 0)];
	[self show:NO];
    [[BoomManager instance] inactiveAll];
	GAME_IS_PLAYING = NO;
}

- (ActorActiveBombObject*) addBall:(id)_class
          _point:(CGPoint)_point
       _velocity:(CGPoint)_velocity
         _active:(BOOL)_active{
    int _cnt = [Defs instance].actorManager.actorsAll.count;
    Actor *_a;
    ActorActiveBombObject *_circleBombActor = nil;
    for (int i = 0; i < _cnt; i++) {
        _a = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
        if (([_a isMemberOfClass:_class])&&(_a.isActive == NO)) {
            _circleBombActor = (ActorActiveBombObject*)_a;
            break;
        }
    }
    
    if (_circleBombActor != nil)
        [_circleBombActor addToField:_point _velocity:_velocity];
    else {
        _circleBombActor = [[_class alloc] init:[Defs instance].spriteSheetChars _location:_point];
        CCLOG(@"CREATE NEW BOMB");
    }
    
    
    _circleBombActor.isActive = _active;
    [_circleBombActor show:_active];
    return _circleBombActor;
}

- (void) addBonus:(int)_type
           _point:(CGPoint)_point
       _velocity:(CGPoint)_velocity
         _active:(BOOL)_active{
    
    int _cnt = [Defs instance].actorManager.actorsAll.count;
    Actor *_a;
    ActorCircleBonus *_circleBombBonus = nil;
    for (int i = 0; i < _cnt; i++) {
        _a = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
        if (([_a isMemberOfClass:[ActorCircleBonus class]])&&(_a.isActive == NO)) {
            _circleBombBonus = (ActorCircleBonus*)_a;
            break;
        }
    }
    
    if (_circleBombBonus != nil)
        [_circleBombBonus addToField:_point _velocity:_velocity];
    else {
        _circleBombBonus = [[ActorCircleBonus alloc] init:[Defs instance].spriteSheetChars _location:_point];
        CCLOG(@"CREATE NEW BONUS");
    }
    if (_active) {
        if (_type == 0) [_circleBombBonus setRandomBonus]; else
            if (_type == 1) [_circleBombBonus setCoins];
    }
    
    _circleBombBonus.isActive = _active;
    [_circleBombBonus show:_active];
}

- (void) levelStart{
    isPause = NO;
	
	levelTime = 0;
	
    collectedCoins = 0;
	scoreLevel = 0;
    [scoreStr setColor:ccc3(255, 255, 255)];
    [scoreStr setString:@"0"];
    isNewScoreSound = NO;
    
    GAME_IS_PLAYING = NO;
    state = GAME_STATE_GAMEPREPARE;
    [[MainScene instance].gui show:state];
    
    [self deactivateAllActors];
    
    [player activate];
    //[player addVelocity:ccp(0,4)];
    [self setCenterOfTheScreen:player.position];
    
    [firstBomb activate];

    timerAddBall = -0.3f;
    
    [self labelScoreBarUpdate];
    //[cells restartParameters];
    [paralaxBackground restartParameters];
    [heightLabels restartParameters];
    [speedWall deactivate];
    
    if (([Defs instance].hintCounter > 0)&&([Defs instance].launchBombLevel == 0)) {
        helpFingerAnimationTime = 0;
        [panelHelpFinger setPosition:ccp(195,250)];
        [panelHelpFinger show:YES];
    }
    
    timeSlowMotion = 0;
    timeSlowMotionPause = 0;
    isSlowMotion = NO;
    [[[CCDirector sharedDirector] scheduler] setTimeScale:1.0f];
    
    [[BoomManager instance] inactiveAll];
    
    [self show:YES];
    
    ++[Defs instance].gameSessionCounter;
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_LEVEL_START];
}

- (void) startGameSession {
    GAME_IS_PLAYING = YES;
    state = GAME_STATE_GAME;
    [[MainScene instance].gui show:state];
    
    [player addVelocity:firstBomb.velocity];
    
    secondBomb = [self addBall:[ActorCircleBomb class] _point:ccp(player.position.x, player.position.y - screenPlayerPositionY) _velocity:ccp(0, 5 + firstBomb.velocity.y) _active:YES];
    
    [self bonusSlowMotionActivate:3 _timeScale:0.7f];
    
    [firstBomb touch];
}

- (void) levelRestart {
    [[GameStandartFunctions instance] hideScreenAnimation];
    [self levelStart];
}

- (void) setPause:(BOOL)_flag{
	isPause = _flag;
	[[MainScene instance].pauseScreen show:isPause];
	  
    if (isPause) {
        oldState = state;
		state = GAME_STATE_GAMEPAUSE;
        [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_PAUSE_ON_CLICKED];
	} else {
		state = oldState;
        [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_PAUSE_OFF_CLICKED];
	}
	
	[[MainScene instance].gui show:state];
}

- (void) getAchievements {
}

- (void) levelFinishAction {
	if (state == GAME_STATE_LEVELFINISH) return;
    
	state = GAME_STATE_LEVELFINISH;
    [[MainScene instance].gui show:state];
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_LEVEL_FINISH];
    
    [self deactivateAllActors];
    [speedWall deactivate];
    
    // get Achievement
    [self getAchievements];
	
	GAME_IS_PLAYING = NO;
    
	if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"game_complete_new.wav"]; 	
    
	[self prepareToHideGameScreen];
	
    [self show:NO];
    
    //[Defs instance].bestScore = 0;
    
    [[MainScene instance] showLevelFinishScreenAndSetScore:YES _collectedCoins:collectedCoins _score:scoreLevel _starCount:3];
    
    [MyData encodeDict:[MyData getDictForSaveData]];
}

- (void) labelScoreBarUpdate {
    [labelScoreStr1 setPosition:ccp(1, SCREEN_HEIGHT-(int)(player.position.y - SCREEN_HEIGHT_HALF/1.5f) % SCREEN_HEIGHT)];
    [labelScoreStr2 setPosition:ccp(1, SCREEN_HEIGHT-(int)(player.position.y) % SCREEN_HEIGHT)];
    [labelScoreStr3 setPosition:ccp(1, SCREEN_HEIGHT-(int)(player.position.y + SCREEN_HEIGHT_HALF/1.5f) % SCREEN_HEIGHT)];
    
    NSString *_strScoreValue;
    float _scoreValue = (int)(player.position.y + (labelScoreStr1.spr.position.y)-(SCREEN_HEIGHT + 160));
        if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue >= 1000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            //if (_scoreValue >= 1000) {
            //    _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
           // } else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(_scoreValue)];
           // }
        }
    [labelScoreStr1 setText:_strScoreValue];
        
    
    _scoreValue = (int)(player.position.y + (labelScoreStr2.spr.position.y)-(SCREEN_HEIGHT + 160));
    if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue >= 1000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            //if (_scoreValue >= 1000) {
            //    _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
            //} else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(_scoreValue)];
            //}
    }
    [labelScoreStr2 setText:_strScoreValue];
    
    _scoreValue = (int)(player.position.y + (labelScoreStr3.spr.position.y)-(SCREEN_HEIGHT + 160));
    if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue >= 1000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            //if (_scoreValue >= 1000) {
            //    _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
            //} else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(_scoreValue)];
           // }
    }
    [labelScoreStr3 setText:_strScoreValue];
}

- (void) bombExplosion:(ActorActiveBombObject*)_tempActor {
    float _tempActorX = _tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x;
    float _tempActorY = _tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y;
    
    float _distance = [[Utils instance] distance:screenPlayerPositionX _y1:screenPlayerPositionY _x2:_tempActorX _y2:_tempActorY];
    if (_distance < elementSize) _distance = elementSize;
    
    if (_distance > 210) return;
    
    float _power = (1 - _distance/210)*15.2f;
    
    float _angle = CC_DEGREES_TO_RADIANS([Utils GetAngleBetweenPt1:ccp(screenPlayerPositionX, screenPlayerPositionY) andPt2:ccp(_tempActorX,_tempActorY)]);
    
    [player addVelocity:ccp(_power*0.4f*cos(_angle),_power*sin(_angle))];
    
    if ([_tempActor isKindOfClass:[ActorActiveBombObject class]]) {
        float _ran = CCRANDOM_0_1();
        if (_ran< [Defs instance].bonusGetChance) {
            [self addBonus:0 _point:_tempActor.costume.position _velocity:player.velocity _active:YES];
        } else
            if (_ran < [Defs instance].bonusGetChance + [Defs instance].coinsGetChance)
                [self addBonus:1 _point:_tempActor.costume.position _velocity:player.velocity _active:YES];
    }
}

- (void) bonusAddFrame:(float)_time
                        _bonusID:(int)_bonusID{
    [panelSlowMotionLeft show:YES];
    [panelSlowMotionLeft.spr setOpacity:200];
    [panelSlowMotionLeft.spr setPosition:ccp(-[Defs instance].objectFrontLayer.position.x, -[Defs instance].objectFrontLayer.position.y)];
    
    panelBonusFadeSpeed = int(255 / (FRAME_RATE*_time));
    
    switch (_bonusID) {
        case BONUS_SLOWMOTION: {
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"time_screen1.png"];
            [panelSlowMotionLeft.spr setDisplayFrame:frame];
        }
            break;
        case BONUS_ACCELERATION: {
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"time_screen1.png"];
            [panelSlowMotionLeft.spr setDisplayFrame:frame];
        }
            break;
        case BONUS_GODMODE: {
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"time_screen1.png"];
            [panelSlowMotionLeft.spr setDisplayFrame:frame];
        }
            break;
            
        case BONUS_APOCALYPSE: {
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"time_screen2.png"];
            [panelSlowMotionLeft.spr setDisplayFrame:frame];
        }
            break;
            
    }
}

- (void) doBonusEffect:(int)_bonusID {
    switch (_bonusID) {
        case BONUS_SLOWMOTION:
            
            break;
            
        case BONUS_ACCELERATION:

            break;
            
        case BONUS_APOCALYPSE: {
            if (![Defs instance].isSoundMute) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"activate_bonus_apocalypse_new.wav"];
            }
            [self bonusAddFrame:0.3f _bonusID:_bonusID];
            Actor* _tempActor;
            int _count = [[Defs instance].actorManager.actorsAll count];
            for (int i = 0; i < _count; i++) {
                _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
                if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)) {
                    if (([_tempActor isKindOfClass:[ActorActiveBombObject class]])
                        &&(![self checkIsOutOfScreen:_tempActor])){
                        //[self bombExplosion:(ActorActiveBombObject*)_tempActor];
                        [_tempActor touch];
                    }
                }
            }
        }
            break;
            
        case BONUS_GODMODE:
   
            break;
    }
}

- (void) bonusSlowMotionActivate:(float)_time
                      _timeScale:(float)_timeScale {
    isSlowMotion = YES;
    timeSlowMotion = 0;
    delaySlowMotion = _time;
    [[[CCDirector sharedDirector] scheduler] setTimeScale:_timeScale];
}

- (void) bonusTouchReaction:(int)_bonusID {
    switch (_bonusID) {
        case BONUS_COINS:
            // Добавляем одну монетку
            ++collectedCoins;
            break;
            
        case BONUS_SLOWMOTION:
            // Включаем замедление времени
            [self bonusSlowMotionActivate:[Defs instance].playerBombSlow _timeScale:0.5f];
            [self bonusAddFrame:[Defs instance].playerBombSlow _bonusID:_bonusID];
            break;
            
        case BONUS_ACCELERATION:
            // Ускорение
            [player setSpeedBonus:[Defs instance].bonusAccelerationDelay];
            [self bonusAddFrame:[Defs instance].bonusAccelerationDelay _bonusID:_bonusID];
            break;
            
        case BONUS_APOCALYPSE:
            // Апокалипсис
            [player setBonusCell:BONUS_APOCALYPSE];
            break;
            
        case BONUS_GODMODE:
            // устанавливаем режим бога
            [player setGodMode:[Defs instance].bonusGodModeTime];
            [self bonusAddFrame:[Defs instance].bonusGodModeTime _bonusID:_bonusID];
            break;
    }
}

- (BOOL) checkIsOutOfScreen:(Actor*)_tempActor {
    if ((_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x <= -elementRadius)
        ||(_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x >= SCREEN_WIDTH+  elementRadius)
        ||(_tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y <= -elementRadius)
        ||(_tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y >= SCREEN_HEIGHT+elementRadius)) return YES;
    return NO;
}

- (void) fingerAnimation {
    helpFingerAnimationTime += TIME_STEP;
    
    if (helpFingerAnimationState == 1) {
        if (helpFingerAnimationTime >= helpFingerAnimationDelay) {
            CCSpriteFrame *_frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"finger_1.png"];
            [panelHelpFinger.spr setDisplayFrame:_frame];
            helpFingerAnimationState = 2;
            helpFingerAnimationTime = 0;
        }
    } else
        if (helpFingerAnimationState == 2) {
            
            if (helpFingerAnimationTime >= helpFingerAnimationDelay) {
                
                CCSpriteFrame *_frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"finger_2.png"];
                [panelHelpFinger.spr setDisplayFrame:_frame];
                
                helpFingerAnimationState = 1;
                helpFingerAnimationTime = 0;
            }
        }
}

- (void) update:(ccTime)dt {
    
    double delta = dt*FRAME_RATE;
    
    [[GameStandartFunctions instance] playCurrentBackgroundMusicTrack:1];
    
    if (state != GAME_STATE_LEVELFINISH) {
        // Пока делаем затемнение или наоборот, ф-цию update не выполняем
    if (([Defs instance].closeAnimationPanel) && ([Defs instance].isOpenScreenAnimation)) {
        if ([Defs instance].closeAnimationPanel.spr.opacity >= 25) [Defs instance].closeAnimationPanel.spr.opacity -= 25; else {
            [[Defs instance].closeAnimationPanel.spr setOpacity:0];
            [[Defs instance].closeAnimationPanel show:NO];
            [Defs instance].isOpenScreenAnimation = NO;
            return;
        }
    } else 
        if ([Defs instance].isCloseScreenAnimation) {
            if ([Defs instance].closeAnimationPanel.spr.opacity <= 225) [Defs instance].closeAnimationPanel.spr.opacity += 25; else {
                [Defs instance].isCloseScreenAnimation = NO;
                [[Defs instance].closeAnimationPanel.spr setOpacity:255];
                if ([Defs instance].afterCloseAnimationScreenType == 0) {
                    [self levelFinishAction];
                }
            }
            return;
        }
    }
	
	if ((GAME_IS_PLAYING)&&((state & (GAME_STATE_GAMEPAUSE)) == 0)) {
		
		levelTime += dt;
        
        if ((secondBomb)&&([Defs instance].hintCounter > 0)&&([Defs instance].launchBombLevel == 0)) {
            if (!labelTouchAllBomb.spr.parent) {
                if (secondBomb.costume.position.y >= 430) {
                    [labelTouchAllBomb show:YES];
                    [panelHelpFinger show:YES];
                    [panelHelpFinger setPosition:ccp(190,240)];
                    [btnPause show:NO];
                    [[[CCDirector sharedDirector] scheduler] setTimeScale:0.0f];
                }
                
            } else {
                [self fingerAnimation];
                
                return;
            }
        }
        
        if (isSlowMotion) {
            timeSlowMotion += TIME_STEP;
            if (timeSlowMotion >= delaySlowMotion) {
                isSlowMotion = NO;
                [[[CCDirector sharedDirector] scheduler] setTimeScale:1.0f];
            }
            
        }
        
        if (player.position.y < SCREEN_HEIGHT_HALF) {
            [self levelFinishCloseAnimationStart];
            return;
        }
        
        if (startPlatform.parent) {
            if (startPlatform.position.y + startPlatform.contentSize.height  < -[Defs instance].objectFrontLayer.position.y) {
                [startPlatform removeFromParent];
            }
        } else {
            if (startPlatform.position.y + startPlatform.contentSize.height  >= -[Defs instance].objectFrontLayer.position.y) {
                [[Defs instance].objectFrontLayer addChild:startPlatform z:0];
            }
        }
        
        Actor *_tempActor;
        float _distanceToActor;
        float _minDistance = elementSize;
        int _count = [[Defs instance].actorManager.actorsAll count];
        for (int i = 0; i < _count; i++) {
            _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
            if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)&&([_tempActor isKindOfClass:[ActorActiveObject class]])
                &&(![self checkIsOutOfScreen:_tempActor])) {
                _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x _y1:_tempActor.costume.position.y _x2:player.position.x _y2:player.position.y];
                if (_distanceToActor < _minDistance) {
                    if ([_tempActor isKindOfClass:[ActorActiveBombObject class]]) [self bombExplosion:(ActorActiveBombObject*)_tempActor];
                    [(ActorActiveObject*)_tempActor touch];
                    if (player.velocity.y > - elementSize) {
                        if ([_tempActor isKindOfClass:[ActorActiveBombObject class]])
                        {
                            [player eraserCollide];
                            if (!player.isActive) {
                                [self levelFinishCloseAnimationStart];
                                return;
                            }
                            break;
                        }
                    }
                }
            }
        }
        
        // Удаляем сильно отдалившиеся объекты
        _minDistance = 500;
        for (int i = 0; i < _count; i++) {
            _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
            if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)&&([_tempActor isKindOfClass:[ActorActiveObject class]])) {
                _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x _y1:_tempActor.costume.position.y _x2:player.position.x _y2:player.position.y];
                if (_distanceToActor > _minDistance) {
                    [(ActorActiveObject*)_tempActor deactivate];
                }
            }
        }
        
        // действуем магнитом на бонусы
        for (int i = 0; i < _count; i++) {
            _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
            if ((_tempActor.isActive)&&([_tempActor isMemberOfClass:[ActorCircleBonus class]])
                /*&&(![self checkIsOutOfScreen:_tempActor])*/) {
                _tempActor.costume.position = ccpAdd(_tempActor.costume.position, [player magnetReaction:_tempActor.costume.position]);
            }
        }
        
        // действуем бомбой магнитом на игрока
        for (int i = 0; i < _count; i++) {
            _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
            if ((_tempActor.isActive)&&([_tempActor isMemberOfClass:[ActorCircleMagnetBomb class]])
                /*&&(![self checkIsOutOfScreen:_tempActor])*/) {
                [player setPosition:ccpAdd(player.position, [(ActorCircleMagnetBomb*)_tempActor magnetReaction:player.position])];
            }
        }
        
        [self labelScoreBarUpdate];
        
        timerAddBall += dt;
        if (timerAddBall >= timerDelayAddBall - (levelTime/900)) {
            float _playerVelocityX = player.velocity.x;
            float _playerVelocityY = player.velocity.y;
            
            if (player.isBonusSpeed) {
                _playerVelocityY -= [Defs instance].bonusAccelerationPower;
            }
            
            if (_playerVelocityY < 0) _playerVelocityY = 0;
            
            float _velocityXCoeff = 1.2f;
            float _velocityYCoeff = 2 + levelTime/23 + CCRANDOM_0_1()*(levelTime/100);
            if (_velocityYCoeff < 5.0f) {
                _velocityYCoeff = 5.0f;
            }

            int _ballCount = 1 + round(CCRANDOM_0_1());
            for (int i = 0; i < _ballCount; i++) {
                float _ran = CCRANDOM_0_1()*8;
                id _newBombType = [ActorCircleBomb class];
                if ((player.position.y >= 50000)&&(_ran > 7)) {
                    _newBombType = [ActorCircleMagnetBomb class];
                    
                    float _bombPosition = SCREEN_WIDTH*0.3f;
                    if (CCRANDOM_MINUS1_1() < 0) _bombPosition = -SCREEN_WIDTH*0.3f;
                    
                    _bombPosition += CCRANDOM_MINUS1_1()*20;
                    
                    [self addBall:_newBombType _point:ccp(player.position.x + _bombPosition, player.position.y - screenPlayerPositionY - elementRadius) _velocity:ccp(_playerVelocityX, _playerVelocityY + 6 + CCRANDOM_0_1()) _active:YES];
                } else
                if ((player.position.y >= 100000)&&(_ran > 5)) {
                    _newBombType = [ActorCircleTimeBomb class];
                    
                    float _bombPosition = SCREEN_WIDTH*0.25f;
                    if (CCRANDOM_MINUS1_1() < 0) _bombPosition = -SCREEN_WIDTH*0.25f;
                    _bombPosition += CCRANDOM_MINUS1_1()*20;
                    
                    [self addBall:_newBombType _point:ccp(player.position.x + _bombPosition, player.position.y - screenPlayerPositionY - elementRadius) _velocity:ccp(_playerVelocityX, _playerVelocityY + 6 + CCRANDOM_0_1()) _active:YES];
                } else {
                    [self addBall:_newBombType _point:ccp(player.position.x + (screenPlayerPositionX - elementSize)*CCRANDOM_MINUS1_1(), player.position.y - screenPlayerPositionY - elementRadius) _velocity:ccp(_playerVelocityX + CCRANDOM_MINUS1_1()*_velocityXCoeff, _playerVelocityY + _velocityYCoeff) _active:YES];
                }
            }
            
            timerAddBall = 0;
        }
        
        if (scoreLevel < (int)(player.position.y - screenPlayerPositionY)) {
            scoreLevel = (int)(player.position.y - screenPlayerPositionY);
            [scoreStr setPosition:ccp(scoreStrPos.x + [[Utils instance] myRandom2F]*2, scoreStrPos.y + [[Utils instance] myRandom2F]*2)];
            
            if ((scoreLevel > [Defs instance].bestScore)&&([Defs instance].gameSessionCounter != 1)) {
                [scoreStr setColor:ccc3(100, 255, 100)];
                //[scoreStr setString:[NSString stringWithFormat:@"Wooow %im!!!",scoreLevel]];
                if (!isNewScoreSound) {
                    if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"new_record_new.wav"];
                    isNewScoreSound = YES;
                }
            }
            [scoreStr setString:[NSString stringWithFormat:@"%i",scoreLevel]];
        }
        
        [[BoomManager instance] update:dt];
        
        [[Defs instance].actorManager update:delta];
        [self setCenterOfTheScreen:player.position];
        
        // делаем апдейт относительно текущей позиции игрока
        //[cells update];
        [paralaxBackground update];
        [heightLabels update];
        // стена скорости, которая действует на персонажа
        [speedWall update];
        [player addVelocity:([speedWall checkToCollide:player.position])];
        
        if (panelSlowMotionLeft.spr.opacity >= panelBonusFadeSpeed) {
            [panelSlowMotionLeft.spr setOpacity:panelSlowMotionLeft.spr.opacity - panelBonusFadeSpeed];
            [panelSlowMotionLeft.spr setPosition:ccp(-[Defs instance].objectFrontLayer.position.x, -[Defs instance].objectFrontLayer.position.y)];
        }
        else {
           [panelSlowMotionLeft show:NO]; 
        }
    } else
        if (state == GAME_STATE_GAMEPREPARE) {
            if (([Defs instance].hintCounter > 0)&&([Defs instance].launchBombLevel == 0)) [self fingerAnimation];
            [firstBomb update:delta];
            firstBomb.costume.position = ccp(screenPlayerPositionX + CCRANDOM_MINUS1_1()*2, (screenPlayerPositionY - 90) + CCRANDOM_MINUS1_1()*2);
        }

}

- (void) show:(BOOL)_flag{
	//if (isVisible != _flag) {
	
		isVisible = _flag;
	
		if (isVisible){
            [[GameStandartFunctions instance] playOpenScreenAnimation];
            
            helpFingerAnimationTime = 0;
            helpFingerAnimationState = 2;
            
            if (!startPlatform.parent) [[Defs instance].objectFrontLayer addChild:startPlatform z:0];
            if (!scoreStr.parent) [[MainScene instance] addChild:scoreStr];
		}else {
            if (startPlatform.parent) [startPlatform removeFromParent];
            if (scoreStr.parent) [scoreStr removeFromParent];
            [speedWall show:NO];
		}
	//}
    //[cells show:_flag];
    [paralaxBackground show:_flag];
    [heightLabels show:_flag];
    [[Defs instance].actorManager show:_flag];
}

- (BOOL) ccTouchBegan:(CGPoint)_touchPos{
	if (!isPause) {
			
		if (state != GAME_STATE_LEVELFINISH) {
			if (GAME_IS_PLAYING) {
                
                if (labelTouchAllBomb.spr.parent) {
                    float _distanceToActor = [[Utils instance] distance:secondBomb.costume.position.x + [Defs instance].objectFrontLayer.position.x _y1:secondBomb.costume.position.y + [Defs instance].objectFrontLayer.position.y _x2:_touchPos.x _y2:_touchPos.y];
                    if (_distanceToActor <= bombTouchSize) {
                        [labelTouchAllBomb show:NO];
                        [panelHelpFinger show:NO];
                        [btnPause show:YES];
                        [self bonusSlowMotionActivate:3 _timeScale:0.7f];
                        secondBomb = nil;
                        --[Defs instance].hintCounter;
                        [MyData setStoreValue:@"hintCounter" value:[NSString stringWithFormat:@"%i",[Defs instance].hintCounter]];
                    }
                }
                
                Actor* _tempActor;
                float _distanceToActor = 0;
                //NSMutableArray *_actorArr = [NSMutableArray arrayWithCapacity:3];
                float _minDistance = 9999;
                int _actorWithMinDistanceID = -1;
                int _count = [[Defs instance].actorManager.actorsAll count];
                for (int i = 0; i < _count; i++) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
                    if ((_tempActor.isActive)
                        &&([_tempActor isKindOfClass:[ActorActiveObject class]])
                        &&(![self checkIsOutOfScreen:_tempActor])) {
                        _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x _y1:_tempActor.costume.position.y+ [Defs instance].objectFrontLayer.position.y _x2:_touchPos.x _y2:_touchPos.y];
                        if (_distanceToActor <= bombTouchSize) {
                            if (_minDistance > _distanceToActor) {
                                _minDistance = _distanceToActor;
                                _actorWithMinDistanceID = i;
                            }
                        }
                    }
                }
                
                if (_actorWithMinDistanceID != -1) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:_actorWithMinDistanceID];
                    
                    [_tempActor touch];
                    
                    
                    //делаем цепную реакцию
                    float _distance;
                    Actor *_actor;
                    int _count = [[Defs instance].actorManager.actorsAll count];
                    for (int i = 0; i < _count; i++) {
                        _actor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
                        if ((_actor.isActive)&&(player.itemID != _tempActor.itemID)&&(_actor.itemID != _tempActor.itemID)) {
                            if (([_actor isKindOfClass:[ActorActiveBombObject class]])
                                &&(![self checkIsOutOfScreen:_tempActor])){
                                _distance = [[Utils instance] distance:_actor.costume.position.x _y1:_actor.costume.position.y _x2:_tempActor.costume.position.x _y2:_tempActor.costume.position.y];
                                if (_distance < elementSize) {
                                    [_actor touch];
                                }
                            }
                        }
                    }
                    
                    if (_tempActor == secondBomb) secondBomb = nil;
                    
                    _tempActor = nil;
                    
                    return YES;
                }
                
			} else {
            
                if (state == GAME_STATE_GAMEPREPARE) {
                    firstBomb.costume.position = ccp(screenPlayerPositionX, screenPlayerPositionY - 90);
                    float _distanceToActor = [[Utils instance] distance:firstBomb.costume.position.x + [Defs instance].objectFrontLayer.position.x _y1:firstBomb.costume.position.y + [Defs instance].objectFrontLayer.position.y _x2:_touchPos.x _y2:_touchPos.y];
                        if (_distanceToActor <= bombTouchSize) {
                            [self startGameSession];
                        }
                    return YES;
                }
                
            }

		}
	}
	
	return NO;
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {

}

- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
