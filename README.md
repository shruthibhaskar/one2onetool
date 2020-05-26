# one2onetool
Mol assessment

Below is a public Github repository containing a simple Node.js web application.
https://github.com/sngsweekeat/one2onetool
The application makes use of a built-in JSON data file, whose filename can be specified in
the “DATA_FILE” environment variable. If the environment variable is not found, then it will
default to using “Questions.json”.
Fork the repository to your own Github account (or any other public Git server), and use this
for the rest of the exercise.
Create a CI/CD pipeline (we prefer Jenkins, but do let us know if you decide to use something
else) that monitors the “release” and “staging” branches of the repository, and when new
commits are found, performs the following:
1. pull the branch from the repository,
2. build the application,
3. run the unit tests,
4. build a docker image that host your application,
5. publish the docker image on docker hub or a public cloud hosting docker repository,
6. deploys the application to a public cloud hosting (you can pick any public cloud
provider with free usage tier).
If any steps above fail, the pipeline should be stopped and an email alert sent.
Additionally, if the deployment is from the “staging” branch, the application should use
“Questions-test.json” as the default data file. If deployed from the “production” branch,
“Questions.json” should be used as the default data file.
Bonus:
● In the docker image, run the application as non-root user
● Add a step in the pipeline to clean up the docker images after deployment
● Figure out and implement an approach to automate the updating of version
numbering in package.json with every release.
