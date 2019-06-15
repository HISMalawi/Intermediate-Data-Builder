# README

This README would normally document whatever steps are necessary to get the
application up and running.

> Things you may want to cover:

* Ruby/ Rails version

* System dependencies

* Configuration

* Database setup/ initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## Ruby/ Rails version

    ruby 2.5.3p105
    
    rails 5.2.3

## System dependencies

## Configuration

> Make sure you copy all required config files in the config/ directory

> Copy all necessary *.yml.example files to *.yml

> Use the example command below as a guide (In the root of application)

    cp config/something.yml.example config/something.yml
    
## Database setup/ initialization
  
**Using an Empty Database**  
> Run the following command to setup and initialize your database with metadata:
  
    rails db:setup
    
> Metadata files reside in the following directory

    db/seed_dumps/

## How to run the test suite

> If tests are available, be sure that all tests pass to allow smooth running of the application

> To run the test suite use the following command:

    rake test
    
## Services (job queues, cache servers, search engines, etc.)

**1. IDS Builder**

This service is used for getting data from RDS (Row Data Storage) to this repository

To build the IDS, you get data from RDS by running the ids_builder service with the following command;

    rails runner bin/ids_builder.rb
    
> **Pre-requisites: Make sure your config/database.yml file is pre-configured for RDS to IDS**
    
...

## Deployment instructions    