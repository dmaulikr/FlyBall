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
#import "ZFontManager.h"
#import "SimpleAudioEngine.h"
#import "ActorCircle.h"
#import "MKStoreManager.h"
#import "GUIPanelDef.h"
#import "GameStandartFunctions.h"
#import "Statistics.h"
#import "GUILabelTTFDef.h"
#import "GUILabelTTFOutlinedDef.h"
#import "FlurryAnalytics.h"
#import "AnalyticsData.h"
#import "MyData.h"
#import "ActorCircleBomb.h"
#import "ActorCircleBonus.h"
#import "CellsBackground.h"

@implementation ZGame

@synthesize state;
@synthesize oldState;

- (void) levelFinishCloseAnimationStart {
    [[GameStandartFunctions instance] playCloseScreenAnimation:0];
}

- (void) buttonLevelRestartAction {
	[levelFinishScreen show:NO];
	[self levelRestart];
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_RESTART_LEVEL_CLICKED];
}

- (void) buttonPauseAction {
    [self setPause:!isPause];
}

- (id) init{
	if ((self = [super init])) {		
		isVisible = NO;
		
		isPause = NO;
		//--------------------------------------
        // То, что можно прокачать
        //--------------------------------------
        [Defs instance].bonusAccelerationValue = BONUS_ACCELERATION_DEFAULT;
        [Defs instance].bonusGetChance = BONUS_GET_CHANCE_DEFAULT;
        [Defs instance].bonusGodModeTime = BONUS_GODMODE_TIME_DEFAULT;
        [Defs instance].gravitation = GRAVITATION_DEFAULT;
        
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        //[Defs instance].startGameNotFirstTime = NO;
        
        if (![Defs instance].startGameNotFirstTime) {            
            [Statistics instance].totalLevelsComplite = 0;
            //[[Defs instance].userSettings setInteger:0 forKey:@"totalLevelsComplite"];
            [MyData setStoreValue:@"totalLevelsComplite" value:@"0"];
            [Statistics instance].totalLevelsStart = 0;
            //[[Defs instance].userSettings setInteger:0 forKey:@"totalLevelsStart"];
            [MyData setStoreValue:@"totalLevelsStart" value:@"0"];
            [Statistics instance].rateMeWindowShowValue = 0;
            //[[Defs instance].userSettings setInteger:0 forKey:@"rateMeWindowShowValue"];
            [MyData setStoreValue:@"rateMeWindowShowValue" value:@"0"];

            //[[Defs instance].userSettings setInteger:0 forKey:@"totalTouchBloxCounter"];
            [MyData setStoreValue:@"totalTouchBloxCounter" value:@"0"];
            //[[Defs instance].userSettings setInteger:0 forKey:@"totalDeadBloxCounter"];
            [MyData setStoreValue:@"totalDeadBloxCounter" value:@"0"];
            [MyData setStoreValue:@"totalBombCounter" value:@"0"];;
            
            [Defs instance].totalTouchBloxCounter = 0;
            [Defs instance].totalDeadBloxCounter = 0;
            [Defs instance].totalBombCounter = 0;
            
        } else {
            [Statistics instance].totalLevelsComplite = [[MyData getStoreValue:@"totalLevelsComplite"] intValue];
            [Statistics instance].totalLevelsStart = [[MyData getStoreValue:@"totalLevelsStart"] intValue];
            [Statistics instance].rateMeWindowShowValue = [[MyData getStoreValue:@"rateMeWindowShowValue"] intValue];
            
            [Defs instance].totalTouchBloxCounter = [[MyData getStoreValue:@"totalTouchBloxCounter"] intValue];
            [Defs instance].totalDeadBloxCounter = [[MyData getStoreValue:@"totalDeadBloxCounter"] intValue];
            [Defs instance].totalBombCounter = [[MyData getStoreValue:@"totalDeadBloxCounter"] intValue];
        }
		
        if (![Defs instance].isSoundMute) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"level_win.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"expand1.wav"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"expand2.wav"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"expand3.wav"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"expand4.wav"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"button_click.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"objectHit.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"redThing_3.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"star.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"level_fix.wav"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"rainbow_back.wav"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"_3__Safe_Clicks_looped.mp3"];
        }
		
		levelFinishScreen = [LevelFinishScreen node];
		[self addChild:levelFinishScreen];
            
		GUIButtonDef *btnDef = [GUIButtonDef node];
		btnDef.sprName = @"btnPause.png";
		btnDef.sprDownName = @"btnPauseDown.png";
		btnDef.group = GAME_STATE_GAME;
		btnDef.objCreator = self;
		btnDef.func = @selector(buttonPauseAction);
		btnDef.sound = @"button_click.wav";
		if ([Defs instance].iPhone5) {
            GUIButton *_btn = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 40, 30)];
            [_btn.spr setScale:1.3f];
            _btn = nil;
        } else
            [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(20,SCREEN_HEIGHT-20)];    
        
		
		/*btnDef.sprName = @"btnPlayPauseScreen.png";
		btnDef.sprDownName = @"btnPlayPauseScreenDown.png";
		btnDef.group = GAME_STATE_GAMEPAUSE;
	
		[[MainScene instance].gui addItem:(id)btnDef _pos:ccp(50,SCREEN_HEIGHT-38)];*/
		
		btnDef.sprName = @"btnRestart.png";
		btnDef.sprDownName = @"btnRestartDown.png";
		btnDef.group = GAME_STATE_GAME|GAME_STATE_GAMEPAUSE;
		btnDef.func = @selector(buttonLevelRestartAction);
        btnDef.isManyTouches = YES;
		if ([Defs instance].iPhone5) {
            GUIButton *_btnRestart = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 30)];
            [_btnRestart.spr setScale:1.f];
            _btnRestart = nil;
        } else {
            GUIButton *_btnRestart = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 20,SCREEN_HEIGHT-20)];
            [_btnRestart.spr setScale:0.7f];
            _btnRestart = nil;
        }
        
        GUILabelTTFDef *_labelTTFDef = [GUILabelTTFDef node];
        _labelTTFDef.group = GAME_STATE_GAME|GAME_STATE_GAMEPAUSE;
        _labelTTFDef.text = @"0";
        
        scoreStrPos = ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT - 20);
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        scoreStr =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:scoreStrPos];
        
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        labelScoreStr1 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(20, SCREEN_HEIGHT_HALF - SCREEN_HEIGHT_HALF/1.5f)];
        
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        labelScoreStr2 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(20, SCREEN_HEIGHT_HALF)];
        
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        labelScoreStr3 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(20,SCREEN_HEIGHT_HALF + SCREEN_HEIGHT_HALF/1.5f)];
        
        cells = [[CellsBackground alloc] init];
        [cells retain];
        
        player = [[ActorCircle alloc] init:[Defs instance].spriteSheetChars _location:ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF)];
        
        for (int i = 0; i < 15; i++)
        [[ActorCircleBomb alloc] init:[Defs instance].spriteSheetChars _location:CGPointZero];
        
        for (int i = 0; i < 10; i++)
            [[ActorCircleBonus alloc] init:[Defs instance].spriteSheetChars _location:CGPointZero];
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

