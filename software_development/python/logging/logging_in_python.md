# **[Logging in Python](https://www.geeksforgeeks.org/logging-in-python/#)**

Logging is a means of tracking events that happen when some software runs. Logging is important for software developing, debugging, and running. If you don’t have any logging record and your program crashes, there are very few chances that you detect the cause of the problem. And if you detect the cause, it will consume a lot of time. With logging, you can leave a trail of breadcrumbs so that if something goes wrong, we can determine the cause of the problem.

There are a number of situations like if you are expecting an integer, you have been given a float and you can a cloud API, the service is down for maintenance, and much more. Such problems are out of control and are hard to determine.

## Why print statement is not Pythonic

Some developers use the concept of printing the statements to validate if the statements are executed correctly or if some error has occurred. But printing is not a good idea. It may solve your issues for simple scripts but for complex scripts, the printing approach will fail.
Python has a built-in module logging which allows writing status messages to a file or any other output streams. The file can contain information on which part of the code is executed and what problems have arisen.  

## Python Logging Levels

There are five built-in levels of the log message.  

- Debug: These are used to give Detailed information, typically of interest only when diagnosing problems.
-Info: These are used to confirm that things are working as expected
- Warning: These are used as an indication that something unexpected happened, or is indicative of some problem in the near future
- Error: This tells that due to a more serious problem, the software has not been able to perform some function
- Critical: This tells serious error, indicating that the program itself may be unable to continue running

If required, developers have the option to create more levels but these are sufficient enough to handle every possible situation. Each built-in level has been assigned its numeric value.

