#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use utf8;

# Crear una instancia de CGI
my $q  = CGI->new;

# Obtener los parámetros del formulario
my $cadena = $q->param('cadena') || '';
my $palabraBuscar = $q->param('palabraBuscar') || '';
my $palabraReemplazar = $q->param('palabraReemplazar') || '';

# Llamada a la subrutina recursiva para hacer el reemplazo
my $resultado = reemplazarPalabraRecursivo($cadena, $palabraBuscar, $palabraReemplazar);

# Subrutina recursiva para reemplazar palabras
sub reemplazarPalabraRecursivo {
    my ($texto, $buscar, $reemplazar) = @_;

    # Si no hay palabra a buscar, retornar el texto original
    return $texto if $buscar eq '';

    # Buscar la primera aparición de la palabra y reemplazarla
    if ($texto =~ s/\b\Q$buscar\E\b/$reemplazar/) {
        # Llamada recursiva para continuar con el reemplazo en el resto del texto
        return reemplazarPalabraRecursivo($texto, $buscar, $reemplazar);
    }
    return $texto;
}

# Imprimir la cabecera y el contenido HTML
print $q->header('text/html');
print "<!DOCTYPE html>";
print "<html lang=\"es\">";
print "<head>";
print "<title>Buscar y Reemplazar</title>";
print "<link rel=\"stylesheet\" href=\"../css/mystyle.css\">";
print "</head>";
print "<body>";

# Contenedor principal
print "<div class=\"container\">";
print "<h1>Buscar y Reemplazar</h1>";

# Formulario para ingresar la cadena, palabra a buscar y palabra de reemplazo
print "<form action=\"evalCadena.pl\" method=\"get\">";
print "<div class=\"form-group\">";
print "<label for=\"cadena\">Ingresar texto:</label>";
print "<textarea id=\"cadena\" name='cadena' rows=\"4\" placeholder=\"Escriba el texto aquí...\">$cadena</textarea>";
print "</div>";

print "<div class=\"form-group\">";
print "<label for=\"palabraBuscar\">Palabra a buscar:</label>";
print "<input type=\"text\" id=\"palabraBuscar\" name='palabraBuscar' value=\"$palabraBuscar\" placeholder=\"Escriba la palabra a buscar\">";
print "</div>";

print "<div class=\"form-group\">";
print "<label for=\"palabraReemplazar\">Reemplazar por:</label>";
print "<input type=\"text\" id=\"palabraReemplazar\" name='palabraReemplazar' value=\"$palabraReemplazar\" placeholder=\"Escriba el reemplazo\">";
print "</div>";

print "<div class=\"row\">";
print "<input type=\"submit\" value=\"Ejecutar\">";
print "</div>";
print "</form>";

# Si se ha ingresado una palabra a buscar, mostrar el textarea con el resultado
if ($palabraBuscar ne '') {
    print "<div class=\"form-group\">";
    print "<label for=\"resultado\">Resultado del reemplazo:</label>";
    print "<textarea id=\"resultado\" rows=\"4\" readonly>$resultado</textarea>";
    print "</div>";
}

# Footer que será mostrado en la página
print "<footer class=\"footer\">";
print "Rivas Revilla Diego Eduardo &copy; 2024/10/24 - Programación Web Lab. Grupo F.";
print "</footer>";

print "</div>";  # Fin del contenedor principal

print "</body>";
print "</html>";
