#!/usr/bin/perl

$listado = "/httpd/htdocs/libro.txt";

print "Content-type: text/plain", "\n\n";
&parse_form_data (*FORM);
$consulta= $FORM{'autor'};
# $consulta="ards";

$autor = "";
$titulo = "";
$director = "";
$contenido = "";
$serie = "";
$lugar = "";
$ano = "";
$paginacion = "";
$notas = "";
$serie = "";
$descriptores = "";
$ubicacion = "";
$inventario = "";
$clean_line = "";

open (LIBROS, "<". $listado);
	while (<LIBROS>) {
$one_line = $_;
($titulo) = ($one_line =~ /TITULO\s*:\s(.*)/) if !$titulo;
($director) = ($one_line =~ /DIRECTOR\s*:\s(.*)/) if !$director;
($autor) = ($one_line =~ /AUTOR\(S\)\s*:\s(.*)/) if !$autor;
($lugar) = ($one_line =~ /LUGAR\/EDITOR\s*:\s(.*)/) if !$lugar;
($contenido) = ($one_line =~ /CONTENIDO\s*:\s(.*)/) if !$contenido;
($serie) = ($one_line =~ /SERIE\s*:\s(.*)/) if !$serie;
($ano) = ($one_line =~ /ANO\s*:\s(.*)/) if !$ano;
($paginacion) = ($one_line =~ /PAGINACION\s*:\s(.*)/) if !$paginacion;
($notas) = ($one_line =~ /NOTAS\s*:\s(.*)/) if !$notas;
($serie) = ($one_line =~ /SERIE\s*:\s(.*)/) if !$serie;
($descriptores) = ($one_line =~ /DESCRIPTORES\s*:\s(.*)/) if !$descriptores;
($ubicacion) = ($one_line =~ /UBIC.\sFISICA\s*:\s(.*)/) if !$ubicacion;
($inventario) = ($one_line =~ /INVENTARIO\s*:\s(.*)/) if !$inventario;

($clean_line) = ($one_line =~ /reg.:\s(.*)/);

if ($clean_line ne "") {

if ($autor =~ /$consulta/i) {
print "Autor: ",$autor,"\n" if $autor;
print "Director: ",$director,"\n" if $director;
print "Titulo: ",$titulo,"\n" if $titulo;
print "Contenido: ",$contenido,"\n" if $contenido;
print "Lugar/Editor : ",$lugar,"\n" if $lugar;
print "Serie: ", $serie,"\n" if $serie;
print "Ano: ",$ano,"\n" if $ano;
print "Paginacion: ", $paginacion,"\n" if $paginacion;
print "Notas: ", $notas,"\n" if $notas;
print "Serie: ",$serie,"\n" if $serie;
print "Descriptores: ",$descriptores,"\n" if $descriptores;
print "Ubicacion Fisica : ",$ubicacion,"\n" if $ubicacion; 
print "Inventario: ",$inventario,"\n" if $inventario;
print "\n\n";
}

$autor = "";
$titulo = "";
$contenido="";
$director = "";
$lugar = "";
$serie = "";
$ano = "";
$paginacion = "";
$notas = "";
$serie = "";
$descriptores = "";
$ubicacion = "";
$inventario = "";
$clean_line = "";

}

} # Final del While
close (LIBROS);
exit (0);

sub parse_form_data
{
local (*FORM_DATA) = @_;

local ( $request_method, $query_string, @key_value_pairs, $key_value, $key,
$value);

$request_method = $ENV{'REQUEST_METHOD'};

if ($request_method eq "GET") {
 	$query_string = $ENV{'QUERY_STRING'};
} elsif ($request_method eq "POST") {
 	read (STDIN, $query_string, $ENV{'CONTENT_LENGTH'});
} else {
 	&return_error (500, "Error en el Servidor", "El servidor no soporta
 el Metodo de traspaso Utilizado");
}

@key_value_pairs = split (/&/, $query_string);

foreach $key_value (@key_value_pairs) {
	($key, $value) = split (/=/, $key_value);
	$value =~ tr/+/ /;
	$value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack ("C", hex ($1))/eg;

	if (defined($FORM_DATA{$key})) {
		$FORM_DATA{$key} = join ("\0", $FORM_DATA{$key}, $value);
	} else {
		$FORM_DATA{$key} = $value;
	}
}
}

sub return_error
{
	local ($status, $keyword, $message) = @_;

	print "Content-type: text/html", "\n";
	print "Status: ", $status, " ", $keyword, "\n\n";

	print <<Fin_Error;

<TITLE>Programa CGI - Error Inesperado</TITLE>
<H1>$keyword</H1>
<HR>$message</HR>
Contactar a <A HREF = mailto:root\@pamela.efn.uncor.edu>root\@pamela.efn.uncor.edu
</A>por informaci&oacute.

Fin_Error

	exit(1);
}
