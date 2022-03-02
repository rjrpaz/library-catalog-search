#!/usr/bin/perl

$listado = "/httpd/htdocs/biblio/data/libro.txt";

print "Content-type: text/html", "\n\n";

&parse_form_data (*FORM);
$consulta= $FORM{'consulta'};
$aspecto= $FORM{'aspecto'};

if (length($consulta) < 3){
 	&return_error (500, "Error en la B&uacute;squeda", "La palabra
provista para la realizaci&oacute;n de a b&uacute;squeda, no alcanza el largo
m&iacute;nimo requerido.");
}

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

$resultado="";
$no_results = "";
$contador = 0;

print <<end_of_head;
<HTML>
<HEAD><TITLE></TITLE></HEAD>
<BODY BACKGROUND="http://pamela.efn.uncor.edu/biblio/img/fondo_main.gif" BGCOLOR="#ffffcc" TEXT="#000000" LINK="#0000ff" VLINK="#800080" ALINK="#ff0000"><TT>
<CENTER><TABLE WIDTH="100%" BORDER=0><TR><TD ALIGN=LEFT><FONT SIZE=1>Resultados</FONT></TD><TD ALIGN=RIGHT><FONT SIZE=1>Biblioteca - F.C.E.F. y N.&nbsp;&nbsp;&nbsp;P&aacute;g. R</FONT></TD></TR></TABLE><HR WIDTH="100%" ALIGN=CENTER SIZE=1><P>
<IMG SRC="http://pamela.efn.uncor.edu/biblio/img/resultados.gif" ALT="Resultados de la Busqueda"><P>
</CENTER>
end_of_head

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

$resultado = $resultado."<B>Autor:</B> ".$autor."<BR>"."\n" if $autor;
$resultado = $resultado."<B>Director:</B> ".$director."<BR>"."\n" if $director;
$resultado = $resultado."<B>T\&iacute\;tulo:</B> ".$titulo."<BR>"."\n" if $titulo;
$resultado = $resultado."<B>Contenido:</B> ".$contenido."<BR>"."\n" if $contenido;
$resultado = $resultado."<B>Lugar/Editor:</B> ".$lugar."<BR>"."\n" if $lugar;
$resultado = $resultado."<B>Serie:</B> ". $serie."<BR>"."\n" if $serie;
$resultado = $resultado."<B>A\&ntilde\;o:</B> ".$ano."<BR>"."\n" if $ano;
$resultado = $resultado."<B>Paginaci\&oacute\;n:</B> ". $paginacion."<BR>"."\n" if $paginacion;
$resultado = $resultado."<B>Notas:</B> ". $notas."<BR>"."\n" if $notas;
$resultado = $resultado."<B>Serie:</B> ".$serie."<BR>"."\n" if $serie;
$resultado = $resultado."<B>Descriptores:</B> ".$descriptores."<BR>"."\n" if $descriptores;
$resultado = $resultado."<B>Ubicaci\&oacute\;n F\&iacute\;sica:</B> ".$ubicacion."<BR>"."\n" if $ubicacion;
$resultado = $resultado."<B>Inventario:</B> ".$inventario."<BR>"."\n" if $inventario;
$resultado = $resultado."<P><HR><P>"."\n";
$contador++;
$no_results = "ok"
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

###########################################################################
# Resultado de la Busqueda
#
if ($no_results eq "") {
print "<H1>","No se encontraron resultados que respondan a su consulta...","</H1>","<P>";
}else{

if ($contador==1){
$palabra=" solo &iacute;tem responde";
}else{
$palabra=" &iacute;tems responden";
}

print "<H1>",$contador,$palabra," a su requerimiento","</H1>","<BR><BR>";
print "<HR>",$resultado;
}
#
#
##########################################################################

print<<end_of_tail;
<CENTER>
</TT>
<A HREF="http://pamela.efn.uncor.edu/biblio/main.html"><IMG SRC="http://pamela.efn.uncor.edu/biblio/img/home.GIF" WIDTH="60" HEIGHT="60" BORDER=0 ALT=""></A>
<A HREF="http://pamela.efn.uncor.edu/biblio/busquedas.html"><IMG SRC="http://pamela.efn.uncor.edu/biblio/img/buscar.GIF" WIDTH="60" HEIGHT="60" BORDER=0 ALT=""></A>
<A HREF="mailto:biblioteca\@gtwing.efn.uncor.edu"><IMG SRC="http://pamela.efn.uncor.edu/biblio/img/correo.GIF" WIDTH="60" HEIGHT="60" BORDER=0 ALT=""></A>
<HR WIDTH="100%" ALIGN=CENTER SIZE=1>
<A HREF="http://dns.uncor.edu"><IMG SRC="http://pamela.efn.uncor.edu/biblio/img/c5.gif" BORDER=0></A>
</CENTER></BODY></HTML>
end_of_tail

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
	print "Status: ", $status, " ",$keyword, "\n\n";

	print <<Fin_Error;
<TITLE>Programa CGI - Error Inesperado</TITLE>
<H1>$keyword</H1>
<HR>$message</HR>
<P>
Para mayor informaci&oacute;n, contactar a <A HREF = mailto:root\@pamela.efn.uncor.edu>root\@pamela.efn.uncor.edu
</A>.

Fin_Error

	exit(1);
}
