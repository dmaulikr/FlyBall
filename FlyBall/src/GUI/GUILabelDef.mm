//
//  GUILabelDef.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUILabelDef.h"
#import "MainScene.h"

@implementation GUILabelDef

@synthesize text;
@synthesize fontName;
@synthesize textColor;

- (id) init{
	if ((self = [super init])) {		
		text = @"";
        fontName = @"gameFont.fnt";
        parentFrame = [MainScene instance];
        textColor = ccc3(0, 0, 0);
	}
	return self;
}

@end
