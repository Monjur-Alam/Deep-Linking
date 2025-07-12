# Setting up iOS Universal Links
<img src="Deep Linking/banner.png" />
## Table of Contents

- [Resources](#resources)
    - [General link resources](#general-link-resources)
    - [Validation tools](#validation-tools)
- [Server configuration](#server-configuration)
	- [Apple JSON Metadata file](#apple-json-metadata-file)
		- [Create a JSON file called apple-app-association](#create-a-json-file-called-apple-app-association)
			- [For iOS12 and earlier](#ios-12-and-earlier)
			- [For iOS13 and later](#ios-13-and-later)
		- [Sign the apple-app-site-association file using openssl](#sign-the-apple-app-association-file-using-openssl)
		- [Upload the signed apple-app-site-association file](#upload-the-signed-apple-app-association-file)
	- [Modifying the Content-type of the apple-app-site-association file](#modifying-the-content-type)
		- [Apache configuration](#apache-configuration)
		- [nginx configuraiton](#nginx-configuration)
	- [Common issues](#server-common-issues)
- [Client configuration](#client-configuration)
    - [Associated domains](#associated-domains)
    - [Implement the corresponding AppDelegate methods](#implement-the-corresponding-appdelegate-methods)
        - [iOS 9.0 and earlier](#ios-9.0-and-earlier)
        - [iOS 9.1 and later](#ios-9.1-and-later)
	- [Common issues](#client-common-issues)

## <a name="resources"></a> Resources

Here are some good URLs that might be of assistance:

### <a name="general-link-resources"></a> General link resources

- <https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/UniversalLinks.html>
- <https://developer.apple.com/videos/play/wwdc2015-509/>
- <https://medium.com/@barsh/my-first-date-with-ios-universal-links-90dfabc88bb8>
- <https://developer.apple.com/documentation/safariservices/supporting_associated_domains_in_your_app>

### <a name="validation-tools"></a> Validation tools

- <https://search.developer.apple.com/appsearch-validation-tool/>
- <https://limitless-sierra-4673.herokuapp.com/>

## <a name="server-configuration"></a> Server configuration

Follow these steps to setup Universal app linking on the web server.
In this documentation we have examples for [Apache2](https://httpd.apache.org/) and [nginx](http://nginx.org/) but the same rules apply for [IIS](https://www.iis.net/) or any other webserver of your choice.

### <a name="apple-json-metadata-file"></a> Apple JSON Metadata file

#### <a name="create-a-json-file-called-apple-app-association"></a> Create a JSON file called "**apple-app-association**"

##### <a name="ios-12-and-earlier"></a> For iOS12 and earlier

Below you'll find a template with a few examples:

```
{
    "applinks": {
        "apps": [],
        "details": [
            {
                "appID": "<TEAM_DEVELOPER_ID>.<BUNDLE_IDENTIFIER>",
                "paths": [ "*" ]
            },
            {
                "appID": "<TEAM_DEVELOPER_ID>.<BUNDLE_IDENTIFIER>",
                "paths": [ "/articles/*" ]
            },
            {
                "appID": "<TEAM_DEVELOPER_ID>.<ANOTHER_APP_BUNDLE_IDENTIFIER>",
                "paths": ["/blog/*","/articles/*"]
            }
        ]
    }
}
```

**PLEASE NOTE!**

- The `"apps":` JSON key must be left as an empty array.
- The `apple-app-site-association` JSON file must not have a `.json` file extension. 

##### <a name="ios-13-and-later"></a> For iOS13 and later

This template gives you a lot more flexibility of how to handle certain URLs on your website. For instance you can specify a required URL query item with a particular name and a value of x numbers of characters. You can exlude URLs with `#` that is common in AngularJS apps.

```
{
  "applinks": {
      "details": [
           {
             "appIDs": [ "ABCDE12345.com.example.app", "ABCDE12345.com.example.app2" ],
             "components": [
               {
                  "#": "no_universal_links",
                  "exclude": true,
                  "comment": "Matches any URL whose fragment equals no_universal_links and instructs the system not to open it as a universal link"
               },
               {
                  "/": "/buy/*",
                  "comment": "Matches any URL whose path starts with /buy/"
               },
               {
                  "/": "/help/website/*",
                  "exclude": true,
                  "comment": "Matches any URL whose path starts with /help/website/ and instructs the system not to open it as a universal link"
               }
               {
                  "/": "/help/*",
                  "?": { "articleNumber": "????" },
                  "comment": "Matches any URL whose path starts with /help/ and which has a query item with name 'articleNumber' and a value of exactly 4 characters"
               }
             ]
           }
       ]
   },
   "webcredentials": {
      "apps": [ "ABCDE12345.com.example.app" ]
   }
}
```

**PLEASE NOTE!**

- The `apple-app-site-association` JSON file must not have a `.json` file extension. 

#### <a name="sign-the-apple-app-association-file-using-openssl"></a> Sign the apple-app-site-association file using openssl

**OBS:** Please note that as of iOS9 you no longer need to sign the `apple-app-site-association` JSON file. However if you still need to support iOS8 or lower this is still required.

```
openssl smime -sign -nodetach 
-in "unsigned.json"
-out "apple-app-site-association" -outform DER 
-inkey /path/to/server.key 
-signer /path/to/server.crt
```

#### <a name="upload-the-signed-apple-app-association-file"></a> Upload the signed "apple-app-association" file

1. Upload the signed `apple-app-site-association` file to the server:

```
scp /path/to/apple-app-site-association username@example.com:~/
```
2. Login to the web server:

```
ssh username@example.com
```
3. Move the file to the root of the webserver *(This might be another directory on your server)*

```
mv apple-app-site-association /var/www/
```

### <a name="modifying-the-content-type"></a> Modifying the Content-type of the apple-app-site-association file

The apple-app-association-file needs to be returned with the following Content-Type:

| Minimum OS version | Content-Type             |
| ------------------ | ------------------------ |
| iOS9 or later      | `application/json`       |
| iOS8 or lower      | `application/pkcs7-mime` |

Below you'll find instructions on how to do this for your web server.

#### <a name="apache-configuration"></a> Apache configuration

- Modify the `/etc/apache2/sites-available/default-ssl` (or equivalent) file to include the `<Files>` snippet:

```
<Directory /path/to/root/directory/>
...
<Files apple-app-site-association>
Header set Content-type "application/json"
</Files>
</Directory>
```

#### <a name="nginx-configuration"></a> nginx configuration

- Modify the `/etc/nginx/sites-available/ssl.example.com` (or equivalent) file to include the `location /apple-app-assocation` snippet:

```
server {
   ...
   location /apple-app-site-association {
      default_type application/json;
   }
}
```

### <a name="server-common-issues"></a> Common issues

The JSON validation may fail if:

- The JSON file is invalid
- Redirects to something other than HTTPS
	- From our experience any redirects will make Apples webscraper bot unable to parse the JSON file, you really should avoid them
- The server returns a 400-499 HTTP status code
- The server returns a 500-599 HTTP status code
	- The Apples webscraper bot assumes that the file is temporarily unavailable and may retry again

For more information go to Apples documentation page [Supporting Associated Domains in Your App](https://developer.apple.com/documentation/safariservices/supporting_associated_domains_in_your_app) and scroll down to the section "Validate the Apple App Site Association File".

## <a name="client-configuration"></a>Client configuration

### <a name="associated-domains"></a> Associated domains

1. In Xcode go to `<MyApp>.xcodeproj/<Build target>/Capabilities` and turn on Associated domains.

![Associated domains](https://gist.githubusercontent.com/anhar/6d50c023f442fb2437e1/raw/bf7101d4522cbe1944a9f1fced03ee3de6d79fd6/xcode_client_setup1.jpg)
2. Enter the domains you want the iOS app to respond to.

![Associated domains](https://gist.githubusercontent.com/anhar/6d50c023f442fb2437e1/raw/bf7101d4522cbe1944a9f1fced03ee3de6d79fd6/xcode_client_setup2.jpg)

- This will generate a `<AppName>.entitlements` file that needs to be included in the project.
- Please note that you need to enter subdomains specifically.

### <a name="implement-the-corresponding-appdelegate-methods"></a> Implement the corresponding `AppDelegate` methods

#### <a name="ios-9.0-and-earlier"></a>iOS 9.0 and earlier

- If you already have a custom URI scheme i.e `myAppScheme://`, this method will already be implemented.
- We have noticed that devices running iOS 9.0.x responds to this older method of handling app links.
- If you want to support iOS 9.0.x or earlier like iOS8/iOS7 you will need to implement this method and add a JavaScript iframe redirect to your website.

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
```

#### <a name="ios-9.1-and-later"></a>iOS 9.1 and later

- Devices running iOS 9.1 or later supports [Apple's Universal Links](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html) and to handle the incoming URL you need to implement the following methods:

```
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    NSURL *url = userActivity.webpageURL;
    // handle url
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    // handle url
}
```

### <a name="client-common-issues"></a> Common issues

Remember that when you make changes to either:

- The `<AppName>.entitlements` file in your iOS project
- The `apple-app-site-association` JSON file

To delete the App from your testing device and compile it again. After an app has been successfully associated with a particular domain it will remain associated until the app is removed from the device.

When testing your deep links I recommend you to use either the iMessage app or the Notes app. If you use other 3rd party iOS applications such as Slack or Facebook Messenger the deeplinking might not work because that's dependent on how those 3rd party apps handle external URLs.
