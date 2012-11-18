//
//  ZMenu.h
//  Beltality
//
//  Created by Mac Mini on 06.11.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIButton.h"
#import "GUICheckBox.h"
#import "GUIPanel.h"
#import "GUILabelTTFOutlined.h"

@interface ZMenu : CCNode {
	BOOL isVisible;
	CCSprite *backSpr;
	CGPoint logoVelocity;
	GUIButton *btnPlay;
	float rotationState;
	float rotationSpd;
	
	CGPoint endTouchPos;
	
	GUIPanel *leftMenuSlider;
	BOOL isSlideLeftAction;
	BOOL isSlideLeftUp;
	float slideLeftTarget;
	GUICheckBox *checkBoxSettings;
	
	GUIPanel *rightMenuSlider;
	BOOL isSlideRightAction;
	BOOL isSlideRightUp;
	float slideRightTarget;
	GUICheckBox *checkBoxOnline;
	
	GUIPanel *panelRestartGameProgress;
	GUIPanel *panelLogo;
    GUIPanel *panelHighlight;
	GUIButton *btnReset;
    GUIButton *btnScore;
    GUIButton *btnAward;
	GUIButton *btnTwitter;
	GUIButton *btnFacebook;
	GUIButton *btnVideo;
	GUICheckBox *btnSound;
    GUICheckBox *btnMusic;
	GUIButton *btnRestartGameProgressNO;
	GUIButton *btnRestartGameProgressYES;
    GUIButton *btnMarket;
    GUIPanel *panelMarket;
    BOOL isPanelMarketOpacityAlpaAdd;
    GLubyte panelMarketOpacity;
    GUILabelTTFOutlined *labelPanelRestartGameProgress;
    GUIButton *btnShop;
    
    float marketGoSpeed;
}

- (id) init;
- (void) update;
- (void) show:(BOOL)_flag;
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void) touchReaction:(CGPoint)_touchPos;
- (void) dealloc;
@end