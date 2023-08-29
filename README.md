# AppDynamicsAgent
This includes AppDynamics iOS SDK which is a framework that allows you to monitor the performance and activities of an iOS application as it runs.

---

# Set the -ObjC Flag

You need to add the -ObjC flag to Other Linker Flags.  

 1. Select your project in the **Project Navigator**.
 2. In the target list, select the target that builds your application.
 3. Select the Build Settings tab.
 4. Scroll to **Linking** and open.
 5. Go to **Other Linker Flags** and double-click to open the popup. 
 6. If the **-ObjC** flag is not in your list, click + and add it.  

---

# NOTE

The **-ObjC** flag is necessary because the iOS Agent defines categories with methods that can be called at runtime, and by default, these methods are not loaded by the linker. As a result, you'll get an "unrecognized selector" runtime exception. The use of -ObjC ensures the methods will be loaded.

---

# Further Documentation

For a more detailed description of how to use SDK, or for
troubleshooting information, please see the
[official documentation](https://docs.appdynamics.com/appd/21.x/21.7/en/end-user-monitoring/mobile-real-user-monitoring/instrument-ios-applications)

