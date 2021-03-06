#!/usr/bin/perl

$exclusive_lock = 2;
$unlock_lock = 8;
$listado ="/var/lib/httpd/cgi-bin/temporal";

print `cp /var/lib/httpd/cgi-bin/libro.txt /var/lib/httpd/cgi-bin/libro.bak`;
$listado_de_libros = "/var/lib/httpd/cgi-bin/libro.txt";

# En primer lugar, realiza una sustitucion y limpieza de todos los
# caracteres raros (acentos, etc), y los reemplaza por su equivalente en
# texto plano.

open (LIBROS, "<" . $listado_de_libros); 
open (LISTADO, ">" . $listado); 
flock (LISTADO, $exclusive_lock);
	while (<LIBROS>) {
$_ =~ s/(\-\s\d+\s\-)//g;
$_ =~ s/(\r\n)/\n/g;
$_ =~ s/(\?)/N/g;
$_ =~ s/(\?)/a/g;
$_ =~ s/(\?)/e/g;
$_ =~ s/(\?)/i/g;
$_ =~ s/(\?)/o/g;
$_ =~ s/(\?)/u/g;
$_ =~ s/(\?)/n/g;
$_ =~ s/(\?)/ro./g; #subindice de nro. (numero)
$_ =~ s/(\?)/u/g; #u con dieresis
$_ =~ s/(\)//g;

print LISTADO $_ if /\w/;
}

 	flock (LISTADO, $unlock_lock);
	close (LISTADO);
	close (LIBROS);

# En esta segunda etapa, analiza los campos que tengan mas de una linea de
# tamanio, y los junta todos en una linea. La forma de reconocer estas
# segundas lineas, es analizar aquellas lineas que comienzan con espacios en
# blanco, pero que no incluyan la cadena "reg". En estos casos, va pegando
# estas lineas (previamente las limpia de eventuales new line), y cuando
# llega a una linea que corresponda ya a otro campo, la imprime recien ahi.
# Esto se logra mediante el uso de un flag.

$flag=0;
$mona="Listado de Libros";

$listado = "/var/lib/httpd/cgi-bin/libro.txt";
$listado_de_libros = "/var/lib/httpd/cgi-bin/temporal";

open (LIBROS, "<" . $listado_de_libros); 
open (LISTADO, ">" . $listado); 
flock (LISTADO, $exclusive_lock);
	while (<LIBROS>) {

if ((/^\s+/)&&(!/reg/)) {

$aux1 = $mona;
($aux2) = ($_ =~ /\s*(.*)/);
$mona = $aux1." ".$aux2;
$flag = 0;
} else {

if (!((/^\s+/)&&(!/reg/))) {
print LISTADO $mona,"\n";
} 
($mona) = ($_ =~ /(.*)/);
$flag=1;
} 

}

 	flock (LISTADO, $unlock_lock);
	close (LISTADO);
	close (LIBROS);

print `rm /var/lib/httpd/cgi-bin/temporal`;

exit(0);
