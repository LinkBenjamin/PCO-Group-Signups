# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Ruby version 
This was built with 3.4.2

## System dependencies

## Configuration

## Database creation

## Database initialization

## How to run the test suite

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

## Running the application

First, install dependencies.  From the project root:
```bash
bundle install --gemfile Gemfile
```

Next, get the master key for the app's PCO credentials from someone on the project.  Not posted here on purpose ;) Put the key into a `/config/master.key` file.  Then you can start the rails server:

```bash
rails server
```

If this works right you should see this in your output:

```bash
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
```

This will run an application that you can reach in your browser at [https://localhost:3000](https://localhost:3000)