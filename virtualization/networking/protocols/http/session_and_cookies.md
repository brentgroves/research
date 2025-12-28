# **[How session and cookies works ?](https://medium.com/@hendelRamzy/how-session-and-cookies-works-640fb3f349d1)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

In the world of web development, sessions and cookies are two important concepts that help store and retrieve information about users.

As we know, HTTP is stateless, which means that all requests sent are independent. However, in some situations, we need to keep track of user activity. A common example is the shopping cart in an ecommerce website. When we add an item to the cart, we don’t want it to disappear when we visit the next page. Therefore, we need to maintain this type of information.

One solution to overcome the stateless nature of the HTTP protocol is to use sessions. In this blog post, we will take a closer look at sessions and cookies, and how they work.

## Disclaimer

For the implementation I’ll use the PHP language. So, for the sake of this blog post, I’ll asume that you have at least some basic knowledge about PHP.
With that said let’s start.

## What are Cookies?

Cookies provide a way for web applications to store information in the user’s browser. This information can be retrieved every time the user requests a page from the same web server that created the cookies.

Cookies can be either first-party or third-party. First-party cookies are created by the website that the user is visiting, while third-party cookies are created by domains other than the website being visited. Third-party cookies are often used for advertising and tracking purposes.

## High-level of how cookies work

First, a cookies is a text string stored by the browser as a key/value pair.

