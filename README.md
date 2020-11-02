# The EffesEYE (MVP) Patform Submission To FSI.ng For The Role Of CTO

> WIP - I will remove this line to signal I am done with updating this guide

Submission documentation for the EffesEYE MVP platform. 
I have structured this document following the sections describing how this entry will be evaluated, as stipulated in the assessment document sent out. I also added a `Sandbox Feedback` section where I provided (hopefully) valuable feedback to FSI. The outline is as follows

1.  What we will evaluate - here I respond inline to some questions posed in the assessment and attempt to draw attention to certain details that might aid evaluating this project
2.  Additional questions - here I provide answers to the questions asked in this section
3.  Security assessment questions - here I provide answers to the questions asked in this section
4.  What to deliver - here I share details about regenerating the database, as required

## What We Will Evaluate

### Code Quality

1.  The EffesEYE platform is predominatly a Javascript-powered ecosystem. I adopted a layered approach to quality across board, but what is important to highlight is the ahderence to a code style (with eslint), and the integration of CodeClimate, showing a quality rating badge for a given codebase. The goal for me here was not to write 100% perfect code, but to build credibility and transparency into how quality is rated and reported. 

2.  Modularity & Application Organisation - I adopted a Github Organization so that sub-systems of the platform can live in their own repos, instead of trying to fit everything into a single and potentially cumbbersome repo. Each sub-system exposes an artifact (via a URL) that the others then plug into/implement. Thus api-spec houses and evolves the underlying APIs of the platform and externalises a specification file which backend-monolith implements into a REST backend. backoffice houses and evolves the administrative application by consuming specific API endpoints from backend-monolith, and pwa was untimately meant to be the client-side application in the hands of our customers. The glue to all of this is the OpenAPI specification in api-spec. The same philosohpy of modularity is held within each sub-system/repo as well.

3.  Code documentation - I am a huge fan of, and prefer clean code over documentation/comments. They is room to improve documentation generally, but the code is very self explanatory and there'll be little to no friction getting around it or understanding it. The API spec is however heavily documented as that establishes the contract between coorporating systemes in the platform

4.  Unit & Integration Testing - While time did not permit me to write as much tests as I would love to, there are a number of unit/integration tests for backend-monolith which is the core of the platform. Though few, the tests hit over 90% coverage because the follow to most code execution path in the system. One huge benefit of API-first design, which we have implemented with api-spec, is that we can use utilities like oatts to generate tests for the entirety of the EffesEYE APIs. I mean test stubs for every single HTTP method for every single API endpoint. 

Tests are powered by Jest and were ran locally against a PostgresSQL database (needed to cut down latency). The `--coverage` flag collects test coverage data and externalises them in files within the `./tests/coverage` folder in backend-monolith. Our `make-coverage-badge` npm dependency is then used to generate a test coverage badge which we have displayed galantly in README file of backend-monolith! Ideally running tests and reporting coverage should be part of our CI/CD pipeline. That prioritises quality of code in the `product delivery`, but we decided to focus on quality of just the code, what is reported and how they get reported

5.  Exception Handling - Practically every error-prone code has a try-catch somewhere in its call stack. We can do more with these (like log them to our Moesif dashboard), but we currently just console log them at certain execution points in the codebase

### Design

Later portions of this document will do justice to the design of the EffesEYE platform

### Functional Completeness

The EffesEYE platform can:

1.  Add, authenticate and authorize users/admins
2.  Get users to add their bank accounts (with a NUBAN number) to their EffesEYE profile, after an enquire/validation is done using the FSI sandbox APIs
3.  Get users to pay for airtime, tv, and electricity, also using the FSI sandbox APIs. payments for tv subscription and electricity were only simulated, as these are not really supported in the FSI sandbox as far as I know


## Additional Questions

### Can you explain in details the application process flow

As described above, the EffesEYE platform comprises of a number of systems: primarily the API, the backend that implements the API as a REST service, and the admin web app that exposes administrative functionality to admins, by consuming specific backend services. An ideal way to explain the process flow will be to do so from the perspective of a persona - either an admin or a customer

