# Respaldo base de datos MongoDB
Esta es una guía básica para automatizar y gestionar copias de seguridad para registros almacenados en mongodb haciendo uso del sistema operativo ubuntu 18.04 en conexión con dropbox para cargar las copias de seguridad.

## Herramientas
- Para subir los documentos a dropbox se utilizó un script de BASH que funciona para cargar, descargar, enumerar o eliminar archivos de Dropbox, un servicio de copia de seguridad, sincronización y uso compartido de archivos en línea el cual les comparto https://github.com/andreafabrizi/Dropbox-Uploader. El mismo no almacena nuestros datos ya que se conecta a la api de dropbox directamente.

- Para programar las tareas se usó el **crontab** de linux.

- Para generar los respaldos se utilizó **Mongodump** que es una utilidad para crear una exportación binaria del contenido de una base de datos.

### Pasos

- Descargar el script BASH de dropbox antes mencionado y darle los permisos para poder ejecutarlo con el comando **chmod +rx dropbox_uploader.sh**, correrlo con **bash dropbox_uploader.sh** y seguir las instruciones.

- Crear otro script donde haremos uso de *mongodump* el cual ejecutaremos con un *crontab*.

```bash
PATH=/bin:$PATH
dt=`date +%y-%m-%d`
mongodump --db MY_DATABASE --username MY_USER --password MY_PASSWORD --authenticationDatabase admin --out /home/ubuntu/backup-files/backup-$dt
bash /home/ubuntu/dropbox_uploader.sh upload /home/ubuntu/backup-files/backup-$dt /backup-bds/backup-$dt
echo "EJECUTADO CORRECTAMENTE"
```
**PATH** es una variable de entorno. Básicamente le dice a su máquina dónde buscar programas en este caso la utilidad *Date*.
**dt** Almacena la fecha actual del servidor,
**mongodump** hace respaldo de los registros de nuestra base de datos y los almacena en la carpeta que le especifiquemos.
Para subir los archivos con el script *dropbox_uploader* usaremos la función **upload** al cual le debemos indicar la carpeta o los archivos que queremos subir además de la carpeta destino en nuestro dropbox.

- Configurar el *crontab* de linux ejecutando el comando **crontab -e** y editarlo agregando lo siguiente:
```
MAILTO=""
PATH=/usr/bin
59 23 * * * /home/ubuntu/backup.sh >> /home/ubuntu/backup-files/backup-logs.log 2>&1
```
**MAILTO** (requerido en crontabs) con esta variable podemos definir si queremos que nos llegue una notificación a nuestro correo cuando se ejecute nuestra tarea (Requiere una configuración adicional, lo deje vacio).

 ```
 # Estructura de un Crontab:
 # .---------------- minutos (0 - 59)
 # |  .------------- horas (0 - 23)
 # |  |  .---------- día del mes (1 - 31)
 # |  |  |  .------- mes (1 - 12) 
 # |  |  |  |  .---- día de la semana (0 - 6) (Sunday=0 or 7)
 # |  |  |  |  |
 # 59  23  *  *  *  Ejecuta nuestros comandos y almacenamos logs. De igual manera podemos visualizar estos logs con el comando  **grep CRON /var/log/syslog**
 ```
 Nuestro crontab se ejecutará todos los dias a las 23:59.












