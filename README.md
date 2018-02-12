# ANE-DeferSystemGestures

A simple native extension for [deferring system gestures on iOS 11+](https://developer.apple.com/documentation/uikit/uiviewcontroller/2887512-preferredscreenedgesdeferringsys).

## Getting started

Download the ANE from the [releases](../../releases/) page and add it to your app's descriptor:

```xml
<extensions>
    <extensionID>com.digitalstrawberry.ane.deferSystemGestures</extensionID>
</extensions>
```

## API Overview

The native API is supported on iOS 11+ only. Use the `isSupported` getter to check for device support:

```as3
if(DeferSystemGestures.instance.isSupported)
{
    ...
}
```

If the API is supported, use the `setScreenEdges` method to specify the screen edges for which you want your gestures to take precedence over the system gestures. For example, setting it to `ScreenEdges.TOP` will prevent the notification center from sliding in when the user is interacting with the app near the top of the screen:

```as3
DeferSystemGestures.instance.setScreenEdges(ScreenEdges.TOP);
```

You can also combine multiple screen edges using the *bitwise or* operator:

```as3
DeferSystemGestures.instance.setScreenEdges(ScreenEdges.TOP | ScreenEdges.BOTTOM);
```

### Changelog

#### February 12, 2018 (v1.0.0)

* Public release