>  With the backend service built, deployed and running at [http://effeseye-api.herokuapp.com/](http://effeseye-api.herokuapp.com/), it comes seeded with some user, accounts and payment data

#### The Admin 

1. Begins by going to [https://effeseye-admin.netlify.app/](https://effeseye-admin.netlify.app/) and logs in as an admin with a white-listed email address (specified in environment variables). 
2.  A successful login on the server produces an authentication token which the admin web app uses to authenticate and authorise the user as an admin in subsequent interactions. The token expires after 30 minutes, but can be invalidated by reseting a SECRET set in an environment variable
3. Armed with the auth token, the admin web app automatically navigates the admin to the home screen, which currently is the screen for viewing `Payments` made so far.
4. The admin can also navigate to the `People` screen to see the users in the platform.
5. While here, transactions going on in the platform are automatically relected in the admin UI becasue every navigation to `Payments` or `People` fetches the data from the server (yeah, not so performant or cost effective) 
6.  The admin can logout with the logout action button, else he/she will be redirected back to the login screen if they try to interact with the app after 30 minutes of the last login, by which time the authentication token would have expired

#### The User / Customer

> Time did not permit me to build the PWA for customers, but that will definitely be done. In its place, we can simulate the interactions of a customer by going over the steps outlined in [backend-monolith/effeseye.rest](https://github.com/EffesEYE/backend-monolith/blob/dev/effeseye.rest)

1.  The customer first registers to join the EffesEYE platform by providing their BVN, email and a password
2.  The EffesEYE platform validates these entries against the schema defined in EffesEYE API specification, and only then does it call the endpoints to handle the requests. The registration request first needs to verify the BVN with the NIBSS API from the FSI Sandbox, yielding some biodata for the user. The EffesEYE platform takes this biodata and creates an account for the user, associating it with the provided email and password pair
3.  Once registered, the customer can proceed to add one or more of their existing bank accounts to their EffesEYE profile, allowing them to (simulate) authorizing bills payments that will be funded by such accounts
4. A registered EffesEYE user with at least one profiled bank account can pay for artime recharge, TV subscription or electricity bills. For each of these, they will have to provide the amount, currency, the account to debit, and well and the utility number to credit. In the case of airtime purchase, utility number is the phone number to credit. This can be the meter number or decoder number for electricity and TV payments respectively.
5.  A succesful bills payment generates a payment ID which can be used to track/query the payment at a later time

### What is the goal of cryptography?

The goal of cryptography is simply to store or transmit (usually sensitive) information across a number of collaborating parties, while significantly reducing the risk of data theft, interception, breach

### What exactly are encryption and decryption?

Encryption is a cryptographic step that converts data from its raw input/readable form into a form that can be safely stored or transmitted with reduced risk of data breach, usually allowing only designated parties to certain credentials, to be able to consume the data and make sense of it.

Decryption on the other hand is the reverse of encryption. Allowing a designated party to descramble previously encrypted data and consume it in a sesnible way

### Can you explain Common Vulnerabilities and Exposures

CVE is generally a documented, established and public data respository of the identities / signatures of well know security vulnerabilities

### How should code review be done

The topic of code reviews is deep and nuanced, but I strongly believe it begins with establishing the goal of code reviews. E.g should it be to identify defects, build collective decision making, enable peer reviews and stronger collaboration, ship higher quality code e.t.c Once the goal is established and socialised, the rest of the code review puzzle can be tamed and easier to effectively build the right culture around. That said, I recommend the following: 

1.  Build a culture of ownership and accountability for all contributors
2.  Build a culture collaboration and stewardship for everyone in the team, such that everyone feels accountable for/to their peers and the product being built
3.  Build / adopt an engineering playbook that stipulates what quality code/technical debt looks like, what best practices are to be adopted and why, and how to get a codebase up to the required standard. Can be required resource for on-boarding, routine refreshers, or a reference.
4. With 1 - 3 out of the way and serving as guiding principles, offload the bulk of (the mundane parts of) code reviews into automated tooling. So much can be achieved by integrating linters, tests, test coverage and tools like CodeClimate and Codacy. 
5.  Optimze for smaller PRs, short cycle times, short time-to-PR-review, and reduced rework, as these seriously hurt code reviews, product delivery and engineer productivity
6.  Adopt a PR teamplate, helping engineers better communiate what has been done / what needs to be reviewed
7.  Get engineers to review each others work as the first review layer before it gets to the senior engineer / tech lead. 
8.  Sprint retrosspectives can and should include notable code review lessons that the entire team needs to learn, else these lessons will be learnt in silos and can even create confusion

### What are your thoughts on risk management and risk assessment matrix

- TODO

### Steps required to harden a server

- TODO

## Security Assessment Questions

> How will you mitigate code injection vulnerability risks for this application

1. We adopted an API-design-first approach. Thus we created an API spec that defines the data schema for all operations at the API level. Leveraing our spec document, we can scrutinze every single inbound HTTP request hitting our backend and immediatly respond with a `4xx` if the request data does not match what is defined in the spec. This means the surface area of code/sql injection is very minimal if it exists
2. We adopted an ORM (Sequelize) which has inbuilt data sanitization checks which we also try to enforce at our models schema and database schema level.

> How will you prevent the risk of weak authentication and session management

1. We adopted token-based authentication with JSON Web Tokens. This means every protected endpoint is intercepted with a check that investigates the validity of the provided token, and only proceeds to call the handler of the requested endpoint if (and only if) the token is verified. 
2.  Tokens are generated with a pletform-wide authentication secret which is stored safely as an environemnt variable. A refresh / change to this secret (e.g in the event of a breach), will invalidate all authentication tokens we already issued to users, forcing them to re-login with the new secret
3.  Session management is handled with Redis - a super fast, secure, highly available and external in-memory system. Thus leveraging industry tested capabilities

> Sensitive Data Exposure is a major risk; how you mitigate the risk of sensitive data exposure for this application

At the point of this writing, we are yet to implement data encryption in the EffesEYE platform, but we are aware of it and have it in our roadmap. This means user can authenticate/authorize, but a breach (over our secure HTTP protocols, which is unlikely but not impossible) could mean their data is exposed. Again, this is top priority!

> How do you prevent broken authentication vulnerabilities

1.  By validating every protected endpoint and resource with a token what has a short lifetime (expiration). This MVP adopts 30 minutes for demonstration, but this could easily be 10 minutes and all client apps can re-negotiate authentication on their users behalf (or redirect to a login screen) if need be
2.  By adopting an externalised token secret, allowing existing tokens to be invalidated in bulk, with a simple refresh of the secret
3.  By adopting an externalized refresh token, e.g one stored in Redis

## What to Deliver - Database Scripts

Permit me to say there'll be no need to run SQL scripts to start or reset the database. We adopted Sequelize as a data abstraction utility for the platform and have provided npm scripts that automatically (re)generate the developemt or test database, and seed them with data, easily:

1. clone the `backend-monolith` repo to your machine and `cd` into it
2. ensure you have Nodejs and npm installed
3. using a terminal and once you are within the project folder, execute `npm run devdb:reset` to reset the (MySQL) development database in our heroku dev server. 
4.  For local tests/evaluation, open the .env.tests file and change the DATABASE_URL to point to your local database. The DATABASE_URL points to a database connection string formatted as `mysql://username:password@hostname/database_name?reconnect=true`. You can then execute `npm run testdb:reset`

## System Design & Architecture

- TODO

## Technology Stack

*   API Design: OpenAPI 3
*   Primary Language:  JavaScript (ES6)   
*   HTTP Handler:  NodeJs / Express
*   Cloud Provider:  Heroku
*   Database:  MySQL
*   Local Test Database:  Postgres
*   Data Access: Sequelize
*   In-memory / Session Store:  Redis
*   Security Scheme:  HTTP Authorization Header via JSON Web Tokens
*   Code Quality:  Eslint + Code Climate
*   Backend / API Monitoring:  Moesif.com


## Feedback On The FSI Sandbox

1.  Naviagtion can be improved. Currently you have to naviagte back to the homepage to switch from one sandbox API to the other
2.  Navigating to the home page reloads the entire web page / APIs, even if that was your 100th view within that browing session. These create friction and somewhat unecessary waits/lags, even for me using the venerable MTN HynetFlex
3. Very wide descrepancies between what is documented in some of the Sandbox APIs and what you can do. E.g I could not get anything under `Get Biller Payment Items` and `Get Billers ISW` in the Sterling bank APIs to work. There's always that feeling that you are probably doing something wrong and I kept poking around the docs and my code (burning tons of time in the process), until I decide the system must be broken or the features are not currently supported. This is not good for developer experience!
4.  A glossary of terms and better feature API descriptions will really help reduce friction and confussion. I have no idea with `Get Biller Payment Items` can do for me in the EffesEYE platform, neither do I have a clue of what `Billers ISW` means.
5.  The current level of documentation leaves so much room for a lot of trial/error and ambiguity. Terms and jargons are not defined. Contraints are also not quite clear. E.g 
    -   I spent a lot of time wondering why my attempt to use the Areica's Talking API to send SMS was failing, only to realise that it had to do with the length of what I provided in the `from` field. Once I switched from `EffesEYE` to `FSI`, it worked. Perharps there's an undocumented lenght contraint somewhere in there.
    -   Calling the NIBSS API with `57650987619` as BVN fails even though it is an 11 character digit like the `12345678901` example provided. What constraints exists here and where are they documented. 
6. As an example, I want to humbly suggest looking at [https://effeseye-api-docs.netlify.app/](https://effeseye-api-docs.netlify.app/). While not complete (e.g naviagtion), is is super clear on what paths / endpoints exists, what HTTP status codes are returned under what circumstance, what data schema is needed for a request and what resposne is expected. I imagine a team can take this spec/documentation, split into frontend and backend teams and go to work simultaneiusly (will be helpful in an FSI hackathon) and quickly ship their MVP
