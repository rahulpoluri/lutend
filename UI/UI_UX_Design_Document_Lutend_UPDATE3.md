

UI/UX Design Document for Lutend

Outcome of Design 
The outcome of the design activity is a set of well-structured Figma designs for mobile devices, along with all supporting source materials required for handover. The Figma file should be interactive where applicable, with clickable buttons and functional elements, and must include: 
● Complete component-based designs following a consistent design 
● All UI states (hover, active, error, etc.) and responsive variations 
● Exported assets in organized folders with clear naming conventions 
● Embedded notes or documentation explaining logic, flows, and behavior 
● A user flow map outlining screen navigation and key paths 

The handover package should be usable by both developers and no-code tools with minimal additional clarification required. 
Design Expectations (Android and IOS) 
● We want the design of the platform to be as enjoyable and intuitive as possible with minimum mental overhead to the user. 
● Design fits seamlessly to both Android and IOS devices 
● Design should be consistent to reduce mental load on the user while using the platform. 
● Design should be open and inclusive, meaning each step should self explain itself on why it is, how it is useful and provide context and confidence to the user. 
● Design should look and feel as a premium product and should impress the user with uniqueness and usage practicality. Design is the first means for this product to show authenticity to users. 
● Design and colors should reflect the brand guidelines and show the values of the platform. 


● We are focusing first on mobile app, later there will also be a web version of the platform. 
● Design should keep in mind the cause of Lutend and honest problems which are solved by Lutend. At every step it should feel transparent to the user. 

Update 1: Introduction of Parallelism: We would like users to connect with a maximum of three matches parallely to prevent users from losing patience from waiting time for their upcoming meet. This affects the meeting section and chat section. 
Meeting section: This section should show three parallel meet flows each can be at different stages. 
Chat section: Users can chat with more than one matches parallely until they are expired. 
Different sections of platform 
Platform is mainly divided into two sections 
1. Onboarding 
2. Dashboard a. Meet section 
b. User Profile section 
c. User Knowledge and Daily dose section 
d. Feedback and complaint section 
e. Update 1: Chat section 
f. Meet credits and offers section 
g. Settings section 


Onboarding 
This section is used to onboard new users into the platform and verify their identity. 
Sub Sections 
● Onboarding questionnaire 
● Verification section 

Pages/Screens 
● At start user should see the logo, animation and signup page using google, Update2: (apple if ios device) Facebook or X. or with phone number and OTP login/signup should be passwordless. 
● Update3: User should be able to SIGNUP only with phone number with otp verification. This is mandatory. Later LOGIN can be done by google, facebook, apple, x accounts if the user optionally chooses to connect using the second login method. 
● Users should know a little about the platform at start, like its uniqueness, its advantages and what problem it solves. Also in between onboarding questions to get users hopeful and excited. 
● Update2: Location screen to get their location access. 
● Next, we should ask the user about his intent to join the platform. The platform has two different flows (marriage/finding partner and finding love) with different sets of questions based on intent. Update3: And some basic info to start with 
● Update3: Next comes onboarding questions, which can be skipped to fill them later. 
● Onboarding questions are divided into multiple meaningful sections. At the start of each section users should be guided on what to expect in the upcoming section. 
● Onboarding questions, type of form field and options in each question is detailed in the onboarding questions document. 
● At each question the user should know the progress on how far he is in the onboarding questionnaire with the possibility to go back and change at each question. 
● For questions like body type, and any other sensitive questions, appropriate links to know more about the topic should be shown. 
● There should be a way for the user to contact the Lutend if he is facing a challenge in any of the questions or on the verification section. 
● Update3: Next comes verification which can also be optionally skipped to just enter into app and do it later before starting matching 
● After user questionnaire is completed, next section is verification section where user is asked with clear instructions for 


○ best pictures 
○ Update 1: Based on their uploaded pictures, the platform will create three avatars, out of which the user can select the one which best suits them. 
○ Update 2: Users can regenerate three more avatars by clicking the regenerate button at the bottom, so in the end he can select one avatar from a total of six. 
○ email verification using otp 
○ phone number verification using otp 
○ video verification on screen 
○ scan of photo identity video format 
○ Location access to check the location of user 