![in](https://media.geeksforgeeks.org/wp-content/uploads/Python-log-levels.png)**

The logging module is packed with several features. It has several constants, classes, and methods. The items with all caps are constant, the capitalized items are classes and the items which start with lowercase letters are methods.

There are several logger objects offered by the base Handler itself.  

- Logger.info(msg): This will log a message with level INFO on this logger.
- Logger.warning(msg): This will log a message with a level WARNING on this logger.
- Logger.error(msg): This will log a message with level ERROR on this logger.
- Logger.critical(msg): This will log a message with level CRITICAL on this logger.
- Logger.log(lvl,msg): This will Log a message with integer level lvl on this logger.
- Logger.exception(msg): This will log a message with level ERROR on this logger.
- Logger.setLevel(lvl): This function sets the threshold of this logger to lvl. This means that all the messages below this level will be ignored.
- Logger.addFilter(filt): This adds a specific filter fit into this logger.
- Logger.removeFilter(filt): This removes a specific filter fit into this logger.
- Logger.filter(record): This method applies the logger’s filter to the record provided and returns True if the record is to be processed. Else, it will return False.
- Logger.addHandler(hdlr): This adds a specific handler hdlr to this logger.
- Logger.removeHandler(hdlr) : This removes a specific handler hdlr into this logger.
- Logger.hasHandlers(): This checks if the logger has any handler configured or not.

## Useful Handlers

In addition to the base Handler Class, many useful subclasses are provided.

| Handler                  | Description                                                                                                                    |
|--------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| StreamHandler            | Sends messages to streams (file-like objects).                                                                                 |
| FileHandler              | Sends messages to disk files.                                                                                                  |
| BaseRotatingHandler      | Base class for handlers that rotate log files at a certain point. Use RotatingFileHandler or TimedRotatingFileHandler instead. |
| RotatingFileHandler      | Sends messages to disk files, with support for maximum log file sizes and log file rotation.                                   |
| TimedRotatingFileHandler | Sends messages to disk files, rotating the log file at certain timed intervals.                                                |
| SocketHandler            | Sends messages to TCP/IP sockets. Also supports Unix domain sockets since Python 3.4.                                          |
| DatagramHandler          | Sends messages to UDP sockets. Also supports Unix domain sockets since Python 3.4.                                             |
| SMTPHandler              | Sends messages to a designated email address.                                                                                  |
| SysLogHandler            | Sends messages to a Unix Syslogthe  daemon, possibly on a remote machine.                                                      |
| NTEventLogHandler        | Sends messages to a Windows NT/2000/XP event log.                                                                              |
| MemoryHandler            | Sends messages to a buffer in memory, which is flushed whenever specific criteria are met.                                     |
| HTTPHandler              | Sends messages to an HTTP server using either GET or POST semantics.                                                           |
| WatchedFileHandler       | Watches the file it is logging to. If the file changes, it is closed and reopened using the file name.                         |
| QueueHandler             | Sends messages to a queue, such as those implemented in the queue or multiprocessing modules.                                  |
| NullHandler              | Does nothing with error messages. Used by library developers to avoid ‘No handlers could be found for logger’ message.         |

## Python Logging Basics

The basics of using the logging module to record the events in a file are very simple.  For that, simply import the module from the library.  

1. Create and configure the logger. It can have several parameters. But importantly, pass the name of the file in which you want to record the events.
2. Here the format of the logger can also be set. By default, the file works in append mode but we can change that to write mode if required.
3. Also, the level of the logger can be set which acts as the threshold for tracking based on the numeric values assigned to each level.
4. There are several attributes that can be passed as parameters.
The list of all those parameters is given in **[Python Library](https://docs.python.org/3/library/logging.html#logrecord-attributes)**.
The user can choose the required attribute according to the requirement.

After that, create an object and use the various methods as shown in the example.

Logging a Variable
This code demonstrates how to log an error message. The logging.error() function is used to log an error message with a placeholder %s for the variable name.

```python
import logging
name = 'GFG'
logging.error('%s raised an error', name)
```

Output :

ERROR:root:GFG raised an error

## Logging of all the levels

This code demonstrates all the levels of logging.

```python
# importing module
import logging

# Create and configure logger
logging.basicConfig(filename="newfile.log",
                    format='%(asctime)s %(message)s',
                    filemode='w')

# Creating an object
logger = logging.getLogger()

# Setting the threshold of logger to DEBUG
logger.setLevel(logging.DEBUG)

# Test messages
logger.debug("Harmless debug Message")
logger.info("Just an information")
logger.warning("Its a Warning")
logger.error("Did you try to divide by zero")
logger.critical("Internet is down")
```

## Configuring Logging

Logging to a File: temp.conf

```bash
[loggers]
keys=root,simpleExample

[handlers]
keys=consoleHandler

[formatters]
keys=simpleFormatter

[logger_root]
level=DEBUG
handlers=consoleHandler

[logger_simpleExample]
level=DEBUG
handlers=consoleHandler
qualname=simpleExample
propagate=0

[handler_consoleHandler]
class=StreamHandler
level=DEBUG
formatter=simpleFormatter
args=(sys.stdout,)

[formatter_simpleFormatter]
format=%(asctime)s - %(name)s - %(levelname)s - %(message)s
```

## Example

The code sets up a logging system using the configuration from the temp.conf file. It obtains a logger named simple example and logs messages with various log levels.

```python
import logging
import logging.config

logging.config.fileConfig('temp.conf')

# create logger
logger = logging.getLogger('simpleExample')

# 'application' code
logger.debug('debug message')
logger.info('info message')
logger.warning('warn message')
logger.error('error message')
logger.critical('critical message')
```

Output :

2023-06-15 18:16:21 - simpleExample - DEBUG - debug message
2023-06-15 18:16:21 - simpleExample - INFO - info message
2023-06-15 18:16:21 - simpleExample - WARNING - warn message
2023-06-15 18:16:21 - simpleExample - ERROR - error message
2023-06-15 18:16:21 - simpleExample - CRITICAL - critical message

## Python Logging Exception

Raising exceptions during logging can be useful in certain scenarios to indicate exceptional conditions or errors in your application. By raising an exception, you can halt the normal flow of execution and notify the caller or the logging system about the encountered issue.

In this code, we are raising an Exception that is being caught by the logging. exception.

```python
import logging

logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s - %(levelname)s - %(message)s')


def perform_operation(value):
    if value < 0:
        raise ValueError("Invalid value: Value cannot be negative.")
    else:
        # Continue with normal execution
        logging.info("Operation performed successfully.")


try:
    input_value = int(input("Enter a value: "))
    perform_operation(input_value)
except ValueError as ve:
    logging.exception("Exception occurred: %s", str(ve))
```

Output :

Enter a value: -1
2023-06-15 18:25:18,064 - ERROR - Exception occurred: Invalid value: Value cannot be negative.

ValueError: Invalid value: Value cannot be negative.
