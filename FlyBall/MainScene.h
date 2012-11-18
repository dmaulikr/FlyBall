//
//  MainScene.h
//  FlyBall
//
//  Created by Zakhar Gadzhiev on 14.11.12.
//  Copyright Zakhar Gadzhiev 2012. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "ZMenu.h"
#import "ZGame.h"
#import "MarketScreen.h"
#import "PauseScreen.h"
#import "GUIInterface.h"
#import "AboutScreen.h"

@interface MainScene : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	ZMenu *menu;
	PauseScreen *pauseScreen;
	MarketScreen *marketScreen;
	GUIInterface *gui;
	AboutScreen *aboutScreen;
}

@property (nonatomic, assign) ZGame *game;
@property (nonatomic, assign) PauseScreen *pauseScreen;
@property (nonatomic, assign) MarketScreen *marketScreen;
@property (nonatomic, assign) GUIInterface *gui;

+(MainScene*) instance;
// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

-(void) update:(ccTime)dt;
- (void) showCredits;
- (void) showMoreGamesScreen;
- (void) showMenu;
- (void) showMarketScreen:(int)_state;
- (void) showGamePause;
- (void) gameLoaded;

@end