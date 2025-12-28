# **[Creating our first project](https://ubuntu.com/tutorials/introduction-to-lxd-projects#3-creating-our-first-project)**

Imagine we have a scenario where we are setting up a web site for a particular client. We want to create two containers; one for the web service and one for the database service. Because we have lots of different web sites for different clients we want to ensure that we can quickly see and manage all of the containers for this particular web site.

Projects help us in this situation because we can create a project called client-website and add the containers to it that are related to providing the client’s web site.

lxc project create client-website -c features.images=false -c features.profiles=false
