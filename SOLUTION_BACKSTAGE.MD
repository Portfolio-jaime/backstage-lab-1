# Solución al problema de acceso al frontend de Backstage en devcontainer/Docker

## Problema
Al ejecutar `yarn start` en Backstage dentro de un devcontainer/Docker, el frontend (`localhost:3000`) no era accesible desde el navegador del host. El backend (`7007`) sí respondía, pero el frontend mostraba "Connection reset by peer" o "Connection refused".

## Causa
El servidor de desarrollo del frontend estaba escuchando solo en `localhost` dentro del contenedor, lo que impide el acceso externo aunque el puerto esté mapeado en Docker Compose.

## Solución
1. **Modificar el script de inicio del frontend**
   - Edita `backstage/packages/app/package.json`:
     ```json
     "start": "cross-env HOST=0.0.0.0 backstage-cli package start"
     ```
   - Esto fuerza al servidor a escuchar en todas las interfaces de red.

2. **Actualizar la configuración de la app**
   - Edita `backstage/app-config.yaml`:
     ```yaml
     app:
       baseUrl: http://0.0.0.0:3000
     ```
   - Esto asegura que la app use la URL correcta para el entorno de desarrollo.

3. **Reconstruir el devcontainer y reiniciar los servicios**
   - Reconstruye el devcontainer para aplicar los cambios.
   - Reinicia Backstage con `yarn start`.

4. **Verificar acceso desde el host**
   - Ejecuta en tu máquina host:
     ```bash
     curl -I http://localhost:3000
     ```
   - Deberías recibir un encabezado HTTP 200.

## Nota sobre autenticación guest
Si al abrir Backstage ves el mensaje:
> You are currently using the legacy guest token, but you have the new guest backend module installed. Do you want to use the new module?
Solo haz clic en "Yes" o "Aceptar". Esto migrará el sistema de autenticación guest al nuevo módulo recomendado por Backstage. No afecta el funcionamiento normal y es seguro aceptar la migración.

## Referencias
- [Backstage Docs](https://backstage.io/docs)
- [DevContainers](https://containers.dev/)