![cookie](https://miro.medium.com/v2/resize:fit:720/format:webp/1*qUjOH5gQsRYAPQdnGG5OiQ.png)

![devtools](https://miro.medium.com/v2/resize:fit:720/format:webp/1*YWoWX0vcDMTsqzA3XdKOIQ.png)

In Figure 02, we can see that there are three cookies: the user ID, the user theme, and a cookie named PHPSESSID that we will discuss later in the session section.

When a browser request a web page, the server create a cookie and return it to the browser as part of the response. The browser then store that cookie in the user’s computer.

Cookies have a expired date that’s set by the server, when that date come, the cookie will be deleted from the user’s browser.

The browser send back that cookie each time it request a web page from that server.

Browsers generally accept only 20 cookie from each site, and 300 cookies in total.

## Summary

For now this is what you need to know about cookies to understand the rest.

- Cookies are text string stored as key/value
- The server Create the cookie and send it to the user’s browser where it’ll be stored.
- The Browser will send that cookie every time it send a request to that server.

## What are Sessions?

Sessions are a way of storing information about a user on the server-side. Those information will then be used in subsequent requests.

By definition, a Web session is a sequence of network HTTP request and response transactions associated with the same user.

Sessions provides the ability to establish variables — such as access rights and localization settings — which will apply to each and every interaction a user has with the web application for the duration of the session.

Let’s take an example. Suppose you’re logged into a web application and you provide your username (or email) and password, then submit. Next, you are redirected to the dashboard page where you can access it if you’re logged in.

In a non-session mechanism, you’ll not be able to access the dashboard, even though you logged in. This is because HTTP requests are independent of each other. When you send the second request to the dashboard page URL, the server doesn’t know who you are.

In a session-based mechanism, when you log in, the server stores some information about you in the session variable (for example, creating a variable that store the authenticated user ). In the next request, when you go to the dashboard page, the server recognizes you by checking that session variable and let you access the dashboard page.

The question now is, how?

## How session work ?

When a user logs into the website, a session is created. In this session, you can created variable called “session variable” that store data in a key/value format ( like cookies ).

This session is associated with a randomly generated unique ID, which is created by the server. It’s called “session ID”.

The generated session ID is then sent to the user’s browser and stored as a cookie, while the session data is stored on the server-side.

Now, when the browser send a request to the server, it’ll send the cookies with the request.

The server will receive the cookie from the incoming request and retrieve the value of the session ID.

![session](https://miro.medium.com/v2/resize:fit:720/format:webp/1*Mc3AiM1OIL4rH4DaC9m6Dg.png)

Afterwards, the server will search for the session and retrieve all the data stored within it once it is found.

If you remember, we saw a cookie named PHPSESSID in the cookie section. Well, This cookie store the session ID of the active session. PHPSESSID is the default name given by the PHP back-end server that created the session ID.

Let’s take a closer look at our previous example to understand what is happening in more detail.

When you log in, a session is created with a unique ID (session ID). The session ID will be sent to the user’s browser.

the server will then create a session variable auth_user ( for example ) and store in it the information of the actual logged in user. The session data will be stored in a file on the server side. The name of the file will be the session ID.

When the user request the dashboard page, the browser will send the cookie that contain the session ID with the request.

The server receives an incoming request, retrieves the session ID, and searches for the associated session. Once the session is found, the server retrieves the data.

Finally, the server will need to check the existence the that auth_user session variable. If he found it, the server will give the access to the dashboard page.

Sessions are often used to store sensitive information such as user credentials and financial data. They are more secure than cookies because the information is stored on the server-side and not on the client-side.

## How session are stored ?

I said later that session data are stored in a file in the server. Well, you should know that the session data are stored in different ways depending on the configuration.

For example, in PHP the default mechanism is to store the session in the file system This provides the advantage of simple file-based storage and the ability for sessions to exist for long periods of time.

Another way is to store the session data in a database, there are several advantages. You have better control over the length of a session, as you can control when the session data is cleared out. You have better security because the data is not stored in a common area

Most of the time, the session is stored in the cache for performance purposes, for example, if a website has a lot of users, it will be a good practice to store the session file in a cache so that the retrieval process will be fast.

Now that we know how session and cookies works, let’s go do some code.

## Implementation

To demonstrate how session and cookies work I’ll create a simple authentication system and a dashboard page where we display all the users information. For the simplicity of this blog, I’ll not use a database, but just an JSON format string That represent the users stored in a text file.

The application will :

- Login the user then redirect to the dashboard.
- Register a new user, store it in the database and redirect him to the dashboard.
- Dashboard page can be only accessed by a logged in user.
- Logged in user can’t go to the login page and register page.

## Little reminder

- To use session in PHP we use the global variable $_SESSION .
- To get access to the global $_SESSION variable, for each PHP file that’ll use that variable, you must call the session_start() method at the top of the file, before any other PHP code.
- To create a session variable we do $_SESSION['session_name'] = session_value.
- To get the value of a session variable we do $session_data = $_SESSION['session_name']
- To test if a session variable exist use the isset() PHP method, like so if(isset($_SESSION['session_name'])) . trueis returned if the session variable exist, else false.

Let’s start by looking at the home page which contain a form for the user to login.

![home](https://miro.medium.com/v2/resize:fit:720/format:webp/1*8tFtp8OST_WWxMtlL7_vIg.png)

![code1](https://miro.medium.com/v2/resize:fit:4800/format:webp/1*2R-q0hPC6DS18FpcU2qVOw.png)

The ```<?php require(’/navigation.php’); ?>``` is responsible to inject the HTML code to create the top navigation bar.

The ```<?php require(’/login_form.php’); ?>``` is responsible to inject the HTML code that create the login form. Let’s take a look at the code.

![code2](https://miro.medium.com/v2/resize:fit:720/format:webp/1*wyc64yzvK6tmy_KISG2wiA.png)

You can see that it’s just a normal HTML ```<form>``` tag. The interesting thing here is in the action and method attribute in the ```<form>``` tag.

POSTis the HTTP method that it’s going to be used, and the path in the action attribute is where to send the request, so that it’s can be handled. In our case the path is ./index.php.

When the index.php file receive a POST request:

- First make sure that all the form fields are filled.
- Check if the email/password combination match a already existing user in the database.
- If it find a user, that user will then be authenticated and redirected to the dashboard.php page

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*BCn_GMa1VUGzQBLVOIQkNA.png)

In the line 17, we check if the incoming request is a POST request. If true, we take the user’s information from the POST request and check for the email and password match. In the line 40 the authentification is made, we associate the actual session with that user by created a session variable called user_auth where we’re going to store the user data.

That auth_user session variable will now be accessible in all other PHP pages.

This is where session are useful, if we don’t use session they’ll no way the tell the other pages that there is an new user that’s logged in.

Now, the authenticated user can access to the dashboard page.

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*pgBzeH_gVLWUeDC-LkxYPw.gif)

Now we finished with the first function, let’s jump into the 3th one which is “Dashboard page can be only accessed by a logged in user.”

The dashboard page is accessible only for authenticated user. Let’s see what happened if we try the go to the dashboard page without login.

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*VL7TUHWv8Q9qNhLnXSAr8g.gif)

We can see a warning saying “you’re not logged in to access the dashboard !”

To know if a user is authenticated or not we use session variable. The auth_user session is created only when a user is logged in successfully. So, we need to test in the dashboard page if that specific session variable is created or not. If it’s not, that’s mean that the user that send the GET request is not logged in the application.

And this is possible because session variables can travel across the website pages.

![across](https://miro.medium.com/v2/resize:fit:720/format:webp/1*-c7OuuOOuJOjPOt3u4QTEQ.png)

In Line 16, we check if the user_auth session variable exist. If true, we continue the logic and display the page content. Else, in Line 44, we redirect the user back into the login page. Like this we finished the 3th function of the application.

## But how about the warning ?

Notice the Line 45. As you see, I’m creating a new session variable called no_auth. this session variable is created when a non logged in user try to access the dashboard page. We create it to kind of notify the index.php page that a user tried to access the dashboard page.

![noauth](https://miro.medium.com/v2/resize:fit:720/format:webp/1*PA2U5KTsAr61IbpRJbmaXw.png)

In the index.php page, we check if this no_authsession variable exist, if true, then we display the warning. Because session variable is only created for that purpose, it’ll then be deleted.

Session variables that are stored only for the next request, like the no_auth variable are called flash session. This is very useful for displaying a success message for example or managing validation errors.

For the 4th function, “Logged in user can’t go to the login page and register page”. That’s pretty simple, we check in the index.php page if the auth_user variable exist. If true, the user will then be redirected to the dashboard page and can not access the login page.

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*CVmnWaF38aM6a5qeXVOwHw.png)

For the Register functionality, I’ll let you think about it. The process is pretty much the same.

- Create register form.
- Check if the new user does not exist before, and display a warning if exist.
- Check if the user is logged in. If yes, then redirect it to the dashboard.
- When the user is created. Login automatically the new user and redirect it to the dashboard.

I’ll put the code in my Github account, if you have problem doing something check the code, or contact me, I’ll be happy to help you.

## How about the cookies ?

Well, as you can notice, in the code there no place where we create a session ID stored in the cookie and send it to the user’s browser. This is because, PHP do all this thing for us.

If you go to the browser and see the list of the cookies, you’ll see that a PHPSESSID is created already.

![session](https://miro.medium.com/v2/resize:fit:720/format:webp/1*90ar5xdvLQl2jlwBkX0N-g.png)

## Conclusion

In conclusion, sessions and cookies are both important concepts in web development. Cookies are used to store user-specific data on the client-side, while sessions are used to store information on the server-side. Sessions are more secure than cookies because the data is stored on the server-side. Understanding the differences between the two can help developers choose the appropriate method for storing and retrieving information about users.
