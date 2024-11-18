# Proyecto: Lab 06 - Búsqueda en un Archivo CSV de Universidades Licenciadas 🏫

Este proyecto es un laboratorio desarrollado en **Perl y CGI** que permite realizar búsquedas en un archivo CSV de universidades licenciadas en Perú. La aplicación permite a los usuarios buscar universidades según distintos criterios y muestra los resultados de manera organizada en una tabla interactiva.

---

## Funcionalidades 🚀

- **Búsqueda personalizada**:
  - Por *Periodo de Licenciamiento*.
  - Por *Nombre de Universidad*.
  - Filtrado por *Departamento*, *Provincia* y *Distrito*.
- Muestra un contador con el número de universidades encontradas.
- Interfaz adaptable y accesible, desarrollada con HTML y CSS.


---

## Tecnologías utilizadas 🛠️

- **Lenguajes**: Perl, HTML5, CSS3.
- **Servidor**: CGI a través de Apache.
- **Estilos**: Diseño responsivo con flexbox.
- **Contenedores**: Docker para un entorno de desarrollo consistente.

---

## Estructura del proyecto 📂
```
Lab06/ 
├── css/ 
│   ├── style.css # Estilos CSS para el diseño del formulario y la página 
├── cgi-bin/ │ 
    ├── lab06.pl # Script CGI en Perl que procesa la búsqueda 
    ├── Data_Universidades_LAB06.csv # Archivo CSV con los datos de universidades licenciadas 
├── index.html # Página principal del proyecto 
└── README.md # Documentación del proyecto
```
---

## Cómo ejecutar el proyecto 🖥️

1. Clona este repositorio:
   ```bash
   git clone https://github.com/fenyx144/Busqueda-en-archivo-CSV-Perl-Docker.git
   cd proyecto-lab06
   ```
---
2. Construye y ejecuta el contenedor Docker:

    ```bash
    docker build -t imagen .
    docker run -d -p 8089:80 -p 2202:22 --name servidor imagen
    ```
---
3. Accede a la aplicación desde tu navegador en la URL:
    ```bash
    http://localhost:8089
    ```