//
//  ZMenu.m
//  Beltality
//
//  Created by Mac Mini on 06.11.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import "ZMenu.h"
#import "Defs.h"
#import "globalParam.h"
#import "GameStandartFunctions.h"
#import "SimpleAudioEngine.h"
#import "GUIButtonDef.h"
#import "GUILabelTTFDef.h"
#import "GUICheckBoxDef.h"
#import "Utils.h"
#import "GameStandartFunctions.h"
#import "GameKit/GameKit.h"
#import "GameCenter.h"
#import "Utils.h"
#import "GUIPanel.h"
#import "MainScene.h"
#import "AnalyticsData.h"
#import "FlurryAnalytics.h"
#import "MyData.h"

@implementation ZMenu


- (void) sliderPanelsHide {
    isSlideLeftAction = YES;
	isSlideLeftUp = NO;
    slideLeftTarget = 0;
    [btnSound setEnabled:NO];
    [btnMusic setEnabled:NO];
    [btnReset setEnabled:NO];
    
    if (rightMenuSlider == nil) return;
    isSlideRightAction = YES;
	isSlideRightUp = NO;
    slideRightTarget = 0;
    [btnAward setEnabled:NO];
    [btnScore setEnabled:NO];
    [btnVideo setEnabled:NO];
}

- (void) buttonTwitterAction {
    [[GameStandartFunctions instance] goToUrl:URL_TWITTER];
    [FlurryAnalytics logEvent:ANALYTICS_MAIN_MENU_BUTTON_TWITTER_CLICKED];
}

- (void) buttonFacebookAction {
#if MACROS_LITE_VERSION
    if ([Defs instance].liteVersionFacebookLike == 0) {
        [Defs instance].liteVersionLevelsCountAvailable +=2;
        [MyData setStoreValue:@"liteVersionLevelsCountAvailable" value:[NSString stringWithFormat:@"%d",[Defs instance].liteVersionLevelsCountAvailable]];
        [Defs instance].liteVersionFacebookLike = 1;
        [MyData setStoreValue:@"liteVersionFacebookLike" value:@"1"];
    }
#endif
	[[GameStandartFunctions instance] goToUrl:URL_FACEBOOK];
    [FlurryAnalytics logEvent:ANALYTICS_MAIN_MENU_BUTTON_FACEBOOK_CLICKED];
}

- (void) buttonWalktroughAction {
	[[GameStandartFunctions instance] goToUrl:URL_VIDEO];
    [FlurryAnalytics logEvent:ANALYTICS_MAIN_MENU_BUTTON_VIDEO_CLICKED];
    [self sliderPanelsHide];
    
}

- (void) settingSliderFastHide {
	[checkBoxSettings setChecked:NO];
	isSlideLeftAction = NO;
	isSlideLeftUp = NO;
	[leftMenuSlider setPosition:ccp(leftMenuSlider.spr.position.x,0)];
	
	[checkBoxOnline setChecked:NO];
	isSlideRightAction = NO;
	isSlideRightUp = NO;
	if (rightMenuSlider!= nil) [rightMenuSlider setPosition:ccp(rightMenuSlider.spr.position.x,0)];
}

- (void) buttonPlayClick { 
    [[GameStandartFunctions instance] playCloseScreenAnimation:0];
}

- (void) buttonPlayAction {    
	[self settingSliderFastHide];
    
    [self show:NO];
    
    if ((![Defs instance].isPlayGameBefore == 0)) {
        [Defs instance].isPlayGameBefore = YES;   
        //[[Defs instance].userSettings setBool:YES forKey:@"isPlayGameBefore"];
        [MyData setStoreValue:@"isPlayGameBefore" value:@"YES"];
        [Defs instance].currentMusicTheme = 1;
        [[GameStandartFunctions instance] playCurrentBackgroundMusicTrack];
    }
    
    [[MainScene instance].game levelStart];
    
    [FlurryAnalytics logEvent:ANALYTICS_MAIN_MENU_BUTTON_PLAY_CLICKED];
}

- (void) buttonMarketClick { 
    [[GameStandartFunctions instance] playCloseScreenAnimation:1];
}

- (void) buttonMarketAction {
	[self settingSliderFastHide];
	[[MainScene instance] showMarketScreen:GAME_STATE_MENU];
}

- (void) buttonGameCenterLeaderboardAction {
    [FlurryAnalytics logEvent:ANALYTICS_MAIN_MENU_BUTTON_LEADERBOARD_CLICKED];
    [self settingSliderFastHide];
    [[GameCenter instance] showLeaderboard];
}

- (void) buttonGameCenterAchievementAction {
    [FlurryAnalytics logEvent:ANALYTICS_MAIN_MENU_BUTTON_ACHIEVEMENT_CLICKED];
    [self settingSliderFastHide];
    [[GameCenter instance] showAchievements]; 
}

- (void) buttonCreditsClick { 
    [[GameStandartFunctions instance] playCloseScreenAnimation:2];
    [FlurryAnalytics logEvent:ANALYTICS_MAIN_MENU_BUTTON_CREITS_CLICKED];
}

- (void) buttonCreditsAction {
	[self settingSliderFastHide];
	[[MainScene instance] showCredits];
}

- (void) checkBoxRestartLevelProgressAction {
	[panelRestartGameProgress show:YES];
    [labelPanelRestartGameProgress show:YES];
	[btnRestartGameProgressNO setEnabled:YES];
	[btnRestartGameProgressYES setEnabled:YES];
	[btnPlay show:NO];
    
    [self sliderPanelsHide];
    [checkBoxSettings setEnabled:NO];
    [btnMarket setEnabled:NO];
    [btnShop setEnabled:NO];
    if ([GameCenter instance].isAvailable) {
        [checkBoxOnline setEnabled:NO];
    } else
    {
        /*[btnTwitter setEnabled:NO];
        [btnFacebook setEnabled:NO];
        [btnVideo setEnabled:NO];*/
    }
}

- (void) checkBoxRestartLevelProgressPanelHide {
	[panelRestartGameProgress show:NO];
    [labelPanelRestartGameProgress show:NO];
	[btnRestartGameProgressNO setEnabled:NO];
	[btnRestartGameProgressYES setEnabled:NO];
	[btnPlay show:YES];
    
    [checkBoxSettings setEnabled:YES];
    [btnMarket setEnabled:YES];
    [btnShop setEnabled:YES];
    if ([GameCenter instance].isAvailable) {
        [checkBoxOnline setEnabled:YES];
    } else
    {
        /*[btnTwitter setEnabled:YES];
        [btnFacebook setEnabled:YES];
        [btnVideo setEnabled:YES];*/
    }
}

- (void) restartLevelProgress {

	[self checkBoxRestartLevelProgressPanelHide];
    [FlurryAnalytics logEvent:ANALYTICS_GAME_RESET];
}

- (void) checkBoxSettingSliderPush {
	isSlideLeftAction = YES;
	isSlideLeftUp = !isSlideLeftUp;
	if (isSlideLeftUp) {
		slideLeftTarget = leftMenuSlider.spr.contentSize.height+13;
        [btnSound setEnabled:YES];
        [btnMusic setEnabled:YES];
        [btnReset setEnabled:YES];
	} else {
		slideLeftTarget = 0;
		[btnSound setEnabled:NO];
        [btnMusic setEnabled:NO];
		[btnReset setEnabled:NO];
	}
}

- (void) checkBoxOnlineSliderPush {
	if (rightMenuSlider == nil) return;
    isSlideRightAction = YES;
	isSlideRightUp = !isSlideRightUp;
	if (isSlideRightUp) {
		slideRightTarget = rightMenuSlider.spr.contentSize.height+13;
        [btnAward setEnabled:YES];
		[btnScore setEnabled:YES];
		[btnVideo setEnabled:YES];
	} else {
		slideRightTarget = 0;
		[btnAward setEnabled:NO];
		[btnScore setEnabled:NO];
		[btnVideo setEnabled:NO];
	}
}

