# Recipe App

This is my solution to the exam question. 

## Focus Areas

My main focus was the architecture, so it could easily be tested. I wrote some unit tests to demonstrate this but ran out of time to write all of them.
While the project called for nothing specifically to be stored to the device, the architecture can be easily adopted to use SwiftData, CoreData, or the file system under the hood. 
I wrote my own image caching solution as the requirements for the app was minimal. It's a personal pet peeve of mine when developers include third party frameworks to accomplish simple tasks. 
I spent some time on the UI, to get the swipeable cards. I could have just done a simple list, but my OCD complex would not allow that.
The header has a menu item, and you can select a cuisine type, the cards will then be for that cuisine type. When you swipe, you remove that card from the stack. An enhancement would be to loop back around.
Pull to refresh reloads the cards for the cuisine type, from memory cache of course. 
Tapping the info button will take you to a website for that recipe with more details. 


## Time Spent.

Honestly, this project took me more than 3-5 hours. I estimate it took me 8. But to get the architecture right and have the UI not be boring, and also add unit tests and comments necessitated that. 

## Trade-offs

There are a lot of stuff I want to clean up with the UI, and add more Unit Tests of course. 

## Weakest Part of the Project

The webview logic and the header selector, as well as the fact the cards are removed when swiping (should go back to the beginning). The Webview should have a loading indicator and error state. The header should be nicer, and more obvious that it is selectable. 

## External Code and Dependencies

None. 


