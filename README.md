# NetworkManager
SDK para llamada a servicios

:::::::::::::::::::::::::::::::: **Ejemplo de Implementación** ::::::::::::::::::::::::::::::::
**1)** Clonar el repositorio en una nueva carpeta llamada "NetworkManager" dentro del path del proyecto a implementar

**2)** Modificar Podfile de su proyecto con las siguiente línea
      _pod 'NetworkManagerSDK', :path => 'NetworkManager'_
      
**3)** Instalar los pods en su proyecto

**4)** Para hacer las peticiones en el Model, seguir el siguiente ejemplo:

_//Import del framework_
import NetworkManagerSDK

_//Instancia de la clase WebService_
var ws : WebService = WebService()

_//Consumir funciones con peticiones a servicios_
self.ws.getCharacters { response, error in
    if let _ = error {
        print("ERROR: \(error!.errorMessage) - (\(error!.error))")
    }else{
        print("Success WS")
    }
}
        
_//(Opcional) Implementación de notificación estatus de servicio_
self.ws.callbackServices = { response in
    if response.status == statusService.start{
        print("Mostrar Loader...")
    }else if response.status == statusService.finish{
        print("Ocultar Loader...")
    }
}

:::: **Author: Ignacio Hernandez Montes** ::::::::::::::::::::::::::::::::::::::::::::::::::