- (id) init{
	if ((self = [super init])) {
		isVisible = NO;
        if ([Defs instance].iPhone5)
            backSpr = [CCSprite spriteWithFile:@"menu_back_iPhone5.jpg"];
        else
            backSpr = [CCSprite spriteWithFile:@"menu_back.jpg"];
        
		backSpr.position = ccp(SCREEN_WIDTH_HALF,SCREEN_HEIGHT_HALF);
		[backSpr retain];
		
		logoVelocity = ccp(0,0);
	
		GUIPanelDef *panelDef = [GUIPanelDef node];
        //panelDef.parentFrame = [Defs instance].objectBackLayer;
        panelDef.enabled = NO;
		panelDef.sprName = @"slideLeftMenu.png";
		panelDef.group = GAME_STATE_MENU;
        panelDef.zIndex = 3;
		leftMenuSlider = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(28, 0)];
		[leftMenuSlider.spr setAnchorPoint:ccp(0.5f,1)];
		
		isSlideLeftAction = NO;
		isSlideLeftUp = NO;
		slideLeftTarget = 0;
		
        panelDef.parentFrame = [MainScene instance].gui;
        panelDef.group = GAME_STATE_NONE;
        panelDef.enabled = NO;
		panelDef.sprName = @"window_reset.png";
        panelDef.zIndex = 50;
		panelRestartGameProgress = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,200)];
        
        panelDef.group = GAME_STATE_MENU;
        
        //panelDef.parentFrame = [Defs instance].objectBackLayer;
        panelDef.sprName = @"star_menu.png";
        panelDef.zIndex = 1;
		panelHighlight = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,350)];
        [panelHighlight.spr setScaleX:3.5f];
        [panelHighlight.spr setScaleY:3.5f];
        
        panelDef.parentFrame = [MainScene instance].gui;
        panelDef.sprName = @"logo.png";
        panelDef.enabled = NO;
		panelLogo = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,350)];
        
        panelDef.group = GAME_STATE_NONE;
        panelDef.sprName = nil;
        panelDef.sprFileName = @"blackScreen.jpg";
        panelDef.zIndex = 100;
        panelDef.parentFrame = [MainScene instance];
        [Defs instance].closeAnimationPanel = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,SCREEN_HEIGHT_HALF)];
        if ([Defs instance].iPhone5) {
            [[Defs instance].closeAnimationPanel.spr setScaleX:2.37f];
            [[Defs instance].closeAnimationPanel.spr setScaleY:2];
        }
        else
            if ([Defs instance].screenHD) [[Defs instance].closeAnimationPanel.spr setScale:2];
        
        GUILabelTTFOutlinedDef *labelTTFOutlinedDef = [GUILabelTTFOutlinedDef node];
        labelTTFOutlinedDef.group = GAME_STATE_NONE;
        labelTTFOutlinedDef.fontSize = 22;
        labelTTFOutlinedDef.textColor = ccc3(255,255,255);
        labelTTFOutlinedDef.outlineColor = ccc3(0,0,0);
        labelTTFOutlinedDef.outlineSize = 2;
        labelTTFOutlinedDef.text = NSLocalizedString(@"Restart Progress?",@"");
        labelPanelRestartGameProgress = [[MainScene instance].gui addItem:(id)labelTTFOutlinedDef _pos:
                                         ccp(panelRestartGameProgress.spr.position.x,panelRestartGameProgress.spr.position.y + panelRestartGameProgress.spr.contentSize.height*0.25f)];
        
        float _textSize = 1;
        if ([[Defs instance].currentLanguage isEqualToString:@"fr"]) {
            _textSize = 0.9f; 
        } 
        [labelPanelRestartGameProgress.spr setScale:_textSize];
		
		GUIButtonDef *btnPlayDef = [GUIButtonDef node];
		btnPlayDef.sprName = @"btnPlay.png";
		btnPlayDef.sprDownName = @"btnPlayDown.png";
		btnPlayDef.group = GAME_STATE_MENU;
		btnPlayDef.objCreator = self;
		btnPlayDef.func = @selector(buttonPlayClick);
		btnPlayDef.sound = @"button_click.wav";
		
		btnPlay = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(SCREEN_WIDTH_HALF,200)];
        
        btnPlayDef.sprName = @"btnShop.png";
		btnPlayDef.sprDownName = @"btnShopDown.png";
		btnPlayDef.func = @selector(buttonMarketClick);
		
		btnShop = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(35,SCREEN_HEIGHT - 35)];
		
		btnPlayDef.sprName = @"btnCreditsBallon.png";
		btnPlayDef.sprDownName = @"btnCreditsBallon.png";
		btnPlayDef.func = @selector(buttonCreditsClick);
        btnPlayDef.zIndex = 9;
		
		btnMarket = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(160,SCREEN_HEIGHT - 50)];
        
        panelDef.group = GAME_STATE_MENU;
        panelDef.sprName = @"lightMarket.png";
		panelDef.enabled = YES;
        panelDef.zIndex = 8;
        panelDef.parentFrame = [MainScene instance].gui;
        panelMarket = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(26,23)];
       
        isPanelMarketOpacityAlpaAdd = NO;
        panelMarketOpacity = 255;
        
        btnPlayDef.isManyTouches = YES;
        btnPlayDef.sprName = @"iconFacebook.png";
        btnPlayDef.sprDownName = @"iconFacebook.png";
        btnPlayDef.func = @selector(buttonFacebookAction);
        btnFacebook = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(SCREEN_WIDTH - 135,20)];
        
        btnPlayDef.sprName = @"iconTwitter.png";
        btnPlayDef.sprDownName = @"iconTwitter.png";
        btnPlayDef.func = @selector(buttonTwitterAction);
        btnTwitter = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(SCREEN_WIDTH - 80,20)];
        
		btnPlayDef.sprName = @"btnReset.png";
		btnPlayDef.sprDownName = @"btnResetDown.png";
		btnPlayDef.parentFrame = leftMenuSlider.spr;
		btnPlayDef.func = @selector(checkBoxRestartLevelProgressAction);
        btnPlayDef.isManyTouches = YES;
		//btnPlayDef.enabled = NO;
		
		btnReset = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(leftMenuSlider.spr.contentSize.width*0.5f,165)];
        
        GUICheckBoxDef *checkBoxSoundDef = [GUICheckBoxDef node];
		checkBoxSoundDef.sprName = @"btnSetting.png";
		checkBoxSoundDef.sprOneDownName = @"btnSettingDown.png";
		checkBoxSoundDef.sprTwoName = @"btnSettingChecked.png";
		checkBoxSoundDef.sprTwoDownName = @"btnSettingCheckedDown.png";
		checkBoxSoundDef.group = GAME_STATE_MENU;
		checkBoxSoundDef.objCreator = self;
		checkBoxSoundDef.func = @selector(checkBoxSettingSliderPush);
		checkBoxSoundDef.sound = @"button_click.wav";
        checkBoxSoundDef.zIndex = 4;
		
		checkBoxSettings = [[MainScene instance].gui addItem:(id)checkBoxSoundDef _pos:ccp(28,25)];
		
    if ([GameCenter instance].isAvailable) {
        
        //panelDef.parentFrame = [Defs instance].objectBackLayer;
        panelDef.enabled = NO;
        panelDef.sprName = @"slideLeftMenu.png";
		panelDef.group = GAME_STATE_MENU;
        panelDef.zIndex = 3;
        rightMenuSlider = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH - 28, 0)];
		[rightMenuSlider.spr setAnchorPoint:ccp(0.5f,1)];
		
		isSlideRightAction = NO;
		isSlideRightUp = NO;
		slideRightTarget = 0;
        
        checkBoxSoundDef.sprName = @"btnMenu.png";
		checkBoxSoundDef.sprOneDownName = @"btnMenuDown.png";
		checkBoxSoundDef.sprTwoName = @"btnMenuChecked.png";
		checkBoxSoundDef.sprTwoDownName = @"btnMenuCheckedDown.png";
		checkBoxSoundDef.func = @selector(checkBoxOnlineSliderPush);
        checkBoxSoundDef.zIndex = 3;
		
		checkBoxOnline = [[MainScene instance].gui addItem:(id)checkBoxSoundDef _pos:ccp(SCREEN_WIDTH - 28,25)];
        
		btnPlayDef.sprName = @"btn_score.png";
		btnPlayDef.sprDownName = @"btn_score.png";
		btnPlayDef.parentFrame = rightMenuSlider.spr;
		btnPlayDef.func = @selector(buttonGameCenterLeaderboardAction);
        btnPlayDef.enabled = YES;
		
		btnScore = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(rightMenuSlider.spr.contentSize.width*0.5f,65)];
		
		btnPlayDef.sprName = @"btn_award.png";
		btnPlayDef.sprDownName = @"btn_award.png";
		btnPlayDef.parentFrame = rightMenuSlider.spr;
		btnPlayDef.func = @selector(buttonGameCenterAchievementAction);
		
		btnAward = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(rightMenuSlider.spr.contentSize.width*0.5f,115)];
		
		btnPlayDef.sprName = @"iconWalktrough.png";
		btnPlayDef.sprDownName = @"iconWalktrough.png";
		btnPlayDef.parentFrame = rightMenuSlider.spr;
		btnPlayDef.func = @selector(buttonWalktroughAction);
		
		btnVideo = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(rightMenuSlider.spr.contentSize.width*0.5f,165)];
        
    } else {
        
        rightMenuSlider = nil;
        
        btnPlayDef.sprName = @"iconWalktrough.png";
		btnPlayDef.sprDownName = @"iconWalktrough.png";
		btnPlayDef.parentFrame = [MainScene instance].gui;
		btnPlayDef.func = @selector(buttonWalktroughAction);
		
		btnVideo = [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(SCREEN_WIDTH - 25,20)];
    }
		
        btnPlayDef.isManyTouches = YES;
		btnPlayDef.sprName = @"btnNo.png";
		btnPlayDef.sprDownName = @"btnNoDown.png";
		btnPlayDef.parentFrame = panelRestartGameProgress.spr;
		btnPlayDef.func = @selector(checkBoxRestartLevelProgressPanelHide);
		btnPlayDef.enabled = NO;
		
		btnRestartGameProgressNO = [[MainScene instance].gui addItem:(id)btnPlayDef 
									 _pos:ccp(panelRestartGameProgress.spr.contentSize.width*0.5f-50,panelRestartGameProgress.spr.contentSize.height*0.25f)];
		
		btnPlayDef.sprName = @"btnOk.png";
		btnPlayDef.sprDownName = @"btnOkDown.png";
		btnPlayDef.func = @selector(restartLevelProgress);
		
		btnRestartGameProgressYES = [[MainScene instance].gui addItem:(id)btnPlayDef 
									 _pos:ccp(panelRestartGameProgress.spr.contentSize.width*0.5f+50,panelRestartGameProgress.spr.contentSize.height*0.25f)];
		
        checkBoxSoundDef.sprName = @"btnMusicOnSlider.png";
		checkBoxSoundDef.sprOneDownName = @"btnMusicOnSliderDown.png";
		checkBoxSoundDef.sprTwoName = @"btnMusicOffSlider.png";
		checkBoxSoundDef.sprTwoDownName = @"btnMusicOffSliderDown.png";
		checkBoxSoundDef.parentFrame = leftMenuSlider.spr;
		checkBoxSoundDef.objCreator = [GameStandartFunctions instance];
		checkBoxSoundDef.func = @selector(checkBoxEnableMusicAction);
		checkBoxSoundDef.checked = [Defs instance].isMusicMute;
		checkBoxSoundDef.enabled = NO;
		
		btnMusic = [[MainScene instance].gui addItem:(id)checkBoxSoundDef _pos:ccp(leftMenuSlider.spr.contentSize.width*0.5f,115)];
        
        checkBoxSoundDef.sprName = @"btnSoundSlide.png";
		checkBoxSoundDef.sprOneDownName = @"btnSoundSlideDown.png";
		checkBoxSoundDef.sprTwoName = @"btnSoundSlideOff.png";
		checkBoxSoundDef.sprTwoDownName = @"btnSoundSlideOffDown.png";
		checkBoxSoundDef.func = @selector(checkBoxEnableSoundAction);
		checkBoxSoundDef.checked = [Defs instance].isSoundMute;
		
		btnSound = [[MainScene instance].gui addItem:(id)checkBoxSoundDef _pos:ccp(leftMenuSlider.spr.contentSize.width*0.5f,65)];       
		
		rotationState = 0;
		rotationSpd = 2;
        
        marketGoSpeed = 0.17f;
	
		//btnLeaderboard = [[Defs instance].myFont textOut:ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT - 240) _str:@"LEADERBOARD-CRYSTAL"];
		//[btnLeaderboard retain];
		
		//tip = [[Tips alloc] init];
		}
	return self;
}

