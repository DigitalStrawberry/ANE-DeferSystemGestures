/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2018 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "FlashRuntimeExtensions.h"
#import "DeferSystemGestures.h"
#import "Functions/IsSupportedFunction.h"
#import "Functions/SetScreenEdgesFunction.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

FREContext DeferSystemGesturesExtContext = nil;
DeferSystemGestures* DeferSystemGesturesSharedInstance = nil;

@implementation DeferSystemGestures {
    UIRectEdge mEdges;
}

- (id) init
{
    self = [super init];
    
    if(self != nil)
    {
        mEdges = UIRectEdgeNone;
        
        // Swizzle 'preferredScreenEdgesDeferringSystemGestures'
        BOOL iOS11Plus = [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0;
        if(iOS11Plus)
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                UIViewController* rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                if(rootVC == nil)
                {
                    return;
                }
                    
                Class vcClass = object_getClass( rootVC );
                
                SEL vcSelector = @selector(preferredScreenEdgesDeferringSystemGestures);
                [self overrideVC:vcClass method:vcSelector withMethod:@selector(dsg_preferredScreenEdgesDeferringSystemGestures)];
            });
        }
    }
    
    return self;
}

- (void) setScreenEdges:(int) edges
{
    mEdges = edges;
    
    UIViewController* rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootVC setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
}

- (UIRectEdge) getScreenEdges
{
    return mEdges;
}

# pragma mark - Private

- (BOOL) overrideVC:(Class) vcClass method:(SEL) vcSelector withMethod:(SEL) swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(vcClass, vcSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(vcClass,
                    swizzledSelector,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod));
    
    if(didAddMethod)
    {
        class_replaceMethod(vcClass,
                            vcSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return didAddMethod;
}

- (UIRectEdge) dsg_preferredScreenEdgesDeferringSystemGestures
{
    if([self respondsToSelector:@selector(dsg_preferredScreenEdgesDeferringSystemGestures)])
    {
        UIRectEdge v = [self dsg_preferredScreenEdgesDeferringSystemGestures];
        v = v | [[DeferSystemGestures sharedInstance] getScreenEdges];
        return v;
    }
    return UIRectEdgeNone;
}

# pragma mark - Static

+ (nonnull DeferSystemGestures*) sharedInstance
{
    if(DeferSystemGesturesSharedInstance == nil)
    {
        DeferSystemGesturesSharedInstance = [[DeferSystemGestures alloc] init];
    }
    return DeferSystemGesturesSharedInstance;
}

@end

# pragma mark - Extension

FRENamedFunction airDeferSystemGesturesExtFunctions[] =
{
    { (const uint8_t*) "setScreenEdges", 0, dsg_setScreenEdges },
    { (const uint8_t*) "isSupported",    0, dsg_isSupported }
};

void DeferSystemGesturesContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    *numFunctionsToSet = sizeof( airDeferSystemGesturesExtFunctions ) / sizeof( FRENamedFunction );
    
    *functionsToSet = airDeferSystemGesturesExtFunctions;
    
    DeferSystemGesturesExtContext = ctx;
}

void DeferSystemGesturesContextFinalizer( FREContext ctx ) { }

void DeferSystemGesturesInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet )
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &DeferSystemGesturesContextInitializer;
    *ctxFinalizerToSet = &DeferSystemGesturesContextFinalizer;
}

void DeferSystemGesturesFinalizer( void* extData ) { }