- (void) setCenterOfTheScreen:(CGPoint)_position {
    int x = MAX(_position.x, INTMAX_MIN);
    int y = MAX(_position.y, SCREEN_HEIGHT_HALF);
    
    x = MIN(x, INTMAX_MAX);
    y = MIN(y, INTMAX_MAX);
    
    [Defs instance].objectFrontLayer.position = ccpSub(ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF), ccp(x,y));
    //[Defs instance].objectBackLayer.position = ccp([Defs instance].objectFrontLayer.position.x/10, [Defs instance].objectFrontLayer.position.y/10);
}

- (void) prepareToHideGameScreen {
    [self setCenterOfTheScreen:ccp(SCREEN_WIDTH_HALF, 0)];
	[self show:NO];
	[self deactivateAllActors];
	GAME_IS_PLAYING = NO;
}

- (void) addBall:(CGPoint)_point
       _velocity:(CGPoint)_velocity
         _active:(BOOL)_active{
    
    int _cnt = [Defs instance].actorManager.actorsAll.count;
    Actor *_a;
    ActorCircleBomb *_circleBombActor = nil;
    for (int i = 0; i < _cnt; i++) {
        _a = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
        if (([_a isMemberOfClass:[ActorCircleBomb class]])&&(_a.isActive == NO)) {
            _circleBombActor = (ActorCircleBomb*)_a;
            break;
        }
    }
    
    if (_circleBombActor != nil)
        [_circleBombActor addToField:_point _velocity:_velocity];
    else {
        _circleBombActor = [[ActorCircleBomb alloc] init:[Defs instance].spriteSheetChars _location:_point];
        CCLOG(@"CREATE NEW BOMB");
    }

    
    _circleBombActor.isActive = _active;
    [_circleBombActor show:_active];
}

