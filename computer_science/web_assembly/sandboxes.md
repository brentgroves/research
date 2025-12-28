# **[sandbox](https://www.howtogeek.com/169139/sandboxes-explained-how-theyre-already-protecting-you-and-how-to-sandbox-any-program/)**

## How Sandboxes Are Essential For Security

A sandbox is a tightly controlled environment where programs can be run. Sandboxes restrict what a piece of code can do, giving it just as many permissions as it needs without adding additional permissions that could be abused.

For example, your web browser essentially runs web pages you visit in a sandbox. They're restricted to running in your browser and accessing a limited set of resources -- they can't view your webcam without permission or read your computer's local files. If websites you visit weren't sandboxed and isolated from the rest of your system, visiting a malicious website would be as bad as installing a virus.

Other programs on your computer are also sandboxed. For example, Google Chrome and Internet Explorer both run in a sandbox themselves. These browsers are programs running on your computer, but they don't have access to your entire computer. They run in a low-permission mode. Even if the web page found a security vulnerability and managed to take control of the browser, it would then have to escape the browser's sandbox to do real damage. By running the web browser with fewer permissions, we gain security. Sadly, Mozilla Firefox still doesn't run in a sandbox.

![i](https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2013/07/webcam-access-permission.png)

## What's Already Being Sandboxed

Much of the code your devices run every day is already sandboxed for your protection:

- **Web Pages:** Your browser essentially sandboxes the web pages it loads. Web pages can run JavaScript code, but this code can't do anything it wants -- if JavaScript code tries to access a local file on your computer, the request will fail.
- **Browser Plug-in Content:** Content loaded by browser plug-ins -- such as Adobe Flash or Microsoft Silverlight -- is run in a sandbox, too. Playing a flash game on a web page is safer than downloading a game and running it as a standard program because Flash isolates the game from the rest of your system and restricts what it can do. Browser plug-ins, particularly Java, are a frequent target of attacks that use security vulnerabilities to escape this sandbox and do damage.
- **PDFs and Other Documents:** Adobe Reader now runs PDF files in a sandbox, preventing them from escaping the PDF viewer and tampering with the rest of your computer. Microsoft Office also has a sandbox mode to prevent unsafe macros from harming your system.
- **Browsers and Other Potentially Vulnerable Applications:** Web browsers run in low-permission, sandboxed mode to ensure that they can't do much damage if they're compromised:
- **Mobile Apps:** Mobile platforms run their apps in a sandbox. Apps for iOS, Android, and Windows 8 are restricted from doing many of the things standard desktop applications can do. They have to declare permissions if they want to do something like access your location. In return, we gain some security -- the sandbox also isolates apps from each other, so they can't tamper with each other.
- **Windows Programs:** User Account Control functions as a bit of a sandbox, essentially restricting Windows desktop applications from modifying system files without first asking you permission. Note that this is very minimal protection -- any Windows desktop program could choose to sit in the background and log all your keystrokes, for example. User Account Control just restricts access to system files and system-wide settings.

![i](https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2013/07/mobile-app-permissions.png)

## How to Sandbox Any Program

Desktop programs aren't generally sandboxed by default. Sure, there's UAC -- but as we mentioned above, that's very minimal sandboxing. If you want to test out a program and run it without it being able to interfere with the rest of your system, you can run any program in a sandbox.

- **Virtual Machines:** A virtual machine program like VirtualBox or VMware creates virtual hardware devices that it uses to run an operating system. The other operating system runs in a window on your desktop. This entire operating system is essentially sandboxed, as it doesn't have access to anything outside of the virtual machine. You could install software on the virtualized operating system and run that software as if it were running on a standard computer. This would allow you to install malware and analyze it, for example -- or just install a program and see if it does anything bad. Virtual machine programs also contain snapshot features so you could "roll back" your guest operating system to the state it was in before you installed the bad software.

- **Sandboxie:** Sandboxie is a Windows program that creates sandboxes for Windows applications. It creates isolated virtual environments for programs, preventing them from making permanent changes to your computer. This can be useful for testing software. Consult our introduction to Sandboxie for more details.

![i](https://static0.howtogeekimages.com/wordpress/wp-content/uploads/2013/07/sandboxie-intro.png)

Sandboxing isn't something the average user needs to worry about. The programs you use do the sandboxing work in the background to keep you secure. However, you should bear in mind what is sandboxed and what isn't -- that's why it's safer to load any website than run any program.

However, if you want to sandbox a standard desktop program that normally wouldn't be sandboxed, you can do it with one of the above tools.