● This section should build confidence in the user on how this improves the security and multiple ways to access his profile, how we fight fakes with the bank level security of users. 
● Users should be made aware of their right to ask for removal of all their data from the platform anytime asked and their right to report against fraud and report any harassment to ban the harassing users. 
● There should be a page of declaration for the user to swear that all the details provided are true as per their knowledge, any information when found false will lead to ban of the user and be considered as cheating. 
● Then the profile is sent to Lutend for verification, with a waiting screen. 
● Profiles can be both accepted or rejected based on user input, this might take from few minutes to few hours, so a waiting screen and if rejected the rejected screen with appropriate text with the lutend team’s message on why the profile is rejected has to be shown. 

Dashboard 
When a user is onboarded and logged in, his first page that he sees is Dashboard with multiple sections to navigate. 
Dashboard section should contain a tutorial for the first time users to show the user what are different sections and what can they do with them pointing to the section. 
Meet section - Of Dashboard 
This section is where all the online meeting activity happens, starting the partner search, see match initial details, getting updates on the next meeting, reminders, video calling, feedback, and reporting of the user. 
Update3: Users here should be able to see some animated preview on how the matching works. 
Sub Sections 
● Current meet section: where information and status of current/upcoming meeting scheduled. 
● Previous meet section: where the user can see all the details of the previous meetings he had. 

Current meet section 
● The user should be able to start the search for the new partner using a button if he has meet credits already, if not, the user should be asked to buy credits to start the search. Update2: He should be also asked to setup the secondary signin method, so that he doesn't miss out notification or lose account. 
● A waiting screen is shown while we are finding a match for the user using all his given preference criteria 
● Update 1: Users can see the avatar of their match along with their Bio. Three avatars will be created by the platform based on their uploaded photos during onboarding. The user can then select one of the provided avatars that best suits them. 
● Meet Scheduling Page: After two users are matched, they are both asked to share their preferred time for the meeting. ○ Update 1: After the user checks the profile, if he finds it interesting, the user can send a personalized voice note to his match (optional) and answer the questions given by his match (optional). 
○ If the user is the first to respond, they’ll see a calendar where they can pick and submit their available time slots optionally with an optional voice note and answers to the questions. 



○ If the user is the second, they’ll see the first person’s submitted time slots on the same screen and choose one that works for them. This helps both users agree on a meeting time smoothly and quickly. 

● Meet checklist screen: which is a checklist of suggestions shown to the user to prepare for this meet like grooming, choosing the outfit, some tips on background, topics to discuss and avoid etc. 
● An acknowledgement screen: meeting fixed and waiting screen with countdown time will be shown. 
● Check In screen: for the user to acknowledge he joins the meeting on the fixed time to make the user remember the meeting a few hours before meet. 
● Join the meet screen at the time of meeting. 
● Meeting screen for video call: with options to end call and extend the meeting time. 
● Post-Meeting Feedback Screen: After the meeting ends, users will see a feedback screen with the following prompts and actions: ○ How was the meeting? (general rating or comment) 
○ What went well? 
○ What didn’t go well? 


Users will also have these action options: 
○ Report: to flag any issue and explain the problem 
○ Reject: if the match wasn’t a good fit 
○ Update3: Meet Again: to schedule another meeting with the same match 
○ Update 1: Enable chat: An option to enable chat after their first meet which is enabled for {30 days}. With ghosting period of 7 days Reveal/Plan Date: to plan an in-person meet and connect outside the platform 


This step ensures better experiences and safety for all users. 
● A waiting screen: to know the result of the other user. 

Previous meet section 
● Should contain user statistics on when, how many times and how many people. 


● User’s own feedback given on each particular meet from the feedback section. 
● Some details about the previous meet like the name, note from the match and few details shared before the meet. 

