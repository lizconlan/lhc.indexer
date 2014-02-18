lhc.indexer
===========

Search indexing thing for the 
[Large Hansard Collider](https://github.com/lizconlan/large-hansard-collider).

A little rough and ready, and decidedly weird to start working on this while 
the Collider's only half built but, but... Reasons. Honest.

Also, frankly, [dogfooding](http://en.wikipedia.org/wiki/Eating_your_own_dog_food).

## Oddities

Deliberately doesn't build the database as it assumes that the database has 
already been created and populated by the Collider.

## Erm, why is this separate?

We wanted to have the option to run this from its own box, although we're 
not necessarily going to implement it that way. So the Collider, the Indexer
and the Search Front End are going to go into their own repos.

## Assumptions

* Ruby 2.0.x
* Postgres 9.3.x
* Elasticsearch 1.0.x