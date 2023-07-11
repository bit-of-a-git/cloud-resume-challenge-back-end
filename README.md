# Cloud Resume Challenge - Back-End

This repository holds the back-end section of Forrest Brazzeal's Cloud Resume Challenge, which I built on AWS using Terraform.

<img src="/img/CloudResumeChallenge.drawio.png"/>

## Objectives

To create a site visitor counter using an API Gateway, Lambda, and DynamoDB, and to create a CI/CD pipeline which tests any changes before they are allowed to merge to production.

## Mods

* Unique visitors counter using hashed visitor IPs
* Changes deployed to dev account, only merge and deploy to production once tests pass
* Dev resources are uniquely named using Git commit ID and torn down after successful tests

<img src="/img/Hashed IPs.png"/>
<img src="/img/Hit counter and unique visitors.png"/>

## Reflection

This step posed a few challenges when recreating in Terraform as it seemed to deploy resources slightly differently than they are deployed through the console. In particular, the API Gateway and Lambda integration took some troubleshooting. I eventually resolved any issues by looking up error messages and found a CORS module which was very useful.

It also took some experimenting to get the Cypress tests working through Github Actions. I was delighted the first time I saw the API URL being passed in correctly and passing tests!

## Automation and CI/CD

Changes are made to the dev branch and pushed to Github. When a pull request is made to main, resources are deployed and tested in the dev account. After passing, the code is allowed to merge to main. This triggers Github Actions, which automatically deploys the new configuration to the production account.

## Blog Post

You can find my blog post [here](https://dev.to/bit-of-a-git/a-security-focused-cloud-resume-challenge-16aa)