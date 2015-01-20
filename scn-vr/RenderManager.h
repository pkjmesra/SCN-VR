//
//  RenderManager.h
//  SCN-VR
//
//  Created by Michael Fuller on 12/20/14.
//  Copyright (c) 2014 M-Gate Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderBase.h"
#import "MonoRenderInstance.h"
#import "SBSRenderInstance.h"

@interface RenderManager : NSObject

@property (strong, readonly, nonatomic) NSMutableArray * renders;

+ (id)sharedManager;

-(RenderBase *) findRendererForViewports:(int) viewportCount;

@end