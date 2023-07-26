//const baseURL = "http://10.0.2.2:8000/api/";
//const imageURL = "http://10.0.2.2:8000/storage/";

//------------------------------------------
const imageURL = "http://ec2-54-167-104-104.compute-1.amazonaws.com/storage/";

//const baseURL = "https://sigweb.fly.dev/api/"; 
// const baseURL = "http://192.168.0.11:3000/api/";
const baseURL = "https://laravel-production-14dc.up.railway.app/api/puntos/coordenadasbyId";  

const listURL = "https://laravel-production-14dc.up.railway.app/api/puntos/datosGral";


const allLineasURL = baseURL + 'all-lineas';
const unaLineaURL = baseURL + 'una-linea'; // anadir al service /:linea

const unaLugarURL = baseURL + 'una-linea'; // anadir al service /:linea

const allRecorridosURL = baseURL + 'all-recorridos';
const unRecorridoURL = baseURL + 'un-recorrido'; // anadir al service /:recorrido


const allPuntosURL = baseURL + 'all-puntos';
const puntosCodeURL = baseURL + 'puntos-code'; // anadir al service /:code


const allPuntosFinalURL = baseURL + 'all-puntosFinal';
const puntosFinalCodeURL = baseURL + 'puntosFinal-code'; // anadir al service /:code 



//---errors
const serverError = 'Error del servidor';
const unautorized = 'No autorizado';
const somethingWentWrong = '¡Algo salió mal, intenta de nuevo!';

//---headers
const Map<String, String> headers = {"Content-Type": "application/json"};
