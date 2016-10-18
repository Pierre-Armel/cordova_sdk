## Summary

This is the Cordova SDK of adjust™. You can read more about adjust™ at [adjust.com].

N.B. At the moment, SDK 4.10.0 for Cordova supports Android platform version `4.0.0 and higher` and iOS platform version 
`3.0.0 and higher`. Windows platform is **not supported** at the moment.

## Table of contents

* [Example app](#example-app)
* [Basic integration](#basic-integration)
   * [Get the SDK](#sdk-get)
   * [Add the SDK to your project](#sdk-add)
   * [Integrate the SDK into your app](#sdk-integrate)
   * [Adjust logging](#adjust-logging)
   * [Google Play Services](#google-play-services)
* [Additional features](#additional-features)
   * [Event tracking](#event-tracking)
      * [Revenue tracking](#revenue-tracking)
      * [Revenue deduplication](#revenue-deduplication)
      * [In-App Purchase verification](#iap-verification)
      * [Callback parameters](#callback-parameters)
      * [Partner parameters](#partner-parameters)
    * [Session parameters](#session-parameters)
      * [Session callback parameters](#session-callback-parameters)
      * [Session partner parameters](#session-partner-parameters)
      * [Delay start](#delay-start)
    * [Attribution callback](#attribution-callback)
    * [Session and event callbacks](#session-event-callbacks)
    * [Disable tracking](#disable-tracking)
    * [Offline mode](#offline-mode)
    * [Event buffering](#event-buffering)
    * [Background tracking](#background-tracking)
    * [Device IDs](#device-ids)
    * [Push token](#push-token)
    * [Pre-installed trackers](#pre-installed-trackers)
    * [Deep linking](#deeplinking)
        * [Standard deep linking scenario](#deeplinking-standard)
        * [Deep linking on Android & iOS 8 and earlier](#deeplinking-android-ios-old)
        * [Deep linking on iOS 9 and later](#deeplinking-ios-new)
        * [Deferred deep linking scenario](#deeplinking-deferred)
        * [Reattribution via deep links](#deeplinking-reattribution)
* [License](#license)


## <a id="example-app"></a>Example app

There is example inside the [`example` directory][example]. In there you can check how to integrate the adjust SDK into your 
app. The example app has been uploaded without platforms being added due to size considerations, so after downloading the app, 
go to app folder and run:

```
cordova platform add ios
cordova platform add android
```

## <a id="basic-integration">Basic integration

These are the minimal steps required to integrate the adjust SDK into your Cordova project.

### <a id="sdk-get">Get the SDK

You can get the latest version of the adjust SDK from the `npm` [repository][npm-repo] or download the it from our 
[releases page][releases].

### <a id="sdk-add">Add the SDK to your project

You can download our SDK directly as the plugin from `npm` repository. In order to do that, just execute this command in your 
project folder:

```
> cordova plugin add com.adjust.sdk
Fetching plugin "com.adjust.sdk" via npm
Installing "com.adjust.sdk" for android
Installing "com.adjust.sdk" for ios
```

Alternatively, if you have downloaded our SDK from the releases page, extract the archive to folder from your choice and 
execute following command in your project folder:

```
> cordova plugin add path_to_folder/cordova_sdk
Installing "com.adjust.sdk" for android
Installing "com.adjust.sdk" for ios
```

### <a id="sdk-integrate">Integrate the SDK into your app

The adjust SDK automatically registers with the Cordova events `deviceready`, `resume` and `pause`.

In your `index.js` file after you have received the `deviceready` event, add the following code to initialize the adjust SDK:

```js
var adjustConfig = new AdjustConfig("{YourAppToken}", AdjustConfig.EnvironmentSandbox);

Adjust.create(adjustConfig);
```

Replace `{YourAppToken}` with your app token. You can find this in your [dashboard].

Depending on whether you build your app for testing or for production, you must set `environment` with one of these values:

```javascript
AdjustConfig.EnvironmentSandbox
AdjustConfig.EnvironmentProduction
```

**Important:** This value should be set to `AdjustConfig.EnvironmentSandbox` if and only if you or someone else is testing 
your app. Make sure to set the environment to `AdjustConfig.EnvironmentProduction` just before you publish the app. Set it 
back to `AdjustConfig.EnvironmentSandbox` when you start developing and testing it again.

We use this environment to distinguish between real traffic and test traffic from test devices. It is very important that you 
keep this value meaningful at all times! This is especially important if you are tracking revenue.

### <a id="sdk-logging">Adjust logging

You can increase or decrease the amount of logs you see in tests by calling `setLogLevel` on your `AdjustConfig` instance with 
one of the following parameters:

```js
adjustConfig.setLogLevel(AdjustConfig.LogLevelVerbose);   // enable all logging
adjustConfig.setLogLevel(AdjustConfig.LogLevelDebug);     // enable more logging
adjustConfig.setLogLevel(AdjustConfig.LogLevelInfo);      // the default
adjustConfig.setLogLevel(AdjustConfig.LogLevelWarn);      // disable info logging
adjustConfig.setLogLevel(AdjustConfig.LogLevelError);     // disable warnings as well
adjustConfig.setLogLevel(AdjustConfig.LogLevelAssert);    // disable errors as well
adjustConfig.setLogLevel(AdjustConfig.LogLevelSuppress);  // disable all logging
```

### <a id="google-play-services">Google Play Services

Since the 1st of August of 2014, apps in the Google Play Store must use the [Google Advertising ID][google-ad-id] to uniquely 
identify each device. To allow the adjust SDK to use the Google Advertising ID, you must integrate the 
[Google Play Services][google-play-services].

The adjust SDK adds Google Play Services by default to your app.

If you are using Proguard, add these lines to your Proguard file:

```
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep class com.adjust.sdk.plugin.MacAddressUtil {
    java.lang.String getMacAddress(android.content.Context);
}
-keep class com.adjust.sdk.plugin.AndroidIdUtil {
    java.lang.String getAndroidId(android.content.Context);
}
-keep class com.google.android.gms.common.ConnectionResult {
    int SUCCESS;
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    java.lang.String getId();
    boolean isLimitAdTrackingEnabled();
}
```

If you don't want to use Google Play Services in your app, you can remove them by editing the `plugin.xml` file of the adjust 
SDK plugin. Go to the `plugins/com.adjust.sdk` folder and open the `plugin.xml` file. As part of the 
`<platform name="android">`, you can find the following line which adds the Google Play Services dependency:

```xml
<framework src="com.google.android.gms:play-services-analytics:+" />
```

Sometimes, it can happen that other Cordova plugins which you are using are also importing Google Play Services by default 
into your app. In this case, it can happen that Google Play Services from our SDk and other plugins conflict and cause build 
time errors for you. It is not important that Google Play Services are present in your app as part of our SDK exclusively. As 
long as you have `analytics` part of Google Play Services integrated in your app, our SDK will be able to read all needed 
information. In case you choose to add Google Play Services into your app as part of another Cordova plygin, you can simply 
remove line from above from `plugin.xml` file of our SDK.

## <a id="additional-features">Additional features

You can take advantage of the following features once the adjust SDK is integrated into your project.

### <a id="event-tracking">Event tracking

With adjust, you can track every event that you want. Suppose you want to track every tap on a button. Simply create a new 
event token in your [dashboard]. Let's say that event token is `abc123`. You can add the following line in your button’s click
handler method to track the click:

```js
var adjustEvent = new AdjustEvent("abc123");
Adjust.trackEvent(adjustEvent);
```

### <a id="revenue-tracking">Revenue tracking

If your users can generate revenue by tapping on advertisements or making In-App Purchases, then you can track those revenues 
with events. Let's say a tap is worth €0.01. You could track the revenue event like this:

```js
var adjustEvent = new AdjustEvent("abc123");

adjustEvent.setRevenue(0.01, "EUR");

Adjust.trackEvent(adjustEvent);
```

When you set a currency token, adjust will automatically convert the incoming revenues into a reporting revenue of your 
choice. Read more about [currency conversion here][currency-conversion].


### <a id="revenue-deduplication"></a>Revenue deduplication

You can also add an optional transaction ID to avoid tracking duplicate revenues. The last ten transaction IDs are remembered, 
and revenue events with duplicate transaction IDs are skipped. This is especially useful for In-App Purchase tracking. You can 
see an example below.

If you want to track in-app purchases, please make sure to call the `trackEvent` only if the transaction is finished and item 
is purchased. That way you can avoid tracking revenue that is not actually being generated.

```js
var adjustEvent = new AdjustEvent("abc123");

adjustEvent.setRevenue(0.01, "EUR");
adjustEvent.setTransactionId("{YourTransactionId}");

Adjust.trackEvent(adjustEvent);
```

**Note**: Transaction ID is the iOS term, unique identifier for successfully finished Android In-App-Purchases is named 
**Order ID**.

### <a id="iap-verification">In-App Purchase verification

If you want to check the validity of In-App Purchases made in your app using Purchase Verification, adjust's server side 
receipt verification tool, then check out our Cordova purchase SDK and read more about it [here][cordova-purchase-sdk].

### <a id="callback-parameters">Callback parameters

You can also register a callback URL for that event in your [dashboard][dashboard] and we will send a GET request to that URL 
whenever the event gets tracked. In that case you can also put some key-value pairs in an object and pass it to the 
`trackEvent` method. We will then append these named parameters to your callback URL.

For example, suppose you have registered the URL `http://www.adjust.com/callback` for your event with event token `abc123` and 
execute the following lines:

```js
var adjustEvent = new AdjustEvent("abc123");

adjustEvent.addCallbackParameter("key", "value");
adjustEvent.addCallbackParameter("foo", "bar");

Adjust.trackEvent(adjustEvent);
```

In that case we would track the event and send a request to:

```
http://www.adjust.com/callback?key=value&foo=bar
```

It should be mentioned that we support a variety of placeholders like `{idfa}` for iOS or `{gps_adid}` for Android that can be 
used as parameter values.  In the resulting callback the `{idfa}` placeholder would be replaced with the ID for Advertisers of 
the current device for iOS and the `{gps_adid}` would be replaced with the Google Advertising ID of the current device for 
Android. Also note that we don't store any of your custom parameters, but only append them to your callbacks. If you haven't 
registered a callback for an event, these parameters won't even be read.

You can read more about using URL callbacks, including a full list of available values, in our 
[callbacks guide][callbacks-guide].

### <a id="partner-parameters">Partner parameters

Similarly to the callback parameters mentioned above, you can also add parameters that adjust will transmit to the network 
partners of your choice. You can activate these networks in your adjust dashboard.

This works similarly to the callback parameters mentioned above, but can be added by calling the `addPartnerParameter` method 
on your `AdjustEvent` instance.

```js
var adjustEvent = new AdjustEvent("abc123");

adjustEvent.addPartnerParameter("key", "value");
adjustEvent.addPartnerParameter("foo", "bar");

Adjust.trackEvent(adjustEvent);
```

You can read more about special partners and networks in our [guide to special partners][special-partners].

### <a id="session-parameters">Session parameters

Some parameters are saved to be sent in every event and session of the adjust SDK. Once you have added any of these
parameters, you don't need to add them every time, since they will be saved locally. If you add the same parameter twice,
there will be no effect.

These session parameters can be called before the adjust SDK is launched to make sure they are sent even on install. If you
need to send them with an install, but can only obtain the needed values after launch, it's possible to [delay](#delay-start) 
the first launch of the adjust SDK to allow this behaviour.

### <a id="session-callback-parameters"> Session callback parameters

The same callback parameters that are registered for [events](#callback-parameters) can be also saved to be sent in every
event or session of the adjust SDK.

The session callback parameters have a similar interface of the event callback parameters. Instead of adding the key and
it's value to an event, it's added through a call to method `addSessionCallbackParameter` of the `Adjust` instance:

```js
Adjust.addSessionCallbackParameter("foo", "bar");
```

The session callback parameters will be merged with the callback parameters added to an event. The callback parameters added 
to an event have precedence over the session callback parameters. Meaning that, when adding a callback parameter to an event 
with the same key to one added from the session, the value that prevails is the callback parameter added to the event.

It's possible to remove a specific session callback parameter by passing the desiring key to the method 
`removeSessionCallbackParameter` of the `Adjust` instance:

```js
Adjust.removeSessionCallbackParameter("foo");
```

If you wish to remove all key and values from the session callback parameters, you can reset it with the method
`resetSessionCallbackParameters` of the `Adjust` instance:

```js
Adjust.resetSessionCallbackParameters();
```

### <a id="session-partner-parameters">Session partner parameters

In the same way that there is [session callback parameters](#session-callback-parameters) that are sent for every event or
session of the adjust SDK, there is also session partner parameters.

These will be transmitted to network partners, for the integrations that have been activated in your adjust [dashboard].

The session partner parameters have a similar interface to the event partner parameters. Instead of adding the key and its
value to an event, it's added through a call to method `addSessionPartnerParameter` of the `Adjust` instance:

```js
Adjust.addSessionPartnerParameter("foo", "bar");
```

The session partner parameters will be merged with the partner parameters added to an event. The partner parameters added to 
an event have precedence over the session partner parameters. Meaning that, when adding a partner parameter to an event with 
the same key to one added from the session, the value that prevails is the partner parameter added to the event.

It's possible to remove a specific session partner parameter by passing the desiring key to the method
`removeSessionPartnerParameter` of the `Adjust` instance:

```js
Adjust.removeSessionPartnerParameter("foo");
```

If you wish to remove all keys and values from the session partner parameters, you can reset it with the method
`resetSessionPartnerParameters` of the `Adjust` instance:

```js
Adjust.resetSessionPartnerParameters();
```

### <a id="delay-start">Delay start

Delaying the start of the adjust SDK allows your app some time to obtain session parameters, such as unique identifiers, to
be sent on install.

Set the initial delay time in seconds with the `setDelayStart` field of the `AdjustConfig` instance:

```js
adjustConfig.setDelayStart(5.5);
```

In this case this will make the adjust SDK not send the initial install session and any event created for 5.5 seconds. After 
this time is expired or if you call `sendFirstPackages()` of the `Adjust` instance in the meanwhile, every session parameter 
will be added to the delayed install session and events and the adjust SDK will resume as usual.

**The maximum delay start time of the adjust SDK is 10 seconds**.

### <a id="attribution-callback">Attribution callback

You can register a listener to be notified of tracker attribution changes. Due to the different sources considered for 
attribution, this information can not by provided synchronously. The simplest way is to create a single anonymous listener 
which is going to be called **each time your user's attribution value changes**:

With the `AdjustConfig` instance, before starting the SDK, add the anonymous listener:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setAttributionCallbackListener(function(attribution) {
    // Printing all attribution properties.
    console.log("Attribution changed!");
    console.log(attribution.trackerToken);
    console.log(attribution.trackerName);
    console.log(attribution.network);
    console.log(attribution.campaign);
    console.log(attribution.adgroup);
    console.log(attribution.creative);
    console.log(attribution.clickLabel);
});

Adjust.create(adjustConfig);
```

Within the listener function you have access to the `attribution` parameters. Here is a quick summary of its properties:

- `trackerToken`    the tracker token of the current install.
- `trackerName`     the tracker name of the current install.
- `network`         the network grouping level of the current install.
- `campaign`        the campaign grouping level of the current install.
- `adgroup`         the ad group grouping level of the current install.
- `creative`        the creative grouping level of the current install.
- `clickLabel`      the click label of the current install.

Please make sure to consider our [applicable attribution data policies][attribution-data].

### <a id="session-event-callbacks">Session and event callbacks

You can register a callback to be notified of successful and failed tracked events and/or sessions.

Follow the same steps as for attribution callback to implement the following callback function for successfully tracked 
events:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setEventTrackingSucceededCallbackListener(function(eventSuccess) {
    // Printing all event success properties.
    console.log("Event tracking succeeded!");
    console.log(eventSuccess.message);
    console.log(eventSuccess.timestamp);
    console.log(eventSuccess.eventToken);
    console.log(eventSuccess.adid);
    console.log(eventSuccess.jsonResponse);
});

Adjust.create(adjustConfig);
```

The following callback function for failed tracked events:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setEventTrackingFailedCallbackListener(function(eventFailure) {
    // Printing all event failure properties.
    console.log("Event tracking failed!");
    console.log(eventSuccess.message);
    console.log(eventSuccess.timestamp);
    console.log(eventSuccess.eventToken);
    console.log(eventSuccess.adid);
    console.log(eventSuccess.willRetry);
    console.log(eventSuccess.jsonResponse);
});

Adjust.create(adjustConfig);
```

For successfully tracked sessions:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setSessionTrackingSucceededCallbackListener(function(sessionSuccess) {
    // Printing all session success properties.
    console.log("Session tracking succeeded!");
    console.log(sessionSuccess.message);
    console.log(sessionSuccess.timestamp);
    console.log(sessionSuccess.adid);
    console.log(sessionSuccess.jsonResponse);
});

Adjust.create(adjustConfig);
```

And for failed tracked sessions:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setSessionTrackingFailedCallbackListener(function(sessionFailure) {
    // Printing all session failure properties.
    console.log("Session tracking failed!");
    console.log(sessionSuccess.message);
    console.log(sessionSuccess.timestamp);
    console.log(sessionSuccess.adid);
    console.log(sessionSuccess.willRetry);
    console.log(sessionSuccess.jsonResponse);
});

Adjust.create(adjustConfig);
```

The callback functions will be called after the SDK tries to send a package to the server. Within the callback you have access 
to a response data object specifically for the callback. Here is a quick summary of the session response data properties:

- `var message` the message from the server or the error logged by the SDK.
- `var timestamp` timestamp from the server.
- `var adid` a unique device identifier provided by adjust.
- `var jsonResponse` the JSON object with the response from the server.

Both event response data objects contain:

- `var eventToken` the event token, if the package tracked was an event.

And both event and session failed objects also contain:

- `var willRetry` indicates there will be an attempt to resend the package at a later time.

### <a id="disable-tracking">Disable tracking

You can disable the adjust SDK from tracking by invoking the method `setEnabled` of the `Adjust` instance with the enabled 
parameter as `false`. This setting is **remembered between sessions**, but it can only be activated after the first session.

```js
Adjust.setEnabled(false);
```

You can verify if the adjust SDK is currently active with the method `isEnabled` of the `Adjust` instance. It is always 
possible to activate the adjust SDK by invoking `setEnabled` with the parameter set to `true`.

### <a id="offline-mode">Offline mode

You can put the adjust SDK in offline mode to suspend transmission to our servers while retaining tracked data to be sent 
later. When in offline mode, all information is saved in a file, so be careful not to trigger too many events while in offline 
mode.

You can activate offline mode by calling the method `setOfflineMode` of the `Adjust` instance with the parameter `true`.

```js
Adjust.setOfflineMode(true);
```

Conversely, you can deactivate offline mode by calling `setOfflineMode` with `false`. When the adjust SDK is put back in 
online mode, all saved information is send to our servers with the correct time information.

Unlike disabling tracking, **this setting is not remembered** between sessions. This means that the SDK is in online mode
whenever it is started, even if the app was terminated in offline mode.

### <a id="event-buffering">Event buffering

If your app makes heavy use of event tracking, you might want to delay some HTTP requests in order to send them in one batch 
every minute. You can enable event buffering with your `AdjustConfig` instance by calling `setEventBufferingEnabled` method:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setEventBufferingEnabled(true);

Adjust.create(adjustConfig);
```

### <a id="background-tracking">Background tracking

The default behaviour of the adjust SDK is to **pause sending HTTP requests while the app is in the background**. You can 
change this in your `AdjustConfig` instance by calling `setSendInBackground` method:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setSendInBackground(true);

Adjust.create(adjustConfig);
```

If nothing is set, sending in background is **disabled by default**.

### <a id="device-ids">Device IDs

Certain services (such as Google Analytics) require you to coordinate Device and Client IDs in order to prevent duplicate
reporting.

### Android

If you need to obtain the Google Advertising ID, you can call the function `getGoogleAdId`. To get it in the callback method 
you pass to the call:

```js
Adjust.getGoogleAdId(function(googleAdId) {
    // Use googleAdId value.
});
```

Inside the callback method you will have access to the Google Advertising ID as the variable `googleAdId`.

### iOS

To obtain the IDFA, call the function `getIdfa` in the same way like the method `getGoogleAdId`:

```js
Adjust.getIdfa(function(idfa) {
    // Use idfa value.
});
```

### <a id="push-token">Push token

To send us the push notifications token, then add the following call to Adjust **whenever you get your token in the app or 
when it gets updated**:

```js
Adjust.setDeviceToken("YourPushNotificationToken");
```

### <a id="pre-installed-trackers">Pre-installed trackers

If you want to use the adjust SDK to recognize users that found your app pre-installed on their device, follow these steps.

1. Create a new tracker in your [dashboard].
2. Open your app delegate and add set the default tracker of your `AdjustConfig` instance:

    ```js
    var adjustConfig = new AdjustConfig(appToken, environment);

    adjustConfig.setDefaultTracker("{TrackerToken}");
    
    Adjust.create(adjustConfig);
    ```

  Replace `{TrackerToken}` with the tracker token you created in step 2. Please note that the dashboard displays a tracker 
  URL (including `http://app.adjust.com/`). In your source code, you should specify only the six-character token and not the
  entire URL.

3. Build and run your app. You should see a line like the following in the app's log output:

    ```
    Default tracker: 'abc123'
    ```

### <a id="deeplinking">Deep linking

If you are using the adjust tracker URL with an option to deep link into your app from the URL, there is the possibility to 
get info about the deep link URL and its content. Hitting the URL can happen when the user has your app already installed 
(standard deep linking scenario) or if they don't have the app on their device (deferred deep linking scenario).

### <a id="deeplinking-standard">Standard deep linking scenario

Standard deep linking scenario is a platform specific feature and in order to support it, you need to add some additional 
settings to your app. If your user already has the app installed and hits the tracker URL with deep link information in it, 
your application will be opened and the content of the deep link will be sent to your app so that you can parse it and decide 
what to do next. 

**Note for iOS**: With introduction of iOS 9, Apple has changed the way how deep linking should be handled in the app. 
Depending on which scenario you want to use for your app (or if you want to use them both to support wide range of devices), 
you need to set up your app to handle one or both of the following scenarios.

### <a id="deeplinking-android-ios-old"> Deep linking on Android & iOS 8 and earlier

To support deep linking handling in your app for Android and iOS 8 and earlier versions, you can use the `Custom URL Scheme` 
plugin which can be found [here][custom-url-scheme].

After you successfully integrate this plugin, in the callback method used with the plugin described in this 
[section][custom-url-scheme-usage] you will have an access to the content of the URL which opened your app on user's device:

```js
function handleOpenURL(url) {
    setTimeout(function () {
        // Check content of the url object and get information about the URL.
    }, 300);
};
```

By completing integration of this plugin, you should be able to handle deep linking in **Android and iOS 8 and lower**.

### <a id="deeplinking-ios-new"> Deep linking on iOS 9 and later

Starting from **iOS 9**, Apple has introduced suppressed support for old style deep linking with custom URL schemes like 
described above in favour of `universal links`. If you want to support deep linking in your app for iOS 9 and higher, you need 
to add support for universal links handling.

First thing you need to do is to enable universal links for your app in the adjust dashboard. Instructions on how to do that 
can be found in our native iOS SDK [README][enable-ulinks].

After you have enabled universal links handling for your app in your dashboard, you need to add support for it in your app as 
well. You can achieve this by adding this [plugin][plugin-ulinks] to your cordova app. Please, read the README of this plugin, 
because it precisely describes what should be done in order to properly integrate it.

**Note**: With anything you see in the README that assumes you need to have domain and website or to upload a file to the root 
of your domain - don't worry about that. Adjust is taking care of this instead of you and you can skip these parts of the 
README. Also, you don't need to follow the instructions of this plugin for the Android platform, because deep linking in 
Android is still being handled unchanged with `Custom URL scheme` plugin.

To complete the integration of `Cordova Universal Links Plugin` after successfully enabling universal links for your app in 
the adjust dashboard you must:

### Edit your `config.xml` file

You need to add following entry to your `config.xml` file:

```xml
<widget>
    <universal-links>
        <host name="[hash].ulink.adjust.com" scheme="https">
            <path event="adjustDeepLinking" url="/ulink/*" />
        </host>
    </universal-links>
</widget>
```

You should replace the `[hash]` value with the value you generated on the adjust dashboard. You can name the event also how 
ever you like.

### Check `ul_web_hooks/ios/` content of the plugin

Go to the `Cordova Universal Links Plugin` install directory in your app and check the `ul_web_hooks/ios/` folder content. In 
there, you should see a generated file with the name `[hash].ulink.adjust.com#apple-app-site-association`. The content of that 
file should look like this:

```
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "<YOUR_TEAM_ID_FROM_MEMBER_CENTER>.com.adjust.example",
        "paths": [
          "/ulink/*"
        ]
      }
    ]
  }
}
```

### Integrate plugin to your `index.js` file

After the `deviceready` event gets fired, you should subscribe to the event you have defined in your `config.xml` file, and 
define the callback method which gets fired once the event is triggered. Because you don't need this plugin to handle deep 
linking in Android, you can only need to subscribe to it if your app is running on an iOS device.

```js
// ...

var app = {
    initialize: function() {
        this.bindEvents();
    },

    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },

    onDeviceReady: function() {
        if (device.platform == "iOS") {
            universalLinks.subscribe('adjustDeepLinking', app.didLaunchAppFromLink);
        }
    },

    didLaunchAppFromLink: function(eventData) {
        // Check content of the eventData.url object and get information about the URL.
    }
}
// ...
```

By completing these steps, you have successfully added support for deep linking for iOS 9 and above as well.

### <a id="deeplinking-deferred">Deferred deep linking scenario

While deferred deep linking is not supported out of the box on Android and iOS, our adjust SDK makes it possible.
 
In order to get info about the URL content in a deferred deep linking scenario, you should set a callback method on the 
`AdjustConfig` object which will receive one parameter where the content of the URL will be delivered. You should set this 
method on the config object by calling the method `setDeeplinkCallbackListener`:

```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setDeferredDeeplinkCallbackListener(function(deeplink) {
    console.log("Deferred deep link URL content: " + deeplink);
});

Adjust.create(adjustConfig);
```

In deferred deep linking scenario, there is one additional setting which can be set on the `AdjustConfig` object. Once the 
adjust SDK gets the deferred deep link info, we are offering you the possibility to choose whether our SDK should open this 
URL or not. You can choose to set this option by calling the `setShouldLaunchDeeplink` method on the config object:


```js
var adjustConfig = new AdjustConfig(appToken, environment);

adjustConfig.setShouldLaunchDeeplink(true);
// or adjustConfig.setShouldLaunchDeeplink(false);

adjustConfig.setDeeplinkCallbackListener(function(deeplink) {
    console.log("Deferred deep link URL content: " + deeplink);
});

Adjust.create(adjustConfig);
```

If nothing is set, **the adjust SDK will always try to launch the URL by default**.

### <a id="deeplinking-reattribution">Reattribution via deep links

Adjust enables you to run re-engagement campaigns by using deep links. For more information on this, please check our 
[official docs][reattribution-with-deeplinks].

If you are using this feature, in order for your user to be properly reattributed, you need to make one additional call to the 
adjust SDK in your app.

Once you have received deep link content information in your app, add a call to `appWillOpenUrl` method of the `Adjust` 
instance. By making this call, the adjust SDK will try to find if there is any new attribution info inside of the deep link 
and if any, it will be sent to the adjust backend. If your user should be reattributed due to a click on the adjust tracker 
URL with deep link content in it, you will see the [attribution callback](#attribution-callback) in your app being triggered 
with new attribution info for this user.

In the code samples described above, call to the `appWillOpenUrl` method should be done like this:

```js
function handleOpenURL(url) {
    setTimeout(function () {
        // Check content of the url object and get information about the URL.
        Adjust.appWillOpenUrl(url);
    }, 300);
};
```

```js
// ...

var app = {
    initialize: function() {
        this.bindEvents();
    },

    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },

    onDeviceReady: function() {
        if (device.platform == "iOS") {
            universalLinks.subscribe('adjustDeepLinking', app.didLaunchAppFromLink);
        }
    },

    didLaunchAppFromLink: function(eventData) {
        // Check content of the eventData.url object and get information about the URL.
        Adjust.appWillOpenUrl(eventData.url);
    }
}
// ...
```

[dashboard]:    http://adjust.com
[adjust.com]:   http://adjust.com

[example]:      http://github.com/adjust/ios_sdk/tree/master/examples
[releases]:     https://github.com/adjust/cordova_sdk/releases
[npm-repo]:     https://www.npmjs.com/package/com.adjust.sdk

[google-ad-id]:         https://developer.android.com/google/play-services/id.html
[enable-ulinks]:        https://github.com/adjust/ios_sdk#deeplinking-setup-new
[plugin-ulinks]:        https://github.com/nordnet/cordova-universal-links-plugin
[event-tracking]:       https://docs.adjust.com/en/event-tracking
[callbacks-guide]:      https://docs.adjust.com/en/callbacks
[attribution-data]:     https://github.com/adjust/sdks/blob/master/doc/attribution-data.md
[special-partners]:     https://docs.adjust.com/en/special-partners
[custom-url-scheme]:    https://github.com/EddyVerbruggen/Custom-URL-scheme

[google-launch-modes]:    http://developer.android.com/guide/topics/manifest/activity-element.html#lmode
[currency-conversion]:    https://docs.adjust.com/en/event-tracking/#tracking-purchases-in-different-currencies
[cordova-purchase-sdk]:   https://github.com/adjust/cordova_purchase_sdk
[google-play-services]:   http://developer.android.com/google/play-services/index.html

[custom-url-scheme-usage]:      https://github.com/EddyVerbruggen/Custom-URL-scheme#3-usage
[reattribution-with-deeplinks]: https://docs.adjust.com/en/deeplinking/#manually-appending-attribution-data-to-a-deep-link

## <a id="license">License

The adjust SDK is licensed under the MIT License.

Copyright (c) 2012-2016 adjust GmbH, 
http://www.adjust.com

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
