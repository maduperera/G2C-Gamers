# G2C-Gamers
One stop for all gamers needs.

# Please open the G2C Gamers.xcworkspace in Xcode in order to run it.


Min iOS v 11, Min swift version 4.2

# architectural patterns used

I could have used either MVC or MVVM for this as those are the two effecient mobile app design architectures to date. But in this app I went for the most classical MVC architecture where I seperated Controllers, Views and Models. But It's always nice to keep the controller cohesive as much, to handle user interactions while a dedicated viewmodel does the presentaional formating. 
Interestingly by looking in to the nature of this perticular app (this is a sort of a tableview intensive app) I guessed that tableview cells are where most of the data formating needs to be done. So the UITableViewCell files made under Cells category(folder) in the app works mostly as viewmodels. So that I thought having a seperate ViewModel category won't do much and adhereing to MVC along with Cell and Network Category (folder) would just be fine even when the project expands in future.

Further, I have used singleton pattern to keep a single copy of the DB and used delegate pattern to handle call backs where necessary. 

# Areas of the app that needs more time to develop or improve

The networking and local storage that needs more developer design + implemetation attention which will be the foundation for the project to last in future while the app grows .
Here in the app I have done an assumption where the next page in pagination can be found by incrementing page number by 1. If one page is missing in between in the server, the app would look for the next and so on. 
But I do prefer much and kept the code extensible in future to use the nextPage url detail given in current page details. Unfortunately in the third party network layer I used, I couldn't find a way to use the nextPage url it self and just pass it to get data since the string Url it self had params encoded within.
I could have extracted page number and page size from nextPage url and feed it to Moya layer. But I stronly believe there should be a better way to just pass the nextpage url (i.e. : "next": "https://api.rawg.io/api/games?page=2&page_size=10") and grab data. I kept that for future work and implemented pagination by incementing the page number at each subsequent fetch.

# The best part of the app

Description page which has favourite finctionality and more less functionality where we have two different cell types being used in same table.

# Appstore readiness
The app is perfectly 'OK tested' to release in appstore for the given requirements. I spent lot of time pefecting the app and done pretty good QA to handle any errors.

# Comments

I have used three third party libraries as they are essential to an app and to prevent re einventing the wheel.
The two libraries I used are
1. Networking layer - Moya (https://github.com/Moya/Moya)
2. Image caching - Kingfisher (https://github.com/onevcat/Kingfisher)
3. Local Database layer - SQLite (https://github.com/stephencelis/SQLite.swift) 

These libraries are MIT licenced and free to be used in our commercial apps.
Due to the integration of these libraries via cocoa pods please be kind enough to open the G2C Gamers.xcworkspace in Xcode in order to run it.

# Things that are missing or open in this assignment

1. I could have done unit testing but I had to sacrifice it to keep up the time since I was doing the assignment while working fulltime at office during a release. I did intensive QA to make sure the app works without any side effects.

2. As I said before I would need to check if theres a way to pass a url with params as it is to Moya and fetch data. If we can do pagination using the given next, previous attributes it would have been much better.These are the only two things that are open in this assignment.

Below are some screenshots of the real app.

https://user-images.githubusercontent.com/4883128/69006144-25d5f000-0951-11ea-81e4-3814792a2361.png

https://user-images.githubusercontent.com/4883128/69006146-266e8680-0951-11ea-91b8-eed8d6ef57b3.png

https://user-images.githubusercontent.com/4883128/69006147-266e8680-0951-11ea-8838-bad735b90f56.png

https://user-images.githubusercontent.com/4883128/69006148-266e8680-0951-11ea-9f64-a26d842a2e29.png

https://user-images.githubusercontent.com/4883128/69006149-27071d00-0951-11ea-8150-b6d134b30436.png

https://user-images.githubusercontent.com/4883128/69006201-a72d8280-0951-11ea-8ffa-73ee3bc3ee8a.png

https://user-images.githubusercontent.com/4883128/69006202-a72d8280-0951-11ea-9857-3fdc95d8eca3.png

https://user-images.githubusercontent.com/4883128/69006203-a72d8280-0951-11ea-98a8-fc21f87f478b.png

https://user-images.githubusercontent.com/4883128/69006204-a7c61900-0951-11ea-8d11-9cbdb698dbe2.png



