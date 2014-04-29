# The Angular-Axiom generator 

A [Yeoman](http://yeoman.io) generator for [AngularJS](http://angularjs.org) and [Axiom](https://github.com/tsujigiri/axiom).

Axiom is an Erlang-based micro-framework.  For AngularJS integration with other micro-frameworks, see https://github.com/rayokota/MicroFrameworkRosettaStone.

## Installation

Install [Git](http://git-scm.com), [node.js](http://nodejs.org), [Erlang](http://www.erlang.org/), and [MySQL](http://www.mysql.com/).

Install Yeoman:

    npm install -g yo

Install the Angular-Axiom generator:

    npm install -g generator-angular-axiom

The above prerequisites can be installed to a VM using the [Angular-Axiom provisioner](https://github.com/rayokota/provision-angular-axiom).

## Creating an Axiom service

In a new directory, generate the service:

    yo angular-axiom
    
Create a user and database in MySQL as specified in the file `priv/app.config`.

Install dependencies and build the service:

    make
    
Run the service:

	make run

Your service will run at [http://localhost:8080](http://localhost:8080).


## Creating a persistent entity

Generate the entity:

    yo angular-axiom:entity [myentity]

You will be asked to specify attributes for the entity, where each attribute has the following:

- a name
- a type (String, Integer, Float, Boolean, Date, Enum)
- for a String attribute, an optional minimum and maximum length
- for a numeric attribute, an optional minimum and maximum value
- for a Date attribute, an optional constraint to either past values or future values
- for an Enum attribute, a list of enumerated values
- whether the attribute is required

Files that are regenerated will appear as conflicts.  Allow the generator to overwrite these files as long as no custom changes have been made.

Install dependencies and build the service:

    make
    
Run the service:

	make run
	    
A client-side AngularJS application will now be available by running

	grunt server
	
The Grunt server will run at [http://localhost:9000](http://localhost:9000).  It will proxy REST requests to the Axiom service running at [http://localhost:8080](http://localhost:8080).

At this point you should be able to navigate to a page to manage your persistent entities.  

The Grunt server supports hot reloading of client-side HTML/CSS/Javascript file changes.