User Profile section - Of Dashboard 
This section is where the user sees all his details and preferences which he can change, this makes the matching algorithm transparent and works as per users wishes. 
Pages/Screens 
Also divided into two sections 
User details section 
This section is where the user can see his own details given in onboarding, he can change some of the details but with a request to the system for approval. 
● The user should be able to see his intention (Love / Long Term Partner) to be on this app. 
● He should be able to write a small bio, which he will be shown to the match before the call. 
● Update 1: Users should be able to add up to three generalised questions for their match that will intrigue the interest in the meeting (Not mandatory). These questions will be shown to their match after they confirm that they are interested in the meeting. 
● All the user details, with edit option 

User preferences section 
Here preselected default preferences are shown, which users can change and alter their order of importance by shuffling them. The top 3 preferences are mandatory preferences meaning any match made should definitely fulfill 
these criteria, for rest preferences they are matched based on weighted scores. We encourage users to check and change their preferences often to see what works for them. 
User Knowledge and Daily dose section - Of Dashboard 
This is a kind of media section, where the user gets to read articles and watch videos related to relationship advice, mental health topics and other topics related to self-help. 
We do not want to encourage short form content but good size text to read or good informative long videos to watch will be preferable, also there will only be a few per day, not to distract users too much with notifications. Maybe also showing a timer on how much time he spent in the section. 
Pages/Screens 
● Preferably LinkedIn style format, with videos and text, where people can also comment. Update2: Tag another user and reply to the comment of the previous user. The user will be shown with his avatar as an icon with lastname appended with a number in the comments section. 

Feedback/ Help section - Of Dashboard 
The purpose of this section is to be near to users wherever the user faces any problem with the platform, so that we get happy customers, and the user will not feel frustrated if he faces any kind of challenge. Also, it helps unhappy users directly report to us and talk to us, instead of feeling helpless and making bad reviews on google play store. The response from the team might take a few business days. Easy and usual questions will be answered by chatbot but we will have a real person if there is any specific challenge to address it. Of Course, users can also post positive reviews if they love the platform here. 
Update3: This is achieved by having every info text and question buttons on every section leading to a screen where users can give their feedback or ask question to the lutend team. 
Pages/Screens 
● Chat section where user can type his question and gets the response from chatbot (or Lutend team, if escalated further) indicating the timeline if it takes more time to respond 
● Commonly asked questions to see usual questions. 

Update 1: Chat section - Dashboard: 
Where users can chat with their matched users who have already had their first meet, for 7 days. And can also see all the details of meets they have met before. 
Chats will expire after 7{30} days. They can either choose to meet again on the platform or share their details and get out of the platform within those 7{30} days. 
In this section, users can see their active chats (with his match details), expired chats (with match details) and the feedback they gave about their match after their meet. 
Update3: Users can also have video calls from here 
Meet Credits Section - Of Dashboard 
The purpose of this section is to show offers to the user, his credit information, buy new credits using payment gateway, and ‘know more’ section on credits. Every new user gets some free credits after signing up, and he should buy more credits after using free credits. 
Pages/Screens 
● Page showing his current credits left 
● To buy new credits 
● To see offers on buying credits 

Settings and info Section - Of Dashboard 
This should contain all the user settings and some mandatory pages. 
Pages/Screens 

● Notification - to enable or disable various notifications 
● About us page - to tell a little story about the firm and the team behind 
● Community guidelines - to inform user on what is expected on the platform 
● Terms and conditions - to inform user on our contract terms and conditions 
● Privacy policy - to make user know the privacy policy we conform 
● Tracking and settings - to know user what kind of tracker we use and what we collect 
● Safety - to make users know how do we handle safety and how to be safe on platform 
● Compliance - to make users know what kind of compliances we follow. 
● Change password - if users opted to join with username and password in new page 
● Change Email - to allow user change his email, again with verification using phone in new page 
● Change phone - to allow user to change phone number, again with verification email in new page 
● Account page - to delete account 
● Logout - to logout of the app 

Extra pages - Of Dashboard 
● Page for login if logged out 

Confidentiality Notice 
This document contains confidential and proprietary information related to Lutend. Please do not share, reproduce, or distribute any part of it without written permission. Thank you for respecting our brand’s privacy. 
Rahul Poluri and Jetal Bhanarkar 