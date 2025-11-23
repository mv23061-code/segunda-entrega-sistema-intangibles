# segunda-entrega-sistema-intangibles
Repositorio de la segunda entrega del sistema web de control de activos intangibles
# Segunda Entrega – Sistema Web de Control de Activos Intangibles

Este repositorio contiene la segunda entrega del proyecto académico, incluyendo la base de datos en PostgreSQL, documentación técnica, diagramas UML, código fuente, mockups de interfaz y evidencia funcional.

## Objetivo

Desarrollar un sistema web funcional para la gestión de activos intangibles, con énfasis en licencias de software, amortización contable y generación de reportes institucionales en formato PDF.

## Estructura del repositorio

- `docs/`: Documentación técnica y académica (Word, PDF).
- `diagrams/`: Diagramas UML y ERD generados en pgAdmin.
- `mockups/`: Mockups de interfaz institucional.
- `src/`: Código fuente del sistema (frontend y backend).
- `sql/`: Script SQL para crear la base de datos en PostgreSQL.
- `annexes/`: Evidencia técnica y capturas de pantalla.

## Módulos implementados

- Registro y consulta de licencias de software.
- Cálculo automático de amortización mensual y acumulada.
- Generación de reportes PDF con encabezado institucional.
- Gestión de usuarios con roles diferenciados (Administrador, Contador, Auditor).
- Validación de llaves foráneas y relaciones entre tablas.
- Inserciones controladas y consultas con `JOIN` para trazabilidad contable.

## Tecnologías utilizadas

- PostgreSQL + pgAdmin
- HTML, CSS, JavaScript
- PHP (backend y generación de PDF)
- jsPDF / TCPDF (exportación de reportes)
- Git + GitHub (control de versiones)

## Evidencia técnica

- Base de datos funcional con integridad referencial.
- Inserciones exitosas en tablas principales (`Usuario`, `Categoria`, `ActivoIntangible`).
- Diagrama ERD generado en pgAdmin.
- Capturas de consultas SQL y reportes generados.
- Validación de errores y correcciones aplicadas en tiempo real.

## Instalación

1. Clonar el repositorio:
