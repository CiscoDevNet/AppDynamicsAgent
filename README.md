# AppDynamicsAgent iOS SDK

An AppDynamics iOS SDK framework for monitoring the performance and activity of iOS applications. This SDK can be added to your Xcode development environment via the AppDynamics [GitHub repository](https://github.com/CiscoDevNet/AppDynamicsAgent.git).

> ⚠️ This project contains a single manifest file `Package.swift`, and there are no future plans to include any source code. As such, it is unlikely that we will be accepting contributions to the project, as its primary purpose is for binary distribution.


## Swift Package Manager Install

**SDK Install Requirements**

  * Swift Package Manager install is supported for iOS Agent 23.10.1 or higher.
  * You must have the supported Xcode version >=14.1

Complete the following steps in your Xcode environment to add the AppDynamics iOS SDK package:
1. Navigate to **File > Add Packages**.
2. In the search bar, specify the following GitHub URL: ```https://github.com/CiscoDevNet/AppDynamicsAgent.git```
3. Specify the version that you want to add.
4. Click **Add Package**.
5. Select the package and the target application.
6. Click **Add Package**.

After you add the package, complete the following:

## Add Required Libraries

### The AppDynamics iOS Agent requires these libraries:
1. `SystemConfiguration.framework`
2. `CoreTelephony.framework`
3. `libz.dylib or .tbd`
  
### To add the libraries:
1. Select the target that builds your app in Xcode.
2. Select the Build Phases tab.
3. Expand the **Link Binary With Libraries** section.
4. If any of the above libraries are not listed:
  * Click the + button.
  * Locate the missing library in the list.
  * Click **Add**. 

Repeat this step for each missing library.

### Set the -ObjC Flag

You also need to add the -ObjC flag to Other Linker Flags.  
  
1. Select your project in the **Project Navigator**.
2. In the target list, select the target that builds your application.
3. Select the Build Settings tab.
4. Scroll to **Linking** and open.
5. Go to **Other Linker Flags** and double-click to open the popup. 
6. If the **-ObjC** flag is not in your list, click + and add it.  

## Documentation

For a more detailed description of how to incorporating and utilizing the SDK, or for
troubleshooting information, please see the
[official documentation](https://docs.appdynamics.com/appd/23.x/23.10/en/end-user-monitoring/mobile-real-user-monitoring/instrument-ios-applications/install-the-ios-sdk)
