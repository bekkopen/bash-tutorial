# About

This project is used for workshop purposes and contains examples of (hopefully) good practices for bash scripting.

# Examples

## Debugging

**Source:** [scripts/debugging\_easy\_example.sh](bash-tutorial/blob/master/scripts/debugging\_easy\_example.sh) and [scripts/debugging\_tougher\_example.sh](bash-tutorial/blob/master/scripts/debugging\_easy\_example.sh)

**The point:** Debugging is hard in bash.

**Assignment:** Find the bugs.

## Syntax

**Source:** [scripts/syntax.sh](bash-tutorial/blob/master/scripts/syntax.sh)

**The point:** You can do similar things in different ways in bash.

**Assignment:** Try out the different ifs and explain the differences, when to use, and what you prefer.

## Organizing files

**Source:** The project tree.

**The point:** Understand convention over configuration and why it is important to put different types of files in different places.

**Assignment:** How would you organize your files when you have specific scripts for different projects residing in different folders.

## Functions and configuration

**Source:** [include/common\_functions.sh include/common\_config.sh](bash-tutorial/blob/master/include/common\_functions.sh include/common\_config.sh)

**The point:** Reduce complexity, enhance testability, and reusability.

**Assignment:** Go through the functions and try to understand them. Write your own function. How can you run the functions directly from the command line?

## Return values and return statuses

**Source:** [include/common\_functions.sh](bash-tutorial/blob/master/include/common\_functions.sh) (functions: \_is\_snapshot, \_startServers, \_find\_version\_from\_pom and \_delete)

**The point:** Understand the differences between a return value and a return status.

**Assignment:** Revisit the functions and explain what the different functions return (values and/or statuses)

## Pitfall return values

**Source:** [scripts/pitfall\_return\_values.sh](bash-tutorial/blob/master/scripts/pitfall\_return\_values.sh)

**The point:** Understand a common pitfall when using return values.

**Assignment:** Comment in the echo statement in the function and see what happens. Why?

## Pitfall return statuses
**Source:** [scripts/pitfall\_return\_status.sh](bash-tutorial/blob/master/scripts/pitfall\_return\_status.sh)

**The point:** Understand a common pitfall when using return statuses.

**Assignment:** Why do the two statements return different statuses?

## Including common functionality

**Source:** [include/includes.sh](bash-tutorial/blob/master/include/includes.sh)

**The point:** Understand reusability by sourcing other files.

**Assignment:** Write a function in a file and include and use it in a script.

## Debugging revisited

**Source:** [include/common\_functions.sh scripts/debugging.sh](bash-tutorial/blob/master/include/common\_functions.sh scripts/debugging.sh)

**The point:** Understand how you can debug your scripts without executing "dangerous" commands. Understand the -x, the -u, and the set -e set +e constructs.

**Assignment:** Write debugging for a function or script where it is lacking.

## Logging

**Source:** [scripts/logging.sh](bash-tutorial/blob/master/scripts/logging.sh) [scripts/rotating\_log.sh include/log.sh](bash-tutorial/blob/master/scripts/rotating\_log.sh include/log.sh)

**The point:** Understand how you can write your own logging framework.

**Assignment:** Write logging configuration to switch betwwen logging to file and stdout.

## Unit testing framework

**Source:** [tests/runAll.sh](bash-tutorial/blob/master/tests/runAll.sh)

**The point:** Example of how you can syntax check and run all your tests.

**Assignment:** Make running of tests part of your build (scripts/package.sh)

## Unit testing using the && and || operators

**Source:** [tests/testMs.sh](bash-tutorial/blob/master/tests/testMs.sh)

**The point:** An example of how you can unit test bash functions using the && and || operators.

**Assignment:** Write a unit test. Is this readable?

## Unit testing with asserts

**Source:** [bashUnit/asserts.sh](bash-tutorial/blob/master/bashUnit/asserts.sh) [tests/testVersionCheck.sh](bash-tutorial/blob/master/tests/testVersionCheck.sh)

**The point:** An example of how you can unit test bash functions using asserts.

**Assignment:** How does assertEquals differ from the assertTrue in e. g. jUnit? Write an assertTrue function and a test that uses it. Is this more readable?

**Bonus assignment:** Write an assertArrayEquals function and a test that uses it.

## Simple deploy and rollback

**Source:** [scripts/deploy.sh](bash-tutorial/blob/master/scripts/deploy.sh) [scripts/rollback.sh](bash-tutorial/blob/master/scripts/rollback.sh)

**The point:** These scripts are not very testable.

**Assignment:** Make the scripts testable.

