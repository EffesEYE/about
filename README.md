# The EffesEYE (MVP) Patform - Charles Odili's Entry For The FSI.ng CTO Role 

> WIP - I will remove this line to signal that I am done with updating this guide

I have structured this document following the sections describing how this entry will be evaluated, as stipulated in the assessment document sent out. I also added a `FSI Sandbox Feedback` section where I provided (hopefully) valuable feedback to FSI. The completed outline of this document is as follows : 

1.  **What we will evaluate -** here I respond inline to some questions posed in the assessment and attempt to draw attention to certain details that might aid evaluating this project
2.  **Additional questions -** here I provide answers to the questions asked in this section
3.  **Security assessment questions -** here I provide answers to the questions asked in this section
4.  **What to deliver -** here I share details about regenerating the database

## What We Will Evaluate

### Code Quality

1.  **Quality -** The EffesEYE platform is predominatly a Javascript-powered ecosystem. I adopted a layered approach to quality across board, but want to highlight ahderence to a code style (with eslint) and the integration of [CodeClimate](https://codeclimate.com/), showing the [quality rating](https://codeclimate.com/repos/5f8b5b5daa271c3997004343) (maintainability and technical debt) for a given codebase. The goal for me in this project was [not really to try to write perfect code](https://codeclimate.com/repos/5f8f7dd3e5fc6a01a300724f), but to build credibility, transparency and visibility into how quality is rated and reported. 

2.  **Modularity & Application Organisation -** I adopted a [Github Organization](https://github.com/EffesEYE) so that sub-systems of the platform can live in their own repos, instead of trying to fit so much into a single and potentially cumbbersome repo. Each sub-system exposes an artifact (via a URL) that the others then plug into/implement/comsume. Thus [api-spec](https://github.com/EffesEYE/api-spec) houses and evolves the underlying APIs of the entire platform and externalizes a [specification file](https://github.com/EffesEYE/api-spec/blob/dev/reference/spec.v2020-10.yaml) which [backend-monolith](https://github.com/EffesEYE/backend-monolith) implements into a REST backend. [backoffice](https://github.com/EffesEYE/backoffice) houses and evolves the administrative application that enables administration by consuming specific API endpoints from [backend-monolith](https://github.com/EffesEYE/backend-monolith), and [pwa](https://github.com/EffesEYE/pwa) was untimately meant to be the client-side application in the hands of our customers. The glue to all of this is the OpenAPI specification in [api-spec](https://github.com/EffesEYE/api-spec). Thia same philosohpy of modularity is held within each sub-system/repo as well.

3.  **Code documentation -** I am a huge fan of, and prefer clean/self documenting code over undue reliance on code documentation/comments. There is room to improve our current level of documentation generally, but the code is very self explanatory and there'll be little friction getting around it or understanding it. The API spec is however [heavily documented](https://effeseye-api-docs.netlify.app/) as it establishes the contract between systemes within the EffesEYE platform

4.  **Unit & Integration Testing -** While time did not permit us to write as much tests as we would love to, there are a number of unit/integration tests for [backend-monolith](https://github.com/EffesEYE/backend-monolith) which is the core system in the platform. Though few, the tests hit over `90% coverage` because they follow the most code execution path in the system. One huge benefit of our API-first design for EffesEYE is that we can employ utilities like [oatts](https://github.com/google/oatts) to generate tests for the entirety of our core APIs. I mean test stubs for every single HTTP method of every API endpoint defined in our OpenAPI spec!

    Our tests are powered by [Jest](https://jestjs.io/) and currently run locally against a PostgresSQL database (needed to cut down latency and had trouble getting MySQL setup in the Debian VM running inside my Chromebox). The `--coverage` flag collects test coverage data and externalizes them into files within the [./tests/coverage folder](https://github.com/EffesEYE/backend-monolith/tree/dev/tests/coverage) in backend-monolith. Our `make-coverage-badge` npm dependency is then used to generate a test coverage badge which we have displayed galantly in the [README file of backend-monolith!](https://github.com/EffesEYE/backend-monolith/blob/dev/README.md). While running tests and reporting coverage should be part of our CI/CD pipeline, we believe that prioritises quality of `product delivery` wheras we wanted to focus on quality and reliability of our tests which become highly unstable when exposed to external factors like database connection latency

5.  Exception Handling - Practically every error-prone code has a try-catch somewhere in its call heirarchy. We can do more with these (like log them to our Moesif dashboard), but we currently just relay their messages and console log them at certain execution points in the codebase

### Design

See the `System Design & Architecture` section below in this guide

### Functional Completeness

The EffesEYE Platform Can:

1.  Add, authenticate and authorize customers and admins
2.  Get customers to add their bank accounts (NUBAN number) to their EffesEYE profile, after an enquiry/validation is done using the FSI sandbox APIs
3.  Get customers to pay for airtime, tv subscription, and electricity bills, while using the FSI sandbox APIs as much as possible. Payments for tv subscription and electricity bills were only simulated as we could not identify where/how these are supported in the FSI sandbox.

## Additional Questions

### Can you explain in details the application process flow

As described above, the EffesEYE platform comprises of a number of systems: primarily an API, a backend that implements the API as a REST service, an admin web app that exposes administrative functionality to admins by consuming specific backend services, and a customer-facing PWA that is still under construction. An ideal way to explain the process flow will be to do so from the perspective of a persona - an admin or customer

>  With the backend service built, deployed and running at [http://effeseye-api.herokuapp.com/](http://effeseye-api.herokuapp.com/) and also seeded with some user, accounts and payment data - consider the following user journeys

#### The Admin 

1. Begins by going to [https://effeseye-admin.netlify.app/](https://effeseye-admin.netlify.app/) and logs in as an admin with a white-listed email address (chaluwa@gmail.com for now) which is specified in environment variables
2.  A successful login on the server produces a JSON web token which the admin web app uses to authenticate and authorize the admin in subsequent interactions. The token expires after 30 minutes, but can be invalidated by reseting a SECRET set in an environment variable
3. Armed with the auth token, the admin web app automatically navigates the admin to the home screen, which currently is the screen for viewing `Payments` made on the EffesEYE platform so far
4. The admin can also navigate to the `People` screen to see the users (admins and customers) in the platform.
5. While here, transactions going on in the platform are automatically reflected in the admin UI becasue every navigation to the `Payments` or `People` screens fetch the data from the server (yeah, not so performant or cost effective) 
6.  The admin can logout with the logout action button, else he/she will be redirected back to the login screen if they try to interact with the app after 30 minutes of the last login, by which time the authentication token would have expired

#### The User / Customer

> Time did not permit us to build the PWA for customers. In its place, we can simulate the interactions of a customer by going over the steps outlined in [backend-monolith/effeseye.rest](https://github.com/EffesEYE/backend-monolith/blob/dev/effeseye.rest). They can be summarized as: 

1.  The customer first registers to join the EffesEYE platform by providing their BVN, email and a password
2.  The EffesEYE platform validates these entries against the schema defined in EffesEYE [API specification](https://effeseye-api-docs.netlify.app/), and only then does it call the requested endpoint to handle the request. The registration process first needs to verify the BVN with the NIBSS API from the FSI Sandbox, yielding some biodata for the prospective customer. The EffesEYE platform takes this biodata and creates an account for the user, associating it with the provided email and password pair as long as no existing account has the email for this intending customer
3.  On successful registration, the customer gets a welcome email from `Evie`, our Senior Product Marketing Manager!
3.  Once registered, the customer can proceed to add one or more of their existing bank accounts (NUBAN) to their EffesEYE profile, allowing them to make bills payments that will be funded by such accounts. We utilise the Sterling bank's `InterbankNameEnquiry` API to validate the account number and get more information about it
4.  A registered EffesEYE customer with at least one profiled bank account can pay for artime recharge, TV subscription or electricity bills. For each of these, they will have to provide the `amount`, `currency`, the `account` to debit, as well as the utility number to credit. In the case of airtime purchase, the utility number is the phone number to credit. This can be the meter number or TV decoder number for electricity and TV payments respectively.
5.  A succesful bills payment returns a payment ID which can be used to track/query the payment at a later time

### What is the goal of cryptography?

The goal of cryptography is simply to store or transmit (usually sensitive) information across a number of collaborating parties, while significantly reducing the risk of data theft, interception, breach

### What exactly are encryption and decryption?

Encryption is a cryptographic process that converts data from its default input/readable form into a form that can be safely stored or transmitted with reduced risk of data breach, usually allowing only designated parties with certain credentials, to be able to consume the data and make sense of it.

Conversely, Decryption is the reverse of encryption, allowing a designated party to descramble previously encrypted data and consume it in a sesnible way

### Can you explain Common Vulnerabilities and Exposures

CVE is generally a documented, established and public data respository of the identities / signatures of well know security vulnerabilities

### How should code review be done

The topic of code reviews is deep and nuanced, but I strongly believe it begins with establishing the goal of code reviews. E.g should it be to identify defects in code, build collective decision making, enable peer reviews and stronger collaboration, ship higher quality code e.t.c Once the goal is established and socialised, the rest of the code review puzzle can be tamed and easier to effectively build the right culture around. That said, I recommend the following: 

1.  Build a culture of ownership and accountability for all contributors
2.  Build a culture of collaboration and stewardship for everyone in the team, such that everyone feels accountable for/to their peers and the product being built
3.  Build / adopt an engineering playbook that stipulates what quality code/technical debt looks like, what best practices and conventions are to be adopted and why, and how to get a codebase up to the required standard. Such a resource can be required for on-boarding, routine refreshers, or used as a reference.
4.  Optimze for smaller PRs, short cycle times, short time-to-review, and reduced rework, as these seriously hurt code reviews, product delivery and engineer productivity
5.  Adopt a PR teamplate, helping engineers better communiate what has been done/changed and what needs to be reviewed
6. With 1 - 5 out of the way and serving as guiding principles, offload the bulk of (the mundane parts of) code reviews into automated tooling. So much can be achieved by integrating linters, tests, test coverage and tools like CodeClimate and Codacy. This ensures the same standard is upheld across reviews and reduces the risk of nitpicking / personal biases from reviewers
7.  Get engineers to review each others work as the first layer before it gets to the senior engineer / tech lead / engineering manager whose responsibility it is to do code reviews
8.  Reviewers can and should focus their engagement on 
    -   how the code can be improved in areas it might have been flagged by tools in use
    -   how the code / feature aligns with acceptance criteria of the story being worked on
    -   any aspects of quality stipualted in the engineering playbook that tooling may not (yet) be able to highlight
9.  Sprint retrospectives can and should include notable code review lessons/highlights that the entire team needs to learn from, else such lessons will be learnt in silos, lost in 1:1s, and can even create confusion across the rest of the team


## Security Assessment Questions

### How will you mitigate code injection vulnerability risks for this application

1. We adopted an API-design-first approach. Thus we created an API spec that defines the data schema for all operations at the HTTP level. Using our spec document in a middleware that intercepts all inbound (and outbound) HTTP traffic, we can scrutinze every single request hitting our backend and immediatly respond with a `4xx` if the request data does not match what is defined in the spec. This means the surface area of code/sql injection is very minimal if it exists. The spec uses contraints (including regular expressions) to deeply specify the shape and form of the data schema in the API!
2. We adopted an ORM (Sequelize) which has inbuilt data sanitization checks. A major benefit for using ORMs is that they make use of prepared statements, which is a technique to escape input in order to prevent SQL injection vulnerabilities as much as possible

### How will you prevent the risk of weak authentication and session management

1. We adopted token-based authentication with JSON Web Tokens. This means every protected endpoint is intercepted with a check that investigates the validity of the provided token, and only proceeds to call the handler of the requested endpoint if (and only if) the token is verified. Any attempt to interfere or alter the signature of the token automatically invalidates it
2.  Tokens are generated with a platform-wide authentication secret which is stored safely as an environemnt variable. A refresh / change to this secret (e.g in the event of a breach), will invalidate all authentication tokens we already issued to out, forcing user to re-authenticate with the new secret
3.  Tokens have a limited lifespan and expire after 30 minutes - reducing how much time an attack can occur
3.  Session management is best handled with platforms like Redis - a super fast, secure, highly available and external in-memory system. Thus leveraging industry tested capabilities 

### Sensitive Data Exposure is a major risk; how you mitigate the risk of sensitive data exposure for this application

1.  Sensitive data like passwords are not stored in raw text form. Their encrypted equivalents are what gets stored
2.  At the time of this writing, we are yet to implement data encryption across communication boundaries in the EffesEYE platform, but we have it in [our roadmap](https://github.com/orgs/EffesEYE/projects/1). This means while users are constantly on our secure network protocal (HTTPS), a breach (which is unlikely but not impossible) could mean their data is open to interception and eavesdropping.

### How do you prevent broken authentication vulnerabilities

1.  By validating every protected endpoint with a token that has a short lifetime (expiration). This MVP adopts 30 minutes token expiration for demonstration, but this could easily be 10 minutes and all client apps can re-negotiate authentication on their users behalf (or redirect to a login screen) when the need arises
2.  By adopting and externalized token secret, allowing existing tokens to be invalidated in bulk, with a simple refresh of the secret
3.  By adopting an externalized refresh token, e.g one stored in Redis

## What to Deliver - Database Scripts

Permit me to say there'll be no need to run SQL scripts to initialize or reset the database. We adopted Sequelize as a data abstraction utility for the platform and have provided npm scripts that automatically (re)generate the developemt or test database, and seed them with data automatically. Explore any of the following two options

1.  Use database import scripts
    *   See [effeseye_odili_db.sql](https://github.com/EffesEYE/about/blob/main/effeseye_odili_db.sql) for the SQL scripts to regenerate the database with seed data

2.  Use automatic Sequelize database migration
    *  Using a terminal, clone the `backend-monolith` repo to your machine and `cd` into it
    *  Ensure you have `Nodejs` and `npm` installed
    *  Once you are within the project folder, execute `npm run devdb:reset` to reset the (live) MySQL development database in our heroku dev server. 
    *  For local tests/evaluation, open the `.env.test` file in the project's root and change the `DATABASE_URL` field to point to your local database. The value of this field is a database connection string formatted as `mysql://username:password@hostname/database_name`. You can then execute `npm run testdb:reset`

## System Design & Architecture

- TODO

## Technology & Tools

*   API Design: OpenAPI 3
*   Primary Language:  JavaScript (ES6)   
*   HTTP Handler:  NodeJs / Express
*   Cloud Provider:  Heroku
*   Live (Dev) Database:  MySQL
*   Local (Test) Database:  Postgres
*   Data Access / ORM: Sequelize
*   In-memory / Session Store:  Redis
*   Security Scheme:  HTTP Authorization Header (containing JSON Web Token)
*   Code Quality:  Eslint, Code Climate
*   Tests:   Jest, jest-openapi
*   Test Coverage: make-coverage-badge
*   Backend / API Monitoring:  Moesif
*   API Interceptor Middleware: express-openapi-validator
*   Email:  Gmail 
*   Client-side State Management: Immer
*   Client-side Routing:    Pagejs


## FSI Sandbox Feedback

1.  Naviagtion can be significantly improved. Currently you have to naviagte back to the sandbox homepage to switch from one API to the other

2.  Navigating back to the sanbox home page always reloads the entire web page / APIs, even if that was your 100th view of that page within that particular browsing session. These create friction and unecessary waits/lags even for me using the venerable MTN HynetFlex. I know that pdf downloads are available on the sandbox, but given my feedback in items 3 and 4 below, I believe they will quickly become a liability both to those who download them (for anything other than very short term use), and the FSI team meant to be maintaining them. 

3. Wide descrepancies between what is documented in some of the sandbox APIs and what you can actually do. E.g I could not get anything under `Get Biller Payment Items` and `Get Billers ISW` in the Sterling bank APIs to work. There's always that feeling that you are probably doing something wrong, leaving you on the edge and poking around the docs and your code, ultimately burning tons of time in the process. At some point, I decided the system was either broken or those particular features were not currently deployed / supported. This is not good for developer experience!

4. Much wider decrepancies between what is documented as supported APIs in the sandbox vs what is available in the published client libraries / SDKs. None of the Sterling bank's `Get Biller Payment Items` and `Get Billers ISW` functionality is present in the Nodejs client libraries. This is symptomatic of a broken product delivery process or schedule, asit appears the APIs in the online sandbox evolve in a way that is completely different from the development of the client libraries, causing friction and confusion about what one is to be used / consulted / relied on.

4.  A glossary of terms and better feature / API descriptions will really help reduce friction and confussion. Continuing with my earlier example, I have no idea what `Get Biller Payment Items` means or can do for me in the EffesEYE MVP, neither do I have a clue of what `Billers ISW` is about. I believe this is implicitly inhibiting adoption and inovation, and has the potential of creating false engagements (noise) in the FSI community channels where engineers will likely go to raise questions in an attempt to close these knowledge gaps. Finally this is potentially is missed opportunity in creating a mass of engineers who can make the sandbox their home / reference for terminology in our fast growing fintech industry - terms they will definitey encounter in their fintech product journeys, which I believe FSI is meant to be catalyzing.

5.  The current level of documentation leaves so much room for a lot of trial/error-driven development (yeah, I just made that up). API features not well described means engineers are constantly trying out code to see what will work and what the outcome will be. Contraints on input data not being clear means engineers are up for a surprise / steep learning curve as they integrate with APIs in the sandbox. E.g 
    -   I spent a lot of time wondering why my attempt to use the Africa's Talking API to send SMS was failing, only to later discover that it had to do with the length of what I provided in the `from` field. Once I switched from `EffesEYE` to `FSI`, it worked. Perharps there's an undocumented lenght contraint somewhere in there!
    -   Calling the NIBSS API with `57650987619` as a BVN value cause the API call to fail even though it is still an 11 number digit like the `12345678901` example provided. What constraints exists here and where are they documented?

6. As an example, I want to humbly suggest looking at this example from our API spec at [https://effeseye-api-docs.netlify.app/#operation/post-airtime-recharge](https://effeseye-api-docs.netlify.app/#operation/post-airtime-recharge). While not perfect / complete (e.g naviagtion is still poor), is is super clear on what paths / endpoints exists, what HTTP status codes are returned under what circumstance, what data schema is needed for a request (with samples) and what resposne is expected (with samples). With the level of detail and specificty of the definitions, I imagine a team can take this spec/documentation, split into frontend and backend teams and go to work simultaneiusly because they are both clear on the contract and rules of data exchange. The backend team know what endpoints to build and what data to expect, while the frontend team knows what data to send. I believe this can be empowering for engineers and teams in an FSI hackathon working to quickly ship their MVP!

7.  Even after incorporating my feedback from 1 - 6 above, there's still one critical missiing bit to highlight - that the sandbox arguably feels like a listing of resources and more needs to be done to make it into a product that delivers XYZ value to engineers. Just like many company websites dont just list their services but go ahead to share case studies of how such services have been used to solve specific kinds of problems, the sandbox can really benefit from something like a recipies section. I am not sure is this is prohibitive to engineer who are meant to be innovating (figuring things out and competing) during FSI hackthons, but imagine how helpful it could be to include a recipe (step-by-step guide) on how to go from a particular idea/problem to a complete working solution invloving several APIs in the sanbox. In other words, in addition to the sandbox being a tool that says "here are these APIs you can use to prototype your fintech solutions", how can we get the sandbox to be a tool that says "oh, by the way, here is how you'd build out, test and deploy a solution to THIS KIND OF problem"

