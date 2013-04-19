//
//  IRenderingEngine.hpp
//  HelloArrow
//
//  Created by huang guijun on 12-1-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

enum DeviceOrientation {
    DeviceOrientationUnknown,
    DeviceOrientationPortrait,
    DeviceOrientationPortraitUpsideDown,
    DeviceOrientationLandscapeLeft,
    DeviceOrientationLandscapeRight,
    DeviceOrientationFaceUp,
    DeviceOrientationFaceDown,
};

#define STRINGIFY(A)  #A

// Creates an instance of the renderer and sets up various OpenGL state.
struct IRenderingEngine *CreateRenderer1();
struct IRenderingEngine *CreateRenderer2();

// Interface to the OpenGL ES renderer; consumed by GLView.
struct IRenderingEngine {
    virtual void Initialize(int width, int height) = 0;
    virtual void Render() const = 0;
    virtual void UpdateAnimation(float timeStep) = 0;
    virtual void OnRotate(DeviceOrientation newOrientation) = 0;
    virtual ~IRenderingEngine() {}
};
