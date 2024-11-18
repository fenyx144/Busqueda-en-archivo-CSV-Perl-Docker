#!/usr/bin/perl
use strict;
use warnings;
use CGI;

# Crear objeto CGI
my $cgi = CGI->new;

sub eliminar_tildes {
    my ($texto) = @_;
    $texto =~ tr/áéíóúÁÉÍÓÚ/aeiouAEIOU/;  # Reemplazar tildes
    return $texto;
}

# Obtener parámetros del formulario
my $tipoBusqueda = $cgi->param('tipoBusqueda');
my $comentario = $cgi->param('comentario');
my $departamento = $cgi->param('departamento');
my $provincia = $cgi->param('provincia');
my $distrito = $cgi->param('distrito');

# Definir el archivo CSV
my $archivo_csv = 'Data_Universidades_LAB06.csv';

# Leer el archivo CSV
open my $fh, '<', $archivo_csv or die "No se puede abrir el archivo: $!";

# Leer encabezados y almacenarlos
my $encabezados = <$fh>;
chomp $encabezados;
my @cabeceras = split /,/, $encabezados;  # Dividir los campos de la primera línea en un array

# Crear un array para almacenar los resultados
my @resultados;

while (my $linea = <$fh>) {
    chomp $linea;
    my @campos = split /,/, $linea;  # Dividir los campos por coma
    
   if ($tipoBusqueda == 1) {
       
    # Ahora se puede comparar sin problemas de tildes ni de mayúsculas/minúsculas
    if ($campos[1] =~ /$comentario/i) {
        push @resultados, \@campos;
    }
}
 elsif ($tipoBusqueda == 2) {
        if (eliminar_tildes($campos[2]) =~ /$comentario/i) {
            push @resultados, \@campos;
        }
    } elsif ($tipoBusqueda == 3) {
        if (eliminar_tildes($campos[3]) =~ /\Q$comentario\E/i) {
            push @resultados, \@campos;
        }
    }
    # Si el tipo de búsqueda es 1 (Periodo de Licenciamiento)
    elsif ($tipoBusqueda == 4) {
        if ($comentario && $campos[6] =~ /$comentario/i) {
            push @resultados, \@campos;
        }
    }
    # Si el tipo de búsqueda es 2 (Departamento, Provincia, Distrito)
    elsif ($tipoBusqueda == 5) {
        if ($departamento && $campos[7] eq $departamento &&
            $provincia && $campos[8] eq $provincia &&
            $distrito && $campos[9] eq $distrito) {
            push @resultados, \@campos;
        }
    }
}

# Generar HTML de la respuesta
print $cgi->header('text/html');
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Universidades - Lab 06</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header>
        <h1>Lab 06: Búsqueda en un archivo CSV de Universidades Licenciadas</h1>
    </header>
    <main>
        <form action="/cgi-bin/lab06.pl" method="GET" class="form-container"> 
            <div class="form-row">
                <div class="form-col">
                    <select id="tipoBusqueda" name="tipoBusqueda">
                        <option value="">Seleccione</option>
                        <option value="1" @{[($tipoBusqueda == 1) ? 'selected' : '']}>Nombre</option>
                        <option value="2" @{[($tipoBusqueda == 2) ? 'selected' : '']}>Tipo de gestion</option>
                        <option value="3" @{[($tipoBusqueda == 3) ? 'selected' : '']}>Estado de Licenciamiento</option>
                        <option value="4" @{[($tipoBusqueda == 4) ? 'selected' : '']}>Periodo de licenciamiento</option>
                        <option value="5" @{[($tipoBusqueda == 5) ? 'selected' : '']}>Ubicacion</option>
                    </select>
                    </select>
                </div>
                <div class="form-col">
                    <input type="text" id="comentario" name="comentario">
                </div>
            </div>
            <div class="form-row">
                <label for="departamento">Departamento:</label>
                <select id="departamento" name="departamento">
                    <option value="">Seleccione</option>
                    <option value="AMAZONAS" @{[($departamento eq 'AMAZONAS') ? 'selected' : '']}>Amazonas</option>
                    <option value="ANCASH" @{[($departamento eq 'ANCASH') ? 'selected' : '']}>Áncash</option>
                    <!-- Agrega más departamentos aquí -->
                </select>
            </div>
            <div class="form-row">
                <label for="provincia">Provincia:</label>
                <select id="provincia" name="provincia">
                    <option value="">Seleccione</option>
                    <optgroup label="Amazonas">
                        <option value="CHACHAPOYAS" @{[($provincia eq 'CHACHAPOYAS') ? 'selected' : '']}>Chachapoyas</option>
                        <option value="BAGUA" @{[($provincia eq 'BAGUA') ? 'selected' : '']}>Bagua</option>
                        <!-- Más provincias -->
                    </optgroup>
                    <!-- Agrega más provincias -->
                </select>
            </div>
            <div class="form-row">
                <label for="distrito">Distrito:</label>
                <select id="distrito" name="distrito">
                    <option value="">Seleccione</option>
                    <optgroup label="Chachapoyas (Amazonas)">
                        <option value="CHACHAPOYAS" @{[($distrito eq 'CHACHAPOYAS') ? 'selected' : '']}>Chachapoyas</option>
                        <option value="ASUNCION" @{[($distrito eq 'ASUNCION') ? 'selected' : '']}>Asunción</option>
                        <!-- Más distritos -->
                    </optgroup>
                </select>
            </div>
            <div class="form-row">
                <button type="submit" class="btn">Buscar</button>
            </div>
        </form>
HTML

# Si hay resultados, mostrarlos en una tabla
if (@resultados) {
    my $num_universidades = scalar @resultados;
    print "<p><strong>Encontradas $num_universidades universidades</strong></p>";

    print "<table border='1'><tr>";
    
    # Imprimir todas las cabeceras dinámicamente
    foreach my $cabecera (@cabeceras) {
        print "<th>$cabecera</th>";
    }
    
    print "</tr>";
    
    # Imprimir los resultados
    foreach my $row (@resultados) {
        print "<tr>";
        # Imprimir cada campo de la fila
        foreach my $campo (@$row) {
            print "<td>$campo</td>";
        }
        print "</tr>";
    }
    print "</table>";
} else {
    print "<p>No se encontraron resultados.</p>";
}

print <<HTML;
    </main>
    <footer>
        <p>&copy; 2024 - Pw1 - 24b Grupo D | Hecho por Juan Perez</p>
    </footer>
</body>
</html>
HTML

close $fh;
