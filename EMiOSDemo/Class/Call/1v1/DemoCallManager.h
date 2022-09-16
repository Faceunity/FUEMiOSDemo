//
//  DemoCallManager.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 22/11/2016.
//  Copyright © 2016 XieYajie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FURenderKit/FURenderKit.h>
#import <FURenderKit/FUGLDisplayView.h>

@interface DemoCallManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) FUGLDisplayView *glView;

@property (nonatomic, strong) FUCaptureCamera *mCamera;

- (void)answerCall:(NSString *)aCallId;

- (void)endCallWithId:(NSString *)aCallId
               reason:(EMCallEndReason)aReason;

- (void)saveCallOptions;

@property (strong, nonatomic, readonly) EMCallSession *currentCall;

@end
