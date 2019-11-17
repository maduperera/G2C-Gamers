# G2C-Gamers
One stop for all gamers needs.

# Please open the G2C Gamers.xcworkspace in Xcode in order to run it.

# How did you decide to use that design and architectural patterns?

I could have used either MVC or MVVM for this as those are the two effecient mobile app design architectures to date. But in this app I went for the most classical MVC architecture where I seperated Controllers, Views and Models. But It's always nice to keep the controller cohesive as much, to handle user interactions while a dedicated viewmodel does the presentaional formating. 
Interestingly by looking in to the nature of this perticular app (this is a sort of a tableview intensive app) I guessed that tableview cells are where most of the data formating needs to be done. So the UITableViewCell files made under Cells category(folder) in the app works mostly as viewmodels. So that I thought having a seperate ViewModel category won't do much and adhereing to MVC along with Cell and Network Category (folder) would just be fine even when the project expands in future.

# What should be the part of this app that needs more time to develop or improve?

I think it is the networking and local storage which will be the foundation for the project to last in future while the app grows.
Here in the app I have done an assumption where the next page in pagination can be found by incrementing page number by 1. If one page is missing in between in the server, the app would look for the next and so on. 
But I do prefer much and kept the code extensible in future to use the nextPage url detail given in current page details. Unfortunately in the third party network layer I used, I couldn't find a way to use the nextPage url it self and just pass it to get data since the string Url it self had params encoded within.
I could have extracted page number and page size from nextPage url and feed it to Moya layer. But I stronly believe there should be a better way to just pass the nextpage url (i.e. : "next": "https://api.rawg.io/api/games?page=2&page_size=10") and grab data. I kept that for future work and implemented pagination by incementing the page number at each subsequent fetch.

# Which part did you like most in this app?

Description page which has favourite finctionality and more less functionality where we have two different cell types being used in same table.

Does this app ready to submit to store? If not, what should be done to achieve that?
Yes. I spent lot of time pefecting the app and done pretty good QA to handle any errors.

# Do you have any comments to us?

Nothing much. This way of accessing is appreciable.

# What are the things you think are missing or open in this assignment?

1. I could have done unit testing but I had to sacrifice it to keep up the time since I was doing the assignment while working fulltime at office during a release. I did intensive QA to make sure the app works without any side effects.

2. As I said before I would need to check if theres a way to pass a url with params as it is to Moya and fetch data. If we can do pagination using the given next, previous attributes it would have been much better.

These are the only two things that are open in this assignment.





