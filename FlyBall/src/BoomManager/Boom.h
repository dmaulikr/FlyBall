//
//  Actor.h
//  IncredibleBlox
//
//  Created by Mac Mini on 23.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Boon : NSObject {
	int itemID;
	CCSprite *costume;
	CCNode *parentFrame;
	
    BOOL isActive;
	BOOL isVisible;
}

@property (nonatomic, assign) int itemID;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) CCSprite *costume;

- (id) init;
- (void) load;
- (void) update:(ccTime)dt;
- (void) activate;
- (void) deactivate;
- (void) outOfArea;
- (void) removeCostume;
- (void) show:(BOOL)_flag;

@end
