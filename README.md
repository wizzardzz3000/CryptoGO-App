# CryptoGO

A Swift app I imagined and developed back in 2018. 

It analyzes cryptocurrency markets and helps you follow and trade your assets.

Checkout the business plan included in the repo to learn more about the project's core development.

In the last weeks I worked on CryptoGO, the project was in a position to receive a 50,000$ investment from a private investor, before I stepped back and joined 42 Paris to study coding in further depth.

![CryptoGO screens](https://user-images.githubusercontent.com/31767776/68083193-90057580-fe26-11e9-962a-972f67d33e9b.png)

# Resume of the original app marketing

## Advanced analyzing algorithm built in
The app embarks a complex mathematical algorithm that analyses cryptocurrency markets. A combination of reputable trading indicators (like the Relative Strength Index and Ichimoku Clouds) methods and modern intelligence adapted to crypto provides precise buy-and-sell indicators. We are currently working on developing a more sophisticated machine learning algorithm to allow CryptoGO to learn by itself and adjust it’s previsions.

(Please note that the algorithm was not included in the demo code, but we would love to have you help us improve the technology. If you're interested in working on our code and have great machine learning / financial analyzing skills please contact us at contact@cryptogo.tech)

## CGO Tokens and community
CryptoGO has it’s own cryptocurrency and community. Members can vote to express their opinion on the cryptocurrency market and share information in the in-app’s news feed. 
Most active members are rewarded in CGO tokens directly in their ERC20 compatible wallet.

## (Beta) Push notifications 
The app is set to receive Push Notifications from an AWS server. The payload triggers background activity in order to display custom notifications to the user if new data justifies it.

## Key metrics tracking and automatic crash reporting 
The app is using Fabric to automatically track user key metrics and report any crash and it’s origin.

## Multi-format design adapted to every Apple device
The app is designed to look great on every Apple’s portable device screen size, from the biggest iPad to the smallest iPhone.

## And..
- CryptoGO uses it’s own server and API to track, analyze and display community data (news feed, votes, number of voters, community opinion…).
- Secure data fetching, preventing unexpected changes in API structures and formats. The app’s code has many safety guards preventing any crash due to impossible or incorrect data fetching.
- Automatic currency setup based on user location. You can also set a preferred currency in the settings window.
- The app uses many of Swift’s best practice features including Core Data and UITableViews.

## What’s next?
- Algorithm improvement with machine learning.
- Analyzing of every major cryptocurrency.
- Dynamic rewards based on user accuracy and pertinence.
- Improved news feed including community vote on news sources.