- (void) addBonus:(CGPoint)_point
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
    if (_active) [_circleBombBonus setRandomBonus];
    
    _circleBombBonus.isActive = _active;
    [_circleBombBonus show:_active];
}

- (void) levelStart{
	GAME_STARTED = YES;
    isPause = NO;
    
	[levelFinishScreen show:NO];
	
	levelTime = 0;
	
	scoreLevel = 0;
    
    GAME_IS_PLAYING = YES;
    state = GAME_STATE_GAME;
    [[MainScene instance].gui show:state];
    
    ++[Statistics instance].totalLevelsStart;
    
    [self deactivateAllActors];
    
    player.costume.position = ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF);
    [player activate];
    [player addVelocity:ccp(0,4)];
    
    [self addBall:ccp(player.costume.position.x, player.costume.position.y - SCREEN_HEIGHT_HALF) _velocity:ccp(0,7) _active:YES];
    
    timerAddBall = -1;
    timerDelayAddBall = 0.4f;
    
    [cells restartParameters];
    
    [self show:YES];
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_LEVEL_START];
}

- (void) levelRestart {
    [[GameStandartFunctions instance] hideScreenAnimation];
    [self levelStart];
}

- (void) setPause:(BOOL)_flag{
	isPause = _flag;
	[[MainScene instance].pauseScreen show:isPause];
	  
    if (isPause) {		
		state = GAME_STATE_GAMEPAUSE;
        [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_PAUSE_ON_CLICKED];
	} else {
		state = GAME_STATE_GAME;
        [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_PAUSE_ON_CLICKED];
	}
	
	[[MainScene instance].gui show:state];
}

- (void) getAchievements {
}

- (void) levelFinishAction {
	if (state == GAME_STATE_LEVELFINISH) return;
    
	state = GAME_STATE_LEVELFINISH;
    [[MainScene instance].gui show:state];
    
    ++[Statistics instance].totalLevelsComplite;
    //[[Defs instance].userSettings setInteger:[Statistics instance].totalLevelsComplite forKey:@"totalLevelsComplite"];
	[MyData setStoreValue:@"totalLevelsComplite" value:[NSString stringWithFormat:@"%i",[Statistics instance].totalLevelsComplite]];
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_LEVEL_FINISH];
    
    [self deactivateAllActors];
    
    // get Achievement
    [self getAchievements];
	
	GAME_IS_PLAYING = NO;
    
	if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"level_win.wav"]; 	
    
	[self prepareToHideGameScreen];
	
	if (scoreLevel < 0) scoreLevel = 0;
	
    [self show:NO];
    
	[levelFinishScreen setScore:scoreLevel];
	[levelFinishScreen showStars:3];
	[levelFinishScreen show:YES];
    
    [MyData encodeDict:[MyData getDictForSaveData]];
}

- (void) labelScoreBarUpdate {
    [labelScoreStr1 setPosition:ccp(20, SCREEN_HEIGHT-(int)(player.costume.position.y - SCREEN_HEIGHT_HALF/1.5f) % SCREEN_HEIGHT)];
    [labelScoreStr2 setPosition:ccp(20, SCREEN_HEIGHT-(int)(player.costume.position.y) % SCREEN_HEIGHT)];
    [labelScoreStr3 setPosition:ccp(20, SCREEN_HEIGHT-(int)(player.costume.position.y + SCREEN_HEIGHT_HALF/1.5f) % SCREEN_HEIGHT)];
    
    NSString *_strScoreValue;
    int _scoreValue = (int)(player.costume.position.y + (labelScoreStr1.spr.position.y - SCREEN_HEIGHT));
        if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue > 10000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            if (_scoreValue > 1000) {
                _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
            } else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(player.costume.position.y  + (labelScoreStr1.spr.position.y - SCREEN_HEIGHT))];
            }
        }
    [labelScoreStr1 setText:_strScoreValue];
        
    
    _scoreValue = (int)(player.costume.position.y + (labelScoreStr2.spr.position.y - SCREEN_HEIGHT));
    if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue > 10000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            if (_scoreValue > 1000) {
                _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
            } else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(player.costume.position.y + (labelScoreStr2.spr.position.y - SCREEN_HEIGHT))];
            }
    }
    [labelScoreStr2 setText:_strScoreValue];
    
    _scoreValue = (int)(player.costume.position.y + (labelScoreStr3.spr.position.y - SCREEN_HEIGHT));
    if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue > 10000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            if (_scoreValue > 1000) {
                _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
            } else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(player.costume.position.y + (labelScoreStr3.spr.position.y - SCREEN_HEIGHT))];
            }
    }
    [labelScoreStr3 setText:_strScoreValue];
}

