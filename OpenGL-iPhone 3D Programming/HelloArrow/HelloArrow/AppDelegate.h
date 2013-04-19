//
//  AppDelegate.h
//  HelloArrow
//
//  Created by huang guijun on 12-1-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLView;


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *_window;
    GLView   *_glView;
}

@property (nonatomic, retain) UIWindow *window;

@end
