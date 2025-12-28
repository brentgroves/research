# **[Implementing TLS/SSL in Python](https://snyk.io/blog/implementing-tls-ssl-python/)**

**[Research List](../../../research_list.md)**\
**[Curent Tasks](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

Nowadays, we do virtually everything online: book flights, pay for goods, transfer bank funds, message friends, store documents, and so on. Many things we do require giving out sensitive information like our credit card details and banking information. If a website uses an unsecured network, a malicious hacker can easily steal user information. This is why encryption is so important.

The transport layer security (TLS) protocol is the ultimate safeguard of user information on websites and web applications. TLS uses a hard-to-crack cryptographic algorithm that ensures that no one other than the web server and web client can read or modify transmitted data.

In this article, we’ll explore TLS and how to use Python to check for a website’s TLS certificate validity. Then, we’ll walk through the steps for adding TLS to your Python application on Linux.

## Understanding TLS/SSL

The TLS protocol, the successor of the secure socket layer (SSL) protocol, protects data using encryption. When users send their information to a website, TLS encrypts it before sending it. Then, only the server with the same public key as the client can open the message. This rule also applies when the server sends information back to the client. Only the client with the corresponding key can read the data.

An SSL certificate must be valid to work. This means that not only must a credible certificate authority (CA) sign it, but the certificate also must be active. Every certificate has an issuance date and an expiration date. A certificate is no longer valid after its expiration date.

Websites without a valid SSL certificate have few visible indicators. For one, the URL in the address bar uses the HTTP:// prefix instead of HTTPS://. Additionally, there is no lock icon — which browsers use to indicate a secure site — next to the URL. Be cautious about what you share if you notice either of these signs.

Now that we’ve explored TLS-over-SSL (TLS/SSL), let’s see how to implement it using Python.

## Working with TLS/SSL in Python

When building a web server with Python, it’s crucial to know how to add TLS/SSL to our application. Before we learn how to do so, let’s see how to use Python to verify the validity of a website’s SSL certificate.

## Checking if a website has a valid SSL certificate

If we want to check the validity of a website’s SSL certificate, we can easily do so by running a Python script like this:

```python
import requests

response=requests.get('<https://twitter.com/>')

print(response)
```

The code above imports the requests Python module and uses it to make a GET request to the Twitter website. (To run the script, you must install the requests module in Python using pip). We can replace Twitter’s URL with the URL of the website whose SSL certificate we want to verify. The response variable stores the received value, which the code prints on the last line.

When we execute the code, we get a <Response [200]> (OK) message, meaning that the Twitter site is using a valid SSL certificate (as expected).

Now, we execute a GET request to another website. This time we use a website that we know lacks a valid SSL certificate.

```python
import requests

response=requests.get('<https://www.expired.badssl.com/>')

print(response)
```

This time, we receive an error stating that the certificate verification process failed:

requests.exceptions.SSLError: HTTPSConnectionPool(host='www. expired.badssl.com', port=443): Max retries exceeded with url : / (Caused by SSLError (SSLCertVerificationError(1, '[SSL:CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1131)’)))

## The Python SSL library

We use the Python SSL library to provide TLS encryption in socket-based communication between Python clients and servers. It uses cryptography and message digests to secure data and detect alteration attempts in the network. Digital certificates provide authentication.

The SSL library supports Windows, macOS, and other modern UNIX systems. It also requires OpenSSL to work.

Toward the end of this article, we’ll use the Python SSL library to wrap our connection-based socket with the SSL certificate we generate in the following section.