- (void) bombExplosion:(ActorActiveBombObject*)_tempActor {
    float _tempActorX = _tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x;
    float _tempActorY = _tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y;
    
    float _distance = [[Utils instance] distance:SCREEN_WIDTH_HALF _y1:SCREEN_HEIGHT_HALF _x2:_tempActorX _y2:_tempActorY];
    if (_distance < elementSize) _distance = elementSize;
    
    float _power = (1 - _distance/SCREEN_HEIGHT_HALF)*10.0f;
    
    CCLOG(@"_power = %f, _distance = %f", _power, _distance);
    float _angle = [Utils GetAngleBetweenPt1:ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF) andPt2:ccp(_tempActorX,_tempActorY)];
    
    [player addVelocity:ccp(_power*cos(CC_DEGREES_TO_RADIANS(_angle)),_power*sin(CC_DEGREES_TO_RADIANS(_angle)))];
}

- (void) bonusTouchReaction:(int)_bonusID {
    if (_bonusID <= BONUS_ARMOR) {
        // Включаем броню
        [player addArmor];
    } else
        if (_bonusID <= BONUS_ACCELERATION) {
            // Ускорение
            [player addVelocity:ccp(0, [Defs instance].bonusAccelerationValue)];
        } else
            if (_bonusID <= BONUS_APOCALYPSE) {
                // Апокалипсис
                Actor* _tempActor;
                int _count = [[Defs instance].actorManager.actorsAll count];
                for (int i = 0; i < _count; i++) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
                    if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)) {
                        if (([_tempActor isKindOfClass:[ActorActiveBombObject class]])
                            &&(![self checkIsOutOfScreen:_tempActor])){
                            [self bombExplosion:(ActorActiveBombObject*)_tempActor];
                            [_tempActor touch];
                        }
                    }
                }
            } else
                if (_bonusID <= BONUS_GODMODE) {
                    // устанавливаем режим бога
                    [player setGodMode:[Defs instance].bonusGodModeTime];
                }
}

- (BOOL) checkIsOutOfScreen:(Actor*)_tempActor {
    if ((_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x <= -elementRadius)
        ||(_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x >= SCREEN_WIDTH+  elementRadius)
        ||(_tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y <= -elementRadius)
        ||(_tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y >= SCREEN_HEIGHT+elementRadius)) return YES;
    return NO;
}

- (void) update {
    if (state != GAME_STATE_LEVELFINISH) {
    if (([Defs instance].closeAnimationPanel) && ([Defs instance].isOpenScreenAnimation)) {
        if ([Defs instance].closeAnimationPanel.spr.opacity >= 25) [Defs instance].closeAnimationPanel.spr.opacity -= 25; else {
            [[Defs instance].closeAnimationPanel.spr setOpacity:0];
            [[Defs instance].closeAnimationPanel show:NO];
            [Defs instance].isOpenScreenAnimation = NO;
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
        }
    }
    
    
    if (state == GAME_STATE_LEVELFINISH) [levelFinishScreen update];
	
	if ((GAME_IS_PLAYING)&&((state & (GAME_STATE_GAMEPAUSE)) == 0)) {
		
		levelTime += TIME_STEP;
        
        if (player.costume.position.y < SCREEN_HEIGHT_HALF) {
            [self levelFinishCloseAnimationStart];
            return;
        }
        
        Actor *_tempActor;
        float _distanceToActor;
        float _minDistance = elementSize;
        int _count = [[Defs instance].actorManager.actorsAll count];
        for (int i = 0; i < _count; i++) {
            _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
            if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)&&([_tempActor isKindOfClass:[ActorActiveObject class]])
                &&(![self checkIsOutOfScreen:_tempActor])) {
                _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x _y1:_tempActor.costume.position.y _x2:player.costume.position.x _y2:player.costume.position.y];
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
                _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x _y1:_tempActor.costume.position.y _x2:player.costume.position.x _y2:player.costume.position.y];
                if (_distanceToActor > _minDistance) {
                    [(ActorActiveObject*)_tempActor deactivate];
                }
            }
        }
        
        [self labelScoreBarUpdate];
        
        timerAddBall += TIME_STEP;
        if (timerAddBall >= timerDelayAddBall - fabs(player.velocity.x/300)) {
            float _velocityXCoeff = 1 + fabs(player.velocity.x/10);
            float _velocityYCoeff = (1 + fabs(player.velocity.y/30))*3 + CCRANDOM_0_1()*(fabs(player.velocity.y/30));
            if (_velocityYCoeff < 4) _velocityYCoeff = 4;
            int _ballCount = round(CCRANDOM_0_1()*2);
            for (int i = 0; i < _ballCount; i++) {
                [self addBall:ccp(player.costume.position.x + player.velocity.x*5 + SCREEN_WIDTH_HALF*CCRANDOM_MINUS1_1(), player.costume.position.y - SCREEN_HEIGHT_HALF - elementRadius) _velocity:ccp(player.velocity.x + CCRANDOM_MINUS1_1()*_velocityXCoeff, player.velocity.y + _velocityYCoeff) _active:YES];
            }
            
            timerAddBall = 0;
        }
        
        if (scoreLevel < (int)(player.costume.position.y - SCREEN_HEIGHT_HALF)) {
            scoreLevel = (int)(player.costume.position.y - SCREEN_HEIGHT_HALF);
            [scoreStr setPosition:ccp(scoreStrPos.x + [[Utils instance] myRandom2F]*2, scoreStrPos.y + [[Utils instance] myRandom2F]*2)];
            [scoreStr setText:[NSString stringWithFormat:@"%i",scoreLevel]];
        }
        
        [cells update];
        
        [[Defs instance].actorManager update];
        CGPoint centerOfScreen = ccp(player.costume.position.x, player.costume.position.y);
        [self setCenterOfTheScreen:centerOfScreen];
    }

}

