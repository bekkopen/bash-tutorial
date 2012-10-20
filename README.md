# About

This project is used for workshop purposes and contains examples of (hopefully) good practices for bash scripting.

# Examples

## Debugging

**Source:** scripts/debugging\_easy\_example.sh and scripts/debugging\_tougher\_example.sh                                      

**The point:** Debugging is hard in bash.

**Assignment:** Find the bugs.

## Syntax

**Source:** scripts/syntax.sh

**The point:** You can do similar things in different ways in bash.

**Assignment:** Try out the different ifs and explain the differences, when to use, and what you prefer.

## Organizing of files

**Source:** The project tree

**The point:** Understand convention over configuration and why it is important to put different types of files in different places.

**Assignment:** How would you organize your files when you have specific scripts for different projects residing in different folders.

## Functions and configuration

**Source:** include/common\_functions.sh include/common\_config.sh

**The point:** Reduce complexity, enhance testability, and reuseability.

**Assignment:** Go through the functions and try to understand them. Write your own function.

## Return values and return statuses

**Source:** include/common\_functions.sh

**The point:** Understand the differences betwwen a return value and a return status.

**Assignment:** Revisit the functions and explain what the different functions return (values and/or statuses)

## Including common functionality

**Source:** include/includes.sh

**The point:** Understand reusability by sourcing other files.

**Assignment:** Write a function in a file and include and use it in a script.

## Debugging revisited

**Source:** include/common\_functions.sh

**The point:** Understand how you can debug your scripts without executing "dangerous" commands. Understand the -x and the set +e set -e constructs.

**Assignment:** Write debugging for a function or script where it is lacking.

## Simple deploy and rollback

**Source:** scripts/deploy.sh and scripts/rollback.sh

**The point:** These scripts are not very testable.

**Assignment:** Make the scripts testable.

