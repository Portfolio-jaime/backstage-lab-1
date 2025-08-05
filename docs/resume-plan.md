# Plan para continuar - Gemini

**Contexto:**

Estábamos solucionando una serie de errores de configuración en la aplicación de Backstage.

1.  **Problema Inicial:** Error de "Failed to sign in as a guest".
2.  **Progreso:**
    *   Se modificaron `app-config.local.yaml` y `app-config.yaml` para habilitar correctamente la autenticación de invitado.
    *   Se actualizó `packages/app/src/apis.ts` para usar el nuevo sistema de autenticación del frontend.
3.  **Problema Actual:** La aplicación muestra un error en el navegador: `Plugin catalog tried to register duplicate or forbidden API factory for apiRef{plugin.catalog.service}`.
4.  **Diagnóstico:** El archivo `packages/app/src/App.tsx` está utilizando un patrón de configuración obsoleto que entra en conflicto con la forma en que se registran las APIs de los plugins.

**Siguiente Paso:**

Refactorizar el archivo `/Users/jaime.henao/arheanja/Backstage-solutions/backstage-lab-1/backstage/packages/app/src/App.tsx` para adoptar el enfoque moderno basado en `features` de Backstage.

**Acción a realizar:**

1.  Reemplazar el contenido de `App.tsx` para que utilice `createApp` con un arreglo de `features` (plugins).
2.  Esto eliminará la gestión manual de rutas (`<FlatRoutes>`) y la configuración de APIs en `apis.ts`, permitiendo que Backstage resuelva las dependencias automáticamente.
3.  Verificar que la aplicación se inicie correctamente sin errores de autenticación ni de registro de APIs.