- (void) update {
	/*[btnMarket setPosition:ccp([[Utils instance] aspire:btnMarket.spr.position.x _aim:SCREEN_WIDTH_HALF _speed:0.1],btnMarket.spr.position.y)]; */ 
    
    if ([Defs instance].isOpenScreenAnimation) {
        if ([Defs instance].closeAnimationPanel.spr.opacity >= 25) [Defs instance].closeAnimationPanel.spr.opacity -= 25; else {
            [[Defs instance].closeAnimationPanel.spr setOpacity:0];
            [[Defs instance].closeAnimationPanel show:NO];
            [Defs instance].isOpenScreenAnimation = NO;
        }
    } else    
    if ([Defs instance].isCloseScreenAnimation) {
        if ([Defs instance].closeAnimationPanel.spr.opacity <= 225) [Defs instance].closeAnimationPanel.spr.opacity += 25; else
        {
            [Defs instance].isCloseScreenAnimation = NO;
            [[Defs instance].closeAnimationPanel.spr setOpacity:255];
            if ([Defs instance].afterCloseAnimationScreenType == 0) {
                [self buttonPlayAction];
            } else
                if ([Defs instance].afterCloseAnimationScreenType == 1) {
                    [self buttonMarketAction];
                } else
                    if ([Defs instance].afterCloseAnimationScreenType == 2) {
                        [self buttonCreditsAction];
                    }
            return;
        }
    }
    
    panelHighlight.spr.rotation += 0.5f;
    if (panelHighlight.spr.rotation > 360) panelHighlight.spr.rotation -= 360;
    
	CGPoint pos = btnMarket.spr.position;
	pos.x += logoVelocity.x;
	
	float leftBorder = 80;
	float rightBorder = SCREEN_WIDTH - 30;
	
	if (pos.x < leftBorder) {
		pos.x = leftBorder;
		logoVelocity = CGPointZero;
	} else if (pos.x > rightBorder) {
		pos.x = rightBorder;
		logoVelocity = CGPointZero;
	}
    
    float _marketGoSpeedAcc = 0.01f;
    
    if (pos.y > (SCREEN_HEIGHT - 50)) _marketGoSpeedAcc = -0.01f;
        
    marketGoSpeed += _marketGoSpeedAcc;
    
    pos.y += marketGoSpeed;
	
	[btnMarket setPosition:pos];
    [panelMarket setPosition:pos];
    
    if (isPanelMarketOpacityAlpaAdd) {
        if (panelMarketOpacity < 253) panelMarketOpacity += 3; else isPanelMarketOpacityAlpaAdd = NO;
    } else {
         if (panelMarketOpacity > 100) panelMarketOpacity -= 3; else isPanelMarketOpacityAlpaAdd = YES;
    }
    [panelMarket.spr setOpacity:panelMarketOpacity];
	
	/*if (rotationState == 0) {
		btnMarket.rotation = [[Utils instance] aspire:btnMarket.rotation _aim:3 _speed:0.3f];  
		if (6 - btnMarket.rotation < 1) {
			//logoSpr.rotation += rotationSpd;
			rotationState = 1;
		} else {
			//rotationState = 1;
		}
	} else 
		if(rotationState == 1) {
			btnMarket.rotation = [[Utils instance] aspire:btnMarket.rotation _aim:-3 _speed:0.3f];
			if (fabs(btnMarket.rotation + 6) < 1) {
				//logoSpr.rotation -= rotationSpd;
				rotationState = 0;
			} else {
				//rotationState = 0;
			}
		}*/
	
	if (isSlideLeftAction) {		
		[leftMenuSlider setPosition:ccp(leftMenuSlider.spr.position.x,
									   [[Utils instance] aspire:leftMenuSlider.spr.position.y _aim:slideLeftTarget
														 _speed:fabs(leftMenuSlider.spr.position.y-slideLeftTarget)/5])];
		
		if ((isSlideLeftUp)&&((slideLeftTarget - leftMenuSlider.spr.position.y) <= 1)) {
			[leftMenuSlider setPosition:ccp(leftMenuSlider.spr.position.x,slideLeftTarget)];
			isSlideLeftAction = NO;
		} else 
		if ((!isSlideLeftUp)&&((leftMenuSlider.spr.position.y - slideLeftTarget) <= 1)) {
			leftMenuSlider.spr.position = ccp(leftMenuSlider.spr.position.x,slideLeftTarget);
			isSlideLeftAction = NO;
		}

	}
	
    if (rightMenuSlider!= nil)
	if (isSlideRightAction) {		
		[rightMenuSlider setPosition:ccp(rightMenuSlider.spr.position.x,
									  [[Utils instance] aspire:rightMenuSlider.spr.position.y _aim:slideRightTarget
														_speed:fabs(rightMenuSlider.spr.position.y-slideRightTarget)/5])];
		
		if ((isSlideRightUp)&&((slideRightTarget - rightMenuSlider.spr.position.y) <= 1)) {
			[rightMenuSlider setPosition:ccp(rightMenuSlider.spr.position.x,slideRightTarget)];
			isSlideRightAction = NO;
		} else 
			if ((!isSlideRightUp)&&((rightMenuSlider.spr.position.y - slideRightTarget) <= 1)) {
				[rightMenuSlider setPosition:ccp(rightMenuSlider.spr.position.x,slideRightTarget)];
				isSlideRightAction = NO;
			}
		
	}
}
	
