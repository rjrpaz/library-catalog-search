#!/usr/bin/perl

# $listado = "/var/lib/httpd/htdocs/biblio/data/libro.txt";

open (LIBROS, "</var/lib/httpd/htdocs/biblio/data/libro.txt");
open (DESCRIPTORES, ">/var/lib/httpd/cgi-bin/listado");
	while (<LIBROS>) {
$renglon = $_;
($descriptores) = ($renglon =~ /DESCRIPTORES\s*:\s(.*)/);
@var = split /\s*;\s*/,$descriptores;
foreach $var (@var){
print DESCRIPTORES $var,"\n" if $descriptores;
}

#($var1) = ($descriptores =~/([^;]*)/);
#print DESCRIPTORES $var1,"\n" if $descriptores; 
#(@var2) = ($descriptores =~/;\s*([^;]*)/g);
#foreach $var2 (@var2) {
#($var4) = ($var2 =~ /(.*)\s\Z/);
#print DESCRIPTORES $var4,"\n" if $descriptores;
#($var3) = ($descriptores =~/;(.*)\s*\Z/);
#print DESCRIPTORES $var3,"\n" if $descriptores;
#}

} # Final del While
close (DESCRIPTORES);
close (LIBROS);

print `more /var/lib/httpd/cgi-bin/listado |sort >/var/lib/httpd/cgi-bin/listado_ordenado`;

$renglon_anterior = "";
open (ORDENADO, "</var/lib/httpd/cgi-bin/listado_ordenado");
open (DESC, ">/var/lib/httpd/cgi-bin/desc");
	while (<ORDENADO>) {
$renglon = $_;
if ($renglon ne $renglon_anterior){
print DESC $renglon; 
$renglon_anterior=$renglon;
}

} # Final del While
close (DESC);
close (ORDENADO);
print `rm /var/lib/httpd/cgi-bin/listado`;
print `rm /var/lib/httpd/cgi-bin/listado_ordenado`;

exit (0);