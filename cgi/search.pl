#!/usr/bin/perl

$listado = "/var/lib/httpd/htdocs/libro.txt";

print "Content-type: text/html", "\n\n";
print "<HTML>", "\n";
print "<HEAD></HEAD>", "\n";
print "<BODY BACKGROUND=\"\" BGCOLOR=\"#ffffcc\"><H1>Resultados de la busqueda</H1>", "\n";
print "<HR><PRE><H3>";

&parse_form_data (*FORM);
$consulta= $FORM{'consulta'};
$aspecto= $FORM{'aspecto'};
# $consulta="ards";
# print "aspecto: ",$temporal,"\n";

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
$nuevo_registro = "";
$bandera = "";
$no_results = "";

open (LIBROS, "<". $listado);
	while (<LIBROS>) {
$renglon = $_;

if ($renglon =~ /$consulta/i) {
$bandera = "ok";
}

($titulo) = ($renglon =~ /TITULO\s*:\s(.*)/) if !$titulo;
($director) = ($renglon =~ /DIRECTOR\s*:\s(.*)/) if !$director;
($autor) = ($renglon =~ /AUTOR\(S\)\s*:\s(.*)/) if !$autor;
($lugar) = ($renglon =~ /LUGAR\/EDITOR\s*:\s(.*)/) if !$lugar;
($contenido) = ($renglon =~ /CONTENIDO\s*:\s(.*)/) if !$contenido;
($serie) = ($renglon =~ /SERIE\s*:\s(.*)/) if !$serie;
($ano) = ($renglon =~ /ANO\s*:\s(.*)/) if !$ano;
($paginacion) = ($renglon =~ /PAGINACION\s*:\s(.*)/) if !$paginacion;
($notas) = ($renglon =~ /NOTAS\s*:\s(.*)/) if !$notas;
($serie) = ($renglon =~ /SERIE\s*:\s(.*)/) if !$serie;
($descriptores) = ($renglon =~ /DESCRIPTORES\s*:\s(.*)/) if !$descriptores;
($ubicacion) = ($renglon =~ /UBIC.\sFISICA\s*:\s(.*)/) if !$ubicacion;
($inventario) = ($renglon =~ /INVENTARIO\s*:\s(.*)/) if !$inventario;

($nuevo_registro) = ($renglon =~ /reg.:\s(.*)/);

if ($nuevo_registro ne "") {

if ((($aspecto eq "Autor") && ($autor =~ /$consulta/i)) || (($aspecto eq "Titulo") && ($titulo =~ /$consulta/i)) || (($aspecto eq
"PC") && ($bandera eq "ok"))){
print "Autor: ",$autor,"<BR>","\n" if $autor;
print "Director: ",$director,"<BR>","\n" if $director;
print "Titulo: ",$titulo,"<BR>","\n" if $titulo;
print "Contenido: ",$contenido,"<BR>","\n" if $contenido;
print "Lugar/Editor : ",$lugar,"<BR>","\n" if $lugar;
print "Serie: ", $serie,"<BR>","\n" if $serie;
print "Ano: ",$ano,"<BR>","\n" if $ano;
print "Paginacion: ", $paginacion,"<BR>","\n" if $paginacion;
print "Notas: ", $notas,"<BR>","\n" if $notas;
print "Serie: ",$serie,"<BR>","\n" if $serie;
print "Descriptores: ",$descriptores,"<BR>","\n" if $descriptores;
print "Ubicacion Fisica : ",$ubicacion,"<BR>","\n" if $ubicacion; 
print "Inventario: ",$inventario,"<BR>","\n" if $inventario;
print "\n\n";
$no_results = "ok"
# print "<BR><BR>";
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
$nuevo_registro = "";
$bandera = "";

}

} # Final del While
close (LIBROS);

if ($no_results eq "") {
print "No se encontraron resultados que respondan a su consulta ..."
}

print "<HR></H3></PRE>", "\n";
print "</BODY></HTML>", "\n";

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