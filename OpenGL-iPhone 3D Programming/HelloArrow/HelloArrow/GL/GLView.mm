//
//  GLView.mm
//  HelloArrow
//
//  Created by huang guijun on 12-1-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"

#import "mach/mach_time.h"
#import <OpenGLES/ES2/gl.h>

const bool ForceES1 = false;

@implementation GLView
+ (Class)layerClass 
{
    return [CAEAGLLayer class];
}

- (void)dealloc
{
    if ([EAGLContext currentContext] == m_context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [m_context release];
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)super.layer;
        eaglLayer.opaque = YES;
        
        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
        m_context = [[EAGLContext alloc] initWithAPI:api];
        
        if (!m_context || ForceES1) {
            api = kEAGLRenderingAPIOpenGLES1;
            m_context = [[EAGLContext alloc] initWithAPI:api];
        }
        
        if (!m_context || ![EAGLContext setCurrentContext:m_context]) {
            [self release];
            return nil;
        }
        
        //GL Initialization
        /*
         *   步骤摘要表:
         *
         *   1.    创建renderbuffer并绑定到固定渲染通道。
         *   2.    用EAGL layer创建一个renderbuffer的storage，必须要用到Objective-C的语法。
         *   3.    创建一个framebuffer并将renderbuffer附属于它。
         *   4.    用glViewport设置视图矩阵，用glOrthof设置投影矩阵。
         */
        /**
        GLuint framebuffer, renderbuffer;
        glGenFramebuffersOES(1, &framebuffer);
        glGenRenderbuffersOES(1, &renderbuffer);
        
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderbuffer);
        */
        if (api == kEAGLRenderingAPIOpenGLES1) {
            NSLog(@"Using OpenGL ES 1.1");
            m_renderingEngine = CreateRenderer1();
        } else {
            NSLog(@"Using OpenGL ES 2.0");
            m_renderingEngine = CreateRenderer2();
        }
        
        [m_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
        
        /**
        glFramebufferRenderbuffer(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, renderbuffer);
        
        
        glViewport(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
         */
        m_renderingEngine->Initialize(CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        
        //[self drawView];
        [self drawView:nil];
        
        //add
        m_timestamp = CACurrentMediaTime();
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self
                                                                 selector:@selector(drawView:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didRotate:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

//- (void)drawView
//{
//    glClearColor(0.5, 0.5, 0.5, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
//    
//    [m_context presentRenderbuffer:GL_RENDERBUFFER_OES];
//}

- (void)drawView:(CADisplayLink *)displayLink
{
    if (displayLink != nil) {
        float elapsedSeconds = displayLink.timestamp - m_timestamp;
        m_timestamp = displayLink.timestamp;
        m_renderingEngine->UpdateAnimation(elapsedSeconds);
    }
    
    m_renderingEngine->Render();
    
    [m_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)didRotate:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    m_renderingEngine->OnRotate((DeviceOrientation) orientation);
    
    [self drawView:nil];
}

@end










