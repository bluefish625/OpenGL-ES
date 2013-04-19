//
//  GLView.h
//  HelloArrow
//
//  Created by huang guijun on 12-1-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IRenderingEngine.hpp"

#import <OpenGLES/EAGL.h>
#import <QuartzCore/QuartzCore.h>

//#import <OpenGLES/ES1/gl.h>
//#import <OpenGLES/ES1/glext.h>


@interface GLView : UIView
{
    EAGLContext *m_context;
    IRenderingEngine *m_renderingEngine;
    float m_timestamp;
}

- (void)drawView:(CADisplayLink *)displayLink;
- (void)didRotate:(NSNotification *)notification;
@end
