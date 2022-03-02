# library-catalog-search

Very old script to parse and search in the library catalog from where I studied.

Main reference for this was the book: "CGI Programming on the World Wide Web" by Shishir Gundavaram.

The library used a version of [ISIS](https://es.wikipedia.org/wiki/CDS/ISIS). This is a kind of standard for public libraries.

At that moment, there was no documented API to search into the data. Because of this, we required to export the database to text and then clean the content a little.

## Content

### catalog

Includes a sample database from ISIS. It also includes a script (*limpieza.pl*) that cleaned the file to be usable for the search script.

### cgi

Includes the search scripts (*autor.pl*, *search.pl*). Return the result in html format.

### html

Includes the search form (*biblio.html*).