- (void) show:(BOOL)_flag{
	if (isVisible == _flag) return;
	
	isVisible = _flag;
	if (isVisible){
        [[GameStandartFunctions instance] playOpenScreenAnimation];        
        
		if (backSpr.parent == nil) [self addChild:backSpr z:0];
		[self checkBoxRestartLevelProgressPanelHide];
		[btnSound setChecked:[Defs instance].isSoundMute];
        [btnMusic setChecked:[Defs instance].isMusicMute];

	} else { 
		if (backSpr.parent != nil) [backSpr removeFromParentAndCleanup:YES];
	}
	//[tip show:_flag];
    
    /*#if MACROS_LITE_VERSION
        [btnPlay show:NO];
    #else
        btnPlay.spr.opacity = 128;
    #endif*/
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	//logoSpr.rotation += acceleration.z/10;
	//if (acceleration.x < -1)
	float deceleration = 0.9f;
	float sensitivity = 0.3f;
	float maxVelocity = 15;
	
	logoVelocity.x = logoVelocity.x * deceleration - acceleration.y * sensitivity;
	
	if (logoVelocity.x > maxVelocity) logoVelocity.x = maxVelocity; else
		if (logoVelocity.x < - maxVelocity) logoVelocity.x = -maxVelocity;
	
    btnMarket.spr.rotation *= 0.8f;
    
    btnMarket.spr.rotation -= acceleration.y * 3.2f;
    
	//logoSpr.position = ccp(logoSpr.position.x-acceleration.y,logoSpr.position.y);
}

- (void) touchReaction:(CGPoint)_touchPos {	
	//[self sliderPanelsHide];
}

- (void) dealloc{
	[backSpr release];
    backSpr = nil;
	//[tip release];
	[super dealloc];
}

@end