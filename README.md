# README

PCO-Group-Signups is a rails application meant to assist in signing people up for groups.  This functionality exists within PCO, but giving group leaders full access to do this within the app apparently gives them too much data access, so we don't do it.  Having it in a separate app means that the app can have full data access but only expose the data that we want them to use.

## Ruby version 
This was built with Ruby 3.4.2.

## Rails version
This was built with Rails 8.0.2.

## How to run the test suite

## Running a local copy

### Install Dependencies

From the project root:
```bash
bundle install --gemfile Gemfile
```
### Set up master key

Get the master key for the app's PCO credentials from someone on the project.  Not posted here on purpose ;) Put the key into a `/config/master.key` file.  

### Running the application

```bash
rails server
```

If this works right you should see this in your output:

```bash
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
```

This will run an application that you can reach in your browser at [https://localhost:3000](https://localhost:3000)