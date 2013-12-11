//
//  IOLWebView.h
//  INFOnlineLibrary
//
//  Created by Michael Ochs on 10/23/12.
//  Copyright (c) 2012 RockAByte GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 IOLWebView is a WebView that is able to handle tracking across hybrid apps.
 
 If you have an app that uses websites that have the INFOnline web tracking installed, you can use this webview to pass informations
 about the device to the web tracking service to identify you users across your app and the web sites.
 
 You can use this webview instead of a `UIWebView`, as it inherits from it and only implements some tracking logic.
 */
@interface IOLWebView : UIWebView

/*!
 This is the UIWebView's delegate.
 
 @warning You **must not** check an `IOLWebView`'s delegate for pointer equality or nil! Instead check for isEqual: if you have to compare the delegate with another object.
 */
@property (nonatomic, assign, readwrite) id<UIWebViewDelegate> delegate;

/*!
 The multi identifier string is send to your webserver as argument of the iom.setMultiIdentifier(string) JavaScript method
 of the INFOnline tracking framework.
 
 Normally you don't need to access this value, however if you are using frameworks like phonegap and you are not able to
 use the IOLWebView, you can use this string and call the iom.setMultiIdentifier() method on -webViewDidFinishLoad: manually.
 
 @return	The escaped multi identifier string or nil if the session has not been initialized yet.
 
 @note		You should not cache or store this value. Pass it as is to the JavaScript function! No manipulation like escaping is required.
 @since		1.1
 */
+ (NSString*)multiIdentifierString;

@end