- (void) show:(BOOL)_flag{
	if (isVisible != _flag) {
	
		isVisible = _flag;
	
		if (isVisible){
            [[GameStandartFunctions instance] playOpenScreenAnimation];
		}else {
		}
	}
    [cells show:_flag];
    [[Defs instance].actorManager show:_flag];
}

- (BOOL) ccTouchBegan:(CGPoint)_touchPos{
	if (!isPause) {
			
		if (state != GAME_STATE_LEVELFINISH) {
			if (GAME_IS_PLAYING) {
                
                Actor* _tempActor;
                float _distanceToActor = 0;
                //NSMutableArray *_actorArr = [NSMutableArray arrayWithCapacity:3];
                float _minDistance = 9999;
                int _actorWithMinDistanceID = -1;
                int _count = [[Defs instance].actorManager.actorsAll count];
                for (int i = 0; i < _count; i++) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
                    if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)
                        &&([_tempActor isKindOfClass:[ActorActiveObject class]])
                        &&(![self checkIsOutOfScreen:_tempActor])) {
                            _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x _y1:_tempActor.costume.position.y+ [Defs instance].objectFrontLayer.position.y _x2:_touchPos.x _y2:_touchPos.y];
                            if (_distanceToActor < elementSize) {
                                if (_minDistance > _distanceToActor) {
                                    _minDistance = _distanceToActor;
                                    _actorWithMinDistanceID = i;
                                }
                            }
                        }
                }
                
                if (_actorWithMinDistanceID != -1) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:_actorWithMinDistanceID];
                    
                    if ([_tempActor isKindOfClass:[ActorActiveBombObject class]]) {
                        [self bombExplosion:(ActorActiveBombObject*)_tempActor];
                        if (CCRANDOM_0_1() < [Defs instance].bonusGetChance) {
                            [self addBonus:_tempActor.costume.position _velocity:player.velocity _active:YES];
                        }
                    }
                    
                    [_tempActor touch];
                    
                    _tempActor = nil;
                    
                    return YES;
                }
                
			}

		}else {
			return [levelFinishScreen ccTouchBegan:_touchPos];
		}
	}
	
	return NO;
}

-(void) ccTouchEnded:(CGPoint)_touchPos {
	if (state == GAME_STATE_LEVELFINISH) {
		[levelFinishScreen ccTouchEnded:_touchPos];
	}
}

-(void) ccTouchMoved:(CGPoint)_touchLocation
	   _prevLocation:(CGPoint)_prevLocation 
			   _diff:(CGPoint)_diff {	

	if (state == GAME_STATE_LEVELFINISH) {
		[levelFinishScreen ccTouchMoved:_touchLocation _prevLocation:_prevLocation _diff:_diff];
	}
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {

}

- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end