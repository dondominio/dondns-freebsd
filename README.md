# Cliente DonDNS para FreeBSD

Basado en versión 0.9.1 de ***Borja Ruiz Castro (borja at libcrack.so)***

## Instalacion

Instalar curl via ports (opción 1)  

```
cd /usr/ports/ftp/curl && make intall clean
```

Instalar curl via pkg (opcion 2)  


```
pkg_add -vr curl
```

Crear un usuario en el sistema  

```
pw adduser dondomcli -d /nonexistent -s /usr/sbin/nologin
```

Instalar el cliente de DonDominio (DonDNS)  

  
```
cp dondomcli.tcsh /usr/local/bin/
chown dondomcli:dondomcli /usr/local/bin/dondomcli.tcsh
chmod 755 /usr/local/bin/dondomcli.tcsh
cp dondomcli.conf /usr/local/etc/
chown dondomcli:dondomcli /usr/local/etc/dondomcli.conf
chmod 600 /usr/local/etc/dondomcli.conf
```


## Configuracion

Edita /usr/local/etc/dondomcli.conf 
 
```
set DDUSER = "miusuario"
set DDPASSWORD = "miAPIkey"
set DDHOST = "misubdominio.midominio.com"
``` 

Añade un trabajo CRON para que se ejecute horariamente el script con el usuario dondomcli:

```
echo '0 * * * * dondomcli /usr/local/bin/dondomcli.tcsh -c /usr/local/etc/dondomcli.conf' >> /etc/crontab
echo >> /etc/crontab
```

